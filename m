Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1626F6AD7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 05:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712121149; cv=none; b=jBqhNL+e8Fm2OKCHTVK10OpKkQxO0RuIRDJrpKrl8kYJF3Dw63SxUj1vIeh5cffbLRn9zTaQJNZlgsEzbHLSNxIIrr86uEHpQnYmky0tuI2OfAfxZD76lsHuzIGjNYFPv8sgeEUz5oxVmh4JRTVS3Q/bue+ozkJrqAtlF8i1PxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712121149; c=relaxed/simple;
	bh=MtrTnaPGRR7/sCRH9ydZSDxR8CSvkID6VOwJ2u3yPDs=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tPlc3dLdlEMgIcEq1nwA11GMZkEzrtjbVXkl5kHIhhaZ5gG0RTz5FElYuIBOgjdQWSMwoXpAIapv/aGspBiV/6J7WaySaXY5HUK0zXfyOqQ1WQeoD7fipdeZ6tC5saPNpUIRMhcIMXdvDFL+6fZrOz34UblstQTAEGEkHDMMN1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFAkPocP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFAkPocP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE62BC433F1;
	Wed,  3 Apr 2024 05:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712121148;
	bh=MtrTnaPGRR7/sCRH9ydZSDxR8CSvkID6VOwJ2u3yPDs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=FFAkPocPixGZZavnRmYfHGzh0mDSiBBT2R185e0B1I+IXayTFB2foRbnO1c7BOzN8
	 gOviKTDy4lQ35qOyqHRXjwazcLFe/ijWZe1BhNaeM85L7XDIpG8cyQVSeawe8WokK/
	 d5l3x8c42nc0O4gcQXl4tlTap5upbOmqp+a9rgQ3h14GYjXCEHrL74eHRcID/fSx1C
	 MSa6ao2WtOfksMvXxK+w8t957qTyW9SfagHVJcllm330/luMNm7XuOpfQtVeMrKzH8
	 7imogCA+6VaKSaTZLFmrCviF4ONMqT6ZpMTP/GJH6N3YmmOI+pggYlFgIbiFKFQCbt
	 LAlnFjZTSwxlw==
Subject: [PATCH 1/3] xfs: expose xfs_bmap_local_to_extents for online repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Date: Tue, 02 Apr 2024 22:12:28 -0700
Message-ID: <171212114806.1525560.3907483686132876442.stgit@frogsfrogsfrogs>
In-Reply-To: <171212114215.1525560.14502410308582567104.stgit@frogsfrogsfrogs>
References: <171212114215.1525560.14502410308582567104.stgit@frogsfrogsfrogs>
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

Allow online repair to call xfs_bmap_local_to_extents and add a void *
argument at the end so that online repair can pass its own context.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c           |   11 ++++++-----
 fs/xfs/libxfs/xfs_bmap.h           |    6 ++++++
 fs/xfs/libxfs/xfs_symlink_remote.c |    3 ++-
 fs/xfs/libxfs/xfs_symlink_remote.h |    3 ++-
 4 files changed, 16 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 46bbc9f0a1173..59b8b9dc29ccf 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -779,7 +779,7 @@ xfs_bmap_local_to_extents_empty(
 }
 
 
-STATIC int				/* error */
+int					/* error */
 xfs_bmap_local_to_extents(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_inode_t	*ip,		/* incore inode pointer */
@@ -789,7 +789,8 @@ xfs_bmap_local_to_extents(
 	void		(*init_fn)(struct xfs_trans *tp,
 				   struct xfs_buf *bp,
 				   struct xfs_inode *ip,
-				   struct xfs_ifork *ifp))
+				   struct xfs_ifork *ifp, void *priv),
+	void		*priv)
 {
 	int		error = 0;
 	int		flags;		/* logging flags returned */
@@ -850,7 +851,7 @@ xfs_bmap_local_to_extents(
 	 * log here. Note that init_fn must also set the buffer log item type
 	 * correctly.
 	 */
-	init_fn(tp, bp, ip, ifp);
+	init_fn(tp, bp, ip, ifp, priv);
 
 	/* account for the change in fork size */
 	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
@@ -982,8 +983,8 @@ xfs_bmap_add_attrfork_local(
 
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		return xfs_bmap_local_to_extents(tp, ip, 1, flags,
-						 XFS_DATA_FORK,
-						 xfs_symlink_local_to_remote);
+				XFS_DATA_FORK, xfs_symlink_local_to_remote,
+				NULL);
 
 	/* should only be called for types that support local format data */
 	ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b8bdbf1560e65..32fb2a455c294 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -179,6 +179,12 @@ unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
+int xfs_bmap_local_to_extents(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_extlen_t total, int *logflagsp, int whichfork,
+		void (*init_fn)(struct xfs_trans *tp, struct xfs_buf *bp,
+				struct xfs_inode *ip, struct xfs_ifork *ifp,
+				void *priv),
+		void *priv);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 8f0d5c584f46f..d150576ddd0af 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -169,7 +169,8 @@ xfs_symlink_local_to_remote(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp,
 	struct xfs_inode	*ip,
-	struct xfs_ifork	*ifp)
+	struct xfs_ifork	*ifp,
+	void			*priv)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	char			*buf;
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.h b/fs/xfs/libxfs/xfs_symlink_remote.h
index ac3dac8f617ed..83b89a1deb9f2 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.h
+++ b/fs/xfs/libxfs/xfs_symlink_remote.h
@@ -16,7 +16,8 @@ int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
 bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
-				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+				 struct xfs_inode *ip, struct xfs_ifork *ifp,
+				 void *priv);
 xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
 int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
 int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,

