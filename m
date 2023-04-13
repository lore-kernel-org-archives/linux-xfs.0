Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9795BC77B6E
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 11:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjDMLaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 07:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjDMLaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 07:30:22 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1212F975A
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 04:30:21 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id sg7so47970508ejc.9
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 04:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681385419; x=1683977419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r9VZRy+ALIrbnuoSe0PNBBfvqUV9FWtMpLqMl4pVQlE=;
        b=FawizVY7HhksSlM/EXpzcpXldi+yCz4HZxgMXFrA0D7TY4SooKByYRyl/PrpnGtURT
         U6ZKsSzk7dtuHBeRnU6ubUixkbtyvQKJMGIGlbSWvMmR+qYeXlDB7bsjXKsp0vUodqxS
         m++tC1HwAEMoJw2Z8Byx/zXZc0awaueEJ+rjFerBgu6BSFlkLZ5kDARUp5jMzmZuP+2R
         YavPMLdiDbZj4QeI9567bpyOc7Su1ZUmVqDBnoD3ih8M3yTN3z81SNKoOCn9/EFVOzkE
         xLRdq6Jac5+YtYp0Wtfjk1nyUNJJIKHH7MXAgKQriYtIcNy2davJ3g7H0KNWCGx5h1ZK
         SLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681385419; x=1683977419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r9VZRy+ALIrbnuoSe0PNBBfvqUV9FWtMpLqMl4pVQlE=;
        b=HVvnUtgT36NJ4QceyqiqmQSYCGKfgUmRpMjtymgh1H0SsBO9NYq48FP40ua0NcYQQA
         9+SW+az1BcN+a7Dn0goYg773aMxgdiFlwaB0Ynts+pRv1WNXloB/46RE74YvY3BBGFPJ
         YsnxoBRh9y10fFz4NVZVSPoPKdgRvNAzABrMwxp6rvMODTc0Lt6/qhDN8MUgZ8EpSBHX
         YaO+GSYOr+X9ok1DE/Fv07ifArteUk3NjA8QGRg6tW5TTwwoHVrPZK59GXz5LXu7FVkl
         yZw3FhBk1IOnDmJ9Cf/rcHRfKMf3ET/r0qvNTAY+lcRA4irZukcLk6b/19RvIPkSUj4O
         ANkg==
X-Gm-Message-State: AAQBX9dRYdEhT15f96dRpKVNm9Qh6plPwEby1hsXUKdCcccYwlaL/dUu
        PIekFqjYbx1tbIymR4vl/IgokIVBcpApFDBEqEnC5Q==
X-Google-Smtp-Source: AKy350YGfS9e19HP05Oiznjy9Mfa8a36DWz+4bhJqVxRh8Sp9QjK9ffjx1ux2/OVFijfQ9Nymg9OabFJJrpzaJeAblM=
X-Received: by 2002:a17:906:f753:b0:933:1967:a984 with SMTP id
 jp19-20020a170906f75300b009331967a984mr1014820ejb.15.1681385419329; Thu, 13
 Apr 2023 04:30:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230413104034.1086717-1-yosryahmed@google.com>
 <20230413104034.1086717-4-yosryahmed@google.com> <b7fe839d-d914-80f7-6b96-f5f3a9d0c9b0@redhat.com>
In-Reply-To: <b7fe839d-d914-80f7-6b96-f5f3a9d0c9b0@redhat.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Thu, 13 Apr 2023 04:29:43 -0700
Message-ID: <CAJD7tkae0uDuRG77nQEtzkV1abGstjF-1jfsCguR3jLNW=Cg5w@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] mm: vmscan: refactor updating current->reclaim_state
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Dave Chinner <david@fromorbit.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2023 at 4:21=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 13.04.23 12:40, Yosry Ahmed wrote:
> > During reclaim, we keep track of pages reclaimed from other means than
> > LRU-based reclaim through scan_control->reclaim_state->reclaimed_slab,
> > which we stash a pointer to in current task_struct.
> >
> > However, we keep track of more than just reclaimed slab pages through
> > this. We also use it for clean file pages dropped through pruned inodes=
,
> > and xfs buffer pages freed. Rename reclaimed_slab to reclaimed, and add
>
> Would "reclaimed_non_lru" be more expressive? Then,
>
> mm_account_reclaimed_pages() -> mm_account_non_lru_reclaimed_pages()
>
>
> Apart from that LGTM.

Thanks!

I suck at naming things. If you think "reclaimed_non_lru" is better,
then we can do that. FWIW mm_account_reclaimed_pages() was taken from
a suggestion from Dave Chinner. My initial version had a terrible
name: report_freed_pages(), so I am happy with whatever you see fit.

Should I re-spin for this or can we change it in place?

>
> --
> Thanks,
>
> David / dhildenb
>
