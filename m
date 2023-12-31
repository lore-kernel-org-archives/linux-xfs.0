Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02681C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F+IfxN7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B765C433C8;
	Sun, 31 Dec 2023 23:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065266;
	bh=Yi8lTFiyNvTSh+3F5oaAvkv4PWGAmt5uTWL0zdfWuz0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F+IfxN7NGJwuHYJldCOpWFhyR5G6HXlT1GkAVLq2d7lo7tHDPiDGmi+HZIfE9+tmp
	 6peOzDBMP5jFy7zVhv6k2McD8bLpMfVsGfQDy7sHVVO8rtOkQC/dztVab8KAi+ebRV
	 B4qKmg7ffhVPE4FFaqp6ZIyEIVPwHmM9ginVVGZPiOjuaTfLgdrNfaJ7Lrj5I2V0tI
	 uPNmOE8vXkgDQEO4EyuS2OW9UORfytSaFhsuZFkiWA6scikp8qA8vKtdcWiLn+fOJV
	 hEEzKD6FHG2p48bgEZMy3FmeedXZ/sjh/+lvxHbanMo/raNkvsE+pwjZn+Mgw2mm5m
	 qOV5BNBcnaZUQ==
Date: Sun, 31 Dec 2023 15:27:46 -0800
Subject: [PATCH 21/28] xfs: hoist inode free function to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009456.1808635.1003747568543984857.stgit@frogsfrogsfrogs>
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

Create a libxfs helper function that marks an inode free on disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_inode_util.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h |    5 +++++
 2 files changed, 55 insertions(+)


diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 8f053e3941c..19d26950db9 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -668,3 +668,53 @@ xfs_bumplink(
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
+
+/* Mark an inode free on disk. */
+int
+xfs_dir_ifree(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip,
+	struct xfs_icluster	*xic)
+{
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
+		kmem_free(ip->i_df.if_u1.if_data);
+		ip->i_df.if_u1.if_data = NULL;
+		ip->i_df.if_bytes = 0;
+	}
+
+	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
+	ip->i_diflags = 0;
+	ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
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
index a2a1796a72f..521f044198c 100644
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
@@ -57,6 +59,9 @@ void xfs_trans_ichgtime(struct xfs_trans *tp, struct xfs_inode *ip, int flags);
 void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 		struct xfs_inode *ip);
 
+int xfs_dir_ifree(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip, struct xfs_icluster *xic);
+
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);

