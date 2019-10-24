Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7442CA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5BA721872
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408744AbfJXHva (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:51:30 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408743AbfJXHva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:51:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AaAADRVrFd/0e30XYNWBsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWkEAQEBCwEBhDqEKI9JBoERiiKFIAGKE4F7CQEBAQE?=
 =?us-ascii?q?BAQEBATcBAYQ7AwICg1k2Bw4CDAEBAQQBAQEBAQUDAYVYgRoBAQQHAYUBAgE?=
 =?us-ascii?q?DIwRSEBgNAiYCAkcQBhOFdbF0dX8zGoowgQ4oAYFkikJ4gQeBETODHYdVgl4?=
 =?us-ascii?q?EjQ6CLzeGQEOWbIIulUUMgi+LcAMQixQtqVkBgglNLgqDJ1CDNheOMGeHPYM?=
 =?us-ascii?q?ZhVgBAQ?=
X-IPAS-Result: =?us-ascii?q?A2AaAADRVrFd/0e30XYNWBsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWkEAQEBCwEBhDqEKI9JBoERiiKFIAGKE4F7CQEBAQEBAQEBATcBAYQ7A?=
 =?us-ascii?q?wICg1k2Bw4CDAEBAQQBAQEBAQUDAYVYgRoBAQQHAYUBAgEDIwRSEBgNAiYCA?=
 =?us-ascii?q?kcQBhOFdbF0dX8zGoowgQ4oAYFkikJ4gQeBETODHYdVgl4EjQ6CLzeGQEOWb?=
 =?us-ascii?q?IIulUUMgi+LcAMQixQtqVkBgglNLgqDJ1CDNheOMGeHPYMZhVgBAQ?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250044005"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:51:27 +0800
Subject: [PATCH v7 10/17] xfs: add xfs_remount_ro() helper
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 24 Oct 2019 15:51:27 +0800
Message-ID: <157190348766.27074.17456421465521004386.stgit@fedora-28>
In-Reply-To: <157190333868.27074.13987695222060552856.stgit@fedora-28>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Factor the remount read only code into a helper to simplify the
subsequent change from the super block method .remount_fs to the
mount-api fs_context_operations method .reconfigure.

This helper is only used by the mount code, so locate it along with
that code.

While we are at it change STATIC -> static for xfs_save_resvblks().

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c |   76 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c07e41489e75..97c3f1edb69c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -48,6 +48,7 @@ static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 #endif
 
 static void xfs_restore_resvblks(struct xfs_mount *mp);
+static void xfs_save_resvblks(struct xfs_mount *mp);
 
 /*
  * Table driven mount option parser.
@@ -519,6 +520,47 @@ xfs_remount_rw(
 	return 0;
 }
 
+static int
+xfs_remount_ro(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	/*
+	 * Cancel background eofb scanning so it cannot race with the final
+	 * log force+buftarg wait and deadlock the remount.
+	 */
+	xfs_stop_block_reaping(mp);
+
+	/* Get rid of any leftover CoW reservations... */
+	error = xfs_icache_free_cowblocks(mp, NULL);
+	if (error) {
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return error;
+	}
+
+	/* Free the per-AG metadata reservation pool. */
+	error = xfs_fs_unreserve_ag_blocks(mp);
+	if (error) {
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return error;
+	}
+
+	/*
+	 * Before we sync the metadata, we need to free up the reserve block
+	 * pool so that the used block count in the superblock on disk is
+	 * correct at the end of the remount. Stash the current* reserve pool
+	 * size so that if we get remounted rw, we can return it to the same
+	 * size.
+	 */
+	xfs_save_resvblks(mp);
+
+	xfs_quiesce_attr(mp);
+	mp->m_flags |= XFS_MOUNT_RDONLY;
+
+	return 0;
+}
+
 struct proc_xfs_info {
 	uint64_t	flag;
 	char		*str;
@@ -1224,7 +1266,7 @@ xfs_fs_statfs(
 	return 0;
 }
 
-STATIC void
+static void
 xfs_save_resvblks(struct xfs_mount *mp)
 {
 	uint64_t resblks = 0;
@@ -1378,37 +1420,9 @@ xfs_fs_remount(
 
 	/* rw -> ro */
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY)) {
-		/*
-		 * Cancel background eofb scanning so it cannot race with the
-		 * final log force+buftarg wait and deadlock the remount.
-		 */
-		xfs_stop_block_reaping(mp);
-
-		/* Get rid of any leftover CoW reservations... */
-		error = xfs_icache_free_cowblocks(mp, NULL);
-		if (error) {
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-			return error;
-		}
-
-		/* Free the per-AG metadata reservation pool. */
-		error = xfs_fs_unreserve_ag_blocks(mp);
-		if (error) {
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		error = xfs_remount_ro(mp);
+		if (error)
 			return error;
-		}
-
-		/*
-		 * Before we sync the metadata, we need to free up the reserve
-		 * block pool so that the used block count in the superblock on
-		 * disk is correct at the end of the remount. Stash the current
-		 * reserve pool size so that if we get remounted rw, we can
-		 * return it to the same size.
-		 */
-		xfs_save_resvblks(mp);
-
-		xfs_quiesce_attr(mp);
-		mp->m_flags |= XFS_MOUNT_RDONLY;
 	}
 
 	return 0;

