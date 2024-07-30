Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F181B10E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299184; cv=none; b=u8Dzsp8rvZAsQRB4xkvlrQK0kWp0Y3ax0o6uCPIws0S7crUpNb9u4uOxHMUDhxgBaS8SwOaKLVsjn+tOVcYdxAnCySWqvKPGmqTsbcob94jhES437+XOz566oSDNCpt4knou5hkED1v5dqJGz4/vTgPh0C0zvMiKXoOli4B/M7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299184; c=relaxed/simple;
	bh=zqqE0pDSc94SCcVKaDoqqAJBp1TB/3Fo4Cvx89ltN8s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EgWa71re65vTbmEVgTbCFaTxzbCHUkoTkO1dLv6tjvMITPRTmFs8fRF0CYgSnVjIS1SRmqhhtDrU2DriZzObnRWDenHGLfTU4NZvvbQgbQshyEc1cAniGsqGlArnfWjMoBhnYcewBoY7Y/NpuUM9e0YU9rk+j9MVOFCnvce6lFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4tflIzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4tflIzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70813C32786;
	Tue, 30 Jul 2024 00:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299183;
	bh=zqqE0pDSc94SCcVKaDoqqAJBp1TB/3Fo4Cvx89ltN8s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j4tflIzCoiw1fETaE2dfKcLGgiT7Dzv40Sfu+TjJllwjFpDYqp/qXI9iJKtDziEwf
	 TiktW7UvGTpM/oLhpxoA3L4DfYIfERkdOgeYw5IFTAZb0GgrWAZHV8O8gtYye/3bY2
	 VT9mir4wqBNu70uQNY1wNGjH6uFNcguNN4MhFJ+p5M8cyxX+0AhhsjWj5KwFS2sSaC
	 f6FMSulWWj+benExzp0OLWroFkV0qaXe1EXeR9slBPZ43sFy+Xr82B/C6uSrKcnr6z
	 zDf8BX4DMwsS/D1KH7oAktm1veYYpgq2xWcyh5QQdcA2S8sUx4FAgBw6rP6Zf0QQlw
	 beihwhXo6W+SA==
Date: Mon, 29 Jul 2024 17:26:22 -0700
Subject: [PATCH 010/115] xfs: condense symbolic links after a mapping exchange
 operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842582.1338752.12848688005174368044.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 33a9be2b7016e79f47c4c1b523a0aa59d41893c0

The previous commit added a new file mapping exchange flag that enables
us to perform post-exchange processing on file2 once we're done
exchanging the extent mappings.  Now add this ability for symlinks.

This isn't used anywhere right now, but we need to have the basic ondisk
flags in place so that a future online symlink repair feature can
salvage the remote target in a temporary link and exchange the data fork
mappings when ready.  If one file is in extents format and the other is
inline, we will have to promote both to extents format to perform the
exchange.  After the exchange, we can try to condense the fixed symlink
down to inline format if possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_exchmaps.c       |   49 ++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_symlink_remote.c |   47 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_symlink_remote.h |    1 +
 3 files changed, 96 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 6e758cac1..34ac9d5f2 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -27,6 +27,7 @@
 #include "xfs_attr.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_dir2.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache	*xfs_exchmaps_intent_cache;
 
@@ -430,6 +431,49 @@ xfs_exchmaps_dir_to_sf(
 	return xfs_dir2_block_to_sf(&args, bp, size, &sfh);
 }
 
