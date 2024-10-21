Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A64194AF6
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548077; cv=none; b=QQByR5pbYaxpT9xxWzjL+ZjuxpSM8rFfC4SHYfmbjeIjP0Fs70bQ1oX5GZznqJcXusWKhTEUyEQ/JYuxegu4D/f0aCjydRpcUenF4XMub39LXtelSRdijdImatTQvJiMxqjTyHm5ksDxYLLl0H9Mxbz0eQrnzMxxM3q29mvTSl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548077; c=relaxed/simple;
	bh=9pSWW6myBYphmV/7ZWKjzJDBWqRUuXQMijVw2gnl2yQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LjA896sbhp8aPkI1iEt6N3GjlKsRk7HU7o3hr2Hz+I80QQy+eFRQxqHOMFyeZGL17767Pr+1e7kwI3N2Jfz2JxI+qRV4tdu2r4y0qO8K1gOAqAZP/PlyPcso/C5b8SB7DDsI3z3FkrgnKCAZs1+p0NH1mHk5nOT55jxSqfHX2+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IvqvUR9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IvqvUR9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF16C4CEC3;
	Mon, 21 Oct 2024 22:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548076;
	bh=9pSWW6myBYphmV/7ZWKjzJDBWqRUuXQMijVw2gnl2yQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IvqvUR9DX9AVBEVtfta/ipuxr4TJExzTvS4cZw2P2KRr+sjT5hGDUJ3Mkc2cgXfmG
	 pVF7EeXVjTAxQHaceCpTS7Npl20QmpotL+PVGMSMeyacuCzC991So0THEt08FCYQvE
	 ZZKmdmuccnpCgySsQCOLxewIO9xJIHku0k81vwsqe/so8xgCGrvrEH84mt/lYdjWGF
	 aplSKYcl8TXVEvm9oONEF2JMH3C7KGRi4BIS+SyYWl7pGHALm/rJrUGi9CDuq3h9sI
	 9Kh6azR/M6D+c8DtNcqXI6oWLQjfVPvW6G2k3Gb15DDBvpSdAtI5K70tWmPk2+R8wI
	 wLE7SQEejgv6g==
Date: Mon, 21 Oct 2024 15:01:16 -0700
Subject: [PATCH 09/37] xfs: remove the limit argument to xfs_rtfind_back
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783608.34558.107625526634874383.stgit@frogsfrogsfrogs>
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

