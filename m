Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE48EC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 22:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A194B60F6E
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 22:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhG0WNm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 18:13:42 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:38973 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231989AbhG0WNm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 18:13:42 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 6FFBD80BAEE;
        Wed, 28 Jul 2021 08:13:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8VKU-00BWu7-Kv; Wed, 28 Jul 2021 08:13:38 +1000
Date:   Wed, 28 Jul 2021 08:13:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: limit iclog tail updates
Message-ID: <20210727221338.GV664593@dread.disaster.area>
References: <20210727071012.3358033-1-david@fromorbit.com>
 <20210727071012.3358033-12-david@fromorbit.com>
 <20210727212531.GJ559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727212531.GJ559212@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=_N6w9kZlGIghYNu7SesA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 02:25:31PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 27, 2021 at 05:10:12PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > From the department of "generic/482 keeps giving", we bring you
> > another tail update race condition:
> > 
> > iclog:
> > 	S1			C1
> > 	+-----------------------+-----------------------+
> > 				 S2			EOIC
> > 
> > Two checkpoints in a single iclog. One is complete, the other just
> > contains the start record and overruns into a new iclog.
> > 
> > Timeline:
> > 
> > Before S1:	Cache flush, log tail = X
> > At S1:		Metadata stable, write start record and checkpoint
> > At C1:		Write commit record, set NEED_FUA
> > 		Single iclog checkpoint, so no need for NEED_FLUSH
> > 		Log tail still = X, so no need for NEED_FLUSH
> > 
> > After C1,
> > Before S2:	Cache flush, log tail = X
> > At S2:		Metadata stable, write start record and checkpoint
> > After S2:	Log tail moves to X+1
> > At EOIC:	End of iclog, more journal data to write
> > 		Releases iclog
> > 		Not a commit iclog, so no need for NEED_FLUSH
> > 		Writes log tail X+1 into iclog.
> > 
> > At this point, the iclog has tail X+1 and NEED_FUA set. There has
> > been no cache flush for the metadata between X and X+1, and the
> > iclog writes the new tail permanently to the log. THis is sufficient
> > to violate on disk metadata/journal ordering.
> > 
> > We have two options here. The first is to detect this case in some
> > manner and ensure that the partial checkpoint write sets NEED_FLUSH
> > when the iclog is already marked NEED_FUA and the log tail changes.
> > This seems somewhat fragile and quite complex to get right, and it
> > doesn't actually make it obvious what underlying problem it is
> > actually addressing from reading the code.
> > 
> > The second option seems much cleaner to me, because it is derived
> > directly from the requirements of the C1 commit record in the iclog.
> > That is, when we write this commit record to the iclog, we've
> > guaranteed that the metadata/data ordering is correct for tail
> > update purposes. Hence if we only write the log tail into the iclog
> > for the *first* commit record rather than the log tail at the last
> > release, we guarantee that the log tail does not move past where the
> > the first commit record in the log expects it to be.
> > 
> > IOWs, taking the first option means that replay of C1 becomes
> > dependent on future operations doing the right thing, not just the
> > C1 checkpoint itself doing the right thing. This makes log recovery
> > almost impossible to reason about because now we have to take into
> > account what might or might not have happened in the future when
> > looking at checkpoints in the log rather than just having to
> > reconstruct the past...
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 37 +++++++++++++++++++++++++++++++------
> >  1 file changed, 31 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 1c328efdca66..1b20fb479ebc 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -489,12 +489,31 @@ xfs_log_reserve(
> >  
> >  /*
> >   * Flush iclog to disk if this is the last reference to the given iclog and the
> > - * it is in the WANT_SYNC state.  If the caller passes in a non-zero
> > - * @old_tail_lsn and the current log tail does not match, there may be metadata
> > - * on disk that must be persisted before this iclog is written.  To satisfy that
> > - * requirement, set the XLOG_ICL_NEED_FLUSH flag as a condition for writing this
> > - * iclog with the new log tail value.
> > + * it is in the WANT_SYNC state.
> > + *
> > + * If the caller passes in a non-zero @old_tail_lsn and the current log tail
> > + * does not match, there may be metadata on disk that must be persisted before
> > + * this iclog is written.  To satisfy that requirement, set the
> > + * XLOG_ICL_NEED_FLUSH flag as a condition for writing this iclog with the new
> > + * log tail value.
> > + *
> > + * If XLOG_ICL_NEED_FUA is already set on the iclog, we need to ensure that the
> > + * log tail is updated correctly. NEED_FUA indicates that the iclog will be
> > + * written to stable storage, and implies that a commit record is contained
> > + * within the iclog. We need to ensure that the log tail does not move beyond
> > + * the tail that the first commit record in the iclog ordered against, otherwise
> > + * correct recovery of that checkpoint becomes dependent on future operations
> > + * performed on this iclog.
> > + *
> > + * Hence if NEED_FUA is set and the current iclog tail lsn is empty, write the
> > + * current tail into iclog. Once the iclog tail is set, future operations must
> > + * not modify it, otherwise they potentially violate ordering constraints for
> > + * the checkpoint commit that wrote the initial tail lsn value. The tail lsn in
> > + * the iclog will get zeroed on activation of the iclog after sync, so we
> > + * always capture the tail lsn on the iclog on the first NEED_FUA release
> > + * regardless of the number of active reference counts on this iclog.
> >   */
> > +
> >  int
> >  xlog_state_release_iclog(
> >  	struct xlog		*log,
> > @@ -519,6 +538,10 @@ xlog_state_release_iclog(
> >  
> >  		if (old_tail_lsn && tail_lsn != old_tail_lsn)
> >  			iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
> > +
> > +		if ((iclog->ic_flags & XLOG_ICL_NEED_FUA) &&
> > +		    !iclog->ic_header.h_tail_lsn)
> > +			iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> >  	}
> >  
> >  	if (!atomic_dec_and_test(&iclog->ic_refcnt))
> > @@ -530,7 +553,8 @@ xlog_state_release_iclog(
> >  	}
> >  
> >  	iclog->ic_state = XLOG_STATE_SYNCING;
> > -	iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> > +	if (!iclog->ic_header.h_tail_lsn)
> > +		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> >  	xlog_verify_tail_lsn(log, iclog, tail_lsn);
> 
> What is xlog_verify_tail_lsn protecting against?  I /think/ it is a
> debug check that makes sure that there's enough space between the head
> and the tail (i.e. the space that hasn't been written to yet) to write
> the iclog that we're releasing, right?

Yeah, I thinks so - it is a physical space check to see if the current iclog
will fit between the tail and the location that the log thinks the
iclog is going to be located at.

That said, prev_block/cycle is the location that the last iclog that
was switched into WANT_SYNC state starts at. It's not necessarily
the location this iclog starts at because xlog_state_switch_iclog()
isn't always called from the same lock context that releases the
iclog (e.g. log force). Hence I think this debug check is racy and
potentially wrong.

It seems kinda stupid, really, because the iclog has it's physical
location in the header, too. It doesn't need the prev block/cycle to
be able to check this.

I note that l_prev_cycle is only used for xlog_verify_tail_lsn(),
but l_prev_block is also written into the iclog header in
xlog_state_switch_iclog(). It's not used at all by log recovery and
only for information prints in userspace, and I really can't see how
it is useful in any way for recovery. So this all really looks like
code that can be simplified by removing it and fixing
xlog_verify_tail_lsn() just to look at internal iclog state.

So I'd suggest there are substantial cleanups around this debug
operation which would also remove unnecessary runtime overhead.

> I think that means that we're indirectly checking that if this iclog is
> persisted then recovery will be able to find complete log records
> between h_tail_lsn and h_lsn for replay, right?
> 
> Before this patch we'd write out this iclog with h_tail_lsn set to
> wherever the log tail is /now/, but now we write out the iclog with
> h_tail_lsn set to wherever the tail was when the first commit record was
> added to this iclog.  That implies that recovery will now have to do
> more work, but at least the flushes will be in order, right?
> 
> So then, the question is this: should this call be:
> 
> 	xlog_verify_tail_lsn(log, iclog,
> 			be64_to_cpu(iclog->ic_header.h_tail_lsn));
> 
> since we need to guarantee that recovery will be able to start reading
> in log records starting at h_tail_lsn?

Probably should be. I'll update the patch and sen dout a new version
once I've let the smoke out a couple of times.

Thanks, Darrick!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
