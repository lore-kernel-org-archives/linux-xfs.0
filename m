Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P8p5JT224567 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 02:51:05 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C5771DC15C8
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 00:53:27 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	DHpcILpViGr2eLeO for <xfs@oss.sgi.com>;
	Tue, 25 Jan 2011 00:53:27 -0800 (PST)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PheeI-0003xT-Rt
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 19:53:14 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Phebw-0007gQ-M9
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 19:50:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfs: limit extent length for allocation to AG size
Date: Tue, 25 Jan 2011 19:50:40 +1100
Message-Id: <1295945444-29488-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1295945444-29488-1-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Delayed allocation extents can be larger than AGs, so when trying to
convert a large range we may scan every AG inside
xfs_bmap_alloc_nullfb() trying to find an AG with a size larger than
an AG. We should stop when we find the first AG with a maximum
possible allocation size. This causes excessive CPU usage when there
are lots of AGs.

The same problem occurs when doing preallocation of a range larger
than an AG.

Fix the problem by limiting real allocation lengths to the maximum
that an AG can support. This means if we have empty AGs, we'll stop
the search at the first of them. If there are no empty AGs, we'll
still scan them all, but that is a different problem....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_alloc.h |   16 ++++++++++++++++
 fs/xfs/xfs_bmap.c  |   16 +++++++++-------
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index 0ab56b3..6ad45b9 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -75,6 +75,22 @@ typedef unsigned int xfs_alloctype_t;
 #define XFS_ALLOC_SET_ASIDE(mp)  (4 + ((mp)->m_sb.sb_agcount * 4))
 
 /*
+ * When deciding how much space to allocate out of an AG, we limit the
+ * allocation maximum size to the size the AG. However, we cannot use all the
+ * blocks in the AG - some are permanently used by metadata. These
+ * blocks are generally:
+ *	- the AG superblock, AGF, AGI and AGFL
+ *	- the AGF (bno and cnt) and AGI btree root blocks
+ *	- 4 blocks on the AGFL according to XFS_ALLOC_SET_ASIDE() limits
+ *
+ * The AG headers are sector sized, so the amount of space they take up is
+ * dependent on filesystem geometry. The others are all single blocks.
+ */
+#define XFS_ALLOC_AG_MAX_USABLE(mp)	\
+	((mp)->m_sb.sb_agblocks - XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)) + 7)
+
+
+/*
  * Argument structure for xfs_alloc routines.
  * This is turned into a structure to avoid having 20 arguments passed
  * down several levels of the stack.
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 4111cd3..74861c6 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2430,7 +2430,7 @@ xfs_bmap_btalloc_nullfb(
 		startag = ag = 0;
 
 	pag = xfs_perag_get(mp, ag);
-	while (*blen < ap->alen) {
+	while (*blen < args->maxlen) {
 		if (!pag->pagf_init) {
 			error = xfs_alloc_pagf_init(mp, args->tp, ag,
 						    XFS_ALLOC_FLAG_TRYLOCK);
@@ -2452,7 +2452,7 @@ xfs_bmap_btalloc_nullfb(
 			notinit = 1;
 
 		if (xfs_inode_is_filestream(ap->ip)) {
-			if (*blen >= ap->alen)
+			if (*blen >= args->maxlen)
 				break;
 
 			if (ap->userdata) {
@@ -2498,14 +2498,14 @@ xfs_bmap_btalloc_nullfb(
 	 * If the best seen length is less than the request
 	 * length, use the best as the minimum.
 	 */
-	else if (*blen < ap->alen)
+	else if (*blen < args->maxlen)
 		args->minlen = *blen;
 	/*
 	 * Otherwise we've seen an extent as big as alen,
 	 * use that as the minimum.
 	 */
 	else
-		args->minlen = ap->alen;
+		args->minlen = args->maxlen;
 
 	/*
 	 * set the failure fallback case to look in the selected
@@ -2573,7 +2573,9 @@ xfs_bmap_btalloc(
 	args.tp = ap->tp;
 	args.mp = mp;
 	args.fsbno = ap->rval;
-	args.maxlen = MIN(ap->alen, mp->m_sb.sb_agblocks);
+
+	/* Trim the allocation back to the maximum an AG can fit. */
+	args.maxlen = MIN(ap->alen, XFS_ALLOC_AG_MAX_USABLE(mp));
 	args.firstblock = ap->firstblock;
 	blen = 0;
 	if (nullfb) {
@@ -2621,7 +2623,7 @@ xfs_bmap_btalloc(
 			/*
 			 * Adjust for alignment
 			 */
-			if (blen > args.alignment && blen <= ap->alen)
+			if (blen > args.alignment && blen <= args.maxlen)
 				args.minlen = blen - args.alignment;
 			args.minalignslop = 0;
 		} else {
@@ -2640,7 +2642,7 @@ xfs_bmap_btalloc(
 			 * of minlen+alignment+slop doesn't go up
 			 * between the calls.
 			 */
-			if (blen > mp->m_dalign && blen <= ap->alen)
+			if (blen > mp->m_dalign && blen <= args.maxlen)
 				nextminlen = blen - mp->m_dalign;
 			else
 				nextminlen = args.minlen;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
