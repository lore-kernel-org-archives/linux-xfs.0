Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149357F
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 01:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716253420; cv=none; b=RmRpTgTBlmpuXt/io31LbWoMY8GPSeOorGmMVYLv+1tI1x+hM6pSqmwt3QW7kdXFt15/+yXRqXI1Lm25iL7/Zv4CwW1/MMVD5MkD/gtXUTIyEHUSbMStaA9lo8CSYed4fIIFgCMEmnWggh/j+eymjXuUfuDkYpA/2Y7IuhsuT4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716253420; c=relaxed/simple;
	bh=dak+NhYtaYPV9hkY65Tpwq6YqWwrP4OPZNoRU16inZs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=J12jNDT8KhTATYg8xYdWkEhPK6wHjWZ4KwBV+z8LXHPBR24NK1b8m3hvczv86BGvRnfC11UX17YgLyw0cwrDo3U0CoOi5EvfgheIdXplD/BVWn831LreESA3oJzK1o++dWtCJ8ocA6w4QGi/0daMZtsSnRGMPr/9DeOYv/lZoKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=foMNSPc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="foMNSPc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792F1C2BD10;
	Tue, 21 May 2024 01:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716253419;
	bh=dak+NhYtaYPV9hkY65Tpwq6YqWwrP4OPZNoRU16inZs=;
	h=Date:From:To:Cc:Subject:From;
	b=foMNSPc5PlPILqRcqWXUY9DvVDiI1gvSfWduNQ0YruDtfQHQbp+p19mXV1UIymNq2
	 b9/VfO+L3RCQ4iiaeF636lpodfZCCqulMOo4l9OkCkTELRS5HijiFoY1qfHu+C1A+d
	 knHwWhBj/Awa+fBi/chneWG//n+v2HamQLc/QEGqN3AEhJmvyIAGgPkGJ36KfQsGk2
	 DxJxfw9GaQIV4DBYYYk96IQhkxWdl6sGtpHl04KqdF0RahfrzhQOBuFKtq4cHwEDoj
	 BIKxM8Axwi2c/i7Z9B9e6dV4YQWkQn60+OoMA1bxmJyXDCIgTFS62qidTbPiSN2nDb
	 ZXhPaC/sXx1XQ==
Date: Mon, 20 May 2024 18:03:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix xfs_init_attr_trans not handling explicit operation
 codes
Message-ID: <20240521010338.GL25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

When we were converting the attr code to use an explicit operation code
instead of keying off of attr->value being null, we forgot to change the
code that initializes the transaction reservation.  Split the function
into two helpers that handle the !remove and remove cases, then fix both
callsites to handle this correctly.

Fixes: c27411d4c640 ("xfs: make attr removal an explicit operation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |   40 +++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_attr.h |    6 ++++--
 fs/xfs/xfs_attr_item.c   |   15 +++++++++++++--
 3 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 33f1d032ef138..302b0cf95528a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -339,26 +339,31 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
-/* Initialize transaction reservation for attr operations */
-void
-xfs_init_attr_trans(
+/* Initialize transaction reservation for an xattr set/replace/upsert */
+unsigned int
+xfs_attr_init_set_trans(
 	struct xfs_da_args	*args,
-	struct xfs_trans_res	*tres,
-	unsigned int		*total)
+	struct xfs_trans_res	*tres)
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
 
-	if (args->value) {
-		tres->tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres *
-				 args->total;
-		tres->tr_logcount = XFS_ATTRSET_LOG_COUNT;
+	tres->tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+			  M_RES(mp)->tr_attrsetrt.tr_logres * args->total;
+	tres->tr_logcount = XFS_ATTRSET_LOG_COUNT;
 		tres->tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		*total = args->total;
-	} else {
-		*tres = M_RES(mp)->tr_attrrm;
-		*total = XFS_ATTRRM_SPACE_RES(mp);
-	}
+	return args->total;
+}
+
+/* Initialize transaction reservation for an xattr remove */
+unsigned int
+xfs_attr_init_remove_trans(
+	struct xfs_da_args	*args,
+	struct xfs_trans_res	*tres)
+{
+	struct xfs_mount	*mp = args->dp->i_mount;
+
+	*tres = M_RES(mp)->tr_attrrm;
+	return XFS_ATTRRM_SPACE_RES(mp);
 }
 
 /*
@@ -1021,7 +1026,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	int			error, local;
 	int			rmt_blks = 0;
-	unsigned int		total;
+	unsigned int		total = 0;
 
 	ASSERT(!args->trans);
 
@@ -1049,10 +1054,12 @@ xfs_attr_set(
 		if (!local)
 			rmt_blks = xfs_attr3_rmt_blocks(mp, args->attr_filter,
 					args->valuelen);
+		total = xfs_attr_init_set_trans(args, &tres);
 		break;
 	case XFS_ATTRUPDATE_REMOVE:
 		XFS_STATS_INC(mp, xs_attr_remove);
 		rmt_blks = xfs_attr3_max_rmt_blocks(mp);
+		total = xfs_attr_init_remove_trans(args, &tres);
 		break;
 	}
 
@@ -1060,7 +1067,6 @@ xfs_attr_set(
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
-	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 088cb7b301680..616b0b5a0f11c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -565,8 +565,10 @@ bool xfs_attr_check_namespace(unsigned int attr_flags);
 bool xfs_attr_namecheck(unsigned int attr_flags, const void *name,
 		size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
-void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
-			 unsigned int *total);
+unsigned int xfs_attr_init_set_trans(struct xfs_da_args *args,
+		struct xfs_trans_res *tres);
+unsigned int xfs_attr_init_remove_trans(struct xfs_da_args *args,
+		struct xfs_trans_res *tres);
 
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2b10ac4c5fce2..cff051ccafa43 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -746,7 +746,7 @@ xfs_attr_recover_work(
 	struct xfs_attri_log_format	*attrp;
 	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
 	int				error;
-	int				total;
+	unsigned int			total = 0;
 
 	/*
 	 * First check the validity of the attr described by the ATTRI.  If any
@@ -763,7 +763,18 @@ xfs_attr_recover_work(
 		return PTR_ERR(attr);
 	args = attr->xattri_da_args;
 
-	xfs_init_attr_trans(args, &resv, &total);
+	switch (xfs_attr_intent_op(attr)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		total = xfs_attr_init_set_trans(args, &resv);
+		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		total = xfs_attr_init_remove_trans(args, &resv);
+		break;
+	}
 	resv = xlog_recover_resv(&resv);
 	error = xfs_trans_alloc(mp, &resv, total, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
