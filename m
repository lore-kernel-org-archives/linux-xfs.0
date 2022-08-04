Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB5BC19F2D
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 18:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239646AbiHDSGd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 14:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238831AbiHDSGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 14:06:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466A32CE0F
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 11:06:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B6E9B826E2
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 18:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B670AC433D7;
        Thu,  4 Aug 2022 18:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659636388;
        bh=8uPruD/cLnW1lQ6T1s3y9i4bA2bDxOpHUjdC1XmiYhc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mgljBzXpFmUVnaLYBUqvCmsRkQYHYAX6tGqLm33p7e9a/KmjEbNnxIkm6y5/wk7YP
         tmiGiGAxdon1Dja//Dv9foB3q0h/3v6YAJmap7mpu9ss3Np1X82nc6hKrJ9Xkt8Be+
         cbt5NBC/OtZdp0nXmZbjqDktYvDSjcYTBeG/Mnl+jDM5QIpEhvcVnuoaeUXM8ktEd5
         6qTfFqj+H80pHY1BoX1Vt8bTrtpDQh4/aSY+BhQlTyMtBLC62j3bkQKsM6fNqc/7Aw
         udEOE5Kj5LRfsW9K3LaegTeUy2WLTRYMA3f4jOaeT4YSBuodWmE5076qB1hx5TQZH7
         +YIBZT+gS9gbw==
Subject: [PATCH 1/2] xfs: check return codes when flushing block devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 04 Aug 2022 11:06:28 -0700
Message-ID: <165963638822.1272632.5382210082462983546.stgit@magnolia>
In-Reply-To: <165963638241.1272632.9852314965190809423.stgit@magnolia>
References: <165963638241.1272632.9852314965190809423.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a blkdev_issue_flush fails, fsync needs to report that to upper
levels.  Modify xfs_file_fsync to capture the errors, while trying to
flush as much data and log updates to disk as possible.

If log writes cannot flush the data device, we need to shut down the log
immediately because we've violated a log invariant.  Modify this code to
check the return value of blkdev_issue_flush as well.

This behavior seems to go back to about 2.6.15 or so, which makes this
fixes tag a bit misleading.

Link: https://elixir.bootlin.com/linux/v2.6.15/source/fs/xfs/xfs_vnodeops.c#L1187
Fixes: b5071ada510a ("xfs: remove xfs_blkdev_issue_flush")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c |   22 ++++++++++++++--------
 fs/xfs/xfs_log.c  |   11 +++++++++--
 2 files changed, 23 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5a171c0b244b..a02000be931b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -142,7 +142,7 @@ xfs_file_fsync(
 {
 	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
 	struct xfs_mount	*mp = ip->i_mount;
-	int			error = 0;
+	int			error, err2;
 	int			log_flushed = 0;
 
 	trace_xfs_file_fsync(ip);
@@ -163,18 +163,21 @@ xfs_file_fsync(
 	 * inode size in case of an extending write.
 	 */
 	if (XFS_IS_REALTIME_INODE(ip))
-		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
+		error = blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
-		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
+		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
 
 	/*
 	 * Any inode that has dirty modifications in the log is pinned.  The
-	 * racy check here for a pinned inode while not catch modifications
+	 * racy check here for a pinned inode will not catch modifications
 	 * that happen concurrently to the fsync call, but fsync semantics
 	 * only require to sync previously completed I/O.
 	 */
-	if (xfs_ipincount(ip))
-		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
+	if (xfs_ipincount(ip)) {
+		err2 = xfs_fsync_flush_log(ip, datasync, &log_flushed);
+		if (!error && err2)
+			error = err2;
+	}
 
 	/*
 	 * If we only have a single device, and the log force about was
@@ -184,8 +187,11 @@ xfs_file_fsync(
 	 * commit.
 	 */
 	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
-	    mp->m_logdev_targp == mp->m_ddev_targp)
-		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
+	    mp->m_logdev_targp == mp->m_ddev_targp) {
+		err2 = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
+		if (!error && err2)
+			error = err2;
+	}
 
 	return error;
 }
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4b1c0a9c6368..15d7cdc7a632 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1925,9 +1925,16 @@ xlog_write_iclog(
 		 * device cache first to ensure all metadata writeback covered
 		 * by the LSN in this iclog is on stable storage. This is slow,
 		 * but it *must* complete before we issue the external log IO.
+		 *
+		 * If the flush fails, we cannot conclude that past metadata
+		 * writeback from the log succeeded, which is effectively a
+		 * log IO error.
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

