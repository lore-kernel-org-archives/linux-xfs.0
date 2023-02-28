Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5380FC7EE30
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Feb 2023 08:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbjB1IuR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Feb 2023 03:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjB1IuO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 03:50:14 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C2F8696
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 00:50:06 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id bw25-20020a056a00409900b005a9d0e66a7aso4776039pfb.5
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 00:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677574206;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xdSAVrwCtkhEWC8GgYYqKMfIX8yBwrpfZDbmqtRyDyA=;
        b=SOVV++5ZdqitZ36JKIv2fFMUIZWr2mRvM+1SYrMDqxcU64YKMcyXiXS7/JBzrMzVGR
         a6lwTwArMZ5cvyX8urVSHUrUuVQOSfF42XGvNomA8Tvnp0LV06/wsJWl0LMz4W76Db5h
         y3jUa5jifEAMLoWLF0Zr9sO3rNX27weBBlTgPK6tlMagy9lhu6URapPi6JL/AiWDq+/O
         xpiOl8e/9NHV1lIOw2MgMwgF5M6/In9pOSbo61IAhJJdv/IGVjLeA7M8iH+2ekiFYHMp
         H9Jqpmo7RoeMES/COvqdvDIkncurMcMLwWiPU0V57IM51nNJ+lMIpEBY3rU7HFrTSgtB
         lU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677574206;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xdSAVrwCtkhEWC8GgYYqKMfIX8yBwrpfZDbmqtRyDyA=;
        b=Pd02+CvpwTDcklR1nXTqDEd7ERTDnl34cTv5vmowLaSKzZ7HqHnXWHuf9RMlH7brH3
         eLVoTTsThIRQd0wHFe29ZwSGmwykpiQ2LxyH9+GD2I8PHC6oirwNZljPENqnz8I04Bl3
         dUpMSym26+vkVVsrxtLvA+HMasb19P2agGkOgPGHLidpfogFWYTphAKXQLhot7UwiJ2A
         K4FeXGVYJ0Wgq/5+BZwwYN5AUPqVihs8ESqEiY4qeAbvNirv+V1vgJdi2kD+Cxs+BNVs
         jIf6LLwjfgbgbi1qGYjRA2cSID8rhbz6M7nmORj1eDATx0TIhoQFvITjLc5FfpcbCsOs
         O2yA==
X-Gm-Message-State: AO0yUKXLXJcQxCgn/W8o39LaxLrggedBuEVvB8vkr1fhN+r20EATd25X
        EF5xyCFWOwzZWwcsL0m/Za6IUkWrNO62b/Uv
X-Google-Smtp-Source: AK7set9xyaSEGINDP0JdrxfWpmvgvG2OFkld3cb1qL57vscSNy7S0nejYo/cjvFVY+VnsY2ooCNyScP6qk2951NZ
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:902:6bc5:b0:19c:fc1b:e600 with SMTP
 id m5-20020a1709026bc500b0019cfc1be600mr684030plt.5.1677574206196; Tue, 28
 Feb 2023 00:50:06 -0800 (PST)
Date:   Tue, 28 Feb 2023 08:50:00 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228085002.2592473-1-yosryahmed@google.com>
Subject: [PATCH v1 0/2] Ignore non-LRU-based reclaim in memcg reclaim
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
The pages are uncharged anyway, so even if we end up under-reporting
reclaimed pages we will still succeed in making progress during
charging.

Do not let the diff stat trick you, patch 2 is a one-line change. All
the rest is moving a couple of functions around and a huge comment :)

RFC -> v1:
- Exported report_freed_pages in case XFS is built as a module (Matthew
  Wilcox).
- Renamed reclaimed_slab to reclaim in previously missed MGLRU code.
- Refactored using reclaim_state to update sc->nr_reclaimed into a
  helper and added an XL comment explaining why we ignore
  reclaim_state->reclaimed in memcg reclaim (Johannes Weiner).

Yosry Ahmed (2):
  mm: vmscan: refactor updating reclaimed pages in reclaim_state
  mm: vmscan: ignore non-LRU-based reclaim in memcg reclaim

 fs/inode.c           |  3 +-
 fs/xfs/xfs_buf.c     |  3 +-
 include/linux/swap.h |  5 ++-
 mm/slab.c            |  3 +-
 mm/slob.c            |  6 ++--
 mm/slub.c            |  5 ++-
 mm/vmscan.c          | 79 +++++++++++++++++++++++++++++++++++---------
 7 files changed, 74 insertions(+), 30 deletions(-)

-- 
2.39.2.722.g9855ee24e9-goog

