Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972BB4778B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 23:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712100616; cv=none; b=Tm+F2rUqrTIWBysN4VyzDo8cbTOUO/isgIu+wTJ7x3mAz7MFQGdxhdaCXdEhX8jgoYEIEo8FQ2UmKOs+nWIvKJQZ9uIiFXS7YI8JM5KClsNxnzHRJWLULpDDDE9/zPp0gqQ8/ogIapIFptWy2gmdNz6w0C72tqP7pCnx5pZ+xeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712100616; c=relaxed/simple;
	bh=6hiQtB945cLWiZckyIOeJX5lb2vQT2O8Y5op35KgXKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkIEPh7+W2O7ITM3SYRd2y7+olXGV5RmXMbOOH/sODu+SXvkO1YMLm2wIziyBbromRKRZKeYXJ1vXFXx3foY8JB8ek9DqPQmRVxPb+ER0W5WkN3knilFacYbVpoWlNT2/z06JUPCntBfzfn4GacmvbFikQN8kwBaJAughB4OyQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Hg3PwR9X; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Hg3PwR9X"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5a5272035d3so3449849eaf.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 16:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712100612; x=1712705412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a2BFcAI5vyaY4aG7ATpYX9nsM3eKjqpcy+7EyTjx93Q=;
        b=Hg3PwR9XVURL/s2XFxQCpn11rqcD2IZGVwBBYEagzHNTcS89XeMjsDMFAAfo6tYQYd
         sDmGDYxNxNgi7kFQy8eZW/ijdkObIrcMW6xpXM5h+hyDXf8uADDolltwC3UeOd0khWYr
         r4eRyNnA71YHy+Noy4ZphHPtEOuaEMQN6CxoBrsNB3UYoixNLKOZvuzY5pluPb8NRW2+
         bK6hj0zb7MHMYn20tZksbzCwbno41lnAiCgJWNNtof1z30gE7iWrDjfyvL0lA/BxiOJ5
         MuGYQO3Hugbs/GiihYTcMlO6TmZfV6gK9pZsECxZw73kVjxuIl1y42q4caHWZcOQjbww
         hdIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712100612; x=1712705412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a2BFcAI5vyaY4aG7ATpYX9nsM3eKjqpcy+7EyTjx93Q=;
        b=K6/Jww8d8N31wD9Gql9qrt3qqIgqTyXyS8GjVtVGYh5nVliYXq4ABMrMvf/FQ6kHZg
         hXbfVAprnDGxaY3CBhFGqc9Xo+BKkHcYQ8Y8sTdYcTKxN366sGMJw/WVVBodZUv2PZPQ
         VWDMbNSIDhJw3F7hc7MjfZleyPRNuAB/bAunkCZK3Z+/ftuJgfHqM0m5bNeXuXLkwLOM
         J3tB0x3qQji6mMxP6rUC+hksePMW0zqUAW17U8mvQN7VNjBB96icvL1cPyQYAsV+Hsq3
         59Kym5/v4/7Ssa71g46Kq3Dz7vS2JeNSSOeu5OKGWRhRG9K+Yehzs6d5TILOHhvWWcO9
         SoGg==
X-Gm-Message-State: AOJu0Yxs6QjALMs6WU84mGWEnmK+FXvEropOIXy9YRzzVbUE42sFK5ge
	8YKSL1VrL4FE3nqcMvi6rtu6lF2TOLTuyXH4a9zcVbeoSxyp3GFl51DGLR9VGU+0PjNmYA//UDE
	f
X-Google-Smtp-Source: AGHT+IFDf+2bZlr/odRujs2H4C8GpVGAuwqCzM7Zm9HiCC8xOxyToCVoxtPW47+dWE6aznbd5IRUyw==
X-Received: by 2002:a05:6358:49f:b0:183:630a:a88d with SMTP id x31-20020a056358049f00b00183630aa88dmr1079608rwi.9.1712100612273;
        Tue, 02 Apr 2024 16:30:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id by1-20020a056a02058100b005dc26144d96sm9121778pgb.75.2024.04.02.16.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 16:30:11 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrnZx-001syI-22;
	Wed, 03 Apr 2024 10:30:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrnZx-000000054rJ-0XO2;
	Wed, 03 Apr 2024 10:30:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: john.g.garry@oracle.com
