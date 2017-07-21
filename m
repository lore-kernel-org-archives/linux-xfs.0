Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35319 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdGUEkm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:42 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6L4efb7010377
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:40:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v6L4eeM8030509
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:40:41 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6L4eejq009200
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:40:40 GMT
Subject: [PATCH 20/22] xfs: scrub parent pointers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jul 2017 21:40:38 -0700
Message-ID: <150061203891.14732.2830567045712478700.stgit@magnolia>
In-Reply-To: <150061190859.14732.17040548800470377701.stgit@magnolia>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Scrub parent pointers, sort of.  For directories, we can ride the
'..' entry up to the parent to confirm that there's at most one
dentry that points back to this directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    3 -
 fs/xfs/scrub/common.c  |    4 +
 fs/xfs/scrub/common.h  |    2 
 fs/xfs/scrub/parent.c  |  252 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 261 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/parent.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 3d862b9..e73cdc2 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -151,6 +151,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   ialloc.o \
 				   inode.o \
 				   metabufs.o \
+				   parent.o \
 				   refcount.o \
 				   rmap.o \
 				   symlink.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 95d9ce9..4ad3056 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -500,7 +500,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_DIR	16	/* directory */
 #define XFS_SCRUB_TYPE_XATTR	17	/* extended attribute */
 #define XFS_SCRUB_TYPE_SYMLINK	18	/* symbolic link */
-#define XFS_SCRUB_TYPE_MAX	18
+#define XFS_SCRUB_TYPE_PARENT	19	/* parent pointers */
+#define XFS_SCRUB_TYPE_MAX	19
 
 /* i: repair this metadata */
 #define XFS_SCRUB_FLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 4003c2f..6f701c6 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -856,6 +856,10 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 		.setup	= xfs_scrub_setup_symlink,
 		.scrub	= xfs_scrub_symlink,
 	},
