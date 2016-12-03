Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20537 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759368AbcLCBlH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:41:07 -0500
Subject: [PATCH 53/55] xfs: repair damaged symlinks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:41:03 -0800
Message-ID: <148072926358.12995.5634529438592658038.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Repair inconsistent symbolic link data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/repair/common.c  |    3 -
 fs/xfs/repair/common.h  |    1 
 fs/xfs/repair/symlink.c |  235 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 238 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index e5c293d..720ad2a 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -956,6 +956,7 @@ __xfs_scrub_setup_inode(
 	resblks = xfs_bmbt_calc_size(mp,
 			max_t(xfs_extnum_t, sc->ip->i_d.di_nextents,
 				sc->ip->i_d.di_anextents));
+	resblks = max_t(unsigned long long, resblks, XFS_SYMLINK_MAPS);
 	error = xfs_scrub_trans_alloc(sm, mp, &M_RES(mp)->tr_itruncate,
 			resblks, 0, 0, &sc->tp);
 	if (error)
@@ -1160,7 +1161,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_cow, NULL, NULL},
 	{xfs_scrub_setup_inode, xfs_scrub_directory, NULL, NULL},
 	{xfs_scrub_setup_inode_xattr, xfs_scrub_xattr, NULL, NULL},
-	{xfs_scrub_setup_inode_symlink, xfs_scrub_symlink, NULL, NULL},
+	{xfs_scrub_setup_inode_symlink, xfs_scrub_symlink, xfs_repair_symlink, NULL},
 	{xfs_scrub_setup_rt, xfs_scrub_rtbitmap, NULL, xfs_sb_version_hasrealtime},
 	{xfs_scrub_setup_rt, xfs_scrub_rtsummary, NULL, xfs_sb_version_hasrealtime},
 };
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index 525b02b..3f7d5c4 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -294,5 +294,6 @@ int xfs_repair_refcountbt(struct xfs_scrub_context *sc);
 int xfs_repair_inode(struct xfs_scrub_context *sc);
 int xfs_repair_bmap_data(struct xfs_scrub_context *sc);
 int xfs_repair_bmap_attr(struct xfs_scrub_context *sc);
