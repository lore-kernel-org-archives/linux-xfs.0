Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F72EB64C
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371361; cv=none; b=EaJAJtAuUjlB1YZmGPDQBvoWhdrDML0it0b9JwDowpeesY8tU8+ULW211AzLyuhrUDu9wzW8+YVcqIM2uDPXnl4hQwGnflpCj3CaFLsIOd0DA2O3lA+74g2bMH3Q+rlezRMFRNlSvjXanh9HXl+h2bDtaKM6dSgNg97toIefSAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371361; c=relaxed/simple;
	bh=s75AhDv7JFKFKyQpY3SMN0Zqquc9Egq96qEX+gzYJJU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cm1Y+Yz3QqnQNZ0Q0v0Opn3/HZGBTEGo0s1fFq8hs7fSfZ67Q5z8OiwHQvvHD0tbFIW9Kdu17gNmokiuZCuAk5uKVqhW38CMIkxAH3UUHfYLgsFrqNRlJkkztQuqCLjX91kbmvqHBF0Dk2GwTi/YUE745CLalBTaiZhLG1rcllg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qQLhkd9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQLhkd9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461ADC32782;
	Fri, 23 Aug 2024 00:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371361;
	bh=s75AhDv7JFKFKyQpY3SMN0Zqquc9Egq96qEX+gzYJJU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qQLhkd9rvNTdVtmylyuvTWalEJUzFr8s6FH3hzizyF15k82eqQITh9tALSov2EV9r
	 MUSEd1heZuzVF7VqkAUggnwHSlFT6TTUsv6iE6fT5eqL6uuvC3doGOqqNOXWgPj0ur
	 oxCovtLOODm/FQ96K30rgpUeptnPlbPHsvPBwPl8zrH5tY2B1DePQ/HRIaqeJ3cC2q
	 U6sk2CkffHj0K7Kucp6FdfJEk2DKINkKJojV9kS+Hy3u4yYZYL+5W68id6WEcC66CB
	 o0srtii19+roZgs15ZiNWvUjhAg9z/HUnZmm/t/d7/UMscvUo1F7jCE+dFnBDFXswT
	 RDBxjzyYSTCKQ==
Date: Thu, 22 Aug 2024 17:02:40 -0700
Subject: [PATCH 02/26] xfs: refactor loading quota inodes in the regular case
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085206.57482.3726157833898843274.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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

Create a helper function to load quota inodes in the case where the
dqtype and the sb quota inode fields correspond.  This is true for
nearly all the iget callsites in the quota code, except for when we're
switching the group and project quota inodes.  We'll need this in
subsequent patches to make the metadir handling less convoluted.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c          |   46 +++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_qm.h          |    3 +++
 fs/xfs/xfs_qm_syscalls.c |   13 +++++------
 fs/xfs/xfs_quotaops.c    |   53 +++++++++++++++++++++++++++-------------------
 4 files changed, 80 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 63f6ca2db2515..7e2307921deb2 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1538,6 +1538,43 @@ xfs_qm_mount_quotas(
 	}
 }
 
+/*
+ * Load the inode for a given type of quota, assuming that the sb fields have
+ * been sorted out.  This is not true when switching quota types on a V4
+ * filesystem, so do not use this function for that.
+ *
+ * Returns -ENOENT if the quota inode field is NULLFSINO; 0 and an inode on
+ * success; or a negative errno.
+ */
+int
+xfs_qm_qino_load(
+	struct xfs_mount	*mp,
+	xfs_dqtype_t		type,
+	struct xfs_inode	**ipp)
+{
+	xfs_ino_t		ino = NULLFSINO;
+
+	switch (type) {
+	case XFS_DQTYPE_USER:
+		ino = mp->m_sb.sb_uquotino;
+		break;
+	case XFS_DQTYPE_GROUP:
+		ino = mp->m_sb.sb_gquotino;
+		break;
+	case XFS_DQTYPE_PROJ:
+		ino = mp->m_sb.sb_pquotino;
+		break;
+	default:
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	if (ino == NULLFSINO)
+		return -ENOENT;
+
+	return xfs_iget(mp, NULL, ino, 0, 0, ipp);
+}
+
 /*
  * This is called after the superblock has been read in and we're ready to
  * iget the quota inodes.
@@ -1561,24 +1598,21 @@ xfs_qm_init_quotainos(
 		if (XFS_IS_UQUOTA_ON(mp) &&
 		    mp->m_sb.sb_uquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_uquotino > 0);
-			error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
-					     0, 0, &uip);
+			error = xfs_qm_qino_load(mp, XFS_DQTYPE_USER, &uip);
 			if (error)
 				return error;
 		}
 		if (XFS_IS_GQUOTA_ON(mp) &&
 		    mp->m_sb.sb_gquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_gquotino > 0);
-			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
-					     0, 0, &gip);
+			error = xfs_qm_qino_load(mp, XFS_DQTYPE_GROUP, &gip);
 			if (error)
 				goto error_rele;
 		}
 		if (XFS_IS_PQUOTA_ON(mp) &&
 		    mp->m_sb.sb_pquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_pquotino > 0);
-			error = xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
-					     0, 0, &pip);
+			error = xfs_qm_qino_load(mp, XFS_DQTYPE_PROJ, &pip);
 			if (error)
 				goto error_rele;
 		}
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 6e09dfcd13e25..e919c7f62f578 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -184,4 +184,7 @@ xfs_get_defquota(struct xfs_quotainfo *qi, xfs_dqtype_t type)
 	}
 }
 
+int xfs_qm_qino_load(struct xfs_mount *mp, xfs_dqtype_t type,
+		struct xfs_inode **ipp);
+
 #endif /* __XFS_QM_H__ */
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 392cb39cc10c8..4eda50ae2d1cb 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -53,16 +53,15 @@ xfs_qm_scall_quotaoff(
 STATIC int
 xfs_qm_scall_trunc_qfile(
 	struct xfs_mount	*mp,
-	xfs_ino_t		ino)
+	xfs_dqtype_t		type)
 {
 	struct xfs_inode	*ip;
 	struct xfs_trans	*tp;
 	int			error;
 
-	if (ino == NULLFSINO)
+	error = xfs_qm_qino_load(mp, type, &ip);
+	if (error == -ENOENT)
 		return 0;
-
-	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
 	if (error)
 		return error;
 
@@ -113,17 +112,17 @@ xfs_qm_scall_trunc_qfiles(
 	}
 
 	if (flags & XFS_QMOPT_UQUOTA) {
-		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_uquotino);
+		error = xfs_qm_scall_trunc_qfile(mp, XFS_DQTYPE_USER);
 		if (error)
 			return error;
 	}
 	if (flags & XFS_QMOPT_GQUOTA) {
-		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
+		error = xfs_qm_scall_trunc_qfile(mp, XFS_DQTYPE_GROUP);
 		if (error)
 			return error;
 	}
 	if (flags & XFS_QMOPT_PQUOTA)
-		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_pquotino);
+		error = xfs_qm_scall_trunc_qfile(mp, XFS_DQTYPE_PROJ);
 
 	return error;
 }
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 9c162e69976be..4c7f7ce4fd2f4 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -16,24 +16,25 @@
 #include "xfs_qm.h"
 
 
-static void
+static int
 xfs_qm_fill_state(
 	struct qc_type_state	*tstate,
 	struct xfs_mount	*mp,
-	struct xfs_inode	*ip,
-	xfs_ino_t		ino,
-	struct xfs_def_quota	*defq)
+	xfs_dqtype_t		type)
 {
-	bool			tempqip = false;
+	struct xfs_inode	*ip;
+	struct xfs_def_quota	*defq;
+	int			error;
 
-	tstate->ino = ino;
-	if (!ip && ino == NULLFSINO)
-		return;
-	if (!ip) {
-		if (xfs_iget(mp, NULL, ino, 0, 0, &ip))
-			return;
-		tempqip = true;
+	error = xfs_qm_qino_load(mp, type, &ip);
+	if (error) {
+		tstate->ino = NULLFSINO;
+		return error != -ENOENT ? error : 0;
 	}
+
+	defq = xfs_get_defquota(mp->m_quotainfo, type);
+
+	tstate->ino = ip->i_ino;
 	tstate->flags |= QCI_SYSFILE;
 	tstate->blocks = ip->i_nblocks;
 	tstate->nextents = ip->i_df.if_nextents;
@@ -43,8 +44,9 @@ xfs_qm_fill_state(
 	tstate->spc_warnlimit = 0;
 	tstate->ino_warnlimit = 0;
 	tstate->rt_spc_warnlimit = 0;
-	if (tempqip)
-		xfs_irele(ip);
+	xfs_irele(ip);
+
+	return 0;
 }
 
 /*
@@ -56,8 +58,9 @@ xfs_fs_get_quota_state(
 	struct super_block	*sb,
 	struct qc_state		*state)
 {
-	struct xfs_mount *mp = XFS_M(sb);
-	struct xfs_quotainfo *q = mp->m_quotainfo;
+	struct xfs_mount	*mp = XFS_M(sb);
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
+	int			error;
 
 	memset(state, 0, sizeof(*state));
 	if (!XFS_IS_QUOTA_ON(mp))
@@ -76,12 +79,18 @@ xfs_fs_get_quota_state(
 	if (XFS_IS_PQUOTA_ENFORCED(mp))
 		state->s_state[PRJQUOTA].flags |= QCI_LIMITS_ENFORCED;
 
-	xfs_qm_fill_state(&state->s_state[USRQUOTA], mp, q->qi_uquotaip,
-			  mp->m_sb.sb_uquotino, &q->qi_usr_default);
-	xfs_qm_fill_state(&state->s_state[GRPQUOTA], mp, q->qi_gquotaip,
-			  mp->m_sb.sb_gquotino, &q->qi_grp_default);
-	xfs_qm_fill_state(&state->s_state[PRJQUOTA], mp, q->qi_pquotaip,
-			  mp->m_sb.sb_pquotino, &q->qi_prj_default);
+	error = xfs_qm_fill_state(&state->s_state[USRQUOTA], mp,
+			XFS_DQTYPE_USER);
+	if (error)
+		return error;
+	error = xfs_qm_fill_state(&state->s_state[GRPQUOTA], mp,
+			XFS_DQTYPE_GROUP);
+	if (error)
+		return error;
+	error = xfs_qm_fill_state(&state->s_state[PRJQUOTA], mp,
+			XFS_DQTYPE_PROJ);
+	if (error)
+		return error;
 	return 0;
 }
 

