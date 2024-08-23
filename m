Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8D0620
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372002; cv=none; b=dSRmsTEEtRa8dK1aFkNOYxxXpGvLGmAJIgHqLtDkfUe0tmE58DLRrIggShf/uUJ9EJ0ImbWopX2oazmufly3NzCGRy/hgECd6l4A/UopYmI6fF9L98/vS1KbJNwoHMwNYW5vx6gCUmFpx/cXcNgftX+aAYPRVL5bk722RwzIkCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372002; c=relaxed/simple;
	bh=R/CbXvZiPxXm7EUKkHTnQ4645IJ2vIpsy39qfAEwmmk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oLcrXiUsC3kchbAy6I4gZqepFphVLa1CzGnxSLZdcmbEHtW2miQANAV1AGmWXmlq9SoeIXEPraKg+15kAK8npRTNNIuvzYpez0IVpv57DNU7cAeQJHzY/7ohXkf7qBFrehygL6ijP10cgM5QPNJWpvSmnZxcNpdq8fjI43yp/zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SP2wrvwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SP2wrvwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EC9C4AF0B;
	Fri, 23 Aug 2024 00:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372002;
	bh=R/CbXvZiPxXm7EUKkHTnQ4645IJ2vIpsy39qfAEwmmk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SP2wrvwf+4yfhA1PCx/hydLn0CfwNY8BT5ywmm5y8glMO/AavL/4iwMDm3PzMjMUO
	 pwX5jDGlpG1SA5AkBPdfNItLxQ++dLWTAyJgXkqv0uD9SCVG5LJk+OxHm9DVgPpSIW
	 WA3Efx3OWq7M1KKbKPeAFQueXmBqgqq8TcN12fOkfsC/UlUpcTRbUKMnTxEQsgHwq5
	 3TwJmr9/QEXPATfl+b/ojV3JGZZtYH8yLrd1imsnE/as3/JD7Hu/SJo6wxoTWI+mK1
	 rFeNyRcoK9EZXigeCwQPXAM+5hvilVt5masIJ9nYaHQKdCE+4awJk/vEAkrP63xwRm
	 oz1j2GlA6XPqg==
Date: Thu, 22 Aug 2024 17:13:21 -0700
Subject: [PATCH 05/10] xfs: refactor aligning bestlen to prod
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086703.59070.1862088410279807687.stgit@frogsfrogsfrogs>
In-Reply-To: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
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

There are two places in xfs_rtalloc.c where we want to make sure that a
count of rt extents is aligned with a particular prod(uct) factor.  In
one spot, we actually use rounddown(), albeit unnecessarily if prod < 2.
In the other case, we open-code this rounding inefficiently by promoting
the 32-bit length value to a 64-bit value and then performing a 64-bit
division to figure out the subtraction.

Refactor this into a single helper that uses the correct types and
division method for the type, and skips the division entirely unless
prod is large enough to make a difference.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7e45e1c74c027..54f34d7d4c199 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -196,6 +196,17 @@ xfs_rtallocate_range(
 	return xfs_rtmodify_range(args, start, len, 0);
 }
 
+/* Reduce @rtxlen until it is a multiple of @prod. */
+static inline xfs_rtxlen_t
+xfs_rtalloc_align_len(
+	xfs_rtxlen_t	rtxlen,
+	xfs_rtxlen_t	prod)
+{
+	if (unlikely(prod > 1))
+		return rounddown(rtxlen, prod);
+	return rtxlen;
+}
+
 /*
  * Make sure we don't run off the end of the rt volume.  Be careful that
  * adjusting maxlen downwards doesn't cause us to fail the alignment checks.
@@ -210,7 +221,7 @@ xfs_rtallocate_clamp_len(
 	xfs_rtxlen_t		ret;
 
 	ret = min(mp->m_sb.sb_rextents, startrtx + rtxlen) - startrtx;
-	return rounddown(ret, prod);
+	return xfs_rtalloc_align_len(ret, prod);
 }
 
 /*
@@ -294,17 +305,10 @@ xfs_rtallocate_extent_block(
 		goto nospace;
 
 	/*
-	 * If size should be a multiple of prod, make that so.
+	 * Ensure bestlen is a multiple of prod, but don't return a too-short
+	 * extent.
 	 */
-	if (prod > 1) {
-		xfs_rtxlen_t	p;	/* amount to trim length by */
-
-		div_u64_rem(bestlen, prod, &p);
-		if (p)
-			bestlen -= p;
-	}
-
-	/* Don't return a too-short extent. */
+	bestlen = xfs_rtalloc_align_len(bestlen, prod);
 	if (bestlen < minlen)
 		goto nospace;
 

