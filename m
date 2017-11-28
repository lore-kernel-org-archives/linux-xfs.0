Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16929 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752361AbdK1Rj7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 12:39:59 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vASHdwXA014746
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 17:39:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vASHdwE6024781
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 17:39:58 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vASHdwF3031324
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 17:39:58 GMT
Subject: [PATCH 1/3] xfs: ubsan fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 28 Nov 2017 09:39:56 -0800
Message-ID: <151189079681.14861.10709810493861130558.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix some complaints from the UBSAN about signed integer addition overflows.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a3eeaba..b0cccf8 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -399,7 +399,7 @@ xfs_map_blocks(
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
 	ASSERT(offset <= mp->m_super->s_maxbytes);
 
-	if (offset + count > mp->m_super->s_maxbytes)
+	if ((xfs_ufsize_t)offset + count > mp->m_super->s_maxbytes)
 		count = mp->m_super->s_maxbytes - offset;
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
@@ -1265,7 +1265,7 @@ xfs_map_trim_size(
 	if (mapping_size > size)
 		mapping_size = size;
 	if (offset < i_size_read(inode) &&
-	    offset + mapping_size >= i_size_read(inode)) {
+	    (xfs_ufsize_t)offset + mapping_size >= i_size_read(inode)) {
 		/* limit mapping to block that spans EOF */
 		mapping_size = roundup_64(i_size_read(inode) - offset,
 					  i_blocksize(inode));
@@ -1312,7 +1312,7 @@ xfs_get_blocks(
 	lockmode = xfs_ilock_data_map_shared(ip);
 
 	ASSERT(offset <= mp->m_super->s_maxbytes);
-	if (offset + size > mp->m_super->s_maxbytes)
+	if ((xfs_ufsize_t)offset + size > mp->m_super->s_maxbytes)
 		size = mp->m_super->s_maxbytes - offset;
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);

