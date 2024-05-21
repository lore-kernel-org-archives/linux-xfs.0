Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF06D1CD13
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 16:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716307511; cv=none; b=PwJOv/EU6G7lBTJ3wgx3zhEisK4OlxEN2GSmZuBNzr/4ytPacEVPGCJCiqPJijfba4zesg06Sd7njbdgDnxgh7fGy4c3ySsI40zYSZYSLYf1+AN4f72jjJVdBJFVp/eeoEj8M9U4k7pzV2R00DqwNdglMK7f56GEoV4mmmCu3RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716307511; c=relaxed/simple;
	bh=EJT17WnLXRxQgyJjgbeGGUGUFNL4Eoh+baFdTyPCVmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MO1KNPHqAm3rPh2vTOdAfplCyTU0dIjFe7C1X2AHK+/+LV9Hm0yBEHbL1pEg86n5h77lWZ2AKhYWCqf8LyUouFNZcsfTEEXuYDr/9Gt9L5SQpb9pAUioyM48Npn7P95qcBpjW3oE88UaSu90XUKk88bUw/ocyPK9gls2syGog1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pwLlOxR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pwLlOxR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8E5C2BD11;
	Tue, 21 May 2024 16:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716307510;
	bh=EJT17WnLXRxQgyJjgbeGGUGUFNL4Eoh+baFdTyPCVmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pwLlOxR3YjlA0NyrDACiBWkCoPZU3raybRKBpOtqHQCm1do5zMQPA/FTW+YwdyUWX
	 Lp8gvjw+o/4By9Fjic0ktg1fSHS06rlj/tgr9vO1WnlX+UIvpdqGzUI1AbexDs5Vc1
	 E+o44fpeXQVAFeDYB1TG9L4uZNp2v6Xq0TKDziMmqVry9OwKQx1oeYCwCjqcC2KL1J
	 XVYlQQsMplWtetxmF1j7NYiRReLDrzzBkurLhXW0CvZ13Z2W68A76xlUK/6iJE1BAt
	 HmSHe3jjaYzZveHey7epxghZq9lJaK02VxAz4962JfK4k6elx67KWwX44c4gcSE5Oq
	 etzQt1/4e7EVQ==
Date: Tue, 21 May 2024 09:05:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] xfs: fix xfs_init_attr_trans not handling explicit
 operation codes
Message-ID: <20240521160509.GR25518@frogsfrogsfrogs>
References: <20240521010338.GL25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521010338.GL25518@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

When we were converting the attr code to use an explicit operation code
instead of keying off of attr->value being null, we forgot to change the
code that initializes the transaction reservation.  Split the function
into two helpers that handle the !remove and remove cases, then fix both
callsites to handle this correctly.

Fixes: c27411d4c640 ("xfs: make attr removal an explicit operation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: remove the xfs_init_attr_remove_trans function, fix indenting
---
 fs/xfs/libxfs/xfs_attr.c |   37 +++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_attr.h |    3 +--
 fs/xfs/xfs_attr_item.c   |   17 +++++++++++++++--
 3 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 33f1d032ef138..82f601cd6833a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -339,26 +339,20 @@ xfs_attr_calc_size(
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
@@ -1021,7 +1015,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	int			error, local;
 	int			rmt_blks = 0;
-	unsigned int		total;
+	unsigned int		total = 0;
 
 	ASSERT(!args->trans);
 
@@ -1049,10 +1043,14 @@ xfs_attr_set(
 		if (!local)
 			rmt_blks = xfs_attr3_rmt_blocks(mp, args->attr_filter,
 					args->valuelen);
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
 
@@ -1060,7 +1058,6 @@ xfs_attr_set(
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
-	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 088cb7b301680..0e51d0723f9aa 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -565,8 +565,7 @@ bool xfs_attr_check_namespace(unsigned int attr_flags);
 bool xfs_attr_namecheck(unsigned int attr_flags, const void *name,
 		size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
-void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
-			 unsigned int *total);
+struct xfs_trans_res xfs_attr_set_resv(const struct xfs_da_args *args);
 
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2b10ac4c5fce2..f683b7a9323f1 100644
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
@@ -763,7 +763,20 @@ xfs_attr_recover_work(
 		return PTR_ERR(attr);
 	args = attr->xattri_da_args;
 
-	xfs_init_attr_trans(args, &resv, &total);
+	switch (xfs_attr_intent_op(attr)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		resv = xfs_attr_set_resv(args);
+		total = args->total;
+		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		resv = M_RES(mp)->tr_attrrm;
+		total = XFS_ATTRRM_SPACE_RES(mp);
+		break;
+	}
 	resv = xlog_recover_resv(&resv);
 	error = xfs_trans_alloc(mp, &resv, total, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
