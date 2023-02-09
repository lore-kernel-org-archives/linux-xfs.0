Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D7DC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjBIWSv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjBIWSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:39 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFC65A9C9
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:37 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id be8so4527208plb.7
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=REq2pF6sxL8DZMxc8MZRkkT5BzEsoU4EcNVieyN8kAs=;
        b=cYftBA8GSibpOU5KkpLOGPby4qxJ5qp1OGBqAitiCXEVZKBD6Yi81kjAC+uOVkuqgN
         vKLezPJib5VugBRz7BOu8ygqwgWJGunGVZlLJr6EsYVoRcTU8JM6/Y+xzRKM7R1qXw8L
         4LmXDe/UHPtixjL/oSxhsaA5gUONWkZgyFpNZ+ghZi7d2vKOvspOgBxfbvoYQUY2FPRm
         8pXSc8rfKqCFSv7NtmYczDStsJV+rLmY5FT2bFwlTZN6IN1EVjw8dMPsRAhzTnSssw1d
         AIirdnlNCs/6rxbNCHfgHtwj6Gg1LQV/LqqTNcLelA56E3XihBHfPelcL9BLdFOmqztB
         sz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=REq2pF6sxL8DZMxc8MZRkkT5BzEsoU4EcNVieyN8kAs=;
        b=iIUGrRjdfyB+f0heubrSn8c6pM6x6Yz3qLvA4KeSyEOj/PUlAbMN9bJZFfrBKjosZT
         nM2YGnn4/9jetV4pjcrzxRxsYcTN2SQ5X2ed081xniNIOL2FtU0bQFkw6JzAenO1gYa/
         HBVbtQiS3v1nrgCnGFnKRlUVqNRuI4Rk24oZVJm/WRfWgyAtv3XHDiqJq7ngDf4ruKC6
         sNekzw6wRisqfGiM1EpLbvbLkrRhIgBfNd6zoyOGiHdsz3pfk5z+A7DXbU028mGKOg1O
         K3mvLn2RSURxJQmMR8DHYa70XG/7qQLXzdTr4Vd0zYH+gw2RniJZoEUAKHwpwR2EjE+3
         bpLw==
X-Gm-Message-State: AO0yUKUCS4BEiyYT4WGHoxF5dTU9sBnMa6hmhe+tQaADW7HL893dwRQV
        U7q1OiPXyeNeEghZwOfk21l+hP7B2QWhQbCP
X-Google-Smtp-Source: AK7set9si+Ro8CbA7ZEO9KgvMdygPIf87vat9bm3R5V71u+R5ErNZLCOH5bxZS7IIiLzq9V1NwTNoQ==
X-Received: by 2002:a17:903:41ca:b0:199:28b9:789e with SMTP id u10-20020a17090341ca00b0019928b9789emr13842858ple.32.1675981117043;
        Thu, 09 Feb 2023 14:18:37 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id l5-20020a170902d34500b00188fc6766d6sm1987308plk.219.2023.02.09.14.18.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:36 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVQ-D3
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcNW-1H
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 20/42] xfs: use xfs_alloc_vextent_first_ag() where appropriate
Date:   Fri, 10 Feb 2023 09:18:03 +1100
Message-Id: <20230209221825.3722244-21-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Change obvious callers of single AG allocation to use
xfs_alloc_vextent_first_ag(). This gets rid of
XFS_ALLOCTYPE_FIRST_AG as the type used within
xfs_alloc_vextent_first_ag() during iteration is _THIS_AG. Hence we
can remove the setting of args->type from all the callers of
_first_ag() and remove the alloctype.

