Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F2EC38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjARWpa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjARWpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:18 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE185F395
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:17 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 78so92594pgb.8
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gMejnVgrbPmkzLpcSjDMUCL+ynfiDTVQd/geV+mcHw8=;
        b=dVwgtPmlrDoNIHKKKEipvjyB7hKXrj4mPFJKRjicvs/SN9d9qup15izYa1p5sNM1/k
         QOQC47V+o5vUjvLqW28GroxXNNq9GKsO5d6ozrrP3W/7oC4Scn3SNZaXSzjoOTaq3xfb
         aHLWcoaYQ7Jhtc9SKlloYllgEJbFpEtqyLTY2rlaixCbe1dasIELm0GSTudPU8wbxkqg
         WF27Pai6xDnoFG12CYdbtKw6w3fo7BVIWCdYbFVaf/LXE/0Q2cNvUHS6PTR9jxPQbGKG
         Rf2DCTI6IoV0cHwP012+/0o+nl5xLvO2jFFekdIkwKYILxBaItLF8RJeKxoyTmgbjtl7
         RJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gMejnVgrbPmkzLpcSjDMUCL+ynfiDTVQd/geV+mcHw8=;
        b=PcxeZO6xPBUnUAR2nJ60E3MHNf/WUQ0+2v/k0blhEEZlf4Uc+QZ38AzF3KRBRfqOsy
         Q2vfjt8agu29UXBPL6DrrDyqXyGNhsRLYIlsmHiNF2X2VtFrouZhRYTmxwyNxbPUXZ3a
         tt8pLj/0jBWekdqyazGa2OIHODd/TXle2eTueP03jQT1qRIO5A4w4N4FB8VaylAF5RLz
         7AJ3r5pgzuvIOzHeiSEWeSAODtBWUMVZ5t9uIYv6llW04GLI4Y0MvXVFd4pXmG1s7TLH
         EW05Cu5vPBDfcU+3HijpJZRJTNSSMq4P0d+5W3dYePEvleNd3hKI8r+2bRaJzYRf5IAN
         jMmw==
X-Gm-Message-State: AFqh2kqkeoY7mD2A1uftztRQ2+o9iR725h2ExuU5KCdqYcZf+O9SIaEL
        8M3QPXpSxw4vpoyCD7f0m37hUkW8tB3Nrr5a
X-Google-Smtp-Source: AMrXdXttqyTfsBx5kl1m9QwstD6ZQUPGmssykAXAGDc51R1dtiBBnN+RZsnja4CxcMrCV08EnruSAw==
X-Received: by 2002:a62:5ec2:0:b0:580:963d:8064 with SMTP id s185-20020a625ec2000000b00580963d8064mr6978204pfb.20.1674081916416;
        Wed, 18 Jan 2023 14:45:16 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id a6-20020aa79706000000b0058d9e915891sm6763406pfg.57.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB8-004iWj-TL
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:10 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB8-008FCp-2x
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/42] xfs: drop firstblock constraints from allocation setup
Date:   Thu, 19 Jan 2023 09:44:27 +1100
Message-Id: <20230118224505.1964941-5-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that xfs_alloc_vextent() does all the AGF deadlock prevention
filtering for multiple allocations in a single transaction, we no
longer need the allocation setup code to care about what AGs we
might already have locked.

Hence we can remove all the "nullfb" conditional logic in places
like xfs_bmap_btalloc() and instead have them focus simply on
setting up locality constraints. If the allocation fails due to
AGF lock filtering in xfs_alloc_vextent, then we just fall back as
we normally do to more relaxed allocation constraints.

As a result, any allocation that allows AG scanning (i.e. not
confined to a single AG) and does not force a worst case full
filesystem scan will now be able to attempt allocation from AGs
lower than that defined by tp->t_firstblock. This is because
xfs_alloc_vextent() allows try-locking of the AGFs and hence enables
low space algorithms to at least -try- to get space from AGs lower
than the one that we have currently locked and allocated from. This
is a significant improvement in the low space allocation algorithm.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 168 +++++++++++----------------------
 fs/xfs/libxfs/xfs_bmap.h       |   1 +
 fs/xfs/libxfs/xfs_bmap_btree.c |  30 +++---
 3 files changed, 67 insertions(+), 132 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9dc33cdc2ab9..bc566aae4246 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -645,16 +645,9 @@ xfs_bmap_extents_to_btree(
 	args.tp = tp;
 	args.mp = mp;
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
-	if (tp->t_firstblock == NULLFSBLOCK) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
-	} else if (tp->t_flags & XFS_TRANS_LOWMODE) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.fsbno = tp->t_firstblock;
-	} else {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.fsbno = tp->t_firstblock;
-	}
+
+	args.type = XFS_ALLOCTYPE_START_BNO;
+	args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = wasdel;
 	*logflagsp = 0;
