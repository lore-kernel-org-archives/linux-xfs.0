Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 22FB87F4E
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:07:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C798AAC003
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:07:33 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Mpr4nPzWxqWIsyCi for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:07:31 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTpO-0006La-O0
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTpO-0002C1-N8
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/16] xfs: abstract the differences in dir2/dir3 via an ops
	vector
Date: Mon, 30 Sep 2013 13:07:04 +1000
Message-Id: <1380510433-8353-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510433-8353-1-git-send-email-david@fromorbit.com>
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Lots of the dir code now goes through switches to determine what is
the correct on-disk format to parse. It generally involves a
"xfs_sbversion_hasfoo" check, deferencing the superblock version and
feature fields and hence touching several cache lines per operation
in the process. Some operations do multiple checks because they nest
conditional operations and they don't pass the information in a
direct fashion between each other.

Hence, add an ops vector to the xfs_inode structure that is
configured when the inode is initialised to point to all the correct
decode and encoding operations.  This will significantly reduce the
branchiness and cacheline footprint of the directory object decoding
and encoding.

This is the first patch in a series of conversion patches. It will
introduce the ops structure, the setup of it and add the first
operation to the vector. Subsequent patches will convert directory
ops one at a time to keep the changes simple and obvious.

Just this patch shows the benefit of such an approach on code size.
Just converting the two shortform dir operations as this patch does
decreases the built binary size by ~1500 bytes:

$ size fs/xfs/xfs.o.orig fs/xfs/xfs.o.p1
   text    data     bss     dec     hex filename
 794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
 792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
$

That's a significant decrease in the instruction cache footprint of
the directory code for such a simple change, and indicates that this
approach is definitely worth pursuing further.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile           |  1 +
 fs/xfs/xfs_da_btree.h     |  1 +
 fs/xfs/xfs_da_format.c    | 85 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_da_format.h    | 26 ---------------
 fs/xfs/xfs_dir2.c         |  7 ++++
 fs/xfs/xfs_dir2.h         | 14 ++++++++
 fs/xfs/xfs_dir2_block.c   |  2 +-
 fs/xfs/xfs_dir2_readdir.c |  4 +--
 fs/xfs/xfs_dir2_sf.c      | 31 +++++++++--------
 fs/xfs/xfs_inode.h        |  3 ++
 fs/xfs/xfs_iops.c         |  1 +
 fs/xfs/xfs_mount.h        |  2 ++
 12 files changed, 132 insertions(+), 45 deletions(-)
 create mode 100644 fs/xfs/xfs_da_format.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 33a69fa..c21f435 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -66,6 +66,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_bmap_btree.o \
 				   xfs_btree.o \
 				   xfs_da_btree.o \
+				   xfs_da_format.o \
 				   xfs_dir2.o \
 				   xfs_dir2_block.o \
 				   xfs_dir2_data.o \
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index e492dca..6e95ea7 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -23,6 +23,7 @@ struct xfs_bmap_free;
 struct xfs_inode;
 struct xfs_trans;
 struct zone;
