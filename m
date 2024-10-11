Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E278BE8
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610625; cv=none; b=u6jYZ3Fs7V2oO2kXWmkaRRO5prjU2l2jRTw+P/n98ZzhFydH7qH9NHZNMeeA0PKG2coX2UutMK9KU3AyaCHRtOcdAzuSqN0E7DqYEf8vgJBqMnIQMa22kIImNRGDZEM6q1K+d+kPCj7B8ajJnFMZX76is4CCSJDbrBPG2NTNQ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610625; c=relaxed/simple;
	bh=9iPfZBeDJ+h8dc9jkr2VaBBx9GSB8waA4uLDb+vO8zg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r8X0V7JZH5faZIdj0gPuDtbWS2wBi2mvodJuGSGgz8hN5n+1T6MeX0V/LVj0Y2F22UiLFLq3QXKm20RwIMmOI73dZSdfZHvBuc00vVIvyDmjR4ztvWEE9cPerCH/ODFO5TpkMfgWXZAhZkPHpb3we94wKQPLwV+jZcMRy/OtTNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1K7jbKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1K7jbKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC64C4CEC5;
	Fri, 11 Oct 2024 01:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610624;
	bh=9iPfZBeDJ+h8dc9jkr2VaBBx9GSB8waA4uLDb+vO8zg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T1K7jbKGHgUWutP6aw5DphOomlngGLdO6Uq1ZZH65a+By6a9Flhx798hb8sREuRQJ
	 +OZqjLPgihKjSRL//7qqHuXluPp50DSs4RFh9srNA+/uIaqMDuHjAXVz2qZAqpbqgm
	 bTmiqEu1H+KwZc0GNUKrz3vj5gDjk5IJUKq+bEcNvpp+HAv3mQxYqCkp+1ZuGgwT4G
	 EGVpDDwQgmfUjybD/0AGJ6FVQ/9fujUWcdauTZQO0MsFgBRuUYTa6/88nnqehQkn9t
	 0RDRZ69rh0xqU8kCKWjgWEKF1wColU0cU/Qody+5LwG0g06meJeG3UELALU/KAAkWu
	 z2+pan4vPdgAQ==
Date: Thu, 10 Oct 2024 18:37:04 -0700
Subject: [PATCH 5/7] xfs_repair: support quota inodes in the metadata
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860656449.4186076.2799572913482105622.stgit@frogsfrogsfrogs>
In-Reply-To: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
References: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
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

