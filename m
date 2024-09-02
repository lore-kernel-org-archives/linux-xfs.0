Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F56C19CC01
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301701; cv=none; b=Ak/IZHlyZpyYHLN9iGsUpLem74UOoen/d1LTlbI6MugAiVJUUK8PhC/HPbGmMMwFD3UWGq4h9oh+0akVqOshQooV9pw7EcozQuA3lA1XW+ZQpEc18juiWmrZxnYiVQJVB4nUcZyvsflP8YJKJcRdbFb8K9vAf91K8N1KHyvHoDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301701; c=relaxed/simple;
	bh=XkCkUJuVh+ssGc433Kd37Lt/P8FkkU33xZj5mRnWFFs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EeXWHoB7RPR9AEOxShwrze0CMrmG87s3nkXVG9XJI4AcV1cN5v4W8VWp6CUpyKdvfKZcz/PEcprBMV1ZAErUrOE+0LXAXxh4JzZErECqk5/JK8kLcJz2I2zbYR8443thHxZz6n9JmSt7kzoKi7BuulCsPFsfriAlD1thipTop/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ID5+DFs6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ID5+DFs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CDFC4CEC2;
	Mon,  2 Sep 2024 18:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301701;
	bh=XkCkUJuVh+ssGc433Kd37Lt/P8FkkU33xZj5mRnWFFs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ID5+DFs64T4pYgX27NSmCRbUAdNzUjuh+/fXsQQxZfDT4TW8jtUsuTBYmCWYIuacd
	 jnPTtDy7C5OKizNIr2K8EIekebvoqs5350E93WCQWjg0zCQQV4m/m+xhIBacIv5/lW
	 kbkzh681J3xVpyuzQPKChcdZU8204+JXJ/em6iSm976CMFaq4+zqiUhnDfXKkg4zjH
	 uz0B34+T9T6zg+LhgbUeGeKCXH0l/KuYTsK3R9VU+h+oLPLBMfd1l+9mwj3zOP7Hd3
	 2dmCZuYYo/b/G2rWzx50I5NU+j+ImFT6nvSFM+8sS5XuKIvISFgwwmwV2L00e700Ie
	 1pxPG/pYn4tOQ==
Date: Mon, 02 Sep 2024 11:28:20 -0700
Subject: [PATCH 05/10] xfs: refactor aligning bestlen to prod
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106340.3325667.13658709448715994650.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 58081ce5247b..11c58f12bcb2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -194,6 +194,17 @@ xfs_rtallocate_range(
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
@@ -208,7 +219,7 @@ xfs_rtallocate_clamp_len(
 	xfs_rtxlen_t		ret;
 
 	ret = min(mp->m_sb.sb_rextents, startrtx + rtxlen) - startrtx;
-	return rounddown(ret, prod);
+	return xfs_rtalloc_align_len(ret, prod);
 }
 
 /*
@@ -292,17 +303,10 @@ xfs_rtallocate_extent_block(
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
 

