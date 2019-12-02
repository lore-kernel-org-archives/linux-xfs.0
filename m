Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC65CC33C99
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 13:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A17422053B
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 13:46:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="weHqKqK6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfLBNp5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 08:45:57 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45813 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727362AbfLBNp5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 08:45:57 -0500
Received: by mail-lj1-f196.google.com with SMTP id d20so10383766ljc.12
        for <linux-xfs@vger.kernel.org>; Mon, 02 Dec 2019 05:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=49jYbZVycOXFspdxl9CDUTh2W/4I3gjVIzO2kAHOhfU=;
        b=weHqKqK6CpbCFt1jkDcyAM9l4ZlRl5wkEuDFLBbazMmIojfqabp5oSo6tLXuCIzaWu
         MuYMSoa0ONVmpFuwjEWhox/dhcv86Z+wsg/9kFtV+cGU8yOL6I56QuWgtyseIhjPdthi
         I4+IK8zSzhPx9UAPZQ1g80GtClIcJh08T7JdA38TQ8PMmNgRAMPhKG+oIUfRP8h/P0hE
         Ax9lEnmLM6EUctVOZmfwlpRgge80/NhgGBajWxHstwa7SYJzz95fdPGiB0sr3VHSmSSy
         AHtD+4qLHIo/GXk0NdOm9nCKaAktJHtGSveoJV3FECVT+9pI49wRBla4o7CRBlyZVmDK
         dsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=49jYbZVycOXFspdxl9CDUTh2W/4I3gjVIzO2kAHOhfU=;
        b=P5GGYrKUeWP4kXBorFJ6fdozK0uuD5r0Bcnh7OBLz1Sbb1v0fChAf2jmefV7izcKh5
         lxubmKNVQN/xWsJauFbBoU3tiVlSIRX6FVOp0yw3Pkc2XQyEGmeoQaDAxyVQxKbhReE2
         uGm3DWYG3+IcEAEXVlCxll7XVigbtfYvrP8a36zXsTAdWAhbTvohnURZ85m2mnH2uTuG
         95oWdCTJwH8lV16PwbmHsD1S9DYV6NU2ZjTwxLVEcSqWEqefchEVYvLdgLTNRjZuOO0V
         /rRBykU4xAfaBMg8em15oFuL2SDYrJgUmzBSFQ91zLdhfH43d4SdM1GUZe+C8jOB4fJ0
         6G0w==
X-Gm-Message-State: APjAAAU6E9g/GNpx3W7MCQjyto6lypauVYCife+OKvOunr6iz5X6epp+
        CrTSDDHS/BeS6DI/MMCX7Qcyjwgh5fv/k43CiYaKqw==
X-Google-Smtp-Source: APXvYqxeByd/GwXPla7qySqPY0k0YYlASUzuqjZNj/U6zFcUOWxtXgVlcft9G28tw4AAwHLj66dc1hiGkBjfOJNyWxY=
X-Received: by 2002:a2e:9a04:: with SMTP id o4mr14412076lji.214.1575294354710;
 Mon, 02 Dec 2019 05:45:54 -0800 (PST)
MIME-Version: 1.0
References: <20191114113153.GB4213@ming.t460p> <20191114235415.GL4614@dread.disaster.area>
 <20191115010824.GC4847@ming.t460p> <20191115045634.GN4614@dread.disaster.area>
 <20191115070843.GA24246@ming.t460p> <20191128094003.752-1-hdanton@sina.com>
 <CAKfTPtA23ErKGCEJVmg6vk-QoufkiUM3NbXd31mZmKnuwbTkFw@mail.gmail.com>
 <20191202024625.GD24512@ming.t460p> <20191202040256.GE2695@dread.disaster.area>
In-Reply-To: <20191202040256.GE2695@dread.disaster.area>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Mon, 2 Dec 2019 14:45:42 +0100
Message-ID: <CAKfTPtD8Q97qJ_+hdCXQRt=gy7k96XrhnFmGYP1G88YSFW0vNA@mail.gmail.com>
Subject: Re: single aio thread is migrated crazily by scheduler
To:     Dave Chinner <david@fromorbit.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Hillf Danton <hdanton@sina.com>,
        linux-block <linux-block@vger.kernel.org>,
        linux-fs <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>,
        Rong Chen <rong.a.chen@intel.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2 Dec 2019 at 05:02, Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Dec 02, 2019 at 10:46:25AM +0800, Ming Lei wrote:
