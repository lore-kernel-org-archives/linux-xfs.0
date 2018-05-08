Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33558 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbeEHEnd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 00:43:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w484fuJD066767
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:32 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2hs426eur2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 04:43:32 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w484hVHV016018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:31 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w484hVZF029389
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:31 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 20/21] xfsprogs: Add parent pointers during protofile creation
Date: Mon,  7 May 2018 21:41:18 -0700
Message-Id: <1525754479-12177-21-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 mkfs/proto.c         | 59 ++++++++++++++++++++++++++++++++++------------------
 repair/attr_repair.c | 16 ++------------
 repair/phase6.c      | 47 +++++++++++++++++++++++++----------------
 3 files changed, 70 insertions(+), 52 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 67c228a..3e4fd33 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -19,6 +19,7 @@
 #include "libxfs.h"
 #include <sys/stat.h>
 #include "xfs_multidisk.h"
+#include "xfs_parent.h"
 
 /*
  * Prototypes for internal functions.
@@ -318,23 +319,25 @@ newregfile(
 
 static void
 newdirent(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_inode_t	*pip,
-	struct xfs_name	*name,
-	xfs_ino_t	inum,
-	xfs_fsblock_t	*first,
-	struct xfs_defer_ops	*dfops)
+	xfs_mount_t		*mp,
+	xfs_trans_t		*tp,
+	xfs_inode_t		*pip,
+	struct xfs_name		*name,
+	struct xfs_inode	*ip,
+	xfs_fsblock_t		*first,
+	struct xfs_defer_ops	*dfops,
+	xfs_dir2_dataptr_t      *offset)
 {
-	int	error;
-	int	rsv;
+	int			error;
+	int			rsv;
 
 	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
-	error = -libxfs_dir_createname(tp, pip, name, inum, first, dfops, rsv,
-				       NULL);
+	error = -libxfs_dir_createname(tp, pip, name, ip->i_ino, first, dfops, rsv,
+				       offset);
 	if (error)
 		fail(_("directory createname error"), error);
+
 }
 
 static void
@@ -387,6 +390,7 @@ parseproto(
 	cred_t		creds;
 	char		*value;
 	struct xfs_name	xname;
+	xfs_dir2_dataptr_t offset;
 
 	memset(&creds, 0, sizeof(creds));
 	mstr = getstr(pp);
@@ -470,7 +474,7 @@ parseproto(
 			free(buf);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
+		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
 		break;
 
 	case IF_RESERVED:			/* pre-allocated space only */
@@ -493,7 +497,7 @@ parseproto(
 		libxfs_trans_ijoin(tp, pip, 0);
 
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
+		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
 		libxfs_trans_log_inode(tp, ip, flags);
 
 		libxfs_defer_ijoin(&dfops, ip);
@@ -516,7 +520,7 @@ parseproto(
 		}
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_BLKDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
+		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
 		flags |= XFS_ILOG_DEV;
 		break;
 
@@ -530,7 +534,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_CHRDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
+		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
 		flags |= XFS_ILOG_DEV;
 		break;
 
@@ -542,7 +546,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_FIFO;
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
+		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
 		break;
 	case IF_SYMLINK:
 		buf = getstr(pp);
@@ -555,7 +559,7 @@ parseproto(
 		flags |= newfile(tp, ip, &dfops, &first, 1, 1, buf, len);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_SYMLINK;
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
+		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
 		break;
 	case IF_DIRECTORY:
 		tp = getres(mp, 0);
@@ -572,8 +576,8 @@ parseproto(
 		} else {
 			libxfs_trans_ijoin(tp, pip, 0);
 			xname.type = XFS_DIR3_FT_DIR;
-			newdirent(mp, tp, pip, &xname, ip->i_ino,
-				  &first, &dfops);
+			newdirent(mp, tp, pip, &xname, ip,
+				  &first, &dfops, &offset);
 			inc_nlink(VFS_I(pip));
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
@@ -612,8 +616,23 @@ parseproto(
 		fail(_("Error encountered creating file from prototype file"),
 			error);
 	}
-	libxfs_trans_commit(tp);
+        libxfs_trans_commit(tp);
+
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		error = xfs_parent_add(tp, pip, ip, &xname, offset, &first, &dfops);
+		if (error)
+			fail(_("Error creating parent pointer"), error);
+
+		libxfs_trans_log_inode(tp, ip, flags);
+		libxfs_defer_ijoin(&dfops, ip);
+		error = -libxfs_defer_finish(&tp, &dfops);
+		if (error)
+			fail(_("Directory creation failed"), error);
+		libxfs_trans_commit(tp);
+	}
+
 	IRELE(ip);
+	
 }
 
 void
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 8b1b8a7..e5ff3b0 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -305,16 +305,6 @@ process_shortform_attr(
 			}
 		}
 
