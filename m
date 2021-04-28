Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8ABC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 06:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF7EE61400
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 06:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbhD1Gw6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 02:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236303AbhD1Gw5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 02:52:57 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C147C06175F
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 23:52:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so4858284pjb.4
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 23:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BMbbpLCRtWYMHeo3LpOqsi735MK2/h7Xcwh9ksODX1c=;
        b=dNbyftEQFaXERBr/wgz0UazLY6Alwb4xxKElspkkGTBxeuAjDc80Et4XZWcJ7p12a5
         Ye+ZcPo9NMA++NYaVQjiq+lvesiuKkjgisKi3UOBT+Mwu0S9uwQout5KxMAaWr4Qbvuk
         r+nmlUatngYK+SeyHUYan0IAMH7tDe2dnp4ztIlVJEDJ3YHJ81lcFQd0RxTdbcNmqzoF
         4UekHDBK/54cC5HHemW97IsekkD5jA1sbEoFoGA1ffMqt53pKmoUtL16VrPOM9CGfS6R
         pPSr5UXWDA7daXDYeX3MZScld+DQoKU9/jaCCy55iPtum5Lx8iKVXKoPR0YcpTpRd2FV
         /qJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BMbbpLCRtWYMHeo3LpOqsi735MK2/h7Xcwh9ksODX1c=;
        b=GL3uSsabUdcGPfmNGA/A/OFPZwAKBYpWLOOsiswb1vxm1QEUtkTeQmoN2/W3l3dZNo
         xaB6j37MOw2meeQC1arMxpG5q7YQOmG5GD6MKqGZxYxHpfX8OvTbhGNX0bC4dBH+UhPx
         jzu4LB1ycE4UlbrR5+HjxsikYbR7OvZh+T73qJZ/0MNi80JiRGTvka6RuGGD0vJ1CGjY
         z5KuGO1N1r99F9eT/CInxo6TtGJSTF5da6tgYhPk6TJ5aES8kJpIDDgQ3uYx1sULuyCi
         DBfVIH/LH0X5flvRE9cpvFejBQlGp6y4ukTLYQV+o7x1GFlpew6ZWLSt6VBQ5wngiB8y
         rxRw==
X-Gm-Message-State: AOAM532dYIqrM+T/dqCnFOr5C+CUO7kX1mVm5z/bho7LX/cdLUUdXEY8
        qGT2K9X/DLLzJfWgZpS6IqIEE5nHgok=
X-Google-Smtp-Source: ABdhPJxGxcRLSXVrFu6FOc/Bb+JKN1H4Co03TAZZOxrnZfUjtdM/mD+YT9C6XcxAKl8zbT83DRV0Xw==
X-Received: by 2002:a17:90a:4e81:: with SMTP id o1mr2281240pjh.7.1619592731582;
        Tue, 27 Apr 2021 23:52:11 -0700 (PDT)
Received: from localhost.localdomain ([122.171.137.194])
        by smtp.gmail.com with ESMTPSA id u12sm4039551pfh.122.2021.04.27.23.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 23:52:11 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>
Subject: [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for AGFL
Date:   Wed, 28 Apr 2021 12:21:52 +0530
Message-Id: <20210428065152.77280-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428065152.77280-1-chandanrlinux@gmail.com>
References: <20210428065152.77280-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Executing xfs/538 after disabling injection of bmap_alloc_minlen_extent error
can cause several tasks to trigger hung task timeout. Most of the tasks are
blocked on getting a lock on an AG's AGF buffer. However, The task which has
the lock on the AG's AGF buffer has the following call trace,

PID: 1341   TASK: ffff8881073f3700  CPU: 1   COMMAND: "fsstress"
   __schedule+0x22f at ffffffff81f75e8f
   schedule+0x46 at ffffffff81f76366
   xfs_extent_busy_flush+0x69 at ffffffff81477d99
   xfs_alloc_ag_vextent_size+0x16a at ffffffff8141711a
   xfs_alloc_ag_vextent+0x19b at ffffffff81417edb
   xfs_alloc_fix_freelist+0x22f at ffffffff8141896f
   xfs_free_extent_fix_freelist+0x6a at ffffffff8141939a
   __xfs_free_extent+0x99 at ffffffff81419499
   xfs_trans_free_extent+0x3e at ffffffff814a6fee
   xfs_extent_free_finish_item+0x24 at ffffffff814a70d4
   xfs_defer_finish_noroll+0x1f7 at ffffffff81441407
   xfs_defer_finish+0x11 at ffffffff814417e1
   xfs_itruncate_extents_flags+0x13d at ffffffff8148b7dd
   xfs_inactive_truncate+0xb9 at ffffffff8148bb89
   xfs_inactive+0x227 at ffffffff8148c4f7
   xfs_fs_destroy_inode+0xb8 at ffffffff81496898
   destroy_inode+0x3b at ffffffff8127d2ab
   do_unlinkat+0x1d1 at ffffffff81270df1
   do_syscall_64+0x40 at ffffffff81f6b5f0
   entry_SYSCALL_64_after_hwframe+0x44 at ffffffff8200007c

The following sequence of events lead to the above listed call trace,

1. The task frees atleast two extents belonging to the file being truncated.
2. The corresponding xfs_extent_free_items are stored in the list pointed to
   by xfs_defer_pending->dfp_work.
3. When executing the next step of the rolling transaction, The first of the
   above mentioned extents is freed. The corresponding busy extent entry is
   added to the current transaction's tp->t_busy list as well as to the perag
   rb tree at xfs_perag->pagb_tree.
4. When trying to free the second extent, XFS determines that the AGFL needs
   to be populated and hence tries to allocate free blocks.
5. The only free extent whose size is >= xfs_alloc_arg->maxlen
   happens to be the first extent that was freed by the current transaction.
6. Hence xfs_alloc_ag_vextent_size() flushes the CIL in the hope of clearing
   the busy status of the extent and waits for the busy generation number to
   change.
7. However, flushing the CIL is futile since the busy extent is still in the
   current transaction's tp->t_busy list.

Here the task ends up waiting indefinitely.

This commit fixes the bug by preventing a CIL flush if all free extents are
busy and all of them are in the transaction's tp->t_busy list.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 59 +++++++++++++++++++++++++++++----------
 fs/xfs/xfs_extent_busy.c  |  6 +++-
 fs/xfs/xfs_extent_busy.h  |  2 +-
 3 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7dc50a435cf4..8e5c91bd3031 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -274,7 +274,8 @@ xfs_alloc_compute_aligned(
 	xfs_extlen_t	foundlen,	/* length in found extent */
 	xfs_agblock_t	*resbno,	/* result block number */
 	xfs_extlen_t	*reslen,	/* result length */
-	unsigned	*busy_gen)
+	unsigned	*busy_gen,
+	bool		*busy_in_trans)
 {
 	xfs_agblock_t	bno = foundbno;
 	xfs_extlen_t	len = foundlen;
@@ -282,7 +283,7 @@ xfs_alloc_compute_aligned(
 	bool		busy;
 
 	/* Trim busy sections out of found extent */
-	busy = xfs_extent_busy_trim(args, &bno, &len, busy_gen);
+	busy = xfs_extent_busy_trim(args, &bno, &len, busy_gen, busy_in_trans);
 
 	/*
 	 * If we have a largish extent that happens to start before min_agbno,
@@ -852,7 +853,7 @@ xfs_alloc_cur_check(
 	}
 
 	busy = xfs_alloc_compute_aligned(args, bno, len, &bnoa, &lena,
-					 &busy_gen);
+					 &busy_gen, NULL);
 	acur->busy |= busy;
 	if (busy)
 		acur->busy_gen = busy_gen;
@@ -1248,7 +1249,7 @@ xfs_alloc_ag_vextent_exact(
 	 */
 	tbno = fbno;
 	tlen = flen;
-	xfs_extent_busy_trim(args, &tbno, &tlen, &busy_gen);
+	xfs_extent_busy_trim(args, &tbno, &tlen, &busy_gen, NULL);
 
 	/*
 	 * Give up if the start of the extent is busy, or the freespace isn't
@@ -1669,6 +1670,9 @@ xfs_alloc_ag_vextent_size(
 	xfs_extlen_t	rlen;		/* length of returned extent */
 	bool		busy;
 	unsigned	busy_gen;
+	bool		busy_in_trans;
+	bool		all_busy_in_trans;
+	bool		alloc_small_extent;
 
 restart:
 	/*
@@ -1677,6 +1681,10 @@ xfs_alloc_ag_vextent_size(
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
 		args->agno, XFS_BTNUM_CNT);
 	bno_cur = NULL;
+	alloc_small_extent = false;
+	all_busy_in_trans = true;
+
+restart_alloc_small_extent:
 	busy = false;
 
 	/*
@@ -1687,13 +1695,14 @@ xfs_alloc_ag_vextent_size(
 		goto error0;
 
 	/*
-	 * If none then we have to settle for a smaller extent. In the case that
-	 * there are no large extents, this will return the last entry in the
-	 * tree unless the tree is empty. In the case that there are only busy
-	 * large extents, this will return the largest small extent unless there
-	 * are no smaller extents available.
+	 * We have to settle for a smaller extent if there are no maxlen +
+	 * alignment - 1 sized extents or if all larger free extents are still
+	 * in current transaction's busy list. In either case, this will return
+	 * the last entry in the tree unless the tree is empty. In the case that
+	 * there are only busy large extents, this will return the largest small
+	 * extent unless there are no smaller extents available.
 	 */
-	if (!i) {
+	if (!i || alloc_small_extent) {
 		error = xfs_alloc_ag_vextent_small(args, cnt_cur,
 						   &fbno, &flen, &i);
 		if (error)
@@ -1705,7 +1714,9 @@ xfs_alloc_ag_vextent_size(
 		}
 		ASSERT(i == 1);
 		busy = xfs_alloc_compute_aligned(args, fbno, flen, &rbno,
-				&rlen, &busy_gen);
+				&rlen, &busy_gen, &busy_in_trans);
+		if (busy && !busy_in_trans)
+			all_busy_in_trans = false;
 	} else {
 		/*
 		 * Search for a non-busy extent that is large enough.
@@ -1720,15 +1731,32 @@ xfs_alloc_ag_vextent_size(
 			}
 
 			busy = xfs_alloc_compute_aligned(args, fbno, flen,
-					&rbno, &rlen, &busy_gen);
+					&rbno, &rlen, &busy_gen,
+					&busy_in_trans);
 
 			if (rlen >= args->maxlen)
 				break;
 
+			if (busy && !busy_in_trans)
+				all_busy_in_trans = false;
+
 			error = xfs_btree_increment(cnt_cur, 0, &i);
 			if (error)
 				goto error0;
 			if (i == 0) {
+				/*
+				 * All of the large free extents are busy in the
+				 * current transaction's t->t_busy
+				 * list. Hence, flushing the CIL's busy extent list
+				 * will be futile and also leads to the current
+				 * task waiting indefinitely. Hence try to
+				 * allocate smaller extents.
+				 */
+				if (all_busy_in_trans) {
+					alloc_small_extent = true;
+					goto restart_alloc_small_extent;
+				}
+
 				/*
 				 * Our only valid extents must have been busy.
 				 * Make it unbusy by forcing the log out and
@@ -1783,7 +1811,10 @@ xfs_alloc_ag_vextent_size(
 			if (flen < bestrlen)
 				break;
 			busy = xfs_alloc_compute_aligned(args, fbno, flen,
-					&rbno, &rlen, &busy_gen);
+					&rbno, &rlen, &busy_gen,
+					&busy_in_trans);
+			if (busy && !busy_in_trans)
+				all_busy_in_trans = false;
 			rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
 			if (XFS_IS_CORRUPT(args->mp,
 					   rlen != 0 &&
@@ -1819,7 +1850,7 @@ xfs_alloc_ag_vextent_size(
 	 */
 	args->len = rlen;
 	if (rlen < args->minlen) {
-		if (busy) {
+		if (busy && !all_busy_in_trans) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 			trace_xfs_alloc_size_busy(args);
 			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index a4075685d9eb..16ba514f9e81 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -334,7 +334,8 @@ xfs_extent_busy_trim(
 	struct xfs_alloc_arg	*args,
 	xfs_agblock_t		*bno,
 	xfs_extlen_t		*len,
-	unsigned		*busy_gen)
+	unsigned		*busy_gen,
+	bool			*busy_in_trans)
 {
 	xfs_agblock_t		fbno;
 	xfs_extlen_t		flen;
@@ -362,6 +363,9 @@ xfs_extent_busy_trim(
 			continue;
 		}
 
+		if (busy_in_trans)
+			*busy_in_trans = busyp->flags & XFS_EXTENT_BUSY_IN_TRANS;
+
 		if (bbno <= fbno) {
 			/* start overlap */
 
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 929f72d1c699..dcdc70821622 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -49,7 +49,7 @@ xfs_extent_busy_reuse(struct xfs_mount *mp, xfs_agnumber_t agno,
 
 bool
 xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
-		xfs_extlen_t *len, unsigned *busy_gen);
+		xfs_extlen_t *len, unsigned *busy_gen, bool *busy_in_trans);
 
 void
 xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,
-- 
2.30.2

