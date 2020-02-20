Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4AD5C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 03:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6380208C4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 03:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbgBTDcY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 22:32:24 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54917 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727476AbgBTDcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 22:32:24 -0500
Received: from dread.disaster.area (pa49-195-185-106.pa.nsw.optusnet.com.au [49.195.185.106])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E7D00820879;
        Thu, 20 Feb 2020 14:32:18 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j4cZV-0005hM-9R; Thu, 20 Feb 2020 14:32:17 +1100
Date:   Thu, 20 Feb 2020 14:32:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix iclog release error check race with shutdown
Message-ID: <20200220033217.GN10776@dread.disaster.area>
References: <20200218175425.20598-1-bfoster@redhat.com>
 <20200218215243.GS10776@dread.disaster.area>
 <20200219131232.GA24157@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219131232.GA24157@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=bkRQb8bsQZKWSSj4M57YXw==:117 a=bkRQb8bsQZKWSSj4M57YXw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=YLTrRmUPn5wXjQ3j8bMA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 08:12:32AM -0500, Brian Foster wrote:
> On Wed, Feb 19, 2020 at 08:52:43AM +1100, Dave Chinner wrote:
> > On Tue, Feb 18, 2020 at 12:54:25PM -0500, Brian Foster wrote:
> > > Prior to commit df732b29c8 ("xfs: call xlog_state_release_iclog with
> > > l_icloglock held"), xlog_state_release_iclog() always performed a
> > > locked check of the iclog error state before proceeding into the
> > > sync state processing code. As of this commit, part of
> > > xlog_state_release_iclog() was open-coded into
> > > xfs_log_release_iclog() and as a result the locked error state check
> > > was lost.
> > > 
> > > The lockless check still exists, but this doesn't account for the
> > > possibility of a race with a shutdown being performed by another
> > > task causing the iclog state to change while the original task waits
> > > on ->l_icloglock. This has reproduced very rarely via generic/475
> > > and manifests as an assert failure in __xlog_state_release_iclog()
> > > due to an unexpected iclog state.
> > > 
> > > Restore the locked error state check in xlog_state_release_iclog()
> > > to ensure that an iclog state update via shutdown doesn't race with
> > > the iclog release state processing code.
> > > 
> > > Fixes: df732b29c807 ("xfs: call xlog_state_release_iclog with l_icloglock held")
> > > Reported-by: Zorro Lang <zlang@redhat.com>
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > v2:
> > > - Include Fixes tag.
> > > - Use common error path to include shutdown call.
> > > v1: https://lore.kernel.org/linux-xfs/20200214181528.24046-1-bfoster@redhat.com/
> > > 
> > >  fs/xfs/xfs_log.c | 13 +++++++++----
> > >  1 file changed, 9 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index f6006d94a581..796ff37d5bb5 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -605,18 +605,23 @@ xfs_log_release_iclog(
> > >  	struct xlog		*log = mp->m_log;
> > >  	bool			sync;
> > >  
> > > -	if (iclog->ic_state == XLOG_STATE_IOERROR) {
> > > -		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > > -		return -EIO;
> > > -	}
> > 
> > hmmmm.
> > 
> > xfs_force_shutdown() will does nothing if the iclog at the head of
> > the log->iclog list is marked with XLOG_STATE_IOERROR before IO is
> > submitted. In general, that is the case here as the head iclog is
> > what xlog_state_get_iclog_space() returns.
> > 
> > i.e. XLOG_STATE_IOERROR here implies the log has already been shut
> > down because the state is IOERROR rather than ACTIVE or WANT_SYNC as
> > was set when the iclog was obtained from
> > xlog_state_get_iclog_space().
> > 
> 
> I'm not sure that assumption is always true. If the iclog is (was)
> WANT_SYNC, for example, then it's already been switched out from the
> head of that list.

Yes, but if the iclog is in XLOG_STATE_IOERROR here, the only way
that state change can happen is if a shutdown has been completely
processed between getting the iclog from
xlog_state_get_iclog_space() and releasing it here. It can't come
from an actual IO error, because a iclog being written to can't be
under IO. Hence it doesn't matter if it was XLOG_STATE_ACTIVE at the
head of the log or XLOG_STATE_WANT_SYNC and ready for IO; that state
has been overwritten by the shutdown that has already been
completed....

> That might only happen if a checkpoint happens to
> align nicely with the end of an iclog, but that's certainly possible. We
> also need to consider that ->l_icloglock cycles here and thus somebody
> else could switch out the head iclog..

Yup, that can happen, but the only way that we can get to the
XLOG_STATE_IOERROR here is for a shutdown to have already processed
a shutdown.

> 
> > > +	if (iclog->ic_state == XLOG_STATE_IOERROR)
> > > +		goto error;
> > >  
> > >  	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> > > +		if (iclog->ic_state == XLOG_STATE_IOERROR) {
> > > +			spin_unlock(&log->l_icloglock);
> > > +			goto error;
> > > +		}
> > >  		sync = __xlog_state_release_iclog(log, iclog);
> > >  		spin_unlock(&log->l_icloglock);
> > >  		if (sync)
> > >  			xlog_sync(log, iclog);
> > >  	}
> > >  	return 0;
> > > +error:
> > > +	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > > +	return -EIO;
> > 
> > Hence I suspect that this should be ASSERT(XLOG_FORCED_SHUTDOWN(log))
> > just like is in xfs_log_force_umount() when this pre-existing log
> > IO error condition is tripped over...
> > 
> 
> I think this change is fundamentally correct based on the simple fact
> that we only ever set XLOG_STATE_IOERROR in the shutdown path. That
> said, the assert would be potentially racy against the shutdown path
> without any ordering guarantee that the release path might see the iclog
> state update prior to the log state update and lead to a potentially
> false negative assert failure. I suspect this is why the shutdown call
> might have been made from here in the first place (and partly why I
> didn't bother with it in the restored locked state check).

*nod*

And if we change this to XLOG_FORCED_SHUTDOWN() checks, then the
need for an assert check goes away, anyway...

> Given the context of this patch (fixing a regression) and the practical
> history of this code (and the annoying process of identifying and
> tracking down the source of these kind of shutdown buglets), I'm
> inclined to have this patch preserve the historical and relatively
> proven behavior as much as possible and consider further cleanups
> separately...

If that's the case, then I don't think the shutdown call should be
moved - the second XLOG_STATE_IOERROR occurs under the l_icloglock.
Given that XLOG_STATE_IOERROR can only be set while holding 
the l_icloglock during shutdown processing, it makes no sense to
recurse into shutdown here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
