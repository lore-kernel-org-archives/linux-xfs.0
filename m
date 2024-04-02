Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6BB47A7A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 23:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712100615; cv=none; b=WNGHGDtS4o639WktU1lwupX9m/AOccZYHuCRxHCImg6vC1NNWqgUgH5Lx01x80iaCUH7UeEg3faetPoxF29z7V8sGW7UrobFAjRIfK2nio16SZedMzYd2wsCaAH/OuqCuBTwxUtzYMUzggWuWJB1Qgrf+rLAaAOVMgYrrrshTto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712100615; c=relaxed/simple;
	bh=XxNE5XuA3FOHpAnxx1aOsYa1bfR+4NUGy9EA4Kgkvhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz5xmaXw9E397WplTBiLa1V1adDLoLbtnQcI10ksafEAmNBp7+QLrzme1l3NyPvSEf6LxccCTLAlVpGDWdjXs8q4AJ270yZUerch14cKkWholW0cUUEa2zkkQ3YIX3uL8qbI0ADxL3VJOOFAmK08Bs/thvGoUjYfLi6+ZVgTuRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=cxsluApe; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="cxsluApe"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6ea838bf357so4626936b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 16:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712100613; x=1712705413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cCiVd/EKqlGc+KmzbIhWQ2lrcDlpYer4Wmh3xMARoY=;
        b=cxsluApe/i3KhKBLZHdmYX1TD5drl6et76Vb9rnBm7BsNy8AHid1lxUr6r1gY8S2s9
         K1PQHNQ+qEfiojsgKPrMd7N6Dcpk5LRhpLfWXqAYkG0bWTCD8EtVhOWsbZB+z1vMi9TN
         sJx9nt+muyaCqiQgpLgQxUzxPIcagr2jicztDGGKonEbARlA6/A4EWOaiOsx82Y3YMlc
         TW4YrBXy2Mkk1bXsUeOFOz9/a4r2KSR14lPSc11zxw3Z8+XchMlCKT8gfaQg/jZks3hc
         yfVoM4GnJk//Pe2D3NQrHZRdRFWlZO38l8TnyF+79rdnmsieLnOLCGwMweN7J/vrmtnQ
         4huA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712100613; x=1712705413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5cCiVd/EKqlGc+KmzbIhWQ2lrcDlpYer4Wmh3xMARoY=;
        b=TTRmyt0EeCwRKCZM8DOJ8iGEJxbpYBl4WgjRHWWAjV97XYzjWEyKt39ZwkWRF8i1QY
         PmJhbwNVNwuWAcXdcLxIERnadTwYaIfBeClgBswH9N6ebyhEXADJE6XNjIznW4/Jr88m
         iT71nRw8Wi1L8LN6p/IuITTFN4wb17PWjOKwy7a3Pcu43foGjilnWBt85fKZ78z0w/ER
         kJHsLMBKSDbXZTc1ljj02mEKDvPMvPVEG4ZcaGNTH8mBCtcvFL1e3eLy1E77TeaITPlJ
         JHFGQ33kG+0OkuX3FCOhwNhPfT8k12QVednMfmFH31WokhuZMh5Y9oh1WdTHDrwoTfd/
         qdhg==
X-Gm-Message-State: AOJu0YzLtbMVj6O98SGQyPPH0r5zimKBh8wiTtetCzhKMknrdm0qaEKB
	yj4gyZbamrJ9RgFU1Vj0uPFMl/o/IuaVVnU4BIEDynBuMT72tcw6/Od8wa4R9BTfRRs0tKN/0pL
	z
X-Google-Smtp-Source: AGHT+IE18/kBq+7XMAqgCGaXHq/E8eTj/mBYU5Nr0pAztEk5PgxUb60Oiq7UgwTq8OaarcCMo0yI6Q==
X-Received: by 2002:a05:6a20:3096:b0:1a3:e25f:3c17 with SMTP id 22-20020a056a20309600b001a3e25f3c17mr10852668pzn.29.1712100612775;
        Tue, 02 Apr 2024 16:30:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id n20-20020a6563d4000000b005f05c88c149sm9101331pgv.71.2024.04.02.16.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 16:30:11 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrnZx-001syO-29;
	Wed, 03 Apr 2024 10:30:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrnZx-000000054rP-0j05;
	Wed, 03 Apr 2024 10:30:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: john.g.garry@oracle.com
Subject: [PATCH 4/5] xfs: make EOF allocation simpler
Date: Wed,  3 Apr 2024 10:28:43 +1100
Message-ID: <20240402233006.1210262-5-david@fromorbit.com>
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

Currently the allocation at EOF is broken into two cases - when the
offset is zero and when the offset is non-zero. When the offset is
non-zero, we try to do exact block allocation for contiguous
extent allocation. When the offset is zero, the allocation is simply
an aligned allocation.

We want aligned allocation as the fallback when exact block
allocation fails, but that complicates the EOF allocation in that it
now has to handle two different allocation cases. The
caller also has to handle allocation when not at EOF, and for the
upcoming forced alignment changes we need that to also be aligned
allocation.