+struct xfs_dir_ops;
 
 /*========================================================================
  * Btree searching and modification structure definitions.
diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
new file mode 100644
index 0000000..982d105
--- /dev/null
+++ b/fs/xfs/xfs_da_format.c
@@ -0,0 +1,85 @@
+/*
+ * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_da_format.h"
+#include "xfs_inode.h"
+#include "xfs_dir2.h"
+
+
+static int
+xfs_dir2_sf_entsize(
+	struct xfs_dir2_sf_hdr	*hdr,
+	int			len)
+{
+	int count = sizeof(struct xfs_dir2_sf_entry);	/* namelen + offset */
+
+	count += len;					/* name */
+	count += hdr->i8count ? sizeof(xfs_dir2_ino8_t) :
+				sizeof(xfs_dir2_ino4_t); /* ino # */
+	return count;
+}
+
+static int
+xfs_dir3_sf_entsize(
+	struct xfs_dir2_sf_hdr	*hdr,
+	int			len)
+{
+	return xfs_dir2_sf_entsize(hdr, len) + sizeof(__uint8_t);
+}
+
+static struct xfs_dir2_sf_entry *
+xfs_dir2_sf_nextentry(
+	struct xfs_dir2_sf_hdr	*hdr,
+	struct xfs_dir2_sf_entry *sfep)
+{
+	return (struct xfs_dir2_sf_entry *)
+		((char *)sfep + xfs_dir2_sf_entsize(hdr, sfep->namelen));
+}
+
+static struct xfs_dir2_sf_entry *
+xfs_dir3_sf_nextentry(
+	struct xfs_dir2_sf_hdr	*hdr,
+	struct xfs_dir2_sf_entry *sfep)
+{
+	return (struct xfs_dir2_sf_entry *)
+		((char *)sfep + xfs_dir3_sf_entsize(hdr, sfep->namelen));
+}
+
+
+const struct xfs_dir_ops xfs_dir2_ops = {
+	.sf_entsize = xfs_dir2_sf_entsize,
+	.sf_nextentry = xfs_dir2_sf_nextentry,
+};
+
+const struct xfs_dir_ops xfs_dir2_ftype_ops = {
+	.sf_entsize = xfs_dir3_sf_entsize,
+	.sf_nextentry = xfs_dir3_sf_nextentry,
+};
+
+const struct xfs_dir_ops xfs_dir3_ops = {
+	.sf_entsize = xfs_dir3_sf_entsize,
+	.sf_nextentry = xfs_dir3_sf_nextentry,
+};
diff --git a/fs/xfs/xfs_da_format.h b/fs/xfs/xfs_da_format.h
index 89a1a21..d54726d 100644
--- a/fs/xfs/xfs_da_format.h
+++ b/fs/xfs/xfs_da_format.h
@@ -329,32 +329,6 @@ xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
 		((char *)hdr + xfs_dir2_sf_hdr_size(hdr->i8count));
 }
 
-static inline int
-xfs_dir3_sf_entsize(
-	struct xfs_mount	*mp,
-	struct xfs_dir2_sf_hdr	*hdr,
-	int			len)
-{
-	int count = sizeof(struct xfs_dir2_sf_entry); 	/* namelen + offset */
-
-	count += len;					/* name */
-	count += hdr->i8count ? sizeof(xfs_dir2_ino8_t) :
-				sizeof(xfs_dir2_ino4_t); /* ino # */
-	if (xfs_sb_version_hasftype(&mp->m_sb))
-		count += sizeof(__uint8_t);		/* file type */
-	return count;
-}
-
-static inline struct xfs_dir2_sf_entry *
-xfs_dir3_sf_nextentry(
-	struct xfs_mount	*mp,
-	struct xfs_dir2_sf_hdr	*hdr,
-	struct xfs_dir2_sf_entry *sfep)
-{
-	return (struct xfs_dir2_sf_entry *)
-		((char *)sfep + xfs_dir3_sf_entsize(mp, hdr, sfep->namelen));
-}
-
 /*
  * in dir3 shortform directories, the file type field is stored at a variable
  * offset after the inode number. Because it's only a single byte, endian
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 38bf932..7911136 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -112,6 +112,13 @@ xfs_dir_mount(
 		mp->m_dirnameops = &xfs_ascii_ci_nameops;
 	else
 		mp->m_dirnameops = &xfs_default_nameops;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		mp->m_dir_inode_ops = &xfs_dir3_ops;
+	else if (xfs_sb_version_hasftype(&mp->m_sb))
+		mp->m_dir_inode_ops = &xfs_dir2_ftype_ops;
+	else
+		mp->m_dir_inode_ops = &xfs_dir2_ops;
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 9910401..1909d9f 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -32,6 +32,20 @@ struct xfs_dir2_data_unused;
 extern struct xfs_name	xfs_name_dotdot;
 
 /*
+ * directory operations vector for encode/decode routines
+ */
+struct xfs_dir_ops {
+	int	(*sf_entsize)(struct xfs_dir2_sf_hdr *hdr, int len);
+	struct xfs_dir2_sf_entry *
+		(*sf_nextentry)(struct xfs_dir2_sf_hdr *hdr,
+				struct xfs_dir2_sf_entry *sfep);
+};
+
+extern const struct xfs_dir_ops xfs_dir2_ops;
+extern const struct xfs_dir_ops xfs_dir2_ftype_ops;
+extern const struct xfs_dir_ops xfs_dir3_ops;
+
+/*
  * Generic directory interface routines
  */
 extern void xfs_dir_startup(void);
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 9f3f83a..9d86b6f 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -1240,7 +1240,7 @@ xfs_dir2_sf_to_block(
 		if (++i == sfp->count)
 			sfep = NULL;
 		else
-			sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
+			sfep = dp->d_ops->sf_nextentry(sfp, sfep);
 	}
 	/* Done with the temporary buffer */
 	kmem_free(sfp);
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 45c9ce8..8033305 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -153,7 +153,7 @@ xfs_dir2_sf_getdents(
 				xfs_dir2_sf_get_offset(sfep));
 
 		if (ctx->pos > off) {
-			sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
+			sfep = dp->d_ops->sf_nextentry(sfp, sfep);
 			continue;
 		}
 
