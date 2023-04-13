Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43D7C77B6E
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 11:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjDML10 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 07:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjDML1Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 07:27:25 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBFA93FE
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 04:27:24 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id q23so27078632ejz.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 04:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681385242; x=1683977242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hzqQs+ynPLskxl47UZfCKlnD8vWrn86NbxoteoLGhFU=;
        b=JNfNJP3pF77l40f1jjSgvbWjp2I2/WFvuBnxlqMR81t79Dtpme0p9vMqE0EfTQlY+5
         UQ5/1l+482xix6SvemcrraWKa8GP6Eq9DLY2ze//BXzN6zXQ+yYtsnOSweo+AFG1OQtc
         C7hG7cdh1vUGhwwE+G1jeoRmTSjeavJatbUnKd2hrAI9Akn0/QYTYoYXhVnfkoGtMaIY
         Ox9YUu+JbLCOCTEirveoq4t/mSoxeo0MvMzFgs+MRLUBCZOCaTLKaqSpNbmiPSp3ITGu
         +7bV2a8y9RqGqHKl4mmEmAGXcma6tXW7Uf8YVPJ2TqTph4k1//8eeXUKBSKqd68ShkvY
         42BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681385242; x=1683977242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hzqQs+ynPLskxl47UZfCKlnD8vWrn86NbxoteoLGhFU=;
        b=RfepUssCW1ZQE48x8PGPSYJ5tXVB3lsuzxW4wEbIJSgpg16IQXtiPTVyKPnbYM+AdS
         6f0vLghHnrKd7UYcZIzy2zQZh3/89Y24OY40R0hbMm6StZevnE3JsrU8jn2URdHyLtS4
         RLPTgarbjyv+GvR09ndXRACVqbqM4sEzi8PqPBH9Lxu+bOAfFOQg75U5BI3vBoZZ+eij
         NaPjzWTDuYhqbYu1JR8H/G8PZ27JGV6VoPWamGUAoMsXixqzPJzK9gVGj0mpdHCEhO+8
         Lff9toZtuqTH8+eiaphZNLTSTm93ovnT10YYkYjCU2uq2k27rkGzl/MtDLZzKvnyixa+
         Dpaw==
X-Gm-Message-State: AAQBX9fUivQAohWcNPe85kuO2sH9f+6s0fvpjG1rpUAIASiXae00I4kP
        IgTIysdhjt4nPGlkSr+5xQCThfz1UXwL2JhF5hiLFQ==
X-Google-Smtp-Source: AKy350ZRfFmJqhIM+zLx5wasnjk9Kpxdo4Y1Z7QE9rOwvq/eCO+8LfihDacwwj/WEG28XM3uy6urY66KF6eKt2jUGgg=
X-Received: by 2002:a17:906:2c1a:b0:94e:8e6f:4f1c with SMTP id
 e26-20020a1709062c1a00b0094e8e6f4f1cmr1088308ejh.15.1681385242447; Thu, 13
 Apr 2023 04:27:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230413104034.1086717-1-yosryahmed@google.com>
 <20230413104034.1086717-3-yosryahmed@google.com> <bb42720b-dec9-a62b-50a2-422ddd6a1920@redhat.com>
In-Reply-To: <bb42720b-dec9-a62b-50a2-422ddd6a1920@redhat.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Thu, 13 Apr 2023 04:26:45 -0700
Message-ID: <CAJD7tkZFnjw4sfvr1aDts0B4uWrHAQ962mgKwA3h=es3P=QWFQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] mm: vmscan: move set_task_reclaim_state() near flush_reclaim_state()
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

On Thu, Apr 13, 2023 at 4:19=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 13.04.23 12:40, Yosry Ahmed wrote:
> > Move set_task_reclaim_state() near flush_reclaim_state() so that all
> > helpers manipulating reclaim_state are in close proximity.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
>
> Hm, it's rather a simple helper to set the reclaim_state for a task, not
> to modify it.
>
> No strong opinion, but I'd just leave it as it.

It's just personal taste to have helpers acting on the same data
structure next to one another. I don't feel strongly about it either,
I left it as a separate patch so that we can simply drop it. Peter
also thought the same, so maybe I should just drop it.

>
> --
> Thanks,
>
> David / dhildenb
>