+/* Convert inode2's remote symlink target back to shortform, if possible. */
+STATIC int
+xfs_exchmaps_link_to_sf(
+	struct xfs_trans		*tp,
+	struct xfs_exchmaps_intent	*xmi)
+{
+	struct xfs_inode		*ip = xmi->xmi_ip2;
+	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	char				*buf;
+	int				error;
+
+	if (ifp->if_format == XFS_DINODE_FMT_LOCAL ||
+	    ip->i_disk_size > xfs_inode_data_fork_size(ip))
+		return 0;
+
+	/* Read the current symlink target into a buffer. */
+	buf = kmalloc(ip->i_disk_size + 1,
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
+	if (!buf) {
+		ASSERT(0);
+		return -ENOMEM;
+	}
+
+	error = xfs_symlink_remote_read(ip, buf);
+	if (error)
+		goto free;
+
+	/* Remove the blocks. */
+	error = xfs_symlink_remote_truncate(tp, ip);
+	if (error)
+		goto free;
+
+	/* Convert fork to local format and log our changes. */
+	xfs_idestroy_fork(ifp);
+	ifp->if_bytes = 0;
+	ifp->if_format = XFS_DINODE_FMT_LOCAL;
+	xfs_init_local_fork(ip, XFS_DATA_FORK, buf, ip->i_disk_size);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
+free:
+	kfree(buf);
+	return error;
+}
+
 /* Clear the reflink flag after an exchange. */
 static inline void
 xfs_exchmaps_clear_reflink(
@@ -455,6 +499,8 @@ xfs_exchmaps_do_postop_work(
 			error = xfs_exchmaps_attr_to_sf(tp, xmi);
 		else if (S_ISDIR(VFS_I(xmi->xmi_ip2)->i_mode))
 			error = xfs_exchmaps_dir_to_sf(tp, xmi);
+		else if (S_ISLNK(VFS_I(xmi->xmi_ip2)->i_mode))
+			error = xfs_exchmaps_link_to_sf(tp, xmi);
 		xmi->xmi_flags &= ~__XFS_EXCHMAPS_INO2_SHORTFORM;
 		if (error)
 			return error;
@@ -919,7 +965,8 @@ xfs_exchmaps_init_intent(
 			xmi->xmi_flags |= XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
 	}
 
-	if (S_ISDIR(VFS_I(xmi->xmi_ip2)->i_mode))
+	if (S_ISDIR(VFS_I(xmi->xmi_ip2)->i_mode) ||
+	    S_ISLNK(VFS_I(xmi->xmi_ip2)->i_mode))
 		xmi->xmi_flags |= __XFS_EXCHMAPS_INO2_SHORTFORM;
 
 	return xmi;
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 875e03bcb..72f175990 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -377,3 +377,50 @@ xfs_symlink_write_target(
 	ASSERT(pathlen == 0);
 	return 0;
 }
+
+/* Remove all the blocks from a symlink and invalidate buffers. */
+int
+xfs_symlink_remote_truncate(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*bp;
+	int			nmaps = XFS_SYMLINK_MAPS;
+	int			done = 0;
+	int			i;
+	int			error;
+
+	/* Read mappings and invalidate buffers. */
+	error = xfs_bmapi_read(ip, 0, XFS_MAX_FILEOFF, mval, &nmaps, 0);
+	if (error)
+		return error;
+
+	for (i = 0; i < nmaps; i++) {
+		if (!xfs_bmap_is_real_extent(&mval[i]))
+			break;
+
+		error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(mp, mval[i].br_startblock),
+				XFS_FSB_TO_BB(mp, mval[i].br_blockcount), 0,
+				&bp);
+		if (error)
+			return error;
+
+		xfs_trans_binval(tp, bp);
+	}
+
+	/* Unmap the remote blocks. */
+	error = xfs_bunmapi(tp, ip, 0, XFS_MAX_FILEOFF, 0, nmaps, &done);
+	if (error)
+		return error;
+	if (!done) {
+		ASSERT(done);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
+		return -EFSCORRUPTED;
+	}
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
diff --git a/libxfs/xfs_symlink_remote.h b/libxfs/xfs_symlink_remote.h
index a63bd38ae..ac3dac8f6 100644
--- a/libxfs/xfs_symlink_remote.h
+++ b/libxfs/xfs_symlink_remote.h
@@ -22,5 +22,6 @@ int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
 int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
 		const char *target_path, int pathlen, xfs_fsblock_t fs_blocks,
 		uint resblks);
+int xfs_symlink_remote_truncate(struct xfs_trans *tp, struct xfs_inode *ip);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */

