Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5AC41760
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816803; cv=none; b=sShnIZDXQLqkUV6fgm/5WSAahAYsRFJ7XkX2rYZk/rLF66icXe4LRHTj+AfLE3jNeZUF3Xrmb6suXPHAmRzjtTQeOVB0zjtcP9A4FJpBZtKkrg+6pmHE5cY2UReoOGTUemzlPa6M8I8qIwcp4vXV/IzvSMeIOQKSRcRMOZazCQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816803; c=relaxed/simple;
	bh=yVbNetoEaZTXuP+H5eL9TyvTZBa/j2Wf8T3+ZdKzUM4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sPd2SiL+p4xhlsex75GlvFxoehEm53BGQVpOl8VXrM5bDFnyvGJVHQmSi5pvZmAN3ApKEP6GHnOFoH8xysvH1e0LUYg/JxWsqSv+iwZJcmIIh5vu05RY3Vlwfqriml2XGx3RjseTYvArb1Cg9JmG/KhNPEC5AX1mDVyy+TkpVG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0hMVXAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0hMVXAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE27C433C7;
	Thu,  1 Feb 2024 19:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816803;
	bh=yVbNetoEaZTXuP+H5eL9TyvTZBa/j2Wf8T3+ZdKzUM4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a0hMVXAHvFXt8g7d1zoxBTcu7fOaGYtE0OUA9f6MSwsRNU7ED+rQJyz/MdDg2AN9i
	 IKWu/vJjO7zp6sJP5VXnkBDrfXGul7v7SMbYEQojxG59GAEv9kTJiw2f+oo3BzRUFF
	 yg6b9QiNKmaeylXlLnqXrn4KXS9QxrkeFTWGnoKDQe3NCuQW3UaZ0Sf/Upvge5rfJZ
	 EuqPMFQrXWhYQog5Ny4hAX+/YKqfOXuOChJOmgd+cGxQDdZr5RUHlzA/VbfdMG0xgi
	 8znVKM8Pj96G2akT6UwXQisOJ5rAqSfV6eLY9abOOf2ckcJPVeWdlbXfI+ByIN7G/r
	 aQVnqN4YN7F5Q==
Date: Thu, 01 Feb 2024 11:46:42 -0800
Subject: [PATCH 04/27] xfs: fold xfs_allocbt_init_common into
 xfs_allocbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334852.1605438.17103233144441233312.stgit@frogsfrogsfrogs>
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

Make the levels initialization in xfs_allocbt_init_cursor conditional
and merge the two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c |   42 ++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 75c66dca61eb1..847674658d675 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -513,11 +513,16 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 	.keys_contiguous	= NULL, /* not needed right now */
 };
 
-/* Allocate most of a new allocation btree cursor. */
-STATIC struct xfs_btree_cur *
-xfs_allocbt_init_common(
+/*
+ * Allocate a new allocation btree cursor.
+ *
+ * For staging cursors tp and agbp are NULL.
+ */
+struct xfs_btree_cur *
+xfs_allocbt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
 	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)
 {
@@ -532,31 +537,14 @@ xfs_allocbt_init_common(
 	cur = xfs_btree_alloc_cursor(mp, tp, btnum, ops, mp->m_alloc_maxlevels,
 			xfs_allocbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
-	return cur;
-}
-
-/*
- * Allocate a new allocation btree cursor.
- */
-struct xfs_btree_cur *			/* new alloc btree cursor */
-xfs_allocbt_init_cursor(
-	struct xfs_mount	*mp,		/* file system mount point */
-	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_buf		*agbp,		/* buffer for agf structure */
-	struct xfs_perag	*pag,
-	xfs_btnum_t		btnum)		/* btree identifier */
-{
-	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_allocbt_init_common(mp, tp, pag, btnum);
-	if (btnum == XFS_BTNUM_CNT)
-		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
-	else
-		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
-
 	cur->bc_ag.agbp = agbp;
+	if (agbp) {
+		struct xfs_agf		*agf = agbp->b_addr;
 
+		cur->bc_nlevels = (btnum == XFS_BTNUM_BNO) ?
+			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) :
+			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+	}
 	return cur;
 }
 
@@ -570,7 +558,7 @@ xfs_allocbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_allocbt_init_common(mp, NULL, pag, btnum);
+	cur = xfs_allocbt_init_cursor(mp, NULL, NULL, pag, btnum);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }

