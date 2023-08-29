Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C759CC83F12
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 06:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjH2G5l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 02:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbjH2G5T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 02:57:19 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E14C19B
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2023 23:57:15 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1bc83a96067so23903715ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2023 23:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693292235; x=1693897035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=eClb6zkNviBXrNgm1UAj117BnF2vDWs1UlgX88w5hYA=;
        b=yMg0+LCxjA/Cy/7VimMDCyU4IStSRAeus0EJwrKX2D5mwievpdlzYhdTQjDKzsEp2x
         pPSerLjxzwY743ejG7mYnmfo2ulopThF0RH5mtT00lMCcY/MU4i8qN4VWoJTmsyfWzd3
         mh89u4zAx0NMhvzg1CX1PE+DweToL3YC5C+X4IMmQ2YHIaFuWP6UAHKmiBl2E3zqgddB
         o0HVSOW95ZCRsfauuYr14MHsYXiiIbPmvhKw8j4Ghmaf6YibGcPZuyfrASRIS7+khBfr
         3C81ij99/L5TfgwSm6TE9NbseJJu3bF2YpQxPz2Lf1vTv6mlVBtglf8O72YKmRqdEG/P
         l3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693292235; x=1693897035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eClb6zkNviBXrNgm1UAj117BnF2vDWs1UlgX88w5hYA=;
        b=Si5hrA76bIKEVvmjBEtAk+K6VjYKHtX71dnLQVy3EgHDhC+e/RwF8wZ7mq+qNpw4eS
         3Jm1AHTukbcQRpKWBxfxSNwlbuM0ifnhyDvLzPwEN9Udddh1nOZgjsp1cy8YaU2T7nQP
         XQRnWfXEOz/l60OB1To5X34INacob2GjX6WodhcRhJdxsRfQzDwzVYUAoMKkyXr6BiDe
         oUou+Yyg0fPcfy90RhyveuZCq8idB3rBneflULtTzt8LNxpY90MfVD9Bf3exYwb3EBlv
         mLbpEFKs/UPXekTfu/qt60dw7T/irjPJIKh3n9vgPDA4k/BGpG2I7iG/ij/1zZISJS5V
         pCmQ==
X-Gm-Message-State: AOJu0YxUIrPEVB0iy1voJWvAfZ1Jyu9jWhliBUVqpJMM2zW+zPJSsXyv
        TIGCPorAha9KLRs5L60CKdynH0x28bQZ2i1aNmk=
X-Google-Smtp-Source: AGHT+IE4RFnoYYpzYJbK5sYXNE39YtWZBFVCV51C0Gm4pPvJ8MGqwrtudNuab2ae77hEhixqba8t4w==
X-Received: by 2002:a17:902:ec92:b0:1c0:d5b1:2de8 with SMTP id x18-20020a170902ec9200b001c0d5b12de8mr10696669plg.9.1693292234548;
        Mon, 28 Aug 2023 23:57:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id y1-20020a1709029b8100b001b86492d724sm4118461plp.223.2023.08.28.23.57.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 23:57:13 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qasf1-007yTd-0a
        for linux-xfs@vger.kernel.org;
        Tue, 29 Aug 2023 16:57:10 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qasf0-003w1s-2d
        for linux-xfs@vger.kernel.org;
        Tue, 29 Aug 2023 16:57:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] [RFC] xfs: reduce AGF hold times during fstrim operations
Date:   Tue, 29 Aug 2023 16:57:10 +1000
Message-Id: <20230829065710.938039-1-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

fstrim will hold the AGF lock for as long as it takes to walk and
discard all the free space in the AG that meets the userspace trim
criteria.i For AGs with lots of free space extents (e.g. millions)
or the underlying device is really slow at processing discard
requests (e.g. Ceph RBD), this means the AGF hold time is often
measured in minutes to hours, not a few milliseconds as we normal
see with non-discard based operations.

THis can result in the entire filesystem hanging whilst the
long-running fstrim is in progress. We can have transactions get
stuck waiting for the AGF lock (data or metadata extent allocation
and freeing), and then more transactions get stuck waiting on the
locks those transactions hold. We can get to the point where fstrim
blocks an extent allocation or free operation long enough that it
ends up pinning the tail of the log and the log then runs out of
space. At this point, every modification in the filesystem gets
blocked. This includes read operations, if atime updates need to be
made.

To fix this problem, we need to be able to discard free space
extents safely without holding the AGF lock. Fortunately, we already
do this with online discard via busy extents. We can makr free space
extents as "busy being discarded" under the AGF lock and then unlock
the AGF, knowing that nobody will be able to allocate that free
space extent until we remove it from the busy tree.

Modify xfs_trim_extents to use the same asynchronous discard
mechanism backed by busy extents as is used with online discard.
This results in the AGF only needing to be held for short periods of
time and it is never held while we issue discards. Hence if discard
submission gets throttled because it is slow and/or there are lots
of them, we aren't preventing other operations from being performed
on AGF while we wait for discards to complete...

This is an RFC because it's just the patch I've written to implement
the functionality and smoke test it. It isn't polished, I haven't
broken it up into fine-grained patches, etc. It's just a chunk of
code that fixes the problem so people can comment on the approach
and maybe spot something wrong that I haven't. IOWs, I'm looking for
comments on the functionality change, not the code itself....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_discard.c     | 274 ++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_extent_busy.c |  33 ++++-
 fs/xfs/xfs_extent_busy.h |   4 +
 3 files changed, 286 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index afc4c78b9eed..c2eec29c02d1 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (C) 2010 Red Hat, Inc.
+ * Copyright (C) 2010, 2023 Red Hat, Inc.
  * All Rights Reserved.
  */
 #include "xfs.h"
@@ -19,21 +19,81 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 
-STATIC int
-xfs_trim_extents(
+/*
+ * Notes on an efficient, low latency fstrim algorithm
+ *
+ * We need to walk the filesystem free space and issue discards on the free
+ * space that meet the search criteria (size and location). We cannot issue
+ * discards on extents that might be in use, or are so recently in use they are
+ * still marked as busy. To serialise against extent state changes whilst we are
+ * gathering extents to trim, we must hold the AGF lock to lock out other
+ * allocations and extent free operations that might change extent state.
+ *
+ * However, we cannot just hold the AGF for the entire AG free space walk whilst
+ * we issue discards on each free space that is found. Storage devices can have
+ * extremely slow discard implementations (e.g. ceph RBD) and so walking a
+ * couple of million free extents and issuing synchronous discards on each
+ * extent can take a *long* time. Whilst we are doing this walk, nothing else
+ * can access the AGF, and we can stall transactions and hence the log whilst
+ * modifications wait for the AGF lock to be released. This can lead hung tasks
+ * kicking the hung task timer and rebooting the system. This is bad.
+ *
+ * Hence we need to take a leaf from the bulkstat playbook. It takes the AGI
+ * lock, gathers a range of inode cluster buffers that are allocated, drops the
+ * AGI lock and then reads all the inode cluster buffers and processes them. It
+ * loops doing this, using a cursor to keep track of where it is up to in the AG
+ * for each iteration to restart the INOBT lookup from.
+ *
+ * We can't do this exactly with free space - once we drop the AGF lock, the
+ * state of the free extent is out of our control and we cannot run a discard
+ * safely on it in this situation. Unless, of course, we've marked the free
+ * extent as busy and undergoing a discard operation whilst we held the AGF
+ * locked.
+ *
+ * This is exactly how online discard works - free extents are marked busy when
+ * they are freed, and once the extent free has been committed to the journal,
+ * the busy extent record is marked as "undergoing discard" and the discard is
+ * then issued on the free extent. Once the discard completes, the busy extent
+ * record is removed and the extent is able to be allocated again.
+ *
+ * In the context of fstrim, if we find a free extent we need to discard, we
+ * don't have to discard it immediately. All we need to do it record that free
+ * extent as being busy and under discard, and all the allocation routines will
+ * now avoid trying to allocate it. Hence if we mark the extent as busy under
+ * the AGF lock, we can safely discard it without holding the AGF lock because
+ * nothing will attempt to allocate that free space until the discard completes.
+ *
+ * Hence we can makr fstrim behave much more like bulkstat and online discard
+ * w.r.t. AG header locking. By keeping the batch size low, we can minimise the
+ * AGF lock holdoffs whilst still safely being able to issue discards similar to
+ * bulkstat. We can also issue discards asynchronously like we do with online
+ * discard, and so for fast devices fstrim will run much faster as we can
+ * pipeline the free extent search with in flight discard IO.
+ */
+
+struct xfs_trim_work {
+	struct xfs_perag	*pag;
+	struct list_head	busy_extents;
+	uint64_t		blocks_trimmed;
+	struct work_struct	discard_endio_work;
+};
+
+static int
+xfs_trim_gather_extents(
 	struct xfs_perag	*pag,
 	xfs_daddr_t		start,
 	xfs_daddr_t		end,
 	xfs_daddr_t		minlen,
-	uint64_t		*blocks_trimmed)
+	xfs_extlen_t		*longest,
+	struct xfs_trim_work	*twork)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
-	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
 	struct xfs_agf		*agf;
 	int			error;
 	int			i;
+	int			batch = 100;
 
 	/*
 	 * Force out the log.  This means any transactions that might have freed
@@ -50,17 +110,27 @@ xfs_trim_extents(
 	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
 
 	/*
-	 * Look up the longest btree in the AGF and start with it.
+	 * Look up the extent length requested in the AGF and start with it.
+	 *
+	 * XXX: continuations really want a lt lookup here, so we get the
+	 * largest extent adjacent to the size finished off in the last batch.
+	 * The ge search here results in the extent discarded in the last batch
+	 * being discarded again before we move on to the smaller size...
 	 */
-	error = xfs_alloc_lookup_ge(cur, 0, be32_to_cpu(agf->agf_longest), &i);
+	error = xfs_alloc_lookup_ge(cur, 0, *longest, &i);
 	if (error)
 		goto out_del_cursor;
+	if (i == 0) {
+		/* nothing of that length left in the AG, we are done */
+		*longest = 0;
+		goto out_del_cursor;
+	}
 
 	/*
 	 * Loop until we are done with all extents that are large
-	 * enough to be worth discarding.
+	 * enough to be worth discarding or we hit batch limits.
 	 */
-	while (i) {
+	while (i && batch-- > 0) {
 		xfs_agblock_t	fbno;
 		xfs_extlen_t	flen;
 		xfs_daddr_t	dbno;
@@ -75,6 +145,20 @@ xfs_trim_extents(
 		}
 		ASSERT(flen <= be32_to_cpu(agf->agf_longest));
 
+		/*
+		 * Keep going on this batch until we hit the record size
+		 * changes. That way we will start the next batch with the new
+		 * extent size and we don't get stuck on an extent size when
+		 * there are more extents of that size than the batch size.
+		 */
+		if (batch == 0) {
+			if (flen != *longest)
+				break;
+			batch++;
+		} else {
+			*longest = flen;
+		}
+
 		/*
 		 * use daddr format for all range/len calculations as that is
 		 * the format the range/len variables are supplied in by
@@ -88,6 +172,7 @@ xfs_trim_extents(
 		 */
 		if (dlen < minlen) {
 			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
+			*longest = 0;
 			break;
 		}
 
@@ -110,29 +195,180 @@ xfs_trim_extents(
 			goto next_extent;
 		}
 
-		trace_xfs_discard_extent(mp, pag->pag_agno, fbno, flen);
-		error = blkdev_issue_discard(bdev, dbno, dlen, GFP_NOFS);
-		if (error)
-			break;
-		*blocks_trimmed += flen;
-
+		xfs_extent_busy_insert_discard(pag, fbno, flen,
+				&twork->busy_extents);
+		twork->blocks_trimmed += flen;
 next_extent:
 		error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			break;
 
-		if (fatal_signal_pending(current)) {
-			error = -ERESTARTSYS;
-			break;
-		}
+		/*
+		 * If there's no more records in the tree, we are done. Set
+		 * longest to 0 to indicate to the caller that there is no more
+		 * extents to search.
+		 */
+		if (i == 0)
+			*longest = 0;
 	}
 
+	/*
+	 * If there was an error, release all the gathered busy extents because
+	 * we aren't going to issue a discard on them any more. If we ran out of
+	 * records, set *longest to zero to tell the caller there is nothing
+	 * left in this AG.
+	 */
+	if (error)
+		xfs_extent_busy_clear(pag->pag_mount, &twork->busy_extents,
+				false);
 out_del_cursor:
 	xfs_btree_del_cursor(cur, error);
 	xfs_buf_relse(agbp);
 	return error;
 }
 
