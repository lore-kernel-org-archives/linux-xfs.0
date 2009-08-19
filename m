Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JG4PIM216152 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:04:35 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 163B51BDBCAE
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 09:04:50 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id SXZOXCz8v8TbPc7M for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2009 09:04:50 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/17] vfs: Remove syncing from generic_file_direct_write()
	and generic_file_buffered_write()
Date: Wed, 19 Aug 2009 18:04:30 +0200
Message-Id: <1250697884-22288-4-git-send-email-jack@suse.cz>
In-Reply-To: <1250697884-22288-1-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>, Joel Becker <joel.becker@oracle.com>, xfs@oss.sgi.com, hch@infradead.org, ocfs2-devel@oss.oracle.com

generic_file_direct_write() and generic_file_buffered_write() called
generic_osync_inode() if it was called on O_SYNC file or IS_SYNC inode. But
this is superfluous since generic_file_aio_write() does the syncing as well.
Also XFS and OCFS2 which call these functions directly handle syncing
themselves. So let's have a single place where syncing happens:
generic_file_aio_write().

CC: ocfs2-devel@oss.oracle.com
CC: Joel Becker <joel.becker@oracle.com>
CC: Felix Blyakher <felixb@sgi.com>
CC: xfs@oss.sgi.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/filemap.c |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 554a396..3bee198 100644
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
-- 
1.6.0.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
