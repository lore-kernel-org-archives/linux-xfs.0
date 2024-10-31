Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13371E231B
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416700; cv=none; b=DcHEt6uRUssF+BUHaqi0Hgu9y9QuIuo1tgJfgbaf63krnls3W5ecQ3tbR1oLBZiHOCmXTsoFVUjEG7gl7ZYLl3AHChxUbMkF2zB3JgItlxU1WNk1elJo+kydrsgtQh9qEDHYb4E6QNmHfITHWlyQNj1LL39XYqe0xIvYirgh35s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416700; c=relaxed/simple;
	bh=6v9xPp+HF59XYUVGsO+s6XMsOPw8OoyuO9rkykcOyWM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cxJLZuBqpHi4YOBearALXnFwDKwylrscPu9SvYBw7uk7+n5QLgcNBcOgw1zRU5K0ZHzoKgUmJ2lwPItWv7zFWB5KvJuF50eOqunBnwqCeOXPBGP10N4b4RTGaC+5ZYhHOZuaKhqjvEGuiKihqb+V0jeHfxBvu2BamVI2gYoRc/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjFTkTP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjFTkTP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C0DC4CEC3;
	Thu, 31 Oct 2024 23:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416700;
	bh=6v9xPp+HF59XYUVGsO+s6XMsOPw8OoyuO9rkykcOyWM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fjFTkTP06UUnDf/nXoBJdOWFamRhjphHfPTYtweF+crak3fjYB0mn52dhTVEpDqUl
	 Fd1bDrttsliCcfBOImeN4U+DmMcXFH9eNiSgH8yW4nFIc4idq0utlLkKDzBPjc0t2g
	 yOB3VsOcuh5UwfsuGeotUMqK5SG4QoO0kvADwzfNgeQoP7VNiAf3Siue5/hyt6jfDH
	 uglcuDW9mBnx67/LXZr8alN2m50KppPc6FyyvIRMxytgYMKoeI6WUyxN4K5EmqBZi4
	 aneTySJmir0aYNrViNFK6E0Uczlg0Obcu7Akm+xeAz72D6wbANG6/nmSuvMsyp5ZHp
	 NhC5uatZIlIkg==
Date: Thu, 31 Oct 2024 16:18:20 -0700
Subject: [PATCH 37/41] xfs: support lowmode allocations in
 xfs_bmap_exact_minlen_extent_alloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566481.962545.4521489448593443680.stgit@frogsfrogsfrogs>
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

