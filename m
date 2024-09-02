Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A955680
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301732; cv=none; b=lx49MehRgKtVotno1lHnqCt6CxsVuC8GhvFHVoxelhcVnQrMUq9K4NApFMAZGF4vak71kGWHQ2Pf70meERS9gZS2K6n6lC9qE91XRzYRfFXg8q6BA7Ibpnxvieb+8yutW9Nx6h3FFP138uqGIh3SYt61OVv9QqYViAxUGZcdW8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301732; c=relaxed/simple;
	bh=U1VhHsU7ZONDqTwVBFS6swHjKxPOKhSxxvXPdrrEeR0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NAbAyPt/XyHbibf/PhP+lraYaaV3YnhKgaUD26tY0G4QX3X/YhaKoFAZqdc9nQc9x8mPGqAdRvgtR9lWtmheb5U11K3fDVXJohi+1HfzeOPK10CuBF/DSn8szs6GfXexrIvAN7qesy515gx40446yrCD1jzZ7Vlx6f0gENPuNKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VBn0YY+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VBn0YY+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A345C4CEC2;
	Mon,  2 Sep 2024 18:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301732;
	bh=U1VhHsU7ZONDqTwVBFS6swHjKxPOKhSxxvXPdrrEeR0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VBn0YY+6+a5QJloyHpp6IPWKRjzakDG0VAe3YRaQMmGyS9NZQQ50gwJqTGvnUhQLC
	 hwhQ6AvCrzKE79wqQeMEcOz4i7wasl5RI/r3Sgv6sFxB4Ygn25+mKzRBPrJAEQfpqV
	 lUGFoqtCkDjztIh4FlNkOSfOHwdgPCZNMeBBun3dTdcAoPFZX86cAMrEs3cicXgrTP
	 kJNsq/8PsGYmqLg+6+vOGkwh5DZuEQUqYgUvxX747DWDA1s3yj1FNI9YjWyUr/orI2
	 +ljUn0z00rraUFc5MZ6LFCFSnSIUgA0c4FshKkclWTnDd64UzrusvP7ub8a6vc8GZc
	 DiqQKe1xoO7MQ==
Date: Mon, 02 Sep 2024 11:28:51 -0700
Subject: [PATCH 07/10] xfs: reduce excessive clamping of maxlen in
 xfs_rtallocate_extent_near
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106373.3325667.13490918837169434701.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
References: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The near rt allocator employs two allocation strategies -- first it
tries to allocate at exactly @start.  If that fails, it will pivot back
and forth around that starting point looking for an appropriately sized
free space.

However, I clamped maxlen ages ago to prevent the exact allocation scan
from running off the end of the rt volume.  This, I realize, was
excessive.  If the allocation request is (say) for 32 rtx but the start
position is 5 rtx from the end of the volume, we clamp maxlen to 5.  If
the exact allocation fails, we then pivot back and forth looking for 5
rtx, even though the original intent was to try to get 32 rtx.

If we then find 5 rtx when we could have gotten 32 rtx, we've not done
as well as we could have.  This may be moot if the caller immediately
comes back for more space, but it might not be.  Either way, we can do
better here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index af357704895d..d27bfec08ef8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -338,23 +338,29 @@ xfs_rtallocate_extent_exact(
 	xfs_rtxlen_t		prod,	/* extent product factor */
 	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
 {
+	struct xfs_mount	*mp = args->mp;
 	xfs_rtxnum_t		next;	/* next rtext to try (dummy) */
 	xfs_rtxlen_t		alloclen; /* candidate length */
+	xfs_rtxlen_t		scanlen; /* number of free rtx to look for */
 	int			isfree;	/* extent is free */
 	int			error;
 
 	ASSERT(minlen % prod == 0);
 	ASSERT(maxlen % prod == 0);
-	/*
-	 * Check if the range in question (for maxlen) is free.
-	 */
-	error = xfs_rtcheck_range(args, start, maxlen, 1, &next, &isfree);
+
+	/* Make sure we don't run off the end of the rt volume. */
+	scanlen = xfs_rtallocate_clamp_len(mp, start, maxlen, prod);
+	if (scanlen < minlen)
+		return -ENOSPC;
+
+	/* Check if the range in question (for scanlen) is free. */
+	error = xfs_rtcheck_range(args, start, scanlen, 1, &next, &isfree);
 	if (error)
 		return error;
 
 	if (isfree) {
-		/* start to maxlen is all free; allocate it. */
-		*len = maxlen;
+		/* start to scanlen is all free; allocate it. */
+		*len = scanlen;
 		*rtx = start;
 		return 0;
 	}
@@ -410,11 +416,6 @@ xfs_rtallocate_extent_near(
 	if (start >= mp->m_sb.sb_rextents)
 		start = mp->m_sb.sb_rextents - 1;
 
-	/* Make sure we don't run off the end of the rt volume. */
-	maxlen = xfs_rtallocate_clamp_len(mp, start, maxlen, prod);
-	if (maxlen < minlen)
-		return -ENOSPC;
-
 	/*
 	 * Try the exact allocation first.
 	 */