To simplify all this, pull the aligned allocation cases back into
the callers and leave the EOF allocation path for exact block
allocation only. This means that the EOF exact block allocation
fallback path is the normal aligned allocation path and that ends up
making things a lot simpler when forced alignment is introduced.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c   | 131 +++++++++++++++----------------------
 fs/xfs/libxfs/xfs_ialloc.c |   8 +--
 fs/xfs/xfs_trace.h         |   8 +--
 3 files changed, 62 insertions(+), 85 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d56c82c07505..c2ddf1875e52 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3320,12 +3320,12 @@ xfs_bmap_select_minlen(
 static int
 xfs_bmap_btalloc_select_lengths(
 	struct xfs_bmalloca	*ap,
-	struct xfs_alloc_arg	*args,
-	xfs_extlen_t		*blen)
+	struct xfs_alloc_arg	*args)
 {
 	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno, startag;
+	xfs_extlen_t		blen = 0;
 	int			error = 0;
 
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
@@ -3339,19 +3339,18 @@ xfs_bmap_btalloc_select_lengths(
 	if (startag == NULLAGNUMBER)
 		startag = 0;
 
-	*blen = 0;
 	for_each_perag_wrap(mp, startag, agno, pag) {
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+		error = xfs_bmap_longest_free_extent(pag, args->tp, &blen);
 		if (error && error != -EAGAIN)
 			break;
 		error = 0;
-		if (*blen >= args->maxlen)
+		if (blen >= args->maxlen)
 			break;
 	}
 	if (pag)
 		xfs_perag_rele(pag);
 
-	args->minlen = xfs_bmap_select_minlen(ap, args, *blen);
+	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
 	return error;
 }
 
@@ -3561,78 +3560,40 @@ xfs_bmap_exact_minlen_extent_alloc(
  * If we are not low on available data blocks and we are allocating at
  * EOF, optimise allocation for contiguous file extension and/or stripe
  * alignment of the new extent.
- *
- * NOTE: ap->aeof is only set if the allocation length is >= the
- * stripe unit and the allocation offset is at the end of file.
  */
 static int
 xfs_bmap_btalloc_at_eof(
 	struct xfs_bmalloca	*ap,
-	struct xfs_alloc_arg	*args,
-	xfs_extlen_t		blen,
-	bool			ag_only)
+	struct xfs_alloc_arg	*args)
 {
 	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*caller_pag = args->pag;
+	xfs_extlen_t		alignment = args->alignment;
 	int			error;
 
+	ASSERT(ap->aeof && ap->offset);
+	ASSERT(args->alignment >= 1);
+
 	/*
-	 * If there are already extents in the file, try an exact EOF block
-	 * allocation to extend the file as a contiguous extent. If that fails,
-	 * or it's the first allocation in a file, just try for a stripe aligned
-	 * allocation.
+	 * Compute the alignment slop for the fallback path so we ensure
+	 * we account for the potential alignemnt space required by the
+	 * fallback paths before we modify the AGF and AGFL here.
 	 */
-	if (ap->offset) {
-		xfs_extlen_t	alignment = args->alignment;
-
-		/*
-		 * Compute the alignment slop for the fallback path so we ensure
-		 * we account for the potential alignemnt space required by the
-		 * fallback paths before we modify the AGF and AGFL here.
-		 */
-		args->alignment = 1;
-		args->alignslop = alignment - args->alignment;
-
-		if (!caller_pag)
-			args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
-		error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
-		if (!caller_pag) {
-			xfs_perag_put(args->pag);
-			args->pag = NULL;
-		}
-		if (error)
-			return error;
-
-		if (args->fsbno != NULLFSBLOCK)
-			return 0;
-		/*
-		 * Exact allocation failed. Reset to try an aligned allocation
-		 * according to the original allocation specification.
-		 */
-		args->alignment = alignment;
-		args->alignslop = 0;
-	}
-
-	if (ag_only) {
-		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
-	} else {
+	args->alignment = 1;
+	args->alignslop = alignment - args->alignment;
+
+	if (!caller_pag)
+		args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
+	error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
+	if (!caller_pag) {
+		xfs_perag_put(args->pag);
 		args->pag = NULL;
-		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
-		ASSERT(args->pag == NULL);
-		args->pag = caller_pag;
 	}
-	if (error)
-		return error;
 
-	if (args->fsbno != NULLFSBLOCK)
-		return 0;
-
-	/*
-	 * Aligned allocation failed, so all fallback paths from here drop the
-	 * start alignment requirement as we know it will not succeed.
-	 */
-	args->alignment = 1;
-	return 0;
+	/* Reset alignment to original specifications.  */
+	args->alignment = alignment;
+	args->alignslop = 0;
+	return error;
 }
 
 /*
@@ -3698,12 +3659,19 @@ xfs_bmap_btalloc_filestreams(
 	}
 
 	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
-	if (ap->aeof)
-		error = xfs_bmap_btalloc_at_eof(ap, args, blen, true);
+	if (ap->aeof && ap->offset)
+		error = xfs_bmap_btalloc_at_eof(ap, args);
 
+	/* This may be an aligned allocation attempt. */
 	if (!error && args->fsbno == NULLFSBLOCK)
 		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
 
+	/* Attempt non-aligned allocation if we haven't already. */
+	if (!error && args->fsbno == NULLFSBLOCK && args->alignment > 1)  {
+		args->alignment = 1;
+		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
+	}
+
 out_low_space:
 	/*
 	 * We are now done with the perag reference for the filestreams
@@ -3725,7 +3693,6 @@ xfs_bmap_btalloc_best_length(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args)
 {
-	xfs_extlen_t		blen = 0;
 	int			error;
 
 	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
@@ -3736,23 +3703,33 @@ xfs_bmap_btalloc_best_length(
 	 * the request.  If one isn't found, then adjust the minimum allocation
 	 * size to the largest space found.
 	 */
-	error = xfs_bmap_btalloc_select_lengths(ap, args, &blen);
+	error = xfs_bmap_btalloc_select_lengths(ap, args);
 	if (error)
 		return error;
 
 	/*
-	 * Don't attempt optimal EOF allocation if previous allocations barely
-	 * succeeded due to being near ENOSPC. It is highly unlikely we'll get
-	 * optimal or even aligned allocations in this case, so don't waste time
-	 * trying.
+	 * If we are in low space mode, then optimal allocation will fail so
+	 * prepare for minimal allocation and run the low space algorithm
+	 * immediately.
 	 */
-	if (ap->aeof && !(ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
-		error = xfs_bmap_btalloc_at_eof(ap, args, blen, false);
-		if (error || args->fsbno != NULLFSBLOCK)
-			return error;
+	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
+		ASSERT(args->fsbno == NULLFSBLOCK);
+		return xfs_bmap_btalloc_low_space(ap, args);
+	}
+
+	if (ap->aeof && ap->offset)
+		error = xfs_bmap_btalloc_at_eof(ap, args);
+
+	/* This may be an aligned allocation attempt. */
+	if (!error && args->fsbno == NULLFSBLOCK)
+		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
+
+	/* Attempt non-aligned allocation if we haven't already. */
+	if (!error && args->fsbno == NULLFSBLOCK && args->alignment > 1)  {
+		args->alignment = 1;
+		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	}
 
-	error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error || args->fsbno != NULLFSBLOCK)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index e5ac3e5430c4..11116838ed71 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -758,12 +758,12 @@ xfs_ialloc_ag_alloc(
 		 *
 		 * For an exact allocation, alignment must be 1,
 		 * however we need to take cluster alignment into account when
-		 * fixing up the freelist. Use the minalignslop field to
+		 * fixing up the freelist. Use the alignslop field to
 		 * indicate that extra blocks might be required for alignment,
 		 * but not to use them in the actual exact allocation.
 		 */
 		args.alignment = 1;
-		args.minalignslop = igeo->cluster_align - 1;
+		args.alignslop = igeo->cluster_align - 1;
 
 		/* Allow space for the inode btree to split. */
 		args.minleft = igeo->inobt_maxlevels;
@@ -780,10 +780,10 @@ xfs_ialloc_ag_alloc(
 		 * the exact agbno requirement and increase the alignment
 		 * instead. It is critical that the total size of the request
 		 * (len + alignment + slop) does not increase from this point
-		 * on, so reset minalignslop to ensure it is not included in
+		 * on, so reset alignslop to ensure it is not included in
 		 * subsequent requests.
 		 */
-		args.minalignslop = 0;
+		args.alignslop = 0;
 	}
 
 	if (unlikely(args.fsbno == NULLFSBLOCK)) {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index aea97fc074f8..14679d64558a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1800,7 +1800,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__field(xfs_extlen_t, minleft)
 		__field(xfs_extlen_t, total)
 		__field(xfs_extlen_t, alignment)
-		__field(xfs_extlen_t, minalignslop)
+		__field(xfs_extlen_t, alignslop)
 		__field(xfs_extlen_t, len)
 		__field(char, wasdel)
 		__field(char, wasfromfl)
@@ -1819,7 +1819,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__entry->minleft = args->minleft;
 		__entry->total = args->total;
 		__entry->alignment = args->alignment;
-		__entry->minalignslop = args->minalignslop;
+		__entry->alignslop = args->alignslop;
 		__entry->len = args->len;
 		__entry->wasdel = args->wasdel;
 		__entry->wasfromfl = args->wasfromfl;
@@ -1828,7 +1828,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__entry->highest_agno = args->tp->t_highest_agno;
 	),
 	TP_printk("dev %d:%d agno 0x%x agbno 0x%x minlen %u maxlen %u mod %u "
-		  "prod %u minleft %u total %u alignment %u minalignslop %u "
+		  "prod %u minleft %u total %u alignment %u alignslop %u "
 		  "len %u wasdel %d wasfromfl %d resv %d "
 		  "datatype 0x%x highest_agno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -1841,7 +1841,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		  __entry->minleft,
 		  __entry->total,
 		  __entry->alignment,
-		  __entry->minalignslop,
+		  __entry->alignslop,
 		  __entry->len,
 		  __entry->wasdel,
 		  __entry->wasfromfl,
-- 
2.43.0

