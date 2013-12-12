Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A99A7F6A
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:18:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3BC0030406A
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:18:58 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 8xyBxwPwp3dAgoJx (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 10:18:57 -0800 (PST)
Message-Id: <20131212181844.672949101@bombadil.infradead.org>
Date: Thu, 12 Dec 2013 10:15:01 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] splice: nest i_mutex outside pipe_lock
References: <20131212181459.994196463@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0002-splice-nest-i_mutex-outside-pipe_lock.patch
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

I can't find any obvious reason why we would want to nest i_mutex
inside the pipe lock, but two good reasons speak against it:

 - with i_mutex inside the pipe lock we have to unlock it every time we
   iterate to the next buffer, which prevents i_mutex from guaranteeing
   write atomicy similar to write(2), and also is ineffiecient for
   filesystems like ocfs2 that have additional cluster locking along
   i_mutex.
 - the ordering of pipe_lock outside i_mutex makes it very hard to
   share code with filesystems that have additional inode-wide locks
   that need to be taken in the right order with i_mutex.

In addition to changing the lock order this patch also removes the
useless I_MUTEX_CHILD annotations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ocfs2/file.c |   20 +++++++++++---------
 fs/splice.c     |    5 +++--
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a77ef6e..c68e111 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2461,6 +2461,12 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 			out->f_path.dentry->d_name.len,
 			out->f_path.dentry->d_name.name, len);
 
+	mutex_lock(&inode->i_mutex);
+	ret = ocfs2_rw_lock(inode, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_unlock_inode;
+	}
 	pipe_lock(pipe);
 
 	splice_from_pipe_begin(&sd);
@@ -2469,20 +2475,16 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 		if (ret <= 0)
 			break;
 
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
-		ret = ocfs2_rw_lock(inode, 1);
-		if (ret < 0)
-			mlog_errno(ret);
-		else {
-			ret = ocfs2_splice_to_file(pipe, out, &sd);
-			ocfs2_rw_unlock(inode, 1);
-		}
-		mutex_unlock(&inode->i_mutex);
+		ret = ocfs2_splice_to_file(pipe, out, &sd);
 	} while (ret > 0);
 	splice_from_pipe_end(pipe, &sd);
 
 	pipe_unlock(pipe);
 
+	ocfs2_rw_unlock(inode, 1);
+out_unlock_inode:
+	mutex_unlock(&inode->i_mutex);
+
 	if (sd.num_spliced)
 		ret = sd.num_spliced;
 
diff --git a/fs/splice.c b/fs/splice.c
index fcb459d..4fb6c1f 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1005,6 +1005,8 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 	};
 	ssize_t ret;
 
+	mutex_lock(&inode->i_mutex);
+
 	pipe_lock(pipe);
 
 	splice_from_pipe_begin(&sd);
@@ -1013,7 +1015,6 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		if (ret <= 0)
 			break;
 
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
 		ret = file_remove_suid(out);
 		if (!ret) {
 			ret = file_update_time(out);
@@ -1021,11 +1022,11 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 				ret = splice_from_pipe_feed(pipe, &sd,
 							    pipe_to_file);
 		}
-		mutex_unlock(&inode->i_mutex);
 	} while (ret > 0);
 	splice_from_pipe_end(pipe, &sd);
 
 	pipe_unlock(pipe);
+	mutex_unlock(&inode->i_mutex);
 
 	if (sd.num_spliced)
 		ret = sd.num_spliced;
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
