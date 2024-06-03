Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EC513C693
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441913; cv=none; b=BcefOn4vYoQYZ0evncLAr70Dm/taN0qg3xNfnK6aQZ++qKerHypiLAdffkB2ysU680d+G0tD9YNFmT2g3IvabJo83iY9K6/bmOwDmCZojFx/zPl7I8JKLAU3jmIT+FFHS2l0ZSyTmUamHLyPA9PiQK44w01dM+XVpY/4nbtIxoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441913; c=relaxed/simple;
	bh=fYnTt0v7pQj6GKro+QaCcPDW7A5fNI4PA7QRCA7DRXE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YWCXDswSYEfDyacsbqZWEqsCPG505hfzbUA0MyYmGaTdoUV0aJHDL6xazrVE/8PWevbz62CFefe8txAj6XnaEXzIK0oyZk8thbZMdlMJPXkFoXRmTugjIgVYl9+/im7clf2QGnjN2LfuQJtbA1VHvxMqsp2JbqgJWkGy50S4NU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ap1wPTcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ap1wPTcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EB9C2BD10;
	Mon,  3 Jun 2024 19:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441912;
	bh=fYnTt0v7pQj6GKro+QaCcPDW7A5fNI4PA7QRCA7DRXE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ap1wPTcswM1hcWhTmVdAMvqoPJMLvbjBi5LB/F+2riqeXj6gBqG+6NG7hrBUDCcoF
	 Qn/gRwrfY+4KLVlcHRL560RvYs3XIhi1ueGVlWYVy3t4fAsw6KTAeGVR7OlwLbekZB
	 EajwbuLlgKkNcfbGbTHo8R7Ypuse7hzMBo1oRST50sl4vnCSHyn1/n2m7jn7sERsi0
	 ywiImNMAqeWUU2FpG7dRiOK7Y6K0MjHUyWvXM+Oqyyu/smTveXMfMPwT1nDF7gzdUJ
	 AXISiq/mmd+SXyPIbUVp7a4vVBlH+mWIdwtOyWQ6X4Egwi0ZK1s+VCz/stHFvBycwl
	 0GJ9C9AaLRDAg==
Date: Mon, 03 Jun 2024 12:11:52 -0700
Subject: [PATCH 076/111] xfs: simplify xfs_btree_check_lblock_siblings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040515.1443973.16973118386515709956.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 8b8ada973cacff338a0e817a97dd0afa301798c0

Stop using xfs_btree_check_lptr in xfs_btree_check_lblock_siblings,
as it only duplicates the xfs_verify_fsbno call in the other leg of
if / else besides adding a tautological level check.

With this the cur and level arguments can be removed as they are
now unused.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 4ba36ecbb..55775ddf0 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -56,8 +56,6 @@ xfs_btree_magic(
 static inline xfs_failaddr_t
 xfs_btree_check_lblock_siblings(
 	struct xfs_mount	*mp,
-	struct xfs_btree_cur	*cur,
-	int			level,
 	xfs_fsblock_t		fsb,
 	__be64			dsibling)
 {
@@ -69,14 +67,8 @@ xfs_btree_check_lblock_siblings(
 	sibling = be64_to_cpu(dsibling);
 	if (sibling == fsb)
 		return __this_address;
-	if (level >= 0) {
-		if (!xfs_btree_check_lptr(cur, sibling, level + 1))
-			return __this_address;
-	} else {
-		if (!xfs_verify_fsbno(mp, sibling))
-			return __this_address;
-	}
-
+	if (!xfs_verify_fsbno(mp, sibling))
+		return __this_address;
 	return NULL;
 }
 
@@ -136,10 +128,9 @@ __xfs_btree_check_lblock(
 	if (bp)
 		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 
-	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
-			block->bb_u.l.bb_leftsib);
+	fa = xfs_btree_check_lblock_siblings(mp, fsb, block->bb_u.l.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
+		fa = xfs_btree_check_lblock_siblings(mp, fsb,
 				block->bb_u.l.bb_rightsib);
 	return fa;
 }
@@ -4648,10 +4639,9 @@ xfs_btree_lblock_verify(
 
 	/* sibling pointer verification */
 	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
-	fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
-			block->bb_u.l.bb_leftsib);
+	fa = xfs_btree_check_lblock_siblings(mp, fsb, block->bb_u.l.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
+		fa = xfs_btree_check_lblock_siblings(mp, fsb,
 				block->bb_u.l.bb_rightsib);
 	return fa;
 }

