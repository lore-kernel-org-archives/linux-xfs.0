Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752452AbdFLMXu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 08:23:50 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v6 17/20] fs: add f_md_wb_err field to struct file for tracking metadata errors
Date: Mon, 12 Jun 2017 08:23:13 -0400
Message-Id: <20170612122316.13244-22-jlayton@redhat.com>
In-Reply-To: <20170612122316.13244-1-jlayton@redhat.com>
References: <20170612122316.13244-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

Some filesystems keep a different mapping for metadata writeback. Add a
second errseq_t to struct file for tracking metadata writeback errors.
Also add a new function for checking a mapping of the caller's choosing
vs. the f_md_wb_err value.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/fs.h             |  3 +++
 include/trace/events/filemap.h | 23 ++++++++++-------------
 mm/filemap.c                   | 40 +++++++++++++++++++++++++++++++---------
 3 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index ef3feeec80b2..e366835c93b3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -871,6 +871,7 @@ struct file {
 	struct list_head	f_tfile_llink;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
+	errseq_t		f_md_wb_err; /* optional metadata wb error tracking */
 } __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
 
 struct file_handle {
@@ -2525,6 +2526,8 @@ extern int filemap_fdatawrite_range(struct address_space *mapping,
 extern int filemap_check_errors(struct address_space *mapping);
 
 extern int __must_check filemap_report_wb_err(struct file *file);
+extern int __must_check filemap_report_md_wb_err(struct file *file,
+					struct address_space *mapping);
 extern void __filemap_set_wb_err(struct address_space *mapping, int err);
 
 /**
diff --git a/include/trace/events/filemap.h b/include/trace/events/filemap.h
index 2af66920f267..6e0d78c01a2e 100644
--- a/include/trace/events/filemap.h
+++ b/include/trace/events/filemap.h
@@ -79,12 +79,11 @@ TRACE_EVENT(filemap_set_wb_err,
 );
 
 TRACE_EVENT(filemap_report_wb_err,
-		TP_PROTO(struct file *file, errseq_t old),
+		TP_PROTO(struct address_space *mapping, errseq_t old, errseq_t new),
 
-		TP_ARGS(file, old),
+		TP_ARGS(mapping, old, new),
 
 		TP_STRUCT__entry(
-			__field(struct file *, file);
 			__field(unsigned long, i_ino)
 			__field(dev_t, s_dev)
 			__field(errseq_t, old)
@@ -92,20 +91,18 @@ TRACE_EVENT(filemap_report_wb_err,
 		),
 
 		TP_fast_assign(
-			__entry->file = file;
-			__entry->i_ino = file->f_mapping->host->i_ino;
-			if (file->f_mapping->host->i_sb)
-				__entry->s_dev = file->f_mapping->host->i_sb->s_dev;
+			__entry->i_ino = mapping->host->i_ino;
+			if (mapping->host->i_sb)
+				__entry->s_dev = mapping->host->i_sb->s_dev;
 			else
-				__entry->s_dev = file->f_mapping->host->i_rdev;
+				__entry->s_dev = mapping->host->i_rdev;
 			__entry->old = old;
-			__entry->new = file->f_wb_err;
+			__entry->new = new;
 		),
 
-		TP_printk("file=%p dev=%d:%d ino=0x%lx old=0x%x new=0x%x",
-			__entry->file, MAJOR(__entry->s_dev),
-			MINOR(__entry->s_dev), __entry->i_ino, __entry->old,
-			__entry->new)
+		TP_printk("dev=%d:%d ino=0x%lx old=0x%x new=0x%x",
+			MAJOR(__entry->s_dev), MINOR(__entry->s_dev),
+			__entry->i_ino, __entry->old, __entry->new)
 );
 #endif /* _TRACE_FILEMAP_H */
 
diff --git a/mm/filemap.c b/mm/filemap.c
index c5e19ea0bf12..ef0ff6b87759 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -564,27 +564,49 @@ EXPORT_SYMBOL(__filemap_set_wb_err);
  * value is protected by the f_lock since we must ensure that it reflects
  * the latest value swapped in for this file descriptor.
  */
-int filemap_report_wb_err(struct file *file)
+static int __filemap_report_wb_err(errseq_t *cursor, spinlock_t *lock,
+				struct address_space *mapping)
 {
 	int err = 0;
-	errseq_t old = READ_ONCE(file->f_wb_err);
-	struct address_space *mapping = file->f_mapping;
+	errseq_t old = READ_ONCE(*cursor);
 
 	/* Locklessly handle the common case where nothing has changed */
 	if (errseq_check(&mapping->wb_err, old)) {
 		/* Something changed, must use slow path */
-		spin_lock(&file->f_lock);
-		old = file->f_wb_err;
-		err = errseq_check_and_advance(&mapping->wb_err,
-						&file->f_wb_err);
-		trace_filemap_report_wb_err(file, old);
-		spin_unlock(&file->f_lock);
+		spin_lock(lock);
+		old = *cursor;
+		err = errseq_check_and_advance(&mapping->wb_err, cursor);
+		trace_filemap_report_wb_err(mapping, old, *cursor);
+		spin_unlock(lock);
 	}
 	return err;
 }
+EXPORT_SYMBOL(__filemap_report_wb_err);
+
+int filemap_report_wb_err(struct file *file)
+{
+	return __filemap_report_wb_err(&file->f_wb_err, &file->f_lock,
+					file->f_mapping);
+}
 EXPORT_SYMBOL(filemap_report_wb_err);
 
 /**
+ * filemap_report_md_wb_err - report wb error (if any) that was previously set
+ * @file: struct file on which the error is being reported
+ * @mapping: pointer to metadata mapping to check
+ *
+ * Many filesystems keep inode metadata in the pagecache, and will use the
+ * cache to write it back to the backing store. This function is for these
+ * callers to track metadata writeback.
+ */
+int filemap_report_md_wb_err(struct file *file, struct address_space *mapping)
+{
+	return __filemap_report_wb_err(&file->f_md_wb_err, &file->f_lock,
+					mapping);
+}
+EXPORT_SYMBOL(filemap_report_md_wb_err);
+
+/**
  * replace_page_cache_page - replace a pagecache page with a new one
  * @old:	page to be replaced
  * @new:	page to replace with
-- 
2.13.0