@@ -662,17 +655,14 @@ xfs_bmap_extents_to_btree(
 	if (error)
 		goto out_root_realloc;
 
+	/*
+	 * Allocation can't fail, the space was reserved.
+	 */
 	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
 		error = -ENOSPC;
 		goto out_root_realloc;
 	}
 
-	/*
-	 * Allocation can't fail, the space was reserved.
-	 */
-	ASSERT(tp->t_firstblock == NULLFSBLOCK ||
-	       args.agno >= XFS_FSB_TO_AGNO(mp, tp->t_firstblock));
-	tp->t_firstblock = args.fsbno;
 	cur->bc_ino.allocated++;
 	ip->i_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
@@ -804,13 +794,8 @@ xfs_bmap_local_to_extents(
 	 * Allocate a block.  We know we need only one, since the
 	 * file currently fits in an inode.
 	 */
-	if (tp->t_firstblock == NULLFSBLOCK) {
-		args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
-		args.type = XFS_ALLOCTYPE_START_BNO;
-	} else {
-		args.fsbno = tp->t_firstblock;
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	}
+	args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
+	args.type = XFS_ALLOCTYPE_START_BNO;
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
 	error = xfs_alloc_vextent(&args);
@@ -820,7 +805,6 @@ xfs_bmap_local_to_extents(
 	/* Can't fail, the space was reserved. */
 	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(args.len == 1);
-	tp->t_firstblock = args.fsbno;
 	error = xfs_trans_get_buf(tp, args.mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(args.mp, args.fsbno),
 			args.mp->m_bsize, 0, &bp);
@@ -854,8 +838,7 @@ xfs_bmap_local_to_extents(
 
 	ifp->if_nextents = 1;
 	ip->i_nblocks = 1;
-	xfs_trans_mod_dquot_byino(tp, ip,
-		XFS_TRANS_DQ_BCOUNT, 1L);
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	flags |= xfs_ilog_fext(whichfork);
 
 done:
@@ -3025,9 +3008,7 @@ xfs_bmap_adjacent(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
 	xfs_fsblock_t	adjust;		/* adjustment to block numbers */
-	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
 	xfs_mount_t	*mp;		/* mount point structure */
-	int		nullfb;		/* true if ap->firstblock isn't set */
 	int		rt;		/* true if inode is realtime */
 
 #define	ISVALID(x,y)	\
@@ -3038,11 +3019,8 @@ xfs_bmap_adjacent(
 		XFS_FSB_TO_AGBNO(mp, x) < mp->m_sb.sb_agblocks)
 
 	mp = ap->ip->i_mount;
-	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
 	rt = XFS_IS_REALTIME_INODE(ap->ip) &&
 		(ap->datatype & XFS_ALLOC_USERDATA);
-	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
-							ap->tp->t_firstblock);
 	/*
 	 * If allocating at eof, and there's a previous real block,
 	 * try to use its last block as our starting point.
@@ -3101,13 +3079,6 @@ xfs_bmap_adjacent(
 				prevbno += adjust;
 			else
 				prevdiff += adjust;
-			/*
-			 * If the firstblock forbids it, can't use it,
-			 * must use default.
-			 */
-			if (!rt && !nullfb &&
-			    XFS_FSB_TO_AGNO(mp, prevbno) != fb_agno)
-				prevbno = NULLFSBLOCK;
 		}
 		/*
 		 * No previous block or can't follow it, just default.
@@ -3143,13 +3114,6 @@ xfs_bmap_adjacent(
 				gotdiff += adjust - ap->length;
 			} else
 				gotdiff += adjust;
-			/*
-			 * If the firstblock forbids it, can't use it,
-			 * must use default.
-			 */
-			if (!rt && !nullfb &&
-			    XFS_FSB_TO_AGNO(mp, gotbno) != fb_agno)
-				gotbno = NULLFSBLOCK;
 		}
 		/*
 		 * No next block, just default.
@@ -3236,7 +3200,7 @@ xfs_bmap_select_minlen(
 }
 
 STATIC int
-xfs_bmap_btalloc_nullfb(
+xfs_bmap_btalloc_select_lengths(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		*blen)
@@ -3247,8 +3211,13 @@ xfs_bmap_btalloc_nullfb(
 	int			error;
 
 	args->type = XFS_ALLOCTYPE_START_BNO;
-	args->total = ap->total;
+	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
+		args->total = ap->minlen;
+		args->minlen = ap->minlen;
+		return 0;
+	}
 
+	args->total = ap->total;
 	startag = ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
 	if (startag == NULLAGNUMBER)
 		startag = ag = 0;
@@ -3280,6 +3249,13 @@ xfs_bmap_btalloc_filestreams(
 	int			notinit = 0;
 	int			error;
 
+	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
+		args->type = XFS_ALLOCTYPE_FIRST_AG;
+		args->total = ap->minlen;
+		args->minlen = ap->minlen;
+		return 0;
+	}
+
 	args->type = XFS_ALLOCTYPE_NEAR_BNO;
 	args->total = ap->total;
 
@@ -3460,19 +3436,15 @@ xfs_bmap_exact_minlen_extent_alloc(
 
 	xfs_bmap_compute_alignments(ap, &args);
 
-	if (ap->tp->t_firstblock == NULLFSBLOCK) {
-		/*
-		 * Unlike the longest extent available in an AG, we don't track
-		 * the length of an AG's shortest extent.
-		 * XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is a debug only knob and
-		 * hence we can afford to start traversing from the 0th AG since
-		 * we need not be concerned about a drop in performance in
-		 * "debug only" code paths.
-		 */
-		ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
-	} else {
-		ap->blkno = ap->tp->t_firstblock;
-	}
+	/*
+	 * Unlike the longest extent available in an AG, we don't track
+	 * the length of an AG's shortest extent.
+	 * XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is a debug only knob and
+	 * hence we can afford to start traversing from the 0th AG since
+	 * we need not be concerned about a drop in performance in
+	 * "debug only" code paths.
+	 */
+	ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
 
 	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
