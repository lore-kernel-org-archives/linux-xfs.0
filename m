Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p786jl1Q019850 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 01:45:47 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03578535A04
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2011 23:45:46 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	giZImNF9JAfn7Jpp for <xfs@oss.sgi.com>;
	Sun, 07 Aug 2011 23:45:46 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] vfs: split generic splice code from i_mutex locking
Date: Mon,  8 Aug 2011 16:45:26 +1000
Message-Id: <1312785927-10662-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1312785927-10662-1-git-send-email-david@fromorbit.com>
References: <1312785927-10662-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

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
---
 fs/splice.c            |   58 ++++++++++++++++++++++++++++++++++++++----------
 include/linux/splice.h |    5 ++++
 2 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index fa2defa..a02dddc 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -967,24 +967,24 @@ ssize_t splice_from_pipe(struct pipe_inode_info *pipe, struct file *out,
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
@@ -1001,13 +1001,8 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		if (ret <= 0)
 			break;
 
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
-		ret = file_remove_suid(out);
-		if (!ret) {
-			file_update_time(out);
-			ret = splice_from_pipe_feed(pipe, &sd, pipe_to_file);
-		}
-		mutex_unlock(&inode->i_mutex);
+		ret = actor(pipe, &sd);
+
 	} while (ret > 0);
 	splice_from_pipe_end(pipe, &sd);
 
@@ -1032,7 +1027,46 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 
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
+		file_update_time(out);
+		ret = splice_from_pipe_feed(pipe, sd, pipe_to_file);
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
index 26e5b61..bd14281 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -61,6 +61,8 @@ typedef int (splice_actor)(struct pipe_inode_info *, struct pipe_buffer *,
 			   struct splice_desc *);
 typedef int (splice_direct_actor)(struct pipe_inode_info *,
 				  struct splice_desc *);
+typedef ssize_t (splice_write_actor)(struct pipe_inode_info *,
+				  struct splice_desc *);
 
 extern ssize_t splice_from_pipe(struct pipe_inode_info *, struct file *,
 				loff_t *, size_t, unsigned int,
@@ -82,6 +84,9 @@ extern ssize_t splice_to_pipe(struct pipe_inode_info *,
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 				      splice_direct_actor *);
 
+extern ssize_t splice_write_to_file(struct pipe_inode_info *, struct file *,
+				    loff_t *, size_t, unsigned int,
+				    splice_write_actor *);
 /*
  * for dynamic pipe sizing
  */
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
