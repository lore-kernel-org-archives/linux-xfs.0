Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 17:47:22 -0700 (PDT)
Received: from rgminet02.oracle.com (rgminet02.oracle.com [148.87.113.119])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2G0lE6p007973
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 17:47:15 -0700
Received: from rgminet01.oracle.com (rgminet01.oracle.com [148.87.113.118])
	by rgminet02.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l2FNlojo001027
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 17:47:50 -0600
Date: Thu, 15 Mar 2007 16:47:13 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: Announce: new-aops-1 for 2.6.21-rc3
Message-ID: <20070315234713.GH21942@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070315161704.GH8321@wotan.suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <20070315161704.GH8321@wotan.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>, reiserfs-list@namesys.com, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, nfs@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net

--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2007 at 05:17:04PM +0100, Nick Piggin wrote:
> (excludes the OCFS2 patch that Mark sent, in anticipation of an update)

Attached is said patch. I needed to export __grab_cache_page (ext2/ext3 also
need this if they're to be built as modules), so a patch to do that is also
attached.

This passed some preliminary testing on a two node cluster I have here at
Oracle.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-ocfs2-Convert-to-new-aops.txt"

From: Mark Fasheh <mark.fasheh@oracle.com>

ocfs2: Convert to new aops

Turn ocfs2_prepare_write() and ocfs2_commit_write() into ocfs2_write_begin()
and ocfs2_write_end(). This conveniently eliminates the need for
AOP_TRUNCATED_PAGE during write.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>


e28911070b02362a9a3a543646da84a8fbf9f63b
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 875c114..cbec0e1 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -293,29 +293,67 @@ int ocfs2_prepare_write_nolock(struct in
 }
 
 /*
- * ocfs2_prepare_write() can be an outer-most ocfs2 call when it is called
- * from loopback.  It must be able to perform its own locking around
- * ocfs2_get_block().
+ * ocfs2_write_begin() can be an outer-most ocfs2 call when it is
+ * called from elsewhere in the kernel. It must be able to perform its
+ * own locking around ocfs2_get_block().
  */
-static int ocfs2_prepare_write(struct file *file, struct page *page,
-			       unsigned from, unsigned to)
+static int ocfs2_write_begin(struct file *file, struct address_space *mapping,
+			     loff_t pos, unsigned len, unsigned flags,
+			     struct page **pagep, void **fsdata)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = mapping->host;
+	struct buffer_head *di_bh = NULL;
+	struct page *page = NULL;
 	int ret;
 
-	mlog_entry("(0x%p, 0x%p, %u, %u)\n", file, page, from, to);
-
-	ret = ocfs2_meta_lock_with_page(inode, NULL, 0, page);
+	ret = ocfs2_meta_lock(inode, &di_bh, 1);
 	if (ret != 0) {
 		mlog_errno(ret);
+		return ret;
+	}
+
+	ret = ocfs2_data_lock(inode, 1);
+	if (ret) {
+		ocfs2_meta_unlock(inode, 1);
+
+		mlog_errno(ret);
+		return ret;
+	}
+
+	/*
+	 * Lock the page out here to preserve ordering with
+	 * ip_alloc_sem.
+	 */
+	page = __grab_cache_page(mapping, pos >> PAGE_CACHE_SHIFT);
+	if (!page) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_prepare_write_nolock(inode, page, from, to);
+	*pagep = page;
 
-	ocfs2_meta_unlock(inode, 0);
+	down_read(&OCFS2_I(inode)->ip_alloc_sem);
+	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				ocfs2_get_block);
+	up_read(&OCFS2_I(inode)->ip_alloc_sem);
 out:
-	mlog_exit(ret);
+	if (ret == 0) {
+		*fsdata = di_bh;
+	} else {
+		/*
+		 * Error return - the caller won't call
+		 * ocfs2_write_end, so drop cluster locks here.
+		 */
+		brelse(di_bh);
+		if (page) {
+			unlock_page(page);
+			page_cache_release(page);
+		}
+		ocfs2_data_unlock(inode, 1);
+		ocfs2_meta_unlock(inode, 1);
+	}
+
 	return ret;
 }
 
@@ -388,16 +426,18 @@ out:
 	return handle;
 }
 
