Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD3457CA6
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346987; cv=none; b=N901WvOskMLmw3GuLKC9R+osbePC4F8iBR1C0VurpRFdrTmYN+MTJ3qC6ZL16XrGDFsDwqt2vWqJP7OT1FE54AoG3KvIKGPZAz7Yas+3uQOYpkHOPOSdowTuzMiOBqB45iZm8+BieBmqtLpKEecSPjQ/0QJgro0UNlj6ppf3J1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346987; c=relaxed/simple;
	bh=nllmPiMH+G3rKvHVNBO+lRyKtyEIS3LAVzhLgAmpac4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rFKethysl5Kw9yde/PXoZ52wls7/8h4of/zlX/F4kmaoNKz27VL1WsgSCuKjJEO+6SPKQhcbG0EDt3u9gpBcmssrTv/3xhuFwcRvFPEDns0JzO9Jusv3ECFJpieEwHaq/NvtgYTSXsKKjgQWRuVkgeSieHdq7Sab64GBifIbRiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fnu439Bo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fnu439Bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE512C2BD11;
	Wed, 22 May 2024 03:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346987;
	bh=nllmPiMH+G3rKvHVNBO+lRyKtyEIS3LAVzhLgAmpac4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fnu439BosjhgBByUSsIbzM2k5dKDMv+4ieiIII0vWCEbbOIKMICODOyibDG1T/+uw
	 jffV3bOqGC9btP/Ud3q1JI3tK5bHXQJVjYwIgs/ta7F22V1/oJYJSjS1JdLViSDE7r
	 puGDrn8KQfSefEUECaaZ3+G1A0I+0j6tGJjT5pMsHpBxX47G3p1ZEC0n38DAsYk4ZM
	 +mI5/h+0RcPDLbgPC5obN4pfieYLLTB689pOdC+O7jTl7BostIyScd3A01VcZ9ZbSw
	 n2UygK0qHjp3D6t4BNiBr3CMf1kJ8EZ+A6Pg9KV76S4gilUM24VDo7u7SgrW7UPZ2c
	 Vv08sicjtOQqA==
Date: Tue, 21 May 2024 20:03:07 -0700
Subject: [PATCH 055/111] xfs: fold xfs_inobt_init_common into
 xfs_inobt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532523.2478931.8756770834982161875.stgit@frogsfrogsfrogs>
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
index 87471ba14..aa3f586da 100644
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

