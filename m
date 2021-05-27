Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A2DC4708B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 04:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0277F613CC
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 04:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhE0Exm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 00:53:42 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:35272 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234365AbhE0Exk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 00:53:40 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 3E3DE11411D4
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 14:52:06 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm804-005h19-Ne
        for linux-xfs@vger.kernel.org; Thu, 27 May 2021 14:52:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm804-004qgP-EA
        for linux-xfs@vger.kernel.org; Thu, 27 May 2021 14:52:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] xfs: btree format inode forks can have zero extents
Date:   Thu, 27 May 2021 14:51:57 +1000
Message-Id: <20210527045202.1155628-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527045202.1155628-1-david@fromorbit.com>
References: <20210527045202.1155628-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=RfcaFHgcWMp4lnFpylIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs/538 is assert failing with this trace when testing with
directory block sizes of 64kB:

XFS: Assertion failed: !xfs_need_iread_extents(ifp), file: fs/xfs/libxfs/xfs_bmap.c, line: 608
....
Call Trace:
 xfs_bmap_btree_to_extents+0x2a9/0x470
 ? kmem_cache_alloc+0xe7/0x220
 __xfs_bunmapi+0x4ca/0xdf0
 xfs_bunmapi+0x1a/0x30
 xfs_dir2_shrink_inode+0x71/0x210
 xfs_dir2_block_to_sf+0x2ae/0x410
 xfs_dir2_block_removename+0x21a/0x280
 xfs_dir_removename+0x195/0x1d0
 xfs_remove+0x244/0x460
 xfs_vn_unlink+0x53/0xa0
 ? selinux_inode_unlink+0x13/0x20
 vfs_unlink+0x117/0x220
 do_unlinkat+0x1a2/0x2d0
 __x64_sys_unlink+0x42/0x60
 do_syscall_64+0x3a/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xae

This is a check to ensure that the extents have been read into
memory before we are doing a ifork btree manipulation. This assert
is bogus in the above case.

We have a fragmented directory block that has more extents in it
than can fit in extent format, so the inode data fork is in btree
format. xfs_dir2_shrink_inode() asks to remove all remaining 16
filesystem blocks from the inode so it can convert to short form,
and __xfs_bunmapi() removes all the extents. We now have a data fork
in btree format but have zero extents in the fork. This incorrectly
trips the xfs_need_iread_extents() assert because it assumes that an
empty extent btree means the extent tree has not been read into
memory yet. This is clearly not the case with xfs_bunmapi(), as it
has an explicit call to xfs_iread_extents() in it to pull the
extents into memory before it starts unmapping.

Also, the assert directly after this bogus one is:

	ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);

Which covers the context in which it is legal to call
xfs_bmap_btree_to_extents just fine. Hence we should just remove the
bogus assert as it is clearly wrong and causes a regression.

The returns the test behaviour to the pre-existing assert failure in
xfs_dir2_shrink_inode() that indicates xfs_bunmapi() has failed to
remove all the extents in the range it was asked to unmap.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7e3b9b01431e..3f8b6da09261 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -605,7 +605,6 @@ xfs_bmap_btree_to_extents(
 
 	ASSERT(cur);
 	ASSERT(whichfork != XFS_COW_FORK);
-	ASSERT(!xfs_need_iread_extents(ifp));
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 	ASSERT(be16_to_cpu(rblock->bb_level) == 1);
 	ASSERT(be16_to_cpu(rblock->bb_numrecs) == 1);
-- 
2.31.1

