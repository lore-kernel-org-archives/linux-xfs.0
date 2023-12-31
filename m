Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A20DDA9
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U0j/sDG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1375C433C8;
	Sun, 31 Dec 2023 23:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065985;
	bh=PEZ6dQLon4Mar3SF8ooZq5QfKOeYVAnhltKRlBiRigU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U0j/sDG5hbfNvXyPgrlpGZLVuPjX2rMtofJMPf6iHum8jx2Q511Pm+5WSQ9O0Wv3J
	 bcYaSp5bjiyAyApPD9UNBWDJI7AvZP3i0VKRc/0Cy2kAn3jz/6nj7kgC/06EpXpBJs
	 Yz4eFN3H47x8Q6zS1w1G0l14RCpzDBKr4f1KTD2WNUbAZOcq7QsuaI66IbDGCCWA6F
	 4LAj3s5KsvnaU4Jeq8+hYIk5GeVaPNTjpqPIlOcUCjGn2zQOMfPlnCrQ01HYheCP15
	 Xi5SdhsIT3q2q8YjNW/6c3MlCSIrkEDfPbofiFpUzZeINkdGueaQvri+Me1Z3y+hSu
	 0BRKTh8OV9tcg==
Date: Sun, 31 Dec 2023 15:39:45 -0800
Subject: [PATCH 39/58] xfs_repair: dont check metadata directory dirent
 inumbers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010467.1809361.17760617458885170181.stgit@frogsfrogsfrogs>
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

Phase 6 always rebuilds the entire metadata directory tree, and repair
quietly ignores all the DIFLAG2_METADATA directory inodes that it finds.
As a result, none of the metadata directories are marked inuse in the
incore data.  Therefore, the is_inode_free checks are not valid for
anything we find in a metadata directory.

Therefore, avoid checking is_inode_free when scanning metadata directory
dirents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/dir2.c            |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index ca8e231c0fd..e171755a6f0 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -106,6 +106,7 @@
 #define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
 #define xfs_dinode_good_version		libxfs_dinode_good_version
 #define xfs_dinode_verify		libxfs_dinode_verify
+#define xfs_dinode_verify_metadir	libxfs_dinode_verify_metadir
 
 #define xfs_dir2_data_bestfree_p	libxfs_dir2_data_bestfree_p
 #define xfs_dir2_data_entry_tag_p	libxfs_dir2_data_entry_tag_p
diff --git a/repair/dir2.c b/repair/dir2.c
index b4ebcd56d57..1184392ff47 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -165,6 +165,28 @@ is_meta_ino(
 	return reason != NULL;
 }
 
+static inline bool
+is_metadata_directory(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip)
+{
+	xfs_failaddr_t		fa;
+	uint16_t		mode;
+	uint16_t		flags;
+	uint64_t		flags2;
+
+	if (!xfs_has_metadir(mp))
+		return false;
+	if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADIR)))
+		return false;
+
+	mode = be16_to_cpu(dip->di_mode);
+	flags = be16_to_cpu(dip->di_flags);
+	flags2 = be64_to_cpu(dip->di_flags2);
+	fa = libxfs_dinode_verify_metadir(mp, dip, mode, flags, flags2);
+	return fa == NULL;
+}
+
 /*
  * this routine performs inode discovery and tries to fix things
  * in place.  available redundancy -- inode data size should match
@@ -256,6 +278,12 @@ process_sf_dir2(
 		} else if (!libxfs_verify_dir_ino(mp, lino)) {
 			junkit = 1;
 			junkreason = _("invalid");
+		} else if (is_metadata_directory(mp, dip)) {
+			/*
+			 * Metadata directories are always rebuilt, so don't
+			 * bother checking if the child inode is free or not.
+			 */
+			junkit = 0;
 		} else if (is_meta_ino(mp, ino, dip, lino, &junkreason)) {
 			/*
 			 * Directories that are not in the metadir tree should
@@ -718,6 +746,12 @@ process_dir2_data(
 			 * directory since it's still structurally intact.
 			 */
 			clearreason = _("invalid");
+		} else if (is_metadata_directory(mp, dip)) {
+			/*
+			 * Metadata directories are always rebuilt, so don't
+			 * bother checking if the child inode is free or not.
+			 */
+			clearino = 0;
 		} else if (is_meta_ino(mp, ino, dip, ent_ino, &clearreason)) {
 			/*
 			 * Directories that are not in the metadir tree should

