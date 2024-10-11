Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D7CC2C6
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609532; cv=none; b=CRsKXkR/K3omAYZMawM6HtlDu3VezK2n7NMPbLEzh9umKMtPVtKPaN1DvbKdCujZJLLq63hShk2bDC1OBVAmDS6REqTg8vU+NHBNNtAqJJoSTBmhJtvFBaTRLoDqTwFiClUw3c85Rdep2stbsSwEYjVRSEgSmmF1GxisquTH3wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609532; c=relaxed/simple;
	bh=xwjCb1g6BjH1A89ZxzntZf/g+lH/Rh0PaaWPe8I7jZw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DE9XDle5TV9b9BGERbOIPyQ0XYgZpeiB3kxF0S9rLCvcfvg4MQiHpDFFz6ZZolyP7rvVrk9U6tnDc96XCC6pH0ceQDrA5wLVL+IyT4b8HLXH4+KgSHx5UdXJfyx68GxGyTyEaHsKShKFc02HthJRtaCmXYamUIrFqUZZl/7eUIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q02TUIsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q02TUIsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA93C4CEC5;
	Fri, 11 Oct 2024 01:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609531;
	bh=xwjCb1g6BjH1A89ZxzntZf/g+lH/Rh0PaaWPe8I7jZw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q02TUIsROTJXrFHTkmU8ITdxLL9RC2kpXcdobO5NzcW9S2dXea+LvhPMjulU9sBFF
	 IKwoskLckDyT0QXM+iuuHmqehjr209KTlcfNpidD1sVq4i3tPkVfDIIwSC4pYZu2W7
	 Gv6LlFmgzXwChKKEWXfn0ZKtafBc2NP1MySYiabLa+nnnU0q8AifP5OD+s8Yd3zb60
	 noqFfrtyFPPKxtojGx+nJ36nX9PjHu9j09QdQpz7iykWEiV8cPCVZL3IJh8VLVvI+Z
	 9lNz/51PkIVkSMh6B9HgSQE3JAp0+PPX3TlD1oPwgxkJLpdIv2RBKKG7VYFVwIO8RR
	 8WruYugiL3UIw==
Date: Thu, 10 Oct 2024 18:18:51 -0700
Subject: [PATCH 18/38] xfs_repair: dont check metadata directory dirent
 inumbers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654252.4183231.3311923341938565785.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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
 repair/dir2.c            |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 80eedb2064416d..978796a5c6a281 100644
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

