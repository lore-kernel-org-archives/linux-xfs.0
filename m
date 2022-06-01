Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C851C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 10:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349606AbiFAKqa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 06:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352402AbiFAKqM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 06:46:12 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86CC84A35;
        Wed,  1 Jun 2022 03:46:07 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q7so1768066wrg.5;
        Wed, 01 Jun 2022 03:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b2pvl9UHk0Z4rkTZyge+oGFzFbTSQ4HA4DjZnHNbMzc=;
        b=Oj57oflIWLIstVRtrdtOyhqk2wQfpCO4Gul0cfqenCE18Msr2ZOYrDdAfZh4MnxfzH
         sMseUWCfuGS9krRMGLn5tWphTRX9bJd2YZkfkR0wHcaqrDXTehb2hBQ0ovC77r8mPucf
         3cEYvbzd9x9tJUWINaOZlOF/5k+OeuDrHL9eINY6OnSMM0MfS7aMlUYyleT8OQSfwyEl
         vw65qgbLuq/AYeuMBfi88FT9codLlAzIHEt2FpJhF8YoWEy3yRF5Q/YUHbA3rGY5ftn0
         mMfjs/bT0Hpgp1LJ3c0+vVaCvbfmhXJZwyw714XMIdtX/7OCKACzJgJBb+ukEOeQGRON
         fd1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b2pvl9UHk0Z4rkTZyge+oGFzFbTSQ4HA4DjZnHNbMzc=;
        b=dcIDRbL28txWnoSsHb3uZbLxifGsQhwRarvoDoI6C2CtB8aJyB5qCGg489CirzVONU
         POI0hHTExH5JtvcJcCtN5Mr1msirOy3dGVSZaH8OZIwEmC+/SApfhkeKVpFQD9Nf8a3+
         trya62rz7N0UaXMMjijUE5SnpyqAGb8Ot3zqKeKT/EEjHVLI8TuWu436CjH+WkF0KCt/
         a46VLmWiPvHE3NHRutS4ADPvDz2d2p6VhOR8zw9ms+IZlmcDOX1Bo7Hj/Tx8LOnhccaF
         xH5HjXY1Z+H5WBkwp3kvYH+NLfKHDnlSTpu4RoKa9B2nSR30KaFv3EVtitTj827/s+++
         izVw==
X-Gm-Message-State: AOAM531XtuqPyNbXZfZQhdLEvSPVnfjNl3sshpFa6Ubk2Aew1Ch2f5HE
        hI14ysnHam0aIP0QSkcV9XY=
X-Google-Smtp-Source: ABdhPJwXtfEDgNR3RZSIsxQqHlreRhUU/8jLWP5c5p1euc9vogWKg5K34hI26sJzU9bqe0eGKSJ4bQ==
X-Received: by 2002:adf:fc01:0:b0:20c:ff9a:2c53 with SMTP id i1-20020adffc01000000b0020cff9a2c53mr53206420wrr.142.1654080365855;
        Wed, 01 Jun 2022 03:46:05 -0700 (PDT)
Received: from localhost.localdomain ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id h9-20020a5d4309000000b002102af52a2csm1562150wrq.9.2022.06.01.03.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 03:46:05 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 8/8] xfs: force log and push AIL to clear pinned inodes when aborting mount
Date:   Wed,  1 Jun 2022 13:45:47 +0300
Message-Id: <20220601104547.260949-9-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220601104547.260949-1-amir73il@gmail.com>
References: <20220601104547.260949-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit d336f7ebc65007f5831e2297e6f3383ae8dbf8ed upstream.

If we allocate quota inodes in the process of mounting a filesystem but
then decide to abort the mount, it's possible that the quota inodes are
sitting around pinned by the log.  Now that inode reclaim relies on the
AIL to flush inodes, we have to force the log and push the AIL in
between releasing the quota inodes and kicking off reclaim to tear down
all the incore inodes.  Do this by extracting the bits we need from the
unmount path and reusing them.  As an added bonus, failed writes during
a failed mount will not retry forever now.

