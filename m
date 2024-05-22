Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA841360
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 06:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716357722; cv=none; b=UXDBEJVL9f1Fps1iJ6E1HB61sVd5piV5mV7MhrSuHrN/Y1OavaZVtSZ4E5LI3Il0yT/2lVmmaKm7ipzSGqo/AIJwuQjXaOwnVu6qxEJuYU7JQdrVW6KC47bMKfNTiDWC/6YeGYGiQt/0G4q3gwN9W0jWwi6MYiY6DfNB5IxLTRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716357722; c=relaxed/simple;
	bh=xGe4M8S8Qlh/VUZx31qzxQ+K1T8w++ur7J6Sdq0JGT0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZH+zKkc791Yk9M+4uaTek2AzGxlnP9NOCXnSJh9hNDS8BbyOV9iWsiKAZGJxaovYfTeudxI8G07Lyorf4qv+RcpQ16+sMGzQ0Z/979hwzAe5X6gR1gG4kI+YzmwADbr9Ewk+iuF3PxF7av0ZFx8mpSr0C9NgAqbLXxWkIyDrQXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c8joWjo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c8joWjo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1DCC2BD11;
	Wed, 22 May 2024 06:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716357721;
	bh=xGe4M8S8Qlh/VUZx31qzxQ+K1T8w++ur7J6Sdq0JGT0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c8joWjo/jhhGt8u2SWAlypTr4/VDS/drEgegZUGLCvw7tMIKHpfVhuiU4mohNPOuo
	 raCbfHt3ls4JpZT5sqHUV0T4Q0TNxdn32gMY7L5x/M5bINR0YTSXM4712Fj9A+uxdI
	 lMjdCDgNypTJJPKaP+PMAmVR/Q9+fkivtdDuH2Rm7p1iAeU4ytbAGmMBwD5PulVJo4
	 8ZL1ADO6mwLDgavPaisLDoFC5H3XCF8aL2k6t1SVpRiOjMghVq0u8r1+fJWv7nTVdy
	 bSURyfj0npu4bnlk7u6z/mE5wcm5pNF+g6tA89RfuNGEIxYlYuro1V60dUQHoCkQN0
	 M9SOH5H1KpTIA==
Date: Tue, 21 May 2024 23:02:01 -0700
Subject: [PATCH 2/4] xfs: fix xfs_init_attr_trans not handling explicit
 operation codes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171635763404.2619960.15369274752922556657.stgit@frogsfrogsfrogs>
In-Reply-To: <171635763360.2619960.2969937208358016010.stgit@frogsfrogsfrogs>
References: <171635763360.2619960.2969937208358016010.stgit@frogsfrogsfrogs>
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

When we were converting the attr code to use an explicit operation code
instead of keying off of attr->value being null, we forgot to change the
code that initializes the transaction reservation.  Split the function
into two helpers that handle the !remove and remove cases, then fix both
callsites to handle this correctly.

Fixes: c27411d4c640 ("xfs: make attr removal an explicit operation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c |   38 ++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_attr.h |    3 +--
 fs/xfs/xfs_attr_item.c   |   17 +++++++++++++++--
 3 files changed, 34 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 430cd3244c14..f30bcc64100d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -329,26 +329,20 @@ xfs_attr_calc_size(
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
@@ -1006,7 +1000,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	int			error, local;
 	int			rmt_blks = 0;
-	unsigned int		total;
+	unsigned int		total = 0;
 
 	ASSERT(!args->trans);
 
@@ -1033,10 +1027,15 @@ xfs_attr_set(
 
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
 
@@ -1044,7 +1043,6 @@ xfs_attr_set(
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
-	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 088cb7b30168..0e51d0723f9a 100644
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
index 2b10ac4c5fce..f683b7a9323f 100644
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

