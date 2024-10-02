Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631E65227
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831630; cv=none; b=qLgtxa1GUs5hCGb2oqfnnnLbUYlXRq/HDrJSSwHO6mN7MEbgJzmhKYItsQiFC+TEIqUw+K5QtM9jO1IGNsK7zA00MySx5VjCB2eQBAjTCxE5zQ1jaaY/qo0esx4tzlDeSxAzFSz9P+N9h2vBmFVW0ciBxNVO1Yl1Lh+lZbQ5fsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831630; c=relaxed/simple;
	bh=AJQbLbPDFWHtW43elHKmBq875CKAxdZKAS4EWFsV6lU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H7p+j/lqcerw/Q18fWWVu+YjtuKAe7NamozHlZj/WUq5tZOBokDb939H9+IMHHAlixLKFAvcF3dN63zQ8UGFUIVCAdsNeduAllcFhdx//7kG9OONCBygOp185ER6BtbQpvOHIAMB5IsWZCH/NYqqqZ5X5G9iR8kWWUEqOOkCVfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlpFQjk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlpFQjk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33251C4CECD;
	Wed,  2 Oct 2024 01:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831630;
	bh=AJQbLbPDFWHtW43elHKmBq875CKAxdZKAS4EWFsV6lU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HlpFQjk/VqNot4FKMLqsPiiXj+KnsAiuTdShPgaIXNPvjPAb9WWkcluhkrbL+hpLM
	 gA5m921gCANXK1T1C01uPalOEslTrFreBlRXoKt0iMQRAhwVBuc0vKDLsg9gqieXrb
	 MtCd7t3tDyqMzlH4V+o9bP3hXYef0G7+BbpEYAY3A8qfKacZvdfXw3NUYTQTod62FL
	 ctGmALRbTTJq98ZCO7aWgEHb6bJVhByEArIaYuSHpQhn84p5lAe9ZaIrzDjWTJ6nWl
	 1cQ4uKENqtbXzKxQ99BwwpiRUCVMkGidzWh/Gq8xkjJ890jgAN0trKm+tJLVEp6JEX
	 ozIlwL9Tt9/fA==
Date: Tue, 01 Oct 2024 18:13:49 -0700
Subject: [PATCH 23/64] xfs: hoist xfs_{bump,drop}link to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102128.4036371.15379493452014093565.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: a9e583d34facc64b6edf3c9afb2ff4891038176d

Move xfs_bumplink and xfs_droplink to libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_inode.h     |    2 --
 libxfs/inode.c          |   18 ----------------
 libxfs/libxfs_priv.h    |    1 +
 libxfs/xfs_inode_util.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h |    2 ++
 5 files changed, 56 insertions(+), 20 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 19aaa78f3..170cc5288 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -407,8 +407,6 @@ extern void	libxfs_trans_ichgtime(struct xfs_trans *,
 				struct xfs_inode *, int);
 extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
 
-void libxfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
-
 int libxfs_icreate(struct xfs_trans *tp, xfs_ino_t ino,
 		const struct xfs_icreate_args *args, struct xfs_inode **ipp);
 
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 20b9c483a..2062ecf54 100644
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
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index a77524dfd..b720cc5fa 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -135,6 +135,7 @@ extern void cmn_err(int, char *, ...);
 enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 
 #define xfs_info(mp,fmt,args...)	cmn_err(CE_CONT, _(fmt), ## args)
+#define xfs_info_ratelimited(mp,fmt,args...) cmn_err(CE_CONT, _(fmt), ## args)
 #define xfs_notice(mp,fmt,args...)	cmn_err(CE_NOTE, _(fmt), ## args)
 #define xfs_warn(mp,fmt,args...)	cmn_err((mp) ? CE_WARN : CE_WARN, _(fmt), ## args)
 #define xfs_err(mp,fmt,args...)		cmn_err(CE_ALERT, _(fmt), ## args)
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 2d7e970d7..62af002b2 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -624,3 +624,56 @@ xfs_iunlink_remove(
 
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
index 42a032afe..50c14ba6c 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
@@ -50,5 +50,7 @@ void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
+int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
+void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
 #endif /* __XFS_INODE_UTIL_H__ */

