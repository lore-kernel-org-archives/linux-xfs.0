Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47439 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBWcH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 18:32:07 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52MW6sI028215
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:32:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v52MW5li015836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:32:06 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v52MW5Bo027548
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:32:05 GMT
Subject: [PATCH 12/19] xfs: scrub inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 15:32:04 -0700
Message-ID: <149644272412.19430.1799320307566766329.stgit@birch.djwong.org>
In-Reply-To: <149644264601.19430.6064928774771048026.stgit@birch.djwong.org>
References: <149644264601.19430.6064928774771048026.stgit@birch.djwong.org>
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
 fs/xfs/scrub/common.c  |   62 +++++++++
 fs/xfs/scrub/common.h  |    4 +
 fs/xfs/scrub/inode.c   |  325 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h     |    3 
 6 files changed, 394 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/inode.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 54afcbd..471fc27 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -109,6 +109,7 @@ xfs-$(CONFIG_XFS_DEBUG)		+= $(addprefix scrub/, \
 				   btree.o \
 				   common.o \
 				   ialloc.o \
+				   inode.o \
 				   refcount.o \
 				   rmap.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index fe6d5a8..39e6441a 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -503,7 +503,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_FINOBT	8	/* free inode btree */
 #define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
 #define XFS_SCRUB_TYPE_REFCNTBT	10	/* reference count btree */
-#define XFS_SCRUB_TYPE_MAX	10
+#define XFS_SCRUB_TYPE_INODE	11	/* inode record */
+#define XFS_SCRUB_TYPE_MAX	11
 
 #define XFS_SCRUB_FLAG_REPAIR	0x01	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x02	/* o: needs repair */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 031338a..4414a29 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -31,6 +31,8 @@
 #include "xfs_trace.h"
 #include "xfs_sb.h"
 #include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_itable.h"
 #include "xfs_alloc.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_bmap.h"
@@ -557,12 +559,58 @@ xfs_scrub_setup_fs(
 			&M_RES(sc->mp)->tr_itruncate, 0, 0, 0, &sc->tp);
 }
 
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
+	if (sc->sm->sm_gen && !sc->sm->sm_ino)
+		return -EINVAL;
+
+	if (sc->sm->sm_ino && sc->sm->sm_ino != ip_in->i_ino) {
+		if (xfs_internal_inum(mp, sc->sm->sm_ino))
+			return -ENOENT;
+		error = xfs_iget(mp, NULL, sc->sm->sm_ino, XFS_IGET_UNTRUSTED,
+				0, &ips);
+		if (error == -ENOENT || error == -EINVAL) {
+			/* inode doesn't exist... */
+			return -ENOENT;
+		} else if (error) {
+			trace_xfs_scrub_op_error(mp,
+					XFS_INO_TO_AGNO(mp, sc->sm->sm_ino),
+					XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),
+					"inode", error, __func__, __LINE__);
+			return error;
+		}
+		if (VFS_I(ips)->i_generation != sc->sm->sm_gen) {
+			IRELE(ips);
+			return -ENOENT;
+		}
+
+		sc->ip = ips;
+		return 0;
+	}
+
+	sc->ip = ip_in;
+	return 0;
+}
+
 /* Scrub setup and teardown */
 
 /* Free all the resources and finish the transactions. */
 STATIC int
 xfs_scrub_teardown(
 	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip_in,
 	int				error)
 {
 	xfs_scrub_ag_free(sc, &sc->sa);
@@ -570,6 +618,12 @@ xfs_scrub_teardown(
 		xfs_trans_cancel(sc->tp);
 		sc->tp = NULL;
 	}
+	if (sc->ip) {
+		xfs_iunlock(sc->ip, sc->ilock_flags);
+		if (sc->ip != ip_in)
+			IRELE(sc->ip);
+		sc->ip = NULL;
+	}
 	return error;
 }
 
