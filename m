Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500F0C38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjARWsR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjARWsC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:48:02 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40CC656DC
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:49 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y3-20020a17090a390300b00229add7bb36so55332pjb.4
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PFHNdEfZG3vF5DkjDeCV8HGj33I5PK7AxcZqcq5Z04Q=;
        b=hgJVm0NvZ7lSy3fmvx10xU6520usjruS9emhbZDSb97KK3azorlk1Yh9yCWOG/454S
         GSvtgCjjwU7mLTNtMtacXmDl2/NV0YjQ+Vs4RVMHORtDUu5TxKMOy8FO/3rD7MsXBvjR
         91tkhlChaTU8nuDfmwgEyowu5cLQHs0JKdFgqxGihtYwJKgjhgXHYLiwXu3fBaA99tQK
         y/BATDDGLgSV4A9P3WDTI5CXToOZO+8ipVzfxcWL8kmahO4B4bZInhR/5WPVWhn+D0l5
         TypYFRAu7fXlGPOZvaFcawXdJ1zPLCMe+JPjnIJFR0Jag99SPk3H4BCX3lVm2Dp3vfvY
         b0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFHNdEfZG3vF5DkjDeCV8HGj33I5PK7AxcZqcq5Z04Q=;
        b=2Ctvogww6j/0bbMmZespOygTCJYaQ/IJJd3tvNUkE0b4hPezcmWgwmGoUljth8Vn7j
         PJd/fkW1J2y4t2exMvk+bE8EyKMg9blcemZafIy7uMUbcBgOspjY2COQpVC8F/quMPav
         oj3QWj51+yyvkT0zdJxL36qfHzHO/jj32NbNUB9bzvCZqYXtzfgfVBkNaB7aC9bPw31/
         wNClPY5/bqFB/kLz1MlCH2a4TemmV9afIQLmz/7ckZKWZFA48PFLvktYYy5E13dYAPaW
         MmkYamkBCe7ztnceejSVqj8iO98u7hBVqOCu2X12g0wmDyyXuDefqOKaHmNWmg1Phxe4
         /+iw==
X-Gm-Message-State: AFqh2kp0PE2XUuCOgGEhASDQQ1lLJFWD2paCy4anzRja8gpTi4pLlFaJ
        bxMZ4HoqDNksUxXlJtqSidz0QODWRqOzzR6x
X-Google-Smtp-Source: AMrXdXvvUuXGkHSXWgb6BRwOalA1I+81KDxQw6qS+TK0SncsmTBXLII6z9IeQ6Y4MNzKLxFGaHIx9Q==
X-Received: by 2002:a17:902:d395:b0:194:5fc9:f579 with SMTP id e21-20020a170902d39500b001945fc9f579mr9005956pld.40.1674082069098;
        Wed, 18 Jan 2023 14:47:49 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id d5-20020a170903230500b001754fa42065sm10475749plh.143.2023.01.18.14.47.48
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:47:48 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXq-HG
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FEb-1i
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 26/42] xfs: fold xfs_alloc_ag_vextent() into callers
Date:   Thu, 19 Jan 2023 09:44:49 +1100
Message-Id: <20230118224505.1964941-27-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
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
---
 fs/xfs/libxfs/xfs_alloc.c | 100 ++++++++++----------------------------
 fs/xfs/libxfs/xfs_alloc.h |  17 -------
 fs/xfs/libxfs/xfs_bmap.c  |  10 +---
 fs/xfs/xfs_trace.h        |   8 +--
 4 files changed, 29 insertions(+), 106 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ad2b91b230f6..4de9026d872f 100644
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
-	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
-	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
-	args->type = XFS_ALLOCTYPE_NEAR_BNO;
-	args->fsbno = target;
 
+	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
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
index 106b4deb1110..689419409e09 100644
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
index c9902df16e25..ba74aea034b0 100644
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
index c921e9a5256d..3b25b10fccc1 100644
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

