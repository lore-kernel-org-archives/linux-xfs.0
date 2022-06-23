Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A62C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 11:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbiFWLuI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 07:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbiFWLt5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 07:49:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9EAF4D25C
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 04:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655984992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L0wnIASTmDyRBcEcx/ictQYdjHYO7TPcMfV9Uw42DMY=;
        b=D2wz6+CmkaKXLnKq1ongmSqDysD239E/DsIbebKi4nog36cXbADhiSb3/diA8eYHwkH0rZ
        58H/vURVN+7R/97vTxpTb7JvMthFL3nj3mc1P9pbrtAqBxXuirKPZHSMyQNUT9BoEH6boO
        DeRujOZ5lttkyiTmJrtRkAcfm+qXJMc=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-QtHz4NWwNSOGA0uyZPmmKA-1; Thu, 23 Jun 2022 07:49:50 -0400
X-MC-Unique: QtHz4NWwNSOGA0uyZPmmKA-1
Received: by mail-qk1-f197.google.com with SMTP id i16-20020a05620a249000b006aedb25493cso5316406qkn.15
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 04:49:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L0wnIASTmDyRBcEcx/ictQYdjHYO7TPcMfV9Uw42DMY=;
        b=Xf4EGvCsXtmrItknaCicidIBQBLrGc5/SSg0MZabs2bpMxaoqiL+dOrEHudV/R/D6d
         qM5FO2DjQkhc4JRKd7/HdJ/mu+BKxI+Tm11g6fTlDE3IyLyQcmOAE54LKpmz4VymnD6E
         WzqrKn+LHVc4Ey23zzr29bfzTFg2XrzIuhsd7MdEmApJ8uEIbt3qiQtkQALePsxdcAFN
         OEBUND0QbisTPDj4JUHLZNmNCQIhYZoxMlCFyM/UpMa9N0Gve8x9vehpdtR3R8NCYEfK
         AB5nr4YtjgCNecIelsEgRm1ulMsp1wZ0DKw5WOVvSgFlJfCfWOh51847Twj7d6S3uUuq
         hhSQ==
X-Gm-Message-State: AJIora/zIpnYvyRNKkeBs4ur6Yfmw1d3wDB5s8HVlZX231raCLL+GAKC
        mg1vHkXDa9+HT0RBujfMpf60NtldC3UbMpW8wmjvb3o7W15dFa/3+HnpEnVLa0ZQHRWuCl6NbVG
        BJDrU5EHxzT9S7mnRkbYP
X-Received: by 2002:a05:622a:1389:b0:304:f2f9:8202 with SMTP id o9-20020a05622a138900b00304f2f98202mr7355751qtk.42.1655984990008;
        Thu, 23 Jun 2022 04:49:50 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tZm1YYQOJA5tONdhBD+rhGoXpSSBQ4QNXb7+vE5J6VV74YW6WGKvkNtrBbAOyQ3A0YLOp6Cg==
X-Received: by 2002:a05:622a:1389:b0:304:f2f9:8202 with SMTP id o9-20020a05622a138900b00304f2f98202mr7355729qtk.42.1655984989661;
        Thu, 23 Jun 2022 04:49:49 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id h8-20020ac85148000000b003117ee89a51sm6086387qtn.70.2022.06.23.04.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 04:49:49 -0700 (PDT)
Date:   Thu, 23 Jun 2022 07:49:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: bound maximum wait time for inodegc work
Message-ID: <YrRTWoEZys3DfPW8@bfoster>
References: <20220615220416.3681870-1-david@fromorbit.com>
 <20220615220416.3681870-2-david@fromorbit.com>
 <YqytHuc/sJprFn0K@bfoster>
 <20220617215245.GH227878@dread.disaster.area>
 <YrKmrgJh9+SzT0Gz@magnolia>
 <YrM/woFhObNYQx3b@bfoster>
 <YrOzAPXCcDY9DnCj@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrOzAPXCcDY9DnCj@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 05:25:36PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 22, 2022 at 12:13:54PM -0400, Brian Foster wrote:
