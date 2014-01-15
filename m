Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E3E429E19
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:52 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 126E6304032
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:52 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0UrEF003616
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000851.549991275@sgi.com>
Date: Wed, 15 Jan 2014 16:00:17 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 05/17] xfs: (parent ptr) add parent pointer support to attribute
	code
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline; filename=05-pptr-add-xfs_parent-files.patch
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

Add the new parent attribute type. XFS_ATTR_PARENT is used only for
parent pointer entries; it uses reserved blocks like XFS_ATTR_ROOT.

---
 fs/xfs/xfs_attr.c      |   20 ++++++++++++--------
 fs/xfs/xfs_attr.h      |    2 ++
 fs/xfs/xfs_da_format.h |   12 ++++++++----
 fs/xfs/xfs_fs.h        |    1 +
 fs/xfs/xfs_fsops.c     |    4 +++-
 6 files changed, 65 insertions(+), 13 deletions(-)

Index: b/fs/xfs/xfs_attr.c
===================================================================
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -234,7 +234,7 @@ xfs_attr_set_int(
 	int			error, err2, committed;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	int			rsvd = (flags & ATTR_ROOT) != 0;
+	int			rsvd = (flags & (ATTR_ROOT | ATTR_PARENT)) != 0;
 	int			local;
 
 	/*
@@ -444,18 +444,22 @@ xfs_attr_set(
 	int		flags)
 {
 	int             error;
-	struct xfs_name	xname;
+	struct xfs_name	xname, *xnamep;
 
 	XFS_STATS_INC(xs_attr_set);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return (EIO);
 
-	error = xfs_attr_name_to_xname(&xname, name);
-	if (error)
-		return error;
-
-	return xfs_attr_set_int(dp, &xname, value, valuelen, flags);
+	if ((flags & ATTR_PARENT) == 0) {
+		error = xfs_attr_name_to_xname(&xname, name);
+		if (error)
+			return error;
+		xnamep = &xname;
+	} else
+		xnamep = (struct xfs_name *) name;
+	return xfs_attr_set_int(dp, xnamep, value, valuelen, flags);
+					
 }
 
 /*
@@ -516,7 +520,7 @@ xfs_attr_remove_int(xfs_inode_t *dp, str
 	 * operation if necessary
 	 */
 
-	if (flags & ATTR_ROOT)
+	if (flags & (ATTR_ROOT | ATTR_PARENT))
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
 	error = xfs_trans_reserve(args.trans, &M_RES(mp)->tr_attrrm,
Index: b/fs/xfs/xfs_attr.h
===================================================================
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -44,6 +44,7 @@ struct xfs_attr_list_context;
 #define ATTR_SECURE	0x0008	/* use attrs in security namespace */
 #define ATTR_CREATE	0x0010	/* pure create: fail if attr already exists */
 #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
+#define ATTR_PARENT	0x0040	/*  use attrs in parent namespace */
 
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
 #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
@@ -55,6 +56,7 @@ struct xfs_attr_list_context;
 	{ ATTR_SECURE,		"SECURE" }, \
 	{ ATTR_CREATE,		"CREATE" }, \
 	{ ATTR_REPLACE,		"REPLACE" }, \
+	{ ATTR_PARENT,		"PARENT" }, \
 	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
 	{ ATTR_KERNOVAL,	"KERNOVAL" }
 
Index: b/fs/xfs/xfs_da_format.h
===================================================================
--- a/fs/xfs/xfs_da_format.h
+++ b/fs/xfs/xfs_da_format.h
@@ -895,24 +895,28 @@ struct xfs_attr3_icleaf_hdr {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define XFS_ATTR_PARENT_BIT	3	/* parent pointer secure attrs */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1 << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1 << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1 << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTR_PARENT		(1 << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_INCOMPLETE	(1 << XFS_ATTR_INCOMPLETE_BIT)
 
 /*
  * Conversion macros for converting namespace bits from argument flags
  * to ondisk flags.
  */
-#define XFS_ATTR_NSP_ARGS_MASK		(ATTR_ROOT | ATTR_SECURE)
-#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
+#define XFS_ATTR_NSP_ARGS_MASK		(ATTR_ROOT | ATTR_SECURE | XFS_ATTR_PARENT)
+#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
 #define XFS_ATTR_NSP_ONDISK(flags)	((flags) & XFS_ATTR_NSP_ONDISK_MASK)
 #define XFS_ATTR_NSP_ARGS(flags)	((flags) & XFS_ATTR_NSP_ARGS_MASK)
 #define XFS_ATTR_NSP_ARGS_TO_ONDISK(x)	(((x) & ATTR_ROOT ? XFS_ATTR_ROOT : 0) |\
-					 ((x) & ATTR_SECURE ? XFS_ATTR_SECURE : 0))
+					 ((x) & ATTR_SECURE ? XFS_ATTR_SECURE : 0) | \
+					 ((x) & ATTR_PARENT ? XFS_ATTR_PARENT : 0))
 #define XFS_ATTR_NSP_ONDISK_TO_ARGS(x)	(((x) & XFS_ATTR_ROOT ? ATTR_ROOT : 0) |\
-					 ((x) & XFS_ATTR_SECURE ? ATTR_SECURE : 0))
+					 ((x) & XFS_ATTR_SECURE ? ATTR_SECURE : 0) | \
+					 ((x) & XFS_ATTR_PARENT ? ATTR_PARENT : 0))
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
Index: b/fs/xfs/xfs_fs.h
===================================================================
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -238,6 +238,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
 #define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
 #define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	0x20000	/* parent inode support */
 
 /*
  * Minimum and maximum sizes need for growth checks.
Index: b/fs/xfs/xfs_fsops.c
===================================================================
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -104,7 +104,9 @@ xfs_fs_geometry(
 			(xfs_sb_version_hascrc(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_V5SB : 0) |
 			(xfs_sb_version_hasftype(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_FTYPE : 0);
+				XFS_FSOP_GEOM_FLAGS_FTYPE : 0) |
+			(xfs_sb_version_hasparent(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_PARENT : 0);
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
