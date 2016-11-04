Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46888 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934946AbcKDSbz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 14:31:55 -0400
Subject: [PATCH 2/6] libxfs: synchronize dinode_verify with userspace
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 11:31:49 -0700
Message-ID: <147828430980.31793.9062149848276522086.stgit@birch.djwong.org>
In-Reply-To: <147828429514.31793.3070284385118900515.stgit@birch.djwong.org>
References: <147828429514.31793.3070284385118900515.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

The userspace version of _dinode_verify takes a raw inode number
instead of an inode itself.  Since neither version actually needs
the inode, port the changes to the kernel.  This will also reduce
the libxfs diff noise.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 134424f..3a6694b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -380,10 +380,10 @@ xfs_log_dinode_to_disk(
 	}
 }
 
-static bool
+bool
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
-	struct xfs_inode	*ip,
+	xfs_ino_t		ino,
 	struct xfs_dinode	*dip)
 {
 	uint16_t		flags;
@@ -401,7 +401,7 @@ xfs_dinode_verify(
 	if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
 			      XFS_DINODE_CRC_OFF))
 		return false;
-	if (be64_to_cpu(dip->di_ino) != ip->i_ino)
+	if (be64_to_cpu(dip->di_ino) != ino)
 		return false;
 	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
@@ -493,7 +493,7 @@ xfs_iread(
 		return error;
 
 	/* even unallocated inodes are verified */
-	if (!xfs_dinode_verify(mp, ip, dip)) {
+	if (!xfs_dinode_verify(mp, ip->i_ino, dip)) {
 		xfs_alert(mp, "%s: validation failed for inode %lld failed",
 				__func__, ip->i_ino);
 

