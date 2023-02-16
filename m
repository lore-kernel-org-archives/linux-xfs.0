Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E7E4C636D7
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjBPU7y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjBPU7x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:59:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8F3528B7
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:59:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16CDEB829AB
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99C2C433EF;
        Thu, 16 Feb 2023 20:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581185;
        bh=2yOOOisYta9Q0oC4saoAKOx043xe1MlKQi0lmZKdib0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=i3+VcpNFQb55yfOpBw/23FIXmCXI1bbze8u2LRPoEHuBC4i9jNDWjRG6ETF/rscyq
         Rh461+pp1faWP2oVG3Q2Rxm1VlBsrjMfAGEXFapTbbRksNJIqwdnuD05mHBDIjVgtn
         Un6/NjEBa9tlPHp0jGA1EHdpsgV8a6yVU2lzVqEeLJd/K20AzCkh1DrZFXkvGG5Ygr
         ilZMD0xLDrEqwtkIC8VqHvlN30oAwHUNaX0Q1xZe+ZdyGVNMzq1LLkdxXbDIwHXEaV
         95DVSDBENF62j3ex9+CzAeHoh2GpeIEdUQrKQ0PKIYXUd4ScFCiTakfohHnHJe4Ccm
         RWMeY9S7VJRLA==
Date:   Thu, 16 Feb 2023 12:59:45 -0800
Subject: [PATCH 24/25] xfsprogs: Add parent pointers during protofile creation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879228.3476112.6635814832340093972.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Inodes created from protofile parsing will also need to add the appropriate parent
pointers

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 mkfs/proto.c |   50 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 15 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 6b6a070f..36d8cde2 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -8,6 +8,7 @@
 #include <sys/stat.h>
 #include "libfrog/convert.h"
 #include "proto.h"
+#include "xfs_parent.h"
 
 /*
  * Prototypes for internal functions.
@@ -317,18 +318,19 @@ newregfile(
 
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
@@ -381,6 +383,7 @@ parseproto(
 	struct cred	creds;
 	char		*value;
 	struct xfs_name	xname;
+	xfs_dir2_dataptr_t offset;
 
 	memset(&creds, 0, sizeof(creds));
 	mstr = getstr(pp);
@@ -464,7 +467,7 @@ parseproto(
 			free(buf);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		break;
 
 	case IF_RESERVED:			/* pre-allocated space only */
@@ -487,7 +490,7 @@ parseproto(
 		libxfs_trans_ijoin(tp, pip, 0);
 
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		libxfs_trans_log_inode(tp, ip, flags);
 		error = -libxfs_trans_commit(tp);
 		if (error)
@@ -507,7 +510,7 @@ parseproto(
 		}
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_BLKDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		flags |= XFS_ILOG_DEV;
 		break;
 
@@ -521,7 +524,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_CHRDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		flags |= XFS_ILOG_DEV;
 		break;
 
@@ -533,7 +536,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_FIFO;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		break;
 	case IF_SYMLINK:
 		buf = getstr(pp);
@@ -546,7 +549,7 @@ parseproto(
 		flags |= newfile(tp, ip, 1, 1, buf, len);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_SYMLINK;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		break;
 	case IF_DIRECTORY:
 		tp = getres(mp, 0);
@@ -563,7 +566,7 @@ parseproto(
 		} else {
 			libxfs_trans_ijoin(tp, pip, 0);
 			xname.type = XFS_DIR3_FT_DIR;
-			newdirent(mp, tp, pip, &xname, ip->i_ino);
+			newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 			inc_nlink(VFS_I(pip));
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
@@ -599,6 +602,23 @@ parseproto(
 		fail(_("Error encountered creating file from prototype file"),
 			error);
 	}
+
+	if (xfs_has_parent(mp)) {
+		struct xfs_parent_name_rec      rec;
+		struct xfs_da_args		args = {
+			.dp = ip,
+			.name = (const unsigned char *)&rec,
+			.namelen = sizeof(rec),
+			.attr_filter = XFS_ATTR_PARENT,
+			.value = (void *)xname.name,
+			.valuelen = xname.len,
+		};
+		xfs_init_parent_name_rec(&rec, pip, offset);
+		error = xfs_attr_set(&args);
+		if (error)
+			fail(_("Error creating parent pointer"), error);
+	}
+
 	libxfs_irele(ip);
 }
 

