Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713CB8528E
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816834; cv=none; b=hZKEdZrmKhImgurXfP1mAifAihPogIaWO47aMuMO153vwKlL3IDUhDMbzYvYy3ZfUOqgKZ7Fs8QM+wx/7GihSN+Fy39+y86azJKhCTcE6JxQOJSIh6T51JnLMBGWrWcHSlqrbHqFBrBrSs+1U7qz/RMVt29cCesGoTYl5XMQm0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816834; c=relaxed/simple;
	bh=6jq9qWtqVdw5vPHneygzrW2R+ZEpW25UTlo5F4jgRaE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oEpNicLv7r9D2/mMXU/B7/6oKiUMLY+IKjcdA4bi766YPXtpK3P/mEZWmIbCBFInTgbjT0DmAmy73YwsO4DL3+E4occr2qQvPTouPQu6kt/9i26mTqNiEoj7vIQxW6lUXdeRSlzvAtIuuAE0HWGFGp1yNOEtPJQbZaIZnbSnUZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVKZWZ9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVKZWZ9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D26DC433F1;
	Thu,  1 Feb 2024 19:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816834;
	bh=6jq9qWtqVdw5vPHneygzrW2R+ZEpW25UTlo5F4jgRaE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KVKZWZ9U6rQwHlGfawkwl7ZF55gsxpERNDTSqBMfeNpCXOmFQHL7mR/vJqILRUaGU
	 nRIpzlDAlRc5K6RmTIK9V5Dc8faHlXeWO5i299i1+W9Basf31OpN9zU2t4aCa4GqFR
	 Md3kXyIvOfYmCom9NJo6Erz5dzFJOfLSDfsXvs55qld0ZOwaiK95Q6JGX/ksDR2RkO
	 jl7if+28rmjY8YcYAdHcP1p7ZDQJTFT2KgGSP9stO2gwm8aCHIJsb3kfrOBRbXc069
	 QUUBYHNeTmXylj5vzCZ4Ga6p4uadhelJL9PX0WUyRL//S1Ub64OH8JiQ3f7LLzHiCv
	 GceE4q+m/ddSA==
Date: Thu, 01 Feb 2024 11:47:13 -0800
Subject: [PATCH 06/27] xfs: fold xfs_inobt_init_common into
 xfs_inobt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334884.1605438.12512081534655278197.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
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

Make the levels initialization in xfs_inobt_init_cursor conditional
and merge the two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c |   39 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 0d04ac32367df..48bfea0e2a200 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -455,12 +455,15 @@ const struct xfs_btree_ops xfs_finobt_ops = {
 };
 
 /*
- * Initialize a new inode btree cursor.
+ * Create an inode btree cursor.
+ *
+ * For staging cursors tp and agbp are NULL.
  */
-static struct xfs_btree_cur *
-xfs_inobt_init_common(
+struct xfs_btree_cur *
+xfs_inobt_init_cursor(
 	struct xfs_perag	*pag,
-	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
 	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
 {
 	struct xfs_mount	*mp = pag->pag_mount;
@@ -475,26 +478,14 @@ xfs_inobt_init_common(
 	cur = xfs_btree_alloc_cursor(mp, tp, btnum, ops,
 			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
-	return cur;
-}
-
-/* Create an inode btree cursor. */
-struct xfs_btree_cur *
-xfs_inobt_init_cursor(
-	struct xfs_perag	*pag,
-	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	xfs_btnum_t		btnum)
-{
-	struct xfs_btree_cur	*cur;
-	struct xfs_agi		*agi = agbp->b_addr;
-
-	cur = xfs_inobt_init_common(pag, tp, btnum);
-	if (btnum == XFS_BTNUM_INO)
-		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
-	else
-		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
 	cur->bc_ag.agbp = agbp;
+	if (agbp) {
+		struct xfs_agi		*agi = agbp->b_addr;
+
+		cur->bc_nlevels = (btnum == XFS_BTNUM_INO) ?
+			be32_to_cpu(agi->agi_level) :
+			be32_to_cpu(agi->agi_free_level);
+	}
 	return cur;
 }
 
@@ -507,7 +498,7 @@ xfs_inobt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_inobt_init_common(pag, NULL, btnum);
+	cur = xfs_inobt_init_cursor(pag, NULL, NULL, btnum);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }

