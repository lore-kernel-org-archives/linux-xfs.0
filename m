Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20DD3C636D7
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Feb 2023 23:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbjBBXch (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Feb 2023 18:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjBBXcg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2023 18:32:36 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBFF4ED9
        for <linux-xfs@vger.kernel.org>; Thu,  2 Feb 2023 15:32:34 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id z9-20020a25ba49000000b007d4416e3667so3219600ybj.23
        for <linux-xfs@vger.kernel.org>; Thu, 02 Feb 2023 15:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wvPcslomLoHkLO8Yc6SUQeV30+piSf1wG3UvD93eRjk=;
        b=q5PqSQK+++lHtbhZUFBCU+x4zpvrGh4pIKNqDt3jPaMwOvRLITz/8gh2vIwvbOGDXn
         FHL9NUVDmtVGdSCj3mFBi6xfSbyUqEIbfHvKMj5uruVu3bVrC4szl3SkUVxsmgJJdA73
         f0c3SqPtAbMisWYNFJZMbClTUB/2DVlUqbm73mTLpJAOTzCvliRc8Ua1t33hUrwY3x00
         s0Bvg1ekxl+6tcU7L35HzxkbHl9Lbf25lU7EViogFcVu6T3rEY/kyMhRQM2LWbU1A9Kn
         elaobooFLoeTUYtg7Z9LZd33Y+HOrY2Gl7eapgrfYntF6Elpt+jMwqYKaK3W3qIDHp5q
         /cHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wvPcslomLoHkLO8Yc6SUQeV30+piSf1wG3UvD93eRjk=;
        b=yF8zRYvRjrVKfpaiwiTrd4dNFrrH1d3sHFu5iSyeOEl+QxxIwm6RqLTFH1yN+w6bDE
         eU1wu3s6cxPKyvZ41g1DKpHJFvEAL3iN/YfYYuAdgfaqE2/E2jYgrp8Zme9f1YC5i/QR
         roLmrA9mRbH83kbFSbl7I5bdD5kyYePw6TlrDCGiFEAHSCpRMrNTfKE28CovgmB2qC0i
         yqGSJqVhofRSFFVxYVR+kuCFEr8BQZWuy2oRvaa7kSze3NJuNZXpAHeNeVh4aNkALhx6
         UfAaTC/IQOQVLCJyamxzlktyg96wQVUHHBPxkhWCGjuwJCq6fkbMP9VdfoSgi3lPsZOv
         fXTA==
X-Gm-Message-State: AO0yUKUD4lykih/VAbRJYZ6iHV56GU5W6jB549hqACT8UPaX1qhXPL6u
        lCDpOW5Ixl2nzBZNhV4Nkc7qFzeVl7j9qgKH
X-Google-Smtp-Source: AK7set9kUtHsaRY6uXu6dJRkVwBjqCpF4UUcFJZVMG6LU7esmRkQZlJLDYJYrU6vi4GT4w30ZHbokAZ4HSwiHzRk
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a25:9e90:0:b0:866:b2a0:6e9d with SMTP
 id p16-20020a259e90000000b00866b2a06e9dmr104800ybq.203.1675380753703; Thu, 02
 Feb 2023 15:32:33 -0800 (PST)
Date:   Thu,  2 Feb 2023 23:32:27 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202233229.3895713-1-yosryahmed@google.com>
Subject: [RFC PATCH v1 0/2] Ignore non-LRU-based reclaim in memcg reclaim
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
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
        Michal Hocko <mhocko@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reclaimed pages through other means than LRU-based reclaim are tracked
through reclaim_state in struct scan_control, which is stashed in
current task_struct. These pages are added to the number of reclaimed
pages through LRUs. For memcg reclaim, these pages generally cannot be
linked to the memcg under reclaim and can cause an overestimated count
of reclaimed pages. This short series tries to address that.

Patch 1 is just refactoring updating reclaim_state into a helper
function, and renames reclaimed_slab to just reclaimed, with a comment
describing its true purpose.

Patch 2 ignores pages reclaimed outside of LRU reclaim in memcg reclaim.

The original draft was a little bit different. It also kept track of
uncharged objcg pages, and reported them only in memcg reclaim and only
if the uncharged memcg is in the subtree of the memcg under reclaim.
This was an attempt to make reporting of memcg reclaim even more
accurate, but was dropped due to questionable complexity vs benefit
tradeoff. It can be revived if there is interest.

Yosry Ahmed (2):
  mm: vmscan: refactor updating reclaimed pages in reclaim_state
  mm: vmscan: ignore non-LRU-based reclaim in memcg reclaim

 fs/inode.c           |  3 +--
 fs/xfs/xfs_buf.c     |  3 +--
 include/linux/swap.h |  5 ++++-
 mm/slab.c            |  3 +--
 mm/slob.c            |  6 ++----
 mm/slub.c            |  5 ++---
 mm/vmscan.c          | 19 ++++++++++++++++---
 7 files changed, 27 insertions(+), 17 deletions(-)

-- 
2.39.1.519.gcb327c4b5f-goog

