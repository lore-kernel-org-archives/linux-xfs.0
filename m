Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33159 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbdHIBEr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2017 21:04:47 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7914jSe015659
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 9 Aug 2017 01:04:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7914jcq021015
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 9 Aug 2017 01:04:45 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7914jAp011081
        for <linux-xfs@vger.kernel.org>; Wed, 9 Aug 2017 01:04:45 GMT
Date: Tue, 8 Aug 2017 18:04:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/3] xfs: clear MS_ACTIVE after finishing log recovery to
 avoid inode leak
Message-ID: <20170809010444.GR24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Way back when we established inode block-map redo log items, it was
discovered that we needed to prevent the VFS from evicting inodes during
log recovery because any given inode might be have bmap redo items to
replay even if the inode has no link count and is ultimately deleted,
and any eviction of an unlinked inode causes the inode to be truncated
and freed too early.

To make this possible, we set MS_ACTIVE so that inodes would not be torn
down immediately upon release.  Unfortunately, this also results in the
quota inodes not being released at all if a later part of the mount
process should fail, because we never reclaim the inodes.  So, clear
MS_ACTIVE immediately after we finish the log recovery so that the quota
inodes will be torn down properly if we abort the mount.

Fixes: 17c12bcd30 ("xfs: when replaying bmap operations, don't let unlinked inodes get reaped")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 40d4e8b..d463ab3 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -949,7 +949,9 @@ xfs_mountfs(
 	 * iput to behave like they do for an active filesystem.
 	 * xfs_fs_drop_inode needs to be able to prevent the deletion
 	 * of inodes before we're done replaying log items on those
-	 * inodes.
+	 * inodes.  Turn it off immediately after xfs_log_mount_finish
+	 * so that we don't leak the quota inodes if subsequent mount
+	 * activities fail.
 	 */
 	mp->m_super->s_flags |= MS_ACTIVE;
 
@@ -959,6 +961,7 @@ xfs_mountfs(
 	 * read in.
 	 */
 	error = xfs_log_mount_finish(mp);
+	mp->m_super->s_flags &= ~MS_ACTIVE;
 	if (error) {
 		xfs_warn(mp, "log mount finish failed");
 		goto out_rtunmount;
@@ -1028,7 +1031,6 @@ xfs_mountfs(
  out_quota:
 	xfs_qm_unmount_quotas(mp);
  out_rtunmount:
-	mp->m_super->s_flags &= ~MS_ACTIVE;
 	xfs_rtunmount_inodes(mp);
  out_rele_rip:
 	IRELE(rip);
