Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985D11CDFB4
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416263; cv=none; b=gGKjDXe/6gmZRcXNhz9Jpi3Ealb7oMstJIjj1cpZx331kT8Zi972CZCvoyFq77OPkkPvN0Yr2Lt+6xfdqjb0ZlbJzFBhGEUxe+b8PrCrmwCoxpLM/BZeXob5lBFGCm83tpWetPD6cFK0JeegTllvCcC7PLad91Fw1ZZTYa6ALqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416263; c=relaxed/simple;
	bh=9pSWW6myBYphmV/7ZWKjzJDBWqRUuXQMijVw2gnl2yQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cmd02TYzffURSl+D/r8SoMi10Meg7S4vSnwcQ/ruE6Jg5ax+CoHNnIwlGom9or/lB4GM48ZR/1uFceVLVg0ZPcGmWgzCdl4L+xtR3ApJnU973tstvgmHKdFJ0Zup2nBZeEX3JAH8YcWpmuVs7PMR/HHnoDqeL12acFIL+Zgr7Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUuUtmCb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUuUtmCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EF7C4CEC3;
	Thu, 31 Oct 2024 23:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416263;
	bh=9pSWW6myBYphmV/7ZWKjzJDBWqRUuXQMijVw2gnl2yQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JUuUtmCbuf5KP/PMnnL2LDTxAvSBA8MPaFssyJ3Y9XSVHnyaSBcMFISgqMQmynUF8
	 08jwlOA/43cUvI7fe8OjCeWLeZVC54s3w41IeiEaC4cj4Gam5Xma/OKLvjUg+qGTyc
	 N6mjnjJWN3mrg6PBY8/5NN/ST96wmlJdehjzQgQ7Ren38bIE1rzf5v04ZtEWZ8QOgl
	 3d3IagATHiHV6DcPayvFvc7IRCPG2duMBquc1jg2y20FhhWQeMC75TW5C17XJ6B49Z
	 OSA7+MFY6eutqOoUPRYFSyWGtGwmoa09doCBR1hifXMVMmLgml9sNCI7rMjMFS5myi
	 nYSbxTQzneX+A==
Date: Thu, 31 Oct 2024 16:11:02 -0700
Subject: [PATCH 09/41] xfs: remove the limit argument to xfs_rtfind_back
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566057.962545.5860918064169333508.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 119c65e56bc131b466a7cd958a4089e286ce3c4b

All callers pass a 0 limit to xfs_rtfind_back, so remove the argument
and hard code it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.c |    9 ++++-----
 libxfs/xfs_rtbitmap.h |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 58a3ba992f51cc..c7613f2de7b0a0 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -137,14 +137,13 @@ xfs_rtbuf_get(
 }
 
 /*
- * Searching backward from start to limit, find the first block whose
- * allocated/free state is different from start's.
+ * Searching backward from start find the first block whose allocated/free state
+ * is different from start's.
  */
 int
 xfs_rtfind_back(
 	struct xfs_rtalloc_args	*args,
 	xfs_rtxnum_t		start,	/* starting rtext to look at */
-	xfs_rtxnum_t		limit,	/* last rtext to look at */
 	xfs_rtxnum_t		*rtx)	/* out: start rtext found */
 {
 	struct xfs_mount	*mp = args->mp;
@@ -173,7 +172,7 @@ xfs_rtfind_back(
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
 	bit = (int)(start & (XFS_NBWORD - 1));
-	len = start - limit + 1;
+	len = start + 1;
 	/*
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
@@ -696,7 +695,7 @@ xfs_rtfree_range(
 	 * We need to find the beginning and end of the extent so we can
 	 * properly update the summary.
 	 */
-	error = xfs_rtfind_back(args, start, 0, &preblock);
+	error = xfs_rtfind_back(args, start, &preblock);
 	if (error) {
 		return error;
 	}
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 6186585f2c376d..1e04f0954a0fa7 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -316,7 +316,7 @@ xfs_rtsummary_read_buf(
 int xfs_rtcheck_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxlen_t len, int val, xfs_rtxnum_t *new, int *stat);
 int xfs_rtfind_back(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
-		xfs_rtxnum_t limit, xfs_rtxnum_t *rtblock);
+		xfs_rtxnum_t *rtblock);
 int xfs_rtfind_forw(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxnum_t limit, xfs_rtxnum_t *rtblock);
 int xfs_rtmodify_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,

