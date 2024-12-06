Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6079213E79
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528723; cv=none; b=SHQK7LefTyU9VfIwIPhrKfYpjQQ3mta7ZPj7A8pZ7g1pfH+YuNnOQbcqNG9I8XISnwPneGWkljZvSWyqLUZW0WU5uZp2ABfi5VhBMgJcq0w1FEdfcmVxLXk/OQ4UnPj6Yy/QSn5VuBtrpmNc/Femu248jvHEPG7PgSxYhHYmotA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528723; c=relaxed/simple;
	bh=Epa2ws7WQKcuJoxX9NZ69Z83CGw2TZ8wJf/gzjCpcQY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H9icbs8TaMExa88KdyDsUMBhiyjoSbC15jNB4D31IVRbTU9ie9eVP4ycts3QATWyjeUBvZ0WrX/cHw7ha46wXLjJd/nmnv9MVIxpHgegNBYYpzSO5MXFX30TpPsp2xD9wmRojMR27QOdh04hHOp7W+gh1f+/cH59RxeywFFKvew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MDLgfaL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDLgfaL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60564C4CED1;
	Fri,  6 Dec 2024 23:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528723;
	bh=Epa2ws7WQKcuJoxX9NZ69Z83CGw2TZ8wJf/gzjCpcQY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MDLgfaL7WIsO60Fbxjw0SaARAoMoA9Oc+5urdVLMXC7xlQJw51mA9gUSfulyvkRRC
	 pP5bmw+/fhmr80JGrK+lI1m7uKoJiHJ+i+MRyktE3IZ2Npojp66FGmay3mVVhWDawG
	 hM1TZf4O8Oz8Z2vOLArHw2WgeJRYT3SxmInb8sKLNWnSlkqBFpUhep8cZMRs1C6hQu
	 eC6+3HrWZtr/oGWyReNi+Ze7gDHXaxmZ/cSri7vYa2PvOX4nPhoir8Ev4PgzuBz9Su
	 +zNyz94YDC4R8vb9f2CAumqBrBp7pwA52RcbkbB1MeaWXNQXteEiio0vQpFGFxp0oD
	 GG8yLeznb+moQ==
Date: Fri, 06 Dec 2024 15:45:22 -0800
Subject: [PATCH 22/41] xfs_repair: dont check metadata directory dirent
 inumbers
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748573.122992.10119337750632485982.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/dir2.c            |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index dd163709fe07df..d2611d7a764259 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -121,6 +121,7 @@
 #define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
 #define xfs_dinode_good_version		libxfs_dinode_good_version
 #define xfs_dinode_verify		libxfs_dinode_verify
+#define xfs_dinode_verify_metadir	libxfs_dinode_verify_metadir
 
 #define xfs_dir2_data_bestfree_p	libxfs_dir2_data_bestfree_p
 #define xfs_dir2_data_entry_tag_p	libxfs_dir2_data_entry_tag_p
diff --git a/repair/dir2.c b/repair/dir2.c
index bfeaddd07d2058..dab6523f676a34 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -136,6 +136,29 @@ process_sf_dir2_fixoff(
 	}
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
+	if (dip->di_version < 3 ||
+	    !(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
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
@@ -227,6 +250,12 @@ process_sf_dir2(
 		} else if (!libxfs_verify_dir_ino(mp, lino)) {
 			junkit = 1;
 			junkreason = _("invalid");
+		} else if (is_metadata_directory(mp, dip)) {
+			/*
+			 * Metadata directories are always rebuilt, so don't
+			 * bother checking if the child inode is free or not.
+			 */
+			junkit = 0;
 		} else if (lino == mp->m_sb.sb_rbmino)  {
 			junkit = 1;
 			junkreason = _("realtime bitmap");
@@ -698,6 +727,12 @@ process_dir2_data(
 			 * directory since it's still structurally intact.
 			 */
 			clearreason = _("invalid");
+		} else if (is_metadata_directory(mp, dip)) {
+			/*
+			 * Metadata directories are always rebuilt, so don't
+			 * bother checking if the child inode is free or not.
+			 */
+			clearino = 0;
 		} else if (ent_ino == mp->m_sb.sb_rbmino) {
 			clearreason = _("realtime bitmap");
 		} else if (ent_ino == mp->m_sb.sb_rsumino) {

