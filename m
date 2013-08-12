Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F40317F5A
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D47288F8054
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:45 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	FKEh6Gv88wN25ZAt for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:44 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xk-PE
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007Lp-O4
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 04/17] xfs: optimise background inode
	chunk allocation
Date: Mon, 12 Aug 2013 23:19:54 +1000
Message-Id: <1376313607-28133-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1376313607-28133-1-git-send-email-david@fromorbit.com>
References: <1376313607-28133-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that physical inode allocation is being done in the background and separated
from the high level free inode allocation operations, we can start to optimise
the way we allocate physical inode chunks based on observation of inode chunk
allocation requirements.

To start with, we need to determine the approximate rate at which we are
allocating inode chunks. This will tell us how many inode chunks we should
allocate at a time to try to minimise the amount of time free inode allocation
stalls waiting for chunk allocation to occur. Ideally we want to allocate in
large enough chunks that we rarely block free inode allocation.

Assuming a typical inode allocation rate of approximately 20,000 per second per
CPU (~2GHz Xeon CPUs run at around this rate), then we are allocating roughly
300 inode chunks per second. We can assume that this is the rate at which we can
allocate from a single AG, as inode allocation within an AG is single threaded.
Hence trying to keep a "chunks allocated per second" measure probably has
sufficient resolution to provide a stable rate which we can use to allocate an
appropriate number of chunks ahead of time.

This would also allow us to determine a low watermark at which the inode
allocation ticket subsystem can use to kick chunk allocation before we run out
of inodes and force free inode allocation to block.

Once we have a determined rate, we can use that to allocate a number of inode
chunks in a single execution of the worker. Ideally, we want the worker to
allocate enough inode chunks so that it only needs to run a couple of times a
second, and to be able to do this allocation in a manner that results in
large contiguous regions of inode chunks.

For v4 superblocks, just iterate the existing inode chunk allocation transaction
to allocate a chunk at a time. For v5 superblocks, we have the logical inode
create transaction which allows us to initialise an arbitrary number of inode
chunks at a time.

The limit of chunks we can support right now with the current transaction
reservation is the maximum number of sequential records we can insert into the
inode btree while guaranteeing only a single leaf to root split will occur. This
will probably require a special new btree operation for a bulk record insert
with a single index path update once the split and insert is done. This is
probably sufficiently complex that it will require a series of several patches
to do.

Once we can allocate multiple inode chunks in a single operation, we can
optimise inode chunk layout for stripe unit/width extremely well. i.e. we should
allocate a fully aligned stripe unit at a time, and potentially larger if
allowed by the limits of a bulk record insert.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ag.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 317aa86..eb25689 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -249,6 +249,8 @@ typedef struct xfs_perag {
 	xfs_agino_t	pagi_freecount;	/* number of free inodes */
 	xfs_agino_t	pagi_count;	/* number of allocated inodes */
 
+	int		pagi_chunk_alloc_rate;
+
 	/*
 	 * Inode allocation search lookup optimisation.
 	 * If the pagino matches, the search for new inodes
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
