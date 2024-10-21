Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2BA2CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548515; cv=none; b=hCFvPeAfAwlT0dtMNLx4UtTJ+PEz/3sxrnLE7Ccut2PzqRPLIaI4/WJzbUQVMNSsWSQR48zzeG0W/qMOCy8Gvu0F1hJYwK3MsmrKXtGZoKMO0Zv7lxuWF0gceTm5vq/uxSZr6Js6uRL/B2hUV+lG1TbdkrIqKeh1qOwAoczcqV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548515; c=relaxed/simple;
	bh=6v9xPp+HF59XYUVGsO+s6XMsOPw8OoyuO9rkykcOyWM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L/jFWKp3DxgIgnZG12+7kk9l0MXgXBo88I3wIWfFKNJtluu5S32aMa/xJ2P+Z0Ljduh+r4YOKdTCoJf1PlpOWt/IPyixFxkHSEirekpxKCe1B766mdDLiXnF1a41leL0U30xhoO0myY0FnFQTsmnnEpjfhJr8+uQzUx6a8F+qsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tHBU8lEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tHBU8lEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098A2C4CEC3;
	Mon, 21 Oct 2024 22:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548515;
	bh=6v9xPp+HF59XYUVGsO+s6XMsOPw8OoyuO9rkykcOyWM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tHBU8lEzRFbiqdz6idNz55vxTp/o8FwAtfX52fHzuslJckvPuatXdgiL/lCv4xHGM
	 /AxeARzPKtHEA7tYZgfzk499GXIzySZEB5PqTxQdmsCe/hpo8Bjsa5jBZ35BUzhQed
	 Px2Sx+JUbTOCeDOgQAL0N1f1Jk6pQWC3ycAxZDQtFU5PsRizI3YhvVoo0wfN4XcQDF
	 eDfzMWoXHMr3C9gS3dBWPvAnP3DbRHgHNMcAeqIBPlF1Lu8J4p19ceR8F51IljPBAA
	 qlVLhm43uCRAENrwi5hVYKSzBNTqz3pSWPfHiG59z2m6mll61BjlBkPAtvW3zxdpZh
	 5x2c+R+q9TEFg==
Date: Mon, 21 Oct 2024 15:08:34 -0700
Subject: [PATCH 37/37] xfs: support lowmode allocations in
 xfs_bmap_exact_minlen_extent_alloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954784031.34558.14069851291289347323.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6aac77059881e4419df499392c995bf02fb9630b

Currently the debug-only xfs_bmap_exact_minlen_extent_alloc allocation
variant fails to drop into the lowmode last resort allocator, and
thus can sometimes fail allocations for which the caller has a
transaction block reservation.

Fix this by using xfs_bmap_btalloc_low_space to do the actual allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 02f26854c53cfe..aec378ff4a9193 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3495,7 +3495,13 @@ xfs_bmap_exact_minlen_extent_alloc(
 	 */
 	ap->blkno = XFS_AGB_TO_FSB(ap->ip->i_mount, 0, 0);
 
-	return xfs_alloc_vextent_first_ag(args, ap->blkno);
+	/*
+	 * Call xfs_bmap_btalloc_low_space here as it first does a "normal" AG
+	 * iteration and then drops args->total to args->minlen, which might be
+	 * required to find an allocation for the transaction reservation when
+	 * the file system is very full.
+	 */
+	return xfs_bmap_btalloc_low_space(ap, args);
 }
 
 /*

