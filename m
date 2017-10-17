Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38863 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752909AbdJQAQH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 20:16:07 -0400
Date: Mon, 16 Oct 2017 17:16:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 28/30] xfs: scrub directory parent pointers
Message-ID: <20171017001603.GY4703@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777262776.1724.11135251107601015017.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777262776.1724.11135251107601015017.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

Scrub parent pointers, sort of.  For directories, we can ride the
'..' entry up to the parent to confirm that there's at most one
dentry that points back to this directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: refactor the single-ilock-retry code into a separate validate function
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    3 
 fs/xfs/scrub/common.h  |    2 
 fs/xfs/scrub/parent.c  |  309 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |    4 +
 fs/xfs/scrub/scrub.h   |    1 
 6 files changed, 319 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/parent.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 28637a6..2193a54 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -156,6 +156,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   dir.o \
 				   ialloc.o \
 				   inode.o \
+				   parent.o \
 				   refcount.o \
 				   rmap.o \
 				   scrub.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index bb8bcd0..7444094 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -501,9 +501,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_DIR	15	/* directory */
 #define XFS_SCRUB_TYPE_XATTR	16	/* extended attribute */
 #define XFS_SCRUB_TYPE_SYMLINK	17	/* symbolic link */
+#define XFS_SCRUB_TYPE_PARENT	18	/* parent pointers */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	18
+#define XFS_SCRUB_TYPE_NR	19
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index b71c1a8..0542e7d 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -99,6 +99,8 @@ int xfs_scrub_setup_xattr(struct xfs_scrub_context *sc,
 			  struct xfs_inode *ip);
 int xfs_scrub_setup_symlink(struct xfs_scrub_context *sc,
 			    struct xfs_inode *ip);
