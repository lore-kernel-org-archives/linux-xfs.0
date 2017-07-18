Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56694 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751402AbdGRONi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Jul 2017 10:13:38 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 830627DCC8
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 14:13:38 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66D476F92C
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 14:13:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC] xfs: fix buffer check for primary sb in userspace libxfs
Date: Tue, 18 Jul 2017 10:13:37 -0400
Message-Id: <20170718141337.46255-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This patch is actually targeted at userspace. The previous change in commit
f3d7ebde ("xfs: fix superblock inprogress check") to use ->b_maps technically
breaks the logic in userspace in a similar way to the original problem because
userspace has no concept of uncached buffers.  ->b_maps is NULL in userspace
unless the buffer is truly discontiguous.

This would normally result in a segfault but this appears to be hidden
by gcc optimization as -O2 is enabled by default and the
check_inprogress param to xfs_mount_validate_sb() is unused in
userspace. Therefore, the segfault is only reproducible when
optimization is disabled (which is a useful configuration for
debugging).

There are obviously different ways to fix this. I'm floating this (untested)
rfc as a kernel patch (do we ever sync libxfs from xfsprogs -> kernel?) with
the objective of keeping the libxfs code the same between the kernel and
userspace. We could alternatively create a custom helper/macro with the
appropriate check in each place. Thoughts?

Brian

 fs/xfs/libxfs/xfs_sb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 9b5aae2..ec2fd03 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -583,6 +583,7 @@ xfs_sb_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_sb	sb;
+	bool		primary_sb;
 
 	/*
 	 * Use call variant which doesn't convert quota flags from disk 
@@ -592,11 +593,14 @@ xfs_sb_verify(
 
 	/*
 	 * Only check the in progress field for the primary superblock as
-	 * mkfs.xfs doesn't clear it from secondary superblocks.
+	 * mkfs.xfs doesn't clear it from secondary superblocks. Note that
+	 * userspace libxfs does not have uncached buffers and so b_maps is not
+	 * used for the sb buffer.
 	 */
-	return xfs_mount_validate_sb(mp, &sb,
-				     bp->b_maps[0].bm_bn == XFS_SB_DADDR,
-				     check_version);
+	primary_sb = (bp->b_bn == XFS_BUF_DADDR_NULL &&
+		      bp->b_maps[0].bm_bn == XFS_SB_DADDR) ||
+		     bp->b_bn == XFS_SB_DADDR;
+	return xfs_mount_validate_sb(mp, &sb, primary_sb, check_version);
 }
 
 /*
-- 
2.9.4

