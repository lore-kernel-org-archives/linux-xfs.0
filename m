Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B42FC6379F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjARWpX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjARWpQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:16 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6667460491
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id b17so560966pld.7
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=am6dRGIxBONTlNx8td89YADQ2kZ8jOcuNsD9gG75Rz8=;
        b=b79WuTIaViQsrn52rpyVA+AIMXxI3w2U7o8hFLCGuGmEspN1wm2P8OeOilsBZyXJ33
         R4RSGMa0EW5VIm3ONB1HoFqF1L8wuRqFt5iNMKLFzckACS9UyioGBSlNzPMAnWSeqQ5s
         My9JT78zgfl6XnfiVfHHrGLhaBqzDXKLmyhyRXzjiTXFbW2aTTlXG9kjDZ1bEONMhvF+
         XfhrPph7c3xwj4mv4FbcPVUQfbT5Ns6ki0HyQEaZ+jYucBEo0NrJ6LmSLkvwgp5GxzQH
         HJ1fBxvYJeXCTjdJp/i0+qyOj/xsp65Srq1DZyYr3EVFBEJx46ft8sIZ+DvrQ0HDbV4J
         xvmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=am6dRGIxBONTlNx8td89YADQ2kZ8jOcuNsD9gG75Rz8=;
        b=AtjPH3wDT2utttNN6FVc9WvmCh2j/w6L5W1YHdAD+xrvbwxLay9JVcl4z9tn0l5zHk
         zC55nqXsH6i7/spIWwRQXZtQoXAp+8+GI5N4Y9+B9ig7NEMDtbnoVtjWmHjfMciFj8VC
         shmbDwgkW14/6trye34+BLCmL3Jjf8zQoiHCIKUC7LHT3GfQIg8A0rEwOmRimbnfo15c
         L9ogNcS0WtSSlaAJPFGWyr5fsBuur1E1ULOGeW/rVwyUkOXQsW0YQsc5WDoamoHmZusp
         io6MKB2zzIUlcjYj/ODjF6Mv2SBtEo7Naf1rqPIsAfGZ4RMP0UAkD4npOB5Ikt5WOPF5
         LKxw==
X-Gm-Message-State: AFqh2kpF1JbPFIZYyDuYRkEcjbamD9uVKCissnfJ6Di1ZB9aioERQa9X
        5I5/sus5JCV3DrTB409YfMkTuI+1tepLh5ct
X-Google-Smtp-Source: AMrXdXv/GYnnQweD8JTEQ8XUapeEhzA4nRIIFQZ4iK9qp7vItlR3K6AnPMERUTv33KBCpT/9bk3i5Q==
X-Received: by 2002:a17:902:7144:b0:194:9e86:ffee with SMTP id u4-20020a170902714400b001949e86ffeemr7392137plm.44.1674081914173;
        Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id d8-20020a170903230800b001948107490csm8661518plh.19.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXc-CY
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FEC-1G
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 21/42] xfs: use xfs_alloc_vextent_start_bno() where appropriate
Date:   Thu, 19 Jan 2023 09:44:44 +1100
Message-Id: <20230118224505.1964941-22-david@fromorbit.com>
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
xfs_alloc_vextent_start_bno(). Callers no long need to specify
XFS_ALLOCTYPE_START_BNO, and so the type can be driven inward and
removed.

