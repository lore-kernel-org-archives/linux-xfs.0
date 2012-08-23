Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52Vlu134493 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:31 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9ioAXMGseojTgVkg for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:11 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZQ-0003Dx-Kj
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZQ-0003bN-IM
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 003/102] xfs: defer AIO/DIO completions
Date: Thu, 23 Aug 2012 15:01:21 +1000
Message-Id: <1345698180-13612-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: c859cdd1da008b3825555be3242908088a3de366

We really shouldn't complete AIO or DIO requests until we have finished
the unwritten extent conversion and size update.  This means fsync never
has to pick up any ioends as all work has been completed when signalling
I/O completion.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   21 ++++++++-------------
 fs/xfs/linux-2.6/xfs_aops.h |    1 +
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 05df3a8..68ac1ce 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -122,6 +122,10 @@ xfs_destroy_ioend(
 		bh->b_end_io(bh, !ioend->io_error);
 	}
 
+	if (ioend->io_iocb) {
+		if (ioend->io_isasync)
+			aio_complete(ioend->io_iocb, ioend->io_result, 0);
+	}
 	xfs_ioend_wake(ip);
 	mempool_free(ioend, xfs_ioend_pool);
 }
@@ -235,8 +239,6 @@ xfs_end_io(
 		/* ensure we don't spin on blocked ioends */
 		delay(1);
 	} else {
-		if (ioend->io_iocb)
-			aio_complete(ioend->io_iocb, ioend->io_result, 0);
 		xfs_destroy_ioend(ioend);
 	}
 }
@@ -273,6 +275,7 @@ xfs_alloc_ioend(
 	 * all the I/O from calling the completion routine too early.
 	 */
 	atomic_set(&ioend->io_remaining, 1);
+	ioend->io_isasync = 0;
 	ioend->io_error = 0;
 	ioend->io_list = NULL;
 	ioend->io_type = type;
@@ -1309,21 +1312,13 @@ xfs_end_io_direct_write(
 
 	ioend->io_offset = offset;
 	ioend->io_size = size;
+	ioend->io_iocb = iocb;
+	ioend->io_result = ret;
 	if (private && size > 0)
 		ioend->io_type = IO_UNWRITTEN;
 
 	if (is_async) {
-		/*
-		 * If we are converting an unwritten extent we need to delay
-		 * the AIO completion until after the unwrittent extent
-		 * conversion has completed, otherwise do it ASAP.
-		 */
-		if (ioend->io_type == IO_UNWRITTEN) {
-			ioend->io_iocb = iocb;
-			ioend->io_result = ret;
-		} else {
-			aio_complete(iocb, ret, 0);
-		}
+		ioend->io_isasync = 1;
 		xfs_finish_ioend(ioend);
 	} else {
 		xfs_finish_ioend_sync(ioend);
diff --git a/fs/xfs/linux-2.6/xfs_aops.h b/fs/xfs/linux-2.6/xfs_aops.h
index 71f721e..ce3dcb5 100644
--- a/fs/xfs/linux-2.6/xfs_aops.h
+++ b/fs/xfs/linux-2.6/xfs_aops.h
@@ -47,6 +47,7 @@ typedef struct xfs_ioend {
 	unsigned int		io_type;	/* delalloc / unwritten */
 	int			io_error;	/* I/O error code */
 	atomic_t		io_remaining;	/* hold count */
+	unsigned int		io_isasync : 1;	/* needs aio_complete */
 	struct inode		*io_inode;	/* file being written to */
 	struct buffer_head	*io_buffer_head;/* buffer linked list head */
 	struct buffer_head	*io_buffer_tail;/* buffer linked list tail */
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
