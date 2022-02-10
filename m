Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB3EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Feb 2022 19:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343612AbiBJTDa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Feb 2022 14:03:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343596AbiBJTD3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Feb 2022 14:03:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2DFC191
        for <linux-xfs@vger.kernel.org>; Thu, 10 Feb 2022 11:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644519808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gsFXukKJVuBBklw3uyL63O8cs+I+Fi2j9mjo3qEhoLY=;
        b=OUK/p8y3ChIyEhXDrMlWaRJsJGpmzDLZ774rfj5X5xzzWBpQylZPfM9W6fLRSBD3YTzN86
        TNB5k4T3/L1zBszz3zJPKYN7euEW+INhtlBxEiMHz/PbNSkHBB5bneE8bFqU4qO87zs/Vr
        TBqMv3+9SlXsv25+UgFWoSQ2Z+FOTM4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-PsYbERinM76sasfFefcTmg-1; Thu, 10 Feb 2022 14:03:27 -0500
X-MC-Unique: PsYbERinM76sasfFefcTmg-1
Received: by mail-qt1-f198.google.com with SMTP id y22-20020ac87c96000000b002d1bfdbd86dso5097308qtv.20
        for <linux-xfs@vger.kernel.org>; Thu, 10 Feb 2022 11:03:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gsFXukKJVuBBklw3uyL63O8cs+I+Fi2j9mjo3qEhoLY=;
        b=JjCZA01afqiiGx/xh4n0KVjYzMFBsEQItcrpa67d2V+vp4TzC/QEuJjJBDucqDAwe+
         tEPFOD/L1kGczA0MnRcfRznR6M3q6DrT1Nf+yKiM2M4j3hQl5TEPoUCitGUGXtYMk3vY
         luSa9afVd0POO6M5UGdUq1rNeF/Z/7J/lp7cGx1rM6B4pvfrbSeZ8KpH1SXBV3N9WiRw
         htGJTjeLcOTi2UFf+Q36psfs9YREiNvCbyI6dpyA8bJla1b8w5K/GPT+klnGZMPhSyuZ
         fpDUJ1HCuwZKV+B3An1PrsyFkXrVx/DYmZBc2nMZzTFelVmMhzTGyMSsfD5BWTVlZBiT
         fTIQ==
X-Gm-Message-State: AOAM531v9RedN5uabO9R1eEZM2tIza6AQBEfVF95sVgMA2+PWw/LdBGP
        7/XxpDm1igqFMf8KWgufEfZXDyEI9PTHlJz41UxSwjteSp8U5Jru319x+oqKarhIRpNHf0SFGq6
        bvaKFreFTjvkp64WYvpkn
X-Received: by 2002:a05:6214:daf:: with SMTP id h15mr1329728qvh.46.1644519806861;
        Thu, 10 Feb 2022 11:03:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwtHdJOWJL8D0Cna2HeU9HnBIi+KHS5Qic7DLyWLUs5pIcjiE6X4y0g3p7b3hmC0EDlix7bmw==
X-Received: by 2002:a05:6214:daf:: with SMTP id h15mr1329699qvh.46.1644519806515;
        Thu, 10 Feb 2022 11:03:26 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id p130sm10124638qke.61.2022.02.10.11.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 11:03:26 -0800 (PST)
Date:   Thu, 10 Feb 2022 14:03:23 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <YgVhe/mAQvzPIK7M@bfoster>
References: <20220113223810.GG3290465@dread.disaster.area>
 <20220114173535.GA90423@magnolia>
 <YeHSxg3HrZipaLJg@bfoster>
 <20220114213043.GB90423@magnolia>
 <YeVxCXE6hXa1S/ic@bfoster>
 <20220118185647.GB13563@magnolia>
 <Yehvc4g+WakcG1mP@bfoster>
 <20220120003636.GF13563@magnolia>
 <Ye7aaIUvHFV18yNn@bfoster>
 <20220202022240.GY59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202022240.GY59729@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 02, 2022 at 01:22:40PM +1100, Dave Chinner wrote:
> On Mon, Jan 24, 2022 at 11:57:12AM -0500, Brian Foster wrote:
> > On Wed, Jan 19, 2022 at 04:36:36PM -0800, Darrick J. Wong wrote:
> > > > Of course if you wanted to recycle inactive inodes or do something else
> > > > entirely, then it's probably not worth going down this path..
> > > 
> > > I'm a bit partial to /trying/ to recycle inactive inodes because (a)
> > > it's less tangling with -fsdevel for you and (b) inode scans in the
> > > online repair patchset got a little weird once xfs_iget lost the ability
> > > to recycle _NEEDS_INACTIVE inodes...
> > > 
> > > OTOH I tried to figure out how to deal with the lockless list that those
> > > inodes are put on, and I couldn't figure out how to get them off the
> > > list safely, so that might be a dead end.  If you have any ideas I'm all
> > > ears. :)
> > > 
> > 
> > So one of the things that I've been kind of unclear on about the current
> > deferred inactivation implementation is the primary goal of the percpu
> > optimization. I obviously can see the value of the percpu list in
> > general, but how much processing needs to occur in percpu context to
> > achieve the primary goal?
> > 
> > For example, I can see how a single or small multi threaded sustained
> > file removal might be batched efficiently, but what happens if said task
> > happens to bounce around many cpus?
> 
> In that case we have a scheduler problem, not a per-cpu
> infrastructure issue.
> 

