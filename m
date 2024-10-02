Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F19B5227
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832129; cv=none; b=LPfoHbYkj3RjWad9KeT/Fv//rjy2bLH7RA1rI/iyuhy54+ncqNaulB3RHCHZ72ueicLvTXDVS78pMXgV5Eqb3IpaRWOBru93RwrGDtmAmW+zxksc3KAC3SU+nrRb3Cv8+WX+/aIA3iT/4/O/IiDkSPySvNLlRXytL+Ta8dvmzrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832129; c=relaxed/simple;
	bh=eQoexZv1ug1BUsFqXnWmXxGP6zOPuWxHW1n2fChadOg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZMlN7MIZs4Txvg5ZsuLZPp//t1hegb/PXWVJKBktvBs+Qu8RyQK1kwqRRllytpiY9kkxCvJg99ZesnxtPRmFnQMqh+PXq414fjX1W/3lEoG88hYVEU12TH/HRKljZfpzA41t+/LZqaskCcrs8e5cYQLVoesE8SutntAQFLxskTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XIX8a6At; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XIX8a6At"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDB6C4CEC6;
	Wed,  2 Oct 2024 01:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832129;
	bh=eQoexZv1ug1BUsFqXnWmXxGP6zOPuWxHW1n2fChadOg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XIX8a6AtF91dJoaU4WxGaLsxSJKTB5f37ur9zr0jMsvxfB2gHcoBOYdgTxax7b3zC
	 nv1R2g7d3nW5BnWODLrh/pmlpwMX+QIv+EqdWwohOman7nLYY+oQl5htRGSep/SUMe
	 GA427nR1/t0MzfNps40Xzhr3kwp0oZ/+SEXzLxTdDAb6A6NQepaopTIeLCIBN1+e45
	 7kQQJjdkVlrlOhVwagrgChfPqqPiAWeg85DvHDBhNMrTj4TtL2NLsNE6zLKbOoyl/p
	 68jONR1AsivaL3GL0fD/6zRuCawJUmVNK7HJOqCfOLkHzE+5N0vo0N3E/VBBrxNaFU
	 MDmeIPj+LFzFQ==
Date: Tue, 01 Oct 2024 18:22:08 -0700
Subject: [PATCH 55/64] xfs: don't bother calling
 xfs_refcount_finish_one_cleanup in xfs_refcount_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102610.4036371.2235178743289684532.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: bac3f784925299b5e69a857e7e03e59c88aa14be

In xfs_refcount_finish_one we know the cursor is non-zero when calling
xfs_refcount_finish_one_cleanup and we pass a 0 error variable.  This
means xfs_refcount_finish_one_cleanup is just doing a
xfs_btree_del_cursor.

Open code that and move xfs_refcount_finish_one_cleanup to
fs/xfs/xfs_refcount_item.c.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c   |   17 +++++++++++++++++
 libxfs/xfs_refcount.c |   19 +------------------
 libxfs/xfs_refcount.h |    2 --
 3 files changed, 18 insertions(+), 20 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 8cf360567..f6560a6b3 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -423,6 +423,23 @@ xfs_refcount_update_abort_intent(
 {
 }
 
+/* Clean up after calling xfs_refcount_finish_one. */
+STATIC void
+xfs_refcount_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	struct xfs_buf		*agbp;
+
+	if (rcur == NULL)
+		return;
+	agbp = rcur->bc_ag.agbp;
+	xfs_btree_del_cursor(rcur, error);
+	if (error)
+		xfs_trans_brelse(tp, agbp);
+}
+
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.name		= "refcount",
 	.create_intent	= xfs_refcount_update_create_intent,
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 14d1101b4..4b9a8be36 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1299,23 +1299,6 @@ xfs_refcount_adjust(
 	return error;
 }
 
-/* Clean up after calling xfs_refcount_finish_one. */
-void
-xfs_refcount_finish_one_cleanup(
-	struct xfs_trans	*tp,
-	struct xfs_btree_cur	*rcur,
-	int			error)
-{
-	struct xfs_buf		*agbp;
-
-	if (rcur == NULL)
-		return;
-	agbp = rcur->bc_ag.agbp;
-	xfs_btree_del_cursor(rcur, error);
-	if (error)
-		xfs_trans_brelse(tp, agbp);
-}
-
 /*
  * Set up a continuation a deferred refcount operation by updating the intent.
  * Checks to make sure we're not going to run off the end of the AG.
@@ -1379,7 +1362,7 @@ xfs_refcount_finish_one(
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
 		nr_ops = rcur->bc_refc.nr_ops;
 		shape_changes = rcur->bc_refc.shape_changes;
-		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
+		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
 	}
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 01a206211..c94b8f71d 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -82,8 +82,6 @@ void xfs_refcount_increase_extent(struct xfs_trans *tp,
 void xfs_refcount_decrease_extent(struct xfs_trans *tp,
 		struct xfs_bmbt_irec *irec);
 
-extern void xfs_refcount_finish_one_cleanup(struct xfs_trans *tp,
-		struct xfs_btree_cur *rcur, int error);
 extern int xfs_refcount_finish_one(struct xfs_trans *tp,
 		struct xfs_refcount_intent *ri, struct xfs_btree_cur **pcur);
 

