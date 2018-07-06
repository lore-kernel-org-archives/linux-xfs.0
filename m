Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40756 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753851AbeGFDMw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 23:12:52 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6638u5s176344
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:12:52 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2k0dnjg04y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 03:12:51 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w663Cpqs006484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:12:51 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w663CoZm005091
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:12:51 GMT
From: Shan Hai <shan.hai@oracle.com>
Subject: [PATCH RFC 7/8] xfs: return non-zero blocks for inline data
Date: Fri,  6 Jul 2018 11:12:28 +0800
Message-Id: <1530846750-6686-8-git-send-email-shan.hai@oracle.com>
In-Reply-To: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Return non-zero blocks for inline data even though the inode has
no external blocks, otherwise the "ls -ls" would show zero blocks
occupied by the file.

Signed-off-by: Shan Hai <shan.hai@oracle.com>
---
 fs/xfs/xfs_iops.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0fa29f39d658..63be1355a473 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -500,8 +500,14 @@ xfs_vn_getattr(
 	stat->atime = inode->i_atime;
 	stat->mtime = inode->i_mtime;
 	stat->ctime = inode->i_ctime;
-	stat->blocks =
+
+	if (xfs_sb_version_hasinlinedata(&mp->m_sb) &&
+		XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) == XFS_DINODE_FMT_LOCAL) {
+			stat->blocks = BTOBB(XFS_ISIZE(ip));
+	} else {
+		stat->blocks =
 		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
+	}
 
 	if (ip->i_d.di_version == 3) {
 		if (request_mask & STATX_BTIME) {
-- 
2.11.0

