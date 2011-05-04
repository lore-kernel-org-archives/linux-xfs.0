Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p44IuXTe088815 for <xfs@oss.sgi.com>; Wed, 4 May 2011 13:56:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78B6B1B83F3D
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 12:00:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id e7RIJ0vcEm8j9cAs for
	<xfs@oss.sgi.com>; Wed, 04 May 2011 12:00:11 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QHhIx-00023B-0N
	for xfs@oss.sgi.com; Wed, 04 May 2011 19:00:11 +0000
Message-Id: <20110504185513.136746538@bombadil.infradead.org>
Date: Wed, 04 May 2011 14:55:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] online discard support V3
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

Add support for discarding unused blocks at CIL commit time.  The first
patch is the guts of the implementation and relies and the resently
included improved busy extent tracking.  The second patch is an optimization
that helps a lot with performance, and the last two patches submit the
discard requests asynchronously to not stall the log I/O completions threads
and improve performance, but they currently trip over bugs in the block layer.

The performance with these patches is quite bad on the SATA SSDs I tested,
with up to 50% slowdowns on meta data intensive workloads, although ext4 is
much worse and btrfs is almost as bad as bad.  I've demonstrated a prototype
of a vectored discard at LSF that builds on the code subitted here and
only changes the internals of xfs_discard_extents, which brings the performance
back to acceptable levels.

For now my suggestion is to put patches 1 and 2 in to give people a chance
to play with online discard on XFS.  If the block layer issues get fixed
in time we can add patches 3 and 4 later in the 2.6.40 cycle, if not they
will still be needed once we get the proper vectored discard support that
I'm going to start working on soon.

And here's the block layer workaround for the discard merge bug:


Index: xfs/block/blk-core.c
===================================================================
--- xfs.orig/block/blk-core.c	2011-03-30 16:04:45.700659775 +0200
+++ xfs/block/blk-core.c	2011-03-30 16:04:59.775160021 +0200
@@ -1247,7 +1247,7 @@ static int __make_request(struct request
 	 */
 	blk_queue_bounce(q, &bio);
 
-	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
+	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA | REQ_DISCARD)) {
 		spin_lock_irq(q->queue_lock);
 		where = ELEVATOR_INSERT_FLUSH;
 		goto get_rq;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
