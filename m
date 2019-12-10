Return-Path: <SRS0=hCPB=2A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E76C2D0C6
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 11:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99FA02073B
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 11:02:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Mf3xlkOS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfLJLCY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Dec 2019 06:02:24 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42415 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfLJLCY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Dec 2019 06:02:24 -0500
Received: by mail-lj1-f196.google.com with SMTP id e28so19329348ljo.9
        for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2019 03:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=avT8djgaVLUaP/1BXJuTZBwRdJwwah+0AF+tp3FQZPs=;
        b=Mf3xlkOSDEXkKBh/xlW95jq/ctKWC6+5W25pp6TESvMuNfvypSGAfYHsVnbPTF1cYg
         RR0YLlmQ0tYBn9eVo9B5cXn5iQtVmIH73aTUt7+x6qyrXUIoBdS4hBRmUK0eZkDmLkAb
         EGIAlfTwNBPpLzuweZ8Ri86B/UxW1T1ZRDG8hmX5tHJ5Y5Aildo02kJCV0NHR6AdkbLh
         NBmHSZGnygxVFb9Yn3M+Ft/tELQKD1dHnNiv4mWLZc6mZCvBM+Tsyr0Wp7Sd2MG1aAHj
         Tq/GviXZQEHaPzhya05BIy0b3HF1EnJFgiDF4nG2cr+QZRR8UVHE0LLUBd9LPIqUTqH1
         6QoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=avT8djgaVLUaP/1BXJuTZBwRdJwwah+0AF+tp3FQZPs=;
        b=G8RFZdGqIeI0oR9cJbHbswdz5IFnilpvMPj8DdP6XfkC6dqZ9KLvONkQf4IoORwrUa
         nGI53g9bG6d7W6oiAZdACdxoeJY0UzoYby5a1LD0gtwLISZ1ym19dopzcvvAdpjGOiSH
         qFwZC+c1Zdm3f7cMK3im+5Zpy17i0jtexk0U3b/KzzEJwQVFBBFX85iwU20cqwwdkF6i
         3r7dvfjkm71vAFC74LLNSRLBy/lK87np5TwnW4X8EAb4ezBFCtUjcN6LjeIztAbdIcyP
         LAIwNW4E5n83hmLOJwrfFjbCO5aspMXefsn8cX2XYkD/KPRqbOnjpXYLeliGm9lHPRcT
         OzWQ==
X-Gm-Message-State: APjAAAWiX6RetZriewSTHNzmX5l9UG5sQ9T0q+88SRureC43ZoQXcPf3
        ABqXcz2a7LlJ30L6D5S1Nns72WABaHx1bameJq2DfA==
X-Google-Smtp-Source: APXvYqzdKySfdTeUTqDZf48QC6nKJjVrzelXQbA5XcMaY5YcawhwrWRM8Td38VBdqI6RgEEmwUiYHkXJsa2/pme7HDg=
X-Received: by 2002:a2e:9a04:: with SMTP id o4mr21104651lji.214.1575975741445;
 Tue, 10 Dec 2019 03:02:21 -0800 (PST)
MIME-Version: 1.0
References: <20191115234005.GO4614@dread.disaster.area> <20191118092121.GV4131@hirez.programming.kicks-ass.net>
 <20191118204054.GV4614@dread.disaster.area> <20191120191636.GI4097@hirez.programming.kicks-ass.net>
 <20191120220313.GC18056@pauld.bos.csb> <20191121132937.GW4114@hirez.programming.kicks-ass.net>
 <20191209165122.GA27229@linux.vnet.ibm.com> <20191209231743.GA19256@dread.disaster.area>
 <20191210054330.GF27253@linux.vnet.ibm.com> <CAKfTPtCBxV+az30n8E9fRv_HweN_QPJn_ni961OsKp5xUWUD2A@mail.gmail.com>
 <20191210101116.GA9139@linux.vnet.ibm.com>
In-Reply-To: <20191210101116.GA9139@linux.vnet.ibm.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Tue, 10 Dec 2019 12:02:09 +0100
Message-ID: <CAKfTPtD1by06eQ=vJhh9SvfegRanSSwQrKPageLGo0OODu9bjg@mail.gmail.com>
Subject: Re: [PATCH v2] sched/core: Preempt current task in favour of bound kthread
To:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Peter Zijlstra <peterz@infradead.org>,
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

On Tue, 10 Dec 2019 at 11:11, Srikar Dronamraju
<srikar@linux.vnet.ibm.com> wrote:
>
> * Vincent Guittot <vincent.guittot@linaro.org> [2019-12-10 10:43:46]:
>
> > On Tue, 10 Dec 2019 at 06:43, Srikar Dronamraju
> > <srikar@linux.vnet.ibm.com> wrote:
> > >
> > > This is more prone to happen if the current running task is CPU
> > > intensive and the sched_wake_up_granularity is set to larger value.
> > > When the sched_wake_up_granularity was relatively small, it was observed
> > > that the bound thread would complete before the load balancer would have
> > > chosen to move the cache hot task to a different CPU.
> > >
> > > To deal with this situation, the current running task would yield to a
> > > per CPU bound kthread, provided kthread is not CPU intensive.
> > >
> > > /pboffline/hwcct_prg_old/lib/fsperf -t overwrite --noclean -f 5g -b 4k /pboffline
> > >
> > > (With sched_wake_up_granularity set to 15ms)
> >
> > So you increase sched_wake_up_granularity to a high level to ensure
> > that current is no preempted by waking thread but then you add a way
> > to finally preempt it which is somewhat weird IMO
> >
>
> Yes, setting to a smaller value will help mitigate/solve the problem.
> There may be folks out who have traditionally set a high wake_up_granularity
> (and have seen better performance with it), who may miss out that when using
> blk-mq, such settings will cause more harm. And they may continue to see
> some performance regressions when they move to a lower wake_up_granularity.
>
> > Have you tried to increase the priority of workqueue thread  (decrease
> > nice priority) ? This is the right way to reduce the impact of the
> > sched_wake_up_granularity on the wakeup of your specific kthread.
> > Because what you want at the end is keeping a low wakeup granularity
> > for these io workqueues
> >
>
> Yes, people can tune the priority of workqueue threads and infact it may be
> easier to set wake_up_granularity to a lower value. However the point is how
> do we make everyone aware that they are running into a performance issue
> with a higher wakeup_granularity?

I did the test on my local setup to change the nice priority of io
workqueue and the active migrations are removed even with high
wakeup_granularity because IO workqueue can still preempt normal task
but let other workqueue behave normally.

>
> --
> Thanks and Regards
> Srikar Dronamraju
>
