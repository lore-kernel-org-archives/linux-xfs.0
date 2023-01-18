Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6969EC38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjARWpa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjARWpQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:16 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036A663E31
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:15 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id q64so549130pjq.4
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gYOQjTECmcadPuWz4I3IFUdQ7vHbzGKE7RshOXSTHuM=;
        b=Irf0+3NBtxWHJpl/OGm4P3R9LXQjGPUa2u+At6yddTJCjBVyYuN9jTQPlrjNbfe2h2
         g/uOYOg3X4H6b6jrGVsgO2KEV5Nwqf7lhTFRrgZBvqNormr/UP1I+fyCSOEulj6TwVTM
         3l3a60+vhLUOJR9DwLq0qoIC+tjUIgPPURRDIYEh8RYTHvxPr8aD+nMDcBOPj1hSI46I
         fhB0PknV4TI3nuM8yl1nBHMha6+Jg1qW/yaAFON9my2bQySPO9nTq8ul5DClm3u7MTVe
         gADFwwQj3S0O8l5vhFWQux8NUnFCV2FMmiy64ZmeSjvEV/qaMIajkfXYzPSLt7aZD/sl
         Z8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYOQjTECmcadPuWz4I3IFUdQ7vHbzGKE7RshOXSTHuM=;
        b=Ku5sOIWp/8BV7aNayCd2bLBPbRkeghVHHgwhk8wGxyr5gWhiWECoPMPNMDYnJbQIrA
         JGpthcw7uSNQKzRtzAp7n8wEOFzTN5cSM8cr0TFbSF8UjwOFrPVHqHcb2mqqc80wiEgb
         Lx/QjH7m0hOP9GeXouBmbsmaC/5DZh/V37r5MOgRtk7oIQydHPN0uErzHHiKoX2zceP2
         EnM/89gl1KR8ASa0g25QPXsgL5Jw1qbp1TT+8oUXdEJ614qrpPJbuL0j9lJ7ZmEuLyqE
         SDAYoxxvaOlU031JJ6OdjAS4DVBiptp0XrsvKZ2pZQgBkU65jBP0a++wJ4rGMZISp4mR
         JqBQ==
X-Gm-Message-State: AFqh2koX3xbyBbNAkCqriq/wQyGf64LRev4LfzhXACl7RczG4zQhmSN2
        0zuXaYm+59cHHFJuhI2qUvybSnVn/tZWgtth
