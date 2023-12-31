Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F046C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+x8CHX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F72C433C7;
	Sun, 31 Dec 2023 23:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065532;
	bh=viBc982nQ80zJhQyCuFg35i8lVowkqJDzPvsvt5B928=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G+x8CHX5mo9ia/xar4TB0ZsX/D+9+f4C6Uvz9Cjg0yn8srM+MgVbGyC4UQZAZSevF
	 ENX6VwBAdPeB+pj3KXolqBDfDqkiOEqtduKV1UoSIYxKiChrxIJ1ZpYCOMzG1cISYm
	 dH83MRlvvDFPob17e9J4Whg4ESAIhgVGAJoA5TurZuDkbuOrq1JldjGfo371HjZtFW
	 uqM6hAwe7YmTkmyIiibJ1r8wuz+FujTBNfS2BSbOEUQTrzHa8TYKazujQ7oe/8SmSQ
	 X1w3oWhtrwz0Eg9glZHSL5HBPLODosm/GSwjDNVleFJP1it3oGIBi/agh1yXICpIkj
	 h1r8yVf57W7nw==
Date: Sun, 31 Dec 2023 15:32:11 -0800
Subject: [PATCH 10/58] xfs: load metadata directory root at mount time
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010080.1809361.5972158645244058110.stgit@frogsfrogsfrogs>
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

Load the metadata directory root inode into memory at mount time and
release it at unmount time.  We also make sure that the obsolete inode
pointers in the superblock are not logged or read from the superblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h |    1 +
 libxfs/init.c       |   13 +++++++++++++
 libxfs/xfs_sb.c     |   31 +++++++++++++++++++++++++++++++
 libxfs/xfs_types.c  |    2 +-
 4 files changed, 46 insertions(+), 1 deletion(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 7dfa94dfd9f..8952869d89a 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -66,6 +66,7 @@ typedef struct xfs_mount {
 	uint8_t			*m_rsum_cache;
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
+	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
 	struct xfs_buftarg	*m_ddev_targp;
 	struct xfs_buftarg	*m_logdev_targp;
 	struct xfs_buftarg	*m_rtdev_targp;
diff --git a/libxfs/init.c b/libxfs/init.c
index c0f148e75a2..67f9e1fe99b 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -685,6 +685,17 @@ libxfs_mountfs_imeta(
 	if (error)
 		return;
 
+	if (xfs_has_metadir(mp)) {
+		error = -libxfs_imeta_iget(tp, mp->m_sb.sb_metadirino,
+				XFS_DIR3_FT_DIR, &mp->m_metadirip);
+		if (error) {
+			fprintf(stderr,
+ _("%s: Failed to load metadir root directory, error %d\n"),
+					progname, error);
+			goto err_cancel;
+		}
+	}
+
 	error = -xfs_imeta_mount(tp);
 	if (error) {
 		fprintf(stderr,
@@ -991,6 +1002,8 @@ libxfs_umount(
 	int			error;
 
 	libxfs_rtmount_destroy(mp);
+	if (mp->m_metadirip)
+		libxfs_imeta_irele(mp->m_metadirip);
 
 	/*
 	 * Purge the buffer cache to write all dirty buffers to disk and free
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 49d62281995..b74a170605d 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -680,6 +680,25 @@ __xfs_sb_from_disk(
 	/* Convert on-disk flags to in-memory flags? */
 	if (convert_xquota)
 		xfs_sb_quota_from_disk(to);
+
+	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
+		/*
+		 * Set metadirino here and null out the in-core fields for
+		 * the other inodes because metadir initialization will load
+		 * them later.
+		 */
+		to->sb_metadirino = be64_to_cpu(from->sb_rbmino);
+		to->sb_rbmino = NULLFSINO;
+		to->sb_rsumino = NULLFSINO;
+
+		/*
+		 * We don't have to worry about quota inode conversion here
+		 * because metadir requires a v5 filesystem.
+		 */
+		to->sb_uquotino = NULLFSINO;
+		to->sb_gquotino = NULLFSINO;
+		to->sb_pquotino = NULLFSINO;
+	}
 }
 
 void
@@ -827,6 +846,18 @@ xfs_sb_to_disk(
 	to->sb_lsn = cpu_to_be64(from->sb_lsn);
 	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
+
+	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
+		/*
+		 * Save metadirino here and null out the on-disk fields for
+		 * the other inodes, at least until we reuse the fields.
+		 */
+		to->sb_rbmino = cpu_to_be64(from->sb_metadirino);
+		to->sb_rsumino = cpu_to_be64(NULLFSINO);
+		to->sb_uquotino = cpu_to_be64(NULLFSINO);
+		to->sb_gquotino = cpu_to_be64(NULLFSINO);
+		to->sb_pquotino = cpu_to_be64(NULLFSINO);
+	}
 }
 
 /*
diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index 88720b297d7..f5eab8839e3 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
@@ -128,7 +128,7 @@ xfs_verify_dir_ino(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
-	if (xfs_internal_inum(mp, ino))
+	if (!xfs_has_metadir(mp) && xfs_internal_inum(mp, ino))
 		return false;
 	return xfs_verify_ino(mp, ino);
 }

