Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42071 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdJCUmd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:42:33 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v93KgWEW003158
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v93KgVCn002609
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:31 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v93KgVHX007992
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:31 GMT
Subject: [PATCH 16/25] xfs: scrub inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Oct 2017 13:42:30 -0700
Message-ID: <150706335008.19351.13005092237576865356.stgit@magnolia>
In-Reply-To: <150706324963.19351.17715069858921948692.stgit@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Scrub the fields within an inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    3 
 fs/xfs/scrub/common.c  |   65 +++++++++
 fs/xfs/scrub/common.h  |    5 +
 fs/xfs/scrub/inode.c   |  353 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |   17 ++
 fs/xfs/scrub/scrub.h   |    2 
 7 files changed, 443 insertions(+), 3 deletions(-)
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
index 4f8d103..415dec6 100644
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
@@ -40,6 +42,8 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_log.h"
+#include "xfs_trans_priv.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -559,3 +563,64 @@ xfs_scrub_setup_ag_btree(
 
 	return xfs_scrub_ag_init(sc, sc->sm->sm_agno, &sc->sa);
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
+	struct xfs_inode		*ips = NULL;
+	int				error;
+
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
+	error = xfs_iget(mp, NULL, sc->sm->sm_ino, XFS_IGET_UNTRUSTED,
+			0, &ips);
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
+	if (VFS_I(ips)->i_generation != sc->sm->sm_gen) {
+		iput(VFS_I(ips));
+		return -ENOENT;
+	}
+
+	sc->ip = ips;
+	return 0;
+}
+
+/* Push everything out of the log onto disk. */
+int
+xfs_scrub_checkpoint_log(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
+	if (error)
+		return error;
+	xfs_ail_push_all_sync(mp->m_ail);
+	return 0;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 6325f03..c8143e8 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -74,6 +74,8 @@ void xfs_scrub_fblock_set_warning(struct xfs_scrub_context *sc, int whichfork,
 
 void xfs_scrub_set_incomplete(struct xfs_scrub_context *sc);
 
+int xfs_scrub_checkpoint_log(struct xfs_mount *mp);
+
 /* Setup functions */
 int xfs_scrub_setup_fs(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 int xfs_scrub_setup_ag_header(struct xfs_scrub_context *sc,
@@ -86,6 +88,8 @@ int xfs_scrub_setup_ag_rmapbt(struct xfs_scrub_context *sc,
 			      struct xfs_inode *ip);
 int xfs_scrub_setup_ag_refcountbt(struct xfs_scrub_context *sc,
 				  struct xfs_inode *ip);
+int xfs_scrub_setup_inode(struct xfs_scrub_context *sc,
+			  struct xfs_inode *ip);
 
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
@@ -106,5 +110,6 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 
 int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
 			     struct xfs_inode *ip, bool force_log);
+int xfs_scrub_get_inode(struct xfs_scrub_context *sc, struct xfs_inode *ip_in);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
new file mode 100644
index 0000000..88dd3fc
--- /dev/null
+++ b/fs/xfs/scrub/inode.c
@@ -0,0 +1,353 @@
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
+#include "xfs_reflink.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+
+/* Set us up with an inode. */
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
+		return xfs_scrub_checkpoint_log(mp);
+	default:
+		return error;
+	}
+
+	/* Got the inode, lock it and we're ready to go. */
+	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	xfs_ilock(sc->ip, sc->ilock_flags);
+	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+	if (error)
+		goto out_unlock;
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+
+	return error;
+out_unlock:
+	xfs_iunlock(sc->ip, sc->ilock_flags);
+	if (sc->ip != ip)
+		iput(VFS_I(sc->ip));
+	sc->ip = NULL;
+	return error;
+}
+
+/* Inode core */
+
+/* Scrub an inode. */
+int
+xfs_scrub_inode(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_imap			imap;
+	struct xfs_dinode		di;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_buf			*bp = NULL;
+	struct xfs_dinode		*dip;
+	xfs_ino_t			ino;
+	size_t				fork_recs;
+	unsigned long long		isize;
+	uint64_t			flags2;
+	uint32_t			nextents;
+	uint32_t			extsize;
+	uint32_t			cowextsize;
+	uint16_t			flags;
+	uint16_t			mode;
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
+		error = xfs_imap(mp, sc->tp, ino, &imap, XFS_IGET_UNTRUSTED);
+		if (error == -EINVAL) {
+			/*
+			 * Inode could have gotten deleted out from under us;
+			 * just forget about it.
+			 */
+			error = -ENOENT;
+			goto out;
+		}
+		if (!xfs_scrub_op_ok(sc, XFS_INO_TO_AGNO(mp, ino),
+				XFS_INO_TO_AGBNO(mp, ino), &error))
+			goto out;
+
+		error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+				imap.im_blkno, imap.im_len, XBF_UNMAPPED, &bp,
+				NULL);
+		if (!xfs_scrub_op_ok(sc, XFS_INO_TO_AGNO(mp, ino),
+				XFS_INO_TO_AGBNO(mp, ino), &error))
+			goto out;
+
+		/* Is this really an inode? */
+		bp->b_ops = &xfs_inode_buf_ops;
+		dip = xfs_buf_offset(bp, imap.im_boffset);
+		if (!xfs_dinode_verify(mp, ino, dip) ||
+		    !xfs_dinode_good_version(mp, dip->di_version)) {
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			goto out;
+		}
+
+		/* ...and is it the one we asked for? */
+		if (be32_to_cpu(dip->di_gen) != sc->sm->sm_gen) {
+			error = -ENOENT;
+			goto out;
+		}
+	}
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
+		if (dip->di_nlink != 0)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+		if (dip->di_mode == 0 && sc->ip)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+		if (dip->di_projid_lo != 0 || dip->di_projid_hi != 0)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
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
+		ASSERT(0);
+		break;
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
+	/* di_size */
+	isize = be64_to_cpu(dip->di_size);
+	if (isize & (1ULL << 63))
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	if (!S_ISDIR(mode) && !S_ISREG(mode) && !S_ISLNK(mode) && isize != 0)
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+	/* di_nblocks */
+	if (flags2 & XFS_DIFLAG2_REFLINK) {
+		; /* nblocks can exceed dblocks */
+	} else if (flags & XFS_DIFLAG_REALTIME) {
+		if (be64_to_cpu(dip->di_nblocks) >=
+		    mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	} else {
+		if (be64_to_cpu(dip->di_nblocks) >= mp->m_sb.sb_dblocks)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	}
+
+	/* di_extsize */
+	extsize = be32_to_cpu(dip->di_extsize);
+	if (flags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT)) {
+		if (extsize <= 0 || extsize > MAXEXTLEN)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+		if (!(flags & XFS_DIFLAG_REALTIME) &&
+		    extsize > mp->m_sb.sb_agblocks / 2)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	} else {
+		if (extsize != 0)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	}
+
+	/* di_flags */
+	if ((flags & XFS_DIFLAG_IMMUTABLE) && (flags & XFS_DIFLAG_APPEND))
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	if ((flags & XFS_DIFLAG_FILESTREAM) && (flags & XFS_DIFLAG_REALTIME))
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
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
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_DEV:
+	case XFS_DINODE_FMT_UUID:
+	default:
+		if (nextents != 0)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		break;
+	}
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
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_DEV:
+	case XFS_DINODE_FMT_UUID:
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
+
+	/* di_aformat */
+	if (dip->di_aformat != XFS_DINODE_FMT_LOCAL &&
+	    dip->di_aformat != XFS_DINODE_FMT_EXTENTS &&
+	    dip->di_aformat != XFS_DINODE_FMT_BTREE)
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
+	/* di_cowextsize */
+	if (flags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		cowextsize = be32_to_cpu(dip->di_cowextsize);
+
+		if (!xfs_sb_version_hasreflink(&mp->m_sb))
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		if (cowextsize <= 0 || cowextsize > MAXEXTLEN)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		if (cowextsize > mp->m_sb.sb_agblocks / 2)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	}
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
+		if (!xfs_scrub_op_ok(sc, XFS_INO_TO_AGNO(mp, ino),
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
index 7b44364..f014ef0 100644
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
@@ -136,6 +138,7 @@ xfs_scrub_probe(
 STATIC int
 xfs_scrub_teardown(
 	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip_in,
 	int				error)
 {
 	xfs_scrub_ag_free(sc, &sc->sa);
@@ -143,6 +146,12 @@ xfs_scrub_teardown(
 		xfs_trans_cancel(sc->tp);
 		sc->tp = NULL;
 	}
+	if (sc->ip) {
+		xfs_iunlock(sc->ip, sc->ilock_flags);
+		if (sc->ip != ip_in)
+			iput(VFS_I(sc->ip));
+		sc->ip = NULL;
+	}
 	return error;
 }
 
@@ -196,6 +205,10 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.scrub	= xfs_scrub_refcountbt,
 		.has	= xfs_sb_version_hasreflink,
 	},
+	{ /* inode record */
+		.setup	= xfs_scrub_setup_inode,
+		.scrub	= xfs_scrub_inode,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
@@ -281,7 +294,7 @@ xfs_scrub_metadata(
 		 * Tear down everything we hold, then set up again with
 		 * preparation for worst-case scenarios.
 		 */
-		error = xfs_scrub_teardown(&sc, 0);
+		error = xfs_scrub_teardown(&sc, ip, 0);
 		if (error)
 			goto out;
 		try_harder = true;
@@ -294,7 +307,7 @@ xfs_scrub_metadata(
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

