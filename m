Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F024DC43334
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jul 2022 22:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiGIWwR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jul 2022 18:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGIWwQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jul 2022 18:52:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B057413EB5
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 15:52:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63000B80815
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 22:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1C3C3411C;
        Sat,  9 Jul 2022 22:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657407133;
        bh=8doG9T8lnGDOCq1UZLvqYVXV/8aW51hkF66OYoqiwcY=;
        h=Date:From:To:Cc:Subject:From;
        b=guGdrGyytUl0Qt5raGIKaLbwVpIn+8hbL9Kjhj5c7WbULSMVrn+etAyVRr6LyN6Ti
         qtZGnEe56cFexJfYe4KycyQ3fwMWVF6JP4Xh90QKfIVYsNF6FC9b495i0MP8AAyYI9
         vIu8sffsHbEyrNXdJGOZ2TFk7xd05mW1XD+gltf+7t0PxkvrMAubAzta+nn5ovMTEZ
         R7ZkmAr5g3E/dedF/zZVwTtoPY4teIuM3e6v+ti/9ZGshca+XHFHsVs3Nps/ipEldT
         LgY0xefFa47XXAMpC11Mz7rXKSVuxoXJ2mpuTiYSOFNQ15N04KG6CnI4YQcHR6FswN
         jLqKNfzEWMrgg==
Date:   Sat, 9 Jul 2022 15:52:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, oliver.sang@intel.com
Subject: [PATCH v2] xfs: fix use-after-free in xattr node block inactivation
Message-ID: <YsoGnNoF8pGTBPFd@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The kernel build robot reported a UAF error while running xfs/433
(edited somewhat for brevity):

 BUG: KASAN: use-after-free in xfs_attr3_node_inactive (fs/xfs/xfs_attr_inactive.c:214) xfs
 Read of size 4 at addr ffff88820ac2bd44 by task kworker/0:2/139

 CPU: 0 PID: 139 Comm: kworker/0:2 Tainted: G S                5.19.0-rc2-00004-g7cf2b0f9611b #1
 Hardware name: Hewlett-Packard p6-1451cx/2ADA, BIOS 8.15 02/05/2013
 Workqueue: xfs-inodegc/sdb4 xfs_inodegc_worker [xfs]
 Call Trace:
  <TASK>
 dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1))
 print_address_description+0x1f/0x200
 print_report.cold (mm/kasan/report.c:430)
 kasan_report (mm/kasan/report.c:162 mm/kasan/report.c:493)
 xfs_attr3_node_inactive (fs/xfs/xfs_attr_inactive.c:214) xfs
 xfs_attr3_root_inactive (fs/xfs/xfs_attr_inactive.c:296) xfs
 xfs_attr_inactive (fs/xfs/xfs_attr_inactive.c:371) xfs
 xfs_inactive (fs/xfs/xfs_inode.c:1781) xfs
 xfs_inodegc_worker (fs/xfs/xfs_icache.c:1837 fs/xfs/xfs_icache.c:1860) xfs
 process_one_work
 worker_thread
 kthread
 ret_from_fork
  </TASK>

 Allocated by task 139:
 kasan_save_stack (mm/kasan/common.c:39)
 __kasan_slab_alloc (mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:469)
 kmem_cache_alloc (mm/slab.h:750 mm/slub.c:3214 mm/slub.c:3222 mm/slub.c:3229 mm/slub.c:3239)
 _xfs_buf_alloc (include/linux/instrumented.h:86 include/linux/atomic/atomic-instrumented.h:41 fs/xfs/xfs_buf.c:232) xfs
 xfs_buf_get_map (fs/xfs/xfs_buf.c:660) xfs
 xfs_buf_read_map (fs/xfs/xfs_buf.c:777) xfs
 xfs_trans_read_buf_map (fs/xfs/xfs_trans_buf.c:289) xfs
 xfs_da_read_buf (fs/xfs/libxfs/xfs_da_btree.c:2652) xfs
 xfs_da3_node_read (fs/xfs/libxfs/xfs_da_btree.c:392) xfs
 xfs_attr3_root_inactive (fs/xfs/xfs_attr_inactive.c:272) xfs
 xfs_attr_inactive (fs/xfs/xfs_attr_inactive.c:371) xfs
 xfs_inactive (fs/xfs/xfs_inode.c:1781) xfs
 xfs_inodegc_worker (fs/xfs/xfs_icache.c:1837 fs/xfs/xfs_icache.c:1860) xfs
 process_one_work
 worker_thread
 kthread
 ret_from_fork

 Freed by task 139:
 kasan_save_stack (mm/kasan/common.c:39)
 kasan_set_track (mm/kasan/common.c:45)
 kasan_set_free_info (mm/kasan/generic.c:372)
 __kasan_slab_free (mm/kasan/common.c:368 mm/kasan/common.c:328 mm/kasan/common.c:374)
 kmem_cache_free (mm/slub.c:1753 mm/slub.c:3507 mm/slub.c:3524)
 xfs_buf_rele (fs/xfs/xfs_buf.c:1040) xfs
 xfs_attr3_node_inactive (fs/xfs/xfs_attr_inactive.c:210) xfs
 xfs_attr3_root_inactive (fs/xfs/xfs_attr_inactive.c:296) xfs
 xfs_attr_inactive (fs/xfs/xfs_attr_inactive.c:371) xfs
 xfs_inactive (fs/xfs/xfs_inode.c:1781) xfs
 xfs_inodegc_worker (fs/xfs/xfs_icache.c:1837 fs/xfs/xfs_icache.c:1860) xfs
 process_one_work
 worker_thread
 kthread
 ret_from_fork

