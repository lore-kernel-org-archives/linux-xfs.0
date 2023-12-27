Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC0F1362
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugLsVxJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09046C433C7;
	Mon,  1 Jan 2024 00:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069380;
	bh=H255maff+EfGsU7DWyKQy78I30lvQUHG6BAece41hsU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ugLsVxJNm8dG9N8uSwedOa1/aqksULcePk5Z5g9TIPWmmXgGSP3+rJd+hPhOO1OdA
	 7Lkv/ZAt334cnUzXLRqbFQ19AgKmMrUnyjNxx1+dO8RoxnVXRHIpMlMHc7zjOJdA+i
	 u+fzRNIcTQ97RD6kixNlWlbARx2cQMm4h+UeY1mVCvch91VKxSv8ZIjHXF5l/IKgEs
	 py3wwX6srCrfXdmSOwA7Gq44sBAXkibQ6SufwAMH6ODtC0r2wgRdnjLYVJwX9+K3D5
	 sXzhFvPW5Emqt+dN8hpfB8M+/+DTrJVQcwvBlU7ArpgJmT3RPQOmh6/+RyWNw+phYa
	 aH+EBdk0f8k+A==
Date: Sun, 31 Dec 2023 16:36:19 +9900
Subject: [PATCH 39/42] xfs_repair: allow sysadmins to add realtime reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017647.1817107.18135523970470294722.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Allow the sysadmin to use xfs_repair to upgrade an existing filesystem
to support the realtime reference count btree, and therefore reflink on
realtime volumes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/phase2.c          |   83 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 82 insertions(+), 2 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index bc34ce9caad..4e7b3caba4b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -294,6 +294,7 @@
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
 
 #define xfs_rtrefcountbt_absolute_maxlevels	libxfs_rtrefcountbt_absolute_maxlevels
+#define xfs_rtrefcountbt_calc_reserves	libxfs_rtrefcountbt_calc_reserves
 #define xfs_rtrefcountbt_calc_size		libxfs_rtrefcountbt_calc_size
 #define xfs_rtrefcountbt_commit_staged_btree	libxfs_rtrefcountbt_commit_staged_btree
 #define xfs_rtrefcountbt_create		libxfs_rtrefcountbt_create
diff --git a/repair/phase2.c b/repair/phase2.c
index 22458aee4cd..cd3aa30eecd 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -223,14 +223,19 @@ set_reflink(
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
+	/* Quota counts will be wrong once we add the refcount inodes. */
+	if (xfs_has_realtime(mp))
+		quotacheck_skip();
+
 	return true;
 }
 
@@ -511,6 +516,63 @@ reserve_rtrmap_inode(
 	return error;
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
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_path	*path;
+	struct xfs_trans	*tp;
+	xfs_ino_t		ino;
+	xfs_filblks_t		ask;
+	int			error;
+
+	if (!xfs_has_rtreflink(mp))
+		return 0;
+
+	error = -libxfs_rtrefcountbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		return error;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		goto out_path;
+
+	ask = libxfs_rtrefcountbt_calc_reserves(mp);
+
+	error = -libxfs_imeta_lookup(tp, path, &ino);
+	if (error)
+		goto out_trans;
+
+	if (ino == NULLFSINO) {
+		*new_resv += ask;
+		goto out_trans;
+	}
+
+	error = -libxfs_imeta_iget(tp, ino, XFS_DIR3_FT_REG_FILE,
+			&rtg->rtg_refcountip);
+	if (error)
+		goto out_trans;
+
+	error = -libxfs_imeta_resv_init_inode(rtg->rtg_refcountip, ask);
+
+out_trans:
+	libxfs_trans_cancel(tp);
+out_path:
+	libxfs_imeta_free_path(path);
+	return error;
+}
+
 static void
 check_fs_free_space(
 	struct xfs_mount		*mp,
@@ -610,6 +672,18 @@ _("Not enough free space would remain for rtgroup %u rmap inode.\n"),
 			do_error(
 _("Error %d while checking rtgroup %u rmap inode space reservation.\n"),
 					error, rtg->rtg_rgno);
+
+		error = reserve_rtrefcount_inode(rtg, &new_resv);
+		if (error == ENOSPC) {
+			printf(
+_("Not enough free space would remain for rtgroup %u refcount inode.\n"),
+					rtg->rtg_rgno);
+			exit(0);
+		}
+		if (error)
+			do_error(
+_("Error %d while checking rtgroup %u refcount inode space reservation.\n"),
+					error, rtg->rtg_rgno);
 	}
 
 	/*
@@ -643,6 +717,11 @@ _("Error %d while checking rtgroup %u rmap inode space reservation.\n"),
 			libxfs_imeta_irele(rtg->rtg_rmapip);
 			rtg->rtg_rmapip = NULL;
 		}
+		if (rtg->rtg_refcountip) {
+			libxfs_imeta_resv_free_inode(rtg->rtg_refcountip);
+			libxfs_imeta_irele(rtg->rtg_refcountip);
+			rtg->rtg_refcountip = NULL;
+		}
 	}
 
 	/*

