Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF6F43AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817273; cv=none; b=hxwka0ShT3bcD7/vatpZUGiZrWvniFzfwM+Ia/SLQ2+4syN+6tjbzCNunGQ82MZ0TRgrFNE9CQGK4EY2uYjSyQcvdnPoeawoUj5lr2V06HRxV3x9QocigaxVGIV8sr+oVuC3YMKUxsBYaPF6lQxIIwY2XSMOoBu0so5ImfrKrI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817273; c=relaxed/simple;
	bh=v5Ho2aBkGfH1HYKXPe0sDCFl4Zug0EkIlqYXRgu8t4Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Boksfeb3Qlq2WR9PdRFNYZq7SEji0Og77jE/toLKr8xx0ACMZ50PW1/+1JE7na8qyq+j9ukUWZ6qD0MzWQTX9GQkUcVA/u6yOVNwODP0aiDssbEWrZYGQWKRoP8E9V2KkuiX+puP1MqlnmR4lZ/LLrHVLWuVSwM26qicGV8yDcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tMdqOorf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tMdqOorf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83C6C433F1;
	Thu,  1 Feb 2024 19:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817271;
	bh=v5Ho2aBkGfH1HYKXPe0sDCFl4Zug0EkIlqYXRgu8t4Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tMdqOorf3wP20gdJNAW+NRerjSxOrE4I1a4r7imppJeu4YQjSDnhj0I4ig8TtOqhH
	 XIms8vZr2zQK9/4I8OoIrFzV38mbHGO/PD7oRWJv4bmBrjvidLH7umCG9EtmH0O5Kk
	 UOhQhZJPja36IK50l78xyc/cayWibIW+xf7JBXmgpL+M5Bh3cCgSJMFVPaYddxsTmh
	 u942hbCaGjTeOHVFQrnkQdWp/bJ+LTi4TeIBzcGTrSjGJP8eI+z0ai2Jr0cnf09sEx
	 d2xB+kzrc1fOaEF0lR2WSzteyzkaofFmL5DJQ7gJ4wYmAXyCiKUDL1HvKweyNhdpPK
	 hhSDQaJAO/x2A==
Date: Thu, 01 Feb 2024 11:54:31 -0800
Subject: [PATCH 07/10] xfs: tighten up validation of root block in inode forks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335725.1606142.18016491737507127760.stgit@frogsfrogsfrogs>
In-Reply-To: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
References: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
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

Check that root blocks that sit in the inode fork and thus have a NULL
bp don't have siblings.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4a6bc66c14d0d..f5d7c4236963b 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -107,7 +107,7 @@ __xfs_btree_check_lblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_failaddr_t		fa;
-	xfs_fsblock_t		fsb = NULLFSBLOCK;
+	xfs_fsblock_t		fsb;
 
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -127,9 +127,19 @@ __xfs_btree_check_lblock(
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

