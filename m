Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F1CBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iseXg58w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCBAC433C7;
	Sun, 31 Dec 2023 21:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056946;
	bh=5COLX7mGNH6r3IhrR2tURNGbDnTe/jhI1qJV7DblWjc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iseXg58wtD+oSLnm23Hi2Az65jCVxx6rqTplE1SY5Zv8Nr/KF49D4FTRqUpCNMN75
	 CO6XEUmbqYmVotl5c8No3HRA09KljFkJ2GtOApZNieWKM4IApGLYmWbtLi5dNHH0SY
	 XFhntvFOeWA9kaw0cG5uzLQodL6e3QVRIIrtXxKrgSEe0WyWgfUvmUS1KU16vsUtWM
	 /+Jen92x9yB97QB78TpPDumus+cqrE7DSYAFqDycIltzBIk06kxwa1VrXwH+M9Zwug
	 2bWE72gAdQaQyat5Ozj5IIZJ5oy6lQIik/ss21UzBktoP4dZ2C6Rup+iDhXbZH7/nT
	 Nx8R8GQinCOCg==
Date: Sun, 31 Dec 2023 13:09:05 -0800
Subject: [PATCH 11/32] xfs: enforce metadata inode flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845041.1760491.1555837437528332561.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Add checks for the metadata inode flag so that we don't ever leak
metadata inodes out to userspace, and we don't ever try to read a
regular inode as metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   73 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.h |    3 ++
 fs/xfs/scrub/common.c         |   10 ++++--
 fs/xfs/scrub/inode.c          |   25 +++++++++++++-
 fs/xfs/scrub/inode_repair.c   |   10 ++++++
 fs/xfs/xfs_icache.c           |    2 +
 fs/xfs/xfs_inode.c            |   13 +++++++
 7 files changed, 132 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d79002343d0b6..18d9e71a3bb30 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -460,6 +460,73 @@ xfs_dinode_verify_nrext64(
 	return NULL;
 }
 
+/*
+ * Validate all the picky requirements we have for a file that claims to be
+ * filesystem metadata.
+ */
+xfs_failaddr_t
+xfs_dinode_verify_metadir(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip,
+	uint16_t		mode,
+	uint16_t		flags,
+	uint64_t		flags2)
+{
+	if (!xfs_has_metadir(mp))
+		return __this_address;
+
+	/* V5 filesystem only */
+	if (dip->di_version < 3)
+		return __this_address;
+
+	/* V3 inode fields that are always zero */
+	if (dip->di_onlink)
+		return __this_address;
+	if ((flags2 & XFS_DIFLAG2_NREXT64) && dip->di_nrext64_pad)
+		return __this_address;
+	if (!(flags2 & XFS_DIFLAG2_NREXT64) && dip->di_flushiter)
+		return __this_address;
+
+	/* Metadata files can only be directories or regular files */
+	if (!S_ISDIR(mode) && !S_ISREG(mode))
+		return __this_address;
+
+	/* They must have zero access permissions */
+	if (mode & 0777)
+		return __this_address;
+
+	/* DMAPI event and state masks are zero */
+	if (dip->di_dmevmask || dip->di_dmstate)
+		return __this_address;
+
+	/* User, group, and project IDs must be zero */
+	if (dip->di_uid || dip->di_gid ||
+	    dip->di_projid_lo || dip->di_projid_hi)
+		return __this_address;
+
+	/* Immutable, sync, noatime, nodump, and nodefrag flags must be set */
+	if (!(flags & XFS_DIFLAG_IMMUTABLE))
+		return __this_address;
+	if (!(flags & XFS_DIFLAG_SYNC))
+		return __this_address;
+	if (!(flags & XFS_DIFLAG_NOATIME))
+		return __this_address;
+	if (!(flags & XFS_DIFLAG_NODUMP))
+		return __this_address;
+	if (!(flags & XFS_DIFLAG_NODEFRAG))
+		return __this_address;
+
+	/* Directories must have nosymlinks flags set */
+	if (S_ISDIR(mode) && !(flags & XFS_DIFLAG_NOSYMLINKS))
+		return __this_address;
+
+	/* dax flags2 must not be set */
+	if (flags2 & XFS_DIFLAG2_DAX)
+		return __this_address;
+
+	return NULL;
+}
+
 xfs_failaddr_t
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
@@ -624,6 +691,12 @@ xfs_dinode_verify(
 	    !xfs_has_bigtime(mp))
 		return __this_address;
 
+	if (flags2 & XFS_DIFLAG2_METADIR) {
+		fa = xfs_dinode_verify_metadir(mp, dip, mode, flags, flags2);
+		if (fa)
+			return fa;
+	}
+
 	return NULL;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 585ed5a110af4..8d43d2641c732 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -28,6 +28,9 @@ int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 
 xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
 			   struct xfs_dinode *dip);
