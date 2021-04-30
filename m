Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A96C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 15:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 610AF6144D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 15:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhD3PPu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Apr 2021 11:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhD3PPu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Apr 2021 11:15:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F6146144B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Apr 2021 15:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619795701;
        bh=OQ/MihnFdLLW/rlLJ9/cNJJu8wGvNxv/2O3DbEUCegM=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=pCYn/2rbqaAeEAeFbw3Ix718cjIEVTVWtwi7/xhiqoauPHgXZv/f2J/dvVoarf1zs
         YNN/nMlIV9i6kUPW2LBZaGpUfNy1jP3RftnE4i+MXywAp9GNZE7vnyKLGY1XhQs9kw
         ugh8kZGr69AYKZN1Cw9uPvr+Zd6wF/nA6Fswhd8vzo6mmnnUCI0os3BBd8XmZQLg5c
         yZVHlvwKLhNLIS+XnrdPcbN7oxchIoiLT4CnifZeDm1nKYudiSNf7qJvMJ45Vohw6E
         QDx8Ems0RgJQaEhcQkoiVNCPz5+d4laGjHn0fcA/moPIv9xexE+1TMZyqIiYXPjJSZ
         U8+c5zradyztQ==
Date:   Fri, 30 Apr 2021 08:15:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] xfs: don't allow log writes if the data device is readonly
Message-ID: <20210430151500.GQ3122264@magnolia>
References: <20210430004012.GO3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430004012.GO3122264@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While running generic/050 with an external log, I observed this warning
in dmesg:

Trying to write to read-only block-device sda4 (partno 4)
WARNING: CPU: 2 PID: 215677 at block/blk-core.c:704 submit_bio_checks+0x256/0x510
Call Trace:
 submit_bio_noacct+0x2c/0x430
 _xfs_buf_ioapply+0x283/0x3c0 [xfs]
 __xfs_buf_submit+0x6a/0x210 [xfs]
 xfs_buf_delwri_submit_buffers+0xf8/0x270 [xfs]
 xfsaild+0x2db/0xc50 [xfs]
 kthread+0x14b/0x170

I think this happened because we tried to cover the log after a readonly
mount, and the AIL tried to write the primary superblock to the data
device.  The test marks the data device readonly, but it doesn't do the
same to the external log device.  Therefore, XFS thinks that the log is
writable, even though AIL writes whine to dmesg because the data device
is read only.

Fix this by amending xfs_log_writable to prevent writes when the AIL
can't possible write anything into the filesystem.

Note: As for the external log or the rt devices being readonly--
xfs_blkdev_get will complain about that if we aren't doing a norecovery
mount.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
v2: tweak the wording of the comment a little bit
---
 fs/xfs/xfs_log.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 06041834daa3..c19a82adea1e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -355,13 +355,15 @@ xfs_log_writable(
 	struct xfs_mount	*mp)
 {
 	/*
-	 * Never write to the log on norecovery mounts, if the block device is
-	 * read-only, or if the filesystem is shutdown. Read-only mounts still
-	 * allow internal writes for log recovery and unmount purposes, so don't
-	 * restrict that case here.
+	 * Do not write to the log on norecovery mounts, if the data or log
+	 * devices are read-only, or if the filesystem is shutdown. Read-only
+	 * mounts allow internal writes for log recovery and unmount purposes,
+	 * so don't restrict that case.
 	 */
 	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
 		return false;
+	if (xfs_readonly_buftarg(mp->m_ddev_targp))
+		return false;
 	if (xfs_readonly_buftarg(mp->m_log->l_targ))
 		return false;
 	if (XFS_FORCED_SHUTDOWN(mp))
