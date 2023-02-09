Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D12BC6379F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjBIWSw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjBIWSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:40 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA99568AC9
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:37 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id o8so2160973pls.11
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SmVIC3OJ11uJZvyqvgeTuBOTXl3n0LSEhi2IvSm1+TI=;
        b=TuFeTpVj8blS6GiEqGxrlATcWE9Cvubrv17NbjYnHokLJvQvEIgj0VcmvZIibHx1+t
         QmJyBdrnMXGZzoSYXQx3w0SvLIRPDwTmiQi/h82AgAxglRuY78NU5ta4Ht7xNrl4j8ab
         jWvJkPrRtuuZdkbXX11aGCd/5ya/SHanmxbw5R7027spspFYvf/q8N+0aRDgYx8MPz4g
         WlomBqF4fO3etnBI2rzXUQMJJYntsNIrCg3xCU50SzNEGUbcfgqFVeQB0QFPV4TbP7ei
         aWHapMdQhRY4xt4BuGy7DWiq9VrCKDEqQrEcduVl03rWZLERPxwg9EEuNFsKHByvazYI
         GlLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SmVIC3OJ11uJZvyqvgeTuBOTXl3n0LSEhi2IvSm1+TI=;
        b=DrDNMXmF9Rw8oSAmisinH9o44NuU+uzzOQKRVHrzpbSFz6HcCqj2gJ6GpNhsDwM2S7
         q1q065YyZqehWrDIORw7L5r/IwcayAPNGnMYEzeH+SdaGhp4/JruPw3Ff8eoQ+Oexl/f
         kDh6NFQtRBKGgIkXjrdWMX/RHNwJe+EpBkGlXblonFjQEK3OTuLKjeXFkvRqV8aQKscn
         Oe7Mn08YxnKRY0ea9BIBI8wdJb5K7vzOv9bWItQ6ZZyVhujVQLS6bTCH4XZLZ6F17+uu
         kyDHv2O75tP/8KPaQ/q88SSjpv2gIDXQc+R3b2on+GGPSOjQ8u4iI7BfusgK2/Niws1j
         xjjQ==
X-Gm-Message-State: AO0yUKW+DC5/bH0iVjAx3AjVzfvpQM6U2Uj13EQ7zq9BOJv6z7eyAfIG
        kKBeLNre931qesqBHQifIG+BecTtpSXOsWgF
X-Google-Smtp-Source: AK7set+4sdibKzczVHJ20+7PEUlszjwkNIMLRaGs7cIgsZ9MLrXc6ssULscQ9GXPnboyFNN3MT8liA==
X-Received: by 2002:a17:903:1cb:b0:199:4fcc:b36c with SMTP id e11-20020a17090301cb00b001994fccb36cmr7821279plh.54.1675981117313;
        Thu, 09 Feb 2023 14:18:37 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id w13-20020a1709029a8d00b00194c2f78581sm1994381plp.199.2023.02.09.14.18.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:36 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVM-BD
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcNM-15
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 18/42] xfs: use xfs_alloc_vextent_this_ag() where appropriate
Date:   Fri, 10 Feb 2023 09:18:01 +1100
Message-Id: <20230209221825.3722244-19-david@fromorbit.com>
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
xfs_alloc_vextent_this_ag(). Drive the per-ag grabbing out to the
callers, too, so that callers with active references don't need
to do new lookups just for an allocation in a context that already
has a perag reference.

