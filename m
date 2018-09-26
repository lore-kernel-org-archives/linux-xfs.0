Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55474 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbeIZQiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANnhB087712
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:52 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mndpphh7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:52 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPqxo005015
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:52 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPqvI018452
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:52 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 28/30] xfsprogs: Add parent pointers during protofile creation
Date: Wed, 26 Sep 2018 03:23:31 -0700
Message-Id: <1537957413-10630-29-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Inodes created from protofile parsing will also need to
add the appropriate parent pointers

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 mkfs/proto.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index a0b2003..0d8c229 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -7,6 +7,7 @@
 #include "libxfs.h"
 #include <sys/stat.h>
 #include "xfs_multidisk.h"
+#include "xfs_parent.h"
 
 /*
  * Prototypes for internal functions.
@@ -303,18 +304,19 @@ newregfile(
 
 static void
 newdirent(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_inode_t	*pip,
-	struct xfs_name	*name,
-	xfs_ino_t	inum)
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*pip,
+	struct xfs_name		*name,
+	xfs_ino_t		inum,
+	xfs_dir2_dataptr_t      *offset)
 {
-	int	error;
-	int	rsv;
+	int			error;
+	int			rsv;
 
 	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
-	error = -libxfs_dir_createname(tp, pip, name, inum, rsv, NULL);
+	error = -libxfs_dir_createname(tp, pip, name, inum, rsv, offset);
 	if (error)
 		fail(_("directory createname error"), error);
 }
@@ -351,7 +353,6 @@ parseproto(
 
 	char		*buf;
 	int		error;
-	xfs_fsblock_t	first;
 	int		flags;
 	int		fmt;
 	int		i;
@@ -368,6 +369,7 @@ parseproto(
 	cred_t		creds;
 	char		*value;
 	struct xfs_name	xname;
+	xfs_dir2_dataptr_t offset;
 
 	memset(&creds, 0, sizeof(creds));
 	mstr = getstr(pp);
@@ -450,7 +452,7 @@ parseproto(
 			free(buf);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		break;
 
 	case IF_RESERVED:			/* pre-allocated space only */
@@ -473,7 +475,7 @@ parseproto(
 		libxfs_trans_ijoin(tp, pip, 0);
 
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		libxfs_trans_log_inode(tp, ip, flags);
 		libxfs_trans_commit(tp);
 		rsvfile(mp, ip, llen);
@@ -491,7 +493,7 @@ parseproto(
 		}
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_BLKDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		flags |= XFS_ILOG_DEV;
 		break;
 
@@ -505,7 +507,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_CHRDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		flags |= XFS_ILOG_DEV;
 		break;
 
@@ -517,7 +519,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_FIFO;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		break;
 	case IF_SYMLINK:
 		buf = getstr(pp);
@@ -530,7 +532,7 @@ parseproto(
 		flags |= newfile(tp, ip, 1, 1, buf, len);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_SYMLINK;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		break;
 	case IF_DIRECTORY:
 		tp = getres(mp, 0);
@@ -547,7 +549,7 @@ parseproto(
 		} else {
 			libxfs_trans_ijoin(tp, pip, 0);
 			xname.type = XFS_DIR3_FT_DIR;
-			newdirent(mp, tp, pip, &xname, ip->i_ino);
+			newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 			inc_nlink(VFS_I(pip));
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
@@ -577,6 +579,13 @@ parseproto(
 	}
 	libxfs_trans_log_inode(tp, ip, flags);
 	libxfs_trans_commit(tp);
+
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		error = xfs_parent_add(pip, ip, &xname, offset);
+		if (error)
+			fail(_("Error creating parent pointer"), error);
+	}
+
 	IRELE(ip);
 }
 
-- 
2.7.4
