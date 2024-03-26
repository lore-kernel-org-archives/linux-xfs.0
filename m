Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27960129A83
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424974; cv=none; b=Is19yTfjdR9l2L48Od6QQjWpb1rlDj2GcJsQBp/f4KUpPMqkeuI39pGejut4F4V1oZH2bXj/YIQDW/5UpGpuESTc3oe+ZhIPSgbyOIGIZha3FCa3m2eogpXBXeszCxjjcSOR+aodeUHwY9v31rQggmJJYPSQU1U5BX4jRkuAxjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424974; c=relaxed/simple;
	bh=yx9h65pe0O8e1Rh30kw3mC0OkhHlZiqHnKw664SYvMA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nBrbdoAXdfibX2JK3dTYqk4WXjloQzfjaN+7pQGeXrQyqM0PFY1ZKjAaNFl+S5FR8zHdnmE4kzqbFcDco6bQOsWz7JlrhtvHEOb2uIX3ve9/AaS8yVVlH0cuaAW33Cr835FUqcqezCdShtCKX155731ZCmfYvqX/duA+LHLPpAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e3GUWcG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e3GUWcG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B7EC433F1;
	Tue, 26 Mar 2024 03:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424974;
	bh=yx9h65pe0O8e1Rh30kw3mC0OkhHlZiqHnKw664SYvMA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e3GUWcG8QJiVQTQU6z5Gx5ra7UPb9lQ2VBEBMYM7lAQt042Vhu8jgZ8r/G0r1vvyH
	 /W2MzSg/eMEkqtUdC2ycYG+0Z+Mtdfm3NQot337QaCd216wvf8ywO6A8bF8vO96K07
	 pEV1T6xiUX9psn5c0DNG+8OVkvW2a/yViEgAMBYJwz3pcQdOIXFHC0ovI/IdexiLGi
	 BhQc8MqaaC99kgQRgNaIwp40yd0eZCzlnPdBPqZs0vDrxuWK8Yok+7/WhTgNc9Hiqx
	 veWr2iU7mzM3+9DaMHJIM7j8ruAdunhX3kEa+RoFaoXOLEs5FLg8Da+z/WweWauIlI
	 +njdPdit0oFBg==
Date: Mon, 25 Mar 2024 20:49:33 -0700
Subject: [PATCH 081/110] xfs: tighten up validation of root block in inode
 forks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132547.2215168.17356335150848921646.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: d477f1749f00899c71605ea01aba0ce67e030471

Check that root blocks that sit in the inode fork and thus have a NULL
bp don't have siblings.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 0b5002540b50..2f5848b9d51b 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -104,7 +104,7 @@ __xfs_btree_check_lblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_failaddr_t		fa;
-	xfs_fsblock_t		fsb = NULLFSBLOCK;
+	xfs_fsblock_t		fsb;
 
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -124,9 +124,19 @@ __xfs_btree_check_lblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
-	if (bp)
-		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
+	/*
+	 * For inode-rooted btrees, the root block sits in the inode fork.  In
+	 * that case bp is NULL, and the block must not have any siblings.
+	 */
+	if (!bp) {
+		if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK))
+			return __this_address;
+		if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK))
+			return __this_address;
+		return NULL;
+	}
 
+	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_lblock_siblings(mp, fsb, block->bb_u.l.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_lblock_siblings(mp, fsb,

