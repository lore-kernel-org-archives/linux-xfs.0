Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B5DC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbiLaDZ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbiLaDZE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:25:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6027C12A80
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:25:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC65461CC1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF44C433EF;
        Sat, 31 Dec 2022 03:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457102;
        bh=1aDgw+OdoEVEfb9KilMz+gbALKo2DQwY2tHIzjcNDJk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HYWb3kHpgi0gDXGdUq3DHuYs++JN1tKg71sNrAA8+Oig02GLpcuiPZI6YKyhqfe4d
         FCZIixz+i7NDtIAFy1BhRRwUAwNatKSHgNdNJ59dV1aZJ4gs4jd7MOsMThkAMVa4cr
         tV1l2WGaC27tv8V9FQjf8RNDeqSXaItNv2x7Zo5gVDwoSUMjJLOqxa15VmbAjYn3AA
         A8G/WUcIabyDvIUCgVEmwX+3xC3di34+775V0b3anAflAYWsZ9tyn/NlrRn9Ji1/Rp
         TDBO/dClpQqarFhjwgCULqg9GCrtZ4EVQMWNLTOlJl16ridI6gPkRo16zZuQHZN9rf
         sBcMuVL6IgaUw==
Subject: [PATCH 01/11] xfs: track deferred ops statistics
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:40 -0800
Message-ID: <167243884045.739244.9856060374468246701.stgit@magnolia>
In-Reply-To: <167243884029.739244.16777239536975047510.stgit@magnolia>
References: <167243884029.739244.16777239536975047510.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Track some basic statistics on how hard we're pushing the defer ops.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trans.h |    4 ++++
 libxfs/xfs_defer.c  |   14 ++++++++++++++
 2 files changed, 18 insertions(+)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 0ecf0a95560..9b12791ff4e 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -75,6 +75,10 @@ typedef struct xfs_trans {
 	long			t_frextents_delta;/* superblock freextents chg*/
 	struct list_head	t_items;	/* log item descriptors */
 	struct list_head	t_dfops;	/* deferred operations */
+
+	unsigned int	t_dfops_nr;
+	unsigned int	t_dfops_nr_max;
+	unsigned int	t_dfops_finished;
 } xfs_trans_t;
 
 void	xfs_trans_init(struct xfs_mount *);
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 1d8bf2f6f65..2ca03674e2d 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -504,6 +504,8 @@ xfs_defer_finish_one(
 	/* Done with the dfp, free it. */
 	list_del(&dfp->dfp_list);
 	kmem_cache_free(xfs_defer_pending_cache, dfp);
+	tp->t_dfops_nr--;
+	tp->t_dfops_finished++;
 out:
 	if (ops->finish_cleanup)
 		ops->finish_cleanup(tp, state, error);
@@ -545,6 +547,9 @@ xfs_defer_finish_noroll(
 
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
+		(*tp)->t_dfops_nr_max = max((*tp)->t_dfops_nr,
+					    (*tp)->t_dfops_nr_max);
+
 		if (has_intents < 0) {
 			error = has_intents;
 			goto out_shutdown;
@@ -575,6 +580,7 @@ xfs_defer_finish_noroll(
 	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	trace_xfs_defer_finish_error(*tp, error);
 	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
+	(*tp)->t_dfops_nr = 0;
 	xfs_defer_cancel(*tp);
 	return error;
 }
@@ -615,6 +621,7 @@ xfs_defer_cancel(
 
 	trace_xfs_defer_cancel(tp, _RET_IP_);
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
+	tp->t_dfops_nr = 0;
 }
 
 /* Add an item for later deferred processing. */
@@ -651,6 +658,7 @@ xfs_defer_add(
 		dfp->dfp_count = 0;
 		INIT_LIST_HEAD(&dfp->dfp_work);
 		list_add_tail(&dfp->dfp_list, &tp->t_dfops);
+		tp->t_dfops_nr++;
 	}
 
 	list_add_tail(li, &dfp->dfp_work);
@@ -669,6 +677,12 @@ xfs_defer_move(
 	struct xfs_trans	*stp)
 {
 	list_splice_init(&stp->t_dfops, &dtp->t_dfops);
+	dtp->t_dfops_nr += stp->t_dfops_nr;
+	dtp->t_dfops_nr_max = stp->t_dfops_nr_max;
+	dtp->t_dfops_finished = stp->t_dfops_finished;
+	stp->t_dfops_nr = 0;
+	stp->t_dfops_nr_max = 0;
+	stp->t_dfops_finished = 0;
 
 	/*
 	 * Low free space mode was historically controlled by a dfops field.

