Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C7EC636D3
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjBIWSi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjBIWSd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:33 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAEC6A724
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:31 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id be8so4526953plb.7
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wwkQOgZVPch52OGAI42PiKly1eTSSoNgvy0o0fBjaFg=;
        b=Ll6ctDs5Hsws90oqdu62Nixpn1IkYm2JywalTTNGEWysayvXH/b937p+octTdbv9DT
         Sk5oBgJLSlhlLbJzuL82z1M1JuY2wmn2NkfLs8S7hE2NiuNoP+aSnvwyOx3G/cXucbU/
         7VdS3Rrg+xmvh1KUs9RHkivIYMhlhuhny12JIDO95YMUsKrw07/8Zqbz/cvuO+j6HeFy
         t3GMRmy/yBl6F0+wMMdjMVT6PJXtmAxjy9u6PEgdLpWI1SwxCxTl0SQvb7146q4mrg7N
         vpD1iWsnfX6QgEhCOEHo7VD6X55+Y5krOJ3pkzDFrsL/eXQZ63XbIrlv7ixwqEo+zlWO
         bABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwkQOgZVPch52OGAI42PiKly1eTSSoNgvy0o0fBjaFg=;
        b=26BgsgNrLQV53zZUKPRD54+iUA2OLeV0yic6qIiIopnKOkrlUhElyj5xdqHpPkVBww
         fS9zqySgC007tZh5A3nHaC16XRXYEo2Wi4KBoqdOFac9i8F6dDzDPdeRzJaKMfOaFhgM
         9iTFGaOv2iIj8JRKGHiKHxLwobhRgkwASGvxDeW1Bx/9LzOwkPFg0cq7hLl/SqqWq6O8
         GmXy69TSPiKxC5usQfrZdX73uJ++KaXZrwYwehWP4bTQfKRsDXLZhOxxi1Gwwr4wgYO+
         Ox65isNfPws47zrchzRzSs4GO+kc/BIQ+ssrFzEhZEU9XPciS+4MDezrrYDNcQP9MYFF
         KA9w==
X-Gm-Message-State: AO0yUKVsfZWg2ZnAzYPf2S1ujaBHUJQWW/PnZIN15djtuJbi3jmJ520d
        91oOBQT9A17MCuFjLZMF9rwE5Uzq2jbgMDbm
X-Google-Smtp-Source: AK7set+VQmB8ZvdIvWnltrLriRBvvjOBwxjcbnIzPY4/d1YY3vErjnpmKxrKwtW3bd+ICbwPwRodUw==
X-Received: by 2002:a05:6a21:6714:b0:b8:4b1a:deb5 with SMTP id wh20-20020a056a21671400b000b84b1adeb5mr2547496pzb.18.1675981111409;
        Thu, 09 Feb 2023 14:18:31 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id 26-20020aa7921a000000b00593eb3a5e44sm1948306pfo.37.2023.02.09.14.18.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:31 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVc-IV
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcO0-1p
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 26/42] xfs: fold xfs_alloc_ag_vextent() into callers
Date:   Fri, 10 Feb 2023 09:18:09 +1100
Message-Id: <20230209221825.3722244-27-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We don't need the multiplexing xfs_alloc_ag_vextent() provided
anymore - we can just call the exact/near/size variants directly.
This allows us to remove args->type completely and stop using
args->fsbno as an input to the allocator algorithms.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 100 ++++++++++----------------------------
 fs/xfs/libxfs/xfs_alloc.h |  17 -------
 fs/xfs/libxfs/xfs_bmap.c  |  10 +---
 fs/xfs/xfs_trace.h        |   8 +--
 4 files changed, 29 insertions(+), 106 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index afc6bd48b0a5..50eb44851f23 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -36,10 +36,6 @@ struct workqueue_struct *xfs_alloc_wq;
 #define	XFSA_FIXUP_BNO_OK	1
 #define	XFSA_FIXUP_CNT_OK	2
 
-STATIC int xfs_alloc_ag_vextent_exact(xfs_alloc_arg_t *);
-STATIC int xfs_alloc_ag_vextent_near(xfs_alloc_arg_t *);
-STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
-
 /*
  * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of slots in
  * the beginning of the block for a proper header with the location information
@@ -772,8 +768,6 @@ xfs_alloc_cur_setup(
 	int			error;
 	int			i;
 
-	ASSERT(args->alignment == 1 || args->type != XFS_ALLOCTYPE_THIS_BNO);
-
 	acur->cur_len = args->maxlen;
 	acur->rec_bno = 0;
 	acur->rec_len = 0;
@@ -887,7 +881,6 @@ xfs_alloc_cur_check(
 	 * We have an aligned record that satisfies minlen and beats or matches
 	 * the candidate extent size. Compare locality for near allocation mode.
 	 */
