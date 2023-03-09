Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4118AC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Mar 2023 09:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjCIJb3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Mar 2023 04:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjCIJb0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Mar 2023 04:31:26 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BE170431
        for <linux-xfs@vger.kernel.org>; Thu,  9 Mar 2023 01:31:23 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 66-20020a250245000000b00a53c1100d72so1798704ybc.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Mar 2023 01:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678354283;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XmqAffVC+m+oVrrIAcB4LBUAdhmCJbGaOFJSOfA6Apk=;
        b=TFj7MTDsZpBNZ1Pa0nPpBjAVMapPhqIjEuIqItxSZfA4ak3MR9Zb48iIb7foczQpbX
         WbksQYQHrdZrln4nHdw6+5sdurXfjnbNe/kDD/0fdzYnrK4FPkh80+fXTAFYX+K7ErEh
         1rcQSsoydEEK0CwMuckiZLK2zbAhv/zNi+QuBYMCZBwEZzkU8Itoiq8WU1TgB18gc2Bw
         EDGa5MXDFojPNO9J/WmuxVzK2IXT3yxoZSKw2S8SO1+F98jJAYgqAMtZYNYjCgHAsfK6
         fm7hVlPreLuzvKK1gsnbhaUhDW/3kun5nSsDzOEnqh2wUc39UfeqzmXDz1CyRuaUl0uD
         IRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678354283;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XmqAffVC+m+oVrrIAcB4LBUAdhmCJbGaOFJSOfA6Apk=;
        b=0+jgS5s6hgoVx+pKKuVofSV52D15fIbVlScMkvBbz9fToOeL/gAQK6PoTdEUO0UISc
         FD90yhRmM5A1PIj3wTy/D6zSIYYhIKqO7WKAQFhTv7pXOHlvOHSpHmRR3E+hgFp/o4rs
         lmJHhsSlfWduZWJa/Lc5yVMlala+uJ7cMpiqroKS1eW9E94Dvk7u647YOa/g21/L6GJu
         r36CY/OxyjTM5N3E3Xge273RQ2xtqz81v4t0BbyCFtTvvj91xSsSfqM2rbNs7/Tcg2Uz
         Vq3Zv7j95gKHcjFcs0S00wle+MnVHpZw51xHWmIH0xDt785MTwlbKO8bKyy4pIq7JKXb
         9Skw==
X-Gm-Message-State: AO0yUKV8JOH4PbQDDzhdZ0gd/huXR2+F7wvekyNqFEPkQR6ExDz6mlRf
        0/1nciBifND/dxMBtDkorSllgSH3czEGvf9C
X-Google-Smtp-Source: AK7set8lfhDA1hmab01GBmCcbW1gNF0jJVZZ3P6U2WtB9nZ0L2Sl5efbx+XPbYy5GSpQU4+BOx2RAfHOQQ1GpTqg
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a25:fe04:0:b0:b1a:64ba:9c9b with SMTP
 id k4-20020a25fe04000000b00b1a64ba9c9bmr4212060ybe.1.1678354283152; Thu, 09
 Mar 2023 01:31:23 -0800 (PST)
Date:   Thu,  9 Mar 2023 09:31:06 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230309093109.3039327-1-yosryahmed@google.com>
Subject: [PATCH v2 0/3] Ignore non-LRU-based reclaim in memcg reclaim
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
        Michal Hocko <mhocko@kernel.org>, Yu Zhao <yuzhao@google.com>
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
2.40.0.rc0.216.gc4246ad0f0-goog

