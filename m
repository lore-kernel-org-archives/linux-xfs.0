Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987687462
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 01:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584330; cv=none; b=WoLOEjJy2l07eQBJyifRAYg0wLC1a8w77F+LVFr/wHR/ObdZCeQdqSx10E+IEXUaJbezeNBxgj6rPaC0TbkjFXEoDKvqH3PDVz1SnahvZH76US4ORXfa7XalxMskgzxo5W/yal5xeKaX39gDIvQ9MItko+AQWHKqJ90sA49jMR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584330; c=relaxed/simple;
	bh=G8P+ogE+bxuBAmqY4Lj424BQNciA8LSuhnc1xgfRdsY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GpvLI2I8Utz/qLlOJ8fHmWEWA9csPw6A+U7bBZZ/jX4o+aLQXgOllQLh91T0NjTEm5F5DY1alvGnuq2ya59ZcoCZyHSYXhTN4goYC8mHAAE5zrxx2mlBnCLy0PFa8LhUK1Zgdf5fqVK2GQOqYxkeJxMsE40XnEcrgiRcDnWrUq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C44VgRLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C44VgRLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A01C4CECE;
	Tue, 26 Nov 2024 01:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584330;
	bh=G8P+ogE+bxuBAmqY4Lj424BQNciA8LSuhnc1xgfRdsY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C44VgRLIdhaRsfhwGOLF3Wk4PAJDCF+2oDEYoVMi2dZKbpo5R1+9Y5EVQSF7lwo/E
	 FIm378jtiiEy60HfD3LWjUpy2KPK8KL3vIeR+BCxv6d8OE0KEU2IbNy2zWMyAnaYr2
	 Sc2mGyexFB2xn+lKLzIURhtohG4ABaylKtlcqfBSV0FLUzqZubfccnp81TK1SW3fOk
	 Qqg4+oKzNRvWjyzy/BPqXOG4AWjIpGkfObKWp3oPFeFtQ3NdBYowraKQ7Awi36GHvE
	 zIiZLctvGmT6zy7Fcjm242eG3+vxvR5Z39P7bHDM6fFaK5TJicSn33WJHl/TALYRCz
	 G0zazquAHrkMw==
Date: Mon, 25 Nov 2024 17:25:29 -0800
Subject: [PATCH 03/21] xfs: keep quota directory inode loaded
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173258397854.4032920.7776347980322455777.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In the same vein as the previous patch, there's no point in the metapath
scrub setup function doing a lookup on the quota metadir just so it can
validate that lookups work correctly.  Instead, retain the quota
directory inode in memory for the lifetime of the mount so that we can
check this meaningfully.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/metapath.c |   37 ++++++-------------------------------
 fs/xfs/xfs_qm.c         |   47 +++++++++++++++++++++++++----------------------
 fs/xfs/xfs_qm.h         |    1 +
 3 files changed, 32 insertions(+), 53 deletions(-)


diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 80467d6bc76389..c678cba1ffc3f7 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -171,23 +171,13 @@ static int
 xchk_setup_metapath_quotadir(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_trans	*tp;
-	struct xfs_inode	*dp = NULL;
-	int			error;
+	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 
-	error = xfs_trans_alloc_empty(sc->mp, &tp);
-	if (error)
-		return error;
+	if (!qi || !qi->qi_dirip)
+		return -ENOENT;
 
-	error = xfs_dqinode_load_parent(tp, &dp);
-	xfs_trans_cancel(tp);
-	if (error)
-		return error;
-
-	error = xchk_setup_metapath_scan(sc, sc->mp->m_metadirip,
-			kasprintf(GFP_KERNEL, "quota"), dp);
-	xfs_irele(dp);
-	return error;
+	return xchk_setup_metapath_scan(sc, sc->mp->m_metadirip,
+			kstrdup("quota", GFP_KERNEL), qi->qi_dirip);
 }
 
 /* Scan a quota inode under the /quota directory. */
