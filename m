Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E1E369D76
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571976; cv=none; b=lE1br4U6/5zhVXj/EKFPD7d82wML9VQvLK+xIWcHyj1oZKR0eqRe9vX/CVtgUJ5CUQUyQTCc4Y2qnTsmbmDB2y9j26b2PpwQf4u2kmL8jqPyGX3WxPaepbqLKl9ugxFTFSC3FdMxtf31GcI4JaEQJJpCEMI0rcNDR2DSpnl/8cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571976; c=relaxed/simple;
	bh=1b/vQK9o7Nn6uGvFE1NtNz4XiGMiimt+3xwdFebwPfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpvqvtVoJI2bpWtMjidMzqNd7/aeN21Cpv51WHHR1Ck5h6CEK3tRyyHzuxDxeEyXHjENCEl8UmVk+k+RyvdVkfeqA/2mz7YcsxGDEcs9jZxkhJA58SGTosyug1ugkJzuVe/zci4PUwN9okTFvZ62UddHDuqdrYE3AKDeXZJHIuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApuLlpjQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApuLlpjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCEF1F00A3A;
	Mon, 24 Aug 2026 11:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571974;
	bh=HcGYpGRH0uQp//YSghX+MFw+ZD0dm0aGlFUvCvVlVrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApuLlpjQQVdr6oYP7n1EFDAQxLynfbwFW2aiRijDgm/iBJfIeq8zt/8ETOS5uW0og
	 FWr4v4I4AgtEyTzfrTxwQh3/LQRJVbpC3j/Q9grmcvWBpdAcQUzDLGL8e5WHh9/oCC
	 78edBynDf012ohfsaPcwwwTaQNSwGYu5mikqmSlZNAxGJ7Cv6OVGarOlWYIPrGp9Wg
	 T5n0UPJw5DDWZRx581LsnIBx13mPcbXKvl91XEvlDKzJfN23x+JsAcTfQKrC4X9nIk
	 zcEa3oNH+HPN4sGmLVDcegtAcGriVduETK1DayhT9MZNDI5w3SrRf7R7QZl9h3OsIs
	 IDo4g1aYPLblA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH 07/21] xfs: add a xfs_rmap_inode_owner helper
Date: Mon, 24 Aug 2026 12:40:05 +0200
Message-ID: <20260824104022.420566-8-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824104022.420566-1-aalbersh@kernel.org>
References: <20260824104022.420566-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f882fc7dd9f04f73d94379deb9e68d8db613c976

Add a small wrapper for initializing the rmap owner to i_ino.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c | 2 +-
 libxfs/xfs_rmap.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1bd65a0cba26..23cc5bb46272 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -813,7 +813,7 @@ xfs_bmap_local_to_extents(
 	args.mp = ip->i_mount;
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
-	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
+	xfs_rmap_inode_owner(&args.oinfo, ip, whichfork, 0);
 
 	/*
 	 * Allocate a block.  We know we need only one, since the
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 7188459f61cf..6016fd5fcad9 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -37,6 +37,8 @@ xfs_rmap_ino_owner(
 	if (whichfork == XFS_ATTR_FORK)
 		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
 }
+#define xfs_rmap_inode_owner(oi, ip, whichfork, offset) \
+	xfs_rmap_ino_owner(oi, (ip)->i_ino, whichfork, offset)
 
 static inline bool
 xfs_rmap_should_skip_owner_update(
-- 
2.55.0

