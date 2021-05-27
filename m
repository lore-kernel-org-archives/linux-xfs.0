Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17EFC4708C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 04:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE90D61073
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 04:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhE0Exn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 00:53:43 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:51001 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234363AbhE0Exl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 00:53:41 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 3D38B1AFF11
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 14:52:06 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm804-005h17-Nd
        for linux-xfs@vger.kernel.org; Thu, 27 May 2021 14:52:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm804-004qgR-F0
        for linux-xfs@vger.kernel.org; Thu, 27 May 2021 14:52:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] xfs: bunmapi has unnecessary AG lock ordering issues
Date:   Thu, 27 May 2021 14:51:58 +1000
Message-Id: <20210527045202.1155628-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527045202.1155628-1-david@fromorbit.com>
References: <20210527045202.1155628-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=jemw3zrVzxxEioCUW9kA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

large directory block size operations are assert failing because
xfs_bunmapi() is not completely removing fragmented directory blocks
like so:

XFS: Assertion failed: done, file: fs/xfs/libxfs/xfs_dir2.c, line: 677
....
Call Trace:
 xfs_dir2_shrink_inode+0x1a8/0x210
 xfs_dir2_block_to_sf+0x2ae/0x410
 xfs_dir2_block_removename+0x21a/0x280
 xfs_dir_removename+0x195/0x1d0
 xfs_rename+0xb79/0xc50
 ? avc_has_perm+0x8d/0x1a0
 ? avc_has_perm_noaudit+0x9a/0x120
 xfs_vn_rename+0xdb/0x150
 vfs_rename+0x719/0xb50
 ? __lookup_hash+0x6a/0xa0
 do_renameat2+0x413/0x5e0
 __x64_sys_rename+0x45/0x50
 do_syscall_64+0x3a/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xae

We are aborting the bunmapi() pass because of this specific chunk of
code:

                /*
                 * Make sure we don't touch multiple AGF headers out of order
                 * in a single transaction, as that could cause AB-BA deadlocks.
                 */
                if (!wasdel && !isrt) {
                        agno = XFS_FSB_TO_AGNO(mp, del.br_startblock);
                        if (prev_agno != NULLAGNUMBER && prev_agno > agno)
                                break;
                        prev_agno = agno;
                }

This is designed to prevent deadlocks in AGF locking when freeing
multiple extents by ensuring that we only ever lock in increasing
AG number order. Unfortunately, this also violates the "bunmapi will
always succeed" semantic that some high level callers depend on,
such as xfs_dir2_shrink_inode(), xfs_da_shrink_inode() and
xfs_inactive_symlink_rmt().

This AG lock ordering was introduced back in 2017 to fix deadlocks
triggered by generic/299 as reported here:

https://lore.kernel.org/linux-xfs/800468eb-3ded-9166-20a4-047de8018582@gmail.com/

This codebase is old enough that it was before we were defering all
AG based extent freeing from within xfs_bunmapi(). THat is, we never
actually lock AGs in xfs_bunmapi() any more - every non-rt based
extent free is added to the defer ops list, as is all BMBT block
freeing. And RT extents are not RT based, so there's no lock
ordering issues associated with them.

Hence this AGF lock ordering code is both broken and dead. Let's
just remove it so that the large directory block code works reliably
again.

Tested against xfs/538 and generic/299 which is the original test
that exposed the deadlocks that this code fixed.

Fixes: 5b094d6dac04 ("xfs: fix multi-AG deadlock in xfs_bunmapi")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3f8b6da09261..a3e0e6f672d6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5349,7 +5349,6 @@ __xfs_bunmapi(
 	xfs_fsblock_t		sum;
 	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
 	xfs_fileoff_t		max_len;
-	xfs_agnumber_t		prev_agno = NULLAGNUMBER, agno;
 	xfs_fileoff_t		end;
 	struct xfs_iext_cursor	icur;
 	bool			done = false;
@@ -5441,16 +5440,6 @@ __xfs_bunmapi(
 		del = got;
 		wasdel = isnullstartblock(del.br_startblock);
 
-		/*
-		 * Make sure we don't touch multiple AGF headers out of order
-		 * in a single transaction, as that could cause AB-BA deadlocks.
-		 */
-		if (!wasdel && !isrt) {
-			agno = XFS_FSB_TO_AGNO(mp, del.br_startblock);
-			if (prev_agno != NULLAGNUMBER && prev_agno > agno)
-				break;
-			prev_agno = agno;
-		}
 		if (got.br_startoff < start) {
 			del.br_startoff = start;
 			del.br_blockcount -= start - got.br_startoff;
-- 
2.31.1