X-Google-Smtp-Source: AMrXdXvD5lc7+BsWHV/pW6ZhN0gqF3jQFIaN5B1XUvi7YT7VcBZ7oEPSOAKW5LHFWGSOKFBghrAHkg==
X-Received: by 2002:a17:902:7fc9:b0:194:84f2:c1ec with SMTP id t9-20020a1709027fc900b0019484f2c1ecmr9032672plb.21.1674081914540;
        Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090264d700b00192820d00d0sm23575065pli.120.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXh-ES
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FEM-1R
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 23/42] xfs: introduce xfs_alloc_vextent_exact_bno()
Date:   Thu, 19 Jan 2023 09:44:46 +1100
Message-Id: <20230118224505.1964941-24-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Two of the callers to xfs_alloc_vextent_this_ag() actually want
exact block number allocation, not anywhere-in-ag allocation. Split
this out from _this_ag() as a first class citizen so no external
extent allocation code needs to care about args->type anymore.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c     |  6 ++--
 fs/xfs/libxfs/xfs_alloc.c  | 65 ++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_alloc.h  | 13 ++++++--
 fs/xfs/libxfs/xfs_bmap.c   |  6 ++--
 fs/xfs/libxfs/xfs_ialloc.c |  6 ++--
 fs/xfs/scrub/repair.c      |  4 +--
 6 files changed, 73 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 053d77a283f7..86696a1c6891 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -888,7 +888,6 @@ xfs_ag_shrink_space(
 		.tp	= *tpp,
 		.mp	= mp,
 		.pag	= pag,
-		.type	= XFS_ALLOCTYPE_THIS_BNO,
 		.minlen = delta,
 		.maxlen = delta,
 		.oinfo	= XFS_RMAP_OINFO_SKIP_UPDATE,
@@ -920,8 +919,6 @@ xfs_ag_shrink_space(
 	if (delta >= aglen)
 		return -EINVAL;
 
-	args.fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, aglen - delta);
-
 	/*
 	 * Make sure that the last inode cluster cannot overlap with the new
 	 * end of the AG, even if it's sparse.
@@ -939,7 +936,8 @@ xfs_ag_shrink_space(
 		return error;
 
 	/* internal log shouldn't also show up in the free space btrees */
-	error = xfs_alloc_vextent_this_ag(&args);
+	error = xfs_alloc_vextent_exact_bno(&args,
+			XFS_AGB_TO_FSB(mp, pag->pag_agno, aglen - delta));
 	if (!error && args.agbno == NULLAGBLOCK)
 		error = -ENOSPC;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 485a73eab9d9..b810a94aad70 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3272,28 +3272,34 @@ xfs_alloc_vextent_set_fsbno(
  */
 int
 xfs_alloc_vextent_this_ag(
-	struct xfs_alloc_arg	*args)
+	struct xfs_alloc_arg	*args,
+	xfs_agnumber_t		agno)
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno = 0;
+	xfs_rfsblock_t		target = XFS_AGB_TO_FSB(mp, agno, 0);
 	int			error;
 
 	if (args->tp->t_highest_agno != NULLAGNUMBER)
 		minimum_agno = args->tp->t_highest_agno;
 
-	error = xfs_alloc_vextent_check_args(args, args->fsbno);
+	if (minimum_agno > agno) {
+		trace_xfs_alloc_vextent_skip_deadlock(args);
+		args->fsbno = NULLFSBLOCK;
+		return 0;
+	}
+
+	error = xfs_alloc_vextent_check_args(args, target);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
 		return error;
 	}
 
-	args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
-	if (minimum_agno > args->agno) {
-		trace_xfs_alloc_vextent_skip_deadlock(args);
-		args->fsbno = NULLFSBLOCK;
-		return 0;
-	}
+	args->agno = agno;
+	args->agbno = 0;
+	args->fsbno = target;
+	args->type = XFS_ALLOCTYPE_THIS_AG;
 
 	error = xfs_alloc_ag_vextent(args);
 	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