While doing this, also pass the allocation target fsb as a parameter
rather than encoding it in args->fsbno.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c      | 24 ++++++++++---------
 fs/xfs/libxfs/xfs_alloc.h      | 13 ++++++++--
 fs/xfs/libxfs/xfs_bmap.c       | 43 ++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_bmap_btree.c |  9 ++-----
 4 files changed, 51 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 186ce3aee9e0..294f80d596d9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3189,7 +3189,6 @@ xfs_alloc_vextent_check_args(
 	struct xfs_mount	*mp = args->mp;
 	xfs_agblock_t		agsize;
 
-	args->otype = args->type;
 	args->agbno = NULLAGBLOCK;
 
 	/*
@@ -3345,7 +3344,7 @@ xfs_alloc_vextent_iterate_ags(
 		trace_xfs_alloc_vextent_loopfailed(args);
 
 		if (args->agno == start_agno &&
-		    args->otype == XFS_ALLOCTYPE_START_BNO)
+		    args->otype == XFS_ALLOCTYPE_NEAR_BNO)
 			args->type = XFS_ALLOCTYPE_THIS_AG;
 
 		/*
@@ -3373,7 +3372,7 @@ xfs_alloc_vextent_iterate_ags(
 			}
 
 			flags = 0;
-			if (args->otype == XFS_ALLOCTYPE_START_BNO) {
+			if (args->otype == XFS_ALLOCTYPE_NEAR_BNO) {
 				args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
 				args->type = XFS_ALLOCTYPE_NEAR_BNO;
 			}
@@ -3396,18 +3395,22 @@ xfs_alloc_vextent_iterate_ags(
  * otherwise will wrap back to the start AG and run a second blocking pass to
  * the end of the filesystem.
  */
-static int
+int
 xfs_alloc_vextent_start_ag(
 	struct xfs_alloc_arg	*args,
-	xfs_agnumber_t		minimum_agno)
+	xfs_rfsblock_t		target)
 {
 	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		minimum_agno = 0;
 	xfs_agnumber_t		start_agno;
 	xfs_agnumber_t		rotorstep = xfs_rotorstep;
 	bool			bump_rotor = false;
 	int			error;
 
-	error = xfs_alloc_vextent_check_args(args, args->fsbno);
+	if (args->tp->t_highest_agno != NULLAGNUMBER)
+		minimum_agno = args->tp->t_highest_agno;
+
+	error = xfs_alloc_vextent_check_args(args, target);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3416,14 +3419,15 @@ xfs_alloc_vextent_start_ag(
 
 	if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
 	    xfs_is_inode32(mp)) {
-		args->fsbno = XFS_AGB_TO_FSB(mp,
+		target = XFS_AGB_TO_FSB(mp,
 				((mp->m_agfrotor / rotorstep) %
 				mp->m_sb.sb_agcount), 0);
 		bump_rotor = 1;
 	}
-	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, args->fsbno));
-	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
+	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
 	args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	args->fsbno = target;
 
 	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
 			XFS_ALLOC_FLAG_TRYLOCK);
