Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34626 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbdHIBGx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2017 21:06:53 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7916qYF018613
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 9 Aug 2017 01:06:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7916pTQ027287
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 9 Aug 2017 01:06:52 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7916p83022693
        for <linux-xfs@vger.kernel.org>; Wed, 9 Aug 2017 01:06:51 GMT
Date: Tue, 8 Aug 2017 18:06:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/3] xfs: don't leak linked inodes during log recovery
Message-ID: <20170809010650.GF4474@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170809010444.GR24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

When we introduced the bmap redo log items, we set MS_ACTIVE on the
mountpoint and XFS_IRECOVERY on the inode to prevent unlinked inodes
from being truncated prematurely during log recovery.  However, we
neglected to drop linked inodes that are recovered, and if we don't use
the inode between recovery and unmount, the inode will never be marked
reclaimable and thus we fail to free it at umount time.  If we're in
log recovery but IRECOVERY is /not/ set, the inode is linked and can be
reclaimed.

Fixes: 17c12bcd30 ("xfs: when replaying bmap operations, don't let unlinked inodes get reaped")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 38aaacd..9b06ca2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1040,6 +1040,13 @@ xfs_fs_drop_inode(
 	if (ip->i_flags & XFS_IRECOVERY) {
 		ASSERT(ip->i_mount->m_log->l_flags & XLOG_RECOVERY_NEEDED);
 		return 0;
+	} else if (ip->i_mount->m_log->l_flags & XLOG_RECOVERY_NEEDED) {
+		/*
+		 * This inode was loaded during recovery but is not
+		 * being unlinked, so we can free it without fear of
+		 * premature truncation.
+		 */
+		return 1;
 	}
 
 	return generic_drop_inode(inode) || (ip->i_flags & XFS_IDONTCACHE);
