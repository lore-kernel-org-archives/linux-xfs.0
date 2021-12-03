Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F77C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377757AbhLCAEw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:04:52 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:37879 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377751AbhLCAEv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:51 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 5AA23869D90
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:25 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00G1L6-50
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00BkiC-3y
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 25/36] xfs: combine __xfs_alloc_vextent_this_ag and  xfs_alloc_ag_vextent
Date:   Fri,  3 Dec 2021 11:01:00 +1100
Message-Id: <20211203000111.2800982-26-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61a95e55
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=1RbyEdk7UIs8VECVR1gA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

THere's a bit of a recursive conundrum around
xfs_alloc_ag_vextent(). We can't first call xfs_alloc_ag_vextent()
without preparing the AGFL for the allocation, and preparing the
AGFL call xfs_alloc_ag_vextent() to prepare the AGFL for the
allocation. This "double allocation" requirement is not really clear
from the current xfs_alloc_fix_freelist() calls that are sprinkled
through the allocation code.

It's not helped that xfs_alloc_ag_vextent() can actually allocate
from the AGFL itself, but there's special code to prevent AGFL prep
allocations from allocating from the free list it's trying to prep.
The naming is not clear (args->wasfromfl is true when allocated from
the free list, but the indication that we are allocating for the
free list is via (args->resv == XFS_AG_RESV_AGFL).

So, lets make this "allocation required for allocation" situation
clear by moving it all inside xfs_alloc_ag_vextent(). The freelist
allocation is a specific XFS_ALLOCTYPE_THIS_AG allocation, which
translated directly to xfs_alloc_ag_vextent_size() allocation.

This enables us to replace __xfs_alloc_vextent_this_ag() with a call
to xfs_alloc_ag_vextent(), and we drive the freelist fixing further
into the per-ag allocation algrothim.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 65 +++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9ff6772ee019..7082f77c38e9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1126,22 +1126,38 @@ xfs_alloc_ag_vextent_small(
  * and of the form k * prod + mod unless there's nothing that large.
  * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
  */
-STATIC int			/* error */
+static int
 xfs_alloc_ag_vextent(
-	xfs_alloc_arg_t	*args)	/* argument structure for allocation */
+	struct xfs_alloc_arg	*args)
 {
-	int		error=0;
+	struct xfs_mount	*mp = args->mp;
+	int			error = 0;
 
 	ASSERT(args->minlen > 0);
 	ASSERT(args->maxlen > 0);
 	ASSERT(args->minlen <= args->maxlen);
 	ASSERT(args->mod < args->prod);
 	ASSERT(args->alignment > 0);
+	ASSERT(args->resv != XFS_AG_RESV_AGFL);
+
+
+	error = xfs_alloc_fix_freelist(args, 0);
+	if (error) {
+		trace_xfs_alloc_vextent_nofix(args);
+		return error;
+	}
+	if (!args->agbp) {
+		/* cannot allocate in this AG at all */
+		trace_xfs_alloc_vextent_noagbp(args);
+		args->agbno = NULLAGBLOCK;
+		return 0;
+	}
+	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+	args->wasfromfl = 0;
 
 	/*
 	 * Branch to correct routine based on the type.
 	 */
-	args->wasfromfl = 0;
 	switch (args->type) {
 	case XFS_ALLOCTYPE_THIS_AG:
 		error = xfs_alloc_ag_vextent_size(args);
@@ -1162,7 +1178,6 @@ xfs_alloc_ag_vextent(
 
 	ASSERT(args->len >= args->minlen);
 	ASSERT(args->len <= args->maxlen);
-	ASSERT(!args->wasfromfl || args->resv != XFS_AG_RESV_AGFL);
 	ASSERT(args->agbno % args->alignment == 0);
 
 	/* if not file data, insert new block into the reverse map btree */
@@ -2707,7 +2722,7 @@ xfs_alloc_fix_freelist(
 		targs.resv = XFS_AG_RESV_AGFL;
 
 		/* Allocate as many blocks as possible at once. */
-		error = xfs_alloc_ag_vextent(&targs);
+		error = xfs_alloc_ag_vextent_size(&targs);
 		if (error)
 			goto out_agflbp_relse;
 
@@ -2721,6 +2736,18 @@ xfs_alloc_fix_freelist(
 				break;
 			goto out_agflbp_relse;
 		}
+
+		if (!xfs_rmap_should_skip_owner_update(&targs.oinfo)) {
+			error = xfs_rmap_alloc(tp, agbp, pag,
+				       targs.agbno, targs.len, &targs.oinfo);
+			if (error)
+				goto out_agflbp_relse;
+		}
+		error = xfs_alloc_update_counters(tp, agbp,
+						  -((long)(targs.len)));
+		if (error)
+			goto out_agflbp_relse;
+
 		/*
 		 * Put each allocated block on the list.
 		 */
@@ -3206,28 +3233,6 @@ xfs_alloc_vextent_set_fsbno(
 /*
  * Allocate within a single AG only.
  */
-static int
-__xfs_alloc_vextent_this_ag(
-	struct xfs_alloc_arg	*args)
-{
-	struct xfs_mount	*mp = args->mp;
-	int			error;
-
-	error = xfs_alloc_fix_freelist(args, 0);
-	if (error) {
-		trace_xfs_alloc_vextent_nofix(args);
-		return error;
-	}
-	if (!args->agbp) {
-		/* cannot allocate in this AG at all */
-		trace_xfs_alloc_vextent_noagbp(args);
-		args->agbno = NULLAGBLOCK;
-		return 0;
-	}
-	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
-	return xfs_alloc_ag_vextent(args);
-}
-
 static int
 xfs_alloc_vextent_this_ag(
 	struct xfs_alloc_arg	*args)
@@ -3244,7 +3249,7 @@ xfs_alloc_vextent_this_ag(
 
 	args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 	args->pag = xfs_perag_get(mp, args->agno);
-	error = __xfs_alloc_vextent_this_ag(args);
+	error = xfs_alloc_ag_vextent(args);
 	xfs_perag_put(args->pag);
 	if (error)
 		return error;
@@ -3288,7 +3293,7 @@ xfs_alloc_vextent_iterate_ags(
 	args->agno = start_agno;
 	for (;;) {
 		args->pag = xfs_perag_get(mp, args->agno);
-		error = __xfs_alloc_vextent_this_ag(args);
+		error = xfs_alloc_ag_vextent(args);
 		if (error || args->agbp)
 			break;
 
-- 
2.33.0

