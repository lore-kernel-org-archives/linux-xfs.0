Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6236CC352A4
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 21:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3273D2070A
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 21:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgBJVRT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 16:17:19 -0500
Received: from xes-mad.com ([162.248.234.2]:7736 "EHLO mail.xes-mad.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgBJVRT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Feb 2020 16:17:19 -0500
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Feb 2020 16:17:19 EST
Received: from vfazio1.xes-mad.com (vfazio1.xes-mad.com [10.52.16.140])
        by mail.xes-mad.com (Postfix) with ESMTP id 072FB201D2;
        Mon, 10 Feb 2020 15:10:57 -0600 (CST)
From:   Vincent Fazio <vfazio@xes-inc.com>
To:     linux-xfs@vger.kernel.org
Cc:     Vincent Fazio <vfazio@xes-inc.com>,
        Aaron Sierra <asierra@xes-inc.com>
Subject: [PATCH 1/1] xfs: fallback to readonly during recovery
Date:   Mon, 10 Feb 2020 15:10:37 -0600
Message-Id: <20200210211037.1930-1-vfazio@xes-inc.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Previously, XFS would fail to mount if there was an error during log
recovery. This can occur as a result of inevitable I/O errors when
trying to apply the log on read-only ATA devices since the ATA layer
does not support reporting a device as read-only.

Now, if there's an error during log recovery, fall back to norecovery
mode and mark the filesystem as read-only in the XFS and VFS layers.

This roughly approximates the 'errors=remount-ro' mount option in ext4
but is implicit and the scope only covers errors during log recovery.
Since XFS is the default filesystem for some distributions, this change
allows users to continue to use XFS on these read-only ATA devices.

Reviewed-by: Aaron Sierra <asierra@xes-inc.com>
Signed-off-by: Vincent Fazio <vfazio@xes-inc.com>
---
 fs/xfs/xfs_log.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6006d94a581..f5b3528ee028 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -739,7 +739,6 @@ xfs_log_mount(
 			xfs_warn(mp, "log mount/recovery failed: error %d",
 				error);
 			xlog_recover_cancel(mp->m_log);
-			goto out_destroy_ail;
 		}
 	}
 
@@ -3873,10 +3872,17 @@ xfs_log_force_umount(
 	/*
 	 * If this happens during log recovery, don't worry about
 	 * locking; the log isn't open for business yet.
+	 *
+	 * Attempt a read-only, norecovery mount. Ensure the VFS layer is updated.
 	 */
 	if (!log ||
 	    log->l_flags & XLOG_ACTIVE_RECOVERY) {
-		mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
+
+		xfs_notice(mp,
+"Falling back to no-recovery mode. Filesystem will be inconsistent.");
+		mp->m_flags |= (XFS_MOUNT_RDONLY | XFS_MOUNT_NORECOVERY);
+		mp->m_super->s_flags |= SB_RDONLY;
+
 		if (mp->m_sb_bp)
 			mp->m_sb_bp->b_flags |= XBF_DONE;
 		return 0;
-- 
2.25.0

