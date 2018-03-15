Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41462 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752594AbeCOU1B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 16:27:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2FKL1hM035452
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 20:27:01 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2gqyss80sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 20:27:01 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2FKR0CE029458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 20:27:00 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2FKR0qx015884
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 20:27:00 GMT
Subject: [PATCH 06/20] xfs: halt auto-reclamation activities while
 rebuilding rmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Mar 2018 13:26:59 -0700
Message-ID: <152114561947.22742.7669958376744386077.stgit@magnolia>
In-Reply-To: <152114558216.22742.6635423816559130061.stgit@magnolia>
References: <152114558216.22742.6635423816559130061.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rebuilding the reverse-mapping tree requires us to quiesce all inodes in
the filesystem, so we must stop background reclamation of post-EOF and
CoW prealloc blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |   18 ++++++++++++++++++
 fs/xfs/xfs_icache.h |    3 +++
 2 files changed, 21 insertions(+)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d53a316..52f5ab0 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1781,3 +1781,21 @@ xfs_inode_clear_cowblocks_tag(
 	return __xfs_inode_clear_blocks_tag(ip,
 			trace_xfs_perag_clear_cowblocks, XFS_ICI_COWBLOCKS_TAG);
 }
+
+/* Disable post-EOF and CoW block auto-reclamation. */
+void
+xfs_icache_disable_reclaim(
+	struct xfs_mount	*mp)
+{
+	cancel_delayed_work_sync(&mp->m_eofblocks_work);
+	cancel_delayed_work_sync(&mp->m_cowblocks_work);
+}
+
+/* Enable post-EOF and CoW block auto-reclamation. */
+void
+xfs_icache_enable_reclaim(
+	struct xfs_mount	*mp)
+{
+	xfs_queue_eofblocks(mp);
+	xfs_queue_cowblocks(mp);
+}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d4a7758..d69a0f5 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -131,4 +131,7 @@ xfs_fs_eofblocks_from_user(
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
 
+void xfs_icache_disable_reclaim(struct xfs_mount *mp);
+void xfs_icache_enable_reclaim(struct xfs_mount *mp);
+
 #endif

