Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC95FECE58F
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DC332067B
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390291AbfJPAl2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 20:41:28 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:40390
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388246AbfJPAl1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 20:41:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CfAADRZqZd/0e30XYNWRsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgXuEPIQljzMBAQEBAQEGgRGKHYUgAYwOCQEBAQEBAQE?=
 =?us-ascii?q?BATcBAYQ7AwICgxI4EwIMAQEBBAEBAQEBBQMBhViGGgIBAyMEUhAYDQImAgJ?=
 =?us-ascii?q?HEAYThXWuB3V/MxqKKYEMKIFlikF4gQeBRIMdh1KCXgSMfQqCLzeGPkNxlWy?=
 =?us-ascii?q?CLJU2DIIui2gDEIsNLY9Dmg2Bek0uCoMnUJBGZ5FRAQE?=
X-IPAS-Result: =?us-ascii?q?A2CfAADRZqZd/0e30XYNWRsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgXuEPIQljzMBAQEBAQEGgRGKHYUgAYwOCQEBAQEBAQEBATcBAYQ7AwICg?=
 =?us-ascii?q?xI4EwIMAQEBBAEBAQEBBQMBhViGGgIBAyMEUhAYDQImAgJHEAYThXWuB3V/M?=
 =?us-ascii?q?xqKKYEMKIFlikF4gQeBRIMdh1KCXgSMfQqCLzeGPkNxlWyCLJU2DIIui2gDE?=
 =?us-ascii?q?IsNLY9Dmg2Bek0uCoMnUJBGZ5FRAQE?=
X-IronPort-AV: E=Sophos;i="5.67,301,1566835200"; 
   d="scan'208";a="247444178"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 16 Oct 2019 08:41:17 +0800
Subject: [PATCH v6 06/12] xfs: add xfs_remount_rw() helper
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 16 Oct 2019 08:41:13 +0800
Message-ID: <157118647366.9678.14061368527967040009.stgit@fedora-28>
In-Reply-To: <157118625324.9678.16275725173770634823.stgit@fedora-28>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Factor the remount read write code into a helper to simplify the
subsequent change from the super block method .remount_fs to the
mount-api fs_context_operations method .reconfigure.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |  115 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 64 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f8770206b66e..cdc19c2af50f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1213,6 +1213,68 @@ xfs_test_remount_options(
 	return error;
 }
 
+static int
+xfs_remount_rw(
+	struct xfs_mount	*mp)
+{
+	xfs_sb_t		*sbp = &mp->m_sb;
+	int error;
+
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
+		xfs_warn(mp,
+			"ro->rw transition prohibited on norecovery mount");
+		return -EINVAL;
+	}
+
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
+		xfs_warn(mp,
+	"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
+			(sbp->sb_features_ro_compat &
+				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
+		return -EINVAL;
+	}
+
+	mp->m_flags &= ~XFS_MOUNT_RDONLY;
+
+	/*
+	 * If this is the first remount to writeable state we
+	 * might have some superblock changes to update.
+	 */
+	if (mp->m_update_sb) {
+		error = xfs_sync_sb(mp, false);
+		if (error) {
+			xfs_warn(mp, "failed to write sb changes");
+			return error;
+		}
+		mp->m_update_sb = false;
+	}
+
+	/*
+	 * Fill out the reserve pool if it is empty. Use the stashed
+	 * value if it is non-zero, otherwise go with the default.
+	 */
+	xfs_restore_resvblks(mp);
+	xfs_log_work_queue(mp);
+
+	/* Recover any CoW blocks that never got remapped. */
+	error = xfs_reflink_recover_cow(mp);
+	if (error) {
+		xfs_err(mp,
+			"Error %d recovering leftover CoW allocations.", error);
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return error;
+	}
+	xfs_start_block_reaping(mp);
+
+	/* Create the per-AG metadata reservation pool .*/
+	error = xfs_fs_reserve_ag_blocks(mp);
+	if (error && error != -ENOSPC)
+		return error;
+
+	return 0;
+}
+
 STATIC int
 xfs_fs_remount(
 	struct super_block	*sb,
@@ -1276,57 +1338,8 @@ xfs_fs_remount(
 
 	/* ro -> rw */
 	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY)) {
-		if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
-			xfs_warn(mp,
-		"ro->rw transition prohibited on norecovery mount");
-			return -EINVAL;
-		}
-
-		if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		    xfs_sb_has_ro_compat_feature(sbp,
-					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
-			xfs_warn(mp,
-"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
-				(sbp->sb_features_ro_compat &
-					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
-			return -EINVAL;
-		}
-
-		mp->m_flags &= ~XFS_MOUNT_RDONLY;
-
-		/*
-		 * If this is the first remount to writeable state we
-		 * might have some superblock changes to update.
-		 */
-		if (mp->m_update_sb) {
-			error = xfs_sync_sb(mp, false);
-			if (error) {
-				xfs_warn(mp, "failed to write sb changes");
-				return error;
-			}
-			mp->m_update_sb = false;
-		}
-
-		/*
-		 * Fill out the reserve pool if it is empty. Use the stashed
-		 * value if it is non-zero, otherwise go with the default.
-		 */
-		xfs_restore_resvblks(mp);
-		xfs_log_work_queue(mp);
-
-		/* Recover any CoW blocks that never got remapped. */
-		error = xfs_reflink_recover_cow(mp);
-		if (error) {
-			xfs_err(mp,
-	"Error %d recovering leftover CoW allocations.", error);
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-			return error;
-		}
-		xfs_start_block_reaping(mp);
-
-		/* Create the per-AG metadata reservation pool .*/
-		error = xfs_fs_reserve_ag_blocks(mp);
-		if (error && error != -ENOSPC)
+		error = xfs_remount_rw(mp);
+		if (error)
 			return error;
 	}
 

