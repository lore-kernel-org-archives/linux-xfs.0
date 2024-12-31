Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A0729415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689301; cv=none; b=DNHDH7DqKvE+wMCIT+c8joLQs9mSy/x/uXfvq8s9/6XdSBjzkcrsDszV88z1YOTaSdHM3Wk7lXm4exMYP+kll3lLe2PCMnTjTY+xosv7RzhOYfRPN4yLB5zOOVSiAs9TiM6E8N13gXQzOB4MktpRu3sRWo4lEl0EpUKIwmgeyf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689301; c=relaxed/simple;
	bh=zP900MfPC9RDVyofFdZKwn5kMJFhtC3z8GcG9ZVg0X8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSoa6sRfwaiRJhlfebxl/QvIi10li2vuRP6R36BCDXbtY76nbFzOW5VTet9Sj/lKoElgliQFak4F5nMS1xbxnm2G1J9dYv8RLAySKEkqXTXxfDbhdulJVR7exPGvukRbMKfHqAyredv2nzw2niGOF6HjnAm0K52/Wfl2KJWkR1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ccfs8qfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ccfs8qfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A07C4CED2;
	Tue, 31 Dec 2024 23:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689301;
	bh=zP900MfPC9RDVyofFdZKwn5kMJFhtC3z8GcG9ZVg0X8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ccfs8qfJeZSdYtCVE/TOZuCFsu98Y+xjI4pF3WTNA4QGnalaSCwK7AeiGZ89b3/ip
	 RD5V+MLVhKTarQ0fRzR/mGIzgaXzR2xZWjZL1nqV7++rWCo5+RjR4MNOZVXqOX2jpI
	 232zD/uT8cjDh7xVoHSZ1tjbrwKu0w4/o23fQuVNIjHA5PnpVnpcskiyigT/x0FwbX
	 9R0Pfw6/6Y5w85FVMH5DB/GXLtdFhb8FtVHZMaMiKGaAXlxqWbNlyKS9UNLn5tSPjF
	 qc8Vqc4HSda4ErUWymdpBHseQrJ2FPOtp6ELTZjyua3R0vIXxeHlLZHIJ8zEcQNR5N
	 cR9Qz/CYLUQMg==
Date: Tue, 31 Dec 2024 15:55:00 -0800
Subject: [PATCH 07/10] xfs_repair: allow sysadmins to add realtime reverse
 mapping indexes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568779241.2710949.14047199401963688785.stgit@frogsfrogsfrogs>
In-Reply-To: <173568779121.2710949.16873326283859979950.stgit@frogsfrogsfrogs>
References: <173568779121.2710949.16873326283859979950.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Allow the sysadmin to use xfs_repair to upgrade an existing filesystem
to support the reverse mapping btree index for realtime volumes.  This
is needed for online fsck.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/phase2.c          |   64 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 60 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 76f55515bb41f7..2502a7736d1670 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -78,6 +78,7 @@
 #define xfs_btree_bload			libxfs_btree_bload
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
 #define xfs_btree_calc_size		libxfs_btree_calc_size
+#define xfs_btree_compute_maxlevels	libxfs_btree_compute_maxlevels
 #define xfs_btree_decrement		libxfs_btree_decrement
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
 #define xfs_btree_delete		libxfs_btree_delete
diff --git a/repair/phase2.c b/repair/phase2.c
index fa6ea91711557c..b1288bf3dd90cd 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -277,9 +277,8 @@ set_rmapbt(
 		exit(0);
 	}
 
-	if (xfs_has_realtime(mp)) {
-		printf(
-	_("Reverse mapping btree feature not supported with realtime.\n"));
+	if (xfs_has_realtime(mp) && !xfs_has_rtgroups(mp)) {
+		printf(_("Reverse mapping btree requires realtime groups.\n"));
 		exit(0);
 	}
 
@@ -292,6 +291,7 @@ set_rmapbt(
 	printf(_("Adding reverse mapping btrees to filesystem.\n"));
 	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+
 	return true;
 }
 
@@ -466,6 +466,37 @@ check_free_space(
 	return avail > GIGABYTES(10, mp->m_sb.sb_blocklog);
 }
 
+/*
+ * Reserve space to handle rt rmap btree expansion.
+ *
+ * If the rmap inode for this group already exists, we assume that we're adding
+ * some other feature.  Note that we have not validated the metadata directory
+ * tree, so we must perform the lookup by hand and abort the upgrade if there
+ * are errors.  Otherwise, the amount of space needed to handle a new maximally
+ * sized rmap btree is added to @new_resv.
+ */
+static int
+reserve_rtrmap_inode(
+	struct xfs_rtgroup	*rtg,
+	xfs_rfsblock_t		*new_resv)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_inode	*ip = rtg_rmap(rtg);
+	xfs_filblks_t		ask;
+
+	if (!xfs_has_rtrmapbt(mp))
+		return 0;
+
+	ask = libxfs_rtrmapbt_calc_reserves(mp);
+
+	/* failed to load the rtdir inode? */
+	if (!ip) {
+		*new_resv += ask;
+		return 0;
+	}
+	return -libxfs_metafile_resv_init(ip, ask);
+}
+
 static void
 check_fs_free_space(
 	struct xfs_mount		*mp,
@@ -473,6 +504,8 @@ check_fs_free_space(
 	struct xfs_sb			*new_sb)
 {
 	struct xfs_perag		*pag = NULL;
+	struct xfs_rtgroup		*rtg = NULL;
+	xfs_rfsblock_t			new_resv = 0;
 	int				error;
 
 	/* Make sure we have enough space for per-AG reservations. */
@@ -548,6 +581,21 @@ check_fs_free_space(
 		libxfs_trans_cancel(tp);
 	}
 
+	/* Realtime metadata btree inodes */
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		error = reserve_rtrmap_inode(rtg, &new_resv);
+		if (error == ENOSPC) {
+			printf(
+_("Not enough free space would remain for rtgroup %u rmap inode.\n"),
+					rtg_rgno(rtg));
+			exit(0);
+		}
+		if (error)
+			do_error(
+_("Error %d while checking rtgroup %u rmap inode space reservation.\n"),
+					error, rtg_rgno(rtg));
+	}
+
 	/*
 	 * If we're adding parent pointers, we need at least 25% free since
 	 * scanning the entire filesystem to guesstimate the overhead is
@@ -563,13 +611,19 @@ check_fs_free_space(
 
 	/*
 	 * Would the post-upgrade filesystem have enough free space on the data
-	 * device after making per-AG reservations?
+	 * device after making per-AG reservations and reserving rt metadata
+	 * inode blocks?
 	 */
-	if (!check_free_space(mp, mp->m_sb.sb_fdblocks, mp->m_sb.sb_dblocks)) {
+	if (new_resv > mp->m_sb.sb_fdblocks ||
+	    !check_free_space(mp, mp->m_sb.sb_fdblocks, mp->m_sb.sb_dblocks)) {
 		printf(_("Filesystem will be low on space after upgrade.\n"));
 		exit(1);
 	}
 
+	/* Unreserve the realtime metadata reservations. */
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		libxfs_metafile_resv_free(rtg_rmap(rtg));
+
 	/*
 	 * Release the per-AG reservations and mark the per-AG structure as
 	 * uninitialized so that we don't trip over stale cached counters

