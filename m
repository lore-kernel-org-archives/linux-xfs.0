Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE71259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441553; cv=none; b=ZD+Y9QZFq0B/xAPoQDY63PEXKTuWosKwafFaTBkJz/uNEXB+53PVCrrMYvvs5HxfbUm1Y9ciIWgClYXj+1sLH/vHCTbgemzFXxXDOTxQ0+OOeiz8kVe3JZdmJZuXXTogAiJDGItRcFVIlVjTGDL9meymOOqj4fRZnn87XwNDaM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441553; c=relaxed/simple;
	bh=xsZ4zpAJv8emJ3sqEZKMy1Ee7OfmleLufUnZbKPR5OI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pU0hw/nZDa05nPz0sgmuinWOoP6MgPhyWacqesBEmQe2u8kxUuQ1B8V/ojnIRk1gaNAVFmWSMOCgIOXwLg1PVTuinYHFYjCUbE4VtcCe4Vp5/qysgQCbrMdmFxNdBfWmsiJuCGqbGKAZTcybZG68yTStY8SXme2tdpem7EGfKgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pba6unS5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pba6unS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7F7C2BD10;
	Mon,  3 Jun 2024 19:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441553;
	bh=xsZ4zpAJv8emJ3sqEZKMy1Ee7OfmleLufUnZbKPR5OI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Pba6unS5KzrN7q8KsWmaEtBubB7eSovtl74DUZWnvSgVC0jaLz40ZxlQqX3KKnhl1
	 3A9QeKtoWxe115aTi0ZULcO9OmUwjsAf6pAN4wKADEQdfxze3uIaLe2iccdHk4OgF4
	 iBLQ6lWV6IYxeiKAIUaxsOZJqOw4TIU4tPb44a5EEmkcygBn1qmYQYiLEawLiITE/6
	 A8JLQETW0Am6z8bB+Gd/q417zfwi8kPLY3bz4ubLGR0sAth3uh447E6OFaxni6++eV
	 JDdSsDJ8HZystCGvYW5ykY0yBozoRXY/ITi3/TnePfzQqdAan60mwcanZstAQHkNmY
	 xXUd8acSBNvGw==
Date: Mon, 03 Jun 2024 12:05:52 -0700
Subject: [PATCH 053/111] xfs: fold xfs_allocbt_init_common into
 xfs_allocbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040170.1443973.9871444723938697477.stgit@frogsfrogsfrogs>
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

Source kernel commit: fb518f8eeb90197624b21a3429e57b6a65bff7bb

Make the levels initialization in xfs_allocbt_init_cursor conditional
and merge the two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_alloc_btree.c |   42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 6b17037f8..13d2310cf 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -511,11 +511,16 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
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
@@ -530,31 +535,14 @@ xfs_allocbt_init_common(
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
 
@@ -568,7 +556,7 @@ xfs_allocbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_allocbt_init_common(mp, NULL, pag, btnum);
+	cur = xfs_allocbt_init_cursor(mp, NULL, NULL, pag, btnum);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }

