Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF34C761A6
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Mar 2023 22:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjCaWM1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Mar 2023 18:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbjCaWM0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2023 18:12:26 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EED95279
        for <linux-xfs@vger.kernel.org>; Fri, 31 Mar 2023 15:12:24 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r11so95218113edd.5
        for <linux-xfs@vger.kernel.org>; Fri, 31 Mar 2023 15:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680300743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GXj7Qyhuc3VANVAIof/dkXyPEcXygM8YpKQLnR/FCeE=;
        b=Y7wgIhz8nV9/+JLQsYPnAwcryWNNk6SGIsTlR1ZDgFqo2CeTCBdwaY/59tRk1x6wDD
         kJ6hALcgHquJ/7Uw4MiIw4axX8C5DJ7h0ca615Iy3dMLiloDQeOLieUPgXncrwBpcX4e
         m4gAv6Jw4n7BAz5q/oWkZXbBG/l1vfedPJXZxOVCX0izr91Hbzh9Ff5RgEavalR/3rVf
         TlgSh9YdhXvtBNU3CNgG30msbxq42Qn1Iz3O8TlEOIqVOanF6/XVsco+Fyj6Qy1Je7EI
         VsH7GhxQddG6FAxXQId4sr1vTc9RbdeM9SBpzwSijPTcRwfUk4JQDAajQQajP2kXyrdy
         7WBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680300743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GXj7Qyhuc3VANVAIof/dkXyPEcXygM8YpKQLnR/FCeE=;
        b=dNuyTJt3gIBGaykFm2TJ0pFjusED2y3OTktfjQbakOjk37kc47zaynMCQQm8XLEUnf
         LUqlSSeujFwQw6ULx3wVYvLLIiKkp2PvlV4L+aNE5s4LajDq0xAFlZ77MU7vcx5KE0fz
         iB4C5WYAOI4JzTpuoytTTHyWFi638ysKkVXEzmdWoBVit09GcwoeWfClRbANyIDtfzjd
         07SQW/jXiT5PrRmqRjR339uTqqRUxWh0B/2S/5NahK8M5XQmpWbj52aTLERKDWn3BG8U
         dVV8oT/RxnMXnzMsB90ycX4UDS8IqP0qy1n9iP4Ia6wb6oKEDC+mI5q9EMhtLUOL4gKi
         0uSA==
X-Gm-Message-State: AAQBX9fYPs8E0ab/LbCuzQ8/PFRcLVLJxHCC5bh8dUsAItChxjLDK9Qa
        jQUIZMrwHfzdn+tqQC2J8l/f2xeEkePH5s70VoMElg==
X-Google-Smtp-Source: AKy350YNxzefAx/NXeor8UoJ5Yql4qMe7ZyBd+MvOF9a06S3oO/DniRs2KI3wKVInPUmESDZhZ1+jvPbQ747jsXKQN4=
X-Received: by 2002:a17:906:2456:b0:8e5:411d:4d09 with SMTP id
 a22-20020a170906245600b008e5411d4d09mr14741355ejb.15.1680300742955; Fri, 31
 Mar 2023 15:12:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230331070818.2792558-1-yosryahmed@google.com>
 <20230331070818.2792558-3-yosryahmed@google.com> <20230331205117.GI3223426@dread.disaster.area>
In-Reply-To: <20230331205117.GI3223426@dread.disaster.area>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 31 Mar 2023 15:11:46 -0700
Message-ID: <CAJD7tkai_tv32GREjLvopLkUufq+WiR0-fFr-eNAzZNmQqk5dQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: vmscan: refactor updating reclaimed pages in reclaim_state
To:     Dave Chinner <david@fromorbit.com>
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
        David Hildenbrand <david@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>, Yu Zhao <yuzhao@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 31, 2023 at 1:51=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Fri, Mar 31, 2023 at 07:08:17AM +0000, Yosry Ahmed wrote:
> > During reclaim, we keep track of pages reclaimed from other means than
> > LRU-based reclaim through scan_control->reclaim_state->reclaimed_slab,
> > which we stash a pointer to in current task_struct.
> >
> > However, we keep track of more than just reclaimed slab pages through
> > this. We also use it for clean file pages dropped through pruned inodes=
,
> > and xfs buffer pages freed. Rename reclaimed_slab to reclaimed, and add
> > a helper function that wraps updating it through current, so that futur=
e
> > changes to this logic are contained within mm/vmscan.c.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> .....
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index fef7d1c0f82b2..a3e38851b34ac 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -511,6 +511,34 @@ static void set_task_reclaim_state(struct task_str=
uct *task,
> >       task->reclaim_state =3D rs;
> >  }
> >
> > +/*
> > + * mm_account_reclaimed_pages(): account reclaimed pages outside of LR=
U-based
> > + * reclaim
> > + * @pages: number of pages reclaimed
> > + *
> > + * If the current process is undergoing a reclaim operation, increment=
 the
> > + * number of reclaimed pages by @pages.
> > + */
> > +void mm_account_reclaimed_pages(unsigned long pages)
> > +{
> > +     if (current->reclaim_state)
> > +             current->reclaim_state->reclaimed +=3D pages;
> > +}
> > +EXPORT_SYMBOL(mm_account_reclaimed_pages);
>
> Shouldn't this be a static inline in a header file?
>
> Then you don't need an EXPORT_SYMBOL() - which should really be
> EXPORT_SYMBOL_GPL() - and callers don't add the overhead of a
> function call for two lines of code....

Yes it should be. Thanks.

An earlier draft of this series had more going on in this function, so
I moved it to mm/vmscan.c, then I forgot to move it to the header
later. Will do that for v4.

>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
