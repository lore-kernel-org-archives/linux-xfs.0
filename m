Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdLMX6s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:58:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBDNl9Sh024432
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:47 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2eudq605j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:47 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNwkjn002372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:47 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNwkqr018577
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:46 GMT
Subject: [PATCH 05/13] xfs: verify dinode header first
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Dec 2017 15:58:43 -0800
Message-ID: <151320952356.30654.13855911861316331973.stgit@magnolia>
In-Reply-To: <151320949282.30654.14805160700975182459.stgit@magnolia>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

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
index a965448..0e4c720 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -394,6 +394,19 @@ xfs_dinode_verify(
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
@@ -410,16 +423,6 @@ xfs_dinode_verify(
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
 

