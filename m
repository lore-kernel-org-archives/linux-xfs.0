Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFFA646
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300733; cv=none; b=s29ZYncTxkHpeQN9UgyoNjkRTJ1BLZGGilLY5rWkzV5eERWJ+9O21uGS9RF5vGzB35oWt3zOXqlM0wzG8qr/wCGXjkmJ9o+Aw4tB26hKSgh3j2U7lXKoxve6KgnCDrHOm9DFJKNl6i43bq2qQMvLAIpYlIqzWBzP4+z9BPiaekg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300733; c=relaxed/simple;
	bh=ohlMZfvdHJey55ioF1WVvAiATIu6j7EM7niIk6eBSWk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jDxaBObb/UixKN+rI2JIW3KB+QAxXkA8wOZP7eC8sF5uTJJAJvz28QDQB2k7dYF3Aj+5lx4ftYvfE1rej77SUaDy13nB3ATlPmTd0jvNd70E65isnpRIf954nHb1DQp/mbRbpC79gB5Q2uxJvkbHzy/zMk5ggUSLsmXsmXsPL0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DIVp5woe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DIVp5woe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C58C32786;
	Tue, 30 Jul 2024 00:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300733;
	bh=ohlMZfvdHJey55ioF1WVvAiATIu6j7EM7niIk6eBSWk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DIVp5woe7/BY8UWAwE2+CHRyFwdFWUwx85iY0EeRdPqH+zTpT42bhTBINEPpc17RS
	 D+ANU2ELN9J+dTay4gUCXqnaR/N7M9r96jD3kwq2aihvW4r+ya2J+lqxAkT9crugJw
	 1AOyA15/qYcoX1sahMsFinXm1jRoeG62yU3WU6TgG+ad4MSRNPHu57qXmUb5d/w2pF
	 792IAasbD2E+VFipiEH77TAjzfU593S3fhq38k3YhJcaQBmT2a1acF6F9cLVP9+tTv
	 GEU1ih+dNILlx9tJhZocdWbq2ypnBhWsdQndQEBUz6+k1jJcms4SABVADe3TPRfAET
	 2rg+p8hnm3ltg==
Date: Mon, 29 Jul 2024 17:52:12 -0700
Subject: [PATCH 109/115] xfs: fix xfs_init_attr_trans not handling explicit
 operation codes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843979.1338752.1174570151097838124.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 06c37c719d22339ad09b93735923e9b1a9794871

When we were converting the attr code to use an explicit operation code
instead of keying off of attr->value being null, we forgot to change the
code that initializes the transaction reservation.  Split the function
into two helpers that handle the !remove and remove cases, then fix both
callsites to handle this correctly.

Fixes: c27411d4c640 ("xfs: make attr removal an explicit operation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c |   38 ++++++++++++++++++--------------------
 libxfs/xfs_attr.h |    3 +--
 2 files changed, 19 insertions(+), 22 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 9d32aa406..9e1cce577 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -328,26 +328,20 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
-/* Initialize transaction reservation for attr operations */
-void
-xfs_init_attr_trans(
-	struct xfs_da_args	*args,
-	struct xfs_trans_res	*tres,
-	unsigned int		*total)
+/* Initialize transaction reservation for an xattr set/replace/upsert */
+inline struct xfs_trans_res
+xfs_attr_set_resv(
+	const struct xfs_da_args	*args)
 {
-	struct xfs_mount	*mp = args->dp->i_mount;
+	struct xfs_mount		*mp = args->dp->i_mount;
+	struct xfs_trans_res		ret = {
+		.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+			    M_RES(mp)->tr_attrsetrt.tr_logres * args->total,
+		.tr_logcount		= XFS_ATTRSET_LOG_COUNT,
+		.tr_logflags		= XFS_TRANS_PERM_LOG_RES,
+	};
 
-	if (args->value) {
-		tres->tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres *
-				 args->total;
-		tres->tr_logcount = XFS_ATTRSET_LOG_COUNT;
-		tres->tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		*total = args->total;
-	} else {
-		*tres = M_RES(mp)->tr_attrrm;
-		*total = XFS_ATTRRM_SPACE_RES(mp);
-	}
+	return ret;
 }
 
 /*
@@ -1005,7 +999,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	int			error, local;
 	int			rmt_blks = 0;
-	unsigned int		total;
+	unsigned int		total = 0;
 
 	ASSERT(!args->trans);
 
@@ -1032,10 +1026,15 @@ xfs_attr_set(
 
 		if (!local)
 			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
+
+		tres = xfs_attr_set_resv(args);
+		total = args->total;
 		break;
 	case XFS_ATTRUPDATE_REMOVE:
 		XFS_STATS_INC(mp, xs_attr_remove);
 		rmt_blks = xfs_attr3_max_rmt_blocks(mp);
+		tres = M_RES(mp)->tr_attrrm;
+		total = XFS_ATTRRM_SPACE_RES(mp);
 		break;
 	}
 
@@ -1043,7 +1042,6 @@ xfs_attr_set(
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
-	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
 		return error;
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 088cb7b30..0e51d0723 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -565,8 +565,7 @@ bool xfs_attr_check_namespace(unsigned int attr_flags);
 bool xfs_attr_namecheck(unsigned int attr_flags, const void *name,
 		size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
-void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
-			 unsigned int *total);
+struct xfs_trans_res xfs_attr_set_resv(const struct xfs_da_args *args);
 
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to