-static int ocfs2_commit_write(struct file *file, struct page *page,
-			      unsigned from, unsigned to)
+static int ocfs2_write_end(struct file *file, struct address_space *mapping,
+			   loff_t pos, unsigned len, unsigned copied,
+			   struct page *page, void *fsdata)
 {
 	int ret;
-	struct buffer_head *di_bh = NULL;
+	unsigned from, to;
+	struct buffer_head *di_bh = fsdata;
 	struct inode *inode = page->mapping->host;
 	handle_t *handle = NULL;
 	struct ocfs2_dinode *di;
 
-	mlog_entry("(0x%p, 0x%p, %u, %u)\n", file, page, from, to);
+	mlog_entry("(0x%p, 0x%p)\n", file, page);
 
 	/* NOTE: ocfs2_file_aio_write has ensured that it's safe for
 	 * us to continue here without rechecking the I/O against
@@ -412,22 +452,13 @@ static int ocfs2_commit_write(struct fil
 	 *    stale inode allocation image (i_size, i_clusters, etc).
 	 */
 
-	ret = ocfs2_meta_lock_with_page(inode, &di_bh, 1, page);
-	if (ret != 0) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ret = ocfs2_data_lock_with_page(inode, 1, page);
-	if (ret != 0) {
-		mlog_errno(ret);
-		goto out_unlock_meta;
-	}
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
 
 	handle = ocfs2_start_walk_page_trans(inode, page, from, to);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
-		goto out_unlock_data;
+		goto out_unlock;
 	}
 
 	/* Mark our buffer early. We'd rather catch this error up here
@@ -441,8 +472,10 @@ static int ocfs2_commit_write(struct fil
 	}
 
 	/* might update i_size */
-	ret = generic_commit_write(file, page, from, to);
-	if (ret < 0) {
+	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+	if (copied < 0) {
+		ret = copied;
+		copied = 0;
 		mlog_errno(ret);
 		goto out_commit;
 	}
@@ -458,23 +491,30 @@ static int ocfs2_commit_write(struct fil
 	di->i_size = cpu_to_le64((u64)i_size_read(inode));
 
 	ret = ocfs2_journal_dirty(handle, di_bh);
-	if (ret < 0) {
+	if (ret < 0)
 		mlog_errno(ret);
-		goto out_commit;
-	}
 
+	ret = 0;
 out_commit:
 	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
-out_unlock_data:
+out_unlock:
 	ocfs2_data_unlock(inode, 1);
-out_unlock_meta:
 	ocfs2_meta_unlock(inode, 1);
-out:
+
+	if (ret) {
+		/*
+		 * We caught an error before block_write_end() -
+		 * unlock and free the page.
+		 */
+		unlock_page(page);
+		page_cache_release(page);
+	}
+
 	if (di_bh)
 		brelse(di_bh);
 
 	mlog_exit(ret);
-	return ret;
+	return copied ? copied : ret;
 }
 
 static sector_t ocfs2_bmap(struct address_space *mapping, sector_t block)
@@ -678,8 +718,8 @@ out:
 const struct address_space_operations ocfs2_aops = {
 	.readpage	= ocfs2_readpage,
 	.writepage	= ocfs2_writepage,
-	.prepare_write	= ocfs2_prepare_write,
-	.commit_write	= ocfs2_commit_write,
+	.write_begin	= ocfs2_write_begin,
+	.write_end	= ocfs2_write_end,
 	.bmap		= ocfs2_bmap,
 	.sync_page	= block_sync_page,
 	.direct_IO	= ocfs2_direct_IO,
-- 
1.3.3


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-Export-__grab_cache_page.txt"

From: Mark Fasheh <mark.fasheh@oracle.com>

[PATCH] Export __grab_cache_page

Needed at least by ocfs2 and ext[23].

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>


ec4c66f0e6012a182105405aa11813fbf836629f
diff --git a/mm/filemap.c b/mm/filemap.c
index 327c20f..c4a2d68 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2196,6 +2196,7 @@ repeat:
 	}
 	return page;
 }
+EXPORT_SYMBOL(__grab_cache_page);
 
 static ssize_t generic_perform_write_2copy(struct file *file,
 				struct iov_iter *i, loff_t pos)
-- 
1.3.3


--QKdGvSO+nmPlgiQ/--
