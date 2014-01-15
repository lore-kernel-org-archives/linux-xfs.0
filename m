Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5B52A29E1C
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 411C5304032
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:53 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0Uspk003652
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:54 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000852.405366459@sgi.com>
Date: Wed, 15 Jan 2014 16:00:26 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 14/17] xfsprogs: add parent pointer values to headers and fix
	repair
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline; filename=02-xfsprogs-pptr-fix-namecheck.patch
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

Add the parent inode information to the header files.

Make sure that xfs_repair does not think the non-printable
values in parent pointer extended attribute type is an
indication of a corrupted extened attribute entry.

---
 include/libxfs.h        |    1 +
 include/xfs_da_format.h |   12 ++++++++----
 libxfs/xfs.h            |    1 +
 repair/attr_repair.c    |   18 +++++++++++-------
 4 files changed, 21 insertions(+), 11 deletions(-)

Index: b/include/libxfs.h
===================================================================
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -603,6 +603,7 @@ typedef struct xfs_inode {
 #define LIBXFS_ATTR_SECURE	0x0008	/* use attrs in security namespace */
 #define LIBXFS_ATTR_CREATE	0x0010	/* create, but fail if attr exists */
 #define LIBXFS_ATTR_REPLACE	0x0020	/* set, but fail if attr not exists */
+#define LIBXFS_ATTR_PARENT	0x0040	/* parent pointer entry */
 
 /*
  * Project quota id helpers (previously projid was 16bit only and using two
Index: b/include/xfs_da_format.h
===================================================================
--- a/include/xfs_da_format.h
+++ b/include/xfs_da_format.h
@@ -1242,24 +1242,28 @@ struct xfs_attr3_icleaf_hdr {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer entry */
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
+#define XFS_ATTR_NSP_ARGS_MASK		(ATTR_ROOT | ATTR_SECURE | ATTR_PARENT)
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
Index: b/libxfs/xfs.h
===================================================================
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -97,6 +97,7 @@ typedef struct xfs_bmalloca {
 #define ATTR_SECURE			LIBXFS_ATTR_SECURE
 #define ATTR_CREATE			LIBXFS_ATTR_CREATE
 #define ATTR_REPLACE			LIBXFS_ATTR_REPLACE
+#define ATTR_PARENT			LIBXFS_ATTR_PARENT
 #define ATTR_KERNOTIME			0
 #define ATTR_KERNOVAL			0
 
Index: b/repair/attr_repair.c
===================================================================
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -17,6 +17,7 @@
  */
 
 #include <libxfs.h>
+#include <xfs_attr_leaf.h>
 #include "globals.h"
 #include "err_protos.h"
 #include "attr_repair.h"
@@ -880,7 +881,8 @@ process_shortform_attr(
 		/* namecheck checks for / and null terminated for file names.
 		 * attributes names currently follow the same rules.
 		*/
-		if (namecheck((char *)&currententry->nameval[0],
+		if (!(currententry->flags & XFS_ATTR_PARENT) &&
+		     namecheck((char *)&currententry->nameval[0],
 						currententry->namelen))  {
 			do_warn(
 	_("entry contains illegal character in shortform attribute name\n"));
@@ -1026,8 +1028,9 @@ process_leaf_attr_local(
 	xfs_attr_leaf_name_local_t *local;
 
 	local = xfs_attr3_leaf_name_local(leaf, i);
-	if (local->namelen == 0 || namecheck((char *)&local->nameval[0], 
-							local->namelen)) {
+	if (local->namelen == 0 ||
+	     (!(entry->flags & XFS_ATTR_PARENT) &&
+	      namecheck((char *)&local->nameval[0], local->namelen))) {
 		do_warn(
 	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
 			i, da_bno, ino, local->namelen);
@@ -1081,10 +1084,11 @@ process_leaf_attr_remote(
 
 	remotep = xfs_attr3_leaf_name_remote(leaf, i);
 
-	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0], 
-						remotep->namelen) || 
-			be32_to_cpu(entry->hashval) != 
-				libxfs_da_hashname((uchar_t *)&remotep->name[0], 
+	if (remotep->namelen == 0 ||
+	    (!(entry->flags & XFS_ATTR_PARENT) &&
+	     namecheck((char *)&remotep->name[0],remotep->namelen)) ||
+	     be32_to_cpu(entry->hashval) != 
+				libxfs_da_hashname((uchar_t *)&remotep->name[0],
 						remotep->namelen) ||
 			be32_to_cpu(entry->hashval) < last_hashval ||
 			be32_to_cpu(remotep->valueblk) == 0) {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