@@ -163,7 +163,7 @@ xfs_dir2_sf_getdents(
 		if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
 			    xfs_dir3_get_dtype(mp, filetype)))
 			return 0;
-		sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
+		sfep = dp->d_ops->sf_nextentry(sfp, sfep);
 	}
 
 	ctx->pos = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0) &
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 8811ee5..73881c9 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -336,7 +336,7 @@ xfs_dir2_block_to_sf(
 			xfs_dir3_sfe_put_ftype(mp, sfp, sfep,
 					xfs_dir3_dirent_get_ftype(mp, dep));
 
-			sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
+			sfep = dp->d_ops->sf_nextentry(sfp, sfep);
 		}
 		ptr += xfs_dir3_data_entsize(mp, dep->namelen);
 	}
@@ -389,7 +389,7 @@ xfs_dir2_sf_addname(
 	/*
 	 * Compute entry (and change in) size.
 	 */
-	add_entsize = xfs_dir3_sf_entsize(dp->i_mount, sfp, args->namelen);
+	add_entsize = dp->d_ops->sf_entsize(sfp, args->namelen);
 	incr_isize = add_entsize;
 	objchange = 0;
 #if XFS_BIG_INUMS
@@ -483,8 +483,7 @@ xfs_dir2_sf_addname_easy(
 	/*
 	 * Grow the in-inode space.
 	 */
-	xfs_idata_realloc(dp,
-			  xfs_dir3_sf_entsize(dp->i_mount, sfp, args->namelen),
+	xfs_idata_realloc(dp, dp->d_ops->sf_entsize(sfp, args->namelen),
 			  XFS_DATA_FORK);
 	/*
 	 * Need to set up again due to realloc of the inode data.
@@ -563,7 +562,7 @@ xfs_dir2_sf_addname_hard(
 	      eof = (char *)oldsfep == &buf[old_isize];
 	     !eof;
 	     offset = new_offset + xfs_dir3_data_entsize(mp, oldsfep->namelen),
-	      oldsfep = xfs_dir3_sf_nextentry(mp, oldsfp, oldsfep),
+	      oldsfep = dp->d_ops->sf_nextentry(oldsfp, oldsfep),
 	      eof = (char *)oldsfep == &buf[old_isize]) {
 		new_offset = xfs_dir2_sf_get_offset(oldsfep);
 		if (offset + add_datasize <= new_offset)
@@ -603,7 +602,7 @@ xfs_dir2_sf_addname_hard(
 	 * If there's more left to copy, do that.
 	 */
 	if (!eof) {
-		sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
+		sfep = dp->d_ops->sf_nextentry(sfp, sfep);
 		memcpy(sfep, oldsfep, old_isize - nbytes);
 	}
 	kmem_free(buf);
@@ -653,7 +652,7 @@ xfs_dir2_sf_addname_pick(
 			holefit = offset + size <= xfs_dir2_sf_get_offset(sfep);
 		offset = xfs_dir2_sf_get_offset(sfep) +
 			 xfs_dir3_data_entsize(mp, sfep->namelen);
-		sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
+		sfep = dp->d_ops->sf_nextentry(sfp, sfep);
 	}
 	/*
 	 * Calculate data bytes used excluding the new entry, if this
@@ -719,7 +718,7 @@ xfs_dir2_sf_check(
 
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 	     i < sfp->count;
-	     i++, sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep)) {
+	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep)) {
 		ASSERT(xfs_dir2_sf_get_offset(sfep) >= offset);
 		ino = xfs_dir3_sfe_get_ino(mp, sfp, sfep);
 		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
@@ -848,7 +847,7 @@ xfs_dir2_sf_lookup(
 	 */
 	ci_sfep = NULL;
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->count;
-	     i++, sfep = xfs_dir3_sf_nextentry(dp->i_mount, sfp, sfep)) {
+	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep)) {
 		/*
 		 * Compare name and if it's an exact match, return the inode
 		 * number. If it's the first case-insensitive match, store the
@@ -917,7 +916,7 @@ xfs_dir2_sf_removename(
 	 * Find the one we're deleting.
 	 */
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->count;
-	     i++, sfep = xfs_dir3_sf_nextentry(dp->i_mount, sfp, sfep)) {
+	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep)) {
 		if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir3_sfe_get_ino(dp->i_mount, sfp, sfep) ==
@@ -934,7 +933,7 @@ xfs_dir2_sf_removename(
 	 * Calculate sizes.
 	 */
 	byteoff = (int)((char *)sfep - (char *)sfp);
-	entsize = xfs_dir3_sf_entsize(dp->i_mount, sfp, args->namelen);
+	entsize = dp->d_ops->sf_entsize(sfp, args->namelen);
 	newsize = oldsize - entsize;
 	/*
 	 * Copy the part if any after the removed entry, sliding it down.
@@ -1051,7 +1050,7 @@ xfs_dir2_sf_replace(
 	 */
 	else {
 		for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->count;
-		     i++, sfep = xfs_dir3_sf_nextentry(dp->i_mount, sfp, sfep)) {
+		     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep)) {
 			if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
 #if XFS_BIG_INUMS || defined(DEBUG)
@@ -1172,8 +1171,8 @@ xfs_dir2_sf_toino4(
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
 		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
 	     i < sfp->count;
-	     i++, sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep),
-		  oldsfep = xfs_dir3_sf_nextentry(mp, oldsfp, oldsfep)) {
+	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep),
+		  oldsfep = dp->d_ops->sf_nextentry(oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
 		sfep->offset = oldsfep->offset;
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
@@ -1251,8 +1250,8 @@ xfs_dir2_sf_toino8(
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
 		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
 	     i < sfp->count;
-	     i++, sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep),
-		  oldsfep = xfs_dir3_sf_nextentry(mp, oldsfp, oldsfep)) {
+	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep),
+		  oldsfep = dp->d_ops->sf_nextentry(oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
 		sfep->offset = oldsfep->offset;
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index bb2f283..3ce8c01 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -49,6 +49,9 @@ typedef struct xfs_inode {
 	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
 	xfs_ifork_t		i_df;		/* data fork */
 
+	/* operations vectors */
+	const struct xfs_dir_ops *d_ops;		/* directory ops vector */
+
 	/* Transaction and locking information. */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	mrlock_t		i_lock;		/* inode lock */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index eef7f1a..e8ae828 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1210,6 +1210,7 @@ xfs_setup_inode(
 		else
 			inode->i_op = &xfs_dir_inode_operations;
 		inode->i_fop = &xfs_dir_file_operations;
+		ip->d_ops = ip->i_mount->m_dir_inode_ops;
 		break;
 	case S_IFLNK:
 		inode->i_op = &xfs_symlink_inode_operations;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1fa0584..973397f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -26,6 +26,7 @@ struct xfs_mru_cache;
 struct xfs_nameops;
 struct xfs_ail;
 struct xfs_quotainfo;
+struct xfs_dir_ops;
 
 #ifdef HAVE_PERCPU_SB
 
@@ -148,6 +149,7 @@ typedef struct xfs_mount {
 	int			m_dir_magicpct;	/* 37% of the dir blocksize */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
+	const struct xfs_dir_ops *m_dir_inode_ops; /* vector of dir inode ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
 	int			m_dirblkfsbs;	/* directory block sz--fsbs */
 	xfs_dablk_t		m_dirdatablk;	/* blockno of dir data v2 */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
