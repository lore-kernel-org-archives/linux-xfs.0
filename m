Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0J4TIfC179266 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 22:29:18 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 652481621768
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 20:31:35 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TtLK4PDqQ9xWX5Ra for <xfs@oss.sgi.com>;
	Tue, 18 Jan 2011 20:31:35 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PfPhm-0007Eo-Ef
	for xfs@oss.sgi.com; Wed, 19 Jan 2011 15:31:34 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PfPgJ-00044x-76
	for xfs@oss.sgi.com; Wed, 19 Jan 2011 15:30:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfs: limit extent length for allocation to AG size
Date: Wed, 19 Jan 2011 15:29:57 +1100
Message-Id: <1295411400-15614-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1295411400-15614-1-git-send-email-david@fromorbit.com>
References: <1295411400-15614-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_bmap.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 4111cd3..2ad1daf 100644
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
@@ -2573,7 +2573,14 @@ xfs_bmap_btalloc(
 	args.tp = ap->tp;
 	args.mp = mp;
 	args.fsbno = ap->rval;
-	args.maxlen = MIN(ap->alen, mp->m_sb.sb_agblocks);
+
+	/*
+	 * The requested extent can be larger than an AG, so trim the block
+	 * count back to the maximum sized extent in an AG. A typical empty AG
+	 * consumes 1 block for headers, 1 block for each btree root (3) and 4
+	 * blocks for the free list.
+	 */
+	args.maxlen = MIN(ap->alen, mp->m_sb.sb_agblocks - 8);
 	args.firstblock = ap->firstblock;
 	blen = 0;
 	if (nullfb) {
@@ -2621,7 +2628,7 @@ xfs_bmap_btalloc(
 			/*
 			 * Adjust for alignment
 			 */
-			if (blen > args.alignment && blen <= ap->alen)
+			if (blen > args.alignment && blen <= args.maxlen)
 				args.minlen = blen - args.alignment;
 			args.minalignslop = 0;
 		} else {
@@ -2640,7 +2647,7 @@ xfs_bmap_btalloc(
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
