Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42028 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH1SRE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 14:17:04 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7SIH3F4010640
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7SIH2Hh028791
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:03 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7SIH2wn016211
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:02 GMT
Subject: [PATCH 05/12] xfs: verify dinode header first
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 28 Aug 2017 11:17:01 -0700
Message-ID: <150394422155.24826.5926842859371271529.stgit@magnolia>
In-Reply-To: <150394418979.24826.12970283067445908653.stgit@magnolia>
References: <150394418979.24826.12970283067445908653.stgit@magnolia>
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
 

