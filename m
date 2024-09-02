Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D6E19CC10
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301497; cv=none; b=ZgtjHvqvGB/au1cWV3K8yD4T7AqSh6AuPlevsxNZWc96TprWxBrtrEXBz7C+6zbbv4VGKD8q+j8M76cPQFkQlehB8jUdQ4HeaBs2CgCuXJcra9POoE67Htq3ghtT8vmV0h2iZxlpvGe4MZuj6IjsZRccAFHMJcy1VXMzg1fPl/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301497; c=relaxed/simple;
	bh=s3CbncoiCGEnLIyni8gzhm4R/gaBqkvHEDBz8emzatA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r1hKuM6pVL/QH528KDfSnFo8jXxnjPGyP3uXJr2QA3EbOjq1xd90KVDKmJBTSZBv4bKnFmYvs3VFWDNuB+D7t0YBZMGted2p3N65eqecvBIMgWJu+tXD8EvlnvwpIzjAmoiDa6tz+JmelWrsQZ9iPOAlNrSkbD2cE0arDwkZ8cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LykO7/vA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LykO7/vA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61133C4CEC2;
	Mon,  2 Sep 2024 18:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301497;
	bh=s3CbncoiCGEnLIyni8gzhm4R/gaBqkvHEDBz8emzatA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LykO7/vAS7W/LzfptfXYTU+1IiPZP9rFEAGXY/RbMmST/U0vAFoDvLv3bibjHvbcr
	 HjuMHkAz7uYqpHq+KukNZtjqY2d0n2dAmZLTbpQYPKzQJiMhCcCAo4js41PJTxwWc+
	 4MrFOy0yN+dNb5NL3oe+PZTn0kxKmn4sTFghS4PsZrh6RHoX9MEFVpnq8qRJ8W9YN/
	 PGdeILLcJniUaiLVlGo+kCNpMPG39Sw9voVFLi3Q/cbczbHRZIH2UoudtAGCCItsr+
	 CMbwt7IkC7+ckVzMMgHZUP0pxjBMrzV9NjxDOjHEwBGIh9NifA2KgPgZ7H1dMxELPI
	 ebEXv/gEYW1dw==
Date: Mon, 02 Sep 2024 11:24:56 -0700
Subject: [PATCH 04/12] xfs: remove the limit argument to xfs_rtfind_back
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530105781.3325146.12002294989045841517.stgit@frogsfrogsfrogs>
In-Reply-To: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
References: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

All callers pass a 0 limit to xfs_rtfind_back, so remove the argument
and hard code it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    9 ++++-----
 fs/xfs/libxfs/xfs_rtbitmap.h |    2 +-
 fs/xfs/xfs_rtalloc.c         |    2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 386b672c5058..9feeefe53948 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -139,14 +139,13 @@ xfs_rtbuf_get(
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
@@ -175,7 +174,7 @@ xfs_rtfind_back(
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
 	bit = (int)(start & (XFS_NBWORD - 1));
-	len = start - limit + 1;
+	len = start + 1;
 	/*
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
@@ -698,7 +697,7 @@ xfs_rtfree_range(
 	 * We need to find the beginning and end of the extent so we can
 	 * properly update the summary.
 	 */
-	error = xfs_rtfind_back(args, start, 0, &preblock);
+	error = xfs_rtfind_back(args, start, &preblock);
 	if (error) {
 		return error;
 	}
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 6186585f2c37..1e04f0954a0f 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -316,7 +316,7 @@ xfs_rtsummary_read_buf(
 int xfs_rtcheck_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxlen_t len, int val, xfs_rtxnum_t *new, int *stat);
 int xfs_rtfind_back(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
-		xfs_rtxnum_t limit, xfs_rtxnum_t *rtblock);
+		xfs_rtxnum_t *rtblock);
 int xfs_rtfind_forw(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxnum_t limit, xfs_rtxnum_t *rtblock);
 int xfs_rtmodify_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 26eab1b408c8..3728445b0b1c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -142,7 +142,7 @@ xfs_rtallocate_range(
 	 * We need to find the beginning and end of the extent so we can
 	 * properly update the summary.
 	 */
-	error = xfs_rtfind_back(args, start, 0, &preblock);
+	error = xfs_rtfind_back(args, start, &preblock);
 	if (error)
 		return error;
 

