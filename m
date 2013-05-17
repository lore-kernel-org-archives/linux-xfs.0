Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 845497F3F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 04:21:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 21476AC005
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 02:21:13 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id yaJ1vtLI26aG4X8E (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 02:21:09 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r4H9L6RA029478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 09:21:07 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H9L6cZ008347
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 09:21:07 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H9L6Ln025571 for <xfs@oss.sgi.com>; Fri, 17 May 2013 09:21:06 GMT
Message-ID: <5195F67F.5070101@oracle.com>
Date: Fri, 17 May 2013 17:21:03 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: code sync up for log space reservation
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello,

Here is a patch to sync up the kernel code changes regarding log space reservation
to the xfsprogs.

There have a couple of differences between the kernel and the user space.
1) A few transaction reservation item related to dquot are not synced because they
   are not being used in xfsprogs.
2) In xfs_log_rlimit.c, the xfs_log_validate_logspace() is not copied and the xfs_mkfs.c
   still use the default validate_log_space() to check the given log size.

Thanks,
-Jeff


From: Jie Liu <jeff.liu@oracle.com>

Sync up the kernel space code changes to the user space
which are includes:
1) Sync up xfs_log_rlimit.[c|h] to libxfs and replaced two
   functions at mkfs/maxres.c for figuring out the max transaction
   reservation.
2) Add m_tresp() helper, libxfs_trans_reserve() interface refactor
   and propagate them to where they should be.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 include/libxfs.h         |    9 ++-
 include/xfs_log_rlimit.h |   24 ++++++
 include/xfs_mount.h      |   72 ++++++++++-------
 libxfs/Makefile          |    2 +-
 libxfs/trans.c           |   10 +--
 libxfs/util.c            |   11 ++-
 libxfs/xfs_attr.c        |   44 +++++------
 libxfs/xfs_bmap.c        |    4 +-
 libxfs/xfs_log_rlimit.c  |   73 ++++++++++++++++++
 libxfs/xfs_trans.c       |  109 +++++++++++++++++++-------
 mkfs/maxtrres.c          |   68 ++++------------
 mkfs/proto.c             |   61 +++++++++------
 mkfs/xfs_mkfs.c          |    9 ++-
 repair/phase6.c          |  193 ++++++++++++++++++++++++----------------------
 repair/phase7.c          |    6 +-
 15 files changed, 424 insertions(+), 271 deletions(-)
 create mode 100644 include/xfs_log_rlimit.h
 create mode 100644 libxfs/xfs_log_rlimit.c

diff --git a/include/libxfs.h b/include/libxfs.h
index b6e83f4..9e2a603 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -55,6 +55,7 @@
 #include <xfs/xfs_btree.h>
 #include <xfs/xfs_btree_trace.h>
 #include <xfs/xfs_bmap.h>
+#include <xfs/xfs_log_rlimit.h>
 #include <xfs/xfs_trace.h>
 
 #ifndef ARRAY_SIZE
@@ -197,6 +198,11 @@ typedef struct xfs_mount {
 	xfs_dablk_t		m_dirfreeblk;	/* blockno of dirfreeindex v2 */
 } xfs_mount_t;
 
+static inline struct xfs_trans_reservations *
+m_tresp(struct xfs_mount *mp)
+{
+	return &mp->m_reservations;
+}
 
 #define LIBXFS_MOUNT_ROOTINOS		0x0001
 #define LIBXFS_MOUNT_DEBUGGER		0x0002