@@ -3498,8 +3502,6 @@ xfs_alloc_vextent(
 		error = xfs_alloc_vextent_this_ag(args);
 		xfs_perag_put(args->pag);
 		break;
-	case XFS_ALLOCTYPE_START_BNO:
-		return xfs_alloc_vextent_start_ag(args, minimum_agno);
 	default:
 		error = -EFSCORRUPTED;
 		ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 73697dd3ca55..5487dff3d68a 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -20,7 +20,6 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
  */
 #define XFS_ALLOCTYPE_THIS_AG	0x08	/* anywhere in this a.g. */
-#define XFS_ALLOCTYPE_START_BNO	0x10	/* near this block else anywhere */
 #define XFS_ALLOCTYPE_NEAR_BNO	0x20	/* in this a.g. and near this block */
 #define XFS_ALLOCTYPE_THIS_BNO	0x40	/* at exactly this block */
 
@@ -29,7 +28,6 @@ typedef unsigned int xfs_alloctype_t;
 
 #define XFS_ALLOC_TYPES \
 	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
-	{ XFS_ALLOCTYPE_START_BNO,	"START_BNO" }, \
 	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
 	{ XFS_ALLOCTYPE_THIS_BNO,	"THIS_BNO" }
 
@@ -128,6 +126,17 @@ xfs_alloc_vextent(
  */
 int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
 
+/*
+ * Best effort full filesystem allocation scan.
+ *
+ * Locality aware allocation will be attempted in the initial AG, but on failure
+ * non-localised attempts will be made. The AGs are constrained by previous
+ * allocations in the current transaction. Two passes will be made - the first
+ * non-blocking, the second blocking.
+ */
+int xfs_alloc_vextent_start_ag(struct xfs_alloc_arg *args,
+		xfs_rfsblock_t target);
+
 /*
  * Iterate from the AG indicated from args->fsbno through to the end of the
  * filesystem attempting blocking allocation. This is for use in last
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index eb3dc8d5319b..aefcdf2bfd57 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -646,12 +646,11 @@ xfs_bmap_extents_to_btree(
 	args.mp = mp;
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
 
-	args.type = XFS_ALLOCTYPE_START_BNO;
-	args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = wasdel;
 	*logflagsp = 0;
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_start_ag(&args,
+				XFS_INO_TO_FSB(mp, ip->i_ino));
 	if (error)
 		goto out_root_realloc;
 
@@ -792,15 +791,15 @@ xfs_bmap_local_to_extents(
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
 	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
+
 	/*
 	 * Allocate a block.  We know we need only one, since the
 	 * file currently fits in an inode.
 	 */
-	args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
-	args.type = XFS_ALLOCTYPE_START_BNO;
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_start_ag(&args,
+			XFS_INO_TO_FSB(args.mp, ip->i_ino));
 	if (error)
 		goto done;
 
@@ -3208,7 +3207,6 @@ xfs_bmap_btalloc_select_lengths(
 	int			notinit = 0;
 	int			error = 0;
 
-	args->type = XFS_ALLOCTYPE_START_BNO;
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
 		args->total = ap->minlen;
 		args->minlen = ap->minlen;
@@ -3500,7 +3498,8 @@ xfs_bmap_btalloc_at_eof(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		blen,
-	int			stripe_align)
+	int			stripe_align,
+	bool			ag_only)
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_alloctype_t		atype;
@@ -3565,7 +3564,10 @@ xfs_bmap_btalloc_at_eof(
 		args->minalignslop = 0;
 	}
 
-	error = xfs_alloc_vextent(args);
+	if (ag_only)
+		error = xfs_alloc_vextent(args);
+	else
+		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error)
 		return error;
 
@@ -3591,13 +3593,17 @@ xfs_bmap_btalloc_best_length(
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_extlen_t		blen = 0;
+	bool			is_filestream = false;
 	int			error;
 
+	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+	    xfs_inode_is_filestream(ap->ip))
+		is_filestream = true;
+
 	/*
 	 * Determine the initial block number we will target for allocation.
 	 */
-	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-	    xfs_inode_is_filestream(ap->ip)) {
+	if (is_filestream) {
 		xfs_agnumber_t	agno = xfs_filestream_lookup_ag(ap->ip);
 		if (agno == NULLAGNUMBER)
 			agno = 0;
@@ -3613,8 +3619,7 @@ xfs_bmap_btalloc_best_length(
 	 * the request.  If one isn't found, then adjust the minimum allocation
 	 * size to the largest space found.
 	 */
-	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-	    xfs_inode_is_filestream(ap->ip)) {
+	if (is_filestream) {
 		/*
 		 * If there is very little free space before we start a
 		 * filestreams allocation, we're almost guaranteed to fail to
@@ -3639,14 +3644,18 @@ xfs_bmap_btalloc_best_length(
 	 * trying.
 	 */
 	if (ap->aeof && !(ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
-		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
+		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
+				is_filestream);
 		if (error)
 			return error;
 		if (args->fsbno != NULLFSBLOCK)
 			return 0;
 	}
 
-	error = xfs_alloc_vextent(args);
+	if (is_filestream)
+		error = xfs_alloc_vextent(args);
+	else
+		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error)
 		return error;
 	if (args->fsbno != NULLFSBLOCK)
@@ -3658,9 +3667,7 @@ xfs_bmap_btalloc_best_length(
 	 */
 	if (args->minlen > ap->minlen) {
 		args->minlen = ap->minlen;
-		args->type = XFS_ALLOCTYPE_START_BNO;
-		args->fsbno = ap->blkno;
-		error = xfs_alloc_vextent(args);
+		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index d42c1a1da1fc..b8ad95050c9b 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -214,9 +214,6 @@ xfs_bmbt_alloc_block(
 	if (!args.wasdel && args.tp->t_blk_res == 0)
 		return -ENOSPC;
 
-	args.fsbno = be64_to_cpu(start->l);
-	args.type = XFS_ALLOCTYPE_START_BNO;
-
 	/*
 	 * If we are coming here from something like unwritten extent
 	 * conversion, there has been no data extent allocation already done, so
@@ -227,7 +224,7 @@ xfs_bmbt_alloc_block(
 		args.minleft = xfs_bmapi_minleft(cur->bc_tp, cur->bc_ino.ip,
 					cur->bc_ino.whichfork);
 
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_start_ag(&args, be64_to_cpu(start->l));
 	if (error)
 		return error;
 
@@ -237,10 +234,8 @@ xfs_bmbt_alloc_block(
 		 * a full btree split.  Try again and if
 		 * successful activate the lowspace algorithm.
 		 */
-		args.fsbno = 0;
 		args.minleft = 0;
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		error = xfs_alloc_vextent(&args);
+		error = xfs_alloc_vextent_start_ag(&args, 0);
 		if (error)
 			return error;
 		cur->bc_tp->t_flags |= XFS_TRANS_LOWMODE;
-- 
2.39.0

