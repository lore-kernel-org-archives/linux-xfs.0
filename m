Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40824 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032643AbdAGAho (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 19:37:44 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v070bhEp024148
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:37:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v070bhD9009977
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:37:43 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v070bhEN008723
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:37:43 GMT
Subject: [PATCH 18/47] xfs: scrub inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 06 Jan 2017 16:37:42 -0800
Message-ID: <148374946198.30431.15595095706953017145.stgit@birch.djwong.org>
In-Reply-To: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Scrub the fields within an inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile               |    1 
 fs/xfs/libxfs/xfs_fs.h        |    3 
 fs/xfs/libxfs/xfs_inode_buf.c |    2 
 fs/xfs/libxfs/xfs_inode_buf.h |    3 
 fs/xfs/repair/common.c        |   14 +-
 fs/xfs/repair/common.h        |   12 +
 fs/xfs/repair/inode.c         |  379 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_itable.c           |    2 
 fs/xfs/xfs_itable.h           |    5 +
 fs/xfs/xfs_trace.h            |    3 
 10 files changed, 417 insertions(+), 7 deletions(-)
 create mode 100644 fs/xfs/repair/inode.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 2995503..b53cf70 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -108,6 +108,7 @@ xfs-$(CONFIG_XFS_DEBUG)		+= $(addprefix repair/, \
 				   btree.o \
 				   common.o \
 				   ialloc.o \
+				   inode.o \
 				   refcount.o \
 				   rmap.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 9f3603cb..3dfec06 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -585,7 +585,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_FINOBT	8	/* free inode btree */
 #define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
 #define XFS_SCRUB_TYPE_REFCNTBT	10	/* reference count btree */
-#define XFS_SCRUB_TYPE_MAX	10
+#define XFS_SCRUB_TYPE_INODE	11	/* inode record */
+#define XFS_SCRUB_TYPE_MAX	11
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index dd483e2..60b75d3 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -380,7 +380,7 @@ xfs_log_dinode_to_disk(
 	}
 }
 
-static bool
+bool
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 6848a0a..988fd67 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -82,4 +82,7 @@ void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #define	xfs_inobp_check(mp, bp)
 #endif /* DEBUG */
 
+bool	xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
+			  struct xfs_dinode *dip);
+
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index 6bbaed8..3fb7f6c 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -557,6 +557,7 @@ xfs_scrub_dummy(
 int
 xfs_scrub_teardown(
 	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip_in,
 	int				error)
 {
 	xfs_scrub_ag_free(&sc->sa);
@@ -565,6 +566,14 @@ xfs_scrub_teardown(
 	sc->ag_lock.agmask = NULL;
 	xfs_trans_cancel(sc->tp);
 	sc->tp = NULL;
+	if (sc->ip != NULL) {
+		xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
+		xfs_iunlock(sc->ip, XFS_IOLOCK_EXCL);
+		xfs_iunlock(sc->ip, XFS_MMAPLOCK_EXCL);
+		if (sc->ip != ip_in)
+			IRELE(sc->ip);
+		sc->ip = NULL;
+	}
 	return error;
 }
 
@@ -668,6 +677,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_iallocbt, xfs_scrub_finobt, NULL, xfs_sb_version_hasfinobt},
 	{xfs_scrub_setup_ag_header, xfs_scrub_rmapbt, NULL, xfs_sb_version_hasrmapbt},
 	{xfs_scrub_setup_ag_header, xfs_scrub_refcountbt, NULL, xfs_sb_version_hasreflink},
+	{xfs_scrub_setup_inode_raw, xfs_scrub_inode, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
@@ -728,7 +738,7 @@ xfs_scrub_metadata(
 	error = fns->scrub(&sc);
 	if (!deadlocked && error == -EDEADLOCK) {
 		deadlocked = true;
-		error = xfs_scrub_teardown(&sc, error);
+		error = xfs_scrub_teardown(&sc, ip, error);
 		if (error != -EDEADLOCK)
 			goto out;
 		goto retry_op;
@@ -739,7 +749,7 @@ xfs_scrub_metadata(
 		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
 
 out_teardown:
-	error = xfs_scrub_teardown(&sc, error);
+	error = xfs_scrub_teardown(&sc, ip, error);
 out:
 	trace_xfs_scrub_done(ip, sm->sm_type, sm->sm_agno, sm->sm_ino,
 			sm->sm_gen, sm->sm_flags, error);
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index 7dea98a..ae4bee5 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -200,7 +200,8 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 
 /* Setup functions */
 
-int xfs_scrub_teardown(struct xfs_scrub_context *sc, int error);
+int xfs_scrub_teardown(struct xfs_scrub_context *sc, struct xfs_inode *ip_in,
+		       int error);
 int xfs_scrub_setup(struct xfs_scrub_context *sc, struct xfs_inode *ip,
 		    struct xfs_scrub_metadata *sm, bool retry_deadlocked);
 int xfs_scrub_setup_ag(struct xfs_scrub_context *sc, struct xfs_inode *ip,
@@ -213,6 +214,14 @@ int xfs_scrub_setup_ag_iallocbt(struct xfs_scrub_context *sc,
 				struct xfs_inode *ip,
 				struct xfs_scrub_metadata *sm,
 				bool retry_deadlocked);
+int xfs_scrub_setup_inode(struct xfs_scrub_context *sc,
+			  struct xfs_inode *ip,
+			  struct xfs_scrub_metadata *sm,
+			  bool retry_deadlocked);
+int xfs_scrub_setup_inode_raw(struct xfs_scrub_context *sc,
+			      struct xfs_inode *ip,
+			      struct xfs_scrub_metadata *sm,
+			      bool retry_deadlocked);
 
 /* Metadata scrubbers */
 
@@ -226,5 +235,6 @@ int xfs_scrub_inobt(struct xfs_scrub_context *sc);
 int xfs_scrub_finobt(struct xfs_scrub_context *sc);
 int xfs_scrub_rmapbt(struct xfs_scrub_context *sc);
 int xfs_scrub_refcountbt(struct xfs_scrub_context *sc);
+int xfs_scrub_inode(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/repair/inode.c b/fs/xfs/repair/inode.c
new file mode 100644
index 0000000..e06d585
--- /dev/null
+++ b/fs/xfs/repair/inode.c
@@ -0,0 +1,379 @@
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
+#include "xfs_itable.h"
+#include "xfs_inode_buf.h"
+#include "xfs_inode_fork.h"
+#include "xfs_ialloc.h"
+#include "xfs_log.h"
+#include "xfs_trans_priv.h"
+#include "repair/common.h"
+
+/*
+ * Given an inode and the scrub control structure, return either the
+ * inode referenced in the control structure or the inode passed in.
+ * The inode is not locked.
+ */
+STATIC struct xfs_inode *
+xfs_scrub_get_inode(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_inode		*ips = NULL;
+	int				error;
+
+	if (sc->sm->sm_gen && !sc->sm->sm_ino)
+		return ERR_PTR(-EINVAL);
+
+	if (sc->sm->sm_ino && sc->sm->sm_ino != ip->i_ino) {
+		if (xfs_internal_inum(mp, sc->sm->sm_ino))
+			return ERR_PTR(-ENOENT);
+		error = xfs_iget(mp, NULL, sc->sm->sm_ino, XFS_IGET_UNTRUSTED,
+				0, &ips);
+		if (error) {
+			trace_xfs_scrub_op_error(mp,
+					XFS_INO_TO_AGNO(mp, sc->sm->sm_ino),
+					XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),
+					"inode", error, __func__, __LINE__);
+			goto out_err;
+		}
+		if (VFS_I(ips)->i_generation != sc->sm->sm_gen) {
+			IRELE(ips);
+			return ERR_PTR(-ENOENT);
+		}
+
+		return ips;
+	}
+
+	return ip;
+out_err:
+	return ERR_PTR(error);
+}
+
+/* Set us up with an inode. */
+int
+xfs_scrub_setup_inode(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	int				error;
+
+	memset(sc, 0, sizeof(*sc));
+	sc->sm = sm;
+	sc->ip = xfs_scrub_get_inode(sc, ip);
+	if (IS_ERR(sc->ip))
+		return PTR_ERR(sc->ip);
+	else if (sc->ip == NULL)
+		return -ENOENT;
+
+	xfs_ilock(sc->ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(sc->ip, XFS_MMAPLOCK_EXCL);
+	error = xfs_scrub_trans_alloc(sm, mp, &M_RES(mp)->tr_itruncate,
+			0, 0, 0, &sc->tp);
+	if (error)
+		goto out_unlock;
+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+
+	xfs_scrub_ag_lock_init(mp, &sc->ag_lock);
+	return error;
+out_unlock:
+	xfs_iunlock(sc->ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(sc->ip, XFS_MMAPLOCK_EXCL);
+	if (sc->ip != ip)
+		IRELE(sc->ip);
+	return error;
+}
+
+/* Try to get the in-core inode.  If we can't, we'll just have to do it raw. */
+int
+xfs_scrub_setup_inode_raw(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	int				error;
+
+	if (sm->sm_ino && xfs_internal_inum(mp, sm->sm_ino))
+		return -ENOENT;
+
+	error = xfs_scrub_setup_inode(sc, ip, sm, retry_deadlocked);
+	if (error) {
+		memset(sc, 0, sizeof(*sc));
+		sc->ip = NULL;
+		sc->sm = sm;
+
+		/* Push everything out of the log onto disk prior to check. */
+		error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
+		if (error)
+			return error;
+		xfs_ail_push_all_sync(mp->m_ail);
+
+		return xfs_scrub_trans_alloc(sm, mp,
+				&M_RES(mp)->tr_itruncate, 0, 0, 0, &sc->tp);
+	}
+	return 0;
+}
+
+/* Inode core */
+
+#define XFS_SCRUB_INODE_CHECK(fs_ok) \
+	XFS_SCRUB_INO_CHECK(sc, ino, bp, "inode", fs_ok);
+#define XFS_SCRUB_INODE_GOTO(fs_ok, label) \
+	XFS_SCRUB_INO_GOTO(sc, ino, bp, "inode", fs_ok, label);
+#define XFS_SCRUB_INODE_OP_ERROR_GOTO(label) \
+	XFS_SCRUB_OP_ERROR_GOTO(sc, XFS_INO_TO_AGNO(mp, ino), \
+			XFS_INO_TO_AGBNO(mp, ino), "inode", &error, label);
+#define XFS_SCRUB_INODE_PREEN(fs_ok) \
+	XFS_SCRUB_INO_PREEN(sc, bp, "inode", fs_ok);
+/* Scrub an inode. */
+int
+xfs_scrub_inode(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_imap			imap;
+	struct xfs_dinode		di;
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_ifork		*ifp;
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
+			error = -EINVAL;
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
+	 * If this is a reflink inode with no CoW in progress, maybe we
+	 * can turn off the reflink flag?
+	 */
+	if (xfs_is_reflink_inode(sc->ip)) {
+		ifp = XFS_IFORK_PTR(sc->ip, XFS_COW_FORK);
+		XFS_SCRUB_INODE_PREEN(ifp->if_bytes > 0);
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
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 66e8817..4fd5fe1 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -31,7 +31,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 
-STATIC int
+int
 xfs_internal_inum(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino)
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 6ea8b39..dd2427b 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -96,4 +96,9 @@ xfs_inumbers(
 	void			__user *buffer, /* buffer with inode info */
 	inumbers_fmt_pf		formatter);
 
+int
+xfs_internal_inum(
+	xfs_mount_t	*mp,
+	xfs_ino_t	ino);
+
 #endif	/* __XFS_ITABLE_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4757fea..2cf344e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3363,7 +3363,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_INOBT,		"inobt" }, \
 	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }, \
 	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }, \
-	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }
+	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }, \
+	{ XFS_SCRUB_TYPE_INODE,		"inode" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

