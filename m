Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38038 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757794AbdJQANG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 20:13:06 -0400
Date: Mon, 16 Oct 2017 17:13:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 21/30] xfs: scrub inodes
Message-ID: <20171017001300.GW4703@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777258004.1724.14107466871314594061.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777258004.1724.14107466871314594061.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

Scrub the fields within an inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix illegible logic, enhance comments
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    3 
 fs/xfs/scrub/common.c  |   54 ++++
 fs/xfs/scrub/common.h  |    3 
 fs/xfs/scrub/inode.c   |  605 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |   18 +
 fs/xfs/scrub/scrub.h   |    2 
 fs/xfs/xfs_ioctl.c     |    4 
 8 files changed, 687 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/inode.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a7c5752..28e14b7 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -151,6 +151,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   btree.o \
 				   common.o \
 				   ialloc.o \
+				   inode.o \
 				   refcount.o \
 				   rmap.o \
 				   scrub.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b3f992c..f8463e0 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -494,9 +494,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_FINOBT	8	/* free inode btree */
 #define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
 #define XFS_SCRUB_TYPE_REFCNTBT	10	/* reference count btree */
+#define XFS_SCRUB_TYPE_INODE	11	/* inode record */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	11
+#define XFS_SCRUB_TYPE_NR	12
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 39165c3..415c6a9 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -30,6 +30,8 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_itable.h"
 #include "xfs_alloc.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_bmap.h"
@@ -488,3 +490,55 @@ xfs_scrub_checkpoint_log(
 	xfs_ail_push_all_sync(mp->m_ail);
 	return 0;
 }
+
+/*
+ * Given an inode and the scrub control structure, grab either the
+ * inode referenced in the control structure or the inode passed in.
+ * The inode is not locked.
+ */
+int
+xfs_scrub_get_inode(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip_in)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_inode		*ip = NULL;
+	int				error;
+
+	/*
+	 * If userspace passed us an AG number or a generation number
+	 * without an inode number, they haven't got a clue so bail out
+	 * immediately.
+	 */
+	if (sc->sm->sm_agno || (sc->sm->sm_gen && !sc->sm->sm_ino))
+		return -EINVAL;
+
+	/* We want to scan the inode we already had opened. */
+	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino) {
+		sc->ip = ip_in;
+		return 0;
+	}
+
+	/* Look up the inode, see if the generation number matches. */
+	if (xfs_internal_inum(mp, sc->sm->sm_ino))
+		return -ENOENT;
+	error = xfs_iget(mp, NULL, sc->sm->sm_ino,
+			XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE, 0, &ip);
+	if (error == -ENOENT || error == -EINVAL) {
+		/* inode doesn't exist... */
+		return -ENOENT;
+	} else if (error) {
+		trace_xfs_scrub_op_error(sc,
+				XFS_INO_TO_AGNO(mp, sc->sm->sm_ino),
+				XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),
+				error, __return_address);
+		return error;
+	}
+	if (VFS_I(ip)->i_generation != sc->sm->sm_gen) {
+		iput(VFS_I(ip));
+		return -ENOENT;
+	}
+
+	sc->ip = ip;
+	return 0;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 610e956..fcec11e 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -87,6 +87,8 @@ int xfs_scrub_setup_ag_rmapbt(struct xfs_scrub_context *sc,
 			      struct xfs_inode *ip);
 int xfs_scrub_setup_ag_refcountbt(struct xfs_scrub_context *sc,
 				  struct xfs_inode *ip);
+int xfs_scrub_setup_inode(struct xfs_scrub_context *sc,
+			  struct xfs_inode *ip);
 
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
@@ -105,5 +107,6 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 
 int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
 			     struct xfs_inode *ip, bool force_log);