> > On Thu, Nov 28, 2019 at 10:53:33AM +0100, Vincent Guittot wrote:
> > > On Thu, 28 Nov 2019 at 10:40, Hillf Danton <hdanton@sina.com> wrote:
> > > > --- a/fs/iomap/direct-io.c
> > > > +++ b/fs/iomap/direct-io.c
> > > > @@ -157,10 +157,8 @@ static void iomap_dio_bio_end_io(struct
> > > >                         WRITE_ONCE(dio->submit.waiter, NULL);
> > > >                         blk_wake_io_task(waiter);
> > > >                 } else if (dio->flags & IOMAP_DIO_WRITE) {
> > > > -                       struct inode *inode = file_inode(dio->iocb->ki_filp);
> > > > -
> > > >                         INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
> > > > -                       queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
> > > > +                       schedule_work(&dio->aio.work);
> > >
> > > I'm not sure that this will make a real difference because it ends up
> > > to call queue_work(system_wq, ...) and system_wq is bounded as well so
> > > the work will still be pinned to a CPU
> > > Using system_unbound_wq should make a difference because it doesn't
> > > pin the work on a CPU
> > >  +                       queue_work(system_unbound_wq, &dio->aio.work);
> >
> > Indeed, just run a quick test on my KVM guest, looks the following patch
> > makes a difference:
> >
> > diff --git a/fs/direct-io.c b/fs/direct-io.c
> > index 9329ced91f1d..2f4488b0ecec 100644
> > --- a/fs/direct-io.c
> > +++ b/fs/direct-io.c
> > @@ -613,7 +613,8 @@ int sb_init_dio_done_wq(struct super_block *sb)
> >  {
> >         struct workqueue_struct *old;
> >         struct workqueue_struct *wq = alloc_workqueue("dio/%s",
> > -                                                     WQ_MEM_RECLAIM, 0,
> > +                                                     WQ_MEM_RECLAIM |
> > +                                                     WQ_UNBOUND, 0,
> >                                                       sb->s_id);
>
> That's not an answer to the user task migration issue.
>
> That is, all this patch does is trade user task migration when the
> CPU is busy for migrating all the queued work off the CPU so the
> user task does not get migrated. IOWs, this forces all the queued
> work to be migrated rather than the user task. IOWs, it does not
> address the issue we've exposed in the scheduler between tasks with
> competing CPU affinity scheduling requirements - it just hides the
> symptom.
>
> Maintaining CPU affinity across dispatch and completion work has
> been proven to be a significant performance win. Right throughout
> the IO stack we try to keep this submitter/completion affinity,
> and that's the whole point of using a bound wq in the first place:
> efficient delayed batch processing of work on the local CPU.

Do you really want to target the same CPU ? looks like what you really
want to target the same cache instead

>
> Spewing deferred completion work across every idle CPU in the
> machine because the local cpu is temporarily busy is a bad choice,
> both from a performance perspective (dirty cacheline bouncing) and
> from a power efficiency point of view as it causes CPUs to be taken
> out of idle state much more frequently[*].
>
> The fact that the scheduler migrates the user task we use workqueues
> for deferred work as they were intended doesn't make this a
> workqueue problem. If the answer to this problem is "make all IO
> workqueues WQ_UNBOUND" then we are effectively saying "the scheduler
> has unfixable problems when mixing bound and unbound work on the
> same run queue".
>
> And, besides, what happens when every other CPU is also completely
> busy and can't run the work in a timely fashion? We've just moved
> the work to some random CPU where we wait to be scheduled instead of
> just sitting on the local CPU and waiting....
>
> So, yes, we can work around the -symptoms- we see (frequent user
> task migration) by changing the work queue configuration or
> bypassing the workqueue for this specific workload. But these only
> address the visible symptom and don't take into account the wider
> goals of retaining CPU affinity in the IO stack, and they will have
> variable scheduling latency and perofrmance and as the overall
> system load changes.
>
> So, we can fiddle with workqueues, but it doesn't address the
> underlying issue that the scheduler appears to be migrating
> non-bound tasks off a busy CPU too easily....

The root cause of the problem is that the sched_wakeup_granularity_ns
is in the same range or higher than load balance period. As Peter
explained, This make the kworker waiting for the CPU for several load
period and a transient unbalanced state becomes a stable one that the
scheduler to fix. With default value, the scheduler doesn't try to
migrate any task.

Then, I agree that having an ack close to the request makes sense but
forcing it on the exact same CPU is too restrictive IMO. Being able to
use another CPU on the same core should not harm the performance and
may even improve it. And that may still be the case while CPUs share
their cache.

>
> -Dave.
>
> [*] Pay attention to the WQ_POWER_EFFICIENT definition for a work
> queue: it's designed for interrupt routines that defer work via work
> queues to avoid doing work on otherwise idle CPUs. It does this by
> turning the per-cpu wq into an unbound wq so that work gets
> scheduled on a non-idle CPUs in preference to the local idle CPU
> which can then remain in low power states.
>
> That's the exact opposite of what using WQ_UNBOUND ends up doing in
> this IO completion context: it pushes the work out over idle CPUs
> rather than keeping them confined on the already busy CPUs where CPU
> affinity allows the work to be done quickly. So while WQ_UNBOUND
> avoids the user task being migrated frequently, it results in the
> work being spread around many more CPUs and we burn more power to do
> the same work.
>
> --
> Dave Chinner
> david@fromorbit.com
