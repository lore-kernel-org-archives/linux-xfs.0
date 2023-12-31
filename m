Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA40C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YEXlnBke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722AEC433C8;
	Sun, 31 Dec 2023 23:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065563;
	bh=SaXrvfuQZoCuE/QVc5c0xD6nuB2f3789/IfUozcAH+M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YEXlnBke5iQ4djKpFwQClv446h2EWCl3OvMpgNynyGLpU24muaBwQP6SDWsT3nO2H
	 l8Nsp27Xzr+v8XGJVWmIoiI6Qt6thn4BNHk7D0LSP6gKuw9els6m7rYvqhFbpn9dkQ
	 J0kCws2fMb7EuOWuG/a6GXNOxh29GOpnDOyhaybM27phO/d30fawd3Hl7whPS+AO4L
	 VzqL1IBMQux6ynZjQ/VPWoK5wpXVu8hBF1aFVh5tLL4zy7/DMtYRRnR3fJ7WdhrwER
	 BHCKdrHAyJV4lw6iyKMJaOPQ1Wn7JwwognmhVUcyTgcX0qm7u23zJdLfQaqmii1VeM
	 sKyXvYqRfST3Q==
Date: Sun, 31 Dec 2023 15:32:42 -0800
Subject: [PATCH 12/58] xfs: enforce metadata inode flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010107.1809361.1975192314738430464.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
 libxfs/inode.c         |    5 +++
 libxfs/xfs_inode_buf.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_buf.h |    3 ++
 3 files changed, 80 insertions(+), 1 deletion(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 560b127ee9d..5cb2fd7891a 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -244,7 +244,8 @@ libxfs_imeta_iget(
 	if (error)
 		return error;
 
-	if (ftype == XFS_DIR3_FT_UNKNOWN ||
+	if ((xfs_has_metadir(mp) && !xfs_is_metadir_inode(ip)) ||
+	    ftype == XFS_DIR3_FT_UNKNOWN ||
 	    xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype) {
 		libxfs_irele(ip);
 		return -EFSCORRUPTED;
@@ -291,6 +292,8 @@ void
 libxfs_imeta_irele(
 	struct xfs_inode	*ip)
 {
+	ASSERT(!xfs_has_metadir(ip->i_mount) || xfs_is_metadir_inode(ip));
+
 	libxfs_irele(ip);
 }
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index aee581d53c8..8d100595756 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -457,6 +457,73 @@ xfs_dinode_verify_nrext64(
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
@@ -621,6 +688,12 @@ xfs_dinode_verify(
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
 
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 585ed5a110a..8d43d2641c7 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -28,6 +28,9 @@ int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 
 xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
 			   struct xfs_dinode *dip);
+xfs_failaddr_t xfs_dinode_verify_metadir(struct xfs_mount *mp,
+		struct xfs_dinode *dip, uint16_t mode, uint16_t flags,
+		uint64_t flags2);
 xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
 		uint32_t extsize, uint16_t mode, uint16_t flags);
 xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,

