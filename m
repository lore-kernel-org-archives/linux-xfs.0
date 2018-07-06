Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40572 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753851AbeGFDMv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 23:12:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w66395ij147717
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:12:50 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2k0dnjqymb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 03:12:50 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w663Cove017285
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:12:50 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w663CnNk006327
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:12:49 GMT
From: Shan Hai <shan.hai@oracle.com>
Subject: [PATCH RFC 6/8] xfs: fix imbalanced locking
Date: Fri,  6 Jul 2018 11:12:27 +0800
Message-Id: <1530846750-6686-7-git-send-email-shan.hai@oracle.com>
In-Reply-To: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The XFS_ILOCK_SHARED type lock is held in the xfs_ioc_fsgetxattr
but does not released when the inode is in local format, fix it by
eleasing the lock on the local format inode.

Signed-off-by: Shan Hai <shan.hai@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0ef5ece5634c..246562615ccd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -907,7 +907,10 @@ xfs_ioc_fsgetxattr(
 	} else {
 		if (ip->i_df.if_flags & XFS_IFEXTENTS)
 			fa.fsx_nextents = xfs_iext_count(&ip->i_df);
-		else
+		else if (ip->i_df.if_flags & XFS_IFINLINE) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			return 0;
+		} else
 			fa.fsx_nextents = ip->i_d.di_nextents;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-- 
2.11.0