+static void
+xfs_trim_discard_endio_work(
+	struct work_struct	*work)
+{
+	struct xfs_trim_work	*twork =
+		container_of(work, struct xfs_trim_work, discard_endio_work);
+	struct xfs_perag	*pag = twork->pag;
+
+	xfs_extent_busy_clear(pag->pag_mount, &twork->busy_extents, false);
+	kmem_free(twork);
+	xfs_perag_rele(pag);
+}
+
+/*
+ * Queue up the actual completion to a thread to avoid IRQ-safe locking for
+ * pagb_lock.
+ */
+static void
+xfs_trim_discard_endio(
+	struct bio		*bio)
+{
+	struct xfs_trim_work	*twork = bio->bi_private;
+
+	INIT_WORK(&twork->discard_endio_work, xfs_trim_discard_endio_work);
+	queue_work(xfs_discard_wq, &twork->discard_endio_work);
+	bio_put(bio);
+}
+
+/*
+ * Walk the discard list and issue discards on all the busy extents in the
+ * list. We plug and chain the bios so that we only need a single completion
+ * call to clear all the busy extents once the discards are complete.
+ *
+ * XXX: This is largely a copy of xlog_discard_busy_extents(), opportunity for
+ * a common implementation there.
+ */
+static int
+xfs_trim_discard_extents(
+	struct xfs_perag	*pag,
+	struct xfs_trim_work	*twork)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_extent_busy	*busyp;
+	struct bio		*bio = NULL;
+	struct blk_plug		plug;
+	int			error = 0;
+
+	blk_start_plug(&plug);
+	list_for_each_entry(busyp, &twork->busy_extents, list) {
+		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
+					 busyp->length);
+
+		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
+				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
+				XFS_FSB_TO_BB(mp, busyp->length),
+				GFP_NOFS, &bio);
+		if (error && error != -EOPNOTSUPP) {
+			xfs_info(mp,
+	 "discard failed for extent [0x%llx,%u], error %d",
+				 (unsigned long long)busyp->bno,
+				 busyp->length,
+				 error);
+			break;
+		}
+	}
+
+	if (bio) {
+		bio->bi_private = twork;
+		bio->bi_end_io = xfs_trim_discard_endio;
+		submit_bio(bio);
+	} else {
+		xfs_trim_discard_endio_work(&twork->discard_endio_work);
+	}
+	blk_finish_plug(&plug);
+
+	return error;
+}
+
+/*
+ * Iterate the free list gathering extents and discarding them. We need a cursor
+ * for the repeated iteration of gather/discard loop, so use the longest extent
+ * we found in the last batch as the key to start the next.
+ */
+static int
+xfs_trim_extents(
+	struct xfs_perag	*pag,
+	xfs_daddr_t		start,
+	xfs_daddr_t		end,
+	xfs_daddr_t		minlen,
+	uint64_t		*blocks_trimmed)
+{
+	struct xfs_trim_work	*twork;
+	xfs_extlen_t		longest = pag->pagf_longest;
+	int			error = 0;
+
+	do {
+		LIST_HEAD(extents);
+
+		twork = kzalloc(sizeof(*twork), GFP_KERNEL);
+		if (!twork) {
+			error = -ENOMEM;
+			break;
+		}
+
+		atomic_inc(&pag->pag_active_ref);
+		twork->pag = pag;
+		INIT_LIST_HEAD(&twork->busy_extents);
+
+		error = xfs_trim_gather_extents(pag, start, end, minlen,
+				&longest, twork);
+		if (error) {
+			kfree(twork);
+			xfs_perag_rele(pag);
+			break;
+		}
+
+		/*
+		 * We hand the trim work to the discard function here so that
+		 * the busy list can be walked when the discards complete and
+		 * removed from the busy extent list. This allows the discards
+		 * to run asynchronously with gathering the next round of
+		 * extents to discard.
+		 *
+		 * However, we must ensure that we do not reference twork after
+		 * this function call, as it may have been freed by the time it
+		 * returns control to us.
+		 */
+		*blocks_trimmed += twork->blocks_trimmed;
+		error = xfs_trim_discard_extents(pag, twork);
+		if (error)
+			break;
+
+		if (fatal_signal_pending(current)) {
+			error = -ERESTARTSYS;
+			break;
+		}
+	} while (longest != 0);
+
+	return error;
+
+}
+
 /*
  * trim a range of the filesystem.
  *
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 7c2fdc71e42d..53c49b47daca 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -19,13 +19,13 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 
-void
-xfs_extent_busy_insert(
-	struct xfs_trans	*tp,
+static void
+xfs_extent_busy_insert_list(
 	struct xfs_perag	*pag,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	unsigned int		flags)
+	unsigned int		flags,
+	struct list_head	*busy_list)
 {
 	struct xfs_extent_busy	*new;
 	struct xfs_extent_busy	*busyp;
@@ -40,7 +40,7 @@ xfs_extent_busy_insert(
 	new->flags = flags;
 
 	/* trace before insert to be able to see failed inserts */
