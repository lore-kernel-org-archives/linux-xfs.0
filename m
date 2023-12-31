Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF79C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tXBAeznv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CFEC433C7;
	Sun, 31 Dec 2023 23:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065219;
	bh=rPsUNx7RP16Meo46gLaiyjMPwT0r83xmFab3+MwBSb0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tXBAeznveNjZEAzlJxGV7nAS14Mw+sSi2j41yWmvOSS5YDClTgyTk/WVvDJocWVgI
	 4TrcEFaAV6ovYH52xQxyDezNuOh1PngjVbNQJ9Jbptu4CxFtOyc4mXBA5LbFSyUIfn
	 ipAtbd2v7U0rXk2ulpbE/1doAE1UALb7eepK4F/FPpRcyAhwrxlU+JRDKU2SChfKrO
	 KK0lBu09bYvntnnU2njROP7h7/R1lBR59sXE2w4y1uNDUUD0HOhySJDkvdmrErP96C
	 yWNjsYRAJkGosTacQcQRXiPzNXpsvbEU8lfez7/2geUMCZcwac8e5mvB+GhR8DQSl/
	 WUtGPRMRP+qdw==
Date: Sun, 31 Dec 2023 15:26:59 -0800
Subject: [PATCH 18/28] xfs: hoist xfs_{bump,drop}link to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009417.1808635.11181394231337112446.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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

Move xfs_bumplink and xfs_droplink to libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/namei.c               |   23 +++++---------------
 include/xfs_inode.h      |    2 --
 libxfs/inode.c           |   18 ----------------
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/libxfs_priv.h     |    1 +
 libxfs/xfs_inode_util.c  |   53 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h  |    2 ++
 7 files changed, 63 insertions(+), 37 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index 196da7f90e9..e75179b2c67 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -1154,21 +1154,6 @@ unlink_help(void)
 	));
 }
 
-static void
-droplink(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	struct inode		*inode = VFS_I(ip);
-
-	libxfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	if (inode->i_nlink != XFS_NLINK_PINNED)
-		drop_nlink(VFS_I(ip));
-
-	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-}
-
 static int
 remove_child(
 	struct xfs_mount	*mp,
@@ -1218,13 +1203,17 @@ remove_child(
 
 	if (S_ISDIR(VFS_I(ip)->i_mode)) {
 		/* drop ip's dotdot link to dp */
-		droplink(tp, dp);
+		error = -libxfs_droplink(tp, dp);
+		if (error)
+			goto out_trans;
 	} else {
 		libxfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 	}
 
 	/* drop dp's link to ip */
-	droplink(tp, ip);
+	error = -libxfs_droplink(tp, ip);
+	if (error)
+		goto out_trans;
 
 	error = -libxfs_dir_removename(tp, dp, &xname, ip->i_ino, resblks);
 	if (error)
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index a48cb7eaf77..5d7bc69e3ff 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -393,8 +393,6 @@ extern void	libxfs_trans_ichgtime(struct xfs_trans *,
 				struct xfs_inode *, int);
 extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
 
-void libxfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
-
 int libxfs_icreate(struct xfs_trans *tp, xfs_ino_t ino,
 		const struct xfs_icreate_args *args, struct xfs_inode **ipp);
 void libxfs_icreate_args_rootfile(struct xfs_icreate_args *args,
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 73eecebae96..47c9b9d6bd7 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -29,24 +29,6 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
 
-/*
- * Increment the link count on an inode & log the change.
- */
-void
-libxfs_bumplink(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	struct inode		*inode = VFS_I(ip);
-
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	if (inode->i_nlink != XFS_NLINK_PINNED)
-		inc_nlink(inode);
-
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-}
-
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 7e4d4c008cf..de59d6cdb5d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -88,6 +88,7 @@
 #define xfs_buf_read_uncached		libxfs_buf_read_uncached
 #define xfs_buf_relse			libxfs_buf_relse
 #define xfs_buf_unlock			libxfs_buf_unlock
+#define xfs_bumplink			libxfs_bumplink
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_bwrite			libxfs_bwrite
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index a457e127d8a..17e62c9fbb7 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -133,6 +133,7 @@ extern void cmn_err(int, char *, ...);
 enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 
 #define xfs_info(mp,fmt,args...)	cmn_err(CE_CONT, _(fmt), ## args)
+#define xfs_info_ratelimited(mp,fmt,args...) cmn_err(CE_CONT, _(fmt), ## args)
 #define xfs_notice(mp,fmt,args...)	cmn_err(CE_NOTE, _(fmt), ## args)
 #define xfs_warn(mp,fmt,args...)	cmn_err((mp) ? CE_WARN : CE_WARN, _(fmt), ## args)
 #define xfs_err(mp,fmt,args...)		cmn_err(CE_ALERT, _(fmt), ## args)
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index a51d0342b98..8f053e3941c 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -615,3 +615,56 @@ xfs_iunlink_remove(
 
 	return xfs_iunlink_remove_inode(tp, pag, agibp, ip);
 }
+
+/*
+ * Decrement the link count on an inode & log the change.  If this causes the
+ * link count to go to zero, move the inode to AGI unlinked list so that it can
+ * be freed when the last active reference goes away via xfs_inactive().
+ */
+int
+xfs_droplink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	if (inode->i_nlink == 0) {
+		xfs_info_ratelimited(tp->t_mountp,
+ "Inode 0x%llx link count dropped below zero.  Pinning link count.",
+				ip->i_ino);
+		set_nlink(inode, XFS_NLINK_PINNED);
+	}
+	if (inode->i_nlink != XFS_NLINK_PINNED)
+		drop_nlink(inode);
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	if (inode->i_nlink)
+		return 0;
+
+	return xfs_iunlink(tp, ip);
+}
+
+/*
+ * Increment the link count on an inode & log the change.
+ */
+void
+xfs_bumplink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	if (inode->i_nlink == XFS_NLINK_PINNED - 1)
+		xfs_info_ratelimited(tp->t_mountp,
+ "Inode 0x%llx link count exceeded maximum.  Pinning link count.",
+				ip->i_ino);
+	if (inode->i_nlink != XFS_NLINK_PINNED)
+		inc_nlink(inode);
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index 0406401d21b..a2a1796a72f 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
@@ -60,5 +60,7 @@ void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
+int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
+void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
 #endif /* __XFS_INODE_UTIL_H__ */

