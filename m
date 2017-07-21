Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49815 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdGUEkW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:22 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6L4eLvB030717
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:40:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v6L4eLQb014691
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:40:21 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v6L4eE7X006659
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:40:20 GMT
Subject: [PATCH 16/22] xfs: scrub directory metadata
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jul 2017 21:40:13 -0700
Message-ID: <150061201307.14732.2386031240024902784.stgit@magnolia>
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

Scrub the hash tree and all the entries in a directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    3 
 fs/xfs/scrub/common.c  |   37 ++++++
 fs/xfs/scrub/common.h  |    4 +
 fs/xfs/scrub/dir.c     |  291 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h     |    3 
 6 files changed, 337 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/dir.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5f9e121..c568d0d 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -146,6 +146,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   btree.o \
 				   common.o \
 				   dabtree.o \
+				   dir.o \
 				   ialloc.o \
 				   inode.o \
 				   metabufs.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d762277..e646b5f 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -497,7 +497,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTD	13	/* data fork block mapping */
 #define XFS_SCRUB_TYPE_BMBTA	14	/* attr fork block mapping */
 #define XFS_SCRUB_TYPE_BMBTC	15	/* CoW fork block mapping */
-#define XFS_SCRUB_TYPE_MAX	15
+#define XFS_SCRUB_TYPE_DIR	16	/* directory */
+#define XFS_SCRUB_TYPE_MAX	16
 
 /* i: repair this metadata */
 #define XFS_SCRUB_FLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index da3c006..92627e9 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -633,6 +633,39 @@ xfs_scrub_get_inode(
 	return 0;
 }
 
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
+	error = xfs_scrub_trans_alloc(sc->sm, mp, &M_RES(mp)->tr_itruncate,
+			resblks, 0, 0, &sc->tp);
+	if (error)
+		goto out_unlock;
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+
+	return 0;
+out_unlock:
+	xfs_iunlock(sc->ip, sc->ilock_flags);
+	if (sc->ip != ip)
+		IRELE(sc->ip);
+	sc->ip = NULL;
+	return error;
+}
+
 /* Scrub setup and teardown */
 
 /* Free all the resources and finish the transactions. */
@@ -807,6 +840,10 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 		.setup	= xfs_scrub_setup_inode_bmap,
 		.scrub	= xfs_scrub_bmap_cow,
 	},
+	{ /* directory */
+		.setup	= xfs_scrub_setup_directory,
+		.scrub	= xfs_scrub_directory,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 1025466..7baaa2d 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -206,6 +206,8 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
 			     struct xfs_inode *ip, bool force_log);
 int xfs_scrub_get_inode(struct xfs_scrub_context *sc, struct xfs_inode *ip_in);
+int xfs_scrub_setup_inode_contents(struct xfs_scrub_context *sc,
+				   struct xfs_inode *ip, unsigned int resblks);
 
 #define SETUP_FN(name) int name(struct xfs_scrub_context *sc, struct xfs_inode *ip)
 SETUP_FN(xfs_scrub_setup_fs);
@@ -218,6 +220,7 @@ SETUP_FN(xfs_scrub_setup_ag_refcountbt);
 SETUP_FN(xfs_scrub_setup_inode);
 SETUP_FN(xfs_scrub_setup_inode_bmap_data);
 SETUP_FN(xfs_scrub_setup_inode_bmap);
+SETUP_FN(xfs_scrub_setup_directory);
 #undef SETUP_FN
 
 /* Metadata scrubbers */
@@ -239,6 +242,7 @@ SCRUB_FN(xfs_scrub_inode);
 SCRUB_FN(xfs_scrub_bmap_data);
 SCRUB_FN(xfs_scrub_bmap_attr);
 SCRUB_FN(xfs_scrub_bmap_cow);