@@ -704,6 +758,10 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 		.scrub	= xfs_scrub_refcountbt,
 		.has	= xfs_sb_version_hasreflink,
 	},
+	{ /* inode record */
+		.setup	= xfs_scrub_setup_inode,
+		.scrub	= xfs_scrub_inode,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
@@ -775,7 +833,7 @@ xfs_scrub_metadata(
 		 * Tear down everything we hold, then set up again with
 		 * preparation for worst-case scenarios.
 		 */
-		error = xfs_scrub_teardown(&sc, 0);
+		error = xfs_scrub_teardown(&sc, ip, 0);
 		if (error)
 			goto out;
 		try_harder = true;
@@ -787,7 +845,7 @@ xfs_scrub_metadata(
 		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
 
 out_teardown:
-	error = xfs_scrub_teardown(&sc, error);
+	error = xfs_scrub_teardown(&sc, ip, error);
 out:
 	trace_xfs_scrub_done(ip, sm, error);
 	return error;
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 12e7e60..b4aab69 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -52,6 +52,7 @@ struct xfs_scrub_context {
 	const struct xfs_scrub_meta_fns	*fns;
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip;
+	uint				ilock_flags;
 	bool				try_harder;
 
 	/* State tracking for single-AG operations. */
@@ -196,6 +197,7 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 
 int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
 			     struct xfs_inode *ip, bool force_log);
+int xfs_scrub_get_inode(struct xfs_scrub_context *sc, struct xfs_inode *ip_in);
 
 #define SETUP_FN(name) int name(struct xfs_scrub_context *sc, struct xfs_inode *ip)
 SETUP_FN(xfs_scrub_setup_fs);
@@ -204,6 +206,7 @@ SETUP_FN(xfs_scrub_setup_ag_allocbt);
 SETUP_FN(xfs_scrub_setup_ag_iallocbt);
 SETUP_FN(xfs_scrub_setup_ag_rmapbt);
 SETUP_FN(xfs_scrub_setup_ag_refcountbt);
+SETUP_FN(xfs_scrub_setup_inode);
 #undef SETUP_FN
 
 /* Metadata scrubbers */
@@ -219,6 +222,7 @@ SCRUB_FN(xfs_scrub_inobt);
 SCRUB_FN(xfs_scrub_finobt);
 SCRUB_FN(xfs_scrub_rmapbt);
 SCRUB_FN(xfs_scrub_refcountbt);
+SCRUB_FN(xfs_scrub_inode);
 #undef SCRUB_FN
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
new file mode 100644
index 0000000..351c3fd
--- /dev/null
+++ b/fs/xfs/scrub/inode.c
@@ -0,0 +1,325 @@
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
+#include "xfs_trace.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_inode_buf.h"
+#include "xfs_inode_fork.h"
+#include "xfs_ialloc.h"
+#include "xfs_log.h"
+#include "xfs_trans_priv.h"
+#include "xfs_reflink.h"
+#include "scrub/common.h"
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
+		IRELE(sc->ip);
+	sc->ip = NULL;
+	return error;
+}
+
+/* Inode core */
+
+#define XFS_SCRUB_INODE_CHECK(fs_ok) \
+	XFS_SCRUB_INO_CHECK(sc, ino, bp, "inode", fs_ok)
+#define XFS_SCRUB_INODE_GOTO(fs_ok, label) \
+	XFS_SCRUB_INO_GOTO(sc, ino, bp, "inode", fs_ok, label)
+#define XFS_SCRUB_INODE_OP_ERROR_GOTO(label) \
+	XFS_SCRUB_OP_ERROR_GOTO(sc, XFS_INO_TO_AGNO(mp, ino), \
+			XFS_INO_TO_AGBNO(mp, ino), "inode", &error, label)
+#define XFS_SCRUB_INODE_PREEN(fs_ok) \
+	XFS_SCRUB_INO_PREEN(sc, bp, "inode", fs_ok)
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
+	unsigned long long		isize;
+	uint64_t			flags2;
+	uint32_t			nextents;
+	uint32_t			extsize;
+	uint32_t			cowextsize;
+	uint16_t			flags;
+	uint16_t			mode;
+	bool				needs;
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
+		XFS_SCRUB_INODE_OP_ERROR_GOTO(out);
+
+		error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+				imap.im_blkno, imap.im_len, XBF_UNMAPPED, &bp,
+				NULL);
+		XFS_SCRUB_INODE_OP_ERROR_GOTO(out);
+
+		/* Is this really the inode we want? */
+		bp->b_ops = &xfs_inode_buf_ops;
+		dip = xfs_buf_offset(bp, imap.im_boffset);
+		error = xfs_dinode_verify(mp, ino, dip) ? 0 : -EFSCORRUPTED;
+		XFS_SCRUB_INODE_OP_ERROR_GOTO(out);
+		XFS_SCRUB_INODE_GOTO(
+				xfs_dinode_good_version(mp, dip->di_version),
+				out);
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
+	XFS_SCRUB_INODE_CHECK(!(mode & ~(S_IALLUGO | S_IFMT)));
+
+	/* v1/v2 fields */
+	switch (dip->di_version) {
+	case 1:
+		XFS_SCRUB_INODE_CHECK(dip->di_nlink == 0);
+		XFS_SCRUB_INODE_CHECK(dip->di_mode || !sc->ip);
+		XFS_SCRUB_INODE_CHECK(dip->di_projid_lo == 0);
+		XFS_SCRUB_INODE_CHECK(dip->di_projid_hi == 0);
+		break;
+	case 2:
+	case 3:
+		XFS_SCRUB_INODE_CHECK(dip->di_onlink == 0);
+		XFS_SCRUB_INODE_CHECK(dip->di_mode || !sc->ip);
+		XFS_SCRUB_INODE_CHECK(dip->di_projid_hi == 0 ||
+				xfs_sb_version_hasprojid32bit(&mp->m_sb));
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	/* di_format */
+	switch (dip->di_format) {
+	case XFS_DINODE_FMT_DEV:
+		XFS_SCRUB_INODE_CHECK(S_ISCHR(mode) || S_ISBLK(mode) ||
+				      S_ISFIFO(mode) || S_ISSOCK(mode));
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+		XFS_SCRUB_INODE_CHECK(S_ISDIR(mode) || S_ISLNK(mode));
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		XFS_SCRUB_INODE_CHECK(S_ISREG(mode) || S_ISDIR(mode) ||
+				      S_ISLNK(mode));
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		XFS_SCRUB_INODE_CHECK(S_ISREG(mode) || S_ISDIR(mode));
+		break;
+	case XFS_DINODE_FMT_UUID:
+	default:
+		XFS_SCRUB_INODE_CHECK(false);
+		break;
+	}
+
+	/* di_size */
+	isize = be64_to_cpu(dip->di_size);
+	XFS_SCRUB_INODE_CHECK(!(isize & (1ULL << 63)));
+	if (!S_ISDIR(mode) && !S_ISREG(mode) && !S_ISLNK(mode))
+		XFS_SCRUB_INODE_CHECK(isize == 0);
+
+	/* di_nblocks */
+	if (flags2 & XFS_DIFLAG2_REFLINK) {
+		; /* nblocks can exceed dblocks */
+	} else if (flags & XFS_DIFLAG_REALTIME) {
+		XFS_SCRUB_INODE_CHECK(be64_to_cpu(dip->di_nblocks) <
+				mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks);
+	} else {
+		XFS_SCRUB_INODE_CHECK(be64_to_cpu(dip->di_nblocks) <
+				mp->m_sb.sb_dblocks);
+	}
+
+	/* di_extsize */
+	if (flags & XFS_DIFLAG_EXTSIZE) {
+		extsize = be32_to_cpu(dip->di_extsize);
+		XFS_SCRUB_INODE_CHECK(extsize > 0);
+		XFS_SCRUB_INODE_CHECK(extsize <= MAXEXTLEN);
+		XFS_SCRUB_INODE_CHECK(extsize <= mp->m_sb.sb_agblocks / 2 ||
+				(flags & XFS_DIFLAG_REALTIME));
+	}
+
+	/* di_flags */
+	XFS_SCRUB_INODE_CHECK(!(flags & XFS_DIFLAG_IMMUTABLE) ||
+			      !(flags & XFS_DIFLAG_APPEND));
+
+	XFS_SCRUB_INODE_CHECK(!(flags & XFS_DIFLAG_FILESTREAM) ||
+			      !(flags & XFS_DIFLAG_REALTIME));
+
+	/* di_nextents */
+	nextents = be32_to_cpu(dip->di_nextents);
+	switch (dip->di_format) {
+	case XFS_DINODE_FMT_EXTENTS:
+		XFS_SCRUB_INODE_CHECK(nextents <=
+			XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec));
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		XFS_SCRUB_INODE_CHECK(nextents >
+			XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec));
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_DEV:
+	case XFS_DINODE_FMT_UUID:
+	default:
+		XFS_SCRUB_INODE_CHECK(nextents == 0);
+		break;
+	}
+
+	/* di_anextents */
+	nextents = be16_to_cpu(dip->di_anextents);
+	switch (dip->di_aformat) {
+	case XFS_DINODE_FMT_EXTENTS:
+		XFS_SCRUB_INODE_CHECK(nextents <=
+			XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec));
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		XFS_SCRUB_INODE_CHECK(nextents >
+			XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec));
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_DEV:
+	case XFS_DINODE_FMT_UUID:
+	default:
+		XFS_SCRUB_INODE_CHECK(nextents == 0);
+		break;
+	}
+
+	/* di_forkoff */
+	XFS_SCRUB_INODE_CHECK(XFS_DFORK_APTR(dip) <
+			(char *)dip + mp->m_sb.sb_inodesize);
+	XFS_SCRUB_INODE_CHECK(dip->di_anextents == 0 || dip->di_forkoff);
+
+	/* di_aformat */
+	XFS_SCRUB_INODE_CHECK(dip->di_aformat == XFS_DINODE_FMT_LOCAL ||
+			      dip->di_aformat == XFS_DINODE_FMT_EXTENTS ||
+			      dip->di_aformat == XFS_DINODE_FMT_BTREE);
+
+	/* di_cowextsize */
+	if (flags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		cowextsize = be32_to_cpu(dip->di_cowextsize);
+		XFS_SCRUB_INODE_CHECK(xfs_sb_version_hasreflink(&mp->m_sb));
+		XFS_SCRUB_INODE_CHECK(cowextsize > 0);
+		XFS_SCRUB_INODE_CHECK(cowextsize <= MAXEXTLEN);
+		XFS_SCRUB_INODE_CHECK(cowextsize <= mp->m_sb.sb_agblocks / 2);
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
+		error = xfs_reflink_needs_inode_flag(sc->tp, sc->ip, &needs);
+		XFS_SCRUB_INODE_OP_ERROR_GOTO(out);
+		XFS_SCRUB_INODE_PREEN(needs == true);
+	}
+
+out:
+	if (bp)
+		xfs_trans_brelse(sc->tp, bp);
+	return error;
+}
+#undef XFS_SCRUB_INODE_PREEN
+#undef XFS_SCRUB_INODE_OP_ERROR_GOTO
+#undef XFS_SCRUB_INODE_GOTO
+#undef XFS_SCRUB_INODE_CHECK
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index effaa47..ec11889 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3340,7 +3340,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_INOBT,		"inobt" }, \
 	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }, \
 	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }, \
-	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }
+	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }, \
+	{ XFS_SCRUB_TYPE_INODE,		"inode" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