-		/* namecheck checks for / and null terminated for file names.
-		 * attributes names currently follow the same rules.
-		*/
-		if (namecheck((char *)&currententry->nameval[0],
-						currententry->namelen))  {
-			do_warn(
-	_("entry contains illegal character in shortform attribute name\n"));
-			junkit = 1;
-		}
-
 		if (currententry->flags & XFS_ATTR_INCOMPLETE) {
 			do_warn(
 	_("entry has INCOMPLETE flag on in shortform attribute\n"));
@@ -470,8 +460,7 @@ process_leaf_attr_local(
 	xfs_attr_leaf_name_local_t *local;
 
 	local = xfs_attr3_leaf_name_local(leaf, i);
-	if (local->namelen == 0 || namecheck((char *)&local->nameval[0],
-							local->namelen)) {
+	if (local->namelen == 0) {
 		do_warn(
 	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
 			i, da_bno, ino, local->namelen);
@@ -525,8 +514,7 @@ process_leaf_attr_remote(
 
 	remotep = xfs_attr3_leaf_name_remote(leaf, i);
 
-	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0],
-						remotep->namelen) ||
+	if (remotep->namelen == 0 ||
 			be32_to_cpu(entry->hashval) !=
 				libxfs_da_hashname((unsigned char *)&remotep->name[0],
 						remotep->namelen) ||
diff --git a/repair/phase6.c b/repair/phase6.c
index 4fedb35..b861b3b 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -29,6 +29,7 @@
 #include "dinode.h"
 #include "progress.h"
 #include "versions.h"
+#include "xfs_parent.h"
 
 static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
@@ -962,19 +963,20 @@ mk_root_dir(xfs_mount_t *mp)
 static xfs_ino_t
 mk_orphanage(xfs_mount_t *mp)
 {
-	xfs_ino_t	ino;
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	xfs_inode_t	*pip;
-	xfs_fsblock_t	first;
-	ino_tree_node_t	*irec;
-	int		ino_offset = 0;
-	int		i;
-	int		error;
+	xfs_ino_t		ino;
+	xfs_trans_t		*tp;
+	xfs_inode_t		*ip;
+	xfs_inode_t		*pip;
+	xfs_fsblock_t		first;
+	ino_tree_node_t		*irec;
+	int			ino_offset = 0;
+	int			i;
+	int			error;
 	struct xfs_defer_ops	dfops;
-	const int	mode = 0755;
-	int		nres;
-	struct xfs_name	xname;
+	const int		mode = 0755;
+	int			nres;
+	struct xfs_name		xname;
+	xfs_dir2_dataptr_t      offset;
 
 	/*
 	 * check for an existing lost+found first, if it exists, return
@@ -1061,7 +1063,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 * create the actual entry
 	 */
 	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, &first,
-					&dfops, nres, NULL);
+					&dfops, nres, &offset);
 	if (error)
 		do_error(
 		_("can't make %s, createname error %d\n"),
@@ -1089,6 +1091,14 @@ mk_orphanage(xfs_mount_t *mp)
 			ORPHANAGE, error);
 	}
 
+        libxfs_trans_commit(tp);
+        if (xfs_sb_version_hasparent(&mp->m_sb)) {
+                error = xfs_parent_add(tp, pip, ip, &xname, offset,
+				       &first, &dfops);
+                if (error)
+                        do_error(_("Error creating parent pointer: %d\n"),
+				 error);
+        }
 
 	libxfs_trans_commit(tp);
 	IRELE(ip);
@@ -1120,6 +1130,7 @@ mv_orphanage(
 	ino_tree_node_t		*irec;
 	int			ino_offset = 0;
 	struct xfs_name		xname;
+	xfs_dir2_dataptr_t      offset;
 
 	xname.name = fname;
 	xname.len = snprintf((char *)fname, sizeof(fname), "%llu",
@@ -1170,7 +1181,7 @@ mv_orphanage(
 
 			libxfs_defer_init(&dfops, &first);
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, &first, &dfops, nres, NULL);
+						ino, &first, &dfops, nres, &offset);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d), filesystem may be out of space\n"),
@@ -1183,7 +1194,7 @@ mv_orphanage(
 			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
 
 			err = -libxfs_dir_createname(tp, ino_p, &xfs_name_dotdot,
-					orphanage_ino, &first, &dfops, nres, NULL);
+					orphanage_ino, &first, &dfops, nres, &offset);
 			if (err)
 				do_error(
 	_("creation of .. entry failed (%d), filesystem may be out of space\n"),
@@ -1214,7 +1225,7 @@ mv_orphanage(
 			libxfs_defer_init(&dfops, &first);
 
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, &first, &dfops, nres, NULL);
+						ino, &first, &dfops, nres, &offset);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d), filesystem may be out of space\n"),
@@ -1233,7 +1244,7 @@ mv_orphanage(
 			if (entry_ino_num != orphanage_ino)  {
 				err = -libxfs_dir_replace(tp, ino_p,
 						&xfs_name_dotdot, orphanage_ino,
-						&first, &dfops, nres, NULL);
+						&first, &dfops, nres, &offset);
 				if (err)
 					do_error(
 	_("name replace op failed (%d), filesystem may be out of space\n"),
@@ -1270,7 +1281,7 @@ mv_orphanage(
 
 		libxfs_defer_init(&dfops, &first);
 		err = -libxfs_dir_createname(tp, orphanage_ip, &xname, ino,
-						&first, &dfops, nres, NULL);
+						&first, &dfops, nres, &offset);
 		if (err)
 			do_error(
 	_("name create failed in %s (%d), filesystem may be out of space\n"),
-- 
2.7.4

