Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36010 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbdG0Wnb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2017 18:43:31 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6RMhUx4008012
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:43:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMhUtr032387
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:43:30 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMhUwe017999
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:43:30 GMT
Subject: [PATCH 17/26] xfs: scrub inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 27 Jul 2017 15:43:24 -0700
Message-ID: <150119540401.15159.15322602489533742085.stgit@magnolia>
In-Reply-To: <150119530010.15159.9900948790538082160.stgit@magnolia>
References: <150119530010.15159.9900948790538082160.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Scrub the fields within an inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    3 
 fs/xfs/scrub/common.c  |   49 +++++++
 fs/xfs/scrub/common.h  |    3 
 fs/xfs/scrub/inode.c   |  338 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |   17 ++
 fs/xfs/scrub/scrub.h   |    2 
 fs/xfs/scrub/trace.h   |    3 
 8 files changed, 412 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/inode.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 8aa745c..92641fb 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -149,6 +149,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   btree.o \
 				   common.o \
 				   ialloc.o \
+				   inode.o \
 				   refcount.o \
 				   rmap.o \
 				   scrub.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 450a692..2051c3d 100644
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
index a3e185c..2a1d456 100644
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
@@ -552,3 +554,50 @@ xfs_scrub_setup_ag_btree(
 
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
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index e50368d..ae6b557 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -102,6 +102,8 @@ int xfs_scrub_setup_ag_rmapbt(struct xfs_scrub_context *sc,
 			      struct xfs_inode *ip);
 int xfs_scrub_setup_ag_refcountbt(struct xfs_scrub_context *sc,
 				  struct xfs_inode *ip);
+int xfs_scrub_setup_inode(struct xfs_scrub_context *sc,
+			  struct xfs_inode *ip);
 
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
@@ -122,5 +124,6 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 
 int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
 			     struct xfs_inode *ip, bool force_log);