+	{ /* parent pointers */
+		.setup	= xfs_scrub_setup_parent,
+		.scrub	= xfs_scrub_parent,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 6d02a64..1873a31 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -223,6 +223,7 @@ SETUP_FN(xfs_scrub_setup_inode_bmap_data);
 SETUP_FN(xfs_scrub_setup_inode_bmap);
 SETUP_FN(xfs_scrub_setup_directory);
 SETUP_FN(xfs_scrub_setup_xattr);
+SETUP_FN(xfs_scrub_setup_parent);
 SETUP_FN(xfs_scrub_setup_symlink);
 #undef SETUP_FN
 
@@ -247,6 +248,7 @@ SCRUB_FN(xfs_scrub_bmap_attr);
 SCRUB_FN(xfs_scrub_bmap_cow);
 SCRUB_FN(xfs_scrub_directory);
 SCRUB_FN(xfs_scrub_xattr);
+SCRUB_FN(xfs_scrub_parent);
 SCRUB_FN(xfs_scrub_symlink);
 #undef SCRUB_FN
 
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
new file mode 100644
index 0000000..e604885
--- /dev/null
+++ b/fs/xfs/scrub/parent.c
@@ -0,0 +1,252 @@
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
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "scrub/common.h"
+
+/* Set us up to scrub parents. */
+int
+xfs_scrub_setup_parent(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	return xfs_scrub_setup_inode_contents(sc, ip, 0);
+}
+
+/* Parent pointers */
+
+/* Look for an entry in a parent pointing to this inode. */
+
+struct xfs_scrub_parent_ctx {
+	struct dir_context		dc;
+	xfs_ino_t			ino;
+	xfs_nlink_t			nr;
+};
+
+/* Look for a single entry in a directory pointing to an inode. */
+STATIC int
+xfs_scrub_parent_actor(
+	struct dir_context		*dc,
+	const char			*name,
+	int				namelen,
+	loff_t				pos,
+	u64				ino,
+	unsigned			type)
+{
+	struct xfs_scrub_parent_ctx	*spc;
+
+	spc = container_of(dc, struct xfs_scrub_parent_ctx, dc);
+	if (spc->ino == ino)
+		spc->nr++;
+	return 0;
+}
+
+/* Count the number of dentries in the parent dir that point to this inode. */
+STATIC int
+xfs_scrub_parent_count_parent_dentries(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*parent,
+	xfs_nlink_t			*nr)
+{
+	struct xfs_scrub_parent_ctx	spc = {
+		.dc.actor = xfs_scrub_parent_actor,
+		.dc.pos = 0,
+		.ino = sc->ip->i_ino,
+		.nr = 0,
+	};
+	struct xfs_ifork		*ifp;
+	size_t				bufsize;
+	loff_t				oldpos;
+	uint				lock_mode;
+	int				error;
+
+	/*
+	 * Load the parent directory's extent map.  A regular directory
+	 * open would start readahead (and thus load the extent map)
+	 * before we even got to a readdir call, but this isn't
+	 * guaranteed here.
+	 */
+	lock_mode = xfs_ilock_data_map_shared(parent);
+	ifp = XFS_IFORK_PTR(parent, XFS_DATA_FORK);
+	if (XFS_IFORK_FORMAT(parent, XFS_DATA_FORK) == XFS_DINODE_FMT_BTREE &&
+	    !(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(sc->tp, parent, XFS_DATA_FORK);
+		if (error) {
+			xfs_iunlock(parent, lock_mode);
+			return error;
+		}
+	}
+	xfs_iunlock(parent, lock_mode);
+
+	/*
+	 * Iterate the parent dir to confirm that there is
+	 * exactly one entry pointing back to the inode being
+	 * scanned.
+	 */
+	bufsize = (size_t)min_t(loff_t, 32768, parent->i_d.di_size);
+	oldpos = 0;
+	while (true) {
+		error = xfs_readdir(sc->tp, parent, &spc.dc, bufsize);
+		if (error)
+			goto out;
+		if (oldpos == spc.dc.pos)
+			break;
+		oldpos = spc.dc.pos;
+	}
+	*nr = spc.nr;
+out:
+	return error;
+}
+
+/* Scrub a parent pointer. */
+#define XFS_SCRUB_PARENT_CHECK(fs_ok) \
+	XFS_SCRUB_DATA_CHECK(sc, XFS_DATA_FORK, 0, "parent", fs_ok)
+#define XFS_SCRUB_PARENT_GOTO(fs_ok, label) \
+	XFS_SCRUB_DATA_GOTO(sc, XFS_DATA_FORK, 0, "parent", fs_ok, label)
+#define XFS_SCRUB_PARENT_OP_ERROR_GOTO(label) \
+	XFS_SCRUB_FILE_OP_ERROR_GOTO(sc, XFS_DATA_FORK, 0, "parent", \
+		&error, label)
+int
+xfs_scrub_parent(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_inode		*dp = NULL;
+	xfs_ino_t			dnum;
+	xfs_nlink_t			nr;
+	int				tries = 0;
+	int				error;
+
+	/*
+	 * If we're a directory, check that the '..' link points up to
+	 * a directory that has one entry pointing to us.
+	 */
+	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
+		return -ENOENT;
+
+	/*
+	 * The VFS grabs a read or write lock via i_rwsem before it reads
+	 * or writes to a directory.  If we've gotten this far we've
+	 * already obtained IOLOCK_EXCL, which (since 4.10) is the same as
+	 * getting a write lock on i_rwsem.  Therefore, it is safe for us
+	 * to drop the ILOCK here in order to do directory lookups.
+	 */
+	sc->ilock_flags &= ~(XFS_ILOCK_EXCL | XFS_MMAPLOCK_EXCL);
+	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL | XFS_MMAPLOCK_EXCL);
+
+	/* Look up '..' */
+	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
+	XFS_SCRUB_PARENT_OP_ERROR_GOTO(out);
+
+	/* Is this the root dir?  Then '..' must point to itself. */
+	if (sc->ip == mp->m_rootip) {
+		XFS_SCRUB_PARENT_CHECK(sc->ip->i_ino == mp->m_sb.sb_rootino);
+		XFS_SCRUB_PARENT_CHECK(dnum == sc->ip->i_ino);
+		return 0;
+	}
+
+try_again:
+	/* Otherwise, '..' must not point to ourselves. */
+	XFS_SCRUB_PARENT_GOTO(sc->ip->i_ino != dnum, out);
+
+	error = xfs_iget(mp, sc->tp, dnum, 0, 0, &dp);
+	XFS_SCRUB_PARENT_OP_ERROR_GOTO(out);
+	XFS_SCRUB_PARENT_GOTO(dp != sc->ip, out_rele);
+
+	/*
+	 * We prefer to keep the inode locked while we lock and search
+	 * its alleged parent for a forward reference.  However, this
+	 * child -> parent scheme can deadlock with the parent -> child
+	 * scheme that is normally used.  Therefore, if we can lock the
+	 * parent, just validate the references and get out.
+	 */
+	if (xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED)) {
+		error = xfs_scrub_parent_count_parent_dentries(sc, dp, &nr);
+		XFS_SCRUB_PARENT_OP_ERROR_GOTO(out_unlock);
+		XFS_SCRUB_PARENT_CHECK(nr == 1);
+		goto out_unlock;
+	}
+
+	/*
+	 * The game changes if we get here.  We failed to lock the parent,
+	 * so we're going to try to verify both pointers while only holding
+	 * one lock so as to avoid deadlocking with something that's actually
+	 * trying to traverse down the directory tree.
+	 */
+	xfs_iunlock(sc->ip, sc->ilock_flags);
+	sc->ilock_flags = 0;
+	xfs_ilock(dp, XFS_IOLOCK_SHARED);
+
+	/* Go looking for our dentry. */
+	error = xfs_scrub_parent_count_parent_dentries(sc, dp, &nr);
+	XFS_SCRUB_PARENT_OP_ERROR_GOTO(out_unlock);
+
+	/* Drop the parent lock, relock this inode. */
+	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+	sc->ilock_flags = XFS_IOLOCK_EXCL;
+	xfs_ilock(sc->ip, sc->ilock_flags);
+
+	/* Look up '..' to see if the inode changed. */
+	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
+	XFS_SCRUB_PARENT_OP_ERROR_GOTO(out_rele);
+
+	/* Drat, parent changed.  Try again! */
+	if (dnum != dp->i_ino) {
+		IRELE(dp);
+		tries++;
+		if (tries < 20)
+			goto try_again;
+		XFS_SCRUB_INCOMPLETE(sc, "parent", false);
+		goto out;
+	}
+	IRELE(dp);
+
+	/*
+	 * '..' didn't change, so check that there was only one entry
+	 * for us in the parent.
+	 */
+	XFS_SCRUB_PARENT_CHECK(nr == 1);
+	goto out;
+
+out_unlock:
+	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+out_rele:
+	IRELE(dp);
+out:
+	return error;
+}
+#undef XFS_SCRUB_PARENT_OP_ERROR_GOTO
+#undef XFS_SCRUB_PARENT_GOTO
+#undef XFS_SCRUB_PARENT_CHECK

