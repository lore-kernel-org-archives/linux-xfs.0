Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1205C76196
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 00:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbjDDAOR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Apr 2023 20:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjDDAOI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2023 20:14:08 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E164422C
        for <linux-xfs@vger.kernel.org>; Mon,  3 Apr 2023 17:14:02 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id oa14-20020a17090b1bce00b0023d1b58d3baso9439142pjb.4
        for <linux-xfs@vger.kernel.org>; Mon, 03 Apr 2023 17:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680567242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QYyKpmgAe3S55Nk5FWRs2dH0UIocesat7xjNxdFTU4k=;
        b=W5WukSX7xVU0/vv5ALD+tup9Pddeb9Iipi9kb8kJt/jBn+TQTiZoJyEWgKO/OQ61Jh
         2tDeM9kRzvnDYGPtmMlhz5iVehjZJg/jQ63YFUQ7WbbPKq0AY2cM2cHrwogahpd+PgEG
         XwtqC+dGnvs0z0/3t8FCcMDB2O7fMVf3H3E2qFVcjwb9hPLZO3zgEa2XrTMXRi9MFCHf
         WEtCE6c9sD8f7AqxvmgV8c+yt8qmrF2I9lAqEvjVuhsI1HciUBrepOGZet31fNCDDW8P
         oX+wUwY7aO9vBuigwgimgUP/rKThFLYxYAVKIiGShyp9evKm8iqS6ChI4jTiXqDaT7MQ
         ct3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680567242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QYyKpmgAe3S55Nk5FWRs2dH0UIocesat7xjNxdFTU4k=;
        b=bZAsLQufRH0LifBSAfLl9K5IzNahLO8in8GRONcsLDrfHMqeXrlfBNnrETuMoB29x1
         8cMUfeN79qZXxd/BUSzz9tnW/fIw5daoCSShEqLr+HgjPcZujzdlq82ZAMUv1udkYfco
         GtsNWHtG/tgN+xRgR8ejBbxfIdkJCNdFlJX07n/uXdjGinPISdnKrYbFdgAdKWoHGd7n
         HWS5WC6ZOR3jbjJyhAVaVkvaPMzcdI4Jug8U2LYKnVUu68H7CNBDprM5Bmv8Hc74t6Rf
         KEJIU29mKRAvUVzYJf+WU4ptzIQ1oi0a7rCPg2Kyi/hqq2zS7KGY5OmgYP3+aSU0zM5+
         iHFA==
X-Gm-Message-State: AAQBX9eFaXI8GfqHyJh3AFVbhsiarys+oPDvhdj4OypzKzJPP5lrh3Bg
        t268+VJh6TazlGAoS0HZbP+rGM3838GhWOyG
X-Google-Smtp-Source: AKy350a8jpmup3Y0AoRXTeOyKKcgC2LVL+csu37K+C5/P3dMmovoTexr82+Hd4O52pTXV8PmQrABJAtIr5EvWJJc
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a05:6a00:2e14:b0:627:e6d5:ba2d with
 SMTP id fc20-20020a056a002e1400b00627e6d5ba2dmr223605pfb.6.1680567241767;
 Mon, 03 Apr 2023 17:14:01 -0700 (PDT)
Date:   Tue,  4 Apr 2023 00:13:53 +0000
In-Reply-To: <20230404001353.468224-1-yosryahmed@google.com>
Mime-Version: 1.0
References: <20230404001353.468224-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404001353.468224-4-yosryahmed@google.com>
Subject: [PATCH v4 3/3] mm: vmscan: ignore non-LRU-based reclaim in memcg reclaim
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We keep track of different types of reclaimed pages through
reclaim_state->reclaimed, and we add them to the reported number of
reclaimed pages. For non-memcg reclaim, this makes sense. For memcg
reclaim, we have no clue if those pages are charged to the memcg under
reclaim.

Slab pages are shared by different memcgs, so a freed slab page may have
only been partially charged to the memcg under reclaim. The same goes
for clean file pages from pruned inodes (on highmem systems) or xfs
buffer pages, there is no simple way to currently link them to the memcg
under reclaim.

Stop reporting those freed pages as reclaimed pages during memcg
reclaim. This should make the return value of writing to memory.reclaim,
and may help reduce unnecessary reclaim retries during memcg charging.
Writing to memory.reclaim on the root memcg is considered as
cgroup_reclaim(), but for this case we want to include any freed pages,
so use the global_reclaim() check instead.

Generally, this should make the return value of
try_to_free_mem_cgroup_pages() more accurate. In some limited cases (e.g.
freed a slab page that was mostly charged to the memcg under reclaim),
the return value of try_to_free_mem_cgroup_pages() can be
underestimated, but this should be fine. The freed pages will be
uncharged anyway, and we can charge the memcg the next time around as we
usually do memcg reclaim in a retry loop.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 mm/vmscan.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8f0e7c4e91ae3..049e39202e6ce 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -518,7 +518,35 @@ static void set_task_reclaim_state(struct task_struct *task,
 static void flush_reclaim_state(struct scan_control *sc,
 				struct reclaim_state *rs)
 {
-	if (rs) {
+	/*
+	 * Currently, reclaim_state->reclaimed includes three types of pages
+	 * freed outside of vmscan:
+	 * (1) Slab pages.
+	 * (2) Clean file pages from pruned inodes.
+	 * (3) XFS freed buffer pages.
+	 *
+	 * For all of these cases, we have no way of finding out whether these
+	 * pages were related to the memcg under reclaim. For example, a freed
+	 * slab page could have had only a single object charged to the memcg
+	 * under reclaim. Also, populated inodes are not on shrinker LRUs
+	 * anymore except on highmem systems.
+	 *
+	 * Instead of over-reporting the reclaimed pages in a memcg reclaim,
+	 * only count such pages in global reclaim. This prevents unnecessary
+	 * retries during memcg charging and false positive from proactive
+	 * reclaim (memory.reclaim).
+	 *
+	 * For uncommon cases were the freed pages were actually significantly
+	 * charged to the memcg under reclaim, and we end up under-reporting, it
+	 * should be fine. The freed pages will be uncharged anyway, even if
+	 * they are not reported properly, and we will be able to make forward
+	 * progress in charging (which is usually in a retry loop).
+	 *
+	 * We can go one step further, and report the uncharged objcg pages in
+	 * memcg reclaim, to make reporting more accurate and reduce
+	 * under-reporting, but it's probably not worth the complexity for now.
+	 */
+	if (rs && global_reclaim(sc)) {
 		sc->nr_reclaimed += rs->reclaimed;
 		rs->reclaimed = 0;
 	}
-- 
2.40.0.348.gf938b09366-goog