@@ -429,7 +435,8 @@ typedef struct xfs_trans {
 
 extern xfs_trans_t	*libxfs_trans_alloc (xfs_mount_t *, int);
 extern xfs_trans_t	*libxfs_trans_dup (xfs_trans_t *);
-extern int	libxfs_trans_reserve (xfs_trans_t *, uint,uint,uint,uint,uint);
+extern int	libxfs_trans_reserve(xfs_trans_t *, struct xfs_trans_res *,
+				     uint, uint);
 extern int	libxfs_trans_commit (xfs_trans_t *, uint);
 extern void	libxfs_trans_cancel (xfs_trans_t *, int);
 extern void	libxfs_mod_sb (xfs_trans_t *, __int64_t);
diff --git a/include/xfs_log_rlimit.h b/include/xfs_log_rlimit.h
new file mode 100644
index 0000000..3dff6f7
--- /dev/null
+++ b/include/xfs_log_rlimit.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2013 Jie Liu.
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
+#ifndef	__XFS_LOG_RLIMIT_H__
+#define __XFS_LOG_RLIMIT_H__
+
+void xfs_log_adjust_max_attrsetm_res(struct xfs_mount *);
+void xfs_log_get_max_trans_res(struct xfs_mount *, struct xfs_trans_res *);
+
+#endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 28bbf46..ee8928f 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -18,37 +18,53 @@
 #ifndef __XFS_MOUNT_H__
 #define	__XFS_MOUNT_H__
 
+struct xfs_trans_res {
+	uint	tr_logres;	/* log space unit in bytes per log ticket */
+	int	tr_logcount;	/* number of log operations per log ticket */
+	int	tr_logflags;	/* log flags, currently only used for indicating
+				 * a reservation request is permanent or not */
+};
+
 typedef struct xfs_trans_reservations {
-	uint	tr_write;	/* extent alloc trans */
-	uint	tr_itruncate;	/* truncate trans */
-	uint	tr_rename;	/* rename trans */
-	uint	tr_link;	/* link trans */
-	uint	tr_remove;	/* unlink trans */
-	uint	tr_symlink;	/* symlink trans */
-	uint	tr_create;	/* create trans */
-	uint	tr_mkdir;	/* mkdir trans */
-	uint	tr_ifree;	/* inode free trans */
-	uint	tr_ichange;	/* inode update trans */
-	uint	tr_growdata;	/* fs data section grow trans */
-	uint	tr_swrite;	/* sync write inode trans */
-	uint	tr_addafork;	/* cvt inode to attributed trans */
-	uint	tr_writeid;	/* write setuid/setgid file */
-	uint	tr_attrinval;	/* attr fork buffer invalidation */
-	uint	tr_attrsetm;    /* set/create an attribute at mount time */
-	uint	tr_attrsetrt;   /* set/create an attribute at runtime */
-	uint	tr_attrrm;	/* remove an attribute */
-	uint	tr_clearagi;	/* clear bad agi unlinked ino bucket */
-	uint	tr_growrtalloc;	/* grow realtime allocations */
-	uint	tr_growrtzero;	/* grow realtime zeroing */
-	uint	tr_growrtfree;	/* grow realtime freeing */
-	uint	tr_qm_sbchange;	/* change quota flags */
-	uint	tr_qm_setqlim;	/* adjust quota limits */
-	uint	tr_qm_dqalloc;	/* allocate quota on disk */
-	uint	tr_qm_quotaoff;	/* turn quota off */
-	uint	tr_qm_equotaoff;/* end of turn quota off */
-	uint	tr_sb;		/* modify superblock */
+	struct xfs_trans_res	tr_write;	/* extent alloc trans */
+	struct xfs_trans_res	tr_itruncate;	/* truncate trans */
+	struct xfs_trans_res	tr_rename;	/* rename trans */
+	struct xfs_trans_res	tr_link;	/* link trans */
+	struct xfs_trans_res	tr_remove;	/* unlink trans */
+	struct xfs_trans_res	tr_symlink;	/* symlink trans */
+	struct xfs_trans_res	tr_create;	/* create trans */
+	struct xfs_trans_res	tr_mkdir;	/* mkdir trans */
+	struct xfs_trans_res	tr_ifree;	/* inode free trans */
+	struct xfs_trans_res	tr_ichange;	/* inode update trans */
+	struct xfs_trans_res	tr_growdata;	/* fs data section grow trans */
+	struct xfs_trans_res	tr_swrite;	/* sync write inode trans */
+	struct xfs_trans_res	tr_addafork;	/* cvt inode to attributed
+						 * trans */
+	struct xfs_trans_res	tr_writeid;	/* write setuid/setgid file */
+	struct xfs_trans_res	tr_attrinval;	/* attr fork buffer
+						 * invalidation */
+	struct xfs_trans_res	tr_attrsetm;	/* set/create an attribute at
+						 * mount time */
+	struct xfs_trans_res	tr_attrsetrt;	/* set/create an attribute at
+						 * runtime */
+	struct xfs_trans_res	tr_attrrm;	/* remove an attribute */
+	struct xfs_trans_res	tr_clearagi;	/* clear bad agi unlinked ino
+						 * bucket */
+	struct xfs_trans_res	tr_growrtalloc;	/* grow realtime allocations */
+	struct xfs_trans_res	tr_growrtzero;	/* grow realtime zeroing */
+	struct xfs_trans_res	tr_growrtfree;	/* grow realtime freeing */
+	struct xfs_trans_res	tr_qm_sbchange;	/* change quota flags */
+	struct xfs_trans_res	tr_qm_setqlim;	/* adjust quota limits */
+	struct xfs_trans_res	tr_qm_dqalloc;	/* allocate quota on disk */
+	struct xfs_trans_res	tr_qm_quotaoff;	/* turn quota off */
+	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
+	struct xfs_trans_res	tr_sb;		/* modify superblock */
+	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
 } xfs_trans_reservations_t;
 
+#define XFS_TRANS_RES_NUM (sizeof(struct xfs_trans_reservations) / \
+			  sizeof(struct xfs_trans_res))
+
 #ifndef __KERNEL__
 
 #define xfs_daddr_to_agno(mp,d) \
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 28f71c8..53b48d1 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -16,7 +16,7 @@ CFILES = cache.c init.c kmem.c logitem.c radix-tree.c rdwr.c trans.c util.c \
 	xfs_ialloc_btree.c xfs_bmap_btree.c xfs_da_btree.c \
 	xfs_dir2.c xfs_dir2_leaf.c xfs_attr_leaf.c xfs_dir2_block.c \
 	xfs_dir2_node.c xfs_dir2_data.c xfs_dir2_sf.c xfs_bmap.c \