-	ASSERT(args->type == XFS_ALLOCTYPE_NEAR_BNO);
 	diff = xfs_alloc_compute_diff(args->agbno, args->len,
 				      args->alignment, args->datatype,
 				      bnoa, lena, &bnew);
@@ -1132,40 +1125,6 @@ xfs_alloc_ag_vextent_small(
 	return error;
 }
 
-/*
- * Allocate a variable extent in the allocation group agno.
- * Type and bno are used to determine where in the allocation group the
- * extent will start.
- * Extent's length (returned in *len) will be between minlen and maxlen,
- * and of the form k * prod + mod unless there's nothing that large.
- * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
- */
-static int
-xfs_alloc_ag_vextent(
-	struct xfs_alloc_arg	*args)
-{
-	int			error = 0;
-
-	/*
-	 * Branch to correct routine based on the type.
-	 */
-	switch (args->type) {
-	case XFS_ALLOCTYPE_THIS_AG:
-		error = xfs_alloc_ag_vextent_size(args);
-		break;
-	case XFS_ALLOCTYPE_NEAR_BNO:
-		error = xfs_alloc_ag_vextent_near(args);
-		break;
-	case XFS_ALLOCTYPE_THIS_BNO:
-		error = xfs_alloc_ag_vextent_exact(args);
-		break;
-	default:
-		ASSERT(0);
-		/* NOTREACHED */
-	}
-	return error;
-}
-
 /*
  * Allocate a variable extent at exactly agno/bno.
  * Extent's length (returned in *len) will be between minlen and maxlen,
@@ -1351,7 +1310,6 @@ xfs_alloc_ag_vextent_locality(
 	bool			fbinc;
 
 	ASSERT(acur->len == 0);
-	ASSERT(args->type == XFS_ALLOCTYPE_NEAR_BNO);
 
 	*stat = 0;
 
@@ -3137,6 +3095,7 @@ xfs_alloc_vextent_check_args(
 	xfs_agblock_t		agsize;
 
 	args->agbno = NULLAGBLOCK;
+	args->fsbno = NULLFSBLOCK;
 
 	/*
 	 * Just fix this up, for the case where the last a.g. is shorter
@@ -3295,8 +3254,11 @@ xfs_alloc_vextent_finish(
 }
 
 /*
- * Allocate within a single AG only. Caller is expected to hold a
- * perag reference in args->pag.
+ * Allocate within a single AG only. This uses a best-fit length algorithm so if
+ * you need an exact sized allocation without locality constraints, this is the
+ * fastest way to do it.
+ *
+ * Caller is expected to hold a perag reference in args->pag.
  */
 int
 xfs_alloc_vextent_this_ag(
@@ -3305,7 +3267,6 @@ xfs_alloc_vextent_this_ag(
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno = 0;
-	xfs_rfsblock_t		target = XFS_AGB_TO_FSB(mp, agno, 0);
 	int			error;
 
 	if (args->tp->t_highest_agno != NULLAGNUMBER)
@@ -3317,7 +3278,7 @@ xfs_alloc_vextent_this_ag(
 		return 0;
 	}
 
-	error = xfs_alloc_vextent_check_args(args, target);
+	error = xfs_alloc_vextent_check_args(args, XFS_AGB_TO_FSB(mp, agno, 0));
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3326,12 +3287,10 @@ xfs_alloc_vextent_this_ag(
 
 	args->agno = agno;
 	args->agbno = 0;
-	args->fsbno = target;
-	args->type = XFS_ALLOCTYPE_THIS_AG;
 
 	error = xfs_alloc_vextent_prepare_ag(args);
 	if (!error && args->agbp)
-		error = xfs_alloc_ag_vextent(args);
+		error = xfs_alloc_ag_vextent_size(args);
 
 	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
 }
@@ -3355,6 +3314,7 @@ xfs_alloc_vextent_iterate_ags(
 	struct xfs_alloc_arg	*args,
 	xfs_agnumber_t		minimum_agno,
 	xfs_agnumber_t		start_agno,
+	xfs_agblock_t		target_agbno,
 	uint32_t		flags)
 {
 	struct xfs_mount	*mp = args->mp;
@@ -3369,7 +3329,6 @@ xfs_alloc_vextent_iterate_ags(
 	args->agno = start_agno;
 	for (;;) {
 		args->pag = xfs_perag_get(mp, args->agno);
-		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
 		error = xfs_alloc_vextent_prepare_ag(args);
 		if (error)
 			break;
@@ -3379,16 +3338,18 @@ xfs_alloc_vextent_iterate_ags(
 			 * Allocation is supposed to succeed now, so break out
 			 * of the loop regardless of whether we succeed or not.
 			 */
-			error = xfs_alloc_ag_vextent(args);
+			if (args->agno == start_agno && target_agbno) {
+				args->agbno = target_agbno;
+				error = xfs_alloc_ag_vextent_near(args);
+			} else {
+				args->agbno = 0;
+				error = xfs_alloc_ag_vextent_size(args);
+			}
 			break;
 		}
 
 		trace_xfs_alloc_vextent_loopfailed(args);
 
-		if (args->agno == start_agno &&
-		    args->otype == XFS_ALLOCTYPE_NEAR_BNO)
-			args->type = XFS_ALLOCTYPE_THIS_AG;
-
 		/*
 		 * If we are try-locking, we can't deadlock on AGF locks so we
 		 * can wrap all the way back to the first AG. Otherwise, wrap
@@ -3412,10 +3373,8 @@ xfs_alloc_vextent_iterate_ags(
 				trace_xfs_alloc_vextent_allfailed(args);
 				break;
 			}
-
+			args->agbno = target_agbno;
 			flags = 0;
-			if (args->otype == XFS_ALLOCTYPE_NEAR_BNO)
-				args->type = XFS_ALLOCTYPE_NEAR_BNO;
 		}
 		xfs_perag_put(args->pag);
 		args->pag = NULL;
@@ -3464,13 +3423,11 @@ xfs_alloc_vextent_start_ag(
 				mp->m_sb.sb_agcount), 0);
 		bump_rotor = 1;
 	}
+
 	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
-	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
-	args->type = XFS_ALLOCTYPE_NEAR_BNO;
-	args->fsbno = target;
-
 	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
-			XFS_ALLOC_FLAG_TRYLOCK);
+			XFS_FSB_TO_AGBNO(mp, target), XFS_ALLOC_FLAG_TRYLOCK);
+
 	if (bump_rotor) {
 		if (args->agno == start_agno)
 			mp->m_agfrotor = (mp->m_agfrotor + 1) %
@@ -3484,9 +3441,9 @@ xfs_alloc_vextent_start_ag(
 }
 
 /*
- * Iterate from the agno indicated from args->fsbno through to the end of the
+ * Iterate from the agno indicated via @target through to the end of the
  * filesystem attempting blocking allocation. This does not wrap or try a second
- * pass, so will not recurse into AGs lower than indicated by fsbno.
+ * pass, so will not recurse into AGs lower than indicated by the target.
  */
 int
 xfs_alloc_vextent_first_ag(
@@ -3509,10 +3466,8 @@ xfs_alloc_vextent_first_ag(
 	}
 
 	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
-	args->type = XFS_ALLOCTYPE_THIS_AG;
-	args->fsbno = target;
-	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno,
-			start_agno, 0);
+	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
+			XFS_FSB_TO_AGBNO(mp, target), 0);
 	return xfs_alloc_vextent_finish(args, minimum_agno, error, true);
 }
 
@@ -3547,12 +3502,10 @@ xfs_alloc_vextent_exact_bno(
 	}
 
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
-	args->fsbno = target;
-	args->type = XFS_ALLOCTYPE_THIS_BNO;
 
 	error = xfs_alloc_vextent_prepare_ag(args);
 	if (!error && args->agbp)
-		error = xfs_alloc_ag_vextent(args);
+		error = xfs_alloc_ag_vextent_exact(args);
 
 	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
 }
@@ -3594,11 +3547,10 @@ xfs_alloc_vextent_near_bno(
 		args->pag = xfs_perag_get(mp, args->agno);
 
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
-	args->type = XFS_ALLOCTYPE_NEAR_BNO;
 
 	error = xfs_alloc_vextent_prepare_ag(args);
 	if (!error && args->agbp)
-		error = xfs_alloc_ag_vextent(args);
+		error = xfs_alloc_ag_vextent_near(args);
 
 	return xfs_alloc_vextent_finish(args, minimum_agno, error, needs_perag);
 }
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 63d5ad4ed8a3..2b246d74c189 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -16,21 +16,6 @@ extern struct workqueue_struct *xfs_alloc_wq;
 
 unsigned int xfs_agfl_size(struct xfs_mount *mp);
 
-/*
- * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
- */
-#define XFS_ALLOCTYPE_THIS_AG	0x08	/* anywhere in this a.g. */
-#define XFS_ALLOCTYPE_NEAR_BNO	0x20	/* in this a.g. and near this block */
-#define XFS_ALLOCTYPE_THIS_BNO	0x40	/* at exactly this block */
-
-/* this should become an enum again when the tracing code is fixed */
-typedef unsigned int xfs_alloctype_t;
-
-#define XFS_ALLOC_TYPES \
-	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
-	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
-	{ XFS_ALLOCTYPE_THIS_BNO,	"THIS_BNO" }
-
 /*
  * Flags for xfs_alloc_fix_freelist.
  */
@@ -64,8 +49,6 @@ typedef struct xfs_alloc_arg {
 	xfs_agblock_t	min_agbno;	/* set an agbno range for NEAR allocs */
 	xfs_agblock_t	max_agbno;	/* ... */
 	xfs_extlen_t	len;		/* output: actual size of extent */
-	xfs_alloctype_t	type;		/* allocation type XFS_ALLOCTYPE_... */
-	xfs_alloctype_t	otype;		/* original allocation type */
 	int		datatype;	/* mask defining data type treatment */
 	char		wasdel;		/* set if allocation was prev delayed */
 	char		wasfromfl;	/* set if allocation is from freelist */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c507645f3031..ee402ac8c551 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3501,7 +3501,6 @@ xfs_bmap_btalloc_at_eof(
 	bool			ag_only)
 {
 	struct xfs_mount	*mp = args->mp;
-	xfs_alloctype_t		atype;
 	int			error;
 
 	/*
@@ -3513,14 +3512,12 @@ xfs_bmap_btalloc_at_eof(
 	if (ap->offset) {
 		xfs_extlen_t	nextminlen = 0;
 
-		atype = args->type;
-		args->alignment = 1;
-
 		/*
 		 * Compute the minlen+alignment for the next case.  Set slop so
 		 * that the value of minlen+alignment+slop doesn't go up between
 		 * the calls.
 		 */
+		args->alignment = 1;
 		if (blen > stripe_align && blen <= args->maxlen)
 			nextminlen = blen - stripe_align;
 		else
@@ -3544,17 +3541,15 @@ xfs_bmap_btalloc_at_eof(
 		 * according to the original allocation specification.
 		 */
 		args->pag = NULL;
-		args->type = atype;
 		args->alignment = stripe_align;
 		args->minlen = nextminlen;
 		args->minalignslop = 0;
 	} else {
-		args->alignment = stripe_align;
-		atype = args->type;
 		/*
 		 * Adjust minlen to try and preserve alignment if we
 		 * can't guarantee an aligned maxlen extent.
 		 */
+		args->alignment = stripe_align;
 		if (blen > args->alignment &&
 		    blen <= args->maxlen + args->alignment)
 			args->minlen = blen - args->alignment;
@@ -3576,7 +3571,6 @@ xfs_bmap_btalloc_at_eof(
 	 * original non-aligned state so the caller can proceed on allocation
 	 * failure as if this function was never called.
 	 */
-	args->type = atype;
 	args->fsbno = ap->blkno;
 	args->alignment = 1;
 	return 0;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 1d99c30f66f0..bb7ccb5feeca 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1799,8 +1799,6 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__field(xfs_extlen_t, alignment)
 		__field(xfs_extlen_t, minalignslop)
 		__field(xfs_extlen_t, len)
-		__field(short, type)
-		__field(short, otype)
 		__field(char, wasdel)
 		__field(char, wasfromfl)
 		__field(int, resv)
@@ -1820,8 +1818,6 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__entry->alignment = args->alignment;
 		__entry->minalignslop = args->minalignslop;
 		__entry->len = args->len;
-		__entry->type = args->type;
-		__entry->otype = args->otype;
 		__entry->wasdel = args->wasdel;
 		__entry->wasfromfl = args->wasfromfl;
 		__entry->resv = args->resv;
@@ -1830,7 +1826,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 	),
 	TP_printk("dev %d:%d agno 0x%x agbno 0x%x minlen %u maxlen %u mod %u "
 		  "prod %u minleft %u total %u alignment %u minalignslop %u "
-		  "len %u type %s otype %s wasdel %d wasfromfl %d resv %d "
+		  "len %u wasdel %d wasfromfl %d resv %d "
 		  "datatype 0x%x highest_agno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
@@ -1844,8 +1840,6 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		  __entry->alignment,
 		  __entry->minalignslop,
 		  __entry->len,
-		  __print_symbolic(__entry->type, XFS_ALLOC_TYPES),
-		  __print_symbolic(__entry->otype, XFS_ALLOC_TYPES),
 		  __entry->wasdel,
 		  __entry->wasfromfl,
 		  __entry->resv,
-- 
2.39.0

