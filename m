Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6E2CA9EC9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6072B2080F
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfKAHvV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 03:51:21 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:9024
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727053AbfKAHvU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 03:51:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2APAACY47td/xK90HYNVxsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWsEAQEBCwGEPIQoj1oBAQEBAQEGgRGKCIUwAYoVgXs?=
 =?us-ascii?q?JAQEBAQEBAQEBNwEBhDsDAgKEHjYHDgIMAQEBBAEBAQEBBQMBhViGKgIBAyM?=
 =?us-ascii?q?EUhAYDQImAgJHEAYThXWwXnV/MxqKN4EOKAGBZIpEeIEHgREzgx2HVYJeBI0?=
 =?us-ascii?q?Tgi83hkFDlnWCLpVQDIIwi3gDEIseLaloA4IHTS4KgydQgzYXjjBnjmwBAQ?=
X-IPAS-Result: =?us-ascii?q?A2APAACY47td/xK90HYNVxsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWsEAQEBCwGEPIQoj1oBAQEBAQEGgRGKCIUwAYoVgXsJAQEBAQEBAQEBN?=
 =?us-ascii?q?wEBhDsDAgKEHjYHDgIMAQEBBAEBAQEBBQMBhViGKgIBAyMEUhAYDQImAgJHE?=
 =?us-ascii?q?AYThXWwXnV/MxqKN4EOKAGBZIpEeIEHgREzgx2HVYJeBI0Tgi83hkFDlnWCL?=
 =?us-ascii?q?pVQDIIwi3gDEIseLaloA4IHTS4KgydQgzYXjjBnjmwBAQ?=
X-IronPort-AV: E=Sophos;i="5.68,254,1569254400"; 
   d="scan'208";a="215829975"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 01 Nov 2019 15:50:39 +0800
Subject: [PATCH v8 07/16] xfs: add xfs_remount_ro() helper
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 01 Nov 2019 15:50:39 +0800
Message-ID: <157259463969.28278.13374185572499414619.stgit@fedora-28>
In-Reply-To: <157259452909.28278.1001302742832626046.stgit@fedora-28>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
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

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c |   73 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6eaa1b05897a..bdf6c069e3ea 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1246,6 +1246,47 @@ xfs_remount_rw(
 	return 0;
 }
 
+static int
+xfs_remount_ro(
+	struct xfs_mount	*mp)
+{
+	int error;
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
 STATIC int
 xfs_fs_remount(
 	struct super_block	*sb,
@@ -1316,37 +1357,9 @@ xfs_fs_remount(
 
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