Subject: [PATCH 3/5] xfs: simplify extent allocation alignment
Date: Wed,  3 Apr 2024 10:28:42 +1100
Message-ID: <20240402233006.1210262-4-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240402233006.1210262-1-david@fromorbit.com>
References: <20240402233006.1210262-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

We currently align extent allocation to stripe unit or stripe width.
That is specified by an external parameter to the allocation code,
which then manipulates the xfs_alloc_args alignment configuration in
interesting ways.

The args->alignment field specifies extent start alignment, but
because we may be attempting non-aligned allocation first there are
also slop variables that allow for those allocation attempts to
account for aligned allocation if they fail.

This gets much more complex as we introduce forced allocation
alignment, where extent size hints are used to generate the extent
start alignment. extent size hints currently only affect extent
lengths (via args->prod and args->mod) and so with this change we
will have two different start alignment conditions.

Avoid this complexity by always using args->alignment to indicate
extent start alignment, and always using args->prod/mod to indicate
extent length adjustment.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |  4 +-
 fs/xfs/libxfs/xfs_alloc.h |  2 +-
 fs/xfs/libxfs/xfs_bmap.c  | 96 +++++++++++++++++----------------------
 3 files changed, 45 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e21fd5c1f802..563599e956a6 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2393,7 +2393,7 @@ xfs_alloc_space_available(
 	reservation = xfs_ag_resv_needed(pag, args->resv);
 
 	/* do we have enough contiguous free space for the allocation? */
-	alloc_len = args->minlen + (args->alignment - 1) + args->minalignslop;
+	alloc_len = args->minlen + (args->alignment - 1) + args->alignslop;
 	longest = xfs_alloc_longest_free_extent(pag, min_free, reservation);
 	if (longest < alloc_len)
 		return false;
@@ -2422,7 +2422,7 @@ xfs_alloc_space_available(
 	 * allocation as we know that will definitely succeed and match the
 	 * callers alignment constraints.
 	 */
-	alloc_len = args->maxlen + (args->alignment - 1) + args->minalignslop;
+	alloc_len = args->maxlen + (args->alignment - 1) + args->alignslop;
 	if (longest < alloc_len) {
 		args->maxlen = args->minlen;
 		ASSERT(args->maxlen > 0);
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 0b956f8b9d5a..aa2c103d98f0 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -46,7 +46,7 @@ typedef struct xfs_alloc_arg {
 	xfs_extlen_t	minleft;	/* min blocks must be left after us */
 	xfs_extlen_t	total;		/* total blocks needed in xaction */
 	xfs_extlen_t	alignment;	/* align answer to multiple of this */
-	xfs_extlen_t	minalignslop;	/* slop for minlen+alignment calcs */
+	xfs_extlen_t	alignslop;	/* slop for alignment calcs */
 	xfs_agblock_t	min_agbno;	/* set an agbno range for NEAR allocs */
 	xfs_agblock_t	max_agbno;	/* ... */
 	xfs_extlen_t	len;		/* output: actual size of extent */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 656c95a22f2e..d56c82c07505 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3295,6 +3295,10 @@ xfs_bmap_select_minlen(
 	xfs_extlen_t		blen)
 {
 
+	/* Adjust best length for extent start alignment. */
+	if (blen > args->alignment)
+		blen -= args->alignment;
+
 	/*
 	 * Since we used XFS_ALLOC_FLAG_TRYLOCK in _longest_free_extent(), it is
 	 * possible that there is enough contiguous free space for this request.
@@ -3310,6 +3314,7 @@ xfs_bmap_select_minlen(
 	if (blen < args->maxlen)
 		return blen;
 	return args->maxlen;
+
 }
 
 static int
@@ -3403,35 +3408,43 @@ xfs_bmap_alloc_account(
 	xfs_trans_mod_dquot_byino(ap->tp, ap->ip, fld, ap->length);
 }
 
-static int
+/*
+ * Calculate the extent start alignment and the extent length adjustments that
+ * constrain this allocation.
+ *
+ * Extent start alignment is currently determined by stripe configuration and is
+ * carried in args->alignment, whilst extent length adjustment is determined by
+ * extent size hints and is carried by args->prod and args->mod.
+ *
+ * Low level allocation code is free to either ignore or override these values
+ * as required.
+ */
+static void
 xfs_bmap_compute_alignments(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args)
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_extlen_t		align = 0; /* minimum allocation alignment */
-	int			stripe_align = 0;
 
 	/* stripe alignment for allocation is determined by mount parameters */
 	if (mp->m_swidth && xfs_has_swalloc(mp))
-		stripe_align = mp->m_swidth;
+		args->alignment = mp->m_swidth;
 	else if (mp->m_dalign)
-		stripe_align = mp->m_dalign;
+		args->alignment = mp->m_dalign;
 
 	if (ap->flags & XFS_BMAPI_COWFORK)
 		align = xfs_get_cowextsz_hint(ap->ip);
 	else if (ap->datatype & XFS_ALLOC_USERDATA)
 		align = xfs_get_extsz_hint(ap->ip);
+
 	if (align) {
 		if (xfs_bmap_extsize_align(mp, &ap->got, &ap->prev, align, 0,
 					ap->eof, 0, ap->conv, &ap->offset,
 					&ap->length))
 			ASSERT(0);
 		ASSERT(ap->length);
-	}
 
-	/* apply extent size hints if obtained earlier */
-	if (align) {
 		args->prod = align;
 		div_u64_rem(ap->offset, args->prod, &args->mod);
 		if (args->mod)
@@ -3446,7 +3459,6 @@ xfs_bmap_compute_alignments(
 			args->mod = args->prod - args->mod;
 	}
 
-	return stripe_align;
 }
 
 static void
@@ -3518,7 +3530,7 @@ xfs_bmap_exact_minlen_extent_alloc(
 	args.total = ap->total;
 
 	args.alignment = 1;
-	args.minalignslop = 0;
+	args.alignslop = 0;
 
 	args.minleft = ap->minleft;
 	args.wasdel = ap->wasdel;
@@ -3558,7 +3570,6 @@ xfs_bmap_btalloc_at_eof(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		blen,
-	int			stripe_align,
 	bool			ag_only)
 {
 	struct xfs_mount	*mp = args->mp;
@@ -3572,23 +3583,15 @@ xfs_bmap_btalloc_at_eof(
 	 * allocation.
 	 */
 	if (ap->offset) {
-		xfs_extlen_t	nextminlen = 0;
+		xfs_extlen_t	alignment = args->alignment;
 
 		/*
-		 * Compute the minlen+alignment for the next case.  Set slop so
-		 * that the value of minlen+alignment+slop doesn't go up between
-		 * the calls.
+		 * Compute the alignment slop for the fallback path so we ensure
+		 * we account for the potential alignemnt space required by the
+		 * fallback paths before we modify the AGF and AGFL here.
 		 */
 		args->alignment = 1;
-		if (blen > stripe_align && blen <= args->maxlen)
-			nextminlen = blen - stripe_align;
-		else
-			nextminlen = args->minlen;
-		if (nextminlen + stripe_align > args->minlen + 1)
-			args->minalignslop = nextminlen + stripe_align -
-					args->minlen - 1;
-		else
-			args->minalignslop = 0;
+		args->alignslop = alignment - args->alignment;
 
 		if (!caller_pag)
 			args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
@@ -3606,19 +3609,8 @@ xfs_bmap_btalloc_at_eof(
 		 * Exact allocation failed. Reset to try an aligned allocation
 		 * according to the original allocation specification.
 		 */
-		args->alignment = stripe_align;
-		args->minlen = nextminlen;
-		args->minalignslop = 0;
-	} else {
-		/*
-		 * Adjust minlen to try and preserve alignment if we
-		 * can't guarantee an aligned maxlen extent.
-		 */
-		args->alignment = stripe_align;
-		if (blen > args->alignment &&
-		    blen <= args->maxlen + args->alignment)
-			args->minlen = blen - args->alignment;
-		args->minalignslop = 0;
+		args->alignment = alignment;
+		args->alignslop = 0;
 	}
 
 	if (ag_only) {
@@ -3636,9 +3628,8 @@ xfs_bmap_btalloc_at_eof(
 		return 0;
 
 	/*
-	 * Allocation failed, so turn return the allocation args to their
-	 * original non-aligned state so the caller can proceed on allocation
-	 * failure as if this function was never called.
+	 * Aligned allocation failed, so all fallback paths from here drop the
+	 * start alignment requirement as we know it will not succeed.
 	 */
 	args->alignment = 1;
 	return 0;
@@ -3646,7 +3637,9 @@ xfs_bmap_btalloc_at_eof(
 
 /*
  * We have failed multiple allocation attempts so now are in a low space
- * allocation situation. Try a locality first full filesystem minimum length
+ * allocation situation. We give up on any attempt at aligned allocation here.
+ *
+ * Try a locality first full filesystem minimum length
  * allocation whilst still maintaining necessary total block reservation
  * requirements.
  *
@@ -3663,6 +3656,7 @@ xfs_bmap_btalloc_low_space(
 {
 	int			error;
 
+	args->alignment = 1;
 	if (args->minlen > ap->minlen) {
 		args->minlen = ap->minlen;
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
@@ -3682,13 +3676,11 @@ xfs_bmap_btalloc_low_space(
 static int
 xfs_bmap_btalloc_filestreams(
 	struct xfs_bmalloca	*ap,
-	struct xfs_alloc_arg	*args,
-	int			stripe_align)
+	struct xfs_alloc_arg	*args)
 {
 	xfs_extlen_t		blen = 0;
 	int			error = 0;
 
-
 	error = xfs_filestream_select_ag(ap, args, &blen);
 	if (error)
 		return error;
@@ -3707,8 +3699,7 @@ xfs_bmap_btalloc_filestreams(
 
 	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
 	if (ap->aeof)
-		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
-				true);
+		error = xfs_bmap_btalloc_at_eof(ap, args, blen, true);
 
 	if (!error && args->fsbno == NULLFSBLOCK)
 		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
@@ -3732,8 +3723,7 @@ xfs_bmap_btalloc_filestreams(
 static int
 xfs_bmap_btalloc_best_length(
 	struct xfs_bmalloca	*ap,
-	struct xfs_alloc_arg	*args,
-	int			stripe_align)
+	struct xfs_alloc_arg	*args)
 {
 	xfs_extlen_t		blen = 0;
 	int			error;
@@ -3757,8 +3747,7 @@ xfs_bmap_btalloc_best_length(
 	 * trying.
 	 */
 	if (ap->aeof && !(ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
-		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
-				false);
+		error = xfs_bmap_btalloc_at_eof(ap, args, blen, false);
 		if (error || args->fsbno != NULLFSBLOCK)
 			return error;
 	}
@@ -3785,27 +3774,26 @@ xfs_bmap_btalloc(
 		.resv		= XFS_AG_RESV_NONE,
 		.datatype	= ap->datatype,
 		.alignment	= 1,
-		.minalignslop	= 0,
+		.alignslop	= 0,
 	};
 	xfs_fileoff_t		orig_offset;
 	xfs_extlen_t		orig_length;
 	int			error;
-	int			stripe_align;
 
 	ASSERT(ap->length);
 	orig_offset = ap->offset;
 	orig_length = ap->length;
 
-	stripe_align = xfs_bmap_compute_alignments(ap, &args);
+	xfs_bmap_compute_alignments(ap, &args);
 
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = min(ap->length, mp->m_ag_max_usable);
 
 	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
 	    xfs_inode_is_filestream(ap->ip))
-		error = xfs_bmap_btalloc_filestreams(ap, &args, stripe_align);
+		error = xfs_bmap_btalloc_filestreams(ap, &args);
 	else
-		error = xfs_bmap_btalloc_best_length(ap, &args, stripe_align);
+		error = xfs_bmap_btalloc_best_length(ap, &args);
 	if (error)
 		return error;
 
-- 
2.43.0