@@ -3515,13 +3487,11 @@ xfs_bmap_btalloc(
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
 	xfs_alloctype_t		atype = 0;
-	xfs_agnumber_t		fb_agno;	/* ag number of ap->firstblock */
 	xfs_agnumber_t		ag;
 	xfs_fileoff_t		orig_offset;
 	xfs_extlen_t		orig_length;
 	xfs_extlen_t		blen;
 	xfs_extlen_t		nextminlen = 0;
-	int			nullfb; /* true if ap->firstblock isn't set */
 	int			isaligned;
 	int			tryagain;
 	int			error;
@@ -3533,34 +3503,17 @@ xfs_bmap_btalloc(
 
 	stripe_align = xfs_bmap_compute_alignments(ap, &args);
 
-	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
-	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
-							ap->tp->t_firstblock);
-	if (nullfb) {
-		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-		    xfs_inode_is_filestream(ap->ip)) {
-			ag = xfs_filestream_lookup_ag(ap->ip);
-			ag = (ag != NULLAGNUMBER) ? ag : 0;
-			ap->blkno = XFS_AGB_TO_FSB(mp, ag, 0);
-		} else {
-			ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
-		}
-	} else
-		ap->blkno = ap->tp->t_firstblock;
+	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+	    xfs_inode_is_filestream(ap->ip)) {
+		ag = xfs_filestream_lookup_ag(ap->ip);
+		ag = (ag != NULLAGNUMBER) ? ag : 0;
+		ap->blkno = XFS_AGB_TO_FSB(mp, ag, 0);
+	} else {
+		ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
+	}
 
 	xfs_bmap_adjacent(ap);
 
-	/*
-	 * If allowed, use ap->blkno; otherwise must use firstblock since
-	 * it's in the right allocation group.
-	 */
-	if (nullfb || XFS_FSB_TO_AGNO(mp, ap->blkno) == fb_agno)
-		;
-	else
-		ap->blkno = ap->tp->t_firstblock;
-	/*
-	 * Normal allocation, done through xfs_alloc_vextent.
-	 */
 	tryagain = isaligned = 0;
 	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