@@ -197,10 +187,7 @@ xchk_setup_metapath_dqinode(
 	xfs_dqtype_t		type)
 {
 	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
-	struct xfs_trans	*tp = NULL;
-	struct xfs_inode	*dp = NULL;
 	struct xfs_inode	*ip = NULL;
-	int			error;
 
 	if (!qi)
 		return -ENOENT;
@@ -222,20 +209,8 @@ xchk_setup_metapath_dqinode(
 	if (!ip)
 		return -ENOENT;
 
-	error = xfs_trans_alloc_empty(sc->mp, &tp);
-	if (error)
-		return error;
-
-	error = xfs_dqinode_load_parent(tp, &dp);
-	xfs_trans_cancel(tp);
-	if (error)
-		return error;
-
-	error = xchk_setup_metapath_scan(sc, dp,
+	return xchk_setup_metapath_scan(sc, qi->qi_dirip,
 			kstrdup(xfs_dqinode_path(type), GFP_KERNEL), ip);
-
-	xfs_irele(dp);
-	return error;
 }
 #else
 # define xchk_setup_metapath_quotadir(...)	(-ENOENT)
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b928b036990bc3..a4fa21dfd6b4ad 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -241,6 +241,10 @@ xfs_qm_destroy_quotainos(
 		xfs_irele(qi->qi_pquotaip);
 		qi->qi_pquotaip = NULL;
 	}
+	if (qi->qi_dirip) {
+		xfs_irele(qi->qi_dirip);
+		qi->qi_dirip = NULL;
+	}
 }
 
 /*
@@ -648,8 +652,7 @@ xfs_qm_init_timelimits(
 static int
 xfs_qm_load_metadir_qinos(
 	struct xfs_mount	*mp,
-	struct xfs_quotainfo	*qi,
-	struct xfs_inode	**dpp)
+	struct xfs_quotainfo	*qi)
 {
 	struct xfs_trans	*tp;
 	int			error;
@@ -658,7 +661,7 @@ xfs_qm_load_metadir_qinos(
 	if (error)
 		return error;
 
-	error = xfs_dqinode_load_parent(tp, dpp);
+	error = xfs_dqinode_load_parent(tp, &qi->qi_dirip);
 	if (error == -ENOENT) {
 		/* no quota dir directory, but we'll create one later */
 		error = 0;
@@ -668,21 +671,21 @@ xfs_qm_load_metadir_qinos(
 		goto out_trans;
 
 	if (XFS_IS_UQUOTA_ON(mp)) {
-		error = xfs_dqinode_load(tp, *dpp, XFS_DQTYPE_USER,
+		error = xfs_dqinode_load(tp, qi->qi_dirip, XFS_DQTYPE_USER,
 				&qi->qi_uquotaip);
 		if (error && error != -ENOENT)
 			goto out_trans;
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp)) {
-		error = xfs_dqinode_load(tp, *dpp, XFS_DQTYPE_GROUP,
+		error = xfs_dqinode_load(tp, qi->qi_dirip, XFS_DQTYPE_GROUP,
 				&qi->qi_gquotaip);
 		if (error && error != -ENOENT)
 			goto out_trans;
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp)) {
-		error = xfs_dqinode_load(tp, *dpp, XFS_DQTYPE_PROJ,
+		error = xfs_dqinode_load(tp, qi->qi_dirip, XFS_DQTYPE_PROJ,
 				&qi->qi_pquotaip);
 		if (error && error != -ENOENT)
 			goto out_trans;
@@ -698,34 +701,33 @@ xfs_qm_load_metadir_qinos(
 STATIC int
 xfs_qm_create_metadir_qinos(
 	struct xfs_mount	*mp,
-	struct xfs_quotainfo	*qi,
-	struct xfs_inode	**dpp)
+	struct xfs_quotainfo	*qi)
 {
 	int			error;
 
-	if (!*dpp) {
-		error = xfs_dqinode_mkdir_parent(mp, dpp);
+	if (!qi->qi_dirip) {
+		error = xfs_dqinode_mkdir_parent(mp, &qi->qi_dirip);
 		if (error && error != -EEXIST)
 			return error;
 	}
 
 	if (XFS_IS_UQUOTA_ON(mp) && !qi->qi_uquotaip) {
-		error = xfs_dqinode_metadir_create(*dpp, XFS_DQTYPE_USER,
-				&qi->qi_uquotaip);
+		error = xfs_dqinode_metadir_create(qi->qi_dirip,
+				XFS_DQTYPE_USER, &qi->qi_uquotaip);
 		if (error)
 			return error;
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp) && !qi->qi_gquotaip) {
-		error = xfs_dqinode_metadir_create(*dpp, XFS_DQTYPE_GROUP,
-				&qi->qi_gquotaip);
+		error = xfs_dqinode_metadir_create(qi->qi_dirip,
+				XFS_DQTYPE_GROUP, &qi->qi_gquotaip);
 		if (error)
 			return error;
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp) && !qi->qi_pquotaip) {
-		error = xfs_dqinode_metadir_create(*dpp, XFS_DQTYPE_PROJ,
-				&qi->qi_pquotaip);
+		error = xfs_dqinode_metadir_create(qi->qi_dirip,
+				XFS_DQTYPE_PROJ, &qi->qi_pquotaip);
 		if (error)
 			return error;
 	}
@@ -770,7 +772,6 @@ xfs_qm_init_metadir_qinos(
 	struct xfs_mount	*mp)
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct xfs_inode	*dp = NULL;
 	int			error;
 
 	if (!xfs_has_quota(mp)) {
@@ -779,20 +780,22 @@ xfs_qm_init_metadir_qinos(
 			return error;
 	}
 
-	error = xfs_qm_load_metadir_qinos(mp, qi, &dp);
+	error = xfs_qm_load_metadir_qinos(mp, qi);
 	if (error)
 		goto out_err;
 
-	error = xfs_qm_create_metadir_qinos(mp, qi, &dp);
+	error = xfs_qm_create_metadir_qinos(mp, qi);
 	if (error)
 		goto out_err;
 
-	xfs_irele(dp);
+	/* The only user of the quota dir inode is online fsck */
+#if !IS_ENABLED(CONFIG_XFS_ONLINE_SCRUB)
+	xfs_irele(qi->qi_dirip);
+	qi->qi_dirip = NULL;
+#endif
 	return 0;
 out_err:
 	xfs_qm_destroy_quotainos(mp->m_quotainfo);
-	if (dp)
-		xfs_irele(dp);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index e919c7f62f5780..35b64bc3a7a867 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -55,6 +55,7 @@ struct xfs_quotainfo {
 	struct xfs_inode	*qi_uquotaip;	/* user quota inode */
 	struct xfs_inode	*qi_gquotaip;	/* group quota inode */
 	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
+	struct xfs_inode	*qi_dirip;	/* quota metadir */
 	struct list_lru		qi_lru;
 	int			qi_dquots;
 	struct mutex		qi_quotaofflock;/* to serialize quotaoff */