-	xfs_mount.c xfs_rtalloc.c xfs_trans.c xfs_attr.c \
+	xfs_mount.c xfs_rtalloc.c xfs_trans.c xfs_attr.c xfs_log_rlimit.c \
 	crc32.c
 
 CFILES += $(PKG_PLATFORM).c
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 7cb3c8c..d27553b 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -58,12 +58,10 @@ libxfs_trans_dup(
 
 int
 libxfs_trans_reserve(
-	xfs_trans_t	*tp,
-	uint		blocks,
-	uint		logspace,
-	uint		rtextents,
-	uint		flags,
-	uint		logcount)
+	xfs_trans_t		*tp,
+	struct xfs_trans_res	*tres,
+	uint			blocks,
+	uint			rtextents)
 {
 	xfs_sb_t	*mpsb = &tp->t_mountp->m_sb;
 
diff --git a/libxfs/util.c b/libxfs/util.c
index 2ad4bfd..2ae66e0 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -442,11 +442,14 @@ libxfs_alloc_file_space(
 
 	/* allocate file space until done or until there is an error */
 	while (allocatesize_fsb && !error) {
+		struct xfs_trans_res	tres;
+
 		datablocks = allocatesize_fsb;
 
 		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
 		resblks = (uint)XFS_DIOSTRAT_SPACE_RES(mp, datablocks);
-		error = xfs_trans_reserve(tp, resblks, 0, 0, 0, 0);
+		memset(&tres, 0, sizeof(tres));
+		error = xfs_trans_reserve(tp, &tres, resblks, 0);
 		if (error)
 			break;
 		xfs_trans_ijoin(tp, ip, 0);
@@ -528,11 +531,15 @@ libxfs_inode_alloc(
 	}
 
 	if (ialloc_context) {
+		struct xfs_trans_res	tres;
+
 		xfs_trans_bhold(*tp, ialloc_context);
 		ntp = xfs_trans_dup(*tp);
 		xfs_trans_commit(*tp, 0);
 		*tp = ntp;
-		if ((i = xfs_trans_reserve(*tp, 0, 0, 0, 0, 0))) {
+		memset(&tres, 0, sizeof(tres));
+		i = xfs_trans_reserve(*tp, &tres, 0, 0);
+		if (i) {
 			fprintf(stderr, _("%s: cannot reserve space: %s\n"),
 				progname, strerror(i));
 			exit(1);
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2adf92b..7a8e0ff 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -203,19 +203,20 @@ xfs_attr_calc_size(
 
 STATIC int
 xfs_attr_set_int(
-	struct xfs_inode *dp,
-	struct xfs_name	*name,
-	unsigned char	*value,
-	int		valuelen,
-	int		flags)
+	struct xfs_inode	*dp,
+	struct xfs_name		*name,
+	unsigned char		*value,
+	int			valuelen,
+	int			flags)
 {
-	xfs_da_args_t	args;
-	xfs_fsblock_t	firstblock;
-	xfs_bmap_free_t flist;
-	int		error, err2, committed;
-	xfs_mount_t	*mp = dp->i_mount;
-	int             rsvd = (flags & ATTR_ROOT) != 0;
-	int		local;
+	xfs_da_args_t		args;
+	xfs_fsblock_t		firstblock;
+	xfs_bmap_free_t		flist;
+	int			error, err2, committed;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans_res	tres;
+	int			rsvd = (flags & ATTR_ROOT) != 0;
+	int			local;
 
 	/*
 	 * Attach the dquots to the inode.
@@ -275,12 +276,11 @@ xfs_attr_set_int(
 	if (rsvd)
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-
-	error = xfs_trans_reserve(args.trans, args.total,
-				  XFS_ATTRSETM_LOG_RES(mp) +
-				  XFS_ATTRSETRT_LOG_RES(mp) * args.total,
-				  0, XFS_TRANS_PERM_LOG_RES,
-				  XFS_ATTRSET_LOG_COUNT);
+	tres.tr_logres = m_tresp(mp)->tr_attrsetm.tr_logres +
+			 m_tresp(mp)->tr_attrsetrt.tr_logres * args.total;
+	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+	error = xfs_trans_reserve(args.trans, &tres, args.total, 0);
 	if (error) {
 		xfs_trans_cancel(args.trans, 0);
 		return(error);
@@ -500,11 +500,9 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	if (flags & ATTR_ROOT)
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-	if ((error = xfs_trans_reserve(args.trans,
-				      XFS_ATTRRM_SPACE_RES(mp),
-				      XFS_ATTRRM_LOG_RES(mp),
-				      0, XFS_TRANS_PERM_LOG_RES,
-				      XFS_ATTRRM_LOG_COUNT))) {
+	error = xfs_trans_reserve(args.trans, &m_tresp(mp)->tr_attrrm,
+				  XFS_ATTRRM_SPACE_RES(mp), 0);
+	if (error) {
 		xfs_trans_cancel(args.trans, 0);
 		return(error);
 	}
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index c8232a9..8b42453 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1290,8 +1290,8 @@ xfs_bmap_add_attrfork(
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 	if (rsvd)
 		tp->t_flags |= XFS_TRANS_RESERVE;
-	if ((error = xfs_trans_reserve(tp, blks, XFS_ADDAFORK_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_ADDAFORK_LOG_COUNT)))
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_addafork, blks, 0);
+	if (error)
 		goto error0;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
new file mode 100644
index 0000000..edf96a6
--- /dev/null
+++ b/libxfs/xfs_log_rlimit.c
@@ -0,0 +1,73 @@
+/*
+ * Copyright (c) 2013 Jie Liu.
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
+#include <xfs.h>
+
+void
+xfs_log_adjust_max_attrsetm_res(
+	struct xfs_mount	*mp)
+{
+	int			size;
+	int			nblks;
+	int			res;
+
+	/*
+	 * Calculate the maximum length in bytes that would be required
+	 * for a local attribute value as large attributes out of line
+	 * are not logged.
+	 */
+	size = xfs_attr_leaf_entsize_local_max(mp->m_sb.sb_blocksize) - 1;
+	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
+	nblks += XFS_B_TO_FSB(mp, size);
+	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
+
+	res = m_tresp(mp)->tr_attrsetm.tr_logres +
+	      m_tresp(mp)->tr_attrsetrt.tr_logres * nblks;
+	mp->m_reservations.tr_attrsetm.tr_logres = res;
+}
+
+/*
+ * Iterate over the log space reservation table to figure out and return
+ * the maximum one in terms of the pre-calculated values which were done
+ * at mount time.
+ */
+void
+xfs_log_get_max_trans_res(
+	struct xfs_mount		*mp,
+	struct xfs_trans_res		*max_tresp)
+{
+	struct xfs_trans_reservations	*mtresp = m_tresp(mp);
+	struct xfs_trans_res		tres_items[XFS_TRANS_RES_NUM];
+	struct xfs_trans_res		*tresp;
+	int				i, logspace  = 0;
+
+	xfs_log_adjust_max_attrsetm_res(mp);
+
+	memcpy(tres_items, mtresp, sizeof(*mtresp));
+	for (i = 0; i < ARRAY_SIZE(tres_items); i++) {
+		struct xfs_trans_res	*p = &tres_items[i];
+		int			tmp = p->tr_logcount > 1 ?
+					      p->tr_logres * p->tr_logcount :
+					      p->tr_logres;
+		if (logspace < tmp) {
+			logspace = tmp;
+			tresp = p;
+		}
+	}
+
+	*max_tresp = *tresp;
+}
diff --git a/libxfs/xfs_trans.c b/libxfs/xfs_trans.c
index bdd0ebc..72d9e46 100644
--- a/libxfs/xfs_trans.c
+++ b/libxfs/xfs_trans.c
@@ -490,7 +490,8 @@ xfs_calc_attrsetm_reservation(
  * Since the runtime attribute transaction space is dependent on the total
  * blocks needed for the 1st bmap, here we calculate out the space unit for
  * one block so that the caller could figure out the total space according
- * to the attibute extent length in blocks by: ext * XFS_ATTRSETRT_LOG_RES(mp).
+ * to the attibute extent length in blocks by:
+ *	ext * m_tresp(mp)->tr_attrsetrt.tr_logres
  */
 STATIC uint
 xfs_calc_attrsetrt_reservation(
@@ -545,30 +546,78 @@ void
 xfs_trans_init(
 	struct xfs_mount	*mp)
 {
-	struct xfs_trans_reservations *resp = &mp->m_reservations;
-
-	resp->tr_write = xfs_calc_write_reservation(mp);
-	resp->tr_itruncate = xfs_calc_itruncate_reservation(mp);
-	resp->tr_rename = xfs_calc_rename_reservation(mp);
-	resp->tr_link = xfs_calc_link_reservation(mp);
-	resp->tr_remove = xfs_calc_remove_reservation(mp);
-	resp->tr_symlink = xfs_calc_symlink_reservation(mp);
-	resp->tr_create = xfs_calc_create_reservation(mp);
-	resp->tr_mkdir = xfs_calc_mkdir_reservation(mp);
-	resp->tr_ifree = xfs_calc_ifree_reservation(mp);
-	resp->tr_ichange = xfs_calc_ichange_reservation(mp);
-	resp->tr_growdata = xfs_calc_growdata_reservation(mp);
-	resp->tr_swrite = xfs_calc_swrite_reservation(mp);
-	resp->tr_writeid = xfs_calc_writeid_reservation(mp);
-	resp->tr_addafork = xfs_calc_addafork_reservation(mp);
-	resp->tr_attrinval = xfs_calc_attrinval_reservation(mp);
-	resp->tr_attrsetm = xfs_calc_attrsetm_reservation(mp);
-	resp->tr_attrsetrt = xfs_calc_attrsetrt_reservation(mp);
-	resp->tr_attrrm = xfs_calc_attrrm_reservation(mp);
-	resp->tr_clearagi = xfs_calc_clear_agi_bucket_reservation(mp);
-	resp->tr_growrtalloc = xfs_calc_growrtalloc_reservation(mp);
-	resp->tr_growrtzero = xfs_calc_growrtzero_reservation(mp);
-	resp->tr_growrtfree = xfs_calc_growrtfree_reservation(mp);
+	struct xfs_trans_reservations *resp = m_tresp(mp);
+
+	/*
+	 * The following transactions are logged in physical format and
+	 * require a permanent reservation on space.
+	 */
+	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp);
+	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
+	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
+	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
+	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
+	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
+	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp);
+	resp->tr_link.tr_logcount = XFS_LINK_LOG_COUNT;
+	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
+	resp->tr_remove.tr_logcount = XFS_REMOVE_LOG_COUNT;
+	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp);
+	resp->tr_symlink.tr_logcount = XFS_SYMLINK_LOG_COUNT;
+	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_create.tr_logres = xfs_calc_create_reservation(mp);
+	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
+	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
+	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
+	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
+	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
+	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_addafork.tr_logres = xfs_calc_addafork_reservation(mp);
+	resp->tr_addafork.tr_logcount = XFS_ADDAFORK_LOG_COUNT;
+	resp->tr_addafork.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_attrinval.tr_logres = xfs_calc_attrinval_reservation(mp);
+	resp->tr_attrinval.tr_logcount = XFS_ATTRINVAL_LOG_COUNT;
+	resp->tr_attrinval.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_attrsetm.tr_logres = xfs_calc_attrsetm_reservation(mp);
+	resp->tr_attrsetm.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+	resp->tr_attrsetm.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_attrrm.tr_logres = xfs_calc_attrrm_reservation(mp);
+	resp->tr_attrrm.tr_logcount = XFS_ATTRRM_LOG_COUNT;
+	resp->tr_attrrm.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_growrtalloc.tr_logres = xfs_calc_growrtalloc_reservation(mp);
+	resp->tr_growrtalloc.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
+	resp->tr_growrtalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	/* The following transaction are logged in logical format */
+	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
+	resp->tr_growdata.tr_logres = xfs_calc_growdata_reservation(mp);
+	resp->tr_swrite.tr_logres = xfs_calc_swrite_reservation(mp);
+	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
+	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
+	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
+	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
+	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
+	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
 }
 
 /*
@@ -627,7 +676,7 @@ xfs_trans_roll(
 	struct xfs_inode	*dp)
 {
 	struct xfs_trans	*trans;
-	unsigned int		logres, count;
+	struct xfs_trans_res	tres;
 	int			error;
 
 	/*
@@ -639,8 +688,9 @@ xfs_trans_roll(
 	/*
 	 * Copy the critical parameters from one trans to the next.
 	 */
-	logres = trans->t_log_res;
-	count = trans->t_log_count;
+	tres.tr_logres = trans->t_log_res;
+	tres.tr_logcount = trans->t_log_count;
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 	*tpp = xfs_trans_dup(trans);
 
 	/*
@@ -664,8 +714,7 @@ xfs_trans_roll(
 	 * across this call, or that anything that is locked be logged in
 	 * the prior and the next transactions.
 	 */
-	error = xfs_trans_reserve(trans, 0, logres, 0,
-				  XFS_TRANS_PERM_LOG_RES, count);
+	error = xfs_trans_reserve(trans, &tres, 0, 0);
 	/*
 	 *  Ensure that the inode is in the new transaction and locked.
 	 */
diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index f12cc70..c16115c 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -27,55 +27,18 @@
 #include <xfs/libxfs.h>
 #include "xfs_mkfs.h"
 
-static void
-max_attrsetm_trans_res_adjust(
-	xfs_mount_t			*mp)
-{
-	int				local;
-	int				size;
-	int				nblks;
-	int				res;
-
-	/*
-	 * Determine space the maximal sized attribute will use,
-	 * to calculate the largest reservation size needed.
-	 */
-	size = libxfs_attr_leaf_newentsize(MAXNAMELEN, 64 * 1024,
-						mp->m_sb.sb_blocksize, &local);
-	ASSERT(!local);
-	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
-	nblks += XFS_B_TO_FSB(mp, size);
-	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
-	res = XFS_ATTRSETM_LOG_RES(mp) + XFS_ATTRSETRT_LOG_RES(mp) * nblks;
-	mp->m_reservations.tr_attrsetm = res;
-}
-
-static int
-max_trans_res_by_mount(
-	xfs_mount_t			*mp)
-{
-	uint				*p;
-	int				rval;
-	xfs_trans_reservations_t	*tr = &mp->m_reservations;
-
-	for (rval = 0, p = (uint *)tr; p < (uint *)(tr + 1); p++) {
-		if ((int)*p > rval)
-			rval = (int)*p;
-	}
-	return rval;
-}
-
 int
 max_trans_res(
-	int		dirversion,
-	int		sectorlog,
-	int		blocklog,
-	int		inodelog,
-	int		dirblocklog)
+	int			dirversion,
+	int			sectorlog,
+	int			blocklog,
+	int			inodelog,
+	int			dirblocklog)
 {
-	xfs_sb_t	*sbp;
-	xfs_mount_t	mount;
-	int		maxres, maxfsb;
+	struct xfs_sb		*sbp;
+	struct xfs_mount	mount;
+	struct xfs_trans_res	tres;
+	int			maxfsb;
 
 	memset(&mount, 0, sizeof(mount));
 	sbp = &mount.m_sb;
@@ -93,16 +56,11 @@ max_trans_res(
 	sbp->sb_versionnum = XFS_SB_VERSION_4 |
 			(dirversion == 2 ? XFS_SB_VERSION_DIRV2BIT : 0);
 
-	libxfs_mount(&mount, sbp, 0,0,0,0);
-	max_attrsetm_trans_res_adjust(&mount);
-	maxres = max_trans_res_by_mount(&mount);
-	maxfsb = XFS_B_TO_FSB(&mount, maxres);
+	libxfs_mount(&mount, sbp, 0, 0, 0, 0);
+	xfs_log_adjust_max_attrsetm_res(&mount);
+	xfs_log_get_max_trans_res(&mount, &tres);
+	maxfsb = XFS_B_TO_FSB(&mount, tres.tr_logres);
 	libxfs_umount(&mount);
 
-#if 0
-	printf("#define\tMAXTRRES_S%d_B%d_I%d_D%d_V%d\t%lld\n",
-		sectorlog, blocklog, inodelog, dirblocklog, dirversion, maxfsb);
-#endif
-
 	return maxfsb;
 }
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 56eed31..6071acc 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -119,7 +119,10 @@ getres(
 
 	mp = tp->t_mountp;
 	for (i = 0, r = MKFS_BLOCKRES(blocks); r >= blocks; r--) {
-		i = libxfs_trans_reserve(tp, r, 0, 0, 0, 0);
+		struct xfs_trans_res	tres;
+
+		memset(&tres, 0, sizeof(tres));
+		i = libxfs_trans_reserve(tp, &tres, r, 0);
 		if (i == 0)
 			return;
 	}
@@ -597,31 +600,36 @@ parse_proto(
  */
 static void
 rtinit(
-	xfs_mount_t	*mp)
+	xfs_mount_t		*mp)
 {
-	xfs_dfiloff_t	bno;
-	int		committed;
-	xfs_dfiloff_t	ebno;
-	xfs_bmbt_irec_t	*ep;
-	int		error;
-	xfs_fsblock_t	first;
-	xfs_bmap_free_t	flist;
-	int		i;
-	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	xfs_extlen_t	nsumblocks;
-	int		nmap;
-	xfs_inode_t	*rbmip;
-	xfs_inode_t	*rsumip;
-	xfs_trans_t	*tp;
-	struct cred	creds;
-	struct fsxattr	fsxattrs;
+	xfs_dfiloff_t		bno;
+	int			committed;
+	xfs_dfiloff_t		ebno;
+	xfs_bmbt_irec_t		*ep;
+	int			error;
+	xfs_fsblock_t		first;
+	xfs_bmap_free_t		flist;
+	int			i;
+	xfs_bmbt_irec_t		map[XFS_BMAP_MAX_NMAP];
+	xfs_extlen_t		nsumblocks;
+	int			nmap;
+	xfs_inode_t		*rbmip;
+	xfs_inode_t		*rsumip;
+	xfs_trans_t		*tp;
+	struct cred		creds;
+	struct fsxattr		fsxattrs;
+	struct xfs_trans_res	tres;
+
+	memset(&tres, 0, sizeof(tres));
 
 	/*
 	 * First, allocate the inodes.
 	 */
 	tp = libxfs_trans_alloc(mp, 0);
-	if ((i = libxfs_trans_reserve(tp, MKFS_BLOCKRES_INODE, 0, 0, 0, 0)))
+	i = libxfs_trans_reserve(tp, &tres, MKFS_BLOCKRES_INODE, 0);
+	if (i)
 		res_failed(i);
+
 	memset(&creds, 0, sizeof(creds));
 	memset(&fsxattrs, 0, sizeof(fsxattrs));
 	error = libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
@@ -658,9 +666,11 @@ rtinit(
 	 * Next, give the bitmap file some zero-filled blocks.
 	 */
 	tp = libxfs_trans_alloc(mp, 0);
-	if ((i = libxfs_trans_reserve(tp, mp->m_sb.sb_rbmblocks +
-			(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0, 0, 0, 0)))
+	i = libxfs_trans_reserve(tp, &tres, mp->m_sb.sb_rbmblocks +
+				 (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0);
+	if (i)
 		res_failed(i);
+
 	libxfs_trans_ijoin(tp, rbmip, 0);
 	libxfs_trans_ihold(tp, rbmip);
 	bno = 0;
@@ -694,10 +704,12 @@ rtinit(
 	 */
 	tp = libxfs_trans_alloc(mp, 0);
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	if ((i = libxfs_trans_reserve(tp,
+	i = libxfs_trans_reserve(tp, &tres,
 			nsumblocks + (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1),
-			0, 0, 0, 0)))
+			0);
+	if (i)
 		res_failed(i);
+
 	libxfs_trans_ijoin(tp, rsumip, 0);
 	libxfs_trans_ihold(tp, rsumip);
 	bno = 0;
@@ -731,7 +743,8 @@ rtinit(
 	 */
 	for (bno = 0; bno < mp->m_sb.sb_rextents; bno = ebno) {
 		tp = libxfs_trans_alloc(mp, 0);
-		if ((i = libxfs_trans_reserve(tp, 0, 0, 0, 0, 0)))
+		i = libxfs_trans_reserve(tp, &tres, 0, 0);
+		if (i)
 			res_failed(i);
 		xfs_bmap_init(&flist, &first);
 		ebno = XFS_RTMIN(mp->m_sb.sb_rextents,
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a393607..350e2cb 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2685,8 +2685,9 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	 * BNO, CNT free block list
 	 */
 	for (agno = 0; agno < agcount; agno++) {
-		xfs_alloc_arg_t	args;
-		xfs_trans_t	*tp;
+		struct xfs_alloc_arg	args;
+		struct xfs_trans	*tp;
+		struct xfs_trans_res	tres;
 
 		memset(&args, 0, sizeof(args));
 		args.tp = tp = libxfs_trans_alloc(mp, 0);
@@ -2694,7 +2695,9 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		args.agno = agno;
 		args.alignment = 1;
 		args.pag = xfs_perag_get(mp,agno);
-		if ((c = libxfs_trans_reserve(tp, worst_freelist, 0, 0, 0, 0)))
+		memset(&tres, 0, sizeof(tres));
+		c = libxfs_trans_reserve(tp, &tres, worst_freelist, 0);
+		if (c)
 			res_failed(c);
 		libxfs_alloc_fix_freelist(&args, 0);
 		xfs_perag_put(args.pag);
diff --git a/repair/phase6.c b/repair/phase6.c
index 5c33797..af7fc94 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -414,26 +414,31 @@ res_failed(
 }
 
 void
-mk_rbmino(xfs_mount_t *mp)
+mk_rbmino(
+	struct xfs_mount	*mp)
 {
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	xfs_bmbt_irec_t	*ep;
-	xfs_fsblock_t	first;
-	int		i;
-	int		nmap;
-	int		committed;
-	int		error;
-	xfs_bmap_free_t	flist;
-	xfs_dfiloff_t	bno;
-	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	struct xfs_bmbt_irec	*ep;
+	xfs_fsblock_t		first;
+	int			i;
+	int			nmap;
+	int			committed;
+	int			error;
+	struct xfs_bmap_free	flist;
+	xfs_dfiloff_t		bno;
+	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	struct xfs_trans_res	tres;
+
+	memset(&tres, 0, sizeof(tres));
 
 	/*
 	 * first set up inode
 	 */
 	tp = libxfs_trans_alloc(mp, 0);
 
-	if ((i = libxfs_trans_reserve(tp, 10, 0, 0, 0, 0)))
+	i = libxfs_trans_reserve(tp, &tres, 10, 0);
+	if (i)
 		res_failed(i);
 
 	error = libxfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0, 0, &ip);
@@ -474,8 +479,9 @@ mk_rbmino(xfs_mount_t *mp)
 	 * from mkfs)
 	 */
 	tp = libxfs_trans_alloc(mp, 0);
-	if ((error = libxfs_trans_reserve(tp, mp->m_sb.sb_rbmblocks +
-			(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0, 0, 0, 0)))
+	error = libxfs_trans_reserve(tp, &tres, mp->m_sb.sb_rbmblocks +
+			(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0);
+	if (error)
 		res_failed(error);
 
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -509,24 +515,29 @@ mk_rbmino(xfs_mount_t *mp)
 }
 
 static int
-fill_rbmino(xfs_mount_t *mp)
+fill_rbmino(
+	struct xfs_mount	*mp)
 {
-	xfs_buf_t	*bp;
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	xfs_rtword_t	*bmp;
-	xfs_fsblock_t	first;
-	int		nmap;
-	int		error;
-	xfs_dfiloff_t	bno;
-	xfs_bmbt_irec_t	map;
+	struct xfs_buf		*bp;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	xfs_rtword_t		*bmp;
+	xfs_fsblock_t		first;
+	int			nmap;
+	int			error;
+	xfs_dfiloff_t		bno;
+	struct xfs_bmbt_irec	map;
+	struct xfs_trans_res	tres;
+
+	memset(&tres, 0, sizeof(tres));
 
 	bmp = btmcompute;
 	bno = 0;
 
 	tp = libxfs_trans_alloc(mp, 0);
 
-	if ((error = libxfs_trans_reserve(tp, 10, 0, 0, 0, 0)))
+	error = libxfs_trans_reserve(tp, &tres, 10, 0);
+	if (error)
 		res_failed(error);
 
 	error = libxfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0, 0, &ip);
@@ -576,18 +587,22 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 }
 
 static int
-fill_rsumino(xfs_mount_t *mp)
+fill_rsumino(
+	struct xfs_mount	*mp)
 {
-	xfs_buf_t	*bp;
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	xfs_suminfo_t	*smp;
-	xfs_fsblock_t	first;
-	int		nmap;
-	int		error;
-	xfs_dfiloff_t	bno;
-	xfs_dfiloff_t	end_bno;
-	xfs_bmbt_irec_t	map;
+	struct xfs_buf		*bp;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	xfs_suminfo_t		*smp;
+	xfs_fsblock_t		first;
+	int			nmap;
+	int			error;
+	xfs_dfiloff_t		bno;
+	xfs_dfiloff_t		end_bno;
+	struct xfs_bmbt_irec	map;
+	struct xfs_trans_res	tres;
+
+	memset(&tres, 0, sizeof(tres));
 
 	smp = sumcompute;
 	bno = 0;
@@ -595,7 +610,8 @@ fill_rsumino(xfs_mount_t *mp)
 
 	tp = libxfs_trans_alloc(mp, 0);
 
-	if ((error = libxfs_trans_reserve(tp, 10, 0, 0, 0, 0)))
+	error = libxfs_trans_reserve(tp, &tres, 10, 0);
+	if (error)
 		res_failed(error);
 
 	error = libxfs_trans_iget(mp, tp, mp->m_sb.sb_rsumino, 0, 0, &ip);
@@ -645,28 +661,30 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 }
 
 static void
-mk_rsumino(xfs_mount_t *mp)
+mk_rsumino(
+	struct xfs_mount	*mp)
 {
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	xfs_bmbt_irec_t	*ep;
-	xfs_fsblock_t	first;
-	int		i;
-	int		nmap;
-	int		committed;
-	int		error;
-	int		nsumblocks;
-	xfs_bmap_free_t	flist;
-	xfs_dfiloff_t	bno;
-	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	struct xfs_bmbt_irec	*ep;
+	xfs_fsblock_t		first;
+	int			i;
+	int			nmap;
+	int			committed;
+	int			error;
+	int			nsumblocks;
+	struct xfs_bmap_free	flist;
+	xfs_dfiloff_t		bno;
+	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	struct xfs_trans_res	tres;
 
 	/*
 	 * first set up inode
 	 */
 	tp = libxfs_trans_alloc(mp, 0);
 
-	if ((i = libxfs_trans_reserve(tp, 10, XFS_ICHANGE_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_MKDIR_LOG_COUNT)))
+	i = libxfs_trans_reserve(tp, &m_tresp(mp)->tr_ichange, 10, 0);
+	if (i)
 		res_failed(i);
 
 	error = libxfs_trans_iget(mp, tp, mp->m_sb.sb_rsumino, 0, 0, &ip);
@@ -710,11 +728,13 @@ mk_rsumino(xfs_mount_t *mp)
 	xfs_bmap_init(&flist, &first);
 
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	if ((error = libxfs_trans_reserve(tp,
-				  mp->m_sb.sb_rbmblocks +
-				      (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1),
-				  BBTOB(128), 0, XFS_TRANS_PERM_LOG_RES,
-				  XFS_DEFAULT_PERM_LOG_COUNT)))
+	tres.tr_logres = BBTOB(128);
+	tres.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+	error = libxfs_trans_reserve(tp, &tres, mp->m_sb.sb_rbmblocks +
+				     (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1),
+				     0);
+	if (error)
 		res_failed(error);
 
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -764,8 +784,8 @@ mk_root_dir(xfs_mount_t *mp)
 	tp = libxfs_trans_alloc(mp, 0);
 	ip = NULL;
 
-	if ((i = libxfs_trans_reserve(tp, 10, XFS_ICHANGE_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_MKDIR_LOG_COUNT)))
+	i = libxfs_trans_reserve(tp, &m_tresp(mp)->tr_ichange, 10, 0);
+	if (i)
 		res_failed(i);
 
 	error = libxfs_trans_iget(mp, tp, mp->m_sb.sb_rootino, 0, 0, &ip);
@@ -856,8 +876,8 @@ mk_orphanage(xfs_mount_t *mp)
 	xfs_bmap_init(&flist, &first);
 
 	nres = XFS_MKDIR_SPACE_RES(mp, xname.len);
-	if ((i = libxfs_trans_reserve(tp, nres, XFS_MKDIR_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_MKDIR_LOG_COUNT)))
+	i = libxfs_trans_reserve(tp, &m_tresp(mp)->tr_mkdir, nres, 0);
+	if (i)
 		res_failed(i);
 
 	/*
@@ -993,10 +1013,9 @@ mv_orphanage(
 		if (err) {
 			ASSERT(err == ENOENT);
 
-			if ((err = libxfs_trans_reserve(tp, nres,
-					XFS_RENAME_LOG_RES(mp), 0,
-					XFS_TRANS_PERM_LOG_RES,
-					XFS_RENAME_LOG_COUNT)))
+			err = libxfs_trans_reserve(tp, &m_tresp(mp)->tr_rename,
+						   nres, 0);
+			if (err)
 				do_error(
 	_("space reservation failed (%d), filesystem may be out of space\n"),
 					err);
@@ -1037,10 +1056,9 @@ mv_orphanage(
 			libxfs_trans_commit(tp,
 				XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
 		} else  {
-			if ((err = libxfs_trans_reserve(tp, nres,
-					XFS_RENAME_LOG_RES(mp), 0,
-					XFS_TRANS_PERM_LOG_RES,
-					XFS_RENAME_LOG_COUNT)))
+			err = libxfs_trans_reserve(tp, &m_tresp(mp)->tr_rename,
+						   nres, 0);
+			if (err)
 				do_error(
 	_("space reservation failed (%d), filesystem may be out of space\n"),
 					err);
@@ -1095,8 +1113,8 @@ mv_orphanage(
 		 * also accounted for in the create
 		 */
 		nres = XFS_DIRENTER_SPACE_RES(mp, xname.len);
-		err = libxfs_trans_reserve(tp, nres, XFS_REMOVE_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
+		err = libxfs_trans_reserve(tp, &m_tresp(mp)->tr_remove,
+					   nres, 0);
 		if (err)
 			do_error(
 	_("space reservation failed (%d), filesystem may be out of space\n"),
@@ -1191,8 +1209,7 @@ longform_dir2_rebuild(
 
 	tp = libxfs_trans_alloc(mp, 0);
 	nres = XFS_REMOVE_SPACE_RES(mp);
-	error = libxfs_trans_reserve(tp, nres, XFS_REMOVE_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
+	error = libxfs_trans_reserve(tp, &m_tresp(mp)->tr_remove, nres, 0);
 	if (error)
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -1232,8 +1249,8 @@ longform_dir2_rebuild(
 
 		tp = libxfs_trans_alloc(mp, 0);
 		nres = XFS_CREATE_SPACE_RES(mp, p->name.len);
-		error = libxfs_trans_reserve(tp, nres, XFS_CREATE_LOG_RES(mp),
-				0, XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
+		error = libxfs_trans_reserve(tp, &m_tresp(mp)->tr_create,
+					     nres, 0);
 		if (error) {
 			do_warn(
 	_("space reservation failed (%d), filesystem may be out of space\n"),
@@ -1294,8 +1311,7 @@ dir2_kill_block(
 
 	tp = libxfs_trans_alloc(mp, 0);
 	nres = XFS_REMOVE_SPACE_RES(mp);
-	error = libxfs_trans_reserve(tp, nres, XFS_REMOVE_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
+	error = libxfs_trans_reserve(tp, &m_tresp(mp)->tr_remove, nres, 0);
 	if (error)
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -1476,8 +1492,7 @@ longform_dir2_entry_check_data(
 		freetab->nents = db + 1;
 
 	tp = libxfs_trans_alloc(mp, 0);
-	error = libxfs_trans_reserve(tp, 0, XFS_REMOVE_LOG_RES(mp), 0,
-		XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
+	error = libxfs_trans_reserve(tp, &m_tresp(mp)->tr_remove, 0, 0);
 	if (error)
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -2525,10 +2540,8 @@ process_dir_inode(
 			 * new define in ourselves.
 			 */
 			nres = no_modify ? 0 : XFS_REMOVE_SPACE_RES(mp);
-			error = libxfs_trans_reserve(tp, nres,
-					XFS_REMOVE_LOG_RES(mp), 0,
-					XFS_TRANS_PERM_LOG_RES,
-					XFS_REMOVE_LOG_COUNT);
+			error = libxfs_trans_reserve(tp,
+					&m_tresp(mp)->tr_remove, nres, 0);
 			if (error)
 				res_failed(error);
 
@@ -2576,8 +2589,8 @@ process_dir_inode(
 		ASSERT(tp != NULL);
 
 		nres = XFS_MKDIR_SPACE_RES(mp, 2);
-		error = libxfs_trans_reserve(tp, nres, XFS_MKDIR_LOG_RES(mp),
-				0, XFS_TRANS_PERM_LOG_RES, XFS_MKDIR_LOG_COUNT);
+		error = libxfs_trans_reserve(tp, &m_tresp(mp)->tr_mkdir,
+					     nres, 0);
 		if (error)
 			res_failed(error);
 
@@ -2638,12 +2651,8 @@ process_dir_inode(
 			ASSERT(tp != NULL);
 
 			nres = XFS_MKDIR_SPACE_RES(mp, 1);
-			error = libxfs_trans_reserve(tp, nres,
-					XFS_MKDIR_LOG_RES(mp),
-					0,
-					XFS_TRANS_PERM_LOG_RES,
-					XFS_MKDIR_LOG_COUNT);
-
+			error = libxfs_trans_reserve(tp, &m_tresp(mp)->tr_mkdir,
+						     nres, 0);
 			if (error)
 				res_failed(error);
 
diff --git a/repair/phase7.c b/repair/phase7.c
index bd1668e..88f5345 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -71,10 +71,8 @@ update_inode_nlinks(
 
 	tp = libxfs_trans_alloc(mp, XFS_TRANS_REMOVE);
 
-	error = libxfs_trans_reserve(tp, (no_modify ? 0 : 10),
-			XFS_REMOVE_LOG_RES(mp), 0, XFS_TRANS_PERM_LOG_RES,
-			XFS_REMOVE_LOG_COUNT);
-
+	error = libxfs_trans_reserve(tp, &m_tresp(mp)->tr_remove,
+				     (no_modify ? 0 : 10), 0);
 	ASSERT(error == 0);
 
 	error = libxfs_trans_iget(mp, tp, ino, 0, 0, &ip);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