+SCRUB_FN(xfs_scrub_directory);
 #undef SCRUB_FN
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
new file mode 100644
index 0000000..1d6b5329
--- /dev/null
+++ b/fs/xfs/scrub/dir.c
@@ -0,0 +1,291 @@
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
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "scrub/common.h"
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
+#define XFS_SCRUB_DIR_CHECK(fs_ok) \
+	XFS_SCRUB_DATA_CHECK(sdc->sc, XFS_DATA_FORK, offset, "dir", fs_ok)
+#define XFS_SCRUB_DIR_GOTO(fs_ok, label) \
+	XFS_SCRUB_DATA_GOTO(sdc->sc, XFS_DATA_FORK, offset, "dir", fs_ok, label)
+#define XFS_SCRUB_DIR_OP_ERROR_GOTO(label) \
+	XFS_SCRUB_FILE_OP_ERROR_GOTO(sdc->sc, XFS_DATA_FORK, offset, "dir", &error, label)
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
+		XFS_SCRUB_DIR_CHECK(dtype == DT_UNKNOWN || dtype == DT_DIR);
+		goto out;
+	}
+
+	error = xfs_iget(mp, sdc->sc->tp, inum, 0, 0, &ip);
+	XFS_SCRUB_OP_ERROR_GOTO(sdc->sc,
+			XFS_INO_TO_AGNO(mp, inum),
+			XFS_INO_TO_AGBNO(mp, inum),
+			"inode", &error, out);
+	/* Convert mode to the DT_* values that dir_emit uses. */
+	ino_dtype = (VFS_I(ip)->i_mode & S_IFMT) >> 12;
+	XFS_SCRUB_DIR_CHECK(ino_dtype == dtype);
+	IRELE(ip);
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
+	XFS_SCRUB_DIR_GOTO(xfs_dir_ino_validate(mp, ino) == 0, out);
+	XFS_SCRUB_DIR_GOTO(!xfs_internal_inum(mp, ino), out);
+
+	/* Verify that we can look up this name by hash. */
+	xname.name = name;
+	xname.len = namelen;
+	xname.type = XFS_DIR3_FT_UNKNOWN;
+
+	error = xfs_dir_lookup(sdc->sc->tp, ip, &xname, &lookup_ino, NULL);
+	XFS_SCRUB_DIR_OP_ERROR_GOTO(fail_xref);
+	XFS_SCRUB_DIR_GOTO(lookup_ino == ino, out);
+
+	if (!strncmp(".", name, namelen)) {
+		/* If this is "." then check that the inum matches the dir. */
+		if (xfs_sb_version_hasftype(&mp->m_sb))
+			XFS_SCRUB_DIR_CHECK(type == DT_DIR);
+		XFS_SCRUB_DIR_CHECK(ino == ip->i_ino);
+	} else if (!strncmp("..", name, namelen)) {
+		/*
+		 * If this is ".." in the root inode, check that the inum
+		 * matches this dir.
+		 */
+		if (xfs_sb_version_hasftype(&mp->m_sb))
+			XFS_SCRUB_DIR_CHECK(type == DT_DIR);
+		if (ip->i_ino == mp->m_sb.sb_rootino)
+			XFS_SCRUB_DIR_CHECK(ino == ip->i_ino);
+	}
+	if (error)
+		goto out;
+
+	/* Verify the file type. */
+	error = xfs_scrub_dir_check_ftype(sdc, offset, lookup_ino, type);
+	if (error)
+		goto out;
+out:
+	return error;
+fail_xref:
+	return error ? error : -EFSCORRUPTED;
+}
+#undef XFS_SCRUB_DIR_OP_ERROR_GOTO
+#undef XFS_SCRUB_DIR_GOTO
+#undef XFS_SCRUB_DIR_CHECK
+
+#define XFS_SCRUB_DIRENT_CHECK(fs_ok) \
+	XFS_SCRUB_DATA_CHECK(ds->sc, XFS_DATA_FORK, rec_bno, "dir", fs_ok)
+#define XFS_SCRUB_DIRENT_GOTO(fs_ok, label) \
+	XFS_SCRUB_DATA_GOTO(ds->sc, XFS_DATA_FORK, rec_bno, "dir", fs_ok, label)
+#define XFS_SCRUB_DIRENT_OP_ERROR_GOTO(label) \
+	XFS_SCRUB_FILE_OP_ERROR_GOTO(ds->sc, XFS_DATA_FORK, rec_bno, "dir", &error, label)
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
+	XFS_SCRUB_DA_GOTO(ds, rec_bno < mp->m_dir_geo->leafblk, out);
+	error = xfs_dir3_data_read(ds->dargs.trans, dp, rec_bno, -2, &bp);
+	XFS_SCRUB_DIRENT_OP_ERROR_GOTO(out);
+	XFS_SCRUB_DIRENT_GOTO(bp != NULL, out);
+
+	/* Retrieve the entry and check it. */
+	dent = (struct xfs_dir2_data_entry *)(((char *)bp->b_addr) + off);
+	ino = be64_to_cpu(dent->inumber);
+	hash = be32_to_cpu(ent->hashval);
+	tag = be16_to_cpup(dp->d_ops->data_entry_tag_p(dent));
+	XFS_SCRUB_DIRENT_CHECK(xfs_dir_ino_validate(mp, ino) == 0);
+	XFS_SCRUB_DIRENT_CHECK(!xfs_internal_inum(mp, ino));
+	XFS_SCRUB_DIRENT_CHECK(tag == off);
+	XFS_SCRUB_DIRENT_GOTO(dent->namelen < MAXNAMELEN, out_relse);
+	calc_hash = xfs_da_hashname(dent->name, dent->namelen);
+	XFS_SCRUB_DIRENT_CHECK(calc_hash == hash);
+
+out_relse:
+	xfs_trans_brelse(ds->dargs.trans, bp);
+out:
+	return error;
+}
+#undef XFS_SCRUB_DIRENT_OP_ERROR_GOTO
+#undef XFS_SCRUB_DIRENT_GOTO
+#undef XFS_SCRUB_DIRENT_CHECK
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
+	struct xfs_mount		*mp = sc->mp;
+	size_t				bufsize;
+	loff_t				oldpos;
+	int				error;
+
+	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
+		return -ENOENT;
+
+	/* Plausible size? */
+	XFS_SCRUB_INO_GOTO(sc, sc->ip->i_ino, NULL, "inode",
+			sc->ip->i_d.di_size >= xfs_dir2_sf_hdr_size(0), out);
+
+	/* Check directory tree structure */
+	error = xfs_scrub_da_btree(sc, XFS_DATA_FORK, xfs_scrub_dir_rec);
+	if (error)
+		return error;
+
+	/* Check that every dirent we see can also be looked up by hash. */
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
+		XFS_SCRUB_OP_ERROR_GOTO(sc,
+				XFS_INO_TO_AGNO(mp, sc->ip->i_ino),
+				XFS_INO_TO_AGBNO(mp, sc->ip->i_ino),
+				"inode", &error, out);
+		if (oldpos == sdc.dc.pos)
+			break;
+		oldpos = sdc.dc.pos;
+	}
+
+out:
+	return error;
+}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index edfa4c7..ccd27ec 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3327,7 +3327,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_INODE,		"inode" }, \
 	{ XFS_SCRUB_TYPE_BMBTD,		"bmapbtd" }, \
 	{ XFS_SCRUB_TYPE_BMBTA,		"bmapbta" }, \
-	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }
+	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }, \
+	{ XFS_SCRUB_TYPE_DIR,		"dir" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

