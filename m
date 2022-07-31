Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E15C00140
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Jul 2022 16:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiGaQWb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jul 2022 12:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237518AbiGaQWb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Jul 2022 12:22:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E25FD1B
        for <linux-xfs@vger.kernel.org>; Sun, 31 Jul 2022 09:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF99C60F1B
        for <linux-xfs@vger.kernel.org>; Sun, 31 Jul 2022 16:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32875C433C1
        for <linux-xfs@vger.kernel.org>; Sun, 31 Jul 2022 16:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659284549;
        bh=7lMMbaoOvk2Fesb8clB6s0Y4aK+n4526Rpv88Tsr3SA=;
        h=Date:From:To:Subject:From;
        b=FnyxaH1U4O5Cvb5wsB9v2TfrGORt7M8WZKt4KzguVsZtTaqi+ks9wOJHdTiAHGTAY
         do9s+IB6hqScaFZOyM70qdRigDlZNU2cnZldqFSNxXa56jfvzMeg8OBwm1D088WQTO
         TxGweQn8n+gErU57xuN306M6yB6w1Iui4RU/F9esD7mrQ2bSzVhixi9TGp9bMv406J
         3mXjTD8rByyBttPrBkikoX8cDuddwZe0I40gNVOJQW7M17bXGqKsa34bklnZwXVw2k
         0OM0VaGGxXQJym+aBCpt97yJGQRkTO0Svbp8dTyZDNgOJnhXzMvjpKPu8X+i4NYww/
         kgp7qnZ2exwjA==
Date:   Sun, 31 Jul 2022 09:22:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: check return codes when flushing block devices
Message-ID: <YuasRCKeYsKlCgPM@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a block device cache flush fails, fsync needs to report that to upper
levels.  If the log can't flush the data device, we should shut it down
immediately because we've just violated an invariant.  Hence, check the
return value of blkdev_issue_flush.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c |   15 ++++++++++-----
 fs/xfs/xfs_log.c  |    7 +++++--
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5a171c0b244b..88450c33ab01 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -163,9 +163,11 @@ xfs_file_fsync(
 	 * inode size in case of an extending write.
 	 */
 	if (XFS_IS_REALTIME_INODE(ip))
-		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
+		error = blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
-		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
+		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
+	if (error)
+		return error;
 
 	/*
 	 * Any inode that has dirty modifications in the log is pinned.  The
@@ -173,8 +175,11 @@ xfs_file_fsync(
 	 * that happen concurrently to the fsync call, but fsync semantics
 	 * only require to sync previously completed I/O.
 	 */
-	if (xfs_ipincount(ip))
+	if (xfs_ipincount(ip)) {
 		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
+		if (error)
+			return error;
+	}
 
 	/*
 	 * If we only have a single device, and the log force about was
@@ -185,9 +190,9 @@ xfs_file_fsync(
 	 */
 	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
 	    mp->m_logdev_targp == mp->m_ddev_targp)
-		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
+		return blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
 
-	return error;
+	return 0;
 }
 
 static int
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4b1c0a9c6368..8a767f4145f0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1926,8 +1926,11 @@ xlog_write_iclog(
 		 * by the LSN in this iclog is on stable storage. This is slow,
 		 * but it *must* complete before we issue the external log IO.
 		 */
-		if (log->l_targ != log->l_mp->m_ddev_targp)
-			blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
+		if (log->l_targ != log->l_mp->m_ddev_targp &&
+		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
+			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+			return;
+		}
 	}
 	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
 		iclog->ic_bio.bi_opf |= REQ_FUA;
