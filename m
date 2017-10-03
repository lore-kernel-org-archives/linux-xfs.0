Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39635 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbdJCUmw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:42:52 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v93Kgpcf025579
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v93KgoCt005811
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:51 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v93Kgo1e002065
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:50 GMT
Subject: [PATCH 19/25] xfs: scrub directory metadata
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Oct 2017 13:42:49 -0700
Message-ID: <150706336897.19351.7541168310430592724.stgit@magnolia>
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

Scrub the hash tree and all the entries in a directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    3 
 fs/xfs/scrub/common.c  |   32 +++++
 fs/xfs/scrub/common.h  |    4 +
 fs/xfs/scrub/dir.c     |  300 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |    4 +
 fs/xfs/scrub/scrub.h   |    1 
 7 files changed, 344 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/dir.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b48437f..69aa88e 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -152,6 +152,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   btree.o \
 				   common.o \
 				   dabtree.o \
+				   dir.o \
 				   ialloc.o \
 				   inode.o \
 				   refcount.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 02ae58b..b16d004 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -498,9 +498,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTD	12	/* data fork block mapping */
 #define XFS_SCRUB_TYPE_BMBTA	13	/* attr fork block mapping */
 #define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
+#define XFS_SCRUB_TYPE_DIR	15	/* directory */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	15
+#define XFS_SCRUB_TYPE_NR	16
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 415dec6..ac66744 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -624,3 +624,35 @@ xfs_scrub_checkpoint_log(
 	xfs_ail_push_all_sync(mp->m_ail);
 	return 0;
 }
+
+/* Set us up to scrub a file's contents. */
+int
+xfs_scrub_setup_inode_contents(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	unsigned int			resblks)
+{
+	struct xfs_mount		*mp = sc->mp;
+	int				error;
+
+	error = xfs_scrub_get_inode(sc, ip);
+	if (error)
+		return error;
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
+	return 0;
+out_unlock:
+	xfs_iunlock(sc->ip, sc->ilock_flags);
+	if (sc->ip != ip)
+		iput(VFS_I(sc->ip));
+	sc->ip = NULL;
+	return error;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 3e87e3a..f530301 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -94,6 +94,8 @@ int xfs_scrub_setup_inode_bmap(struct xfs_scrub_context *sc,
 			       struct xfs_inode *ip);
 int xfs_scrub_setup_inode_bmap_data(struct xfs_scrub_context *sc,
 				    struct xfs_inode *ip);
+int xfs_scrub_setup_directory(struct xfs_scrub_context *sc,
+			      struct xfs_inode *ip);
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
@@ -114,5 +116,7 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
 			     struct xfs_inode *ip, bool force_log);
 int xfs_scrub_get_inode(struct xfs_scrub_context *sc, struct xfs_inode *ip_in);
