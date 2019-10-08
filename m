Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA303C4360C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 17:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 932632070B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 17:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfJHRej (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 13:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfJHRej (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Oct 2019 13:34:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5EC21C057F88;
        Tue,  8 Oct 2019 17:34:38 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E954360606;
        Tue,  8 Oct 2019 17:34:37 +0000 (UTC)
Date:   Tue, 8 Oct 2019 13:34:36 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Throttle commits on delayed background CIL push
Message-ID: <20191008173436.GB3520@bfoster>
References: <20191001034207.GS16973@dread.disaster.area>
 <20191001131336.GB62428@bfoster>
 <20191001231433.GU16973@dread.disaster.area>
 <20191002124139.GB2403@bfoster>
 <20191003012556.GW16973@dread.disaster.area>
 <20191003144114.GB2105@bfoster>
 <20191004022755.GY16973@dread.disaster.area>
 <20191004115001.GA6706@bfoster>
 <20191008025157.GE16973@dread.disaster.area>
 <20191008132240.GA3520@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008132240.GA3520@bfoster>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 08 Oct 2019 17:34:38 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 08, 2019 at 09:22:40AM -0400, Brian Foster wrote:
> On Tue, Oct 08, 2019 at 01:51:57PM +1100, Dave Chinner wrote:
> > On Fri, Oct 04, 2019 at 07:50:01AM -0400, Brian Foster wrote:
> > > On Fri, Oct 04, 2019 at 12:27:55PM +1000, Dave Chinner wrote:
> > > > On Thu, Oct 03, 2019 at 10:41:14AM -0400, Brian Foster wrote:
> > > > > Hmm, I'm also not sure the lockless reservation algorithm is totally
> > > > > immune to increased concurrency in this regard. What prevents multiple
> > > > > tasks from racing through xlog_grant_head_check() and blowing past the
> > > > > log head, for example?
> > > > 
> > > > Nothing. Debug kernels even emit a "xlog_verify_grant_tail: space >
> > > > BBTOB(tail_blocks)" messages when that happens. It's pretty
> > > > difficult to do this in real world conditions, even when there is
> > > > lots of concurrency being used.
> > > > 
> > > 
> > > Hm, Ok. Though I've seen that alert enough times that I
> > > (unintentionally) ignore it at this point, so it can't be that hard to
> > > reproduce. ;) That is usually during fstests however, and not a typical
> > > workload that I recall.
> > 
> > I can't say I've seen it for a long time now - I want to say "years"
> > but I may well have simply missed it on the rare occasion it has
> > occurred and fstests hasn't captured it. i.e. fstests is supposed to
> > capture unusual things like this appearing in dmesg during a
> > test....
> > 
> > > Of course, there's a difference between
> > > reproducing the basic condition and taking it to the point where it
> > > manifests into a problem.
> > 
> > *nod*
> > 
> > > > But here's the rub: it's not actually the end of the world because
> > > > the reservation doesn't actually determine how much of the log is
> > > > currently being used by running transactions - the reservation is
> > > > for a maximal rolling iteration of a permanent transaction, not the
> > > > initial transaction will be running. Hence if we overrun
> > > > occassionally we don't immediately run out of log space and corrupt
> > > > the log.
> > > > 
> > > 
> > > Ok, that much is evident from the amount of time this mechanism has been
> > > in place without any notable issues.
> > > 
> > > > Yes, if none of the rolling transactions complete and they all need
> > > > to use their entire reservation, and the tail of the log cannot be
> > > > moved forward because it is pinned by one of the transactions that
> > > > is running, then we'll likely get a log hang on a regrant on the
> > > > write head. But if any of the transactions don't use all of their
> > > > reservation, then the overrun gets soaked up by the unused parts of
> > > > the transactions that are completed and returned to reservation
> > > > head, and nobody even notices taht there was a temporary overrun of
> > > > the grant head space.
> > > > 
> > > 
> > > Ok, I didn't expect this to be some catastrophic problem or really a
> > > problem with your patch simply based on the lifetime of the code and how
> > > the grant heads are actually used. I was going to suggest an assert or
> > > something to detect whether batching behavior as a side effect of the
> > > commit throttle would ever increase likelihood of this situation, but it
> > > looks like the grant verify function somewhat serves that purpose
> > > already.
> > 
> > Yeah - xlog_verify_grant_tail() will the report reservation
> > overruns, but the serious log space problems (i.e. head overwritting
> > the tail) are detected by xlog_verify_tail_lsn() when we stamp the
> > tail_lsn into the current iclog header. That's still done under the
> > icloglock and the AIL lock, so the comparison of the tail with the
> > current log head is still completely serialised.
> > 
> > > I'd _prefer_ to see something, at least in DEBUG mode, that indicates
> > > the frequency of the fundamental incorrect accounting condition as
> > > opposed to just the side effect of blowing the tail (because the latter
> > > depends on other difficult to reproduce factors), but I'd have to think
> > > about that some more as it would need to balance against normal/expected
> > > execution flow. Thanks for the background.
> > 
> > You can test that just by removing the XLOG_TAIL_WARN flag setting,
> > then it will warn on every reservation overrun rather than just the
> > first.
> > 
> 
> That's not quite what I'm after. That just removes the oneshot nature of
> the existing check. The current debug check looks for a side effect of
> the current algorithm in the form of overrunning the tail. What I would
> like to see, somehow or another, is something that provides earlier and
> more useful information on the frequency/scale of occurrence where
> multiple reservations have been made based on the same grant baseline.
> 
> This is not so much an error check so not something that should be an
> assert or warning, but rather more of a metric that provides a base for
> comparison whenever we might have code changes or workloads that
> potentially change this behavior. For example, consider a debug mode
> stat or sysfs file that could be used to dump out a counter of "same
> value" grant head samples after a benchmark workload or fstests run. The
> fact that this value might go up or down is not necessarily a problem.
> But that would provide some debug mode data to identify and analyze
> potentially unintended side effects like transient spikes in concurrent
> grant head checks due to blocking/scheduling changes in log reservation
> tasks.
> 
> See the appended RFC for a quick idea of what I mean. This is slightly
> racy, but I think conservative enough to provide valid values with
> respect to already racy reservation implementation. On my slow 4xcpu vm,
> I see occasional sample counts of 2 running a -p8 fsstress. If I stick a
> smallish delay in xfs_log_reserve(), the frequency of the output
> increases and I see occasional bumps to 3, a spike of 8 in one case,
> etc. Of course I'd probably factor the atomic calls into DEBUG only
> inline functions that can be compiled out on production kernels and
> replace the tracepoint with a global counter (exported via stats or
> sysfs knob), but this just illustrates the idea. The global counter
> could also be replaced with (or kept in addition to) something that
> tracks a max concurrency value if that is more useful. Any thoughts on
> something like this?
> 

BTW, this doesn't necessarily have to be a task based counter. Another
approach could be to keep a "lockless reservation slop" counter that is
incremented by the ticket reservation size down in
xlog_grant_head_check() (only in the lockless case) and
flagged/decremented once the reservation is added to the grant head.
Somewhere between the atomic add/sub we check the max slop value we've
encountered and either track it and dump it in a sysfs file and/or just
assert that it never reaches something unexpected/outrageous (based on
some % of the log size, for example).

Brian

> > > > Hence occasional overruns on the reservation head before they start
> > > > blocking isn't really a problem in practice because the probability
> > > > of all the transaction reservation of all transactions running being
> > > > required to make forwards progress is extremely small.
> > > > 
> > > > Basically, we gave up "perfect reservation space grant accounting"
> > > > because performance was extremely important and risk of log hangs as
> > > > a result of overruns was considered to be extremely low and worth
> > > > taking for the benefits the algorithm provided. This was just a
> > > > simple, pragmatic risk based engineering decision.
> > > > 
> > > 
> > > FWIW, the comment for xlog_verify_tail() also suggests the potential for
> > > false positives and references a panic tag, which all seems kind of
> > > erratic and misleading compared to what you explain here.
> > 
> > Well, it's fundamentally an unserialised check, so it can race with
> > other reservation grants, commits that release grant space and tail
> > lsn updates. Hence it's not a 100% reliable debug check.
> > 
> 
> Right. Yet there is a panic knob...
> 
> > It also used to be run at all times, not just under
> > XFS_CONFIG_DEBUG=y, which is why it has a panic tag associated with
> > it. When we first deployed it, we weren't 100% sure there weren't
> > customer workloads that would trip over this and hang the log, so
> > we gave ourselves a way of triggering kernel dumps the instant an
> > overrun was detected. Hence a site that had log hangs with this
> > message in the logs could turn on the panic tag and we'd get a
> > kernel dump to analyse...
> > 
> 
> Ok, makes sense. This kind of speaks to the earlier point around having
> more useful data. While this isn't necessarily a problem right now, we
> have no real data to tell us whether some particular code change alters
> this behavior. If this was enough of a concern when the change was first
> put in place to insert a panic hook, then it stands to reason it's
> something we should at least be cognizant of when making changes that
> could impact its behavior.
> 
> > Since then, this code has been relegated to debug code but the panic
> > tag still exists. It could be turned back into a ASSERT now, but
> > it's still useful the way it is as it means debug kernels don't fall
> > over the moment a spurious overrun occurs...
> > 
> 
> Yeah, ISTM the panic bit could be removed at this point. The warning (as
> opposed to an assert) is probably reasonable so long as the check itself
> is racy so as to not cause false positive panics with fatal asserts
> enabled.
> 
> Brian
> 
> --- 8< ---
> 
> RFC: crude concurrency stat on reserve grant head
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a2beee9f74da..1d3056176e6e 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -175,6 +175,7 @@ xlog_grant_head_init(
>  	xlog_assign_grant_head(&head->grant, 1, 0);
>  	INIT_LIST_HEAD(&head->waiters);
>  	spin_lock_init(&head->lock);
> +	atomic64_set(&head->sample_cnt, 0);
>  }
>  
>  STATIC void
> @@ -446,6 +447,7 @@ xfs_log_reserve(
>  	struct xlog_ticket	*tic;
>  	int			need_bytes;
>  	int			error = 0;
> +	int64_t			sample_cnt;
>  
>  	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
>  
> @@ -465,13 +467,19 @@ xfs_log_reserve(
>  
>  	error = xlog_grant_head_check(log, &log->l_reserve_head, tic,
>  				      &need_bytes);
> +	atomic64_inc(&log->l_reserve_head.sample_cnt);
>  	if (error)
>  		goto out_error;
>  
> +	sample_cnt = atomic64_xchg(&log->l_reserve_head.sample_cnt, 0);
>  	xlog_grant_add_space(log, &log->l_reserve_head.grant, need_bytes);
>  	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
>  	trace_xfs_log_reserve_exit(log, tic);
>  	xlog_verify_grant_tail(log);
> +
> +	if (sample_cnt > 1)
> +		trace_printk("%d: %lld\n", __LINE__, sample_cnt);
> +
>  	return 0;
>  
>  out_error:
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b880c23cb6e4..62e4949f91c4 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -339,6 +339,7 @@ struct xlog_grant_head {
>  	spinlock_t		lock ____cacheline_aligned_in_smp;
>  	struct list_head	waiters;
>  	atomic64_t		grant;
> +	atomic64_t		sample_cnt;
>  };
>  
>  /*