The only remaining caller that does single AG allocation through
xfs_alloc_vextent() is xfs_bmap_btalloc() with
XFS_ALLOCTYPE_NEAR_BNO. That is going to need more untangling before
it can be converted cleanly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c             |  3 +-
 fs/xfs/libxfs/xfs_alloc.c          | 26 ++++++++-------
 fs/xfs/libxfs/xfs_alloc.h          |  6 ++++
 fs/xfs/libxfs/xfs_bmap.c           | 52 +++++++++++++++++-------------
 fs/xfs/libxfs/xfs_bmap_btree.c     | 22 ++++++-------
 fs/xfs/libxfs/xfs_ialloc.c         |  9 ++++--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  3 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  3 +-
 fs/xfs/scrub/repair.c              |  3 +-
 9 files changed, 74 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index a3bdcde95845..053d77a283f7 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -887,6 +887,7 @@ xfs_ag_shrink_space(
 	struct xfs_alloc_arg	args = {
 		.tp	= *tpp,
 		.mp	= mp,
+		.pag	= pag,
 		.type	= XFS_ALLOCTYPE_THIS_BNO,
 		.minlen = delta,
 		.maxlen = delta,
@@ -938,7 +939,7 @@ xfs_ag_shrink_space(
 		return error;
 
 	/* internal log shouldn't also show up in the free space btrees */
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_this_ag(&args);
 	if (!error && args.agbno == NULLAGBLOCK)
 		error = -ENOSPC;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index edcbf8fd10ea..7e4452c11421 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2723,7 +2723,6 @@ xfs_alloc_fix_freelist(
 	targs.agbp = agbp;
 	targs.agno = args->agno;
 	targs.alignment = targs.minlen = targs.prod = 1;
-	targs.type = XFS_ALLOCTYPE_THIS_AG;
 	targs.pag = pag;
 	error = xfs_alloc_read_agfl(pag, tp, &agflbp);
 	if (error)
@@ -3271,14 +3270,17 @@ xfs_alloc_vextent_set_fsbno(
 /*
  * Allocate within a single AG only.
  */
-static int
+int
 xfs_alloc_vextent_this_ag(
-	struct xfs_alloc_arg	*args,
-	xfs_agnumber_t		minimum_agno)
+	struct xfs_alloc_arg	*args)
 {
 	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		minimum_agno = 0;
 	int			error;
 
+	if (args->tp->t_highest_agno != NULLAGNUMBER)
+		minimum_agno = args->tp->t_highest_agno;
+
 	error = xfs_alloc_vextent_check_args(args);
 	if (error) {
 		if (error == -ENOSPC)
@@ -3293,11 +3295,8 @@ xfs_alloc_vextent_this_ag(
 		return 0;
 	}
 
-	args->pag = xfs_perag_get(mp, args->agno);
 	error = xfs_alloc_ag_vextent(args);
-
 	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
-	xfs_perag_put(args->pag);
 	return error;
 }
 
@@ -3480,6 +3479,7 @@ xfs_alloc_vextent(
 	struct xfs_alloc_arg	*args)
 {
 	xfs_agnumber_t		minimum_agno = 0;
+	int			error;
 
 	if (args->tp->t_highest_agno != NULLAGNUMBER)
 		minimum_agno = args->tp->t_highest_agno;
@@ -3488,17 +3488,21 @@ xfs_alloc_vextent(
 	case XFS_ALLOCTYPE_THIS_AG:
 	case XFS_ALLOCTYPE_NEAR_BNO:
 	case XFS_ALLOCTYPE_THIS_BNO:
-		return xfs_alloc_vextent_this_ag(args, minimum_agno);
+		args->pag = xfs_perag_get(args->mp,
+				XFS_FSB_TO_AGNO(args->mp, args->fsbno));
+		error = xfs_alloc_vextent_this_ag(args);
+		xfs_perag_put(args->pag);
+		break;
 	case XFS_ALLOCTYPE_START_BNO:
 		return xfs_alloc_vextent_start_ag(args, minimum_agno);
 	case XFS_ALLOCTYPE_FIRST_AG:
 		return xfs_alloc_vextent_first_ag(args, minimum_agno);
 	default:
+		error = -EFSCORRUPTED;
 		ASSERT(0);
-		/* NOTREACHED */
+		break;
 	}
-	/* Should never get here */
-	return -EFSCORRUPTED;
+	return error;
 }
 
 /* Ensure that the freelist is at full capacity. */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 2c3f762dfb58..0a9ad6cd18e2 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -124,6 +124,12 @@ int				/* error */
 xfs_alloc_vextent(
 	xfs_alloc_arg_t	*args);	/* allocation argument structure */
 
+/*
+ * Allocate an extent in the specific AG defined by args->fsbno. If there is no
+ * space in that AG, then the allocation will fail.
+ */
+int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
+
 /*
  * Free an extent.
  */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 87ad56e034c0..baf11bc4d091 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -789,6 +789,8 @@ xfs_bmap_local_to_extents(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = ip->i_mount;
+	args.total = total;
+	args.minlen = args.maxlen = args.prod = 1;
 	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
 	/*
 	 * Allocate a block.  We know we need only one, since the
@@ -3506,8 +3508,7 @@ xfs_bmap_btalloc(
 	xfs_extlen_t		orig_length;
 	xfs_extlen_t		blen;
 	xfs_extlen_t		nextminlen = 0;
-	int			isaligned;
-	int			tryagain;
+	int			isaligned = 0;
 	int			error;
 	int			stripe_align;
 
@@ -3528,7 +3529,6 @@ xfs_bmap_btalloc(
 
 	xfs_bmap_adjacent(ap);
 
-	tryagain = isaligned = 0;
 	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 
@@ -3576,9 +3576,9 @@ xfs_bmap_btalloc(
 			 * allocation with alignment turned on.
 			 */
 			atype = args.type;
-			tryagain = 1;
 			args.type = XFS_ALLOCTYPE_THIS_BNO;
 			args.alignment = 1;
+
 			/*
 			 * Compute the minlen+alignment for the
 			 * next case.  Set slop so that the value
@@ -3595,34 +3595,37 @@ xfs_bmap_btalloc(
 					args.minlen - 1;
 			else
 				args.minalignslop = 0;
+
+			args.pag = xfs_perag_get(mp,
+					XFS_FSB_TO_AGNO(mp, args.fsbno));
+			error = xfs_alloc_vextent_this_ag(&args);
+			xfs_perag_put(args.pag);
+			if (error)
+				return error;
+
+			if (args.fsbno != NULLFSBLOCK)
+				goto out_success;
+			/*
+			 * Exact allocation failed. Now try with alignment
+			 * turned on.
+			 */
+			args.pag = NULL;
+			args.type = atype;
+			args.fsbno = ap->blkno;
+			args.alignment = stripe_align;
+			args.minlen = nextminlen;
+			args.minalignslop = 0;
+			isaligned = 1;
 		}
 	} else {
 		args.alignment = 1;
 		args.minalignslop = 0;
 	}
-	args.minleft = ap->minleft;
-	args.wasdel = ap->wasdel;
-	args.resv = XFS_AG_RESV_NONE;
-	args.datatype = ap->datatype;
 
 	error = xfs_alloc_vextent(&args);
 	if (error)
 		return error;
 
-	if (tryagain && args.fsbno == NULLFSBLOCK) {
-		/*
-		 * Exact allocation failed. Now try with alignment
-		 * turned on.
-		 */
-		args.type = atype;
-		args.fsbno = ap->blkno;
-		args.alignment = stripe_align;
-		args.minlen = nextminlen;
-		args.minalignslop = 0;
-		isaligned = 1;
-		if ((error = xfs_alloc_vextent(&args)))
-			return error;
-	}
 	if (isaligned && args.fsbno == NULLFSBLOCK) {
 		/*
 		 * allocation failed, so turn off alignment and
@@ -3650,8 +3653,13 @@ xfs_bmap_btalloc(
 			return error;
 		ap->tp->t_flags |= XFS_TRANS_LOWMODE;
 	}
+	args.minleft = ap->minleft;
+	args.wasdel = ap->wasdel;
+	args.resv = XFS_AG_RESV_NONE;
+	args.datatype = ap->datatype;
 
 	if (args.fsbno != NULLFSBLOCK) {
+out_success:
 		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
 			orig_length);
 	} else {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index afd9b2d962a3..d42c1a1da1fc 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -21,6 +21,7 @@
 #include "xfs_quota.h"
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
+#include "xfs_ag.h"
 
 static struct kmem_cache	*xfs_bmbt_cur_cache;
 
@@ -200,14 +201,18 @@ xfs_bmbt_alloc_block(
 	union xfs_btree_ptr		*new,
 	int				*stat)
 {
-	xfs_alloc_arg_t		args;		/* block allocation args */
-	int			error;		/* error return value */
+	struct xfs_alloc_arg	args;
+	int			error;
 
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_ino.ip->i_ino,
 			cur->bc_ino.whichfork);
+	args.minlen = args.maxlen = args.prod = 1;
+	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL;
+	if (!args.wasdel && args.tp->t_blk_res == 0)
+		return -ENOSPC;
 
 	args.fsbno = be64_to_cpu(start->l);
 	args.type = XFS_ALLOCTYPE_START_BNO;
@@ -222,15 +227,9 @@ xfs_bmbt_alloc_block(
 		args.minleft = xfs_bmapi_minleft(cur->bc_tp, cur->bc_ino.ip,
 					cur->bc_ino.whichfork);
 
-	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL;
-	if (!args.wasdel && args.tp->t_blk_res == 0) {
-		error = -ENOSPC;
-		goto error0;
-	}
 	error = xfs_alloc_vextent(&args);
 	if (error)
-		goto error0;
+		return error;
 
 	if (args.fsbno == NULLFSBLOCK && args.minleft) {
 		/*
@@ -243,7 +242,7 @@ xfs_bmbt_alloc_block(
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		error = xfs_alloc_vextent(&args);
 		if (error)
-			goto error0;
+			return error;
 		cur->bc_tp->t_flags |= XFS_TRANS_LOWMODE;
 	}
 	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
@@ -262,9 +261,6 @@ xfs_bmbt_alloc_block(
 
 	*stat = 1;
 	return 0;
-
- error0:
-	return error;
 }
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 20d2365524a4..74ad88853a8c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -630,6 +630,7 @@ xfs_ialloc_ag_alloc(
 	args.mp = tp->t_mountp;
 	args.fsbno = NULLFSBLOCK;
 	args.oinfo = XFS_RMAP_OINFO_INODES;
+	args.pag = pag;
 
 #ifdef DEBUG
 	/* randomly do sparse inode allocations */
@@ -683,7 +684,8 @@ xfs_ialloc_ag_alloc(
 
 		/* Allow space for the inode btree to split. */
 		args.minleft = igeo->inobt_maxlevels;
-		if ((error = xfs_alloc_vextent(&args)))
+		error = xfs_alloc_vextent_this_ag(&args);
+		if (error)
 			return error;
 
 		/*
@@ -731,7 +733,8 @@ xfs_ialloc_ag_alloc(
 		 * Allow space for the inode btree to split.
 		 */
 		args.minleft = igeo->inobt_maxlevels;
-		if ((error = xfs_alloc_vextent(&args)))
+		error = xfs_alloc_vextent_this_ag(&args);
+		if (error)
 			return error;
 	}
 
@@ -780,7 +783,7 @@ xfs_ialloc_ag_alloc(
 					    args.mp->m_sb.sb_inoalignmt) -
 				 igeo->ialloc_blks;
 
-		error = xfs_alloc_vextent(&args);
+		error = xfs_alloc_vextent_this_ag(&args);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 3675a0d29310..fa6cd2502970 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -103,6 +103,7 @@ __xfs_inobt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
+	args.pag = cur->bc_ag.pag;
 	args.oinfo = XFS_RMAP_OINFO_INOBT;
 	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_ag.pag->pag_agno, sbno);
 	args.minlen = 1;
@@ -111,7 +112,7 @@ __xfs_inobt_alloc_block(
 	args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	args.resv = resv;
 
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_this_ag(&args);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index d20abf0390fc..a980fb18bde2 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -67,6 +67,7 @@ xfs_refcountbt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
+	args.pag = cur->bc_ag.pag;
 	args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			xfs_refc_block(args.mp));
@@ -74,7 +75,7 @@ xfs_refcountbt_alloc_block(
 	args.minlen = args.maxlen = args.prod = 1;
 	args.resv = XFS_AG_RESV_METADATA;
 
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_this_ag(&args);
 	if (error)
 		goto out_error;
 	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index d0b1644efb89..5f4b50aac4bb 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -326,6 +326,7 @@ xrep_alloc_ag_block(
 
 	args.tp = sc->tp;
 	args.mp = sc->mp;
+	args.pag = sc->sa.pag;
 	args.oinfo = *oinfo;
 	args.fsbno = XFS_AGB_TO_FSB(args.mp, sc->sa.pag->pag_agno, 0);
 	args.minlen = 1;
@@ -334,7 +335,7 @@ xrep_alloc_ag_block(
 	args.type = XFS_ALLOCTYPE_THIS_AG;
 	args.resv = resv;
 
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_this_ag(&args);
 	if (error)
 		return error;
 	if (args.fsbno == NULLFSBLOCK)
-- 
2.39.0

