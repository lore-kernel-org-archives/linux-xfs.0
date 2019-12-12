Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A1F8C2D0C9
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 11:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CB2422527
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 11:20:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ejIqzn/R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbfLLLUP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 06:20:15 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36891 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbfLLLUO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 06:20:14 -0500
Received: by mail-lj1-f194.google.com with SMTP id u17so1855961lja.4
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 03:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P1W0z4HqV64jzJwtaYcGadzOgRZCn2v4chbYC9m9FGs=;
        b=ejIqzn/RWAjyKo7RBVFzhGkFkF2lSZiGd2eJMd8SI1r0ISOjFbygsYsgAQN8XmQzQk
         0lLFXQhwKM1eITsy4avAQxAh9YW73FCSxA30SOO4ebLCpg54/FqhH1kVEkL7cqr550+3
         I9a9nPQN0ywXQrPzcfOaggdXetKiYHLmJjI+1DZc9EUMx2O/iWPayKLBlkjZYv4V8NgJ
         nan9YSgU3ufNHuyQvCbLyfmekHqbVqfxJNEwf9KzEqsovts3q/fPjhlFqhuzDFb1nWyW
         xAcA0eUqzW/MADBAAmUvKLx8NNJDQc7mcfuqeaYrbAn5Geo/v9v5h5dAUr3AVBKVcV47
         h5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P1W0z4HqV64jzJwtaYcGadzOgRZCn2v4chbYC9m9FGs=;
        b=MdV4igd1GigfNvpC4sDe0d0boAhml0sSKxd+WZcy6bxauGl/6kfXapUnW76WmK9E+k
         kTazdO4BWTu8CCEAKRaOqLDsfakZCWMSzvaNlRT7VyvGepWdrW8kHlwwF9pX5fjkA5WN
         AxpzrEJ35jXIzuKPQD4xz3pcTWKapuA8H/4p4uKAYSfWkdm/JBOUS6D1nTDLftRzYzI6
         GM19GcUbsO4Pdpxa/aIJ89X0v7TLyKJn5m3tGDV1cP9S6MnFcQFWoXNhh1xv54/993aU
         oiU36B6hsmdENuaGfStuVSYgbjkhRemCUiWZTu1vH81688KUv/NjEzjciPcHtSOYv6FK
         hiFg==
X-Gm-Message-State: APjAAAXTJrrPTYpPKVa20pOpTmlJwbpFv2WYjU5jayTfV56BZD+yflVL
        RIWw4yyc7F8usqos8x0pcRgShoX2wp/9bm6BVX8/EbhBzek=
X-Google-Smtp-Source: APXvYqwcNMZYiNwnTt8iXUn4bZLBe/VVIuZbWOxdaGwBRPCIZF6vo/z0Flel1o/NxhVXsNhFkAgOrX3kstFVUuexBm4=
X-Received: by 2002:a2e:9a51:: with SMTP id k17mr5118022ljj.206.1576149612570;
 Thu, 12 Dec 2019 03:20:12 -0800 (PST)
MIME-Version: 1.0
References: <20191120220313.GC18056@pauld.bos.csb> <20191121132937.GW4114@hirez.programming.kicks-ass.net>
 <20191209165122.GA27229@linux.vnet.ibm.com> <20191209231743.GA19256@dread.disaster.area>
 <20191210054330.GF27253@linux.vnet.ibm.com> <20191210172307.GD9139@linux.vnet.ibm.com>
 <20191211173829.GB21797@linux.vnet.ibm.com> <20191211224617.GE19256@dread.disaster.area>
 <20191212101031.GV2827@hirez.programming.kicks-ass.net> <20191212101424.GH2871@hirez.programming.kicks-ass.net>
 <20191212102327.GI2871@hirez.programming.kicks-ass.net>
In-Reply-To: <20191212102327.GI2871@hirez.programming.kicks-ass.net>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Thu, 12 Dec 2019 12:20:01 +0100
Message-ID: <CAKfTPtCUm5vuvNiWszJ5tWHxmcZ2v_KexOxnBHLUkBcqC-P3fw@mail.gmail.com>
Subject: Re: [PATCH v4] sched/core: Preempt current task in favour of bound kthread
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Phil Auld <pauld@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        linux-block <linux-block@vger.kernel.org>,
        linux-fs <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 12 Dec 2019 at 11:23, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Dec 12, 2019 at 11:14:24AM +0100, Peter Zijlstra wrote:
> > On Thu, Dec 12, 2019 at 11:10:31AM +0100, Peter Zijlstra wrote:
> > > @@ -4156,13 +4159,13 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> > >     if (delta_exec < sysctl_sched_min_granularity)
> > >             return;
> > >
> > > -   se = __pick_first_entity(cfs_rq);
> > > +   se = __pick_next_entity(cfs_rq, NULL);
> > >     delta = curr->vruntime - se->vruntime;
> > >
> > >     if (delta < 0)
> > >             return;
> >
> > What I mean with the below comment is, when this isn't enough, try
> > something like:
> >
> >       if (se == cfs_rq->next)
> >               ideal_runtime /= 2;
> >
> > to make it yield sooner to 'next' buddies. Sadly, due to the whole
> > cgroup mess, we can't say what actual task is on the end of it (without
> > doing a full hierarchy pick, which is more expensive still).
>
> Just for giggles, that'd look something like:
>
>         while (!entity_is_task(se) {
>                 cfs_rq = group_cfs_rq(se);
>                 se = pick_next_entity(cfs_rq, cfs_rq->curr);
>         }
>         p = task_of(se);
>
>         if (is_per_cpu_kthread(p))
>                 ideal_runtime /= 2;
>
> the core-scheduling patch set includes the right primitive for this I
> think, pick_task_fair().

why not only updating wan_gran() which is the only function which uses
sysctl_sched_wakeup_granularity ?

For per cpu kthread, we could set the gran to sched_min_granularity
instead of scaling it with thread's priority so per cpu kthread can
still preempt current ask even if sysctl_sched_wakeup_granularity is
large

>
> > > -   if (delta > ideal_runtime)
> > > +   if (delta > ideal_runtime) // maybe frob this too ?
> > >             resched_curr(rq_of(cfs_rq));
> > >  }
