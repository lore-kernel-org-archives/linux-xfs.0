Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1952CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548484; cv=none; b=VLuKvd50M6FByndvf0PUBWFFtp6zUtHz+iQudyeeIqKcddpO8DQucd/KMn0xfjDNuM4qV0KD7f77JGsYVwNG7alCthPMp7i+RH7rYYhmdejK7nM/9vzUBb9ZAylZbULq8HlNsfxQclh3lLpaVa+5tyux8zy92XrAkGGAr0Hp9vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548484; c=relaxed/simple;
	bh=boiVlnQxhES0BwY8QAKEQCXjPoKUQWcAkStRUX+XxmE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TlYozI/N6BKpnAQqHYLFOt89OnvXuY3QAPbNGU3oFHzQB4Gos1k9UzXde8bx5xjjurUMURVLOJCmTiqnapFNGmp7yAAWyyCWirGcMhxFA+3GwdMQG5/gHjVH401WiZoPDRQa+W/PWaNvquKkqiVXMYdwq0HP355GntCveP0GRVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pVRn5zkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pVRn5zkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4805C4CEC3;
	Mon, 21 Oct 2024 22:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548483;
	bh=boiVlnQxhES0BwY8QAKEQCXjPoKUQWcAkStRUX+XxmE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pVRn5zkINOiSS5Q+Rq+UlApnxjbqDOuxO2X45Hp0Pr55LPqqA72fJn1IzF2juC4UP
	 Yu1iVbyqQUlUyC68t3yIZoCu2wiz5655XlZ5zsywyYiI1OUSnElRtj5wXdcLbwTOPi
	 GeTfxYI+ajA+XqWnWxrQswC4RsKozqXaoR6vP+X5LoYGpJidCqoHgdCDjN0joeTTMB
	 JcrVysq90d4F+pT1WA1zjFdDh6wjkEzlUbCgtTdSBYFMDqgFCOVzvXSIEfpkbMKlgm
	 oA/PDh7fkkxy0TpUWnsst7bWECcNHl+LCwSeq8IBAvCaOt9SJID1o00Icm9n1DVpta
	 77mAM+8XXaYjQ==
Date: Mon, 21 Oct 2024 15:08:03 -0700
Subject: [PATCH 35/37] xfs: don't ifdef around the exact minlen allocations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954784001.34558.14414142539970772501.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b611fddc0435738e64453bbf1dadd4b12a801858

Exact minlen allocations only exist as an error injection tool for debug
builds.  Currently this is implemented using ifdefs, which means the code
isn't even compiled for non-XFS_DEBUG builds.  Enhance the compile test
coverage by always building the code and use the compilers' dead code
elimination to remove it from the generated binary instead.

The only downside is that the alloc_minlen_only field is unconditionally
added to struct xfs_alloc_args now, but by moving it around and packing
it tightly this doesn't actually increase the size of the structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_alloc.c |    7 ++-----
 libxfs/xfs_alloc.h |    4 +---
 libxfs/xfs_bmap.c  |    6 ------
 3 files changed, 3 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 3806a6bc0835a7..61453709ae515c 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2762,7 +2762,6 @@ xfs_alloc_commit_autoreap(
 		xfs_defer_item_unpause(tp, aarp->dfp);
 }
 
-#ifdef DEBUG
 /*
  * Check if an AGF has a free extent record whose length is equal to
  * args->minlen.
@@ -2802,7 +2801,6 @@ xfs_exact_minlen_extent_available(
 
 	return error;
 }
-#endif
 
 /*
  * Decide whether to use this allocation group for this allocation.
@@ -2876,15 +2874,14 @@ xfs_alloc_fix_freelist(
 	if (!xfs_alloc_space_available(args, need, alloc_flags))
 		goto out_agbp_relse;
 
-#ifdef DEBUG
-	if (args->alloc_minlen_only) {
+	if (IS_ENABLED(CONFIG_XFS_DEBUG) && args->alloc_minlen_only) {
 		int stat;
 
 		error = xfs_exact_minlen_extent_available(args, agbp, &stat);
 		if (error || !stat)
 			goto out_agbp_relse;
 	}
-#endif
+
 	/*
 	 * Make the freelist shorter if it's too long.
 	 *
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index fae170825be064..0165452e7cd055 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -53,11 +53,9 @@ typedef struct xfs_alloc_arg {
 	int		datatype;	/* mask defining data type treatment */
 	char		wasdel;		/* set if allocation was prev delayed */
 	char		wasfromfl;	/* set if allocation is from freelist */
+	bool		alloc_minlen_only; /* allocate exact minlen extent */
 	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 	enum xfs_ag_resv_type	resv;	/* block reservation to use */
-#ifdef DEBUG
-	bool		alloc_minlen_only; /* allocate exact minlen extent */
-#endif
 } xfs_alloc_arg_t;
 
 /*
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index af493836ecc7ea..3c4922424f3fd0 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3471,7 +3471,6 @@ xfs_bmap_process_allocated_extent(
 	xfs_bmap_alloc_account(ap);
 }
 
-#ifdef DEBUG
 static int
 xfs_bmap_exact_minlen_extent_alloc(
 	struct xfs_bmalloca	*ap)
@@ -3533,11 +3532,6 @@ xfs_bmap_exact_minlen_extent_alloc(
 
 	return 0;
 }
-#else
-
-#define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
-
-#endif
 
 /*
  * If we are not low on available data blocks and we are allocating at

