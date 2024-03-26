Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89461292E6
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424567; cv=none; b=UeDSCkGcTlNuSLwllS4XPZKBI8m1Dbi60Hdw2jENLbwqh4YdEUgo6EYiKxygPxFsOXZy04ri4PbtexZ1u/3YXkZe3NroyIHp762btEr5u6gfGPMCVJMRIZdE5EGZw1yKc4A0iDoYnu9XRZ1Lgc9SPqvTpPAwHDZOe15OoJZaxX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424567; c=relaxed/simple;
	bh=/ThMHH5crAy/07uZxfPjzDRRS1dw7cH1QfvL6cKkDVg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iFhaDCo6q8DhKRqIR/4vOjrE0K0dQ8brB/frwm/UH8ufjLFMbqRQR7Q2Z4EcfQSjU8su7eOhe321LbjhV260nuNR/yGUOjvOUVPUpWQ+netn8SEmB5WfiPwIPJ/6yddSH02E71dXc2RqDLJ0rs31kGPFUNOhUjGTW+bYndHqOOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=paFgs+Vv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="paFgs+Vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC8AC433C7;
	Tue, 26 Mar 2024 03:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424566;
	bh=/ThMHH5crAy/07uZxfPjzDRRS1dw7cH1QfvL6cKkDVg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=paFgs+Vv5kz3sfb8NYuBqh9nTLFXxqb9KqXEDksnc4eAKWRU1IlBfjkuRbPq/zeCI
	 3cin5rbE/j1bgOlMU9mWmA5AVI6GtaCX9L4wkxwLnAveC8TJ4ZLkolnVmW2/3WVKj1
	 Hd7Kx9gRiKlKhwb9EBfLE95d7CF//LBXcRaRT78slMh+SZoZbTkOs7wE9KTdGAy34h
	 0GUkCZyPLDfOfSAkb87DEC2fTD5Qs1+MSPYa/AFmMhOBZ2cbh5F83hm30vPf1ETrQO
	 0H+AnXW2iLccegxn664s16cXJgJv5ejZ4jOVuScvYzDDL0WYSpw5+MgIfrdCvFA9QT
	 aFLzE19bQCeNw==
Date: Mon, 25 Mar 2024 20:42:46 -0700
Subject: [PATCH 055/110] xfs: fold xfs_inobt_init_common into
 xfs_inobt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132176.2215168.18304713842927072433.stgit@frogsfrogsfrogs>
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

Source kernel commit: f6c98d921a9e5b753ac1a35d540a6487ee111a33

Make the levels initialization in xfs_inobt_init_cursor conditional
and merge the two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc_btree.c |   39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)


diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 87471ba14f9d..aa3f586dab01 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -454,12 +454,15 @@ const struct xfs_btree_ops xfs_finobt_ops = {
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
@@ -474,26 +477,14 @@ xfs_inobt_init_common(
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
 
@@ -506,7 +497,7 @@ xfs_inobt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_inobt_init_common(pag, NULL, btnum);
+	cur = xfs_inobt_init_cursor(pag, NULL, NULL, btnum);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }

