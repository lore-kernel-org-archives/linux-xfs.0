Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7LGxGZa182191 for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 11:59:26 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54DD31507383
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 10:00:05 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 46ha0XRRMqkwN4aH for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2009 10:00:05 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/17] vfs: Remove syncing from generic_file_direct_write()
	and generic_file_buffered_write()
Date: Fri, 21 Aug 2009 18:59:47 +0200
Message-Id: <1250874001-15483-3-git-send-email-jack@suse.cz>
In-Reply-To: <1250874001-15483-1-git-send-email-jack@suse.cz>
References: <1250874001-15483-1-git-send-email-jack@suse.cz>
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
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Joel Becker <joel.becker@oracle.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, hch@lst.de, ocfs2-devel@oss.oracle.com

generic_file_direct_write() and generic_file_buffered_write() called
generic_osync_inode() if it was called on O_SYNC file or IS_SYNC inode. But
this is superfluous since generic_file_aio_write() does the syncing as well.
Also XFS and OCFS2 which call these functions directly handle syncing
themselves. So let's have a single place where syncing happens:
generic_file_aio_write().

We slightly change the behavior by syncing only the range of file to which the
write happened for buffered writes but that should be all that is required.

CC: ocfs2-devel@oss.oracle.com
CC: Joel Becker <joel.becker@oracle.com>
CC: Felix Blyakher <felixb@sgi.com>
CC: xfs@oss.sgi.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/filemap.c |   31 ++++---------------------------
 1 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 554a396..b523e42 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2187,20 +2187,7 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 		*ppos = end;
 	}
-
-	/*
-	 * Sync the fs metadata but not the minor inode changes and
-	 * of course not the data as we did direct DMA for the IO.
-	 * i_mutex is held, which protects generic_osync_inode() from
-	 * livelocking.  AIO O_DIRECT ops attempt to sync metadata here.
-	 */
 out:
-	if ((written >= 0 || written == -EIOCBQUEUED) &&
-	    ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
-		int err = generic_osync_inode(inode, mapping, OSYNC_METADATA);
-		if (err < 0)
-			written = err;
-	}
 	return written;
 }
 EXPORT_SYMBOL(generic_file_direct_write);
@@ -2332,8 +2319,6 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
-	const struct address_space_operations *a_ops = mapping->a_ops;
-	struct inode *inode = mapping->host;
 	ssize_t status;
 	struct iov_iter i;
 
@@ -2343,16 +2328,6 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 	if (likely(status >= 0)) {
 		written += status;
 		*ppos = pos + status;
-
-		/*
-		 * For now, when the user asks for O_SYNC, we'll actually give
-		 * O_DSYNC
-		 */
-		if (unlikely((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
-			if (!a_ops->writepage || !is_sync_kiocb(iocb))
-				status = generic_osync_inode(inode, mapping,
-						OSYNC_METADATA|OSYNC_DATA);
-		}
   	}
 	
 	/*
@@ -2514,7 +2489,8 @@ ssize_t generic_file_aio_write_nolock(struct kiocb *iocb,
 
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 
-	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
+	if ((ret > 0 || ret == -EIOCBQUEUED) &&
+	    ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		ssize_t err;
 
 		err = sync_page_range_nolock(inode, mapping, pos, ret);
@@ -2550,7 +2526,8 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 
-	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
+	if ((ret > 0 || ret == -EIOCBQUEUED) &&
+	    ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		ssize_t err;
 
 		err = sync_page_range(inode, mapping, pos, ret);
-- 
1.6.0.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
