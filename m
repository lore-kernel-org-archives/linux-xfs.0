Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49BD29415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689316; cv=none; b=KMRDzvyP3C+hDloLtIPjC4gXvVEKII8EqVPRi2gIGmjTAu/hW9fbyBUkFfiGZSkkMxgyq+lxJsUS4JFA8fPvMR0GspDd4/zs9Gmmho2KkK+zU1oImyyYFIRlD0aUjuH8NPLroNE25O9f8daAj1SMZ2q1OI8sWmJCx/X6WUApjtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689316; c=relaxed/simple;
	bh=FRG0NimpfRHKaQrMjA/o5w9Rxapr1kOU8LtkPwiUoxE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GvevE66SXY4jbGeP4LipIEjOgR6S3P31Pjm2mrK4w4VQsXXn2Qq31yQtBz+lAC9m8gtP4eNVDlXUwesVcUEzlhrfdhLhNZkeWovB3RpnVve3KMeK5QMKiZAH6ZIQQJOewQsV4zirSSSy1zbI/Mg3LLvkKxhf1xZ/lN5DKJKyuHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PC2uBfS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PC2uBfS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81974C4CED2;
	Tue, 31 Dec 2024 23:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689316;
	bh=FRG0NimpfRHKaQrMjA/o5w9Rxapr1kOU8LtkPwiUoxE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PC2uBfS0MOIjJOBDbAEPUhZsTfy9jSBhoayitAaMUDvuVDTJK0zWZNvbsH76wJXPk
	 gRRty3LmaAGvlVM9yHTL3x3HFK6m13QvBIsIBx+ZkUnhYigDn0TgjuK+347iJdfHE7
	 0krvsshcPoNeYGmiyRN19Cc4pNKBC8wx+xUWk4cHfa2Au2bwJTPxDS2BKDWMTsv+n/
	 wjaQx+0VjKrw8IZP0jvnulQyiuDcg3h/uNcE+Sdr77b3QFi8uVp/sEixTmwN2VluxW
	 JNGXStaT18n/k/3z8iERFQ2eRTFz5jW8ExtdS+hGTxidx4/XQxfCUBU8OFYxA1/nWy
	 2RYpJQppCzDmg==
Date: Tue, 31 Dec 2024 15:55:16 -0800
Subject: [PATCH 08/10] xfs_repair: allow sysadmins to add realtime reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568779257.2710949.13339646892376161679.stgit@frogsfrogsfrogs>
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
to support the realtime reference count btree, and therefore reflink on
realtime volumes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/phase2.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)


diff --git a/repair/phase2.c b/repair/phase2.c
index b1288bf3dd90cd..8dc936b572196e 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -250,14 +250,15 @@ set_reflink(
 		exit(0);
 	}
 
-	if (xfs_has_realtime(mp)) {
-		printf(_("Reflink feature not supported with realtime.\n"));
+	if (xfs_has_realtime(mp) && !xfs_has_rtgroups(mp)) {
+		printf(_("Reference count btree requires realtime groups.\n"));
 		exit(0);
 	}
 
 	printf(_("Adding reflink support to filesystem.\n"));
 	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
 	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+
 	return true;
 }
 
@@ -497,6 +498,38 @@ reserve_rtrmap_inode(
 	return -libxfs_metafile_resv_init(ip, ask);
 }
 
+/*
+ * Reserve space to handle rt refcount btree expansion.
+ *
+ * If the refcount inode for this group already exists, we assume that we're
+ * adding some other feature.  Note that we have not validated the metadata
+ * directory tree, so we must perform the lookup by hand and abort the upgrade
+ * if there are errors.  If the inode does not exist, the amount of space
+ * needed to handle a new maximally sized refcount btree is added to @new_resv.
+ */
+static int
+reserve_rtrefcount_inode(
+	struct xfs_rtgroup	*rtg,
+	xfs_rfsblock_t		*new_resv)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_inode	*ip = rtg_refcount(rtg);
+	xfs_filblks_t		ask;
+
+	if (!xfs_has_rtreflink(mp))
+		return 0;
+
+	ask = libxfs_rtrefcountbt_calc_reserves(mp);
+
+	/* failed to load the rtdir inode? */
+	if (!ip) {
+		*new_resv += ask;
+		return 0;
+	}
+
+	return -libxfs_metafile_resv_init(ip, ask);
+}
+
 static void
 check_fs_free_space(
 	struct xfs_mount		*mp,
@@ -594,6 +627,18 @@ _("Not enough free space would remain for rtgroup %u rmap inode.\n"),
 			do_error(
 _("Error %d while checking rtgroup %u rmap inode space reservation.\n"),
 					error, rtg_rgno(rtg));
+
+		error = reserve_rtrefcount_inode(rtg, &new_resv);
+		if (error == ENOSPC) {
+			printf(
+_("Not enough free space would remain for rtgroup %u refcount inode.\n"),
+					rtg_rgno(rtg));
+			exit(0);
+		}
+		if (error)
+			do_error(
+_("Error %d while checking rtgroup %u refcount inode space reservation.\n"),
+					error, rtg_rgno(rtg));
 	}
 
 	/*
@@ -621,8 +666,10 @@ _("Error %d while checking rtgroup %u rmap inode space reservation.\n"),
 	}
 
 	/* Unreserve the realtime metadata reservations. */
-	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
 		libxfs_metafile_resv_free(rtg_rmap(rtg));
+		libxfs_metafile_resv_free(rtg_refcount(rtg));
+	}
 
 	/*
 	 * Release the per-AG reservations and mark the per-AG structure as

