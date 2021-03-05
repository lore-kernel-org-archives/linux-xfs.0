Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4799AC433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 145B065017
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbhCEFLz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 00:11:55 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:40392 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhCEFLw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:11:52 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id DA4AF78AFD1
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:50 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-00FboC-CB
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-000lZE-3y
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/45] xfs: reduce buffer log item shadow allocations
Date:   Fri,  5 Mar 2021 16:11:08 +1100
Message-Id: <20210305051143.182133-11-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
        a=FNdSPaME_fANvIEDIncA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we modify btrees repeatedly, we regularly increase the size of
the logged region by a single chunk at a time (per transaction
commit). This results in the CIL formatting code having to
reallocate the log vector buffer every time the buffer dirty region
grows. Hence over a typical 4kB btree buffer, we might grow the log
vector 4096/128 = 32x over a short period where we repeatedly add
or remove records to/from the buffer over a series of running
transaction. This means we are doing 32 memory allocations and frees
over this time during a performance critical path in the journal.

The amount of space tracked in the CIL for the object is calculated
during the ->iop_format() call for the buffer log item, but the
buffer memory allocated for it is calculated by the ->iop_size()
call. The size callout determines the size of the buffer, the format
call determines the space used in the buffer.

Hence we can oversize the buffer space required in the size
calculation without impacting the amount of space used and accounted
to the CIL for the changes being logged. This allows us to reduce
the number of allocations by rounding up the buffer size to allow
for future growth. This can safe a substantial amount of CPU time in
this path:

-   46.52%     2.02%  [kernel]                  [k] xfs_log_commit_cil
   - 44.49% xfs_log_commit_cil
      - 30.78% _raw_spin_lock
         - 30.75% do_raw_spin_lock
              30.27% __pv_queued_spin_lock_slowpath

(oh, ouch!)
....
      - 1.05% kmem_alloc_large
         - 1.02% kmem_alloc
              0.94% __kmalloc

This overhead here us what this patch is aimed at. After:

      - 0.76% kmem_alloc_large
         - 0.75% kmem_alloc
              0.70% __kmalloc

The size of 512 bytes is based on the bitmap chunk size being 128
bytes and that random directory entry updates almost never require
more than 3-4 128 byte regions to be logged in the directory block.

The other observation is for per-ag btrees. When we are inserting
into a new btree block, we'll pack it from the front. Hence the
first few records land in the first 128 bytes so we log only 128
bytes, the next 8-16 records land in the second region so now we log
256 bytes. And so on.  If we are doing random updates, it will only
allocate every 4 random 128 byte regions that are dirtied instead of
every single one.

Any larger than 512 bytes and I noticed an increase in memory
footprint in my scalability workloads. Any less than this and I
didn't really see any significant benefit to CPU usage.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 17960b1ce5ef..0628a65d9c55 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -142,6 +142,7 @@ xfs_buf_item_size(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	int			i;
+	int			bytes;
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	if (bip->bli_flags & XFS_BLI_STALE) {
@@ -173,7 +174,7 @@ xfs_buf_item_size(
 	}
 
 	/*
-	 * the vector count is based on the number of buffer vectors we have
+	 * The vector count is based on the number of buffer vectors we have
 	 * dirty bits in. This will only be greater than one when we have a
 	 * compound buffer with more than one segment dirty. Hence for compound
 	 * buffers we need to track which segment the dirty bits correspond to,
@@ -181,10 +182,18 @@ xfs_buf_item_size(
 	 * count for the extra buf log format structure that will need to be
 	 * written.
 	 */
+	bytes = 0;
 	for (i = 0; i < bip->bli_format_count; i++) {
 		xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
-					  nvecs, nbytes);
+					  nvecs, &bytes);
 	}
+
+	/*
+	 * Round up the buffer size required to minimise the number of memory
+	 * allocations that need to be done as this item grows when relogged by
+	 * repeated modifications.
+	 */
+	*nbytes = round_up(bytes, 512);
 	trace_xfs_buf_item_size(bip);
 }
 
-- 
2.28.0