I reproduced this for my own satisfaction, and got the same report,
along with an extra morsel:

 The buggy address belongs to the object at ffff88802103a800
  which belongs to the cache xfs_buf of size 432
 The buggy address is located 396 bytes inside of
  432-byte region [ffff88802103a800, ffff88802103a9b0)

I tracked this code down to:

	error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
			child_blkno,
			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
			&child_bp);
	if (error)
		return error;
	error = bp->b_error;

That doesn't look right -- I think this should be dereferencing
child_bp, not bp.  Looking through the codebase history, I think this
was added by commit 2911edb653b9 ("xfs: remove the mappedbno argument to
xfs_da_get_buf"), which replaced a call to xfs_da_get_buf with the
current call to xfs_trans_get_buf.  Not sure why we trans_brelse'd @bp
earlier in the function, but I'm guessing it's to avoid pinning too many
buffers in memory while we inactivate the bottom of the attr tree.
Hence we now have to get the buffer back.

I /think/ this was supposed to check child_bp->b_error and fail the rest
of the invalidation if child_bp had experienced any kind of IO or
corruption error.  I bet the xfs_da3_node_read earlier in the loop will
catch most cases of incoming on-disk corruption which makes this check
mostly moot unless someone corrupts the buffer and the AIL pushes it out
to disk while the buffer's unlocked.

In the first case we'll never get to the bad check, and in the second
case the AIL will shut down the log, at which point there's no reason to
check b_error.  Remove the check, and null out @bp to avoid this problem
in the future.

Cc: hch@lst.de
Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: 2911edb653b9 ("xfs: remove the mappedbno argument to xfs_da_get_buf")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: remove the entire b_error test and bailout block, null out some more
freed variables
---
 fs/xfs/xfs_attr_inactive.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 0e83cab9cdde..895ba8b7a26c 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -158,6 +158,7 @@ xfs_attr3_node_inactive(
 	}
 	child_fsb = be32_to_cpu(ichdr.btree[0].before);
 	xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
+	bp = NULL;
 
 	/*
 	 * If this is the node level just above the leaves, simply loop
@@ -211,12 +212,8 @@ xfs_attr3_node_inactive(
 				&child_bp);
 		if (error)
 			return error;
-		error = bp->b_error;
-		if (error) {
-			xfs_trans_brelse(*trans, child_bp);
-			return error;
-		}
 		xfs_trans_binval(*trans, child_bp);
+		child_bp = NULL;
 
 		/*
 		 * If we're not done, re-read the parent to get the next
@@ -233,6 +230,7 @@ xfs_attr3_node_inactive(
 						  bp->b_addr);
 			child_fsb = be32_to_cpu(phdr.btree[i + 1].before);
 			xfs_trans_brelse(*trans, bp);
+			bp = NULL;
 		}
 		/*
 		 * Atomically commit the whole invalidate stuff.