+int xfs_scrub_setup_inode_contents(struct xfs_scrub_context *sc,
+				   struct xfs_inode *ip, unsigned int resblks);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
new file mode 100644
index 0000000..e58252b
--- /dev/null
+++ b/fs/xfs/scrub/dir.c
@@ -0,0 +1,300 @@
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
+#include "xfs_itable.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/dabtree.h"
+
+/* Set us up to scrub directories. */
+int
+xfs_scrub_setup_directory(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	return xfs_scrub_setup_inode_contents(sc, ip, 0);
+}
+
+/* Directories */
+
+/* Scrub a directory entry. */
+
+struct xfs_scrub_dir_ctx {
+	struct dir_context		dc;
+	struct xfs_scrub_context	*sc;
+};
+
+/* Check that an inode's mode matches a given DT_ type. */
+STATIC int
+xfs_scrub_dir_check_ftype(
+	struct xfs_scrub_dir_ctx	*sdc,
+	xfs_fileoff_t			offset,
+	xfs_ino_t			inum,
+	int				dtype)
+{
+	struct xfs_mount		*mp = sdc->sc->mp;
+	struct xfs_inode		*ip;
+	int				ino_dtype;
+	int				error = 0;
+
+	if (!xfs_sb_version_hasftype(&mp->m_sb)) {
+		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
+			xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
+					offset);
+		goto out;
+	}
+
+	error = xfs_iget(mp, sdc->sc->tp, inum, 0, 0, &ip);
+	if (!xfs_scrub_fblock_op_ok(sdc->sc, XFS_DATA_FORK, offset, &error))
+		goto out;
+
+	/* Convert mode to the DT_* values that dir_emit uses. */
+	ino_dtype = (VFS_I(ip)->i_mode & S_IFMT) >> 12;
+	if (ino_dtype != dtype)
+		xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
+	iput(VFS_I(ip));
+out:
+	return error;
+}
+
+/* Scrub a single directory entry. */
+STATIC int
+xfs_scrub_dir_actor(
+	struct dir_context		*dc,
+	const char			*name,
+	int				namelen,
+	loff_t				pos,
+	u64				ino,
+	unsigned			type)
+{
+	struct xfs_mount		*mp;
+	struct xfs_inode		*ip;
+	struct xfs_scrub_dir_ctx	*sdc;
+	struct xfs_name			xname;
+	xfs_ino_t			lookup_ino;
+	xfs_dablk_t			offset;
+	int				error = 0;
+
+	sdc = container_of(dc, struct xfs_scrub_dir_ctx, dc);
+	ip = sdc->sc->ip;
+	mp = ip->i_mount;
+	offset = xfs_dir2_db_to_da(mp->m_dir_geo,
+			xfs_dir2_dataptr_to_db(mp->m_dir_geo, pos));
+
+	/* Does this inode number make sense? */
+	if (xfs_dir_ino_validate(mp, ino) != 0 || xfs_internal_inum(mp, ino)) {
+		xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
+		goto out;
+	}
+
+	/* Verify that we can look up this name by hash. */
+	xname.name = name;
+	xname.len = namelen;
+	xname.type = XFS_DIR3_FT_UNKNOWN;
+
+	error = xfs_dir_lookup(sdc->sc->tp, ip, &xname, &lookup_ino, NULL);
+	if (!xfs_scrub_fblock_op_ok(sdc->sc, XFS_DATA_FORK, offset, &error))
+		goto fail_xref;
+	if (lookup_ino != ino) {
+		xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
+		goto out;
+	}
+
+	if (!strncmp(".", name, namelen)) {
+		/* If this is "." then check that the inum matches the dir. */
+		if (xfs_sb_version_hasftype(&mp->m_sb) && type != DT_DIR)
+			xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
+					offset);
+		if (ino != ip->i_ino)
+			xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
+					offset);
+	} else if (!strncmp("..", name, namelen)) {
+		/*
+		 * If this is ".." in the root inode, check that the inum
+		 * matches this dir.
+		 */
+		if (xfs_sb_version_hasftype(&mp->m_sb) && type != DT_DIR)
+			xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
+					offset);
+		if (ip->i_ino == mp->m_sb.sb_rootino && ino != ip->i_ino)
+			xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
+					offset);
+	}
+
+	/* Verify the file type.  This function absorbs error codes. */
+	error = xfs_scrub_dir_check_ftype(sdc, offset, lookup_ino, type);
+	if (error)
+		goto out;
+out:
+	return error;
+fail_xref:
+	return error;
+}
+
+/* Scrub a directory btree record. */
+STATIC int
+xfs_scrub_dir_rec(
+	struct xfs_scrub_da_btree	*ds,
+	int				level,
+	void				*rec)
+{
+	struct xfs_mount		*mp = ds->state->mp;
+	struct xfs_dir2_leaf_entry	*ent = rec;
+	struct xfs_inode		*dp = ds->dargs.dp;
+	struct xfs_dir2_data_entry	*dent;
+	struct xfs_buf			*bp;
+	xfs_ino_t			ino;
+	xfs_dablk_t			rec_bno;
+	xfs_dir2_db_t			db;
+	xfs_dir2_data_aoff_t		off;
+	xfs_dir2_dataptr_t		ptr;
+	xfs_dahash_t			calc_hash;
+	xfs_dahash_t			hash;
+	unsigned int			tag;
+	int				error;
+
+	/* Check the hash of the entry. */
+	error = xfs_scrub_da_btree_hash(ds, level, &ent->hashval);
+	if (error)
+		goto out;
+
+	/* Valid hash pointer? */
+	ptr = be32_to_cpu(ent->address);
+	if (ptr == 0)
+		return 0;
+
+	/* Find the directory entry's location. */
+	db = xfs_dir2_dataptr_to_db(mp->m_dir_geo, ptr);
+	off = xfs_dir2_dataptr_to_off(mp->m_dir_geo, ptr);
+	rec_bno = xfs_dir2_db_to_da(mp->m_dir_geo, db);
+
+	if (rec_bno >= mp->m_dir_geo->leafblk) {
+		xfs_scrub_da_set_corrupt(ds, level);
+		goto out;
+	}
+	error = xfs_dir3_data_read(ds->dargs.trans, dp, rec_bno, -2, &bp);
+	if (!xfs_scrub_fblock_op_ok(ds->sc, XFS_DATA_FORK, rec_bno, &error))
+		goto out;
+	if (!bp) {
+		xfs_scrub_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		goto out;
+	}
+
+	/* Retrieve the entry and check it. */
+	dent = (struct xfs_dir2_data_entry *)(((char *)bp->b_addr) + off);
+	ino = be64_to_cpu(dent->inumber);
+	hash = be32_to_cpu(ent->hashval);
+	tag = be16_to_cpup(dp->d_ops->data_entry_tag_p(dent));
+	if (xfs_dir_ino_validate(mp, ino) != 0 ||
+	    xfs_internal_inum(mp, ino) ||
+	    tag != off)
+		xfs_scrub_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+	if (dent->namelen == 0) {
+		xfs_scrub_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		goto out_relse;
+	}
+	calc_hash = xfs_da_hashname(dent->name, dent->namelen);
+	if (calc_hash != hash)
+		xfs_scrub_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+
+out_relse:
+	xfs_trans_brelse(ds->dargs.trans, bp);
+out:
+	return error;
+}
+
+/* Scrub a whole directory. */
+int
+xfs_scrub_directory(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_scrub_dir_ctx	sdc = {
+		.dc.actor = xfs_scrub_dir_actor,
+		.dc.pos = 0,
+	};
+	size_t				bufsize;
+	loff_t				oldpos;
+	int				error;
+
+	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
+		return -ENOENT;
+
+	/* Plausible size? */
+	if (sc->ip->i_d.di_size < xfs_dir2_sf_hdr_size(0)) {
+		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino, NULL);
+		goto out;
+	}
+
+	/* Check directory tree structure */
+	error = xfs_scrub_da_btree(sc, XFS_DATA_FORK, xfs_scrub_dir_rec);
+	if (error)
+		return error;
+
+	/*
+	 * Check that every dirent we see can also be looked up by hash.
+	 * Userspace usually asks for a 32k buffer, so we will too.
+	 */
+	bufsize = (size_t)min_t(loff_t, 32768, sc->ip->i_d.di_size);
+	sdc.sc = sc;
+
+	/*
+	 * Look up every name in this directory by hash.
+	 *
+	 * The VFS grabs a read or write lock via i_rwsem before it reads
+	 * or writes to a directory.  If we've gotten this far we've
+	 * already obtained IOLOCK_EXCL, which (since 4.10) is the same as
+	 * getting a write lock on i_rwsem.  Therefore, it is safe for us
+	 * to drop the ILOCK here in order to reuse the _readdir and
+	 * _dir_lookup routines, which do their own ILOCK locking.
+	 */
+	oldpos = 0;
+	sc->ilock_flags &= ~XFS_ILOCK_EXCL;
+	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
+	while (true) {
+		error = xfs_readdir(sc->tp, sc->ip, &sdc.dc, bufsize);
+		if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, 0, &error))
+			goto out;
+		if (oldpos == sdc.dc.pos)
+			break;
+		oldpos = sdc.dc.pos;
+	}
+
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b10d627..f3a84d9 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -221,6 +221,10 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.setup	= xfs_scrub_setup_inode_bmap,
 		.scrub	= xfs_scrub_bmap_cow,
 	},
+	{ /* directory */
+		.setup	= xfs_scrub_setup_directory,
+		.scrub	= xfs_scrub_directory,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 8920ccf..844506e 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -82,5 +82,6 @@ int xfs_scrub_inode(struct xfs_scrub_context *sc);
 int xfs_scrub_bmap_data(struct xfs_scrub_context *sc);
 int xfs_scrub_bmap_attr(struct xfs_scrub_context *sc);
 int xfs_scrub_bmap_cow(struct xfs_scrub_context *sc);
+int xfs_scrub_directory(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

