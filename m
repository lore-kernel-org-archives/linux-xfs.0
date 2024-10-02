Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1C317D2
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831693; cv=none; b=JLpSuAAqEwhJt+hgOD1JC0C/iP4GdNdo9/UWkrITREhEpkBkVCz2WwasdL+75hkO3XJRO9DaG7FMgrwuK1bt5HuyiruP0L1ZEQfKPt0XlZd2xqdjKmHnZ6WlHFsSVhHmzwxkdGcz+J5N7j1tPyJoIJhBdZ8UuoS9g8OSvV6G/7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831693; c=relaxed/simple;
	bh=cQTJopVtZw73GmkO+eAKJS8Drtg/iFfFEsCgj2zwz48=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gPvupxOMR6Tp+LrK5yDE574/rsoIfPuqlg3vLdmfAIXShxZoXkAAIQYXG4NKMuCGsdB6CDXTGekmTBuiP0UMkx/lT6a+N0w86qI20nV70NglnzscWOrYAqdTIK7Z/zvb7zcM73Vv56lmKfxbgMKxyzAY2DXwQc6yCQSQ0wagD1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bacLRz29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bacLRz29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92193C4CEC6;
	Wed,  2 Oct 2024 01:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831692;
	bh=cQTJopVtZw73GmkO+eAKJS8Drtg/iFfFEsCgj2zwz48=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bacLRz29vdlk3zyY6qf0gQdcuM2cpaCzI7KJYXu/RQ+1Y2Wz9IrKK7e88vuh3MkAS
	 DHZ2muFoniwK373oJjff8gB6UZeWRLUp3dK8fMzuafAPpl9RNxiir2V0uapcBx8fVz
	 AHHiodEBaQVxdNxnffURgSqwpT0B26gbu/cLk0HlWbA/sNPGXL/Ou0wJMcdysBK8L8
	 f85139RM32vZ0hOgadrj1PhewMjbErGyY7ltDLbhOQN5DF8H/rJqzn16qaLFzGGMtR
	 mrhCdvyHxHyi/LqSFANyuRQqGUREyEfK6m9GLe0fdCr0rFiEmf9JAUMelukY67VhzK
	 70wnCbNTtey3Q==
Date: Tue, 01 Oct 2024 18:14:52 -0700
Subject: [PATCH 27/64] xfs: hoist inode free function to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102188.4036371.13924418007546965939.stgit@frogsfrogsfrogs>
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

Source kernel commit: 1964435d19d947b8626379d09db3e33b9669f333

Create a libxfs helper function that marks an inode free on disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_inode_util.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h |    5 +++++
 2 files changed, 56 insertions(+)


diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 13c32d114..74d2b5960 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -693,3 +693,54 @@ xfs_bumplink(
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
+
+/* Free an inode in the ondisk index and zero it out. */
+int
+xfs_inode_uninit(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip,
+	struct xfs_icluster	*xic)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
+	/*
+	 * Free the inode first so that we guarantee that the AGI lock is going
+	 * to be taken before we remove the inode from the unlinked list. This
+	 * makes the AGI lock -> unlinked list modification order the same as
+	 * used in O_TMPFILE creation.
+	 */
+	error = xfs_difree(tp, pag, ip->i_ino, xic);
+	if (error)
+		return error;
+
+	error = xfs_iunlink_remove(tp, pag, ip);
+	if (error)
+		return error;
+
+	/*
+	 * Free any local-format data sitting around before we reset the
+	 * data fork to extents format.  Note that the attr fork data has
+	 * already been freed by xfs_attr_inactive.
+	 */
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		kfree(ip->i_df.if_data);
+		ip->i_df.if_data = NULL;
+		ip->i_df.if_bytes = 0;
+	}
+
+	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
+	ip->i_diflags = 0;
+	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
+	ip->i_forkoff = 0;		/* mark the attr fork not in use */
+	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
+
+	/*
+	 * Bump the generation count so no one will be confused
+	 * by reincarnations of this inode.
+	 */
+	VFS_I(ip)->i_generation++;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index 1c54c3b0c..060242998 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_INODE_UTIL_H__
 #define	__XFS_INODE_UTIL_H__
 
+struct xfs_icluster;
+
 uint16_t	xfs_flags2diflags(struct xfs_inode *ip, unsigned int xflags);
 uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
 uint32_t	xfs_dic2xflags(struct xfs_inode *ip);
@@ -48,6 +50,9 @@ void xfs_trans_ichgtime(struct xfs_trans *tp, struct xfs_inode *ip, int flags);
 void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 		struct xfs_inode *ip);
 
+int xfs_inode_uninit(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip, struct xfs_icluster *xic);
+
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);

