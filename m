Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48789 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753345AbdHQXcE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 19:32:04 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7HNW3Vl027321
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:32:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7HNW39a007902
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:32:03 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7HNW3cs022683
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:32:03 GMT
Subject: [PATCH 05/12] xfs: verify dinode header first
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 17 Aug 2017 16:32:01 -0700
Message-ID: <150301272119.5851.1856081901024907802.stgit@magnolia>
In-Reply-To: <150301268960.5851.2513223883233763065.stgit@magnolia>
References: <150301268960.5851.2513223883233763065.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the v3 inode integrity information (crc, owner, metauuid) before we
look at anything else in the inode so that we don't waste time on a torn
write or a totally garbled block.  This makes xfs_dinode_verify more
consistent with the other verifiers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a5bcf2b..b2423a3 100644
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
 

