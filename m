Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCA1C32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjARWsS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjARWsC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:48:02 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7408666CD6
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:56 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so102099pjl.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pElfy99eOEc0S2Pi7vIbPQFfCND9YbgO18hKOObwMIM=;
        b=hMrNR3JlHJL8MD5mo6rss2x5grCYrOvprU90bUBb08yPcxx1IERzVZqvLG+BwMZJyg
         8X7xQdLY6W/5TAewSvGCL02ySJA4AyoK6t6TyxbtScDuaM58ERS7ZCvU3Rp7MO4O8N3R
         7Uj2tnXUDVWgUPo6hpQqtNzEkWkgLIrBCHvk45kMC0HX9adI5GVMnjJYBeT0A2QO78WJ
         M19EuCQ0XyG/RDGmQSRXCznsy/UBvv7zjhpEFc7YCWROrt7VTCnAWeDhiqm5O7z8OkKN
         JvuRqMYNcpupKGsMEFn60jGwzrq68MUBwYklpbijj2VRkGbDcz0qR0aA8+bhly7bosiy
         d6Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pElfy99eOEc0S2Pi7vIbPQFfCND9YbgO18hKOObwMIM=;
        b=xsEgXIjNdclpon6J56M9C7kuXOZfyU2akt0i8R73+M/k+cSy6BDFHLsk7dD9i2Mi/y
         q0ZbT+yo89UD3hQL1LLEwxD08wNyitfo6WkX3CPwNr6hcIw1pgbiDut1MwcwBzhffBdq
         BcCeqQxo9RRuKmM8kfTTkZUUO7Z50KozSazbbxDCmxXvKykVmBo54Vd7KSRwxveUaWEd
         esyWcbG3DG0Un0VdzLcJETJkIuwL31lgMEd8QbS34895TaqPf7ElNntcyJsP7ZXes3yI
         PKyFDfXK7VnY/7SpbRlWwY6Ku/SKncdfuR0HrmTyIgiP99qBKK80pVdHZBFABFPcp6ms
         34Xw==
X-Gm-Message-State: AFqh2kroCinJJV3BIPi1hi3/JsfxnR3VvudPt50JcuzhEZB8opJOIUMG
        V5zF8F2rLYrt+r0nwZRoxyyPKokaN9fDg9U/
X-Google-Smtp-Source: AMrXdXs2MiyqAWdW5GoiXcYfVmiPykAwK6a2U1qr6+OaQQfLMUaLmtn3UEQz3gABDwBvYGaXSKHpmw==
X-Received: by 2002:a17:90a:f297:b0:228:cb86:1f76 with SMTP id fs23-20020a17090af29700b00228cb861f76mr8898978pjb.21.1674082075921;
        Wed, 18 Jan 2023 14:47:55 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id t1-20020a63d241000000b004c974bb9a4esm7119267pgi.83.2023.01.18.14.47.55
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:47:55 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXY-Bd
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FE7-1A
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 20/42] xfs: use xfs_alloc_vextent_first_ag() where appropriate
Date:   Thu, 19 Jan 2023 09:44:43 +1100
Message-Id: <20230118224505.1964941-21-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
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
 fs/xfs/libxfs/xfs_alloc.c | 35 +++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_alloc.h | 10 ++++++++--
 fs/xfs/libxfs/xfs_bmap.c  | 31 ++++++++++++++++---------------
 3 files changed, 43 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 28b79facf2e3..186ce3aee9e0 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3183,7 +3183,8 @@ xfs_alloc_read_agf(
  */
 static int
 xfs_alloc_vextent_check_args(
-	struct xfs_alloc_arg	*args)
+	struct xfs_alloc_arg	*args,
+	xfs_rfsblock_t		target)
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
-xfs_alloc_vextent_first_ag(
+int
+ xfs_alloc_vextent_first_ag(
 	struct xfs_alloc_arg	*args,
-	xfs_agnumber_t		minimum_agno)
-{
+	xfs_rfsblock_t		target)
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
index 0a9ad6cd18e2..73697dd3ca55 100644
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
+		xfs_rfsblock_t target);
+
 /*
  * Free an extent.
  */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cdf3b551ef7b..eb3dc8d5319b 100644
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

