Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF952C43467
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D90E2224D
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgJOHWO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:14 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35830 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729232AbgJOHWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:14 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9BCFA58C566
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaH-000hwF-8C
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:57 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaH-006qMV-0c
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 24/27] libxfs: add a buftarg cache shrinker implementation
Date:   Thu, 15 Oct 2020 18:21:52 +1100
Message-Id: <20201015072155.1631135-25-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=8-x5ei8IBC0TpnjzmaYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Add a list_lru scanner that runs from the memory pressure detection
to free an amount of the buffer cache that will keep the cache from
growing when there is memory pressure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/buftarg.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
index 6c7142d41eb1..8332bf3341b6 100644
--- a/libxfs/buftarg.c
+++ b/libxfs/buftarg.c
@@ -62,6 +62,19 @@ xfs_buftarg_setsize_early(
 	return xfs_buftarg_setsize(btp, bsize);
 }
 
+static void
+dispose_list(
+	struct list_head	*dispose)
+{
+	struct xfs_buf		*bp;
+
+	while (!list_empty(dispose)) {
+		bp = list_first_entry(dispose, struct xfs_buf, b_lru);
+		list_del_init(&bp->b_lru);
+		xfs_buf_rele(bp);
+	}
+}
+
 /*
  * Scan a chunk of the buffer cache and drop LRU reference counts. If the
  * count goes to zero, dispose of the buffer.
@@ -70,6 +83,13 @@ static void
 xfs_buftarg_shrink(
 	struct xfs_buftarg	*btc)
 {
+	struct list_lru		*lru = &btc->bt_lru;
+	struct xfs_buf		*bp;
+	int			count;
+	int			progress = 16384;
+	int			rotate = 0;
+	LIST_HEAD(dispose);
+
 	/*
 	 * Make the fact we are in memory reclaim externally visible. This
 	 * allows buffer cache allocation throttling while we are trying to
@@ -79,6 +99,37 @@ xfs_buftarg_shrink(
 
 	fprintf(stderr, "Got memory pressure event. Shrinking caches!\n");
 
+	spin_lock(&lru->l_lock);
+	count = lru->l_count / 50;	/* 2% */
+	fprintf(stderr, "cache size before %ld/%d\n", lru->l_count, count);
+	while (count-- > 0 && !list_empty(&lru->l_lru)) {
+		bp = list_first_entry(&lru->l_lru, struct xfs_buf, b_lru);
+		spin_lock(&bp->b_lock);
+		if (!atomic_add_unless(&bp->b_lru_ref, -1, 1)) {
+			atomic_set(&bp->b_lru_ref, 0);
+			bp->b_state |= XFS_BSTATE_DISPOSE;
+			list_move(&bp->b_lru, &dispose);
+			lru->l_count--;
+		} else {
+			rotate++;
+			list_move_tail(&bp->b_lru, &lru->l_lru);
+		}
+
+		spin_unlock(&bp->b_lock);
+		if (--progress == 0) {
+			fprintf(stderr, "Disposing! rotated %d, lru %ld\n", rotate, lru->l_count);
+			spin_unlock(&lru->l_lock);
+			dispose_list(&dispose);
+			spin_lock(&lru->l_lock);
+			progress = 16384;
+			rotate = 0;
+		}
+	}
+	spin_unlock(&lru->l_lock);
+
+	dispose_list(&dispose);
+	fprintf(stderr, "cache size after %ld, count remaining %d\n", lru->l_count, count);
+
 	/*
 	 * Now we've free a bunch of memory, trim the heap down to release the
 	 * freed memory back to the kernel and reduce the pressure we are
-- 
2.28.0

