Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757161AbdLWBOR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:14:17 -0500
Subject: [PATCH 08/20] xfs: verify dinode header first
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:07:54 -0800
Message-ID: <151399127486.23543.4157032277601027971.stgit@magnolia>
In-Reply-To: <151399122361.23543.15718507168231759645.stgit@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the v3 inode integrity information (crc, owner, metauuid) before we
look at anything else in the inode so that we don't waste time on a torn
write or a totally garbled block.  This makes xfs_dinode_verify more
consistent with the other verifiers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a43a370..a1ba112 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -393,6 +393,19 @@ xfs_dinode_verify(
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
 
+	/* Verify v3 integrity information first */
+	if (dip->di_version >= 3) {
+		if (!xfs_sb_version_hascrc(&mp->m_sb))
+			return __this_address;
+		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
+				      XFS_DINODE_CRC_OFF))
+			return __this_address;
+		if (be64_to_cpu(dip->di_ino) != ino)
+			return __this_address;
+		if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
+			return __this_address;
+	}
+
 	/* don't allow invalid i_size */
 	if (be64_to_cpu(dip->di_size) & (1ULL << 63))
 		return __this_address;
@@ -409,16 +422,6 @@ xfs_dinode_verify(
 	if (dip->di_version < 3)
 		return NULL;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return __this_address;
-	if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
-			      XFS_DINODE_CRC_OFF))
-		return __this_address;
-	if (be64_to_cpu(dip->di_ino) != ino)
-		return __this_address;
-	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
-		return __this_address;
-
 	flags = be16_to_cpu(dip->di_flags);
 	flags2 = be64_to_cpu(dip->di_flags2);
 

