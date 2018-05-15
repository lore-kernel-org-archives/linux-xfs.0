Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37260 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752366AbeEOWfU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 18:35:20 -0400
Subject: [PATCH 15/22] xfs: repair inode records
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 15 May 2018 15:35:16 -0700
Message-ID: <152642371638.1556.1181729356027438664.stgit@magnolia>
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

Try to reinitialize corrupt inodes, or clear the reflink flag
if it's not needed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile             |    1 
 fs/xfs/scrub/inode_repair.c |  392 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h       |    2 
 fs/xfs/scrub/scrub.c        |    2 
 4 files changed, 396 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/inode_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 36ad73145c25..b0f25bf07207 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -177,6 +177,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
 				   ialloc_repair.o \
+				   inode_repair.o \
 				   refcount_repair.o \
 				   repair.o \
 				   rmap_repair.o \
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
new file mode 100644
index 000000000000..90208a58a1d1
--- /dev/null
+++ b/fs/xfs/scrub/inode_repair.c
@@ -0,0 +1,392 @@
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
+#include "xfs_icache.h"
+#include "xfs_inode_buf.h"
+#include "xfs_inode_fork.h"
+#include "xfs_ialloc.h"
+#include "xfs_da_format.h"
+#include "xfs_reflink.h"
+#include "xfs_rmap.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_dir2.h"
+#include "xfs_quota_defs.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/* Make sure this buffer can pass the inode buffer verifier. */
+STATIC void
+xfs_repair_inode_buf(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_trans		*tp = sc->tp;
+	struct xfs_dinode		*dip;
+	xfs_agnumber_t			agno;
+	xfs_agino_t			agino;
+	int				ioff;
+	int				i;
+	int				ni;
+	int				di_ok;
+	bool				unlinked_ok;
+
+	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
+	agno = xfs_daddr_to_agno(mp, XFS_BUF_ADDR(bp));
+	for (i = 0; i < ni; i++) {
+		ioff = i << mp->m_sb.sb_inodelog;
+		dip = xfs_buf_offset(bp, ioff);
+		agino = be32_to_cpu(dip->di_next_unlinked);
+		unlinked_ok = (agino == NULLAGINO ||
+			       xfs_verify_agino(sc->mp, agno, agino));
+		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
+			xfs_dinode_good_version(mp, dip->di_version);
+		if (di_ok && unlinked_ok)
+			continue;
+		dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+		dip->di_version = 3;
+		if (!unlinked_ok)
+			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
+		xfs_dinode_calc_crc(mp, dip);
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
+		xfs_trans_log_buf(tp, bp, ioff, ioff + sizeof(*dip) - 1);
+	}
+}
+
+/* Inode didn't pass verifiers, so fix the raw buffer and retry iget. */
+STATIC int
+xfs_repair_inode_core(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_imap			imap;
+	struct xfs_buf			*bp;
+	struct xfs_dinode		*dip;
+	xfs_ino_t			ino;
+	uint64_t			flags2;
+	uint16_t			flags;
+	uint16_t			mode;
+	int				error;
+
+	/* Map & read inode. */
+	ino = sc->sm->sm_ino;
+	error = xfs_imap(sc->mp, sc->tp, ino, &imap, XFS_IGET_UNTRUSTED);
+	if (error)
+		return error;
+
+	error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
+			imap.im_blkno, imap.im_len, XBF_UNMAPPED, &bp, NULL);
+	if (error)
+		return error;
+
+	/* Make sure we can pass the inode buffer verifier. */
+	xfs_repair_inode_buf(sc, bp);
+	bp->b_ops = &xfs_inode_buf_ops;
+
+	/* Fix everything the verifier will complain about. */
+	dip = xfs_buf_offset(bp, imap.im_boffset);
+	mode = be16_to_cpu(dip->di_mode);
+	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN) {
+		/* bad mode, so we set it to a file that only root can read */
+		mode = S_IFREG;
+		dip->di_mode = cpu_to_be16(mode);
+		dip->di_uid = 0;
+		dip->di_gid = 0;
+	}
+	dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+	if (!xfs_dinode_good_version(sc->mp, dip->di_version))
+		dip->di_version = 3;
+	dip->di_ino = cpu_to_be64(ino);
+	uuid_copy(&dip->di_uuid, &sc->mp->m_sb.sb_meta_uuid);
+	flags = be16_to_cpu(dip->di_flags);
+	flags2 = be64_to_cpu(dip->di_flags2);
+	if (xfs_sb_version_hasreflink(&sc->mp->m_sb) && S_ISREG(mode))
+		flags2 |= XFS_DIFLAG2_REFLINK;
+	else
+		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
+	if (flags & XFS_DIFLAG_REALTIME)
+		flags2 &= ~XFS_DIFLAG2_REFLINK;
+	if (flags2 & XFS_DIFLAG2_REFLINK)
+		flags2 &= ~XFS_DIFLAG2_DAX;
+	dip->di_flags = cpu_to_be16(flags);
+	dip->di_flags2 = cpu_to_be64(flags2);
+	dip->di_gen = cpu_to_be32(sc->sm->sm_gen);
+	if (be64_to_cpu(dip->di_size) & (1ULL << 63))
+		dip->di_size = cpu_to_be64((1ULL << 63) - 1);
+
+	/* Write out the inode... */
+	xfs_dinode_calc_crc(sc->mp, dip);
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_DINO_BUF);
+	xfs_trans_log_buf(sc->tp, bp, imap.im_boffset,
+			imap.im_boffset + sc->mp->m_sb.sb_inodesize - 1);
+	error = xfs_trans_commit(sc->tp);
+	if (error)
+		return error;
+	sc->tp = NULL;
+
+	/* ...and reload it? */
+	error = xfs_iget(sc->mp, sc->tp, ino,
+			XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE, 0, &sc->ip);
+	if (error)
+		return error;
+	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	xfs_ilock(sc->ip, sc->ilock_flags);
+	error = xfs_scrub_trans_alloc(sc, 0);
+	if (error)
+		return error;
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+
+	return 0;
+}
+
+/* Fix di_extsize hint. */
+STATIC void
+xfs_repair_inode_extsize(
+	struct xfs_scrub_context	*sc)
+{
+	xfs_failaddr_t			fa;
+
+	fa = xfs_inode_validate_extsize(sc->mp, sc->ip->i_d.di_extsize,
+			VFS_I(sc->ip)->i_mode, sc->ip->i_d.di_flags);
+	if (!fa)
+		return;
+
+	sc->ip->i_d.di_extsize = 0;
+	sc->ip->i_d.di_flags &= ~(XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT);
+}
+
+/* Fix di_cowextsize hint. */
+STATIC void
+xfs_repair_inode_cowextsize(
+	struct xfs_scrub_context	*sc)
+{
+	xfs_failaddr_t			fa;
+
+	if (sc->ip->i_d.di_version < 3)
+		return;
+
+	fa = xfs_inode_validate_cowextsize(sc->mp, sc->ip->i_d.di_cowextsize,
+			VFS_I(sc->ip)->i_mode, sc->ip->i_d.di_flags,
+			sc->ip->i_d.di_flags2);
+	if (!fa)
+		return;
+
+	sc->ip->i_d.di_cowextsize = 0;
+	sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+}
+
+/* Fix inode flags. */
+STATIC void
+xfs_repair_inode_flags(
+	struct xfs_scrub_context	*sc)
+{
+	uint16_t			mode;
+
+	mode = VFS_I(sc->ip)->i_mode;
+
+	if (sc->ip->i_d.di_flags & ~XFS_DIFLAG_ANY)
+		sc->ip->i_d.di_flags &= ~XFS_DIFLAG_ANY;
+
+	if (sc->ip->i_ino == sc->mp->m_sb.sb_rbmino)
+		sc->ip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
+	else
+		sc->ip->i_d.di_flags &= ~XFS_DIFLAG_NEWRTBM;
+
+	if (!S_ISDIR(mode))
+		sc->ip->i_d.di_flags &= ~(XFS_DIFLAG_RTINHERIT |
+					  XFS_DIFLAG_EXTSZINHERIT |
+					  XFS_DIFLAG_PROJINHERIT |
+					  XFS_DIFLAG_NOSYMLINKS);
+	if (!S_ISREG(mode))
+		sc->ip->i_d.di_flags &= ~(XFS_DIFLAG_REALTIME |
+					  XFS_DIFLAG_EXTSIZE);
+
+	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+		sc->ip->i_d.di_flags &= ~XFS_DIFLAG_FILESTREAM;
+}
+
+/* Fix inode flags2 */
+STATIC void
+xfs_repair_inode_flags2(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	uint16_t			mode;
+
+	if (sc->ip->i_d.di_version < 3)
+		return;
+
+	mode = VFS_I(sc->ip)->i_mode;
+
+	if (sc->ip->i_d.di_flags2 & ~XFS_DIFLAG2_ANY)
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_ANY;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb) ||
+	    !S_ISREG(mode))
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+
+	if (!(S_ISREG(mode) || S_ISDIR(mode)))
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_DAX;
+
+	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+
+	if (sc->ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_DAX;
+}
+
+/* Repair an inode's fields. */
+int
+xfs_repair_inode(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_inode		*ip;
+	xfs_filblks_t			count;
+	xfs_filblks_t			acount;
+	xfs_extnum_t			nextents;
+	uint16_t			flags;
+	int				error = 0;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	/* Skip inode core repair if w're here only for preening. */
+	if (sc->ip &&
+	    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_PREEN) &&
+	    !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT) &&
+	    !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)) {
+		xfs_trans_ijoin(sc->tp, sc->ip, 0);
+		goto preen_only;
+	}
+
+	if (!sc->ip) {
+		error = xfs_repair_inode_core(sc);
+		if (error)
+			goto out;
+		if (XFS_IS_UQUOTA_ON(mp))
+			xfs_repair_force_quotacheck(sc, XFS_DQ_USER);
+		if (XFS_IS_GQUOTA_ON(mp))
+			xfs_repair_force_quotacheck(sc, XFS_DQ_GROUP);
+		if (XFS_IS_PQUOTA_ON(mp))
+			xfs_repair_force_quotacheck(sc, XFS_DQ_PROJ);
+	}
+	ASSERT(sc->ip);
+
+	ip = sc->ip;
+	xfs_trans_ijoin(sc->tp, ip, 0);
+
+	/* di_[acm]time.nsec */
+	if ((unsigned long)VFS_I(ip)->i_atime.tv_nsec >= NSEC_PER_SEC)
+		VFS_I(ip)->i_atime.tv_nsec = 0;
+	if ((unsigned long)VFS_I(ip)->i_mtime.tv_nsec >= NSEC_PER_SEC)
+		VFS_I(ip)->i_mtime.tv_nsec = 0;
+	if ((unsigned long)VFS_I(ip)->i_ctime.tv_nsec >= NSEC_PER_SEC)
+		VFS_I(ip)->i_ctime.tv_nsec = 0;
+	if (ip->i_d.di_version > 2 &&
+	    (unsigned long)ip->i_d.di_crtime.t_nsec >= NSEC_PER_SEC)
+		ip->i_d.di_crtime.t_nsec = 0;
+
+	/* di_size */
+	if (!S_ISDIR(VFS_I(ip)->i_mode) && !S_ISREG(VFS_I(ip)->i_mode) &&
+	    !S_ISLNK(VFS_I(ip)->i_mode)) {
+		i_size_write(VFS_I(ip), 0);
+		ip->i_d.di_size = 0;
+	}
+
+	/* di_flags */
+	flags = ip->i_d.di_flags;
+	if ((flags & XFS_DIFLAG_IMMUTABLE) && (flags & XFS_DIFLAG_APPEND))
+		flags &= ~XFS_DIFLAG_APPEND;
+
+	if ((flags & XFS_DIFLAG_FILESTREAM) && (flags & XFS_DIFLAG_REALTIME))
+		flags &= ~XFS_DIFLAG_FILESTREAM;
+	ip->i_d.di_flags = flags;
+
+	/* di_nblocks/di_nextents/di_anextents */
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
+			&nextents, &count);
+	if (error)
+		goto out;
+	ip->i_d.di_nextents = nextents;
+
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
+			&nextents, &acount);
+	if (error)
+		goto out;
+	ip->i_d.di_anextents = nextents;
+
+	ip->i_d.di_nblocks = count + acount;
+	if (ip->i_d.di_anextents != 0 && ip->i_d.di_forkoff == 0)
+		ip->i_d.di_anextents = 0;
+
+	/* Invalid uid/gid? */
+	if (ip->i_d.di_uid == -1U) {
+		ip->i_d.di_uid = 0;
+		VFS_I(ip)->i_mode &= ~(S_ISUID | S_ISGID);
+		if (XFS_IS_UQUOTA_ON(mp))
+			xfs_repair_force_quotacheck(sc, XFS_DQ_USER);
+	}
+	if (ip->i_d.di_gid == -1U) {
+		ip->i_d.di_gid = 0;
+		VFS_I(ip)->i_mode &= ~(S_ISUID | S_ISGID);
+		if (XFS_IS_GQUOTA_ON(mp))
+			xfs_repair_force_quotacheck(sc, XFS_DQ_GROUP);
+	}
+
+	/* Invalid flags? */
+	xfs_repair_inode_flags(sc);
+	xfs_repair_inode_flags2(sc);
+
+	/* Invalid extent size hints? */
+	xfs_repair_inode_extsize(sc);
+	xfs_repair_inode_cowextsize(sc);
+
+	/* Commit inode core changes. */
+	xfs_trans_log_inode(sc->tp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_roll_inode(&sc->tp, ip);
+	if (error)
+		goto out;
+
+preen_only:
+	/* Inode must be _trans_ijoin'd here */
+	if (xfs_is_reflink_inode(sc->ip))
+		return xfs_reflink_clear_inode_flag(sc->ip, &sc->tp);
+
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index d663fc4c464d..8d13986ae824 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -116,6 +116,7 @@ int xfs_repair_allocbt(struct xfs_scrub_context *sc);
 int xfs_repair_iallocbt(struct xfs_scrub_context *sc);
 int xfs_repair_rmapbt(struct xfs_scrub_context *sc);
 int xfs_repair_refcountbt(struct xfs_scrub_context *sc);
+int xfs_repair_inode(struct xfs_scrub_context *sc);
 
 #else
 
@@ -172,6 +173,7 @@ static inline int xfs_repair_rmapbt_setup(
 #define xfs_repair_iallocbt		xfs_repair_notsupported
 #define xfs_repair_rmapbt		xfs_repair_notsupported
 #define xfs_repair_refcountbt		xfs_repair_notsupported
+#define xfs_repair_inode		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index aa35d0384d26..d9b1511cb0d3 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -289,7 +289,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_inode,
 		.scrub	= xfs_scrub_inode,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_inode,
 	},
 	[XFS_SCRUB_TYPE_BMBTD] = {	/* inode data fork */
 		.type	= ST_INODE,

