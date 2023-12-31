Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A78C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhZ8+nxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2764CC433C7;
	Sun, 31 Dec 2023 23:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066189;
	bh=k1rgXECzQHfkHVkFlzO7XLDT8g1tVTd4cn5atZb609k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NhZ8+nxbdgA7OEARDT6e4sLXHKAR19OpQbgCNw3ZnAWj1yhchAqtzx5mHN1lH3Vjf
	 RzKymkS4j16Qk2OH1JBdZIlfDxaPXb0VDShnoiQ0Y47OEsxuz3aAmu8sYgTzGK0+qp
	 TcuKcE+RetK9UxpbgXQoShVkY2JNc33UyHAGVJoDDKSqhaXw5TpVSJzmM3kseLNckW
	 yrnTIsm1ycP6/T/ckHdZTxEPi0nNcL/c8/XNL1hTSxNiIhQ1jr+mMcRLLu31tPmbn4
	 sqGdjNjhnnW8jgGONxKrB02BrEuAhiZHfSRP9A5m0k+t9JYT5R/GvWibU6b7ySNJyZ
	 oZ3YlAxeu7wxA==
Date: Sun, 31 Dec 2023 15:43:08 -0800
Subject: [PATCH 52/58] xfs_repair: reattach quota inodes to metadata directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010640.1809361.6877152924759110980.stgit@frogsfrogsfrogs>
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

If the quota inodes came through unscathed, we should attach them to
the new metadata directory so that phase 7 can run quotacheck on them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index 9ad586602cb..5eeffd5dce9 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3633,6 +3633,131 @@ update_missing_dotdot_entries(
 	}
 }
 
+/*
+ * Re-link a quota inode into the metadata directory.  We do not create quota
+ * inodes or abort repair if we cannot relink the inodes, because quota mount
+ * can recreate all the quota metadata.
+ */
+static int
+reattach_quota_inode(
+	struct xfs_mount		*mp,
+	xfs_ino_t			*inop,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_imeta_update		upd;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*ip = NULL;
+	xfs_ino_t			ino = *inop;
+	int				error;
+
+	error = ensure_imeta_dirpath(mp, path);
+	if (error) {
+		do_warn(
+ _("Couldn't create quota metadata directory, error %d\n"), error);
+		return error;
+	}
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		do_error(
+ _("failed to allocate trans to grab quota inode 0x%llx, error %d\n"),
+				(unsigned long long)ino, error);
+	error = -libxfs_imeta_iget(tp, ino, XFS_DIR3_FT_REG_FILE, &ip);
+	libxfs_trans_cancel(tp);
+	if (error) {
+		do_warn(
+ _("Couldn't grab quota inode 0x%llx, error %d\n"),
+				(unsigned long long)ino, error);
+		goto out_rele;
+	}
+
+	/*
+	 * Since we're reattaching this file to the metadata directory tree,
+	 * try to remove all the parent pointers that might be attached.
+	 */
+	try_erase_parent_ptrs(ip);
+
+	error = -libxfs_imeta_start_link(mp, path, ip, &upd);
+	if (error) {
+		do_warn(
+ _("Couldn't allocate transaction to attach quota inode 0x%llx, error %d\n"),
+				(unsigned long long)ino, error);
+		goto out_rele;
+	}
+
+	/* Null out the superblock pointer and re-link this file into it. */
+	*inop = NULLFSINO;
+
+	error = -libxfs_imeta_link(&upd);
+	if (error) {
+		do_warn(
+ _("Couldn't link quota inode 0x%llx, error %d\n"),
+				(unsigned long long)ino, error);
+		goto out_cancel;
+	}
+
+	/* Reset the link count to something sane. */
+	set_nlink(VFS_I(ip), 1);
+	libxfs_trans_log_inode(upd.tp, ip, XFS_ILOG_CORE);
+
+	error = -libxfs_imeta_commit_update(&upd);
+	if (error) {
+		do_warn(
+_("Couldn't commit quota inode 0x%llx reattachment transaction, error %d\n"),
+				(unsigned long long)ino, error);
+	}
+
+	goto out_rele;
+
+out_cancel:
+	libxfs_imeta_cancel_update(&upd, error);
+out_rele:
+	if (ip)
+		libxfs_irele(ip);
+	return error;
+}
+
+/*
+ * Reattach quota inodes to the metadata directory if we rebuilt the metadata
+ * directory tree.
+ */
+static inline void
+reattach_metadir_quota_inodes(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	if (!xfs_has_metadir(mp) || no_modify)
+		return;
+
+	if (mp->m_sb.sb_uquotino != NULLFSINO) {
+		error = reattach_quota_inode(mp, &mp->m_sb.sb_uquotino,
+				&XFS_IMETA_USRQUOTA);
+		if (error) {
+			mp->m_sb.sb_uquotino = NULLFSINO;
+			lost_uquotino = 1;
+		}
+	}
+
+	if (mp->m_sb.sb_gquotino != NULLFSINO) {
+		error = reattach_quota_inode(mp, &mp->m_sb.sb_gquotino,
+				&XFS_IMETA_GRPQUOTA);
+		if (error) {
+			mp->m_sb.sb_gquotino = NULLFSINO;
+			lost_gquotino = 1;
+		}
+	}
+
+	if (mp->m_sb.sb_pquotino != NULLFSINO) {
+		error = reattach_quota_inode(mp, &mp->m_sb.sb_pquotino,
+				&XFS_IMETA_PRJQUOTA);
+		if (error) {
+			mp->m_sb.sb_pquotino = NULLFSINO;
+			lost_pquotino = 1;
+		}
+	}
+}
+
 static void
 traverse_ags(
 	struct xfs_mount	*mp)
@@ -3718,6 +3843,8 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 		}
 	}
 
+	reattach_metadir_quota_inodes(mp);
+
 	mark_standalone_inodes(mp);
 
 	do_log(_("        - traversing filesystem ...\n"));

