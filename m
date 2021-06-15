Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4CEC48BDF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 22:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAE9561246
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 22:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhFOWtR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Jun 2021 18:49:17 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:50125 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229898AbhFOWtR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jun 2021 18:49:17 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 847CD1B1305;
        Wed, 16 Jun 2021 08:47:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ltHpt-00DCkX-KI; Wed, 16 Jun 2021 08:47:09 +1000
Date:   Wed, 16 Jun 2021 08:47:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: add iclog state trace events
Message-ID: <20210615224709.GX664593@dread.disaster.area>
References: <20210615064658.854029-1-david@fromorbit.com>
 <20210615064658.854029-2-david@fromorbit.com>
 <YMjJTQfDQ3muz2YQ@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMjJTQfDQ3muz2YQ@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=9jfbZ9TJUrPycBtPObcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 15, 2021 at 11:37:49AM -0400, Brian Foster wrote:
> On Tue, Jun 15, 2021 at 04:46:57PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > For the DEBUGS!
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c   | 18 ++++++++++++++++
> >  fs/xfs/xfs_trace.h | 52 ++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 70 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index e921b554b683..54fd6a695bb5 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -524,6 +524,7 @@ __xlog_state_release_iclog(
> >  		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> >  		xlog_verify_tail_lsn(log, iclog, tail_lsn);
> >  		/* cycle incremented when incrementing curr_block */
> > +		trace_xlog_iclog_syncing(iclog, _RET_IP_);
> >  		return true;
> >  	}
> >  
> > @@ -543,6 +544,7 @@ xlog_state_release_iclog(
> >  {
> >  	lockdep_assert_held(&log->l_icloglock);
> >  
> > +	trace_xlog_iclog_release(iclog, _RET_IP_);
> >  	if (iclog->ic_state == XLOG_STATE_IOERROR)
> >  		return -EIO;
> >  
> > @@ -804,6 +806,7 @@ xlog_wait_on_iclog(
> >  {
> >  	struct xlog		*log = iclog->ic_log;
> >  
> > +	trace_xlog_iclog_wait_on(iclog, _RET_IP_);
> 
> Seems like this might be more informative if we actually wait.

This tells us the state at the time the call is made, so we know
from that if we waited or not. Being able to see all calls to this
function was instrumental in understanding the stiuation where we
were waiting and when we weren't waiting. This is the iclog we got
stuck waiting on:

 xlog_iclog_wait_on:   dev 259:0 state 0x3 refcnt 0 offset 32256 lsn 0x2300004be0 caller xlog_cil_push_work

The state is XLOG_STATE_DONE_SYNC, indicating IO had been completed,
and the lsn tells me it is a future iclog we are waiting on, which
tells us that it's waiting for a previous iclog to complete IO
before it can move forward...

> >  	if (!XLOG_FORCED_SHUTDOWN(log) &&
> >  	    iclog->ic_state != XLOG_STATE_ACTIVE &&
> >  	    iclog->ic_state != XLOG_STATE_DIRTY) {
> > @@ -1804,6 +1807,7 @@ xlog_write_iclog(
> >  	unsigned int		count)
> >  {
> >  	ASSERT(bno < log->l_logBBsize);
> > +	trace_xlog_iclog_write(iclog, _RET_IP_);
> >  
> >  	/*
> >  	 * We lock the iclogbufs here so that we can serialise against I/O
> > @@ -1950,6 +1954,7 @@ xlog_sync(
> >  	unsigned int		size;
> >  
> >  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
> > +	trace_xlog_iclog_sync(iclog, _RET_IP_);
> >  
> >  	count = xlog_calc_iclog_size(log, iclog, &roundoff);
> >  
> > @@ -2488,6 +2493,7 @@ xlog_state_activate_iclog(
> >  	int			*iclogs_changed)
> >  {
> >  	ASSERT(list_empty_careful(&iclog->ic_callbacks));
> > +	trace_xlog_iclog_activate(iclog, _RET_IP_);
> >  
> 
> I wonder a bit whether these state change oriented tracepoints could be
> served by a single trace_ixlog_iclog_state() or some such, since the
> tracepoint already prints the state. That wouldn't show the before ->
> state in each tracepoint, but that should reflect in the full log.

I disagree. We lose a -lot- of context by getting rid of the
per-call site trace names, especially those that get called from
multiple places. Not to mention tracing an ACTIVE, idle iclog can
result in zero state information except for the tracepoint name...
e.g:

384.204393: xlog_iclog_write:     dev 259:0 state 0x2 refcnt 0 offset 32256 lsn 0x2300004b60 caller xlog_sync
384.204406: xlog_iclog_sync_done: dev 259:0 state 0x2 refcnt 0 offset 32256 lsn 0x2300004b60 caller xlog_ioend_work
384.204407: xlog_iclog_get_space: dev 259:0 state 0x0 refcnt 1 offset 0 lsn 0x0 caller xlog_write_get_more_iclog_space
384.204408: xlog_iclog_switch:    dev 259:0 state 0x0 refcnt 1 offset 0 lsn 0x2300004ba0 caller xlog_state_get_iclog_space
384.204418: xlog_iclog_release:   dev 259:0 state 0x1 refcnt 1 offset 32256 lsn 0x2300004ba0 caller xlog_write_get_more_iclog_space
384.204419: xlog_iclog_syncing:   dev 259:0 state 0x2 refcnt 0 offset 32256 lsn 0x2300004ba0 caller xlog_write_get_more_iclog_space
384.204419: xlog_iclog_sync:      dev 259:0 state 0x2 refcnt 0 offset 32256 lsn 0x2300004ba0 caller xlog_state_release_iclog
384.204422: xlog_iclog_write:     dev 259:0 state 0x2 refcnt 0 offset 32256 lsn 0x2300004ba0 caller xlog_sync
384.204435: xlog_iclog_sync_done: dev 259:0 state 0x2 refcnt 0 offset 32256 lsn 0x2300004ba0 caller xlog_ioend_work

See how the xlog_iclog_get_space trace has zero state/lsn? That
indicates that it has actually found an idle, active iclog in the
correct state for it to hand out. We can also see this progression
is through xlog_write() filling mulitple iclogs. However, we can get
different progressions from different contexts such as:

384.193766: xlog_iclog_get_space: dev 259:0 state 0x0 refcnt 1 offset 0 lsn 0x0 caller xlog_write_get_more_iclog_space
384.193778: xlog_iclog_release:   dev 259:0 state 0x0 refcnt 1 offset 27352 lsn 0x23000042b0 caller xlog_write
384.193779: xlog_iclog_get_space: dev 259:0 state 0x0 refcnt 1 offset 27352 lsn 0x23000042b0 caller xlog_write
384.193780: xlog_iclog_wait_on:   dev 259:0 state 0x0 refcnt 0 offset 0 lsn 0x0 caller xlog_cil_push_work
384.193781: xlog_iclog_release:   dev 259:0 state 0x0 refcnt 1 offset 27364 lsn 0x23000042b0 caller xlog_cil_push_work
384.201268: xlog_iclog_get_space: dev 259:0 state 0x0 refcnt 1 offset 27364 lsn 0x23000042b0 caller xlog_write

.... the competion of a checkpoint where xlog_write() releases the
iclog and it's not a full iclog. This is followed immediately by the
commit record write which gets iclog space from a different caller
location, passes it back to xlog_cil_push_work which then releases
it. ANd then we try to wait on the previous iclog which is an idle
ACTIVE buffer, so we skip the wait.  And because this isn't a
"stable CIL push", we don't see a xlog_iclog_switch() trace, and the
so iclog is not flushed to disk when it is release here.

IOWs, if we don't have the individual trace names, we largely lose
all this context and then have to infer it from caller and state
changes that occur. That just makes things unnnecessarily difficult
when looking for problems in hundreds of thousands trace events....

> > @@ -3138,6 +3153,8 @@ xfs_log_force(
> >  	if (iclog->ic_state == XLOG_STATE_IOERROR)
> >  		goto out_error;
> >  
> > +	trace_xlog_iclog_force(iclog, _RET_IP_);
> > +
> 
> We have a log force tracepoint a few lines up. Do we need both?

Yes. The log force tracepoint tells us nothing about the iclog
state we are about to operate on.

> > +	TP_ARGS(iclog, caller_ip),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(uint32_t, state)
> > +		__field(int32_t, refcount)
> > +		__field(uint32_t, offset)
> > +		__field(unsigned long long, lsn)
> > +		__field(unsigned long, caller_ip)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = iclog->ic_log->l_mp->m_super->s_dev;
> > +		__entry->state = iclog->ic_state;
> > +		__entry->refcount = atomic_read(&iclog->ic_refcnt);
> > +		__entry->offset = iclog->ic_offset;
> > +		__entry->lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> > +		__entry->caller_ip = caller_ip;
> > +	),
> > +	TP_printk("dev %d:%d state 0x%x refcnt %d offset %u lsn 0x%llx caller %pS",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->state,
> 
> It might be nice to see a string representation of the state like we do
> for other things like log item type, etc.

Yup, I thought about that after I sent when looking at other code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
