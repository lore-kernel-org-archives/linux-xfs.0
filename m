Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31469 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdKIGAN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 01:00:13 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA960BQl018769
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 9 Nov 2017 06:00:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA960B0I031645
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 9 Nov 2017 06:00:11 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA960BEj010875
        for <linux-xfs@vger.kernel.org>; Thu, 9 Nov 2017 06:00:11 GMT
Date: Wed, 8 Nov 2017 22:00:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 7/5] xfs: on failed mount, force-reclaim inodes after
 unmounting quota controls
Message-ID: <20171109060010.GK26910@magnolia>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151001660179.26786.15701876786383794673.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When mounting fails, we must force-reclaim inodes (and disable delayed
reclaim) /after/ the realtime and quota control have let go of the
realtime and quota inodes.  Without this, we corrupt the timer list and
cause other weird problems.

Found by xfs/376 fuzzing u3.bmbt[0].lastoff on an rmap filesystem to
force a bogus post-eof extent reclaim that causes the fs to go down.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e9727d0..a9f0fe9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1022,10 +1022,15 @@ xfs_mountfs(
 	xfs_rtunmount_inodes(mp);
  out_rele_rip:
 	IRELE(rip);
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp, SYNC_WAIT);
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
+	/*
+	 * Cancel all delayed reclaim work and reclaim the inodes directly.
+	 * We have to do this /after/ rtunmount and qm_unmount because those
+	 * two will have scheduled delayed reclaim for the rt/quota inodes.
+	 */
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_reclaim_inodes(mp, SYNC_WAIT);
  out_log_dealloc:
 	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 	xfs_log_mount_cancel(mp);