While doing this, pass the allocation target fsb as a parameter
rather than encoding it in args->fsbno. This starts the process
of making args->fsbno an output only variable rather than
input/output.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 33 ++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_alloc.h | 10 ++++++++--
 fs/xfs/libxfs/xfs_bmap.c  | 31 ++++++++++++++++---------------
 3 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7e4452c11421..bd77e645398b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3183,7 +3183,8 @@ xfs_alloc_read_agf(
  */
 static int
 xfs_alloc_vextent_check_args(
-	struct xfs_alloc_arg	*args)
+	struct xfs_alloc_arg	*args,
+	xfs_fsblock_t		target)
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_agblock_t		agsize;
@@ -3201,13 +3202,13 @@ xfs_alloc_vextent_check_args(
 		args->maxlen = agsize;
 	if (args->alignment == 0)
 		args->alignment = 1;
-	ASSERT(XFS_FSB_TO_AGNO(mp, args->fsbno) < mp->m_sb.sb_agcount);
-	ASSERT(XFS_FSB_TO_AGBNO(mp, args->fsbno) < agsize);
+	ASSERT(XFS_FSB_TO_AGNO(mp, target) < mp->m_sb.sb_agcount);
+	ASSERT(XFS_FSB_TO_AGBNO(mp, target) < agsize);
 	ASSERT(args->minlen <= args->maxlen);
 	ASSERT(args->minlen <= agsize);
 	ASSERT(args->mod < args->prod);
-	if (XFS_FSB_TO_AGNO(mp, args->fsbno) >= mp->m_sb.sb_agcount ||
-	    XFS_FSB_TO_AGBNO(mp, args->fsbno) >= agsize ||
+	if (XFS_FSB_TO_AGNO(mp, target) >= mp->m_sb.sb_agcount ||
+	    XFS_FSB_TO_AGBNO(mp, target) >= agsize ||
 	    args->minlen > args->maxlen || args->minlen > agsize ||
 	    args->mod >= args->prod) {
 		args->fsbno = NULLFSBLOCK;
@@ -3281,7 +3282,7 @@ xfs_alloc_vextent_this_ag(
 	if (args->tp->t_highest_agno != NULLAGNUMBER)
 		minimum_agno = args->tp->t_highest_agno;
 
-	error = xfs_alloc_vextent_check_args(args);
+	error = xfs_alloc_vextent_check_args(args, args->fsbno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3406,7 +3407,7 @@ xfs_alloc_vextent_start_ag(
 	bool			bump_rotor = false;
 	int			error;
 
-	error = xfs_alloc_vextent_check_args(args);
+	error = xfs_alloc_vextent_check_args(args, args->fsbno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3444,25 +3445,29 @@ xfs_alloc_vextent_start_ag(
  * filesystem attempting blocking allocation. This does not wrap or try a second
  * pass, so will not recurse into AGs lower than indicated by fsbno.
  */
-static int
+int
 xfs_alloc_vextent_first_ag(
 	struct xfs_alloc_arg	*args,
-	xfs_agnumber_t		minimum_agno)
-{
+	xfs_fsblock_t		target)
+ {
 	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		minimum_agno = 0;
 	xfs_agnumber_t		start_agno;
 	int			error;
 
-	error = xfs_alloc_vextent_check_args(args);
+	if (args->tp->t_highest_agno != NULLAGNUMBER)
+		minimum_agno = args->tp->t_highest_agno;
+
+	error = xfs_alloc_vextent_check_args(args, target);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
 		return error;
 	}
 
-	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, args->fsbno));
-
+	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
 	args->type = XFS_ALLOCTYPE_THIS_AG;
+	args->fsbno = target;
 	error =  xfs_alloc_vextent_iterate_ags(args, minimum_agno,
 			start_agno, 0);
 	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
@@ -3495,8 +3500,6 @@ xfs_alloc_vextent(
 		break;
 	case XFS_ALLOCTYPE_START_BNO:
 		return xfs_alloc_vextent_start_ag(args, minimum_agno);
-	case XFS_ALLOCTYPE_FIRST_AG:
-		return xfs_alloc_vextent_first_ag(args, minimum_agno);
 	default:
 		error = -EFSCORRUPTED;
 		ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 0a9ad6cd18e2..9be46f493340 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -19,7 +19,6 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
 /*
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
  */
-#define XFS_ALLOCTYPE_FIRST_AG	0x02	/* ... start at ag 0 */
 #define XFS_ALLOCTYPE_THIS_AG	0x08	/* anywhere in this a.g. */
 #define XFS_ALLOCTYPE_START_BNO	0x10	/* near this block else anywhere */
 #define XFS_ALLOCTYPE_NEAR_BNO	0x20	/* in this a.g. and near this block */
@@ -29,7 +28,6 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
 typedef unsigned int xfs_alloctype_t;
 
 #define XFS_ALLOC_TYPES \
-	{ XFS_ALLOCTYPE_FIRST_AG,	"FIRST_AG" }, \
 	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
 	{ XFS_ALLOCTYPE_START_BNO,	"START_BNO" }, \
 	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
@@ -130,6 +128,14 @@ xfs_alloc_vextent(
  */
 int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
 
+/*
+ * Iterate from the AG indicated from args->fsbno through to the end of the
+ * filesystem attempting blocking allocation. This is for use in last
+ * resort allocation attempts when everything else has failed.
+ */
+int xfs_alloc_vextent_first_ag(struct xfs_alloc_arg *args,
+		xfs_fsblock_t target);
+
 /*
  * Free an extent.
  */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a28d57b82396..efca40fea8f1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3248,13 +3248,6 @@ xfs_bmap_btalloc_filestreams(
 	int			notinit = 0;
 	int			error;
 
-	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
-		args->type = XFS_ALLOCTYPE_FIRST_AG;
-		args->total = ap->minlen;
-		args->minlen = ap->minlen;
-		return 0;
-	}
-
 	args->type = XFS_ALLOCTYPE_NEAR_BNO;
 	args->total = ap->total;
 
@@ -3462,9 +3455,7 @@ xfs_bmap_exact_minlen_extent_alloc(
 	 */
 	ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
 
-	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
-	args.type = XFS_ALLOCTYPE_FIRST_AG;
 	args.minlen = args.maxlen = ap->minlen;
 	args.total = ap->total;
 
@@ -3476,7 +3467,7 @@ xfs_bmap_exact_minlen_extent_alloc(
 	args.resv = XFS_AG_RESV_NONE;
 	args.datatype = ap->datatype;
 
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_first_ag(&args, ap->blkno);
 	if (error)
 		return error;
 
@@ -3623,10 +3614,21 @@ xfs_bmap_btalloc_best_length(
 	 * size to the largest space found.
 	 */
 	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-	    xfs_inode_is_filestream(ap->ip))
+	    xfs_inode_is_filestream(ap->ip)) {
+		/*
+		 * If there is very little free space before we start a
+		 * filestreams allocation, we're almost guaranteed to fail to
+		 * find an AG with enough contiguous free space to succeed, so
+		 * just go straight to the low space algorithm.
+		 */
+		if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
+			args->minlen = ap->minlen;
+			goto critically_low_space;
+		}
 		error = xfs_bmap_btalloc_filestreams(ap, args, &blen);
-	else
+	} else {
 		error = xfs_bmap_btalloc_select_lengths(ap, args, &blen);
+	}
 	if (error)
 		return error;
 
@@ -3673,10 +3675,9 @@ xfs_bmap_btalloc_best_length(
 	 * so they don't waste time on allocation modes that are unlikely to
 	 * succeed.
 	 */
-	args->fsbno = 0;
-	args->type = XFS_ALLOCTYPE_FIRST_AG;
+critically_low_space:
 	args->total = ap->minlen;
-	error = xfs_alloc_vextent(args);
+	error = xfs_alloc_vextent_first_ag(args, 0);
 	if (error)
 		return error;
 	ap->tp->t_flags |= XFS_TRANS_LOWMODE;
-- 
2.39.0

