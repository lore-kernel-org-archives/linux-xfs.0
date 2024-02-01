Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAD985620
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816865; cv=none; b=DMYHG40BTnVql2PHllBju3gdV0M7ifp8Gj+nUFUXwBL1tN9+eg05QCVKmR2zz3P5ozuJVS2y+AUfrCXczICse4VxedXUF48oorzfPtiK5tnjiXE3x/MGbJmAVrqyyDGkCaM4TFz5bRGC5rQLM/YslUXRSpia40wHBCGrTWZIu+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816865; c=relaxed/simple;
	bh=kizNhrqbHtzOnXOpJHh2VDDKG41ZZDPcfIUqyTT0Oyo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DedZEHfE4+Dh/iLcq/hNQq+qYA4XLLdbq7dT4AUZQlUysUPaPtPTaoiKFYPTaS8P7HC3ZSzOlU22IGZLJZSQo8SrNKBlh2Cgl77PA9ILVWWhvJ6McRCIs8PEpSZip6ZexHu1zzR4FYj8JndWqr4u9nhPbqUQQDNRGBNuBtCS9uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ufl9fFar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ufl9fFar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65667C433C7;
	Thu,  1 Feb 2024 19:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816865;
	bh=kizNhrqbHtzOnXOpJHh2VDDKG41ZZDPcfIUqyTT0Oyo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ufl9fFarj2v8M1fXz+x3nkPBlV1gYeH0HMU88jG1dlIZKxVX5H0za7ccCb8BUrGOu
	 /jrtz+74e0Utd1sepzVqSUEHDiv6gSsOCMRdJvFbs8ZSJF+8xQ23LAbhfeKwBA1bdr
	 JN0F/Xp1ejWcqg/CmM9BRXxD5920U7pkBxMqqZga3C7PwWyuZvpM8D0e1YqxgjaHyy
	 NSmTvTxEGBaQ2R98JIwXb9YBV6vjBD+YR1HV/RkokeOnmZIdbWiAQ6rdrDt/awQlZY
	 Ts0jcRpTFMjPhFOjvncyt+BresVC+jDqrde1YOaupEXIBkhdjU5R7EsIg9bWRJm/oy
	 mwElQqe8AYb5A==
Date: Thu, 01 Feb 2024 11:47:44 -0800
Subject: [PATCH 08/27] xfs: fold xfs_refcountbt_init_common into
 xfs_refcountbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334916.1605438.10784356405243665338.stgit@frogsfrogsfrogs>
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

Make the levels initialization in xfs_refcountbt_init_cursor conditional
and merge the two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount_btree.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 966e87db2403b..57710856ae347 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -346,12 +346,15 @@ const struct xfs_btree_ops xfs_refcountbt_ops = {
 };
 
 /*
- * Initialize a new refcount btree cursor.
+ * Create a new refcount btree cursor.
+ *
+ * For staging cursors tp and agbp are NULL.
  */
-static struct xfs_btree_cur *
-xfs_refcountbt_init_common(
+struct xfs_btree_cur *
+xfs_refcountbt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
 	struct xfs_perag	*pag)
 {
 	struct xfs_btree_cur	*cur;
@@ -364,23 +367,12 @@ xfs_refcountbt_init_common(
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_refc.nr_ops = 0;
 	cur->bc_refc.shape_changes = 0;
-	return cur;
-}
-
-/* Create a btree cursor. */
-struct xfs_btree_cur *
-xfs_refcountbt_init_cursor(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag)
-{
-	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_refcountbt_init_common(mp, tp, pag);
-	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
 	cur->bc_ag.agbp = agbp;
+	if (agbp) {
+		struct xfs_agf		*agf = agbp->b_addr;
+
+		cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
+	}
 	return cur;
 }
 
@@ -393,7 +385,7 @@ xfs_refcountbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_refcountbt_init_common(mp, NULL, pag);
+	cur = xfs_refcountbt_init_cursor(mp, NULL, NULL, pag);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }

