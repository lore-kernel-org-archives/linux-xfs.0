Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8406BC3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 23:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B12820856
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 23:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfH0XKi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 19:10:38 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35018 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726030AbfH0XKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 19:10:37 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A9AC6360DB1;
        Wed, 28 Aug 2019 09:10:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2kbf-0001MO-D9; Wed, 28 Aug 2019 09:10:31 +1000
Date:   Wed, 28 Aug 2019 09:10:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Rajendra <chandan@linux.ibm.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        hch@infradead.org
Subject: Re: [RFC] xfs: Flush iclog containing XLOG_COMMIT_TRANS before
 waiting for log space
Message-ID: <20190827231031.GI1119@dread.disaster.area>
References: <20190821110448.30161-1-chandanrlinux@gmail.com>
 <20190823130824.GC53137@bfoster>
 <10179524.EWMsHJnrze@localhost.localdomain>
 <3457989.EyS6152c1k@localhost.localdomain>
 <20190826003253.GK1119@dread.disaster.area>
 <20190826123934.GA4592@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826123934.GA4592@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=V1m7CzWJ8yojt6UpajoA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 08:39:34AM -0400, Brian Foster wrote:
> On Mon, Aug 26, 2019 at 10:32:53AM +1000, Dave Chinner wrote:
> > On Sun, Aug 25, 2019 at 08:35:17PM +0530, Chandan Rajendra wrote:
> > > > Btw, the issue is still re-creatable after adding,
> > > > 
> > > > +               if ((log->l_flags & XLOG_RECOVERY_NEEDED)
> > > > +                       && !xfs_ail_min(tp->t_mountp->m_ail))
> > > > +                       tp->t_flags |= XFS_TRANS_SYNC;
> > > > 
> > > > ... to xfs_trans_reserve(). I didn't get a chance to debug it yet. I will try
> > > > to find the root cause now.
> > > > 
> > > 
> > > Dave, With the above changes made in xfs_trans_reserve(), mount task is
> > > deadlocking due to the following,
> > > 1. With synchronous transactions, __xfs_trans_commit() now causes iclogs to be
> > > flushed to the disk and hence log items to be ultimately moved to AIL.
> > > 2. xfsaild task is woken up, which acts in items on AIL.
> > > 3. After some time, we stop issuing synchronous transactions because AIL has
> > >    log items in its list and hence !xfs_ail_min(tp->t_mountp->m_ail) evaluates to
> > >    false. In xfsaild_push(), "XFS_LSN_CMP(lip->li_lsn, target) <= 0"
> > >    evaluates to false on the first iteration of the while loop. This means we
> > >    have a log item whose LSN is larger than xfs_ail->ail_target at the
> > >    beginning of the AIL.
> > 
> > The push target for xlog_grant_push_ail() is to free 25% of the log
> > space. So if all the items in the AIL are not within 25% of the tail
> > end of the log, there's nothing for the AIL to push. This indicates
> > that there is at least 25% of physical log space free.
> > 
> > I suspect that this means the CIL is overruning it's background push
> > target by more than expected probably because the log is so small. That leads
> > to the outstanding CIL pending commit size (the current CIL context
> > and the previous CIL commit that is held off by the uncommited
> > iclog) is greater than the AIL push target, and so nothing will free
> > up more log space and wake up the transaction waiting for grant
> > space.
> > 
> > e.g. the previous CIL context commit might take 15% of the log
> > space, and the current CIL has reserved 11% of the log space.
> > Now new transactions reservations have run out of grant space and we
> > push on the ail, but it's lowest item is at 26%, and so the AIL push
> > does nothing and we're stuck because the CIL has pinned 26% of the
> > log space.
> > 
> 
> This is pretty much the behavior I described in my previous mail. For
> some unknown reason two background CIL pushes do not occur in enough
> time before we exhaust log reservation and so all of our log reservation
> ends up pinned by an iclog. I'd really like more data to explain what
> might be going on in this case to prevent the background CIL push from
> executing...

Oh, it doesn't take much when the log is small. In this case, it's
3600 blocks in size - ~14MB, so 1% of the log is 140kB and that's
smaller than a single itruncate transaction reservation. The CIL
push threshold is ~1.7MB, and the push threshold is ~3.5MB. IOWs,
we might not push the cil the first time until it reaches 1.8MB
because of the size of the last transaction that pushes it over.
Then it gets pushed, leaving the last iclog waiting and pinning
that part of the log.

AFAICT, it's largely caused by the fact that transaction
reservations require significant single digit percentages of the
total log space. i.e. we're fine at 23%, next reservation requires
3% of the total log space, and then we're in trouble.

> > However, what I didn't take into account is that the one going to
> > disk could stall indefinitely because we run out of log space before
> > the current CIL context is pushed and there's nothing to trigger the
> > CIL to be pushed to unwedge it.
> > 
> > There are a few solutions I can think of to this:
> > 
> > 	1 increase the xlog_grant_push_ail() push window to a larger
> > 	  amount of the log for small-to-medium logs. This doesn't
> > 	  work if the overrun is too large, but it should fix the
> > 	  "off-by-one" type of hang.
> > 
> 
> Rather than special case this to log sizes, I'm wondering if we can
> update this function to incorporate log pressure built up in the in-core
> log. The current code already stubs the calculated threshold_lsn to the
> last commit record that made it to the log, so if reservation is pinned
> in-core then just increasing the window may have no effect.

AFAICT, the problem is actually related to log sizes, so we have to
consider that as an aspect of the problem...

> What I'm wondering is that if the log reservation is primarily in-core,
> if this function could easily detect that scenario based on the
> difference between the reservation grant head and the head/tail of the
> physical log. I.e., rename this function to something like
> xlog_grant_push() and do just about all of the same calculations, but
> rather than skip out if the AIL threshold is too far beyond the on-disk
> head, use that to push on the log (not the CIL) before setting the AIL
> threshold.
> 
> I suppose we'd have to do a sync log push here in order to set a valid
> AIL push target, but we're down in the grant wait path anyways so I
> don't see the harm in waiting on a log I/O before waiting on a grant
> head. It does look like we'd need to fix up the locking a bit though.

The problem with dropping the AIL lock and issuing and waiting for
log IO in the grant head wait loop is that it subverts the FIFO
waiting nature of the log reservations. i.e. first into the wait
code is the first woken. If we put a blocking log force in here,
the transaction reseration that triggers it now has to wait for
that to complete before it goes onto the wait queue, and there might
be a bunch more transactions that get in before it.

That also brings up the problem of thundering herd log forces.
Every concurrent transaction reservation that sees this state will
issue a log force before it goes to sleep waiting for space to be
made available. And every time they are woken and there's no space
available, they'll issue a log force. This will substantially
perturb behaviour when we are running in constant tail-pushing
workloads (i.e. all the time on small logs). That's why I suggested
the XFS_TRANS_SYNC mechanism so it didn't perturb the non-blocking
nature of the AIL push....

> Otherwise I think this is quite similar to the aforementioned diff.
> Instead of checking for an empty AIL or special casing against log
> recovery context or small logs, we directly calculate if some portion of
> the log reservation requested by the caller is tied up in the in-core
> log and push on that before we push on the AIL to ultimately free up the
> space. Thoughts? An untested and very quickly hacked up diff is appended
> below just to illustrate the idea. FWIW, this is also effectively
> similar to something along the lines of allowing the excess target into
> the AIL and letting the AIL use that to initiate a log force...

The difference is moving it to the AIL doesn't perturb the
transaction reservation waiting behaviour at all, and it's largely
indepedent on the log size, transaction reservation sizes, etc.

Logic might be:

	if the push target is approximately where the log grant tail
			pushing threshold should be; and
	if the AIL is empty or all the items in the AIL are > grant
			push threshold; and
	if we've got nothing else to do and will go to sleep

		issue a log force

i.e. I don't think we need to put any new code into the log
reservation side of things - all the triggers we need to handle this
in the AIL are already there...

> @@ -1558,8 +1563,15 @@ xlog_grant_push_ail(
>  	 * so that it doesn't change between the compare and the set.
>  	 */
>  	last_sync_lsn = atomic64_read(&log->l_last_sync_lsn);
> -	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
> -		threshold_lsn = last_sync_lsn;
> +	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0) {
> +		int		flushed = 0;
> +		xfs_lsn_t	force_lsn;
> +
> +		force_lsn = xlog_assign_lsn(log->l_prev_cycle,
> +					    log->l_prev_block);
> +		__xfs_log_force_lsn(log->l_mp, force_lsn, XFS_LOG_SYNC,
> +				    &flushed, true);

__xfs_log_force_lsn() takes a CIL lsn, not a log LSN, so this
doesn't work the way you thought it does. i.e. __xfs_log_force_lsn()
pushes on the CIL first, then syncs the iclog buffers. Indeed, if
this was to be used, we wouldn't even need XFS_LOG_SYNC, because all
we need to do is start the IO on all the iclog buffers, and the log
forces do that. XFS_LOG_SYNC() only waits for them all to complete,
it doesn't change the way they are written.

Largest problme with this is that the CIL flush is a blocking
operation. Same as if we just replaced this with xfs_log_force(0)
to just push the CIL and the iclogs to disk...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
