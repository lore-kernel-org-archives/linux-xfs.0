Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF3F4A21
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300201; cv=none; b=AEH+hruLHCsbzXl3Yqskb9PXzSIv2W7gulUSV2Tu70LQL1qnglml2DyNffMom+QF4bgJj51pzCSetDVpVKOlwNdjxi+jMjjw4hRv0eimdHLladUBh5dRVXfJKQCAKNq9IRYnrk5gt/xwZm/OROqWalVc2P4tM3jFk+h85EpsFxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300201; c=relaxed/simple;
	bh=CKBq5VQH4ha9m+jecPJbYxCxv1BJ4Vmu3lMW2EtRwB4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N2ck6cJwc+e/VMyGHkvrMXybKjDtnnEqKKUWuW/PxIZ/jiOrhHGikdvXwnfyAfkuGc0BeKnP9JJ1vZ/Cvzeuzwot8j52avvj2Z1xwLJMpupN5ePjuu2CpOzuVkqAS8dxJtkx6eKl6O57bpJZ/ZZDE6nNJ7gGxDTcJ5AaVB+bUJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NAJGi4o/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NAJGi4o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07474C4AF0C;
	Tue, 30 Jul 2024 00:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300201;
	bh=CKBq5VQH4ha9m+jecPJbYxCxv1BJ4Vmu3lMW2EtRwB4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NAJGi4o/Jtfe69RgJTacrOqBn96XgN2tyMRNiPQMd4C7ydpylXFxl2zaxIghSR47j
	 t7Dq6zFE7nGGIrkG9pYRYfyVGr36sq7TMrDC9+iL5gkY/f1FJbYQJyXJf6eTD93GBZ
	 1IE+AWb5A30XIiMcujddbATRU5W4saYLzzkK+92/QjeGr4FBfi7v4nFg6hyHkY3zxZ
	 pxkt6zqPKKdvn84WfwJkd+m1qqmvfMACCdI1OtzVCBwygvLAd5ag/aGLpNZUecU251
	 At0nGgtDadqAMxRshp+02RRGS8JTrLl66nFsIXI7/WeTf9uu77yVZmYMpYVNyfFSeS
	 4EREMNQZkGBbg==
Date: Mon, 29 Jul 2024 17:43:20 -0700
Subject: [PATCH 075/115] xfs: drop compatibility minimum log size computations
 for reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843500.1338752.7407883717906522881.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6ed858c7c678218aa8df9d9e75d5e9955c105415

Let's also drop the oversized minimum log computations for reflink and
rmap that were the result of bugs introduced many years ago.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_log_rlimit.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index a7bbd2933..246d5f486 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
@@ -24,6 +24,11 @@
  * because that can create the situation where a newer mkfs writes a new
  * filesystem that an older kernel won't mount.
  *
+ * Several years prior, we also discovered that the transaction reservations
+ * for rmap and reflink operations were unnecessarily large.  That was fixed,
+ * but the minimum log size computation was left alone to avoid the
+ * compatibility problems noted above.  Fix that too.
+ *
  * Therefore, we only may correct the computation starting with filesystem
  * features that didn't exist in 2023.  In other words, only turn this on if
  * the filesystem has parent pointers.
@@ -80,6 +85,15 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * If the feature set is new enough, drop the oversized minimum log
+	 * size computation introduced by the original reflink code.
+	 */
+	if (xfs_want_minlogsize_fixes(&mp->m_sb)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to

