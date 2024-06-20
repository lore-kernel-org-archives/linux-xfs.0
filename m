Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37709C8FB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924524; cv=none; b=Dm5SCOzJRLaNAweo1awg1siXN5UlE6b3oMdQCkd4rCsiHyoTLb+Em3nfcl/DLxFmnIpF5puAYlq9/YYIszYom3u3v6mmq3LdM9UEpbF0zLMaKkU03Yo76dbRpq20LQ57LXptZwd5YOKnmu2XVSRIpxy6skVpKxCTIakaJogOWwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924524; c=relaxed/simple;
	bh=p278gOk07vy+VZJd/sZRA2hso2U/29H7TWSZHiKcdVk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fwQJ8hBHf+y1HcMeF9GAQ475X18Y3C/bfYmBb1i8uOp14Ir0gw/1O2JNrtO+1Uj2htqBFbIZOqjLgz6Vi7HmthFVq9GVljZe1WP2/8gx7fBART2dGdmYDKkTVQjUwDuqqTNUX3Gqkq/rde/gE5CKx/qwvS7kgUrnZRhWOGUrWOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VEhZewIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VEhZewIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6912C32781;
	Thu, 20 Jun 2024 23:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924523;
	bh=p278gOk07vy+VZJd/sZRA2hso2U/29H7TWSZHiKcdVk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VEhZewIX5XdQQUJnvrkrwhSiFf14TPohpROh4mio2Xt0I6er7yP056e2SuEM6VUsS
	 CdShBbjYIcB4eSF7AHk3ESDzK/bIj8DT9cYWcC9gHRRHGq98DxGfhrqrrvjrD56bgB
	 NdgExlBig0s3TrFrsAggCPZCUfEoxR/jio1vHt6cQpvjHgj4YJ46jsV4acBONOJHV4
	 By8A87BdbMvDcFMLbC6SWqAqvKp+zTl5ed6TK7+aI9pb7TQ1RivH0U+q6F7UF7V0+k
	 /S2oNePPuiILbuzH1SkZSDS9rsfDL3giKJRgn+DgBQIBzyq1YArGw4joYmGfVyp4yX
	 XCsUmkW0sajbA==
Date: Thu, 20 Jun 2024 16:02:03 -0700
Subject: [PATCH 14/24] xfs: hoist xfs_{bump,drop}link to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418137.3183075.9161813667351346245.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
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
index 5739871ac3705..214976ecefd77 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -626,3 +626,56 @@ xfs_iunlink_remove(
 
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
index 42a032afe3cac..50c14ba6ca5a2 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -50,5 +50,7 @@ void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
+int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
+void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 182c63ee36b0e..c59c6321e361a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -600,59 +600,6 @@ xfs_icreate(
 	return 0;
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
index 47d3a11a0e7ef..5ee044674c3ab 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -615,8 +615,6 @@ void xfs_end_io(struct work_struct *work);
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_remapping(struct xfs_inode *ip1, struct xfs_inode *ip2);
-int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
-void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 void xfs_sort_inodes(struct xfs_inode **i_tab, unsigned int num_inodes);
 

