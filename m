Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18DFC76196
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Mar 2023 07:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjCaHIX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Mar 2023 03:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjCaHIW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2023 03:08:22 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059CDCA1E
        for <linux-xfs@vger.kernel.org>; Fri, 31 Mar 2023 00:08:22 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id e8-20020a17090a118800b0023d35ae431eso6825420pja.8
        for <linux-xfs@vger.kernel.org>; Fri, 31 Mar 2023 00:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680246501;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AxV13ttd0okhRK37057Bft4LTQPnmiMqtPZxYuE9zT4=;
        b=YADI96jVgiYPZRSA/peAggJ1UQ51//UvA/NHqCLbFRbrvy6NrfGn7y68B7SqPbKkWr
         0St+ZzCJthd+R7lYoheP1BORTpoCjw4zPzaECkLQxVQTHrMI8B9cjt7DcBGKSw82qoV7
         govybumASYXhf60cCUp/IaMa0u8IjM5BtYMB7XLWRbZTN2AHMrwl7r6Pl36MpeIoLENE
         DQR8j5Vv14GXCDRTUsQx4sKmHq9BSMZeAYA1VDEA82FeD7/GDaQmT73P882/ebuiiwwv
         zKf3lK298QFggp7XoIt7VpvXlIweYbvefoc6upchYkznH6ammqvuCWagsQRerA20UDUV
         19pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680246501;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AxV13ttd0okhRK37057Bft4LTQPnmiMqtPZxYuE9zT4=;
        b=TVLnjdMusSg1LYpY7Kcw3+GnpNjcIefGqLLf9R/RPe679us8xLfGg658HSm1/vuR7w
         FsngU5lbfxW3R/24mtsGMogjWGXhMxcsPh2prkNGSu8cF+bypeVYzDJFRMs/0z3wugSs
         Fhe7Y0oJq3XXPVS0yxvhjqwxK03abScoepGQ8xqwBtjFmW8FoYu1TG56nFw4hWodqifj
         OwNLoFnZC6FIAdViKRoYaPKaS95gDrEpAV0QxdFHquSAASBfLAxXg6p738fmvdPgqqdS
         Qpete7cM6wXxalUjwSuq9z27enCFXJndeQnMFoje0r9991+tLN3WYcH2acJBvZQbeBgj
         HlHw==
X-Gm-Message-State: AAQBX9cauk0STt00hP+ParMqV6VeWues0pyfGMq2oClXLirFbW9UUqSy
        LHGf7BHWCPOQR9B0id/3UnJifbmsNqd6u1dy
X-Google-Smtp-Source: AKy350b0knEaTNZ6EqlFZpPPUswwWCJeCMzE7r5/axoeUeK3BbwwP1Kc/GQBYQhutWHarYFOq+PIColFf89yH3jn
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90a:68cb:b0:23f:d120:4413 with SMTP
 id q11-20020a17090a68cb00b0023fd1204413mr7943430pjj.1.1680246501490; Fri, 31
 Mar 2023 00:08:21 -0700 (PDT)
Date:   Fri, 31 Mar 2023 07:08:15 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230331070818.2792558-1-yosryahmed@google.com>
Subject: [PATCH v3 0/3] Ignore non-LRU-based reclaim in memcg reclaim
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

Upon running some proactive reclaim tests using memory.reclaim, we
noticed some tests flaking where writing to memory.reclaim would be
successful even though we did not reclaim the requested amount fully.
Looking further into it, I discovered that *sometimes* we over-report
the number of reclaimed pages in memcg reclaim.

Reclaimed pages through other means than LRU-based reclaim are tracked
through reclaim_state in struct scan_control, which is stashed in
current task_struct. These pages are added to the number of reclaimed
pages through LRUs. For memcg reclaim, these pages generally cannot be
linked to the memcg under reclaim and can cause an overestimated count
of reclaimed pages. This short series tries to address that.

Patches 1-2 are just refactoring, they add helpers that wrap some
operations on current->reclaim_state, and rename
reclaim_state->reclaimed_slab to reclaim_state->reclaimed.

Patch 3 ignores pages reclaimed outside of LRU reclaim in memcg reclaim.
The pages are uncharged anyway, so even if we end up under-reporting
reclaimed pages we will still succeed in making progress during
charging.

Do not let the diff stat deceive you, the core of this series is patch 3,
which has one line of code change. All the rest is refactoring and one
huge comment.

v2 -> v3:
- Fixed a compilation problem in patch 2 reported by the bot.
- Rebased on top of v6.3-rc2.

v1 -> v2:
- Renamed report_freed_pages() to mm_account_reclaimed_pages(), as
  suggested by Dave Chinner. There were discussions about leaving
  updating current->reclaim_state open-coded as it's not worth hiding
  the current dereferencing to remove one line, but I'd rather have the
  logic contained with mm/vmscan.c so that the next person that changes
  this logic doesn't have to change 7 different files.
- Renamed add_non_vmscan_reclaimed() to flush_reclaim_state() (Johannes
  Weiner).
- Added more context about how this problem was found in the cover
  letter (Johannes Weiner).
- Added a patch to move set_task_reclaim_state() below the definition of
  cgroup_reclaim(), and added additional helpers in the same position.
  This way all the helpers for reclaim_state live together, and there is
  no need to declare cgroup_reclaim() early or move its definition
  around to call it from flush_reclaim_state(). This should also fix the
  build error reported by the bot in !CONFIG_MEMCG.

RFC -> v1:
- Exported report_freed_pages() in case XFS is built as a module (Matthew
  Wilcox).
- Renamed reclaimed_slab to reclaim in previously missed MGLRU code.
- Refactored using reclaim_state to update sc->nr_reclaimed into a
  helper and added an XL comment explaining why we ignore
  reclaim_state->reclaimed in memcg reclaim (Johannes Weiner).

Yosry Ahmed (3):
  mm: vmscan: move set_task_reclaim_state() after cgroup_reclaim()
  mm: vmscan: refactor updating reclaimed pages in reclaim_state
  mm: vmscan: ignore non-LRU-based reclaim in memcg reclaim

 fs/inode.c           |  3 +-
 fs/xfs/xfs_buf.c     |  3 +-
 include/linux/swap.h |  5 ++-
 mm/slab.c            |  3 +-
 mm/slob.c            |  6 +--
 mm/slub.c            |  5 +--
 mm/vmscan.c          | 88 +++++++++++++++++++++++++++++++++++---------
 7 files changed, 81 insertions(+), 32 deletions(-)

-- 
2.40.0.348.gf938b09366-goog

