Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE6DC76188
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 21:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbjDDVuu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 17:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbjDDVtw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 17:49:52 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9154C13
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 14:49:51 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-501df529967so15233a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 14:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680644989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ORsASzljGfHUFCd3ogFEbqGPps8yt7IIOZl7g4K30Rg=;
        b=s/SiwwnmdwkgdeRuDjJ02rK7CCuhb2Ml/Z5hn/DcsfFr7GYNLhNgYBAFxySLJMz8VX
         gAxjiPpDI6f2ofADSz5Ov1GlKr6Yprh6lp9toubNZO2v6c6IJH7NRAAuuOxuqORiF8zn
         M06YpyIt1QcvlVGPTEQI02wW0h7CBY1ct9cck7SY3hcF83eo9iqyp8jtKFLSEacgcuQl
         lb1owLlctoBpODjGqx/Qj12WkH8TAsyk3xOg/vFwI31/uSeyU7R8/DJE3y2fQs2GiW+o
         g6inQGM0BafkZ4JfB96QwvQyHCb73fuQzDkcYdC5bULTLsWwkmxE/WF6so5OzqVWh0KK
         strA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680644989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ORsASzljGfHUFCd3ogFEbqGPps8yt7IIOZl7g4K30Rg=;
        b=DQUfKa7RH4OARH7MsX4xyo3P6G+TYODhSL1OQ3+ayPQQwTTApNTRjA7yFJEfnzSyaB
         j0C0h8DsGuw3uEZvt+6DERYA3GythBWyKAhtn+QQh7vPImrT9riNZC1lC4o8SFuqownZ
         aq+0PD3ZZxXu4AXp/iLIRSq/cCfH/5TXGAufTja0n88eQy7PVJ0okKR5+XsqskNxLgu4
         irJNtx9W52qrgJuEulk/TOQOZPH5uwMMjBKNhselmqs7zhlANgRJK34C3Fjm5GlIkFPs
         u2snucxFRtw1nOYESEK0/70Ysb+uc98ksYyjEAlEFqvnerYjSBywKHKXo4UJBdDKzzAW
         DcVg==
X-Gm-Message-State: AAQBX9c2ze6fE+ra9sBYcKB649FOn/J8HF1VKHWTvi1DxWXdmrlF7XbF
        6xL/8ZSpkdj12s1Oq83nBdLDtPrcW5fBcrQQfLyhOg==
X-Google-Smtp-Source: AKy350YUhgfNlQB9BgliJhDTPoAtydq+pRpI5OPND73VJuSHENJ8A+1/PZy54LksxQ0Iys/ncdz8czKD7eRq8UO4ZrA=
X-Received: by 2002:a50:aac1:0:b0:502:1d1c:7d37 with SMTP id
 r1-20020a50aac1000000b005021d1c7d37mr20498edc.8.1680644989345; Tue, 04 Apr
 2023 14:49:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230404001353.468224-1-yosryahmed@google.com> <20230404143824.a8c57452f04929da225a17d0@linux-foundation.org>
In-Reply-To: <20230404143824.a8c57452f04929da225a17d0@linux-foundation.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 4 Apr 2023 14:49:13 -0700
Message-ID: <CAJD7tkbZgA7QhkuxEbp=Sam6NCA0i3cZJYF4Z1nrLK1=Rem+Gg@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] Ignore non-LRU-based reclaim in memcg reclaim
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
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
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 4, 2023 at 2:38=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Tue,  4 Apr 2023 00:13:50 +0000 Yosry Ahmed <yosryahmed@google.com> wr=
ote:
>
> > Upon running some proactive reclaim tests using memory.reclaim, we
> > noticed some tests flaking where writing to memory.reclaim would be
> > successful even though we did not reclaim the requested amount fully.
> > Looking further into it, I discovered that *sometimes* we over-report
> > the number of reclaimed pages in memcg reclaim.
> >
> > Reclaimed pages through other means than LRU-based reclaim are tracked
> > through reclaim_state in struct scan_control, which is stashed in
> > current task_struct. These pages are added to the number of reclaimed
> > pages through LRUs. For memcg reclaim, these pages generally cannot be
> > linked to the memcg under reclaim and can cause an overestimated count
> > of reclaimed pages. This short series tries to address that.
> >
> > Patches 1-2 are just refactoring, they add helpers that wrap some
> > operations on current->reclaim_state, and rename
> > reclaim_state->reclaimed_slab to reclaim_state->reclaimed.
> >
> > Patch 3 ignores pages reclaimed outside of LRU reclaim in memcg reclaim=
.
> > The pages are uncharged anyway, so even if we end up under-reporting
> > reclaimed pages we will still succeed in making progress during
> > charging.
> >
> > Do not let the diff stat deceive you, the core of this series is patch =
3,
> > which has one line of code change. All the rest is refactoring and one
> > huge comment.
> >
>
> Wouldn't it be better to do this as a single one-line patch for
> backportability?  Then all the refactoring etcetera can be added on
> later.

Without refactoring the code that adds reclaim_state->reclaimed to
scan_control->nr_reclaimed into a helper (flush_reclaim_state()), the
change would need to be done in two places instead of one, and I
wouldn't know where to put the huge comment.

One thing that I can do is break down patch 2 into two patches, one
that adds the flush_reclaim_state() helper, and one that adds the
mm_account_reclaimed_pages() helper.

The series would be:
Patch 1: move set_task_reclaim_state() near other helpers
Patch 2: introduce mm_account_reclaimed_pages()
Patch 3: introduce flush_reclaim_state()
Patch 4: add the one-line change (and the huge comment) to flush_reclaim_st=
ate()

Backports need only to take patches 3 & 4 (which would be localized to
mm/vmscan.c), as patches 1 & 2 would be purely cosmetic with no
dependency from patches 3 & 4. For the current series, patch 1 is not
needed anyway. So this change would basically save backporters the
part of patch 2 that is outside of mm/vmscan.c.

If you think this would be useful I can send a v5 with patch 2 broken
down into two patches.