> > On Tue, Jun 21, 2022 at 10:20:46PM -0700, Darrick J. Wong wrote:
> > > On Sat, Jun 18, 2022 at 07:52:45AM +1000, Dave Chinner wrote:
> > > > On Fri, Jun 17, 2022 at 12:34:38PM -0400, Brian Foster wrote:
> > > > > On Thu, Jun 16, 2022 at 08:04:15AM +1000, Dave Chinner wrote:
> > > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > > 
> > > > > > Currently inodegc work can sit queued on the per-cpu queue until
> > > > > > the workqueue is either flushed of the queue reaches a depth that
> > > > > > triggers work queuing (and later throttling). This means that we
> > > > > > could queue work that waits for a long time for some other event to
> > > > > > trigger flushing.
> > > > > > 
> > > > > > Hence instead of just queueing work at a specific depth, use a
> > > > > > delayed work that queues the work at a bound time. We can still
> > > > > > schedule the work immediately at a given depth, but we no long need
> > > > > > to worry about leaving a number of items on the list that won't get
> > > > > > processed until external events prevail.
> > > > > > 
> > > > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > > > ---
> > > > > >  fs/xfs/xfs_icache.c | 36 ++++++++++++++++++++++--------------
> > > > > >  fs/xfs/xfs_mount.h  |  2 +-
> > > > > >  fs/xfs/xfs_super.c  |  2 +-
> > > > > >  3 files changed, 24 insertions(+), 16 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > > > index 374b3bafaeb0..46b30ecf498c 100644
> > > > > > --- a/fs/xfs/xfs_icache.c
> > > > > > +++ b/fs/xfs/xfs_icache.c
> > > > > ...
> > > > > > @@ -2176,7 +2184,7 @@ xfs_inodegc_shrinker_scan(
> > > > > >  			unsigned int	h = READ_ONCE(gc->shrinker_hits);
> > > > > >  
> > > > > >  			WRITE_ONCE(gc->shrinker_hits, h + 1);
> > > > > > -			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
> > > > > > +			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
> > > > > >  			no_items = false;
> > > > > >  		}
> > > > > 
> > > > > This all seems reasonable to me, but is there much practical benefit to
> > > > > shrinker infra/feedback just to expedite a delayed work item by one
> > > > > jiffy? Maybe there's a use case to continue to trigger throttling..?
> > > > 
> > > > I haven't really considered doing anything other than fixing the
> > > > reported bug. That just requires an API conversion for the existing
> > > > "queue immediately" semantics and is the safest minimum change
> > > > to fix the issue at hand.
> > > > 
> > > > So, yes, the shrinker code may (or may not) be superfluous now, but
> > > > I haven't looked at it and done analysis of the behaviour without
> > > > the shrinkers enabled. I'll do that in a completely separate
> > > > patchset if it turns out that it is not needed now.
> > > 
> > > I think the shrinker part is still necessary -- bulkstat and xfs_scrub
> > > on a very low memory machine (~560M RAM) opening and closing tens of
> > > millions of files can still OOM the machine if one doesn't have a means
> > > to slow down ->destroy_inode (and hence the next open()) when reclaim
> > > really starts to dig in.  Without the shrinker bits, it's even easier to
> > > trigger OOM storms when xfs has timer-delayed inactivation... which is
> > > something that Brian pointed out a year ago when we were reviewing the
> > > initial inodegc patchset.
> > > 
> > 
> > It wouldn't surprise me if the infrastructure is still necessary for the
> > throttling use case. In that case, I'm more curious about things like
> > whether it's still as effective as intended with such a small scheduling
> > delay, or whether it still might be worth simplifying in various ways
> > (i.e., does the scheduling delay actually make a difference? do we still
> > need a per cpu granular throttle? etc.).
> 
> It can still be useful for certain g*dawful scenarios --
> 
> Let's say you have a horribly misconfigured cloudy system with a tiny
> log, hundreds of CPUs, a memory hogging process, another process with
> many hundreds of threads that are performing small appending synchronous
> writes to a large number of files, and some other process repeatedly
> opens and closes files.  Background writeback completion will create
> enough workers to tie up the log such that writeback and inodegc contend
> for log grant space and make slow progress.  If memory is also tight,
> we want to slow down the file scanning process so that it doesn't shove
> /more/ inodes into the cache and push the system towards OOM behavior.
> 