Handle quota inodes on metadir filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h |    1 
 libxfs/init.c       |    2 -
 repair/agheader.c   |    3 +
 repair/phase2.c     |    3 +
 repair/phase6.c     |  116 +++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/quotacheck.c |   71 +++++++++++++++++++++++++++++++
 repair/quotacheck.h |    1 
 repair/xfs_repair.c |    3 +
 8 files changed, 194 insertions(+), 6 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 0c09dbf3d97ef5..19d08cf047f202 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -85,7 +85,6 @@ typedef struct xfs_mount {
 	xfs_filblks_t		m_rsumblocks;	/* size of rt summary, FSBs */
 	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
 	struct xfs_inode	*m_rtdirip;	/* ptr to realtime metadir */
-	struct xfs_inode	*m_qdirip;	/* ptr to quota metadir */
 	struct xfs_buftarg	*m_ddev_targp;
 	struct xfs_buftarg	*m_logdev_targp;
 	struct xfs_buftarg	*m_rtdev_targp;
diff --git a/libxfs/init.c b/libxfs/init.c
index f4678cb84ac891..16291466ac86d3 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -1001,8 +1001,6 @@ libxfs_umount(
 	int			error;
 
 	libxfs_rtmount_destroy(mp);
-	if (mp->m_qdirip)
-		libxfs_irele(mp->m_qdirip);
 	if (mp->m_metadirip)
 		libxfs_irele(mp->m_metadirip);
 
diff --git a/repair/agheader.c b/repair/agheader.c
index bc6c4579661bdd..5735bb720d94ec 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -509,7 +509,8 @@ secondary_sb_whack(
 			rval |= XR_AG_SB_SEC;
 	}
 
-	rval |= secondary_sb_quota(mp, sbuf, sb, i, do_bzero);
+	if (!xfs_has_metadir(mp))
+		rval |= secondary_sb_quota(mp, sbuf, sb, i, do_bzero);
 
 	/*
 	 * if the secondaries agree on a stripe unit/width or inode
diff --git a/repair/phase2.c b/repair/phase2.c
index 27c873fca76747..71576f5806e473 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -15,6 +15,7 @@
 #include "progress.h"
 #include "scan.h"
 #include "rt.h"
+#include "quotacheck.h"
 
 /* workaround craziness in the xlog routines */
 int xlog_recover_do_trans(struct xlog *log, struct xlog_recover *t, int p)
@@ -625,6 +626,8 @@ phase2(
 	}
 
 	discover_rtgroup_inodes(mp);
+	if (xfs_has_metadir(mp) && xfs_has_quota(mp))
+		discover_quota_inodes(mp);
 
 	/*
 	 * Upgrade the filesystem now that we've done a preliminary check of
diff --git a/repair/phase6.c b/repair/phase6.c
index acd3051751a6e3..28e6bf3b754bdc 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -20,6 +20,7 @@
 #include "versions.h"
 #include "repair/pptr.h"
 #include "repair/rt.h"
+#include "repair/quotacheck.h"
 
 static xfs_ino_t		orphanage_ino;
 
@@ -3189,7 +3190,7 @@ mark_standalone_inodes(xfs_mount_t *mp)
 		mark_inode(mp, mp->m_sb.sb_rsumino);
 	}
 
-	if (!fs_quotas)
+	if (!fs_quotas || xfs_has_metadir(mp))
 		return;
 
 	if (has_quota_inode(XFS_DQTYPE_USER))
@@ -3411,6 +3412,116 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 	}
 }
 
+static bool
+ensure_quota_file(
+	struct xfs_inode	*dp,
+	xfs_dqtype_t		type)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_inode	*ip;
+	const char		*name = libxfs_dqinode_path(type);
+	int			error;
+
+	if (!has_quota_inode(type))
+		return false;
+
+	if (no_modify) {
+		if (lost_quota_inode(type))
+			do_warn(_("would reset %s quota inode\n"), name);
+		return false;
+	}
+
+	if (!lost_quota_inode(type)) {
+		/*
+		 * The /quotas directory has been discarded, but we should
+		 * be able to iget the quota files directly.
+		 */
+		error = -libxfs_metafile_iget(mp, get_quota_inode(type),
+				xfs_dqinode_metafile_type(type), &ip);
+		if (error) {
+			do_warn(
+_("Could not open %s quota inode, error %d\n"),
+					name, error);
+			lose_quota_inode(type);
+		}
+	}
+
+	if (lost_quota_inode(type)) {
+		/*
+		 * The inode was bad or missing, state that we'll make a new
+		 * one even though we always create a new one.
+		 */
+		do_warn(_("resetting %s quota inode\n"), name);
+		error =  -libxfs_dqinode_metadir_create(dp, type, &ip);
+		if (error) {
+			do_warn(
+_("Couldn't create %s quota inode, error %d\n"),
+					name, error);
+			goto bad;
+		}
+	} else {
+		struct xfs_trans	*tp;
+
+		/* Erase parent pointers before we create the new link */
+		try_erase_parent_ptrs(ip);
+
+		error = -libxfs_dqinode_metadir_link(dp, type, ip);
+		if (error) {
+			do_warn(
+_("Couldn't link %s quota inode, error %d\n"),
+					name, error);
+			goto bad;
+		}
+
+		/*
+		 * Reset the link count to 1 because quota files are never
+		 * hardlinked, but the link above probably bumped it.
+		 */
+		error = -libxfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange,
+				0, 0, false, &tp);
+		if (!error) {
+			set_nlink(VFS_I(ip), 1);
+			libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+			error = -libxfs_trans_commit(tp);
+		}
+		if (error)
+			do_error(
+_("Couldn't reset link count on %s quota inode, error %d\n"),
+					name, error);
+	}
+
+	/* Mark the inode in use. */
+	mark_ino_inuse(mp, ip->i_ino, S_IFREG, dp->i_ino);
+	mark_ino_metadata(mp, ip->i_ino);
+	libxfs_irele(ip);
+	return true;
+bad:
+	/* Zeroes qflags */
+	quotacheck_skip();
+	return false;
+}
+
+static void
+reset_quota_metadir_inodes(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inode	*dp = NULL;
+	int			error;
+
+	error = -libxfs_dqinode_mkdir_parent(mp, &dp);
+	if (error)
+		do_error(_("failed to create quota metadir (%d)\n"),
+				error);
+
+	mark_ino_inuse(mp, dp->i_ino, S_IFDIR, mp->m_metadirip->i_ino);
+	mark_ino_metadata(mp, dp->i_ino);
+
+	ensure_quota_file(dp, XFS_DQTYPE_USER);
+	ensure_quota_file(dp, XFS_DQTYPE_GROUP);
+	ensure_quota_file(dp, XFS_DQTYPE_PROJ);
+	libxfs_irele(dp);
+}
+
 void
 phase6(xfs_mount_t *mp)
 {
@@ -3464,6 +3575,9 @@ phase6(xfs_mount_t *mp)
 	else
 		reset_rt_sb_inodes(mp);
 
+	if (xfs_has_metadir(mp) && xfs_has_quota(mp) && !no_modify)
+		reset_quota_metadir_inodes(mp);
+
 	mark_standalone_inodes(mp);
 
 	do_log(_("        - traversing filesystem ...\n"));
diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index c4baf70e41d6b1..8c7339b267d8e6 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -645,3 +645,74 @@ update_sb_quotinos(
 	if (dirty)
 		libxfs_sb_to_disk(sbp->b_addr, &mp->m_sb);
 }
+
+static inline int
+mark_quota_inode(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dqtype_t		type)
+{
+	struct xfs_inode	*ip;
+	int			error;
+
+	error = -libxfs_dqinode_load(tp, dp, type, &ip);
+	if (error == ENOENT)
+		return 0;
+	if (error)
+		goto out_corrupt;
+
+	set_quota_inode(type, ip->i_ino);
+	libxfs_irele(ip);
+	return 0;
+
+out_corrupt:
+	lose_quota_inode(type);
+	return error;
+}
+
+/* Mark the reachable quota metadata inodes prior to the inode scan. */
+void
+discover_quota_inodes(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp;
+	struct xfs_inode	*dp = NULL;
+	int			error, err2;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		goto out;
+
+	error = -libxfs_dqinode_load_parent(tp, &dp);
+	if (error)
+		goto out_cancel;
+
+	error = mark_quota_inode(tp, dp, XFS_DQTYPE_USER);
+	err2 = mark_quota_inode(tp, dp, XFS_DQTYPE_GROUP);
+	if (err2 && !error)
+		error = err2;
+	error = mark_quota_inode(tp, dp, XFS_DQTYPE_PROJ);
+	if (err2 && !error)
+		error = err2;
+
+	libxfs_irele(dp);
+out_cancel:
+	libxfs_trans_cancel(tp);
+out:
+	if (error) {
+		switch (error) {
+		case EFSCORRUPTED:
+			do_warn(
+ _("corruption in metadata directory tree while discovering quota inodes\n"));
+			break;
+		case ENOENT:
+			/* Do nothing, we'll just clear qflags later. */
+			break;
+		default:
+			do_warn(
+ _("couldn't discover quota inodes, err %d\n"),
+						error);
+			break;
+		}
+	}
+}
diff --git a/repair/quotacheck.h b/repair/quotacheck.h
index 36f9f5a12f7f3e..24c9ffa418a3bf 100644
--- a/repair/quotacheck.h
+++ b/repair/quotacheck.h
@@ -14,5 +14,6 @@ int quotacheck_setup(struct xfs_mount *mp);
 void quotacheck_teardown(void);
 
 void update_sb_quotinos(struct xfs_mount *mp, struct xfs_buf *sbp);
+void discover_quota_inodes(struct xfs_mount *mp);
 
 #endif /* __XFS_REPAIR_QUOTACHECK_H__ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 363f8260bd575a..9509f04685c870 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1487,7 +1487,8 @@ _("Warning:  project quota information would be cleared.\n"
 	if (!sbp)
 		do_error(_("couldn't get superblock\n"));
 
-	update_sb_quotinos(mp, sbp);
+	if (!xfs_has_metadir(mp))
+		update_sb_quotinos(mp, sbp);
 
 	if ((mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD) != quotacheck_results()) {
 		do_warn(_("Note - quota info will be regenerated on next "

