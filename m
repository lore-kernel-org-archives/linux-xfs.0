Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649BFC13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbwBLpKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1A4C433C7;
	Sun, 31 Dec 2023 22:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062171;
	bh=yjGx4Q2QpJo23s0rUwxRiGWEO2YAPwy5CaAXIn6f5p8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YbwBLpKFKNz1rpoqV/qpGRgb8XBNRXCfGeZtH28Xgbh65djdGynZ2sbD0/J6HiZgv
	 0rIY3h40/IGigpmTZMZEyIcsYFY0n73oGnDDs6HjjwcReESvf4boZwxqJtdrU81IW0
	 OmPTABgwH59t8k7j8SSoIe358KNHpIjJTYkxY5tsfNQmPoOc2daKEvYnn4Zcx1VcFW
	 x2hNLjRx5CySoXjBmQUFyOOpOe3FI+f/6bOFFzNp3ZVogxCGsfKoeBGR5JdFZphu7a
	 CYEPhgbNg8ce1b6yuPTQfmefKNKAxBw6PyxFkWF1gxXSmQIaijMnJsz7dvI1RtcT/r
	 oZxp5T6bueTXw==
Date: Sun, 31 Dec 2023 14:36:10 -0800
Subject: [PATCH 3/4] libxfs: port the bumplink function from the kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404998332.1797172.7585897571914908972.stgit@frogsfrogsfrogs>
In-Reply-To: <170404998289.1797172.11188208357520292150.stgit@frogsfrogsfrogs>
References: <170404998289.1797172.11188208357520292150.stgit@frogsfrogsfrogs>
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

Port the xfs_bumplink function from the kernel and use it to replace raw
calls to inc_nlink.  The next patch will need this common function to
prevent integer overflows in the link count.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h |    2 ++
 libxfs/util.c       |   17 +++++++++++++++++
 mkfs/proto.c        |    4 ++--
 repair/phase6.c     |   10 +++++-----
 4 files changed, 26 insertions(+), 7 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 302df4c6f7e..47959314811 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -348,6 +348,8 @@ extern void	libxfs_trans_ichgtime(struct xfs_trans *,
 				struct xfs_inode *, int);
 extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
 
+void libxfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
+
 /* Inode Cache Interfaces */
 extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 				uint, struct xfs_inode **);
diff --git a/libxfs/util.c b/libxfs/util.c
index c1ddaf92c8a..11978529ed6 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -240,6 +240,23 @@ xfs_inode_propagate_flags(
 	ip->i_diflags |= di_flags;
 }
 
+/*
+ * Increment the link count on an inode & log the change.
+ */
+void
+libxfs_bumplink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	inc_nlink(inode);
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 0f2facbc32e..457899ac178 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -590,7 +590,7 @@ parseproto(
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
-		inc_nlink(VFS_I(ip));		/* account for . */
+		libxfs_bumplink(tp, ip);		/* account for . */
 		if (!pip) {
 			pip = ip;
 			mp->m_sb.sb_rootino = ip->i_ino;
@@ -600,7 +600,7 @@ parseproto(
 			libxfs_trans_ijoin(tp, pip, 0);
 			xname.type = XFS_DIR3_FT_DIR;
 			newdirent(mp, tp, pip, &xname, ip->i_ino);
-			inc_nlink(VFS_I(pip));
+			libxfs_bumplink(tp, pip);
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
 		newdirectory(mp, tp, ip, pip);
diff --git a/repair/phase6.c b/repair/phase6.c
index ac037cf80ad..75391378291 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -944,7 +944,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(_("%s inode allocation failed %d\n"),
 			ORPHANAGE, error);
 	}
-	inc_nlink(VFS_I(ip));		/* account for . */
+	libxfs_bumplink(tp, ip);		/* account for . */
 	ino = ip->i_ino;
 
 	irec = find_inode_rec(mp,
@@ -996,7 +996,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 * for .. in the new directory, and update the irec copy of the
 	 * on-disk nlink so we don't fail the link count check later.
 	 */
-	inc_nlink(VFS_I(pip));
+	libxfs_bumplink(tp, pip);
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 				  XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
 	add_inode_ref(irec, 0);
@@ -1090,7 +1090,7 @@ mv_orphanage(
 			if (irec)
 				add_inode_ref(irec, ino_offset);
 			else
-				inc_nlink(VFS_I(orphanage_ip));
+				libxfs_bumplink(tp, orphanage_ip);
 			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
 
 			err = -libxfs_dir_createname(tp, ino_p, &xfs_name_dotdot,
@@ -1099,7 +1099,7 @@ mv_orphanage(
 				do_error(
 	_("creation of .. entry failed (%d)\n"), err);
 
-			inc_nlink(VFS_I(ino_p));
+			libxfs_bumplink(tp, ino_p);
 			libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 			err = -libxfs_trans_commit(tp);
 			if (err)
@@ -1124,7 +1124,7 @@ mv_orphanage(
 			if (irec)
 				add_inode_ref(irec, ino_offset);
 			else
-				inc_nlink(VFS_I(orphanage_ip));
+				libxfs_bumplink(tp, orphanage_ip);
 			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
 
 			/*

