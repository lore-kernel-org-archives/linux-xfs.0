Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D33C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+fV5CC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F2AC433C7;
	Sun, 31 Dec 2023 23:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066001;
	bh=zvtRPGX4QxKHhVFTKrR3El3Eo6SiiLHLtMrXNQ2vMQk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O+fV5CC4a0I2evIOoGvsdHLg5VLAsjd40OGDKbzV229gVn0LYy3pfqRQMsO8b6CyK
	 vxntsM0a56uVL1D5Hovm25D5+NARcDo+GBmlXsbWIkD7HE9vispj0RMpq8t/tjKrBR
	 5bHM/LytZxotwdk+oEI+xRIc+t7BXSMjGTOT0Rdm2Guc3mueeCo1fg5oFaZbk34bWh
	 ABBi0qQVx1WY2ToUNDy9+ENwRLVxcpEfHBJOhZDfSerPGEQpg/GunTUQ3t96aJPZ1q
	 hpLh8DWFX1ZA4PiwLb+1BSH/k4F+EdsAVo1Z/jvkFEtc9En4sMENqIybj9eMmtqjzI
	 5zopkFLrEX1RA==
Date: Sun, 31 Dec 2023 15:40:00 -0800
Subject: [PATCH 40/58] xfs_repair: refactor fixing dotdot
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010480.1809361.418418179550995939.stgit@frogsfrogsfrogs>
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

Pull the code that fixes a directory's dot-dot entry into a separate
helper function so that we can call it on the rootdir and (later) the
metadir.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   96 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 39 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index fe9a4da62dc..65a387aa97f 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2829,6 +2829,62 @@ dir_hash_add_parent_ptrs(
 	}
 }
 
+/*
+ * If we have to create a .. for /, do it now *before* we delete the bogus
+ * entries, otherwise the directory could transform into a shortform dir which
+ * would probably cause the simulation to choke.  Even if the illegal entries
+ * get shifted around, it's ok because the entries are structurally intact and
+ * in in hash-value order so the simulation won't get confused if it has to
+ * move them around.
+ */
+static void
+fix_dotdot(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_inode	*ip,
+	xfs_ino_t		rootino,
+	const char		*tag,
+	int			*need_dotdot)
+{
+	struct xfs_trans	*tp;
+	int			nres;
+	int			error;
+
+	if (ino != rootino || !*need_dotdot)
+		return;
+
+	if (no_modify) {
+		do_warn(_("would recreate %s directory .. entry\n"), tag);
+		return;
+	}
+
+	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_LOCAL);
+
+	do_warn(_("recreating %s directory .. entry\n"), tag);
+
+	nres = libxfs_mkdir_space_res(mp, 2);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir, nres, 0, 0, &tp);
+	if (error)
+		res_failed(error);
+
+	libxfs_trans_ijoin(tp, ip, 0);
+
+	error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot, ip->i_ino,
+			nres);
+	if (error)
+		do_error(
+_("can't make \"..\" entry in %s inode %" PRIu64 ", createname error %d\n"),
+			tag ,ino, error);
+
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(
+_("%s inode \"..\" entry recreation failed (%d)\n"), tag, error);
+
+	*need_dotdot = 0;
+}
+
 /*
  * processes all reachable inodes in directories
  */
@@ -2958,45 +3014,7 @@ _("error %d fixing shortform directory %llu\n"),
 	dir_hash_add_parent_ptrs(ip, hashtab);
 	dir_hash_done(hashtab);
 
-	/*
-	 * if we have to create a .. for /, do it now *before*
-	 * we delete the bogus entries, otherwise the directory
-	 * could transform into a shortform dir which would
-	 * probably cause the simulation to choke.  Even
-	 * if the illegal entries get shifted around, it's ok
-	 * because the entries are structurally intact and in
-	 * in hash-value order so the simulation won't get confused
-	 * if it has to move them around.
-	 */
-	if (!no_modify && need_root_dotdot && ino == mp->m_sb.sb_rootino)  {
-		ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_LOCAL);
-
-		do_warn(_("recreating root directory .. entry\n"));
-
-		nres = libxfs_mkdir_space_res(mp, 2);
-		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
-					    nres, 0, 0, &tp);
-		if (error)
-			res_failed(error);
-
-		libxfs_trans_ijoin(tp, ip, 0);
-
-		error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot,
-					ip->i_ino, nres);
-		if (error)
-			do_error(
-	_("can't make \"..\" entry in root inode %" PRIu64 ", createname error %d\n"), ino, error);
-
-		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		error = -libxfs_trans_commit(tp);
-		if (error)
-			do_error(
-	_("root inode \"..\" entry recreation failed (%d)\n"), error);
-
-		need_root_dotdot = 0;
-	} else if (need_root_dotdot && ino == mp->m_sb.sb_rootino)  {
-		do_warn(_("would recreate root directory .. entry\n"));
-	}
+	fix_dotdot(mp, ino, ip, mp->m_sb.sb_rootino, "root", &need_root_dotdot);
 
 	/*
 	 * if we need to create the '.' entry, do so only if