Yeah, I get the general idea/purpose of the throttling. What I'm probing
at here is whether a case like this is still handled effectively with
such a short scheduling delay. Presumably there is some window before
list size based throttling triggers for which the shrinker is expected
to cover, so that implies the shrinker historically is able to detect
and push populated queues and trigger throttling from the point it is
invoked (whether directly via repeated shrinker invocations or
indirectly via causing larger queue sizes is not clear to me).

The thing that stands out to me as a question wrt to this change is that
the trigger for shrinker induced throttling is the list size at the time
of the callback(s), and that goes from having a lifecycle associated
with the size-oriented scheduling algorithm to a time-based scheduling
lifecycle of one jiffy (also noting that the inodegc worker resets
shrinker_hits before it begins to process inodes). So with that in mind,
how reliable is this lowmem signal based on the list size back to the
tasks creating more work and memory pressure? Once a shrinker invocation
occurs, what are the odds that the callback is able to detect a
populated list and act accordingly?

These questions are somewhat rhetorical because this all seems rather
unpredictable when we consider varying resource availability. The
relevant question for this patch is probably just that somebody has
tested and confirmed that the shrinker hasn't been subtly or indirectly
broken in cases like the one you describe above (where perhaps we might
not have many shrinker callback opportunities to act on before OOM).

> Back in the old days when inodegc was a radix tree tag it was fairly
> easy to get OOMs when the delay interval was long (5 seconds).  The
> OOM probability went down pretty sharply as the interval approached
> zero, but even at 1 jiffy I could still occasionally trip it, whereas
> the pre-deferred-inactivation kernels would never OOM.
> 
> I haven't tested it all that rigorously with Dave's fancy new per-cpu
> list design, but I did throw on my silly test setup (see below) and
> still got it to OOM once in 3 runs with the shrinker bits turned off.
> 

Ok.. so that implies we still need throttling, but I'm not sure what
"fancy percpu list design" refers to. If you have a good test case, I
think the interesting immediate question is: are those OOMs avoided with
this patch but the shrinker infrastructure still in place?

If not, then I wonder if something is going wonky there. If so, I'm
still a bit curious what the behavior looks like and whether it can be
simplified in light of this change, but that's certainly beyond the
scope of this patch.

> > > > > If
> > > > > so, it looks like decent enough overhead to cycle through every cpu in
> > > > > both callbacks that it might be worth spelling out more clearly in the
> > > > > top-level comment.
> > > > 
> > > > I'm not sure what you are asking here - mod_delayed_work_on() has
> > > > pretty much the same overhead and behaviour as queue_work() in this
> > > > case, so... ?
> > > 
> > 
> > I'm just pointing out that the comment around the shrinker
> > infrastructure isn't very informative if the shrinker turns out to still
> > be necessary for reasons other than making the workers run sooner.
> 
> <nod> That comment /does/ need to be updated to note the subtlety that a
> lot of shrinker activity can slow down close()ing a file by making user
> tasks wait for the inodegc workers to clear the backlog.
> 
> > > <shrug> Looks ok to me, since djwong-dev has had some variant of timer
> > > delayed inactivation in it longer than it hasn't:
> > > 
> > 
> > Was that with a correspondingly small delay or something larger (on the
> > order of seconds or so)? Either way, it sounds like you have a
> > predictable enough workload that can actually test this continues to
> > work as expected..?
> 
> Yeah.  I snapshot /home (which has ~20 million inodes) then race
> fsstress and xfs_scrub -n in a VM with 560MB of RAM.
> 

Yeah small delay or yeah large delay?

Brian

> --D
> 
> > Brian
> > 
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > --D
> > > 
> > > > Cheers,
> > > > 
> > > > Dave.
> > > > -- 
> > > > Dave Chinner
> > > > david@fromorbit.com
> > > 
> > 
> 

