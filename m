Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbeCZX4g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Mar 2018 19:56:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2QNkcv6130612
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:35 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2gyau3g0n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:35 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2QNuYJq009109
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:34 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2QNuYsV009415
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:34 GMT
Subject: [PATCH 06/20] xfs: halt auto-reclamation activities while
 rebuilding rmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 26 Mar 2018 16:56:32 -0700
Message-ID: <152210859201.13184.1114348565922103.stgit@magnolia>
In-Reply-To: <152210855435.13184.6475770131389744177.stgit@magnolia>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
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

