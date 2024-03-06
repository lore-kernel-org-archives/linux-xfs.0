Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5B91BDD8
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 05:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709703059; cv=none; b=EfWxOzjJ7WtOYw7bIuLvseccUKSP1LwXVAZO5jecnuOaifvABU6ILqwK65LZXptugrBCBZQyoYoP1I58uQpTxkbfA5Ujq5jt0T1CRVkwKIvH6Y1Tl/IhAhOVXQ+AoQDyn+1ZnkLiCl/Kf+vdlDXeySgnf/MTvm2n1KCgnjASFr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709703059; c=relaxed/simple;
	bh=bRPDbLegIlHI/KX8OVWL/MVikBHbDoG312f74IILN7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONjlNKs5KWwHapwH6JJ8k+hlReubaIXr+zyKP5SPR3kKcXTXtYwjjTpmgYttBF6o1B+FIOFj2Wt2s7hzyDxPXMF+WG5FtQiQIkxtRRJSnVpn9HPraKcQ6nY1sSvFf9vsbnl3zeCHmhnL5mdM0JGW+/bcTUGtVR9mCa4cQAAmBJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=N+24URun; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="N+24URun"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3c1a7d51fb5so4679829b6e.1
        for <linux-xfs@vger.kernel.org>; Tue, 05 Mar 2024 21:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709703056; x=1710307856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VZATziKQVkaFM7gGLG8f9hawB3Zsuyy39oUv5WlJeko=;
        b=N+24URun3thh/uK12E7E1ktcSi8H5Lig4ED77ZANrIyBfVURK4HJ09W9/Wwy9QX2dx
         19wiNz3iSego9+KrV9bhZ1pfcT/6fX9I2yG1e2Q2TOYbYpjn2qEEKpstvxu8tXtYHGdu
         kNYhOmIQmSi+OIgYTpQ19E+RFbctcL/CVwZS+glmrco4MFbrJ1iIFbPncl3hZIG2SqVK
         he9dCV/HrEEBBTXRvUCvohpvIGVeK8n89SYyMe+NwDqbMRbkEUGlmMRObbXTjkctb1sj
         dulQx0aU7JISKGEyguTrmXA/U+HYHe8rUgYPqm/GMKd9umfjWvnB5W5ci60p6KhUgi6n
         PeJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709703056; x=1710307856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VZATziKQVkaFM7gGLG8f9hawB3Zsuyy39oUv5WlJeko=;
        b=XccrtgqrToCXdxCs/KkwObfiWUbkYsHEaWrda9wszZarAvix9AAjaxlr0Ivsn796TY
         RBak8TMSGpY291Tyug4EXAWzfLFkgYdYQm4NdJRY93XYZe58cC4PSgnG7pOqPr3Bjvkd
         oQQl0Xt6ty3HQ51lnkimLIzCHlaujzs81edtfecYqIIKpozFUcEUIsU9u5oLRlhXz01c
         7MFkYlXZ63veKv39R+6ljw0U5X6E8inGKtrnagUyrmuRl+LzrSH73XP3wseRepmomup/
         ROrg/ZzWqXVpNjarDEZVSaUK8Wz0bknQNl0pHxdl3aSc6EaukwptvQgtaiRJGdxHY7Z0
         SvUw==
X-Gm-Message-State: AOJu0YxTB1Lj0QK4nEAUN1EdMmjYwIv4VvY+50BSwy7RHtGu4O78xJRU
	C2qORhk2AfoXQOB6Y+qZ6IXfFT9l8C68Lse2X7YUrYZlqNVyATlypmNvS+I/heCAiTEvGzgEzg1
	N
X-Google-Smtp-Source: AGHT+IEgC+HaNtVfhsOiqdGmCC2kTZLuiNV1vAwn0GGXnXMKuDCxVuiXTu9qaUNjGi0AZYcRRnTlrg==
X-Received: by 2002:aca:2102:0:b0:3c1:ea1d:74e with SMTP id 2-20020aca2102000000b003c1ea1d074emr3501190oiz.37.1709703056314;
        Tue, 05 Mar 2024 21:30:56 -0800 (PST)
Received: from dread.disaster.area (pa49-181-192-230.pa.nsw.optusnet.com.au. [49.181.192.230])
        by smtp.gmail.com with ESMTPSA id c2-20020a62e802000000b006e1463c18f8sm9964120pfi.37.2024.03.05.21.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 21:30:55 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rhjrg-00FfkD-1U;
	Wed, 06 Mar 2024 16:30:52 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rhjrf-00000006xM2-4AXZ;
	Wed, 06 Mar 2024 16:30:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: john.g.garry@oracle.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com
Subject: [PATCH 1/3] xfs: simplify extent allocation alignment
Date: Wed,  6 Mar 2024 16:20:11 +1100
Message-ID: <20240306053048.1656747-2-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240306053048.1656747-1-david@fromorbit.com>
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
 <20240306053048.1656747-1-david@fromorbit.com>
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
 fs/xfs/libxfs/xfs_alloc.c |  2 +-
 fs/xfs/libxfs/xfs_alloc.h |  2 +-
 fs/xfs/libxfs/xfs_bmap.c  | 96 +++++++++++++++++----------------------
 3 files changed, 44 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9da52e92172a..5ed9c8a96e32 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2395,7 +2395,7 @@ xfs_alloc_space_available(
 	reservation = xfs_ag_resv_needed(pag, args->resv);
 
 	/* do we have enough contiguous free space for the allocation? */
-	alloc_len = args->minlen + (args->alignment - 1) + args->minalignslop;
+	alloc_len = args->minlen + (args->alignment - 1) + args->alignslop;
 	longest = xfs_alloc_longest_free_extent(pag, min_free, reservation);
 	if (longest < alloc_len)
 		return false;
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

