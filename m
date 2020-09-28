Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0AEC4346E
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 01:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1A0522207
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 01:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgI1BAz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Sep 2020 21:00:55 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:43964 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726328AbgI1BAz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Sep 2020 21:00:55 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B4AFF3A8EFE;
        Mon, 28 Sep 2020 11:00:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kMhX8-00046R-PG; Mon, 28 Sep 2020 11:00:50 +1000
Date:   Mon, 28 Sep 2020 11:00:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: periodically relog deferred intent items
Message-ID: <20200928010050.GB14422@dread.disaster.area>
References: <160083917978.1401135.9502772939838940679.stgit@magnolia>
 <160083919968.1401135.1020138085396332868.stgit@magnolia>
 <20200927230823.GA14422@dread.disaster.area>
 <20200927233025.GA49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200927233025.GA49547@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=7-415B0cAAAA:8
        a=6KAZ8-jqxNW8Us3cnhEA:9 a=ydbhe3W64PlrQZi7:21 a=1InOH1LAZnnC56dc:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 27, 2020 at 04:30:25PM -0700, Darrick J. Wong wrote:
> On Mon, Sep 28, 2020 at 09:08:23AM +1000, Dave Chinner wrote:
> > On Tue, Sep 22, 2020 at 10:33:19PM -0700, Darrick J. Wong wrote:
> > > @@ -361,6 +362,52 @@ xfs_defer_cancel_list(
> > >  	}
> > >  }
> > >  
> > > +/*
> > > + * Prevent a log intent item from pinning the tail of the log by logging a
> > > + * done item to release the intent item; and then log a new intent item.
> > > + * The caller should provide a fresh transaction and roll it after we're done.
> > > + */
> > > +static int
> > > +xfs_defer_relog(
> > > +	struct xfs_trans		**tpp,
> > > +	struct list_head		*dfops)
> > > +{
> > > +	struct xfs_defer_pending	*dfp;
> > > +	xfs_lsn_t			threshold_lsn;
> > > +
> > > +	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> > > +
> > > +	/*
> > > +	 * Figure out where we need the tail to be in order to maintain the
> > > +	 * minimum required free space in the log.
> > > +	 */
> > > +	threshold_lsn = xlog_grant_push_threshold((*tpp)->t_mountp->m_log, 0);
> > > +	if (threshold_lsn == NULLCOMMITLSN)
> > > +		return 0;
> > 
> > This smells of premature optimisation.
> > 
> > When we are in a tail-pushing scenario (i.e. any sort of
> > sustained metadata workload) this will always return true, and so we
> > will relog every intent that isn't in the current checkpoint every
> > time this is called.  Under light load, we don't care if we add a
> > little bit of relogging overhead as the CIL slowly flushes/pushes -
> > it will have neglible impact on performance because there is little
> > load on the journal.
> > 
> > However, when we are under heavy load the code will now be reading
> > the grant head and log position accounting variables during every
> > commit, hence greatly increasing the number and temporal
> > distribution of accesses to the hotest cachelines in the log. We
> > currently never access these cache lines during commit unless the
> > unit reservation has run out and we have to regrant physical log
> > space for the transaction to continue (i.e. we are into slow path
> > commit code). IOWs, this is like causing far more than double the
> > number of accesses to the grant head, the log tail, the
> > last_sync_lsn, etc, all of which is unnecessary exactly when we care
> > about minimising contention on the log space accounting variables...
> > 
> > Given that it is a redundant check under heavy load journal load
> > when access to the log grant/head/tail are already contended,
> > I think we should just be checking the "in current checkpoint" logic
> > and not making it conditional on the log being near full.
> 
> <nod> FWIW I broke this patch up again into the first part that
> only does relogging if the checkpoints don't match, and a second part
> that does the LSN push target check to see if I could observe any
> difference.
> 
> Across a ~4h fstests run I noticed that there was about ~20% fewer
> relogs, but OTOH the total runtime didn't change noticeably.  I kind of
> wondered if the increased cacheline contention would at least slow down
> the frontend a bit to give the log a chance to push things out, but
> haven't had time to dig any further than "ran fstests, recorded runtimes
> and grep | wc -l'd the ftrace log".

fstests doesn't generate anywhere near the load necessary to measure
log space accounting cacheline contention. That's one of the things
I use fsmark workloads for.

One of the things that "20% reduction" tells me, though, is that 80%
of the time that relogging is happening with this patch we are in a
tail pushing situation. i.e. the log is more often full than it is
empty when we are relogging.

That tends to support my statements that this is optimising the
wrong case.

FWIW, it seems to me that we need real stats for the deferops (i.e.
exposed in /proc/fs/xfs/stat) so we can monitor in realtime the
breakdown of work that is being done. Being able to see things like
how many defer rolls a transaction takes under a given workload is
very interesting information, and would give us insight into things
like whether the log count for transaction reservations is
reasonable or not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
