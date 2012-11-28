Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAS2B4tY122939 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 20:11:05 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ANQNAjZIRzsg1FIW for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 18:13:20 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] vfs: split generic splice code from i_mutex locking
Date: Wed, 28 Nov 2012 13:12:47 +1100
Message-Id: <1354068768-4316-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1354068768-4316-1-git-send-email-david@fromorbit.com>
References: <1354068768-4316-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

XFS holds locks that should be nested inside the inode->i_mutex when
generic_file_splice_write is called. This function takes the
i_mutex, and so we get a lock inversion that triggers lockdep
warnings and has been found to cause real deadlocks.

XFS does not need the splice code to take the i_mutex to do the page
cache manipulation, so modify the generic splice code to use an
actor function for the code that currently requires the i_mutex to
be taken.  Convert generic_file_splice_write() to use this new
interface supplying a generic actor function that performs the same
actions as the existing code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/splice.c            |   64 ++++++++++++++++++++++++++++++++++++------------
 include/linux/splice.h |    5 ++++
 2 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 13e5b47..66d4f24 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -970,24 +970,24 @@ ssize_t splice_from_pipe(struct pipe_inode_info *pipe, struct file *out,
 }
 
 /**
- * generic_file_splice_write - splice data from a pipe to a file
+ * splice_write_to_file - splice data from a pipe to a file
  * @pipe:	pipe info
  * @out:	file to write to
  * @ppos:	position in @out
  * @len:	number of bytes to splice
  * @flags:	splice modifier flags
+ * @actor:	worker that does the splicing from the pipe to the file
  *
  * Description:
  *    Will either move or copy pages (determined by @flags options) from
  *    the given pipe inode to the given file.
  *
  */
-ssize_t
-generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
-			  loff_t *ppos, size_t len, unsigned int flags)
+ssize_t splice_write_to_file(struct pipe_inode_info *pipe, struct file *out,
+			     loff_t *ppos, size_t len, unsigned int flags,
+			     splice_write_actor actor)
 {
 	struct address_space *mapping = out->f_mapping;
-	struct inode *inode = mapping->host;
 	struct splice_desc sd = {
 		.total_len = len,
 		.flags = flags,
@@ -996,7 +996,7 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 	};
 	ssize_t ret;
 
-	sb_start_write(inode->i_sb);
+	sb_start_write(mapping->host->i_sb);
 
 	pipe_lock(pipe);
 
@@ -1006,15 +1006,7 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		if (ret <= 0)
 			break;
 
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
-		ret = file_remove_suid(out);
-		if (!ret) {
-			ret = file_update_time(out);
-			if (!ret)
-				ret = splice_from_pipe_feed(pipe, &sd,
-							    pipe_to_file);
-		}
-		mutex_unlock(&inode->i_mutex);
+		ret = actor(pipe, &sd);
 	} while (ret > 0);
 	splice_from_pipe_end(pipe, &sd);
 
@@ -1036,11 +1028,51 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 			*ppos += ret;
 		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
 	}
-	sb_end_write(inode->i_sb);
+	sb_end_write(mapping->host->i_sb);
 
 	return ret;
 }
+EXPORT_SYMBOL(splice_write_to_file);
 
+static ssize_t generic_file_splice_write_actor(struct pipe_inode_info *pipe,
+					       struct splice_desc *sd)
+{
+	struct file *out = sd->u.file;
+	struct inode *inode = out->f_mapping->host;
+	ssize_t ret;
+
+	mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
+	ret = file_remove_suid(out);
+	if (!ret) {
+		ret = file_update_time(out);
+		if (!ret)
+			ret = splice_from_pipe_feed(pipe, sd, pipe_to_file);
+	}
+	mutex_unlock(&inode->i_mutex);
+
+	return ret;
+}
+
+/**
+ * generic_file_splice_write - splice data from a pipe to a file
+ * @pipe:	pipe info
+ * @out:	file to write to
+ * @ppos:	position in @out
+ * @len:	number of bytes to splice
+ * @flags:	splice modifier flags
+ *
+ * Description:
+ *    Will either move or copy pages (determined by @flags options) from
+ *    the given pipe inode to the given file.
+ *
+ */
+ssize_t
+generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
+			  loff_t *ppos, size_t len, unsigned int flags)
+{
+	return splice_write_to_file(pipe, out, ppos, len, flags,
+				    generic_file_splice_write_actor);
+}
 EXPORT_SYMBOL(generic_file_splice_write);
 
 static int write_pipe_buf(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 09a545a..44ce6f6b 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -62,6 +62,8 @@ typedef int (splice_actor)(struct pipe_inode_info *, struct pipe_buffer *,
 			   struct splice_desc *);
 typedef int (splice_direct_actor)(struct pipe_inode_info *,
 				  struct splice_desc *);
+typedef ssize_t (splice_write_actor)(struct pipe_inode_info *,
+				  struct splice_desc *);
 
 extern ssize_t splice_from_pipe(struct pipe_inode_info *, struct file *,
 				loff_t *, size_t, unsigned int,
@@ -83,6 +85,9 @@ extern ssize_t splice_to_pipe(struct pipe_inode_info *,
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 				      splice_direct_actor *);
 
+extern ssize_t splice_write_to_file(struct pipe_inode_info *, struct file *,
+				    loff_t *, size_t, unsigned int,
+				    splice_write_actor *);
 /*
  * for dynamic pipe sizing
  */
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
