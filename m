Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1174F4C89
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347395; cv=none; b=nW47hoAWlomY3QmDx//Y6z3aftfo3zkQTSPOpc/XbdjdUejnokOmAmpNuBl213DGH/EkdFEFJZJOhPdfC/0NsTsS4hpNUQJf2qm10z8tFlG3FWsGC7QTlD/rlGnvPgSqz7yzWu9Dcep3XUdz3MmsXON0nAE+v1SQqpDqgAiuYdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347395; c=relaxed/simple;
	bh=GUgAS33EDgmtP4LenY4EjEm5QNCQM3Bn1vcx3J9kvXM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZaTZJwnnfyqtz1XBfJp1wQ3m9Vmm9jEx6YZbt8H4D4QBVCIkEZXIoSVXq0LD0J5yHpW4ParRU4FJ5vCspDBUN59Mxlaa0NSoCIU5PfmOHe9mlYjivUate3wgBqZJu8dc+QNC9nhKhVw/JImKy2uAeKIEzRhIErZrqKJgRKEvWo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NsN9qy5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NsN9qy5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D7AC2BD11;
	Wed, 22 May 2024 03:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347394;
	bh=GUgAS33EDgmtP4LenY4EjEm5QNCQM3Bn1vcx3J9kvXM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NsN9qy5nFzTeCzl4NzqAc0+gV5OC0Yfdzn/73R6zx81KBQ8deJLYPYSYObiqqbOKv
	 7CVIqBywU5kvWUxCcwEqpNnfduFWPKgbUqa8uFJHsDVWgRs1h6Hz5OmSZSD21EJOXn
	 LVX7qV0iMF0SZeHHSo9lTMzVIaNP8vHVwd8IOk+9edTPXSPr+O37uD98sd3t38QcUK
	 vxJL4+q58bMg9+grqT5X7MA9NhBRjf8ks6iAyHoxZSZk+RFT9mjG2DZFy+PgpheBym
	 7pf/MZZci3SSAH52+N5Rtd9Zqy7kXorTpAV+iAUwhsc5zYNdJ6h2vb2W1XhsMjyFSD
	 l/Ielr7jYR8tQ==
Date: Tue, 21 May 2024 20:09:54 -0700
Subject: [PATCH 081/111] xfs: tighten up validation of root block in inode
 forks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532914.2478931.12159681579668872128.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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
index 0b5002540..2f5848b9d 100644
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