This was originally found during a fuzz test of metadata directories
(xfs/1546), but the actual symptom was that reclaim hung up on the quota
inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_mount.c | 90 +++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a62b8a574409..44b05e1d5d32 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -631,6 +631,47 @@ xfs_check_summary_counts(
 	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
 }
 
+/*
+ * Flush and reclaim dirty inodes in preparation for unmount. Inodes and
+ * internal inode structures can be sitting in the CIL and AIL at this point,
+ * so we need to unpin them, write them back and/or reclaim them before unmount
+ * can proceed.
+ *
+ * An inode cluster that has been freed can have its buffer still pinned in
+ * memory because the transaction is still sitting in a iclog. The stale inodes
+ * on that buffer will be pinned to the buffer until the transaction hits the
+ * disk and the callbacks run. Pushing the AIL will skip the stale inodes and
+ * may never see the pinned buffer, so nothing will push out the iclog and
+ * unpin the buffer.
+ *
+ * Hence we need to force the log to unpin everything first. However, log
+ * forces don't wait for the discards they issue to complete, so we have to
+ * explicitly wait for them to complete here as well.
+ *
+ * Then we can tell the world we are unmounting so that error handling knows
+ * that the filesystem is going away and we should error out anything that we
+ * have been retrying in the background.  This will prevent never-ending
+ * retries in AIL pushing from hanging the unmount.
+ *
+ * Finally, we can push the AIL to clean all the remaining dirty objects, then
+ * reclaim the remaining inodes that are still in memory at this point in time.
+ */
+static void
+xfs_unmount_flush_inodes(
+	struct xfs_mount	*mp)
+{
+	xfs_log_force(mp, XFS_LOG_SYNC);
+	xfs_extent_busy_wait_all(mp);
+	flush_workqueue(xfs_discard_wq);
+
+	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
+
+	xfs_ail_push_all_sync(mp->m_ail);
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_reclaim_inodes(mp);
+	xfs_health_unmount(mp);
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -1005,7 +1046,7 @@ xfs_mountfs(
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
 	/*
-	 * Cancel all delayed reclaim work and reclaim the inodes directly.
+	 * Flush all inode reclamation work and flush the log.
 	 * We have to do this /after/ rtunmount and qm_unmount because those
 	 * two will have scheduled delayed reclaim for the rt/quota inodes.
 	 *
@@ -1015,11 +1056,8 @@ xfs_mountfs(
 	 * qm_unmount_quotas and therefore rely on qm_unmount to release the
 	 * quota inodes.
 	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
  out_log_dealloc:
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 	xfs_log_mount_cancel(mp);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
@@ -1060,47 +1098,7 @@ xfs_unmountfs(
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
 
-	/*
-	 * We can potentially deadlock here if we have an inode cluster
-	 * that has been freed has its buffer still pinned in memory because
-	 * the transaction is still sitting in a iclog. The stale inodes
-	 * on that buffer will be pinned to the buffer until the
-	 * transaction hits the disk and the callbacks run. Pushing the AIL will
-	 * skip the stale inodes and may never see the pinned buffer, so
-	 * nothing will push out the iclog and unpin the buffer. Hence we
-	 * need to force the log here to ensure all items are flushed into the
-	 * AIL before we go any further.
-	 */
-	xfs_log_force(mp, XFS_LOG_SYNC);
-
-	/*
-	 * Wait for all busy extents to be freed, including completion of
-	 * any discard operation.
-	 */
-	xfs_extent_busy_wait_all(mp);
-	flush_workqueue(xfs_discard_wq);
-
-	/*
-	 * We now need to tell the world we are unmounting. This will allow
-	 * us to detect that the filesystem is going away and we should error
-	 * out anything that we have been retrying in the background. This will
-	 * prevent neverending retries in AIL pushing from hanging the unmount.
-	 */
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
-
-	/*
-	 * Flush all pending changes from the AIL.
-	 */
-	xfs_ail_push_all_sync(mp->m_ail);
-
-	/*
-	 * Reclaim all inodes. At this point there should be no dirty inodes and
-	 * none should be pinned or locked. Stop background inode reclaim here
-	 * if it is still running.
-	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
 
 	xfs_qm_unmount(mp);
 
-- 
2.25.1

