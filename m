Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37440 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbeEOWfj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 18:35:39 -0400
Subject: [PATCH 18/22] xfs: repair damaged symlinks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 15 May 2018 15:35:35 -0700
Message-ID: <152642373558.1556.1631904020787783735.stgit@magnolia>
In-Reply-To: <152642361893.1556.9335169821674946249.stgit@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Repair inconsistent symbolic link data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile               |    1 
 fs/xfs/scrub/repair.h         |    2 
 fs/xfs/scrub/scrub.c          |    2 
 fs/xfs/scrub/symlink.c        |    2 
 fs/xfs/scrub/symlink_repair.c |  284 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 289 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/symlink_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 653da1fe6b26..5e336892f21f 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -182,6 +182,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   refcount_repair.o \
 				   repair.o \
 				   rmap_repair.o \
+				   symlink_repair.o \
 				   )
 endif
 endif
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index af5b8bf17858..4c48da0dfc02 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -119,6 +119,7 @@ int xfs_repair_refcountbt(struct xfs_scrub_context *sc);
 int xfs_repair_inode(struct xfs_scrub_context *sc);
 int xfs_repair_bmap_data(struct xfs_scrub_context *sc);
 int xfs_repair_bmap_attr(struct xfs_scrub_context *sc);
+int xfs_repair_symlink(struct xfs_scrub_context *sc);
 
 #else
 
@@ -178,6 +179,7 @@ static inline int xfs_repair_rmapbt_setup(
 #define xfs_repair_inode		xfs_repair_notsupported
 #define xfs_repair_bmap_data		xfs_repair_notsupported
 #define xfs_repair_bmap_attr		xfs_repair_notsupported
+#define xfs_repair_symlink		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index c45be77c6c16..e22b48e0b2f3 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -325,7 +325,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_symlink,
 		.scrub	= xfs_scrub_symlink,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_symlink,
 	},
 	[XFS_SCRUB_TYPE_PARENT] = {	/* parent pointers */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 3aa3d60f7c16..a370aad5233f 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -48,7 +48,7 @@ xfs_scrub_setup_symlink(
 	if (!sc->buf)
 		return -ENOMEM;
 
-	return xfs_scrub_setup_inode_contents(sc, ip, 0);
+	return xfs_scrub_setup_inode_contents(sc, ip, XFS_SYMLINK_MAPS);
 }
 
 /* Symbolic links. */
diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
new file mode 100644
index 000000000000..a58eb96dd448
--- /dev/null
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -0,0 +1,284 @@
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_inode_fork.h"
+#include "xfs_symlink.h"
+#include "xfs_bmap.h"
+#include "xfs_quota.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
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
+	error = xfs_defer_finish(tpp, &dfops);
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
+/* Fix everything that fails the verifiers in the remote blocks. */
+STATIC int
+xfs_repair_symlink_fix_remotes(
+	struct xfs_scrub_context	*sc,
+	loff_t				len)
+{
+	struct xfs_bmbt_irec		mval[XFS_SYMLINK_MAPS];
+	struct xfs_buf			*bp;
+	xfs_filblks_t			fsblocks;
+	xfs_daddr_t			d;
+	loff_t				offset;
+	unsigned int			byte_cnt;
+	int				n;
+	int				nmaps = XFS_SYMLINK_MAPS;
+	int				nr;
+	int				error;
+
+	fsblocks = xfs_symlink_blocks(sc->mp, len);
+	error = xfs_bmapi_read(sc->ip, 0, fsblocks, mval, &nmaps, 0);
+	if (error)
+		return error;
+
+	offset = 0;
+	for (n = 0; n < nmaps; n++) {
+		d = XFS_FSB_TO_DADDR(sc->mp, mval[n].br_startblock);
+		byte_cnt = XFS_FSB_TO_B(sc->mp, mval[n].br_blockcount);
+
+		error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
+				d, BTOBB(byte_cnt), 0, &bp, NULL);
+		if (error)
+			return error;
+		bp->b_ops = &xfs_symlink_buf_ops;
+
+		byte_cnt = XFS_SYMLINK_BUF_SPACE(sc->mp, byte_cnt);
+		if (len < byte_cnt)
+			byte_cnt = len;
+
+		nr = xfs_symlink_hdr_set(sc->mp, sc->ip->i_ino, offset,
+				byte_cnt, bp);
+
+		len -= byte_cnt;
+		offset += byte_cnt;
+
+		xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SYMLINK_BUF);
+		xfs_trans_log_buf(sc->tp, bp, 0, nr - 1);
+		xfs_trans_brelse(sc->tp, bp);
+	}
+	if (len != 0)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+int
+xfs_repair_symlink(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_ifork		*ifp;
+	loff_t				len;
+	size_t				newlen;
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
+			/* Zero length symlink becomes a root symlink. */
+			ifp->if_u1.if_data = kmem_alloc(4, KM_SLEEP);
+			snprintf(ifp->if_u1.if_data, 4, "/");
+			newlen = 1;
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
+	error = xfs_repair_symlink_fix_remotes(sc, len);
+	if (error)
+		goto out;
+
+	/* Roll transaction, release buffers. */
+	error = xfs_trans_roll_inode(&sc->tp, ip);
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
+	newlen = strnlen(sc->buf, XFS_SYMLINK_MAXLEN);
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

