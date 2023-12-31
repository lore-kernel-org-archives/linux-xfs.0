Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20314BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FXByAaBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11C2C433C7;
	Sun, 31 Dec 2023 21:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056649;
	bh=VxawqEVYYD0ZM4ry6dxItr3rcehga7Ke1bDZr91+4Y4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FXByAaBwj/PjQpneGJxSC5oTvmd8gSx8U9Hy0EvpccAwILJZ80aYkOrKq0j2HVVrD
	 d/0T07j4xHgfckYlauozABgnLnxx1TfcYYlS8wd8wrtAly5i2bBs+pOtOoiBInitgL
	 4TESESgTxBmXTk6JYhkwe5ocD+8ASwO8qetrAQaf22L7HiKXkiMNURACrVcRZyReg4
	 lQ8vdCLuM2celDlL3Y7tesVfmZXAo/s0ebo21xrXkisa1GCpRtxdBm1c2MRaoEtmDU
	 sfM8GxTKX95zkZ7/a+kD+PvcUZ04J5R0Iwijd78qsMdQMx8mvl5yOAFffYVJj1II/k
	 wnvwvvCR2GnZw==
Date: Sun, 31 Dec 2023 13:04:08 -0800
Subject: [PATCH 13/21] xfs: hoist xfs_{bump,drop}link to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844262.1759932.6893292995767382211.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
References: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_inode_util.c |   53 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    2 ++
 fs/xfs/xfs_inode.c             |   53 ----------------------------------------
 fs/xfs/xfs_inode.h             |    2 --
 4 files changed, 55 insertions(+), 55 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index be1fa47dc9c88..3de478eb5a83a 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -617,3 +617,56 @@ xfs_iunlink_remove(
 
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
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 0406401d21b76..a2a1796a72ff3 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -60,5 +60,7 @@ void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
+int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
+void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 798c4fdf700c3..0e37bbc5b6784 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -663,59 +663,6 @@ xfs_icreate_args_rootfile(
 		args->flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
 }
 
-/*
- * Decrement the link count on an inode & log the change.  If this causes the
- * link count to go to zero, move the inode to AGI unlinked list so that it can
- * be freed when the last active reference goes away via xfs_inactive().
- */
-int
-xfs_droplink(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	struct inode		*inode = VFS_I(ip);
-
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	if (inode->i_nlink == 0) {
-		xfs_info_ratelimited(tp->t_mountp,
- "Inode 0x%llx link count dropped below zero.  Pinning link count.",
-				ip->i_ino);
-		set_nlink(inode, XFS_NLINK_PINNED);
-	}
-	if (inode->i_nlink != XFS_NLINK_PINNED)
-		drop_nlink(inode);
-
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	if (inode->i_nlink)
-		return 0;
-
-	return xfs_iunlink(tp, ip);
-}
-
-/*
- * Increment the link count on an inode & log the change.
- */
-void
-xfs_bumplink(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	struct inode		*inode = VFS_I(ip);
-
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	if (inode->i_nlink == XFS_NLINK_PINNED - 1)
-		xfs_info_ratelimited(tp->t_mountp,
- "Inode 0x%llx link count exceeded maximum.  Pinning link count.",
-				ip->i_ino);
-	if (inode->i_nlink != XFS_NLINK_PINNED)
-		inc_nlink(inode);
-
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-}
-
 #ifdef CONFIG_XFS_LIVE_HOOKS
 /*
  * Use a static key here to reduce the overhead of directory live update hooks.
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 95e7a73d90e58..6433492e7301f 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -613,8 +613,6 @@ void xfs_end_io(struct work_struct *work);
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_remapping(struct xfs_inode *ip1, struct xfs_inode *ip2);
-int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
-void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 void xfs_sort_inodes(struct xfs_inode **i_tab, unsigned int num_inodes);
 

