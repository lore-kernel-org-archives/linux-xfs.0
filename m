Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C29C07E96
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E191A61C91
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhGGAZy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhGGAZx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 20:25:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 264B8619B9;
        Wed,  7 Jul 2021 00:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625617394;
        bh=3jrmtV+AQLPoEkOv3DWPqBqJpx4iZaH7cMUZMpwlmP8=;
        h=Date:From:To:Cc:Subject:From;
        b=iKOtzv5vlZs56I1vMShUd05W4wzY+JRTNXi3T1t/DQYhfLjJkbB/wHzDYKP5VxAgo
         Nzp0Cp2EdSPDsiDZH+YzMKfHz6+gnZspODRHss7hAq2y8/v7lt4fjUV2oeFWGRcvZg
         5FVyWWrLi0+0o1nwdSKSLFiRkXP4SseLuWRc8Bz5IzgmD3ihQgRzcHDLSiiI6l6sQt
         J8hHcR+QeR7wTP5UAXdtUhGMYszIEJRUlHFPniph6b90v08FccXednRfc1ndtOhPqO
         9Kjpa13FLUY0lB6urmR628XrPpGiJGkXBnPudC/zYhyLHgW5MS3NFDixHr0eXcH50w
         G2PGVsJfN9tHg==
Date:   Tue, 6 Jul 2021 17:23:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: drop experimental warnings for bigtime and inobtcount
Message-ID: <20210707002313.GG11588@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

These two features were merged a year ago, userspace tooling have been
merged, and no serious errors have been reported by the developers.
Drop the experimental tag to encourage wider testing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index cbc1f0157bcd..321e3590c6fe 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1539,10 +1539,6 @@ xfs_fs_fill_super(
 	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
 		sb->s_flags |= SB_I_VERSION;
 
-	if (xfs_sb_version_hasbigtime(&mp->m_sb))
-		xfs_warn(mp,
- "EXPERIMENTAL big timestamp feature in use. Use at your own risk!");
-
 	if (mp->m_flags & XFS_MOUNT_DAX_ALWAYS) {
 		bool rtdev_is_dax = false, datadev_is_dax;
 
@@ -1598,10 +1594,6 @@ xfs_fs_fill_super(
 		goto out_filestream_unmount;
 	}
 
-	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
-		xfs_warn(mp,
- "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
-
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
