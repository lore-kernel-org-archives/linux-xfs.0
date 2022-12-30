Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEB3C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235887AbiLaAVJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbiLaAVI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:21:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5E3B4AF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:21:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E816B81E7C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB61AC433D2;
        Sat, 31 Dec 2022 00:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446062;
        bh=ALZ/sNWYhKPbQ9zS7CgZisst+CMUhfmDd5tUFGuXt4I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fpbnLSnI4Bjbbpz5deocrOhNeP0lHoOh7y4+FqbVcNf3NiqM058rbnzHIA43X/Msv
         bzpqQS7cb9S1+5ONdbvbRTC3ToLlyBhi0wZ+Wkw0lt0AUUU+RWklcqxNJIlC6i/h4U
         HZLJ9e3KPbr1mk8DfHRkCK8wlfYlo2Vk1bkj7Z8clT3i+XOg2d0vtJ7aQW6HjIdgWP
         fdnokJk/m2B8Pi1IilcBrprrb4CVyhK1nDsHJzDtBZ29rQcOq4hGzSivKhdEQ7W0TT
         vwI81fJ+rebQulwArb+iPn7gjNBYoSzTbGvJZW7NEU9o7GWLsyKfkVS7Jys5b/RgAr
         +gFaM+lxJIQjg==
Subject: [PATCH 09/19] xfs: condense symbolic links after an atomic swap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:00 -0800
Message-ID: <167243868056.713817.16461690212103253756.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The previous commit added a new swapext flag that enables us to perform
post-swap processing on file2 once we're done swapping the extent maps.
Now add this ability for symlinks.

This isn't used anywhere right now, but we need to have the basic ondisk
flags in place so that a future online symlink repair feature can
salvage the remote target in a temporary link and swap the data forks
when ready.  If one file is in extents format and the other is inline,
we will have to promote both to extents format to perform the swap.
After the swap, we can try to condense the fixed symlink down to inline
format if possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_swapext.c        |   48 ++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_symlink_remote.c |   47 ++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_symlink_remote.h |    1 +
 3 files changed, 95 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index cb5bafe3112..e439b938f10 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -27,6 +27,7 @@
 #include "xfs_attr.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_dir2.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -421,6 +422,48 @@ xfs_swapext_dir_to_sf(
 	return xfs_dir2_block_to_sf(&args, bp, size, &sfh);
 }
 
+/* Convert inode2's remote symlink target back to shortform, if possible. */
+STATIC int
+xfs_swapext_link_to_sf(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi)
+{
+	struct xfs_inode		*ip = sxi->sxi_ip2;
+	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	char				*buf;
+	int				error;
+
+	if (ifp->if_format == XFS_DINODE_FMT_LOCAL ||
+	    ip->i_disk_size > xfs_inode_data_fork_size(ip))
+		return 0;
+
+	/* Read the current symlink target into a buffer. */
+	buf = kmem_alloc(ip->i_disk_size + 1, KM_NOFS);
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
+	kmem_free(buf);
+	return error;
+}
+
 static inline void
 xfs_swapext_clear_reflink(
 	struct xfs_trans	*tp,
@@ -445,6 +488,8 @@ xfs_swapext_do_postop_work(
 			error = xfs_swapext_attr_to_sf(tp, sxi);
 		else if (S_ISDIR(VFS_I(sxi->sxi_ip2)->i_mode))
 			error = xfs_swapext_dir_to_sf(tp, sxi);
+		else if (S_ISLNK(VFS_I(sxi->sxi_ip2)->i_mode))
+			error = xfs_swapext_link_to_sf(tp, sxi);
 		sxi->sxi_flags &= ~XFS_SWAP_EXT_CVT_INO2_SF;
 		if (error)
 			return error;
@@ -1101,7 +1146,8 @@ xfs_swapext(
 	if (req->req_flags & XFS_SWAP_REQ_CVT_INO2_SF)
 		ASSERT(req->whichfork == XFS_ATTR_FORK ||
 		       (req->whichfork == XFS_DATA_FORK &&
-			S_ISDIR(VFS_I(req->ip2)->i_mode)));
+			(S_ISDIR(VFS_I(req->ip2)->i_mode) ||
+			 S_ISLNK(VFS_I(req->ip2)->i_mode))));
 
 	if (req->blockcount == 0)
 		return;
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 740db58d99c..3565135bead 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -388,3 +388,50 @@ xfs_symlink_write_target(
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
index d81461c06b6..05eb9c3937d 100644
--- a/libxfs/xfs_symlink_remote.h
+++ b/libxfs/xfs_symlink_remote.h
@@ -23,5 +23,6 @@ int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
 int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
 		const char *target_path, int pathlen, xfs_fsblock_t fs_blocks,
 		uint resblks);
+int xfs_symlink_remote_truncate(struct xfs_trans *tp, struct xfs_inode *ip);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */

