Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 479977F69
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:18:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 361598F8064
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:18:57 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ARdBoY3snvmWtEvH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 10:18:56 -0800 (PST)
Message-Id: <20131212181844.848709380@bombadil.infradead.org>
Date: Thu, 12 Dec 2013 10:15:02 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/5] splice: use splice_from_pipe in generic_file_splice_write
References: <20131212181459.994196463@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0003-splice-use-splice_from_pipe-in-generic_file_splice_w.patch
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Reuse generic_write_sync instead of reimplementing it in the splice
write path both in the generic code and ocfs2.  Only needs a little
bit of refactoring for the actors to provide the desired functionality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ocfs2/file.c        |   58 ++++++++++-----------------------------------
 fs/splice.c            |   61 +++++++++++++++++-------------------------------
 include/linux/splice.h |    2 ++
 3 files changed, 36 insertions(+), 85 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index c68e111..5b1b5f9 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2423,38 +2423,14 @@ out_sems:
 	return ret;
 }
 
-static int ocfs2_splice_to_file(struct pipe_inode_info *pipe,
-				struct file *out,
-				struct splice_desc *sd)
-{
-	int ret;
-
-	ret = ocfs2_prepare_inode_for_write(out, &sd->pos,
-					    sd->total_len, 0, NULL, NULL);
-	if (ret < 0) {
-		mlog_errno(ret);
-		return ret;
-	}
-
-	return splice_from_pipe_feed(pipe, sd, pipe_to_file);
-}
-
 static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 				       struct file *out,
 				       loff_t *ppos,
 				       size_t len,
 				       unsigned int flags)
 {
-	int ret;
-	struct address_space *mapping = out->f_mapping;
-	struct inode *inode = mapping->host;
-	struct splice_desc sd = {
-		.total_len = len,
-		.flags = flags,
-		.pos = *ppos,
-		.u.file = out,
-	};
-
+	struct inode *inode = out->f_mapping->host;
+	ssize_t ret;
 
 	trace_ocfs2_file_splice_write(inode, out, out->f_path.dentry,
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -2467,35 +2443,25 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 		mlog_errno(ret);
 		goto out_unlock_inode;
 	}
-	pipe_lock(pipe);
 
-	splice_from_pipe_begin(&sd);
-	do {
-		ret = splice_from_pipe_next(pipe, &sd);
-		if (ret <= 0)
-			break;
-
-		ret = ocfs2_splice_to_file(pipe, out, &sd);
-	} while (ret > 0);
-	splice_from_pipe_end(pipe, &sd);
+	ret = ocfs2_prepare_inode_for_write(out, ppos, len, 0, NULL, NULL);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_unlock_rw;
+	}
 
-	pipe_unlock(pipe);
+	ret = splice_from_pipe(pipe, out, ppos, len, flags, __pipe_to_file);
 
+out_unlock_rw:
 	ocfs2_rw_unlock(inode, 1);
 out_unlock_inode:
 	mutex_unlock(&inode->i_mutex);
 
-	if (sd.num_spliced)
-		ret = sd.num_spliced;
-
 	if (ret > 0) {
-		int err;
-
-		err = generic_write_sync(out, *ppos, ret);
+		int err = generic_write_sync(out, *ppos, ret);
 		if (err)
-			ret = err;
-		else
-			*ppos += ret;
+			return ret;
+		*ppos += ret;
 	}
 
 	return ret;
diff --git a/fs/splice.c b/fs/splice.c
index 4fb6c1f..108e527 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -727,7 +727,7 @@ static int pipe_to_sendpage(struct pipe_inode_info *pipe,
  * SPLICE_F_MOVE isn't set, or we cannot move the page, we simply create
  * a new page in the output file page cache and fill/dirty that.
  */
-int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+int __pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 		 struct splice_desc *sd)
 {
 	struct file *file = sd->u.file;
@@ -766,6 +766,22 @@ int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 out:
 	return ret;
 }
+EXPORT_SYMBOL(__pipe_to_file);
+
+int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+		 struct splice_desc *sd)
+{
+	struct file *file = sd->u.file;
+	int ret;
+
+	ret = file_remove_suid(file);
+	if (ret)
+		return ret;
+	ret = file_update_time(file);
+	if (ret)
+		return ret;
+	return __pipe_to_file(pipe, buf, sd);
+}
 EXPORT_SYMBOL(pipe_to_file);
 
 static void wakeup_pipe_writers(struct pipe_inode_info *pipe)
@@ -995,55 +1011,22 @@ ssize_t
 generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 			  loff_t *ppos, size_t len, unsigned int flags)
 {
-	struct address_space *mapping = out->f_mapping;
-	struct inode *inode = mapping->host;
-	struct splice_desc sd = {
-		.total_len = len,
-		.flags = flags,
-		.pos = *ppos,
-		.u.file = out,
-	};
+	struct inode *inode = out->f_mapping->host;
 	ssize_t ret;
 
 	mutex_lock(&inode->i_mutex);
-
-	pipe_lock(pipe);
-
-	splice_from_pipe_begin(&sd);
-	do {
-		ret = splice_from_pipe_next(pipe, &sd);
-		if (ret <= 0)
-			break;
-
-		ret = file_remove_suid(out);
-		if (!ret) {
-			ret = file_update_time(out);
-			if (!ret)
-				ret = splice_from_pipe_feed(pipe, &sd,
-							    pipe_to_file);
-		}
-	} while (ret > 0);
-	splice_from_pipe_end(pipe, &sd);
-
-	pipe_unlock(pipe);
+	ret = splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_file);
 	mutex_unlock(&inode->i_mutex);
 
-	if (sd.num_spliced)
-		ret = sd.num_spliced;
-
 	if (ret > 0) {
-		int err;
-
-		err = generic_write_sync(out, *ppos, ret);
+		int err = generic_write_sync(out, *ppos, ret);
 		if (err)
-			ret = err;
-		else
-			*ppos += ret;
+			return err;
+		*ppos += ret;
 	}
 
 	return ret;
 }
-
 EXPORT_SYMBOL(generic_file_splice_write);
 
 static int write_pipe_buf(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 74575cb..c5aca88 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -78,6 +78,8 @@ extern void splice_from_pipe_end(struct pipe_inode_info *,
 				 struct splice_desc *);
 extern int pipe_to_file(struct pipe_inode_info *, struct pipe_buffer *,
 			struct splice_desc *);
+extern int __pipe_to_file(struct pipe_inode_info *, struct pipe_buffer *,
+			struct splice_desc *);
 
 extern ssize_t splice_to_pipe(struct pipe_inode_info *,
 			      struct splice_pipe_desc *);
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