-	trace_xfs_extent_busy(tp->t_mountp, pag->pag_agno, bno, len);
+	trace_xfs_extent_busy(pag->pag_mount, pag->pag_agno, bno, len);
 
 	spin_lock(&pag->pagb_lock);
 	rbp = &pag->pagb_tree.rb_node;
@@ -62,10 +62,31 @@ xfs_extent_busy_insert(
 	rb_link_node(&new->rb_node, parent, rbp);
 	rb_insert_color(&new->rb_node, &pag->pagb_tree);
 
-	list_add(&new->list, &tp->t_busy);
+	list_add(&new->list, busy_list);
 	spin_unlock(&pag->pagb_lock);
 }
 
+void
+xfs_extent_busy_insert(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	unsigned int		flags)
+{
+	xfs_extent_busy_insert_list(pag, bno, len, flags, &tp->t_busy);
+}
+
+void xfs_extent_busy_insert_discard(
+	struct xfs_perag	*pag,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	struct list_head	*busy_list)
+{
+	xfs_extent_busy_insert_list(pag, bno, len, XFS_EXTENT_BUSY_DISCARDED,
+			busy_list);
+}
+
 /*
  * Search for a busy extent within the range of the extent we are about to
  * allocate.  You need to be holding the busy extent tree lock when calling
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index c37bf87e6781..f99073208770 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -35,6 +35,10 @@ void
 xfs_extent_busy_insert(struct xfs_trans *tp, struct xfs_perag *pag,
 	xfs_agblock_t bno, xfs_extlen_t len, unsigned int flags);
 
+void
+xfs_extent_busy_insert_discard(struct xfs_perag *pag, xfs_agblock_t bno,
+	xfs_extlen_t len, struct list_head *busy_list);
+
 void
 xfs_extent_busy_clear(struct xfs_mount *mp, struct list_head *list,
 	bool do_discard);
-- 
2.40.1