Last I tested on my box, a single threaded rm -rf had executed on
something like 24 of the 80 cpus available after about ~1m of runtime.
Of course the inactivation work for an inode occurs on the cpu that the
rm task was running on when the inode was destroyed, but I don't think
there's any guarantee that kworker task will be the next task selected
on the cpu if the system is loaded with other runnable tasks (and then
whatever task is selected doesn't pollute the cache). For example, I
also noticed rm-<pidX> -> rm-<pidY> context switching on concurrent
remove tests. That is obviously not a caching issue in this case because
both tasks are still doing remove work, but behavior is less
deterministic of the target task happens to be something unrelated. Of
course, that doesn't mean the approach might not otherwise be effective
for the majority of common workloads..

> > What if a system has hundreds of
> > cpus and enough removal tasks to populate most or all of the
> > queues?
> 
> It behaves identically to before the per-cpu inactivation queues
> were added. Essentially, everything serialises and burns CPU
> spinning on the CIL push lock regardless of where the work is coming
> from. The per-cpu queues do not impact this behaviour at all, nor do
> they change the distribution of the work that needs to be done.
> 
> Even Darrick's original proposal had this same behaviour:
> 
> https://lore.kernel.org/linux-xfs/20210801234709.GD2757197@dread.disaster.area/
> 

Ok..

> > Is
> > it worth having 200 percpu workqueue tasks doing block truncations and
> > inode frees to a filesystem that might have something like 16-32 AGs?
> 
> If you have a workload with 200-way concurrency that hits a
> filesystem path with 16-32 way concurrency because of per-AG
> locking (e.g. unlink needs to lock the AGI twice - once to put the
> inode on the unlinked list, then again to remove and free it),
> then you're only going to get 16-32 way concurrency from your
> workload regardless of whether you have per-cpu algorithms for parts
> of the workload.
> 
> From a workload scalability POV, we've always used the rule that the
> filesystem AG count needs to be at least 2x the concurrency
> requirement of the workload. Generally speaking, that means if you
> want the FS to scale to operations on all CPUs at once, you need to
> configure the FS with agcount=(2 * ncpus). This was one fo the first
> things I was taught about performance tuning large CPU count HPC
> machines when I first started working at SGI back in 2002, and it's
> still true today.
> 

Makes sense.

> > So I dunno, ISTM that the current implementation can be hyper efficient
> > for some workloads and perhaps unpredictable for others. As Dave already
> > alluded to, the tradeoff often times for such hyper efficient structures
> > is functional inflexibility, which is kind of what we're seeing between
> > the inability to recycle inodes wrt to this topic as well as potential
> > optimizations on the whole RCU recycling thing. The only real approach
> > that comes to mind for managing this kind of infrastructure short of
> > changing data structures is to preserve the ability to drain and quiesce
> > it regardless of filesystem state.
> > 
> > For example, I wonder if we could do something like have the percpu
> > queues amortize insertion into lock protected perag lists that can be
> > managed/processed accordingly rather than complete the entire
> > inactivation sequence in percpu context. From there, the perag lists
> > could be processed by an unbound/multithreaded workqueue that's maybe
> > more aligned with the AG count on the filesystem than cpu count on the
> > system.
> 
> That per-ag based back end processing is exactly what Darrick's
> original proposals did:
> 
> https://lore.kernel.org/linux-xfs/162758431072.332903.17159226037941080971.stgit@magnolia/
> 
> It used radix tree walks run in background kworker threads to batch
> all the inode inactivation in a given AG via radix tree walks to
> find them.
> 
> It performed poorly at scale because it destroyed the CPU affinity
> between the unlink() operation and the inactivation operation of the
> unlinked inode when the last reference to the inode is dropped and
> the inode evicted from task syscall exit context. REgardless of
> whether there is a per-cpu front end or not, the per-ag based
> processing will destroy the CPU affinity of the data set being
> processed because we cannot guarantee that the per-ag objects are
> all local to the CPU that is processing the per-ag objects....
> 

Ok. The role/significance of cpu caching was not as apparent to me when
I had last replied to this thread. The discussion around the rcu inode
lifecycle issue helped clear some of that up.

That said, why not conditionally tag and divert to a background worker
when the inodegc is disabled? That could allow NEEDS_INACTIVE inodes to
be claimed/recycled from other contexts in scenarios like when the fs is
frozen, since they won't be stuck in inaccessible and inactive percpu
queues, but otherwise preserves current behavior in normal runtime
conditions. Darrick mentioned online repair wanting to do something
similar earlier, but it's not clear to me if scrub could or would want
to disable the percpu inodegc workers in favor of a temporary/background
mode while repair is running. I'm just guessing that performance is
probably small enough of a concern in that situation that it wouldn't be
a mitigating factor. Hm?

Brian

> IOWs, all the per-cpu queues are trying to do is keep the inode
> inactivation processing local to the CPU where they are already hot
> in cache.  The per-cpu queues do not acheive this perfectly in all
> cases, but they perform far, far better than the original
> parallelised AG affinity inactivation processing that cannot
> maintain any cache affinity for the objects being processed at all.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

