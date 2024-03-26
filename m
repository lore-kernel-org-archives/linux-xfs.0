Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BBE21353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424880; cv=none; b=EHipjaAaoCaHkwcfB7uug3sBmxWxAmX7CW3A+nmMjS/Bp8o38IK8lwzrMdHhCX0EqDKzaQYVdjlabrGrlrMjkcaoh30SUTjpsI9zjo2MX5LCHdJKdIIKczaezqafma0bsxrb3RArqXN+925SSrWVebF1H8bIoFSl8BTnxjVp5KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424880; c=relaxed/simple;
	bh=/SB7RI0oT/u+tps/y+RmG52xybWjBKqx4RNi4pGTK6A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bofHX5mBb87e3C8pLnQBx2AGn0/VLSSkwOWkuLVLUBXWs2O+u4taSdCVAa6sdPpwRXwJZtADiKn04CYXDONvxNr//lkIytOmfWUic9sS174mx3uCfa7h43SFObTLI62rV6rWkcIdROa3aRItzYWrB+ap+SzG1lSw5ZFX3gORV0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dRumb64t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dRumb64t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CD2C433C7;
	Tue, 26 Mar 2024 03:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424880;
	bh=/SB7RI0oT/u+tps/y+RmG52xybWjBKqx4RNi4pGTK6A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dRumb64tK1BQx9z91xBcsNKsTL2kj8T54fIDWNT+ddsWPHYkMxBAmP6rpBjEt7j8N
	 OK00VHRtkq7a9u2q68d8AjNFvZz337Sa4kCv7/afFGJVhQzaZ3O8ZWbvH2Ntz7JorP
	 NQp5QZckBD5WQv6kA/p5APceCQxzN4vLYa8lSXTEf4X+pgDokIR5sbF4tSgxHrp0jy
	 6YOiO8G4KmhC8OEd1BuOq86aoashchO7XGnFtkjO+guoidTmesify4+OdEnZ6ZzQqe
	 K+toqqvvsvoSO/bCy7cJ5PtOMix+aPsni/XAUVLtQy2gJa2Nabpm58si7ggCfUwsJW
	 XAvwfk7PRZA0A==
Date: Mon, 25 Mar 2024 20:47:59 -0700
Subject: [PATCH 075/110] xfs: simplify xfs_btree_check_sblock_siblings
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132460.2215168.738875939039366813.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4bc94bf640e08cf970354036683ec143a7ae974e

Stop using xfs_btree_check_sptr in xfs_btree_check_sblock_siblings,
as it only duplicates the xfs_verify_agbno call in the other leg of
if / else besides adding a tautological level check.

With this the cur and level arguments can be removed as they are
now unused.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 0b6d8d6f1de3..4ba36ecbbc36 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -83,8 +83,6 @@ xfs_btree_check_lblock_siblings(
 static inline xfs_failaddr_t
 xfs_btree_check_sblock_siblings(
 	struct xfs_perag	*pag,
-	struct xfs_btree_cur	*cur,
-	int			level,
 	xfs_agblock_t		agbno,
 	__be32			dsibling)
 {
@@ -96,13 +94,8 @@ xfs_btree_check_sblock_siblings(
 	sibling = be32_to_cpu(dsibling);
 	if (sibling == agbno)
 		return __this_address;
-	if (level >= 0) {
-		if (!xfs_btree_check_sptr(cur, sibling, level + 1))
-			return __this_address;
-	} else {
-		if (!xfs_verify_agbno(pag, sibling))
-			return __this_address;
-	}
+	if (!xfs_verify_agbno(pag, sibling))
+		return __this_address;
 	return NULL;
 }
 
@@ -209,10 +202,10 @@ __xfs_btree_check_sblock(
 	if (bp)
 		agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
 
-	fa = xfs_btree_check_sblock_siblings(pag, cur, level, agbno,
+	fa = xfs_btree_check_sblock_siblings(pag, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_sblock_siblings(pag, cur, level, agbno,
+		fa = xfs_btree_check_sblock_siblings(pag, agbno,
 				block->bb_u.s.bb_rightsib);
 	return fa;
 }
@@ -4710,10 +4703,10 @@ xfs_btree_sblock_verify(
 
 	/* sibling pointer verification */
 	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
-	fa = xfs_btree_check_sblock_siblings(bp->b_pag, NULL, -1, agbno,
+	fa = xfs_btree_check_sblock_siblings(bp->b_pag, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_sblock_siblings(bp->b_pag, NULL, -1, agbno,
+		fa = xfs_btree_check_sblock_siblings(bp->b_pag, agbno,
 				block->bb_u.s.bb_rightsib);
 	return fa;
 }