+int xfs_scrub_get_inode(struct xfs_scrub_context *sc, struct xfs_inode *ip_in);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
new file mode 100644
index 0000000..36c144e
--- /dev/null
+++ b/fs/xfs/scrub/inode.c
@@ -0,0 +1,605 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+
+/*
+ * Grab total control of the inode metadata.  It doesn't matter here if
+ * the file data is still changing; exclusive access to the metadata is
+ * the goal.
+ */
+int
+xfs_scrub_setup_inode(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = sc->mp;
+	int				error;
+
+	/*
+	 * Try to get the inode.  If the verifiers fail, we try again
+	 * in raw mode.
+	 */
+	error = xfs_scrub_get_inode(sc, ip);
+	switch (error) {
+	case 0:
+		break;
+	case -EFSCORRUPTED:
+	case -EFSBADCRC:
+		return 0;
+	default:
+		return error;
+	}
+
+	/* Got the inode, lock it and we're ready to go. */
+	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	xfs_ilock(sc->ip, sc->ilock_flags);
+	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+	if (error)
+		goto out;
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+
+out:
+	/* scrub teardown will unlock and release the inode for us */
+	return error;
+}
+
+/* Inode core */
+
+/*
+ * Validate di_extsize hint.
+ *
+ * The rules are documented at xfs_ioctl_setattr_check_extsize().
+ * These functions must be kept in sync with each other.
+ */
+STATIC void
+xfs_scrub_inode_extsize(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	struct xfs_dinode		*dip,
+	xfs_ino_t			ino,
+	uint16_t			mode,
+	uint16_t			flags)
+{
+	struct xfs_mount		*mp = sc->mp;
+	bool				rt_flag;
+	bool				hint_flag;
+	bool				inherit_flag;
+	uint32_t			extsize;
+	uint32_t			extsize_bytes;
+	uint32_t			blocksize_bytes;
+
+	rt_flag = (flags & XFS_DIFLAG_REALTIME);
+	hint_flag = (flags & XFS_DIFLAG_EXTSIZE);
+	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
+	extsize = be32_to_cpu(dip->di_extsize);
+	extsize_bytes = XFS_FSB_TO_B(sc->mp, extsize);
+
+	if (rt_flag)
+		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
+	else
+		blocksize_bytes = mp->m_sb.sb_blocksize;
+
+	if ((hint_flag || inherit_flag) && !(S_ISDIR(mode) || S_ISREG(mode)))
+		goto bad;
+
+	if (hint_flag && !S_ISREG(mode))
+		goto bad;
+
+	if (inherit_flag && !S_ISDIR(mode))
+		goto bad;
+
+	if ((hint_flag || inherit_flag) && extsize == 0)
+		goto bad;
+
+	if (!(hint_flag || inherit_flag) && extsize != 0)
+		goto bad;
+
+	if (extsize_bytes % blocksize_bytes)
+		goto bad;
+
+	if (extsize > MAXEXTLEN)
+		goto bad;
+
+	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
+		goto bad;
+
+	return;
+bad:
+	xfs_scrub_ino_set_corrupt(sc, ino, bp);
+}
+
+/*
+ * Validate di_cowextsize hint.
+ *
+ * The rules are documented at xfs_ioctl_setattr_check_cowextsize().
+ * These functions must be kept in sync with each other.
+ */
+STATIC void
+xfs_scrub_inode_cowextsize(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	struct xfs_dinode		*dip,
+	xfs_ino_t			ino,
+	uint16_t			mode,
+	uint16_t			flags,
+	uint64_t			flags2)
+{
+	struct xfs_mount		*mp = sc->mp;
+	bool				rt_flag;
+	bool				hint_flag;
+	uint32_t			extsize;
+	uint32_t			extsize_bytes;
+
+	rt_flag = (flags & XFS_DIFLAG_REALTIME);
+	hint_flag = (flags2 & XFS_DIFLAG2_COWEXTSIZE);
+	extsize = be32_to_cpu(dip->di_cowextsize);
+	extsize_bytes = XFS_FSB_TO_B(sc->mp, extsize);
+
+	if (hint_flag && !xfs_sb_version_hasreflink(&mp->m_sb))
+		goto bad;
+
+	if (hint_flag && !(S_ISDIR(mode) || S_ISREG(mode)))
+		goto bad;
+
+	if (hint_flag && extsize == 0)
+		goto bad;
+
+	if (!hint_flag && extsize != 0)
+		goto bad;
+
+	if (hint_flag && rt_flag)
+		goto bad;
+
+	if (extsize_bytes % mp->m_sb.sb_blocksize)
+		goto bad;
+
+	if (extsize > MAXEXTLEN)
+		goto bad;
+
+	if (extsize > mp->m_sb.sb_agblocks / 2)
+		goto bad;
+
+	return;
+bad:
+	xfs_scrub_ino_set_corrupt(sc, ino, bp);
+}
+
+/* Make sure the di_flags make sense for the inode. */
+STATIC void
+xfs_scrub_inode_flags(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	struct xfs_dinode		*dip,
+	xfs_ino_t			ino,
+	uint16_t			mode,
+	uint16_t			flags)
+{
+	struct xfs_mount		*mp = sc->mp;
+
+	if (flags & ~XFS_DIFLAG_ANY)
+		goto bad;
+
+	/* rt flags require rt device */
+	if ((flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) &&
+	    !mp->m_rtdev_targp)
+		goto bad;
+
+	/* new rt bitmap flag only valid for rbmino */
+	if ((flags & XFS_DIFLAG_NEWRTBM) && ino != mp->m_sb.sb_rbmino)
+		goto bad;
+
+	/* directory-only flags */
+	if ((flags & (XFS_DIFLAG_RTINHERIT |
+		     XFS_DIFLAG_EXTSZINHERIT |
+		     XFS_DIFLAG_PROJINHERIT |
+		     XFS_DIFLAG_NOSYMLINKS)) &&
+	    !S_ISDIR(mode))
+		goto bad;
+
+	/* file-only flags */
+	if ((flags & (XFS_DIFLAG_REALTIME | FS_XFLAG_EXTSIZE)) &&
+	    !S_ISREG(mode))
+		goto bad;
+
+	/* filestreams and rt make no sense */
+	if ((flags & XFS_DIFLAG_FILESTREAM) && (flags & XFS_DIFLAG_REALTIME))
+		goto bad;
+
+	return;
+bad:
+	xfs_scrub_ino_set_corrupt(sc, ino, bp);
+}
+
+/* Make sure the di_flags2 make sense for the inode. */
+STATIC void
+xfs_scrub_inode_flags2(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	struct xfs_dinode		*dip,
+	xfs_ino_t			ino,
+	uint16_t			mode,
+	uint16_t			flags,
+	uint64_t			flags2)
+{
+	struct xfs_mount		*mp = sc->mp;
+
+	if (flags2 & ~XFS_DIFLAG2_ANY)
+		goto bad;
+
+	/* reflink flag requires reflink feature */
+	if ((flags2 & XFS_DIFLAG2_REFLINK) &&
+	    !xfs_sb_version_hasreflink(&mp->m_sb))
+		goto bad;
+
+	/* cowextsize flag is checked w.r.t. mode separately */
+
+	/* file-only flags */
+	if ((flags2 & (XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK)) &&
+	    !S_ISREG(mode))
+		goto bad;
+
+	/* realtime and reflink make no sense, currently */
+	if ((flags & XFS_DIFLAG_REALTIME) && (flags2 & XFS_DIFLAG2_REFLINK))
+		goto bad;
+
+	/* dax and reflink make no sense, currently */
+	if ((flags2 & XFS_DIFLAG2_DAX) && (flags2 & XFS_DIFLAG2_REFLINK))
+		goto bad;
+
+	return;
+bad:
+	xfs_scrub_ino_set_corrupt(sc, ino, bp);
+}
+
+/* Scrub all the ondisk inode fields. */
+STATIC void
+xfs_scrub_dinode(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	struct xfs_dinode		*dip,
+	xfs_ino_t			ino)
+{
+	struct xfs_mount		*mp = sc->mp;
+	size_t				fork_recs;
+	unsigned long long		isize;
+	uint64_t			flags2;
+	uint32_t			nextents;
+	uint16_t			flags;
+	uint16_t			mode;
+
+	flags = be16_to_cpu(dip->di_flags);
+	if (dip->di_version >= 3)
+		flags2 = be64_to_cpu(dip->di_flags2);
+	else
+		flags2 = 0;
+
+	/* di_mode */
+	mode = be16_to_cpu(dip->di_mode);
+	if (mode & ~(S_IALLUGO | S_IFMT))
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+	/* v1/v2 fields */
+	switch (dip->di_version) {
+	case 1:
+		/*
+		 * We autoconvert v1 inodes into v2 inodes on writeout,
+		 * so just mark this inode for preening.
+		 */
+		xfs_scrub_ino_set_preen(sc, bp);
+		break;
+	case 2:
+	case 3:
+		if (dip->di_onlink != 0)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+		if (dip->di_mode == 0 && sc->ip)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+		if (dip->di_projid_hi != 0 &&
+		    !xfs_sb_version_hasprojid32bit(&mp->m_sb))
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		break;
+	default:
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		return;
+	}
+
+	/*
+	 * di_uid/di_gid -- -1 isn't invalid, but there's no way that
+	 * userspace could have created that.
+	 */
+	if (dip->di_uid == cpu_to_be32(-1U) ||
+	    dip->di_gid == cpu_to_be32(-1U))
+		xfs_scrub_ino_set_warning(sc, bp);
+
+	/* di_format */
+	switch (dip->di_format) {
+	case XFS_DINODE_FMT_DEV:
+		if (!S_ISCHR(mode) && !S_ISBLK(mode) &&
+		    !S_ISFIFO(mode) && !S_ISSOCK(mode))
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+		if (!S_ISDIR(mode) && !S_ISLNK(mode))
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		if (!S_ISREG(mode) && !S_ISDIR(mode) && !S_ISLNK(mode))
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		if (!S_ISREG(mode) && !S_ISDIR(mode))
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		break;
+	case XFS_DINODE_FMT_UUID:
+	default:
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		break;
+	}
+
+	/*
+	 * di_size.  xfs_dinode_verify checks for things that screw up
+	 * the VFS such as the upper bit being set and zero-length
+	 * symlinks/directories, but we can do more here.
+	 */
+	isize = be64_to_cpu(dip->di_size);
+	if (isize & (1ULL << 63))
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+	/* Devices, fifos, and sockets must have zero size */
+	if (!S_ISDIR(mode) && !S_ISREG(mode) && !S_ISLNK(mode) && isize != 0)
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+	/* Directories can't be larger than the data section size (32G) */
+	if (S_ISDIR(mode) && (isize == 0 || isize >= XFS_DIR2_SPACE_SIZE))
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+	/* Symlinks can't be larger than SYMLINK_MAXLEN */
+	if (S_ISLNK(mode) && (isize == 0 || isize >= XFS_SYMLINK_MAXLEN))
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+	/*
+	 * Warn if the running kernel can't handle the kinds of offsets
+	 * needed to deal with the file size.  In other words, if the
+	 * pagecache can't cache all the blocks in this file due to
+	 * overly large offsets, flag the inode for admin review.
+	 */
+	if (isize >= mp->m_super->s_maxbytes)
+		xfs_scrub_ino_set_warning(sc, bp);
+
+	/* di_nblocks */
+	if (flags2 & XFS_DIFLAG2_REFLINK) {
+		; /* nblocks can exceed dblocks */
+	} else if (flags & XFS_DIFLAG_REALTIME) {
+		/*
+		 * nblocks is the sum of data extents (in the rtdev),
+		 * attr extents (in the datadev), and both forks' bmbt
+		 * blocks (in the datadev).  This clumsy check is the
+		 * best we can do without cross-referencing with the
+		 * inode forks.
+		 */
+		if (be64_to_cpu(dip->di_nblocks) >=
+		    mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	} else {
+		if (be64_to_cpu(dip->di_nblocks) >= mp->m_sb.sb_dblocks)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	}
+
+	xfs_scrub_inode_flags(sc, bp, dip, ino, mode, flags);
+
+	xfs_scrub_inode_extsize(sc, bp, dip, ino, mode, flags);
+
+	/* di_nextents */
+	nextents = be32_to_cpu(dip->di_nextents);
+	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
+	switch (dip->di_format) {
+	case XFS_DINODE_FMT_EXTENTS:
+		if (nextents > fork_recs)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		if (nextents <= fork_recs)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		break;
+	default:
+		if (nextents != 0)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		break;
+	}
+
+	/* di_forkoff */
+	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+	/* di_aformat */
+	if (dip->di_aformat != XFS_DINODE_FMT_LOCAL &&
+	    dip->di_aformat != XFS_DINODE_FMT_EXTENTS &&
+	    dip->di_aformat != XFS_DINODE_FMT_BTREE)
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+	/* di_anextents */
+	nextents = be16_to_cpu(dip->di_anextents);
+	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
+	switch (dip->di_aformat) {
+	case XFS_DINODE_FMT_EXTENTS:
+		if (nextents > fork_recs)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		if (nextents <= fork_recs)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		break;
+	default:
+		if (nextents != 0)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	}
+
+	if (dip->di_version >= 3) {
+		xfs_scrub_inode_flags2(sc, bp, dip, ino, mode, flags, flags2);
+		xfs_scrub_inode_cowextsize(sc, bp, dip, ino, mode, flags,
+				flags2);
+	}
+}
+
+/* Map and read a raw inode. */
+STATIC int
+xfs_scrub_inode_map_raw(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino,
+	struct xfs_buf			**bpp,
+	struct xfs_dinode		**dipp)
+{
+	struct xfs_imap			imap;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_buf			*bp;
+	struct xfs_dinode		*dip;
+	int				error;
+
+	error = xfs_imap(mp, sc->tp, ino, &imap, XFS_IGET_UNTRUSTED);
+	if (error == -EINVAL) {
+		/*
+		 * Inode could have gotten deleted out from under us;
+		 * just forget about it.
+		 */
+		error = -ENOENT;
+		goto out;
+	}
+	if (!xfs_scrub_process_error(sc, XFS_INO_TO_AGNO(mp, ino),
+			XFS_INO_TO_AGBNO(mp, ino), &error))
+		goto out;
+
+	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+			imap.im_blkno, imap.im_len, XBF_UNMAPPED, &bp,
+			NULL);
+	if (!xfs_scrub_process_error(sc, XFS_INO_TO_AGNO(mp, ino),
+			XFS_INO_TO_AGBNO(mp, ino), &error))
+		goto out;
+
+	/*
+	 * Is this really an inode?  We disabled verifiers in the above
+	 * xfs_trans_read_buf call because the inode buffer verifier
+	 * fails on /any/ inode record in the inode cluster with a bad
+	 * magic or version number, not just the one that we're
+	 * checking.  Therefore, grab the buffer unconditionally, attach
+	 * the inode verifiers by hand, and run the inode verifier only
+	 * on the one inode we want.
+	 */
+	bp->b_ops = &xfs_inode_buf_ops;
+	dip = xfs_buf_offset(bp, imap.im_boffset);
+	if (!xfs_dinode_verify(mp, ino, dip) ||
+	    !xfs_dinode_good_version(mp, dip->di_version)) {
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		goto out;
+	}
+
+	/* ...and is it the one we asked for? */
+	if (be32_to_cpu(dip->di_gen) != sc->sm->sm_gen) {
+		error = -ENOENT;
+		goto out;
+	}
+
+	*dipp = dip;
+	*bpp = bp;
+out:
+	return error;
+}
+
+/* Scrub an inode. */
+int
+xfs_scrub_inode(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_dinode		di;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_buf			*bp = NULL;
+	struct xfs_dinode		*dip;
+	xfs_ino_t			ino;
+
+	bool				has_shared;
+	int				error = 0;
+
+	/* Did we get the in-core inode, or are we doing this manually? */
+	if (sc->ip) {
+		ino = sc->ip->i_ino;
+		xfs_inode_to_disk(sc->ip, &di, 0);
+		dip = &di;
+	} else {
+		/* Map & read inode. */
+		ino = sc->sm->sm_ino;
+		error = xfs_scrub_inode_map_raw(sc, ino, &bp, &dip);
+		if (error)
+			goto out;
+	}
+
+	xfs_scrub_dinode(sc, bp, dip, ino);
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	/* Now let's do the things that require a live inode. */
+	if (!sc->ip)
+		goto out;
+
+	/*
+	 * Does this inode have the reflink flag set but no shared extents?
+	 * Set the preening flag if this is the case.
+	 */
+	if (xfs_is_reflink_inode(sc->ip)) {
+		error = xfs_reflink_inode_has_shared_extents(sc->tp, sc->ip,
+				&has_shared);
+		if (!xfs_scrub_process_error(sc, XFS_INO_TO_AGNO(mp, ino),
+				XFS_INO_TO_AGBNO(mp, ino), &error))
+			goto out;
+		if (!has_shared)
+			xfs_scrub_ino_set_preen(sc, bp);
+	}
+
+out:
+	if (bp)
+		xfs_trans_brelse(sc->tp, bp);
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index dbf717fdf..c271d96 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -30,6 +30,8 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_itable.h"
 #include "xfs_alloc.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_bmap.h"
@@ -141,6 +143,7 @@ xfs_scrub_probe(
 STATIC int
 xfs_scrub_teardown(
 	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip_in,
 	int				error)
 {
 	xfs_scrub_ag_free(sc, &sc->sa);
@@ -148,6 +151,13 @@ xfs_scrub_teardown(
 		xfs_trans_cancel(sc->tp);
 		sc->tp = NULL;
 	}
+	if (sc->ip) {
+		xfs_iunlock(sc->ip, sc->ilock_flags);
+		if (sc->ip != ip_in &&
+		    !xfs_internal_inum(sc->mp, sc->ip->i_ino))
+			iput(VFS_I(sc->ip));
+		sc->ip = NULL;
+	}
 	return error;
 }
 
@@ -201,6 +211,10 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.scrub	= xfs_scrub_refcountbt,
 		.has	= xfs_sb_version_hasreflink,
 	},
+	{ /* inode record */
+		.setup	= xfs_scrub_setup_inode,
+		.scrub	= xfs_scrub_inode,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
@@ -300,7 +314,7 @@ xfs_scrub_metadata(
 		 * Tear down everything we hold, then set up again with
 		 * preparation for worst-case scenarios.
 		 */
-		error = xfs_scrub_teardown(&sc, 0);
+		error = xfs_scrub_teardown(&sc, ip, 0);
 		if (error)
 			goto out;
 		try_harder = true;
@@ -313,7 +327,7 @@ xfs_scrub_metadata(
 		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
 
 out_teardown:
-	error = xfs_scrub_teardown(&sc, error);
+	error = xfs_scrub_teardown(&sc, ip, error);
 out:
 	trace_xfs_scrub_done(ip, sm, error);
 	return error;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 1c80bf5..ec635d4 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -59,6 +59,7 @@ struct xfs_scrub_context {
 	const struct xfs_scrub_meta_ops	*ops;
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip;
+	uint				ilock_flags;
 	bool				try_harder;
 
 	/* State tracking for single-AG operations. */
@@ -77,5 +78,6 @@ int xfs_scrub_inobt(struct xfs_scrub_context *sc);
 int xfs_scrub_finobt(struct xfs_scrub_context *sc);
 int xfs_scrub_rmapbt(struct xfs_scrub_context *sc);
 int xfs_scrub_refcountbt(struct xfs_scrub_context *sc);
+int xfs_scrub_inode(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6ff012f..5a84f58 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1202,6 +1202,8 @@ xfs_ioctl_setattr_get_trans(
  * 8. for non-realtime files, the extent size hint must be limited
  *    to half the AG size to avoid alignment extending the extent beyond the
  *    limits of the AG.
+ *
+ * Please keep this function in sync with xfs_scrub_inode_extsize.
  */
 static int
 xfs_ioctl_setattr_check_extsize(
@@ -1258,6 +1260,8 @@ xfs_ioctl_setattr_check_extsize(
  * 5. Extent size must be a multiple of the appropriate block size.
  * 6. The extent size hint must be limited to half the AG size to avoid
  *    alignment extending the extent beyond the limits of the AG.
+ *
+ * Please keep this function in sync with xfs_scrub_inode_cowextsize.
  */
 static int
 xfs_ioctl_setattr_check_cowextsize(
