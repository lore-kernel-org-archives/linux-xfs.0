Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A220BC433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 00:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F79C61450
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 00:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhD3AlD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Apr 2021 20:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhD3AlA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Apr 2021 20:41:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D195B613F7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Apr 2021 00:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619743212;
        bh=i/HCYgJ1q4dYVa6qpxt2WPsWEC+6TboTHrJykpffiOk=;
        h=Date:From:To:Subject:From;
        b=DR+WF0s8XOh0ZKKcgV2sbeEj+sboQ+HE0Vtk69vLmmaw+7oM6rcHC5iGsAvy+LfWi
         5m3JO+JYDOI+TIEHmMXtlgcwkXFpqeZA8y9YpR+h9SKjUMTXBwFhLxNFSgvjYgCMc5
         c9rEy0fex+bLP0GgJD/frE3Kyv/hZ+Le84wZjiwR0U37O1VFqURoREperAF6VtWALi
         KDnUHPnUT9uFfAHmjFwJWWk5VvLuCDBWpt97ysWAk2oh6iYd7dDqg61rjJu2IaA+gN
         1f9dQrqub3r7RdmuevB7eoYejZhbVhbEaBMdQlF+S3i0XD1J8qLGQp8/U+p/r6QH5n
         R6hbTeKvwLq3w==
Date:   Thu, 29 Apr 2021 17:40:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: don't allow log writes if the data device is readonly
Message-ID: <20210430004012.GO3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
---
 fs/xfs/xfs_log.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 06041834daa3..e4839f22ec07 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -358,12 +358,14 @@ xfs_log_writable(
 	 * Never write to the log on norecovery mounts, if the block device is
 	 * read-only, or if the filesystem is shutdown. Read-only mounts still
 	 * allow internal writes for log recovery and unmount purposes, so don't
-	 * restrict that case here.
+	 * restrict that case here unless the data device is also readonly.
 	 */
 	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
 		return false;
 	if (xfs_readonly_buftarg(mp->m_log->l_targ))
 		return false;
+	if (xfs_readonly_buftarg(mp->m_ddev_targp))
+		return false;
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return false;
 	return true;