+int xfs_scrub_setup_parent(struct xfs_scrub_context *sc,
+			   struct xfs_inode *ip);
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
new file mode 100644
index 0000000..c4a78a3
--- /dev/null
+++ b/fs/xfs/scrub/parent.c
@@ -0,0 +1,309 @@
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
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_ialloc.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
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
+	xfs_nlink_t			nlink;
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
+		spc->nlink++;
+	return 0;
+}
+
+/* Count the number of dentries in the parent dir that point to this inode. */
+STATIC int
+xfs_scrub_parent_count_parent_dentries(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*parent,
+	xfs_nlink_t			*nlink)
+{
+	struct xfs_scrub_parent_ctx	spc = {
+		.dc.actor = xfs_scrub_parent_actor,
+		.dc.pos = 0,
+		.ino = sc->ip->i_ino,
+		.nlink = 0,
+	};
+	size_t				bufsize;
+	loff_t				oldpos;
+	uint				lock_mode;
+	int				error = 0;
+
+	/*
+	 * If there are any blocks, read-ahead block 0 as we're almost
+	 * certain to have the next operation be a read there.  This is
+	 * how we guarantee that the parent's extent map has been loaded,
+	 * if there is one.
+	 */
+	lock_mode = xfs_ilock_data_map_shared(parent);
+	if (parent->i_d.di_nextents > 0)
+		error = xfs_dir3_data_readahead(parent, 0, -1);
+	xfs_iunlock(parent, lock_mode);
+	if (error)
+		return error;
+
+	/*
+	 * Iterate the parent dir to confirm that there is
+	 * exactly one entry pointing back to the inode being
+	 * scanned.
+	 */
+	bufsize = (size_t)min_t(loff_t, XFS_READDIR_BUFSIZE,
+			parent->i_d.di_size);
+	oldpos = 0;
+	while (true) {
+		error = xfs_readdir(sc->tp, parent, &spc.dc, bufsize);
+		if (error)
+			goto out;
+		if (oldpos == spc.dc.pos)
+			break;
+		oldpos = spc.dc.pos;
+	}
+	*nlink = spc.nlink;
+out:
+	return error;
+}
+
+/*
+ * Given the inode number of the alleged parent of the inode being
+ * scrubbed, try to validate that the parent has exactly one directory
+ * entry pointing back to the inode being scrubbed.
+ */
+STATIC int
+xfs_scrub_parent_validate(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			dnum,
+	bool				*try_again)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_inode		*dp = NULL;
+	xfs_nlink_t			expected_nlink;
+	xfs_nlink_t			nlink;
+	int				error;
+
+	*try_again = false;
+
+	/* '..' must not point to ourselves. */
+	if (sc->ip->i_ino == dnum) {
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		goto out;
+	}
+
+	/*
+	 * If we're an unlinked directory, the parent /won't/ have a link
+	 * to us.  Otherwise, it should have one link.
+	 */
+	expected_nlink = VFS_I(sc->ip)->i_nlink == 0 ? 0 : 1;
+
+	/* Grab this parent inode. */
+	error = xfs_iget(mp, sc->tp, dnum, XFS_IGET_DONTCACHE, 0, &dp);
+	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+		goto out;
+	if (dp == sc->ip) {
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		goto out_rele;
+	}
+
+	/*
+	 * We prefer to keep the inode locked while we lock and search
+	 * its alleged parent for a forward reference.  If we can grab
+	 * the iolock, validate the pointers and we're done.  We must
+	 * use nowait here to avoid an ABBA deadlock on the parent and
+	 * the child inodes.
+	 */
+	if (xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED)) {
+		error = xfs_scrub_parent_count_parent_dentries(sc, dp, &nlink);
+		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0,
+				&error))
+			goto out_unlock;
+		if (nlink != expected_nlink)
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
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
+	error = xfs_scrub_parent_count_parent_dentries(sc, dp, &nlink);
+	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+		goto out_unlock;
+
+	/* Drop the parent lock, relock this inode. */
+	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+	sc->ilock_flags = XFS_IOLOCK_EXCL;
+	xfs_ilock(sc->ip, sc->ilock_flags);
+
+	/*
+	 * If we're an unlinked directory, the parent /won't/ have a link
+	 * to us.  Otherwise, it should have one link.  We have to re-set
+	 * it here because we dropped the lock on sc->ip.
+	 */
+	expected_nlink = VFS_I(sc->ip)->i_nlink == 0 ? 0 : 1;
+
+	/* Look up '..' to see if the inode changed. */
+	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
+	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+		goto out_rele;
+
+	/* Drat, parent changed.  Try again! */
+	if (dnum != dp->i_ino) {
+		iput(VFS_I(dp));
+		*try_again = true;
+		return 0;
+	}
+	iput(VFS_I(dp));
+
+	/*
+	 * '..' didn't change, so check that there was only one entry
+	 * for us in the parent.
+	 */
+	if (nlink != expected_nlink)
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+	return error;
+
+out_unlock:
+	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+out_rele:
+	iput(VFS_I(dp));
+out:
+	return error;
+}
+
+/* Scrub a parent pointer. */
+int
+xfs_scrub_parent(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	xfs_ino_t			dnum;
+	bool				try_again;
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
+	/* We're not a special inode, are we? */
+	if (!xfs_verify_dir_ino(mp, sc->ip->i_ino)) {
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		goto out;
+	}
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
+	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+		goto out;
+	if (!xfs_verify_dir_ino(mp, dnum)) {
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		goto out;
+	}
+
+	/* Is this the root dir?  Then '..' must point to itself. */
+	if (sc->ip == mp->m_rootip) {
+		if (sc->ip->i_ino != mp->m_sb.sb_rootino ||
+		    sc->ip->i_ino != dnum)
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		goto out;
+	}
+
+	do {
+		error = xfs_scrub_parent_validate(sc, dnum, &try_again);
+		if (error)
+			goto out;
+	} while (try_again && ++tries < 20);
+
+	/*
+	 * We gave it our best shot but failed, so mark this scrub
+	 * incomplete.  Userspace can decide if it wants to try again.
+	 */
+	if (try_again && tries == 20)
+		xfs_scrub_set_incomplete(sc);
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 0a7276b..c6ca402 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -243,6 +243,10 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.setup	= xfs_scrub_setup_symlink,
 		.scrub	= xfs_scrub_symlink,
 	},
+	{ /* parent pointers */
+		.setup	= xfs_scrub_setup_parent,
+		.scrub	= xfs_scrub_parent,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index dc4ed8d..a264810 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -86,5 +86,6 @@ int xfs_scrub_bmap_cow(struct xfs_scrub_context *sc);
 int xfs_scrub_directory(struct xfs_scrub_context *sc);
 int xfs_scrub_xattr(struct xfs_scrub_context *sc);
 int xfs_scrub_symlink(struct xfs_scrub_context *sc);
+int xfs_scrub_parent(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
