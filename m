Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57924 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752251AbeFXTYy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jun 2018 15:24:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5OJOVK2119923
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:54 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2jt7mp8hpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:53 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJOres030139
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:53 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJOqZj013264
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:52 GMT
Subject: [PATCH 13/21] xfs: repair inode records
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 24 Jun 2018 12:24:51 -0700
Message-ID: <152986829144.3155.13577483407162701849.stgit@magnolia>
In-Reply-To: <152986820984.3155.16417868536016544528.stgit@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Try to reinitialize corrupt inodes, or clear the reflink flag
if it's not needed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile             |    1 
 fs/xfs/scrub/inode_repair.c |  483 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h       |    2 
 fs/xfs/scrub/scrub.c        |    2 
 4 files changed, 487 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/inode_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index eeb03b9f30f6..f47f0fe0e70a 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -166,6 +166,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
 				   ialloc_repair.o \
+				   inode_repair.o \
 				   refcount_repair.o \
 				   repair.o \
 				   rmap_repair.o \
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
new file mode 100644
index 000000000000..4ac43c1b1eb0
--- /dev/null
+++ b/fs/xfs/scrub/inode_repair.c
@@ -0,0 +1,483 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
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
+/* Reinitialize things that never change in an inode. */
+STATIC void
+xfs_repair_inode_header(
+	struct xfs_scrub_context	*sc,
+	struct xfs_dinode		*dip)
+{
+	dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+	if (!xfs_dinode_good_version(sc->mp, dip->di_version))
+		dip->di_version = 3;
+	dip->di_ino = cpu_to_be64(sc->sm->sm_ino);
+	uuid_copy(&dip->di_uuid, &sc->mp->m_sb.sb_meta_uuid);
+	dip->di_gen = cpu_to_be32(sc->sm->sm_gen);
+}
+
+/*
+ * Turn di_mode into /something/ recognizable.
+ *
+ * XXX: Ideally we'd try to read data block 0 to see if it's a directory.
+ */
+STATIC void
+xfs_repair_inode_mode(
+	struct xfs_dinode	*dip)
+{
+	uint16_t		mode;
+
+	mode = be16_to_cpu(dip->di_mode);
+	if (mode == 0 || xfs_mode_to_ftype(mode) != XFS_DIR3_FT_UNKNOWN)
+		return;
+
+	/* bad mode, so we set it to a file that only root can read */
+	mode = S_IFREG;
+	dip->di_mode = cpu_to_be16(mode);
+	dip->di_uid = 0;
+	dip->di_gid = 0;
+}
+
+/* Fix any conflicting flags that the verifiers complain about. */
+STATIC void
+xfs_repair_inode_flags(
+	struct xfs_scrub_context	*sc,
+	struct xfs_dinode		*dip)
+{
+	struct xfs_mount		*mp = sc->mp;
+	uint64_t			flags2;
+	uint16_t			mode;
+	uint16_t			flags;
+
+	mode = be16_to_cpu(dip->di_mode);
+	flags = be16_to_cpu(dip->di_flags);
+	flags2 = be64_to_cpu(dip->di_flags2);
+
+	if (xfs_sb_version_hasreflink(&mp->m_sb) && S_ISREG(mode))
+		flags2 |= XFS_DIFLAG2_REFLINK;
+	else
+		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
+	if (flags & XFS_DIFLAG_REALTIME)
+		flags2 &= ~XFS_DIFLAG2_REFLINK;
+	if (flags2 & XFS_DIFLAG2_REFLINK)
+		flags2 &= ~XFS_DIFLAG2_DAX;
+	dip->di_flags = cpu_to_be16(flags);
+	dip->di_flags2 = cpu_to_be64(flags2);
+}
+
+/* Make sure we don't have a garbage file size. */
+STATIC void
+xfs_repair_inode_size(
+	struct xfs_dinode	*dip)
+{
+	uint64_t		size;
+	uint16_t		mode;
+
+	mode = be16_to_cpu(dip->di_mode);
+	size = be64_to_cpu(dip->di_size);
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		/* di_size can't be nonzero for special files */
+		dip->di_size = 0;
+		break;
+	case S_IFREG:
+		/* Regular files can't be larger than 2^63-1 bytes. */
+		dip->di_size = cpu_to_be64(size & ~(1ULL << 63));
+		break;
+	case S_IFLNK:
+		/* Catch over- or under-sized symlinks. */
+		if (size > XFS_SYMLINK_MAXLEN)
+			dip->di_size = cpu_to_be64(XFS_SYMLINK_MAXLEN);
+		else if (size == 0)
+			dip->di_size = cpu_to_be64(1);
+		break;
+	case S_IFDIR:
+		/* Directories can't have a size larger than 32G. */
+		if (size > XFS_DIR2_SPACE_SIZE)
+			dip->di_size = cpu_to_be64(XFS_DIR2_SPACE_SIZE);
+		else if (size == 0)
+			dip->di_size = cpu_to_be64(1);
+		break;
+	}
+}
+
+/* Fix extent size hints. */
+STATIC void
+xfs_repair_inode_extsize_hints(
+	struct xfs_scrub_context	*sc,
+	struct xfs_dinode		*dip)
+{
+	struct xfs_mount		*mp = sc->mp;
+	uint64_t			flags2;
+	uint16_t			flags;
+	uint16_t			mode;
+	xfs_failaddr_t			fa;
+
+	mode = be16_to_cpu(dip->di_mode);
+	flags = be16_to_cpu(dip->di_flags);
+	flags2 = be64_to_cpu(dip->di_flags2);
+
+	fa = xfs_inode_validate_extsize(mp, be32_to_cpu(dip->di_extsize),
+			mode, flags);
+	if (fa) {
+		dip->di_extsize = 0;
+		dip->di_flags &= ~cpu_to_be16(XFS_DIFLAG_EXTSIZE |
+					      XFS_DIFLAG_EXTSZINHERIT);
+	}
+
+	if (dip->di_version < 3)
+		return;
+
+	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
+			mode, flags, flags2);
+	if (fa) {
+		dip->di_cowextsize = 0;
+		dip->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
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
+	xfs_repair_inode_header(sc, dip);
+	xfs_repair_inode_mode(dip);
+	xfs_repair_inode_flags(sc, dip);
+	xfs_repair_inode_size(dip);
+	xfs_repair_inode_extsize_hints(sc, dip);
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
+/* Fix everything xfs_dinode_verify cares about. */
+STATIC int
+xfs_repair_inode_problems(
+	struct xfs_scrub_context	*sc)
+{
+	int				error;
+
+	error = xfs_repair_inode_core(sc);
+	if (error)
+		return error;
+
+	/* We had to fix a totally busted inode, schedule quotacheck. */
+	if (XFS_IS_UQUOTA_ON(sc->mp))
+		xfs_repair_force_quotacheck(sc, XFS_DQ_USER);
+	if (XFS_IS_GQUOTA_ON(sc->mp))
+		xfs_repair_force_quotacheck(sc, XFS_DQ_GROUP);
+	if (XFS_IS_PQUOTA_ON(sc->mp))
+		xfs_repair_force_quotacheck(sc, XFS_DQ_PROJ);
+
+	return 0;
+}
+
+/*
+ * Fix problems that the verifiers don't care about.  In general these are
+ * errors that don't cause problems elsewhere in the kernel that we can easily
+ * detect, so we don't check them all that rigorously.
+ */
+
+/* Make sure block and extent counts are ok. */
+STATIC int
+xfs_repair_inode_unchecked_blockcounts(
+	struct xfs_scrub_context	*sc)
+{
+	xfs_filblks_t			count;
+	xfs_filblks_t			acount;
+	xfs_extnum_t			nextents;
+	int				error;
+
+	/* di_nblocks/di_nextents/di_anextents don't match up? */
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
+			&nextents, &count);
+	if (error)
+		return error;
+	sc->ip->i_d.di_nextents = nextents;
+
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
+			&nextents, &acount);
+	if (error)
+		return error;
+	sc->ip->i_d.di_anextents = nextents;
+
+	sc->ip->i_d.di_nblocks = count + acount;
+	if (sc->ip->i_d.di_anextents != 0 && sc->ip->i_d.di_forkoff == 0)
+		sc->ip->i_d.di_anextents = 0;
+	return 0;
+}
+
+/* Check for invalid uid/gid.  Note that a -1U projid is allowed. */
+STATIC void
+xfs_repair_inode_unchecked_ids(
+	struct xfs_scrub_context	*sc)
+{
+	if (sc->ip->i_d.di_uid == -1U) {
+		sc->ip->i_d.di_uid = 0;
+		VFS_I(sc->ip)->i_mode &= ~(S_ISUID | S_ISGID);
+		if (XFS_IS_UQUOTA_ON(sc->mp))
+			xfs_repair_force_quotacheck(sc, XFS_DQ_USER);
+	}
+
+	if (sc->ip->i_d.di_gid == -1U) {
+		sc->ip->i_d.di_gid = 0;
+		VFS_I(sc->ip)->i_mode &= ~(S_ISUID | S_ISGID);
+		if (XFS_IS_GQUOTA_ON(sc->mp))
+			xfs_repair_force_quotacheck(sc, XFS_DQ_GROUP);
+	}
+}
+
+/* Nanosecond counters can't have more than 1 billion. */
+STATIC void
+xfs_repair_inode_unchecked_timestamps(
+	struct xfs_inode		*ip)
+{
+	if ((unsigned long)VFS_I(ip)->i_atime.tv_nsec >= NSEC_PER_SEC)
+		VFS_I(ip)->i_atime.tv_nsec = 0;
+	if ((unsigned long)VFS_I(ip)->i_mtime.tv_nsec >= NSEC_PER_SEC)
+		VFS_I(ip)->i_mtime.tv_nsec = 0;
+	if ((unsigned long)VFS_I(ip)->i_ctime.tv_nsec >= NSEC_PER_SEC)
+		VFS_I(ip)->i_ctime.tv_nsec = 0;
+	if (ip->i_d.di_version > 2 &&
+	    (unsigned long)ip->i_d.di_crtime.t_nsec >= NSEC_PER_SEC)
+		ip->i_d.di_crtime.t_nsec = 0;
+}
+
+/* Fix inode flags that don't make sense together. */
+STATIC void
+xfs_repair_inode_unchecked_flags(
+	struct xfs_scrub_context	*sc)
+{
+	uint16_t			mode;
+
+	mode = VFS_I(sc->ip)->i_mode;
+
+	/* Clear junk flags */
+	if (sc->ip->i_d.di_flags & ~XFS_DIFLAG_ANY)
+		sc->ip->i_d.di_flags &= ~XFS_DIFLAG_ANY;
+
+	/* NEWRTBM only applies to realtime bitmaps */
+	if (sc->ip->i_ino == sc->mp->m_sb.sb_rbmino)
+		sc->ip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
+	else
+		sc->ip->i_d.di_flags &= ~XFS_DIFLAG_NEWRTBM;
+
+	/* These only make sense for directories. */
+	if (!S_ISDIR(mode))
+		sc->ip->i_d.di_flags &= ~(XFS_DIFLAG_RTINHERIT |
+					  XFS_DIFLAG_EXTSZINHERIT |
+					  XFS_DIFLAG_PROJINHERIT |
+					  XFS_DIFLAG_NOSYMLINKS);
+
+	/* These only make sense for files. */
+	if (!S_ISREG(mode))
+		sc->ip->i_d.di_flags &= ~(XFS_DIFLAG_REALTIME |
+					  XFS_DIFLAG_EXTSIZE);
+
+	/* These only make sense for non-rt files. */
+	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+		sc->ip->i_d.di_flags &= ~XFS_DIFLAG_FILESTREAM;
+
+	/* Immutable and append only?  Drop the append. */
+	if ((sc->ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE) &&
+	    (sc->ip->i_d.di_flags & XFS_DIFLAG_APPEND))
+		sc->ip->i_d.di_flags &= ~XFS_DIFLAG_APPEND;
+
+	if (sc->ip->i_d.di_version < 3)
+		return;
+
+	/* Clear junk flags. */
+	if (sc->ip->i_d.di_flags2 & ~XFS_DIFLAG2_ANY)
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_ANY;
+
+	/* No reflink flag unless we support it and it's a file. */
+	if (!xfs_sb_version_hasreflink(&sc->mp->m_sb) ||
+	    !S_ISREG(mode))
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+
+	/* DAX only applies to files and dirs. */
+	if (!(S_ISREG(mode) || S_ISDIR(mode)))
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_DAX;
+
+	/* No reflink files on the realtime device. */
+	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+
+	/* No mixing reflink and DAX yet. */
+	if (sc->ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_DAX;
+}
+
+/* Fix any irregularities in an inode that the verifiers don't catch. */
+STATIC int
+xfs_repair_inode_unchecked(
+	struct xfs_scrub_context	*sc)
+{
+	int				error;
+
+	error = xfs_repair_inode_unchecked_blockcounts(sc);
+	if (error)
+		return error;
+	xfs_repair_inode_unchecked_timestamps(sc->ip);
+	xfs_repair_inode_unchecked_flags(sc);
+	xfs_repair_inode_unchecked_ids(sc);
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	return xfs_trans_roll_inode(&sc->tp, sc->ip);
+}
+
+/* Repair an inode's fields. */
+int
+xfs_repair_inode(
+	struct xfs_scrub_context	*sc)
+{
+	int				error = 0;
+
+	/*
+	 * No inode?  That means we failed the _iget verifiers.  Repair all
+	 * the things that the inode verifiers care about, then retry _iget.
+	 */
+	if (!sc->ip) {
+		error = xfs_repair_inode_problems(sc);
+		if (error)
+			goto out;
+	}
+
+	/* By this point we had better have a working incore inode. */
+	ASSERT(sc->ip);
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/* If we found corruption of any kind, try to fix it. */
+	if ((sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT) ||
+	    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)) {
+		error = xfs_repair_inode_unchecked(sc);
+		if (error)
+			goto out;
+	}
+
+	/* See if we can clear the reflink flag. */
+	if (xfs_is_reflink_inode(sc->ip))
+		return xfs_reflink_clear_inode_flag(sc->ip, &sc->tp);
+
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 23c160558892..e3a763540780 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -109,6 +109,7 @@ int xfs_repair_allocbt(struct xfs_scrub_context *sc);
 int xfs_repair_iallocbt(struct xfs_scrub_context *sc);
 int xfs_repair_rmapbt(struct xfs_scrub_context *sc);
 int xfs_repair_refcountbt(struct xfs_scrub_context *sc);
+int xfs_repair_inode(struct xfs_scrub_context *sc);
 
 #else
 
@@ -147,6 +148,7 @@ static inline int xfs_repair_rmapbt_setup(
 #define xfs_repair_iallocbt		xfs_repair_notsupported
 #define xfs_repair_rmapbt		xfs_repair_notsupported
 #define xfs_repair_refcountbt		xfs_repair_notsupported
+#define xfs_repair_inode		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index e4801fb6e632..77cbb955d8a8 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -293,7 +293,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_inode,
 		.scrub	= xfs_scrub_inode,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_inode,
 	},
 	[XFS_SCRUB_TYPE_BMBTD] = {	/* inode data fork */
 		.type	= ST_INODE,

