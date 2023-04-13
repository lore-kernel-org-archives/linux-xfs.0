Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F475C77B61
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 21:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjDMVin (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 17:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjDMVim (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 17:38:42 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8E88A6A
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 14:38:41 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id q23so31376307ejz.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 14:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681421919; x=1684013919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3jBN+8LrzwMXhGPqL5814QrhuMx8BEUkHOa7oPWnQaE=;
        b=QZdxNYxEivIMZ3ZooTXElyWIFOLp5+PPY8jbvBPSm/tV3OxRewz8DNABvmmlIACTNm
         b+0rTKE+ycHM8LIvKqhIP79/9GdyN122NZ+udkSdzW2hS0GjAlQib1q9Y771OOVt7LeK
         xwNJQN+UV8Zu+sP9jV64XmUrMaARtI+K3V/jp7Nmm38HeihqNqbdk+mNixdEvLdovloV
         RW6DxYQUpu5JBFIFndkdxyKS3/Op1Jm8A9wvFMY64VFbvRvbF/n6Vpc/6BZWtnYu1mhq
         +PBGUkwsTfguY8eO8CwLcUGujLnaX6vegAUFhkNUfASZKhSEFVT0aFdpLgpF6tq8+LV1
         0sbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681421919; x=1684013919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3jBN+8LrzwMXhGPqL5814QrhuMx8BEUkHOa7oPWnQaE=;
        b=OVWoQLahLHEfX6yHW8ElrTX3oFhwxJ4EQBhsunrX66w92VBv0rWeEz4bOkxE/ZPLz5
         7lweiJkNueQuSJClgIjFNMp0EPSEJ58xXiu0BSpzt7ukwVPWg6XFc3dn9guiD7Yc/gKK
         t81m0OIC4y2/j30mBet9ohfg8LthyB85ZHxu1jroRrkYNY8iLiX58FfhtbXPrRI7+FHX
         EihWbu21rlKlkDIBx9gpgksM0/EHoC7mqWK6jrdikxThzOlXk8pqziWMZcdGORiOdXUQ
         EobLsZdkQPzRZlp3SVphM5xaObYCETlwXmBvnqgeTALn2QYn7bX4jbmqUbs5X9I9B5VW
         p9tQ==
X-Gm-Message-State: AAQBX9dsxE0v0NcsvNjqFVp/ewC3bW0eCmUoNFSHcwGU9iwNoQGBO0hM
        NirBfLb6TsiJFYBFeUO1z69V94mt0UI9q4B+lMutAA==
X-Google-Smtp-Source: AKy350Y6kBYhazbwFlQvQ41HouUtIxfhmf9gOW69a2TRd0rfUKWOv9wHpoOyOmLBMxDdGgLaxywU4ZpyPneky9jufVw=
X-Received: by 2002:a17:906:f0cc:b0:94e:d53e:cc7c with SMTP id
 dk12-20020a170906f0cc00b0094ed53ecc7cmr453680ejb.15.1681421919536; Thu, 13
 Apr 2023 14:38:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230413104034.1086717-1-yosryahmed@google.com>
 <20230413104034.1086717-4-yosryahmed@google.com> <b7fe839d-d914-80f7-6b96-f5f3a9d0c9b0@redhat.com>
 <CAJD7tkae0uDuRG77nQEtzkV1abGstjF-1jfsCguR3jLNW=Cg5w@mail.gmail.com> <20230413210051.GO3223426@dread.disaster.area>
In-Reply-To: <20230413210051.GO3223426@dread.disaster.area>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Thu, 13 Apr 2023 14:38:03 -0700
Message-ID: <CAJD7tkbzQb+gem-49xo8=1EfeOttiHZpD4X-iiWvHuO9rrHuog@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] mm: vmscan: refactor updating current->reclaim_state
To:     Dave Chinner <david@fromorbit.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2023 at 2:01=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Thu, Apr 13, 2023 at 04:29:43AM -0700, Yosry Ahmed wrote:
> > On Thu, Apr 13, 2023 at 4:21=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> > >
> > > On 13.04.23 12:40, Yosry Ahmed wrote:
> > > > During reclaim, we keep track of pages reclaimed from other means t=
han
> > > > LRU-based reclaim through scan_control->reclaim_state->reclaimed_sl=
ab,
> > > > which we stash a pointer to in current task_struct.
> > > >
> > > > However, we keep track of more than just reclaimed slab pages throu=
gh
> > > > this. We also use it for clean file pages dropped through pruned in=
odes,
> > > > and xfs buffer pages freed. Rename reclaimed_slab to reclaimed, and=
 add
> > >
> > > Would "reclaimed_non_lru" be more expressive? Then,
> > >
> > > mm_account_reclaimed_pages() -> mm_account_non_lru_reclaimed_pages()
> > >
> > >
> > > Apart from that LGTM.
> >
> > Thanks!
> >
> > I suck at naming things. If you think "reclaimed_non_lru" is better,
> > then we can do that. FWIW mm_account_reclaimed_pages() was taken from
> > a suggestion from Dave Chinner. My initial version had a terrible
> > name: report_freed_pages(), so I am happy with whatever you see fit.
> >
> > Should I re-spin for this or can we change it in place?
>
> I don't care for the noise all the bikeshed painting has generated
> for a simple change like this.  If it's a fix for a bug, and the
> naming is good enough, just merge it already, ok?

Sorry for all the noise. I think this version is in good enough shape.

Andrew, could you please replace v4 with this v6 without patch 2 as
multiple people pointed out that it is unneeded? Sorry for the hassle.

>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