+int xfs_repair_symlink(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/repair/symlink.c b/fs/xfs/repair/symlink.c
index 932201b..84d8a14 100644
--- a/fs/xfs/repair/symlink.c
+++ b/fs/xfs/repair/symlink.c
@@ -33,6 +33,8 @@
 #include "xfs_inode.h"
 #include "xfs_inode_fork.h"
 #include "xfs_symlink.h"
+#include "xfs_bmap.h"
+#include "xfs_quota.h"
 #include "repair/common.h"
 
 /* Symbolic links. */
@@ -82,3 +84,236 @@ xfs_scrub_symlink(
 }
 #undef XFS_SCRUB_SYMLINK_GOTO
 #undef XFS_SCRUB_SYMLINK_CHECK
+
+/* Blow out the whole symlink; replace contents. */
+STATIC int
+xfs_repair_symlink_rewrite(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	const char		*target_path,
+	int			pathlen)
+{
+	struct xfs_defer_ops	dfops;
+	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
+	struct xfs_ifork	*ifp;
+	const char		*cur_chunk;
+	struct xfs_mount	*mp = (*tpp)->t_mountp;
+	struct xfs_buf		*bp;
+	xfs_fsblock_t		first_block;
+	xfs_fileoff_t		first_fsb;
+	xfs_filblks_t		fs_blocks;
+	xfs_daddr_t		d;
+	uint			resblks;
+	int			byte_cnt;
+	int			n;
+	int			nmaps;
+	int			offset;
+	int			error = 0;
+
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+
+	/* Truncate the whole data fork if it wasn't inline. */
+	if (!(ifp->if_flags & XFS_IFINLINE)) {
+		error = xfs_itruncate_extents(tpp, ip, XFS_DATA_FORK, 0);
+		if (error)
+			goto out;
+	}
+
+	/* Blow out the in-core fork and zero the on-disk fork. */
+	xfs_idestroy_fork(ip, XFS_DATA_FORK);
+	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
+	ip->i_d.di_nextents = 0;
+	memset(&ip->i_df, 0, sizeof(struct xfs_ifork));
+	ip->i_df.if_flags |= XFS_IFEXTENTS;
+
+	/* Rewrite an inline symlink. */
+	if (pathlen <= XFS_IFORK_DSIZE(ip)) {
+		xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen);
+
+		i_size_write(VFS_I(ip), pathlen);
+		ip->i_d.di_size = pathlen;
+		ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
+		xfs_trans_log_inode(*tpp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
+		goto out;
+
+	}
+
+	/* Rewrite a remote symlink. */
+	fs_blocks = xfs_symlink_blocks(mp, pathlen);
+	first_fsb = 0;
+	nmaps = XFS_SYMLINK_MAPS;
+
+	/* Reserve quota for new blocks. */
+	error = xfs_trans_reserve_quota_nblks(*tpp, ip, fs_blocks, 0,
+			XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		goto out;
+
+	/* Map blocks, write symlink target. */
+	xfs_defer_init(&dfops, &first_block);
+
+	error = xfs_bmapi_write(*tpp, ip, first_fsb, fs_blocks,
+			  XFS_BMAPI_METADATA, &first_block, fs_blocks,
+			  mval, &nmaps, &dfops);
+	if (error)
+		goto out_bmap_cancel;
+
+	if (resblks)
+		resblks -= fs_blocks;
+	ip->i_d.di_size = pathlen;
+	i_size_write(VFS_I(ip), pathlen);
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+
+	cur_chunk = target_path;
+	offset = 0;
+	for (n = 0; n < nmaps; n++) {
+		char	*buf;
+
+		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
+		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
+		bp = xfs_trans_get_buf(*tpp, mp->m_ddev_targp, d,
+				       BTOBB(byte_cnt), 0);
+		if (!bp) {
+			error = -ENOMEM;
+			goto out_bmap_cancel;
+		}
+		bp->b_ops = &xfs_symlink_buf_ops;
+
+		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
+		byte_cnt = min(byte_cnt, pathlen);
+
+		buf = bp->b_addr;
+		buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset,
+					   byte_cnt, bp);
+
+		memcpy(buf, cur_chunk, byte_cnt);
+
+		cur_chunk += byte_cnt;
+		pathlen -= byte_cnt;
+		offset += byte_cnt;
+
+		xfs_trans_buf_set_type(*tpp, bp, XFS_BLFT_SYMLINK_BUF);
+		xfs_trans_log_buf(*tpp, bp, 0, (buf + byte_cnt - 1) -
+						(char *)bp->b_addr);
+	}
+	ASSERT(pathlen == 0);
+
+	error = xfs_defer_finish(tpp, &dfops, NULL);
+	if (error)
+		goto out_bmap_cancel;
+
+	return 0;
+
+out_bmap_cancel:
+	xfs_defer_cancel(&dfops);
+out:
+	return error;
+}
+
+int
+xfs_repair_symlink(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_bmbt_irec		mval[XFS_SYMLINK_MAPS];
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_ifork		*ifp;
+	struct xfs_buf			*bp;
+	loff_t				len;
+	size_t				newlen;
+	xfs_daddr_t			d;
+	int				fsblocks;
+	int				nmaps = XFS_SYMLINK_MAPS;
+	int				nr;
+	int				offset;
+	int				n;
+	int				byte_cnt;
+	int				error = 0;
+
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	len = i_size_read(VFS_I(ip));
+	xfs_trans_ijoin(sc->tp, ip, 0);
+
+	/* Truncate the inode if there's a zero inside the length. */
+	if (ifp->if_flags & XFS_IFINLINE) {
+		if (ifp->if_u1.if_data)
+			newlen = strnlen(ifp->if_u1.if_data,
+					XFS_IFORK_DSIZE(ip));
+		else {
+			newlen = 1;
+			ifp->if_u1.if_data = ifp->if_u2.if_inline_data;
+			ifp->if_u1.if_data[0] = '/';
+		}
+		if (len > newlen) {
+			i_size_write(VFS_I(ip), newlen);
+			ip->i_d.di_size = newlen;
+			xfs_trans_log_inode(sc->tp, ip, XFS_ILOG_DDATA |
+					XFS_ILOG_CORE);
+		}
+		goto out;
+	}
+
+	fsblocks = xfs_symlink_blocks(mp, len);
+	error = xfs_bmapi_read(ip, 0, fsblocks, mval, &nmaps, 0);
+	if (error)
+		goto out;
+
+	/* Fix everything that fails the verifiers. */
+	offset = 0;
+	for (n = 0; n < nmaps; n++) {
+		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
+		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
+
+		error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+				d, BTOBB(byte_cnt), 0, &bp, NULL);
+		if (error)
+			goto out;
+		bp->b_ops = &xfs_symlink_buf_ops;
+
+		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
+		if (len < byte_cnt)
+			byte_cnt = len;
+
+		nr = xfs_symlink_hdr_set(mp, ip->i_ino, offset, byte_cnt, bp);
+
+		len -= byte_cnt;
+		offset += byte_cnt;
+
+		xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SYMLINK_BUF);
+		xfs_trans_log_buf(sc->tp, bp, 0, nr - 1);
+		xfs_trans_brelse(sc->tp, bp);
+	}
+	if (len != 0) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	/* Roll transaction, release buffers. */
+	error = xfs_trans_roll(&sc->tp, ip);
+	if (error)
+		goto out;
+
+	/* Size set correctly? */
+	len = i_size_read(VFS_I(ip));
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	error = xfs_readlink(ip, sc->buf);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		goto out;
+
+	/*
+	 * Figure out the new target length.  We can't handle zero-length
+	 * symlinks, so make sure that we don't write that out.
+	 */
+	newlen = strnlen(sc->buf, MAXPATHLEN);
+	if (newlen == 0) {
+		*((char *)sc->buf) = '/';
+		newlen = 1;
+	}
+
+	if (len > newlen)
+		error = xfs_repair_symlink_rewrite(&sc->tp, ip, sc->buf,
+				newlen);
+out:
+	return error;
+}