+xfs_failaddr_t xfs_dinode_verify_metadir(struct xfs_mount *mp,
+		struct xfs_dinode *dip, uint16_t mode, uint16_t flags,
+		uint64_t flags2);
 xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
 		uint32_t extsize, uint16_t mode, uint16_t flags);
 xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 74be3b7341b51..fbc28bd98e957 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -942,9 +942,15 @@ xchk_iget_for_scrubbing(
 	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino)
 		return xchk_install_live_inode(sc, ip_in);
 
-	/* Reject internal metadata files and obviously bad inode numbers. */
-	if (xfs_internal_inum(mp, sc->sm->sm_ino))
+	/*
+	 * On pre-metadir filesystems, reject internal metadata files.  For
+	 * metadir filesystems, scrubbing any file in the metadata directory
+	 * tree by handle is allowed, because that is the only way to validate
+	 * the metadata directory structure.
+	 */
+	if (!xfs_has_metadir(mp) && xfs_internal_inum(mp, sc->sm->sm_ino))
 		return -ENOENT;
+	/* Reject obviously bad inode numbers. */
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index d32716fb2fecf..7357bf5156ba3 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -60,6 +60,22 @@ xchk_install_handle_iscrub(
 	if (error)
 		return error;
 
+	/*
+	 * Don't allow scrubbing by handle of any inodes in the metadata
+	 * directory tree.  We don't know if any of the scans launched by
+	 * this scrubber will end up indirectly trying to lock this file.
+	 *
+	 * Scrubbers of inode-rooted metadata files (i.e. the non-dir files)
+	 * will attach all the resources needed to scrub the inode and call
+	 * xchk_inode directly.  Hence we do not let userspace call us
+	 * directly.
+	 */
+	if (xfs_is_metadir_inode(ip) && !S_ISDIR(VFS_I(ip)->i_mode)) {
+		xchk_irele(sc, ip);
+		sc->ip = NULL;
+		return -ENOENT;
+	}
+
 	return xchk_prepare_iscrub(sc);
 }
 
@@ -94,9 +110,14 @@ xchk_setup_inode(
 		return xchk_prepare_iscrub(sc);
 	}
 
-	/* Reject internal metadata files and obviously bad inode numbers. */
-	if (xfs_internal_inum(mp, sc->sm->sm_ino))
+	/*
+	 * On pre-metadir filesystems, reject internal metadata files.  For
+	 * metadir filesystems, scrubbing directory inodes in the metadata
+	 * directory tree by handle is allowed.
+	 */
+	if (!xfs_has_metadir(mp) && xfs_internal_inum(mp, sc->sm->sm_ino))
 		return -ENOENT;
+	/* Reject obviously bad inode numbers. */
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 187f782d51f22..e2dde5834051c 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -517,6 +517,16 @@ xrep_dinode_flags(
 		dip->di_nrext64_pad = 0;
 	else if (dip->di_version >= 3)
 		dip->di_v3_pad = 0;
+
+	if (flags2 & XFS_DIFLAG2_METADIR) {
+		xfs_failaddr_t	fa;
+
+		fa = xfs_dinode_verify_metadir(sc->mp, dip, mode, flags,
+				flags2);
+		if (fa)
+			flags2 &= ~XFS_DIFLAG2_METADIR;
+	}
+
 	dip->di_flags = cpu_to_be16(flags);
 	dip->di_flags2 = cpu_to_be64(flags2);
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index aa8516e8ab64f..64c52e8621fdb 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -841,6 +841,8 @@ xfs_imeta_iget(
 		goto bad_rele;
 	if (xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype)
 		goto bad_rele;
+	if (xfs_has_metadir(mp) && !xfs_is_metadir_inode(ip))
+		goto bad_rele;
 
 	*ipp = ip;
 	return 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f2145e2701f51..4699a9382f757 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -577,8 +577,19 @@ xfs_lookup(
 	if (error)
 		goto out_free_name;
 
+	/*
+	 * Fail if a directory entry in the regular directory tree points to
+	 * a metadata file.
+	 */
+	if (XFS_IS_CORRUPT(dp->i_mount, xfs_is_metadir_inode(*ipp))) {
+		error = -EFSCORRUPTED;
+		goto out_irele;
+	}
+
 	return 0;
 
+out_irele:
+	xfs_irele(*ipp);
 out_free_name:
 	if (ci_name)
 		kmem_free(ci_name->name);
@@ -2746,6 +2757,8 @@ void
 xfs_imeta_irele(
 	struct xfs_inode	*ip)
 {
+	ASSERT(!xfs_has_metadir(ip->i_mount) || xfs_is_metadir_inode(ip));
+
 	xfs_irele(ip);
 }
 

