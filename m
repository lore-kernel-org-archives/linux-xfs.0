Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6I44r5s079185 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 23:04:53 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACC2A1D88232
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 21:04:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	h4o5cttPTpUWP9kW for <xfs@oss.sgi.com>;
	Sun, 17 Jul 2011 21:04:51 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] vfs: split generic splice code from i_mutex locking
Date: Mon, 18 Jul 2011 14:04:43 +1000
Message-Id: <1310961884-11634-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1310961884-11634-1-git-send-email-david@fromorbit.com>
References: <1310961884-11634-1-git-send-email-david@fromorbit.com>
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

XFS holds locks that should be nested inside the inode->i_mutex when
generic_file_splice_write is called. This function takes the
i_mutex, and so we get a lock inversion that triggers lockdep
warnings and has been found to cause real deadlocks.

XFS does not need the splice code to take the i_mutex to do the page
cache manipulation, so add a new function
generic_file_splice_write_unlocked() that avoids the locking of the
i_mutex for XFS to call.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/splice.c        |   39 +++++++++++++++++++++++++++++++++++----
 include/linux/fs.h |    2 ++
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index aa866d3..c15137d 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -980,8 +980,9 @@ ssize_t splice_from_pipe(struct pipe_inode_info *pipe, struct file *out,
  *
  */
 ssize_t
-generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
-			  loff_t *ppos, size_t len, unsigned int flags)
+__generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
+			  loff_t *ppos, size_t len, unsigned int flags,
+			  int need_imutex)
 {
 	struct address_space *mapping = out->f_mapping;
 	struct inode *inode = mapping->host;
@@ -1001,13 +1002,15 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		if (ret <= 0)
 			break;
 
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
+		if (need_imutex)
+			mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
 		ret = file_remove_suid(out);
 		if (!ret) {
 			file_update_time(out);
 			ret = splice_from_pipe_feed(pipe, &sd, pipe_to_file);
 		}
-		mutex_unlock(&inode->i_mutex);
+		if (need_imutex)
+			mutex_unlock(&inode->i_mutex);
 	} while (ret > 0);
 	splice_from_pipe_end(pipe, &sd);
 
@@ -1033,8 +1036,36 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 	return ret;
 }
 
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
+	return __generic_file_splice_write(pipe, out, ppos, len, flags, 1);
+}
 EXPORT_SYMBOL(generic_file_splice_write);
 
+ssize_t
+generic_file_splice_write_unlocked(struct pipe_inode_info *pipe,
+				   struct file *out, loff_t *ppos,
+				   size_t len, unsigned int flags)
+{
+	return __generic_file_splice_write(pipe, out, ppos, len, flags, 0);
+}
+EXPORT_SYMBOL(generic_file_splice_write_unlocked);
+
 static int write_pipe_buf(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 			  struct splice_desc *sd)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 54c49e5..3a8b984 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2368,6 +2368,8 @@ extern ssize_t default_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
 extern ssize_t generic_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
+extern ssize_t generic_file_splice_write_unlocked(struct pipe_inode_info *,
+		struct file *, loff_t *, size_t, unsigned int);
 extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
 		struct file *out, loff_t *, size_t len, unsigned int flags);
 extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