@@ -3568,30 +3521,19 @@ xfs_bmap_btalloc(
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = min(ap->length, mp->m_ag_max_usable);
 	blen = 0;
-	if (nullfb) {
-		/*
-		 * Search for an allocation group with a single extent large
-		 * enough for the request.  If one isn't found, then adjust
-		 * the minimum allocation size to the largest space found.
-		 */
-		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-		    xfs_inode_is_filestream(ap->ip))
-			error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
-		else
-			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
-		if (error)
-			return error;
-	} else if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
-		if (xfs_inode_is_filestream(ap->ip))
-			args.type = XFS_ALLOCTYPE_FIRST_AG;
-		else
-			args.type = XFS_ALLOCTYPE_START_BNO;
-		args.total = args.minlen = ap->minlen;
-	} else {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.total = ap->total;
-		args.minlen = ap->minlen;
-	}
+
+	/*
+	 * Search for an allocation group with a single extent large
+	 * enough for the request.  If one isn't found, then adjust
+	 * the minimum allocation size to the largest space found.
+	 */
+	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+	    xfs_inode_is_filestream(ap->ip))
+		error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
+	else
+		error = xfs_bmap_btalloc_select_lengths(ap, &args, &blen);
+	if (error)
+		return error;
 
 	/*
 	 * If we are not low on available data blocks, and the underlying
@@ -3678,7 +3620,7 @@ xfs_bmap_btalloc(
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
-	if (args.fsbno == NULLFSBLOCK && nullfb &&
+	if (args.fsbno == NULLFSBLOCK &&
 	    args.minlen > ap->minlen) {
 		args.minlen = ap->minlen;
 		args.type = XFS_ALLOCTYPE_START_BNO;
@@ -3686,7 +3628,7 @@ xfs_bmap_btalloc(
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
-	if (args.fsbno == NULLFSBLOCK && nullfb) {
+	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = 0;
 		args.type = XFS_ALLOCTYPE_FIRST_AG;
 		args.total = ap->minlen;
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 08c16e4edc0f..0ffc0d998850 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -269,4 +269,5 @@ extern struct kmem_cache	*xfs_bmap_intent_cache;
 int __init xfs_bmap_intent_init_cache(void);
 void xfs_bmap_intent_destroy_cache(void);
 
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 18de4fbfef4e..76a0f0d260a4 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -206,28 +206,21 @@ xfs_bmbt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	args.fsbno = cur->bc_tp->t_firstblock;
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_ino.ip->i_ino,
 			cur->bc_ino.whichfork);
 
-	if (args.fsbno == NULLFSBLOCK) {
-		args.fsbno = be64_to_cpu(start->l);
-		args.type = XFS_ALLOCTYPE_START_BNO;
+	args.fsbno = be64_to_cpu(start->l);
+	args.type = XFS_ALLOCTYPE_START_BNO;
 
-		/*
-		 * If we are coming here from something like unwritten extent
-		 * conversion, there has been no data extent allocation already
-		 * done, so we have to ensure that we attempt to locate the
-		 * entire set of bmbt allocations in the same AG, as
-		 * xfs_bmapi_write() would have reserved.
-		 */
+	/*
+	 * If we are coming here from something like unwritten extent
+	 * conversion, there has been no data extent allocation already done, so
+	 * we have to ensure that we attempt to locate the entire set of bmbt
+	 * allocations in the same AG, as xfs_bmapi_write() would have reserved.
+	 */
+	if (cur->bc_tp->t_firstblock == NULLFSBLOCK)
 		args.minleft = xfs_bmapi_minleft(cur->bc_tp, cur->bc_ino.ip,
-						cur->bc_ino.whichfork);
-	} else if (cur->bc_tp->t_flags & XFS_TRANS_LOWMODE) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
-	} else {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	}
+					cur->bc_ino.whichfork);
 
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL;
@@ -247,7 +240,7 @@ xfs_bmbt_alloc_block(
 		 */
 		args.fsbno = 0;
 		args.minleft = 0;
-		args.type = XFS_ALLOCTYPE_FIRST_AG;
+		args.type = XFS_ALLOCTYPE_START_BNO;
 		error = xfs_alloc_vextent(&args);
 		if (error)
 			goto error0;
@@ -259,7 +252,6 @@ xfs_bmbt_alloc_block(
 	}
 
 	ASSERT(args.len == 1);
-	cur->bc_tp->t_firstblock = args.fsbno;
 	cur->bc_ino.allocated++;
 	cur->bc_ino.ip->i_nblocks++;
 	xfs_trans_log_inode(args.tp, cur->bc_ino.ip, XFS_ILOG_CORE);
-- 
2.39.0

