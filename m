Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64724C677F1
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 01:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjASBap (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjASB3s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 20:29:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E186B9A6
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 17:25:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C75B5B81D66
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 01:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69640C433D2;
        Thu, 19 Jan 2023 01:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674091499;
        bh=uOBG0WaIOO57RDd8M9B5J2t71nUxGymzYuZn5q1szVQ=;
        h=Date:From:To:Cc:Subject:From;
        b=DJjhvXV5aO85m0rlfFKzBP3KPZPkTG+LO7whC0LdFK04714Tcs2rfo9CuMwkTFirl
         6hBY/JlBiJzHadwhmPWn0lfo1+RnE/imWMLe1sR0/8CcFh35bKWhjVR3DBCJQIrM+D
         KqtmB0k+OXNTyQlU3m3P0t5MqQni2CkxFPVfuIs3NUSlF3IJr40n6HjQ8ZINQRDwTO
         AtatOnkzg984JFOwuClMEzHqbWZIXzc+lzZqn4RnHgi8LV4P+KVLjaAweIdr1iWbUZ
         cPyDDiY9El3sV1k9txcsY+2YczjpEq4jZcOuJoOqj2MSWlDpABkhIPPHJ28mW4NTVR
         rvnrmlAoWHbrA==
Date:   Wed, 18 Jan 2023 17:24:58 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: recheck appropriateness of map_shared lock
Message-ID: <Y8ib6ls32e/pJezE@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While fuzzing the data fork extent count on a btree-format directory
with xfs/375, I observed the following (excerpted) splat:

XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_bmap.c, line: 1208
------------[ cut here ]------------
WARNING: CPU: 0 PID: 43192 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
Call Trace:
 <TASK>
 xfs_iread_extents+0x1af/0x210 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_dir_walk+0xb8/0x190 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_parent_count_parent_dentries+0x41/0x80 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_parent_validate+0x199/0x2e0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_parent+0xdf/0x130 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_scrub_metadata+0x2b8/0x730 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_scrubv_metadata+0x38b/0x4d0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_ioc_scrubv_metadata+0x111/0x160 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_file_ioctl+0x367/0xf50 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 __x64_sys_ioctl+0x82/0xa0
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

The cause of this is a race condition in xfs_ilock_data_map_shared,
which performs an unlocked access to the data fork to guess which lock
mode it needs:

Thread 0                          Thread 1

xfs_need_iread_extents
<observe no iext tree>
xfs_ilock(..., ILOCK_EXCL)
xfs_iread_extents
<observe no iext tree>
<check ILOCK_EXCL>
<load bmbt extents into iext>
<notice iext size doesn't
 match nextents>
                                  xfs_need_iread_extents
                                  <observe iext tree>
                                  xfs_ilock(..., ILOCK_SHARED)
<tear down iext tree>
xfs_iunlock(..., ILOCK_EXCL)
                                  xfs_iread_extents
                                  <observe no iext tree>
                                  <check ILOCK_EXCL>
                                  *BOOM*

mitigate this race by having thread 1 to recheck xfs_need_iread_extents
after taking the shared ILOCK.  If the iext tree isn't present, then we
need to upgrade to the exclusive ILOCK to try to load the bmbt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d354ea2b74f9..6ce1e0e9f256 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -117,6 +117,20 @@ xfs_ilock_data_map_shared(
 	if (xfs_need_iread_extents(&ip->i_df))
 		lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lock_mode);
+
+	/*
+	 * It's possible that the unlocked access of the data fork to determine
+	 * the lock mode could have raced with another thread that was failing
+	 * to load the bmbt but hadn't yet torn down the iext tree.  Recheck
+	 * the lock mode and upgrade to an exclusive lock if we need to.
+	 */
+	if (lock_mode == XFS_ILOCK_SHARED &&
+	    xfs_need_iread_extents(&ip->i_df)) {
+		xfs_iunlock(ip, lock_mode);
+		lock_mode = XFS_ILOCK_EXCL;
+		xfs_ilock(ip, lock_mode);
+	}
+
 	return lock_mode;
 }
 
@@ -129,6 +143,21 @@ xfs_ilock_attr_map_shared(
 	if (xfs_inode_has_attr_fork(ip) && xfs_need_iread_extents(&ip->i_af))
 		lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lock_mode);
+
+	/*
+	 * It's possible that the unlocked access of the attr fork to determine
+	 * the lock mode could have raced with another thread that was failing
+	 * to load the bmbt but hadn't yet torn down the iext tree.  Recheck
+	 * the lock mode and upgrade to an exclusive lock if we need to.
+	 */
+	if (lock_mode == XFS_ILOCK_SHARED &&
+	    xfs_inode_has_attr_fork(ip) &&
+	    xfs_need_iread_extents(&ip->i_af)) {
+		xfs_iunlock(ip, lock_mode);
+		lock_mode = XFS_ILOCK_EXCL;
+		xfs_ilock(ip, lock_mode);
+	}
+
 	return lock_mode;
 }
 