@@ -3450,7 +3456,7 @@ xfs_alloc_vextent_start_ag(
  * pass, so will not recurse into AGs lower than indicated by fsbno.
  */
 int
- xfs_alloc_vextent_first_ag(
+xfs_alloc_vextent_first_ag(
 	struct xfs_alloc_arg	*args,
 	xfs_rfsblock_t		target)
  {
@@ -3472,12 +3478,51 @@ int
 	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
 	args->type = XFS_ALLOCTYPE_THIS_AG;
 	args->fsbno = target;
-	error =  xfs_alloc_vextent_iterate_ags(args, minimum_agno,
+	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno,
 			start_agno, 0);
 	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
 	return error;
 }
 
+/*
+ * Allocate within a single AG only.
+ */
+int
+xfs_alloc_vextent_exact_bno(
+	struct xfs_alloc_arg	*args,
+	xfs_rfsblock_t		target)
+{
+	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		minimum_agno = 0;
+	int			error;
+
+	if (args->tp->t_highest_agno != NULLAGNUMBER)
+		minimum_agno = args->tp->t_highest_agno;
+
+	error = xfs_alloc_vextent_check_args(args, target);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
+		return error;
+	}
+
+	args->agno = XFS_FSB_TO_AGNO(mp, target);
+	if (minimum_agno > args->agno) {
+		trace_xfs_alloc_vextent_skip_deadlock(args);
+		return 0;
+	}
+
+	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
+	args->fsbno = target;
+	args->type = XFS_ALLOCTYPE_THIS_BNO;
+	error = xfs_alloc_ag_vextent(args);
+	if (error)
+		return error;
+
+	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
+	return 0;
+}
+
 /*
  * Allocate an extent as close to the target as possible. If there are not
  * viable candidates in the AG, then fail the allocation.
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index f38a2f8e20fb..106b4deb1110 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -114,10 +114,10 @@ xfs_alloc_log_agf(
 	uint32_t	fields);/* mask of fields to be logged (XFS_AGF_...) */
 
 /*
- * Allocate an extent in the specific AG defined by args->fsbno. If there is no
- * space in that AG, then the allocation will fail.
+ * Allocate an extent anywhere in the specific AG given. If there is no
+ * space matching the requirements in that AG, then the allocation will fail.
  */
-int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
+int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args, xfs_agnumber_t agno);
 
 /*
  * Allocate an extent as close to the target as possible. If there are not
@@ -126,6 +126,13 @@ int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
 int xfs_alloc_vextent_near_bno(struct xfs_alloc_arg *args,
 		xfs_rfsblock_t target);
 
+/*
+ * Allocate an extent exactly at the target given. If this is not possible
+ * then the allocation fails.
+ */
+int xfs_alloc_vextent_exact_bno(struct xfs_alloc_arg *args,
+		xfs_rfsblock_t target);
+
 /*
  * Best effort full filesystem allocation scan.
  *
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4446b035eed5..c9902df16e25 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3514,7 +3514,6 @@ xfs_bmap_btalloc_at_eof(
 		xfs_extlen_t	nextminlen = 0;
 
 		atype = args->type;
-		args->type = XFS_ALLOCTYPE_THIS_BNO;
 		args->alignment = 1;
 
 		/*
@@ -3532,8 +3531,8 @@ xfs_bmap_btalloc_at_eof(
 		else
 			args->minalignslop = 0;
 
-		args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, args->fsbno));
-		error = xfs_alloc_vextent_this_ag(args);
+		args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
+		error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
 		xfs_perag_put(args->pag);
 		if (error)
 			return error;
@@ -3546,7 +3545,6 @@ xfs_bmap_btalloc_at_eof(
 		 */
 		args->pag = NULL;
 		args->type = atype;
-		args->fsbno = ap->blkno;
 		args->alignment = stripe_align;
 		args->minlen = nextminlen;
 		args->minalignslop = 0;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index daa6f7055bba..d2525f0cc6cd 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -662,8 +662,6 @@ xfs_ialloc_ag_alloc(
 		goto sparse_alloc;
 	if (likely(newino != NULLAGINO &&
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
-		args.type = XFS_ALLOCTYPE_THIS_BNO;
 		args.prod = 1;
 
 		/*
@@ -684,7 +682,9 @@ xfs_ialloc_ag_alloc(
 
 		/* Allow space for the inode btree to split. */
 		args.minleft = igeo->inobt_maxlevels;
-		error = xfs_alloc_vextent_this_ag(&args);
+		error = xfs_alloc_vextent_exact_bno(&args,
+				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
+						args.agbno));
 		if (error)
 			return error;
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 5f4b50aac4bb..1b71174ec0d6 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -328,14 +328,12 @@ xrep_alloc_ag_block(
 	args.mp = sc->mp;
 	args.pag = sc->sa.pag;
 	args.oinfo = *oinfo;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, sc->sa.pag->pag_agno, 0);
 	args.minlen = 1;
 	args.maxlen = 1;
 	args.prod = 1;
-	args.type = XFS_ALLOCTYPE_THIS_AG;
 	args.resv = resv;
 
-	error = xfs_alloc_vextent_this_ag(&args);
+	error = xfs_alloc_vextent_this_ag(&args, sc->sa.pag->pag_agno);
 	if (error)
 		return error;
 	if (args.fsbno == NULLFSBLOCK)
-- 
2.39.0

