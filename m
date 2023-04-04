Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24D5C76188
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 23:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbjDDXrK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 19:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbjDDXrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 19:47:09 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9396240C8
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 16:47:08 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-92fcb45a2cdso6367366b.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 16:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680652027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vi8MTES466++qI3K8H2RA5xq0z5Rl84WyOaFw5DuASg=;
        b=If2bQ4PP42IMPaWPi/mxpS5uD6z8AbVQFXkkogns9TNyuIiTffcA5kdXIUSlty2ruA
         rgjxNGKOv1BufEIWhTD9lu0c4K7mbT4yKTlNFkff+F42czJEauhWZY6XNFIGiNjhQGGi
         wyphX7FpCilXQmTlQXOrHfAEZBurxOp8njL4j8MlQWFZfGqvlUkg+F1zYaJOC/+nb5Pm
         dq1esF1Dqz+Fpvnkx4FwAirFKJoN4xNv4NwZ+1tfRJWFBd8Or9qU3CKgrDUU0sPaDtY6
         0t1e9LwZ0ZXNWN9lWxopo8+RD7NR4rw/k5+aglNEJvKLnm4KjJ8YtgtcKQaKPOHxNSaU
         At6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680652027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vi8MTES466++qI3K8H2RA5xq0z5Rl84WyOaFw5DuASg=;
        b=0MXJCJTV7WgFEoFV4qA8fM7Qhe3nYqes2nnin7QK2h8hqrabU2Sn46VG8JvdMHxIZj
         7HkdLh3k8vHDtEBtWJsoNPkhcGtMcoy11KYOrgBw4qQjBHXRgI9leBsBh1WW4cT+vZqV
         EyfL9VEP3yEb3mspAifwY0kzKN0HHhDyaxK/PsTEGDgMlf5qWKdbfjMeY0K1DIwKUqJq
         1pUpxqL5EBdaNu5Po9698AeTmb0X4nQR+1uofqJIuwBLkTK0Ij56yqxiFV6BNNLTPxjj
         8Dnk1kJ32WCfCK6yP0unrQKogXp3u3sZxrFA3yLhZ34uzFy0dhwtWRii/QbgMWwzfTyi
         bLvQ==
X-Gm-Message-State: AAQBX9fR2e8V0fjT093erJQU7ywDfA6rXcQiA8LbY3ZepIHdU8fLOgIL
        nrf0XSvxxUk4CUquPrwuHzmMQ7IDTTHCPegml9zrkg==
X-Google-Smtp-Source: AKy350amp5Q0CsMRA0vsSv+2EQyk24jR2b8+hCJYdKxg84vsQgd8qYOXeaFgiz9iTyZrvy0BpEcL+UO1UUrppWOUht0=
X-Received: by 2002:a50:aac1:0:b0:502:1d1c:7d37 with SMTP id
 r1-20020a50aac1000000b005021d1c7d37mr140133edc.8.1680652026905; Tue, 04 Apr
 2023 16:47:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230404001353.468224-1-yosryahmed@google.com>
 <20230404143824.a8c57452f04929da225a17d0@linux-foundation.org>
 <CAJD7tkbZgA7QhkuxEbp=Sam6NCA0i3cZJYF4Z1nrLK1=Rem+Gg@mail.gmail.com>
 <20230404145830.b34afedb427921de2f0e2426@linux-foundation.org>
 <CAJD7tkZCmkttJo+6XGROo+pmfQ+ppQp6=qukwvAGSeSBEGF+nQ@mail.gmail.com>
 <20230404152816.cec6d41bfb9de4680ae8c787@linux-foundation.org> <20230404153124.b0fa5074cf9fc3b9925e8000@linux-foundation.org>
In-Reply-To: <20230404153124.b0fa5074cf9fc3b9925e8000@linux-foundation.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 4 Apr 2023 16:46:30 -0700
Message-ID: <CAJD7tkYFZGJqZ278stOWDyW3HgMP8iyAZu8hSG+bV-p9YoVxig@mail.gmail.com>
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

On Tue, Apr 4, 2023 at 3:31=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Tue, 4 Apr 2023 15:28:16 -0700 Andrew Morton <akpm@linux-foundation.or=
g> wrote:
>
> > On Tue, 4 Apr 2023 15:00:57 -0700 Yosry Ahmed <yosryahmed@google.com> w=
rote:
> >
> > > ...
> > >
> > > > >
> > > > > Without refactoring the code that adds reclaim_state->reclaimed t=
o
> > > > > scan_control->nr_reclaimed into a helper (flush_reclaim_state()),=
 the
> > > > > change would need to be done in two places instead of one, and I
> > > > > wouldn't know where to put the huge comment.
> > > >
> > > > Well, all depends on how desirable it it that we backport.  If "not
> > > > desirable" then leave things as-is.  If at least "possibly desirabl=
e"
> > > > then a simple patch with the two changes and no elaborate comment w=
ill
> > > > suit.
> > > >
> > >
> > > I would rather leave the current series as-is with an elaborate
> > > comment. I can send a separate single patch as a backport to stable i=
f
> > > this is something that we usually do (though I am not sure how to
> > > format such patch).
> >
> > -stable maintainers prefer to take something which has already been
> > accepted by Linus.
> >
> > The series could be as simple as
> >
> > simple-two-liner.patch
> > revert-simple-two-liner.patch
> > this-series-as-is.patch
> >
> > simple-two-liner.patch goes into 6.3-rcX and -stable.  The other
> > patches into 6.4-rc1.
>
> But the key question remains: how desirable is a backport?
>
> Looking at the changelogs I'm not seeing a clear statement of the
> impact upon real-world users' real-world workloads.  (This is a hint).
> So I am unable to judge.
>
> Please share your thoughts on this.

I think it's nice to have but not really important. It occasionally
causes writes to memory.reclaim to report false positives and *might*
cause unnecessary retrying when charging memory, but probably too rare
to be a practical problem.

Personally, I intend to backport to our kernel at Google because it's
a simple enough fix and we have occasionally seen test flakiness
without it.

I have a reworked version of the series that only has 2 patches:
- simple-two-liner-patch (actually 5 lines)
- one patch including all refactoring squashed (introducing
flush_reclaim_state() with the huge comment, introducing
mm_account_reclaimed_pages(), and moving set_task_reclaim_state()
around).

Let me know if you want me to send it as v5, or leave the current v4
if you think backporting is not generally important.

>
