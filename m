Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55MWfsI133027 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 17:32:42 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id kTASYvdRMDajzKny (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 15:32:36 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH v2] xfs: Fix overallocation in xfs_buf_allocate_memory()
Date: Wed,  6 Jun 2012 00:32:26 +0200
Message-Id: <1338935546-3914-1-git-send-email-jack@suse.cz>
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
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, David Chinner <dchinner@redhat.com>

Commit de1cbee which removed b_file_offset in favor of b_bn introduced a bug
causing xfs_buf_allocate_memory() to overestimate the number of necessary
pages. The problem is that xfs_buf_alloc() sets b_bn to -1 and thus effectively
every buffer is straddling a page boundary which causes
xfs_buf_allocate_memory() to allocate two pages and use vmalloc() for access
which is unnecessary.

Dave says xfs_buf_alloc() doesn't need to set b_bn to -1 anymore since the
buffer is inserted into the cache only after being fully initialized now.
So just make xfs_buf_alloc() fill in proper block number from the beginning.

CC: David Chinner <dchinner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_buf.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 172d3cc..a4beb42 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -201,14 +201,7 @@ xfs_buf_alloc(
 	bp->b_length = numblks;
 	bp->b_io_length = numblks;
 	bp->b_flags = flags;
-
-	/*
-	 * We do not set the block number here in the buffer because we have not
-	 * finished initialising the buffer. We insert the buffer into the cache
-	 * in this state, so this ensures that we are unable to do IO on a
-	 * buffer that hasn't been fully initialised.
-	 */
-	bp->b_bn = XFS_BUF_DADDR_NULL;
+	bp->b_bn = blkno;
 	atomic_set(&bp->b_pin_count, 0);
 	init_waitqueue_head(&bp->b_waiters);
 
@@ -567,11 +560,6 @@ xfs_buf_get(
 	if (bp != new_bp)
 		xfs_buf_free(new_bp);
 
-	/*
-	 * Now we have a workable buffer, fill in the block number so
-	 * that we can do IO on it.
-	 */
-	bp->b_bn = blkno;
 	bp->b_io_length = bp->b_length;
 
 found:
@@ -772,7 +760,7 @@ xfs_buf_get_uncached(
 	int			error, i;
 	xfs_buf_t		*bp;
 
-	bp = xfs_buf_alloc(target, 0, numblks, 0);
+	bp = xfs_buf_alloc(target, XFS_BUF_DADDR_NULL, numblks, 0);
 	if (unlikely(bp == NULL))
 		goto fail;
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