+int xfs_scrub_get_inode(struct xfs_scrub_context *sc, struct xfs_inode *ip_in);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
new file mode 100644
index 0000000..5cc218b
--- /dev/null
+++ b/fs/xfs/scrub/inode.c
@@ -0,0 +1,338 @@
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
+#include "xfs_log.h"
+#include "xfs_trans_priv.h"
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
+		/* Push everything out of the log onto disk prior to check. */
+		error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
+		if (error)
+			return error;
+		xfs_ail_push_all_sync(mp->m_ail);
+		return 0;
+	default:
+		return error;
+	}
+
+	/* Got the inode, lock it and we're ready to go. */
+	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	xfs_ilock(sc->ip, sc->ilock_flags);
+	error = xfs_scrub_trans_alloc(sc->sm, mp, &M_RES(mp)->tr_itruncate,
+			0, 0, 0, &sc->tp);
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
+		/* Is this really the inode we want? */
+		bp->b_ops = &xfs_inode_buf_ops;
+		dip = xfs_buf_offset(bp, imap.im_boffset);
+		if (!xfs_scrub_ino_check_ok(sc, ino, bp,
+				xfs_dinode_verify(mp, ino, dip) &&
+				xfs_dinode_good_version(mp, dip->di_version)))
+			goto out;
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
+	xfs_scrub_ino_check_ok(sc, ino, bp, !(mode & ~(S_IALLUGO | S_IFMT)));
+
+	/* v1/v2 fields */
+	switch (dip->di_version) {
+	case 1:
+		xfs_scrub_ino_check_ok(sc, ino, bp,
+				dip->di_nlink == 0 &&
+				(dip->di_mode || !sc->ip) &&
+				dip->di_projid_lo == 0 &&
+				dip->di_projid_hi == 0);
+		break;
+	case 2:
+	case 3:
+		xfs_scrub_ino_check_ok(sc, ino, bp,
+				dip->di_onlink == 0 &&
+				(dip->di_mode || !sc->ip) &&
+				(dip->di_projid_hi == 0 ||
+				 xfs_sb_version_hasprojid32bit(&mp->m_sb)));
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
+	xfs_scrub_ino_warn_ok(sc, bp,
+			dip->di_uid != cpu_to_be32(-1U) &&
+			dip->di_gid != cpu_to_be32(-1U));
+
+	/* di_format */
+	switch (dip->di_format) {
+	case XFS_DINODE_FMT_DEV:
+		xfs_scrub_ino_check_ok(sc, ino, bp,
+				S_ISCHR(mode) || S_ISBLK(mode) ||
+				S_ISFIFO(mode) || S_ISSOCK(mode));
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+		xfs_scrub_ino_check_ok(sc, ino, bp,
+				S_ISDIR(mode) || S_ISLNK(mode));
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		xfs_scrub_ino_check_ok(sc, ino, bp, S_ISREG(mode) ||
+				S_ISDIR(mode) || S_ISLNK(mode));
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		xfs_scrub_ino_check_ok(sc, ino, bp, S_ISREG(mode) ||
+				S_ISDIR(mode));
+		break;
+	case XFS_DINODE_FMT_UUID:
+	default:
+		xfs_scrub_ino_check_ok(sc, ino, bp, false);
+		break;
+	}
+
+	/* di_size */
+	isize = be64_to_cpu(dip->di_size);
+	xfs_scrub_ino_check_ok(sc, ino, bp, !(isize & (1ULL << 63)));
+	if (!S_ISDIR(mode) && !S_ISREG(mode) && !S_ISLNK(mode))
+		xfs_scrub_ino_check_ok(sc, ino, bp, isize == 0);
+
+	/* di_nblocks */
+	if (flags2 & XFS_DIFLAG2_REFLINK) {
+		; /* nblocks can exceed dblocks */
+	} else if (flags & XFS_DIFLAG_REALTIME) {
+		xfs_scrub_ino_check_ok(sc, ino, bp,
+				be64_to_cpu(dip->di_nblocks) <
+				mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks);
+	} else {
+		xfs_scrub_ino_check_ok(sc, ino, bp,
+				be64_to_cpu(dip->di_nblocks) <
+				mp->m_sb.sb_dblocks);
+	}
+
+	/* di_extsize */
+	if (flags & XFS_DIFLAG_EXTSIZE) {
+		extsize = be32_to_cpu(dip->di_extsize);
+		xfs_scrub_ino_check_ok(sc, ino, bp,
+				extsize > 0 &&
+				extsize <= MAXEXTLEN &&
+				(extsize <= mp->m_sb.sb_agblocks / 2 ||
+				 (flags & XFS_DIFLAG_REALTIME)));
+	}
+
+	/* di_flags */
+	xfs_scrub_ino_check_ok(sc, ino, bp,
+			(!(flags & XFS_DIFLAG_IMMUTABLE) ||
+			      !(flags & XFS_DIFLAG_APPEND)) &&
+			(!(flags & XFS_DIFLAG_FILESTREAM) ||
+			      !(flags & XFS_DIFLAG_REALTIME)));
+
+	/* di_nextents */
+	nextents = be32_to_cpu(dip->di_nextents);
+	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
+	switch (dip->di_format) {
+	case XFS_DINODE_FMT_EXTENTS:
+		xfs_scrub_ino_check_ok(sc, ino, bp, nextents <= fork_recs);
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		xfs_scrub_ino_check_ok(sc, ino, bp, nextents > fork_recs);
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_DEV:
+	case XFS_DINODE_FMT_UUID:
+	default:
+		xfs_scrub_ino_check_ok(sc, ino, bp, nextents == 0);
+		break;
+	}
+
+	/* di_anextents */
+	nextents = be16_to_cpu(dip->di_anextents);
+	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
+	switch (dip->di_aformat) {
+	case XFS_DINODE_FMT_EXTENTS:
+		xfs_scrub_ino_check_ok(sc, ino, bp, nextents <= fork_recs);
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		xfs_scrub_ino_check_ok(sc, ino, bp, nextents > fork_recs);
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_DEV:
+	case XFS_DINODE_FMT_UUID:
+	default:
+		xfs_scrub_ino_check_ok(sc, ino, bp, nextents == 0);
+		break;
+	}
+
+	/* di_forkoff */
+	xfs_scrub_ino_check_ok(sc, ino, bp,
+			XFS_DFORK_APTR(dip) <
+				(char *)dip + mp->m_sb.sb_inodesize &&
+			(dip->di_anextents == 0 || dip->di_forkoff));
+
+	/* di_aformat */
+	xfs_scrub_ino_check_ok(sc, ino, bp,
+			dip->di_aformat == XFS_DINODE_FMT_LOCAL ||
+			dip->di_aformat == XFS_DINODE_FMT_EXTENTS ||
+			dip->di_aformat == XFS_DINODE_FMT_BTREE);
+
+	/* di_cowextsize */
+	if (flags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		cowextsize = be32_to_cpu(dip->di_cowextsize);
+		xfs_scrub_ino_check_ok(sc, ino, bp,
+				xfs_sb_version_hasreflink(&mp->m_sb) &&
+				cowextsize > 0 &&
+				cowextsize <= MAXEXTLEN &&
+				cowextsize <= mp->m_sb.sb_agblocks / 2);
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
+		xfs_scrub_ino_preen_ok(sc, bp, has_shared == true);
+	}
+
+out:
+	if (bp)
+		xfs_trans_brelse(sc->tp, bp);
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index e5b14d5..0990b06 100644
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
@@ -145,6 +147,7 @@ xfs_scrub_tester(
 STATIC int
 xfs_scrub_teardown(
 	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip_in,
 	int				error)
 {
 	xfs_scrub_ag_free(sc, &sc->sa);
@@ -152,6 +155,12 @@ xfs_scrub_teardown(
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
 
@@ -205,6 +214,10 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.scrub	= xfs_scrub_refcountbt,
 		.has	= xfs_sb_version_hasreflink,
 	},
+	{ /* inode record */
+		.setup	= xfs_scrub_setup_inode,
+		.scrub	= xfs_scrub_inode,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
@@ -284,7 +297,7 @@ xfs_scrub_metadata(
 		 * Tear down everything we hold, then set up again with
 		 * preparation for worst-case scenarios.
 		 */
-		error = xfs_scrub_teardown(&sc, 0);
+		error = xfs_scrub_teardown(&sc, ip, 0);
 		if (error)
 			goto out;
 		try_harder = true;
@@ -297,7 +310,7 @@ xfs_scrub_metadata(
 		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
 
 out_teardown:
-	error = xfs_scrub_teardown(&sc, error);
+	error = xfs_scrub_teardown(&sc, ip, error);
 out:
 	trace_xfs_scrub_done(ip, sm, error);
 	return error;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 4cc4b84..fed8ed1 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -54,6 +54,7 @@ struct xfs_scrub_context {
 	const struct xfs_scrub_meta_ops	*ops;
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip;
+	uint				ilock_flags;
 	bool				try_harder;
 
 	/* State tracking for single-AG operations. */
@@ -72,5 +73,6 @@ int xfs_scrub_inobt(struct xfs_scrub_context *sc);
 int xfs_scrub_finobt(struct xfs_scrub_context *sc);
 int xfs_scrub_rmapbt(struct xfs_scrub_context *sc);
 int xfs_scrub_refcountbt(struct xfs_scrub_context *sc);
+int xfs_scrub_inode(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index b5259c9..d749954 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -36,7 +36,8 @@
 	{ XFS_SCRUB_TYPE_INOBT,		"inobt" }, \
 	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }, \
 	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }, \
-	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }
+	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }, \
+	{ XFS_SCRUB_TYPE_INODE,		"inode" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

