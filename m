Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C07C76196
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 00:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbjDDAOC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Apr 2023 20:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbjDDAN7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2023 20:13:59 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C371729
        for <linux-xfs@vger.kernel.org>; Mon,  3 Apr 2023 17:13:58 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id s4-20020a170902ea0400b001a1f4137086so18370756plg.14
        for <linux-xfs@vger.kernel.org>; Mon, 03 Apr 2023 17:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680567238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/hxuqZFO5U+CmKAu0Izd1qiRBhW4afUnD0WyfUo4Gcw=;
        b=ERBMFlpwQ+/e/a/Z3AL8E+p3U9MNbkZrsz1HL/MZqvfsps00VtVZYbkySPDVq2/6aR
         LHVdBQe3ElTtHckYtN+0h+FDNuiI47HZzvKorWDJwFV06A2ZOZ9rTLgMNb03YVp2wZvD
         PgyPdh7s9QF5a+LrPpjkbUaqX5VHdnehZzbSO8EQsnkGFGX9ApbhWI2WH3GTZIdOCnMl
         aWLwqKHsahq90y7bzc7mLyA1MCyJjLXiPgYUQBEdJC8xf/8EamW1fLH2Ww2pGZUCTg1p
         jUEPpHXUbx3wFMtNPW+KmYfxXVLvMYfkOtlZrUyDZokuwj17Ht/6/tV/rlF0tPwOfpWA
         Gsag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680567238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/hxuqZFO5U+CmKAu0Izd1qiRBhW4afUnD0WyfUo4Gcw=;
        b=zsuXfNYvccG/MCffg9E/AWZK5lFzigdX1jJ9UwdcvCk2Vh7JpGihPWG6ZlBRQ4I/ne
         PAlKI9VGyCYta2ybu49bVKqtTwAzS3rz23Y7rbWXGQ/gC3FywBzSWV9PKv5ThrSZT2Ql
         meDf78TpvceDDErcQm3AEg2B5JjgmUY/7U7wSdtlA+tSSK0iMozkoBxFnYTyPSB0m/oW
         ljEDuyU99ZGr513tGXjB82+Z1xbzqoyG41blpQC8e/HvYgc8TitcMdxxC1T63JxkDIEa
         nLO12avQXtBCYj1+m6JtrczgjyJnVXbrENbzhsn/+bKUK1BXRa3AD3VCyFummVxy4wTU
         9rIw==
X-Gm-Message-State: AAQBX9f1nCOfn+gI/vOOgBA1LtKadPGCt3EWJlFNuS4NPdDObql3YSa2
        cEqF5HItkapd2W+zSOAGgvf/bTqe9NuRb4Wn
X-Google-Smtp-Source: AKy350Z+Sm8hAQJcQhRAP+xzVs9NeoT30dH7npmf11D1Z/F0xl2wPw5f56Q84WDvH4pUeUa2sdKUL4OGwZiD1m0K
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a05:6a00:23cd:b0:625:5949:6dc0 with
 SMTP id g13-20020a056a0023cd00b0062559496dc0mr232232pfc.4.1680567238017; Mon,
 03 Apr 2023 17:13:58 -0700 (PDT)
Date:   Tue,  4 Apr 2023 00:13:51 +0000
In-Reply-To: <20230404001353.468224-1-yosryahmed@google.com>
Mime-Version: 1.0
References: <20230404001353.468224-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404001353.468224-2-yosryahmed@google.com>
Subject: [PATCH v4 1/3] mm: vmscan: move set_task_reclaim_state() after global_reclaim()
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

set_task_reclaim_state() is currently defined in mm/vmscan.c above
an #ifdef CONFIG_MEMCG block where global_reclaim() is defined. We are
about to add some more helpers that operate on reclaim_state, and will
need to use global_reclaim(). Move set_task_reclaim_state() after
the #ifdef CONFIG_MEMCG block containing the definition of
global_reclaim() to keep helpers operating on reclaim_state together.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 mm/vmscan.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9c1c5e8b24b8f..fef7d1c0f82b2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -188,18 +188,6 @@ struct scan_control {
  */
 int vm_swappiness = 60;
 
-static void set_task_reclaim_state(struct task_struct *task,
-				   struct reclaim_state *rs)
-{
-	/* Check for an overwrite */
-	WARN_ON_ONCE(rs && task->reclaim_state);
-
-	/* Check for the nulling of an already-nulled member */
-	WARN_ON_ONCE(!rs && !task->reclaim_state);
-
-	task->reclaim_state = rs;
-}
-
 LIST_HEAD(shrinker_list);
 DECLARE_RWSEM(shrinker_rwsem);
 
@@ -511,6 +499,18 @@ static bool writeback_throttling_sane(struct scan_control *sc)
 }
 #endif
 
+static void set_task_reclaim_state(struct task_struct *task,
+				   struct reclaim_state *rs)
+{
+	/* Check for an overwrite */
+	WARN_ON_ONCE(rs && task->reclaim_state);
+
+	/* Check for the nulling of an already-nulled member */
+	WARN_ON_ONCE(!rs && !task->reclaim_state);
+
+	task->reclaim_state = rs;
+}
+
 static long xchg_nr_deferred(struct shrinker *shrinker,
 			     struct shrink_control *sc)
 {
-- 
2.40.0.348.gf938b09366-goog

