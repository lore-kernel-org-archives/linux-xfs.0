Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8040C34031
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 03:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9711E22B48
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 03:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgBSDAo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 22:00:44 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54340 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728196AbgBSDAo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 22:00:44 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6F5AA7E8B37;
        Wed, 19 Feb 2020 14:00:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j4FbM-0005Kk-8U; Wed, 19 Feb 2020 14:00:40 +1100
Date:   Wed, 19 Feb 2020 14:00:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix iclog release error check race with shutdown
Message-ID: <20200219030040.GZ10776@dread.disaster.area>
References: <20200218175425.20598-1-bfoster@redhat.com>
 <20200218215243.GS10776@dread.disaster.area>
 <20200218223644.GA24053@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218223644.GA24053@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=0MX-4UR2jTMkjeph5_QA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 02:36:44PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 19, 2020 at 08:52:43AM +1100, Dave Chinner wrote:
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
> 
> Indeed, the xfs_force_shutdown is a no-op both for the old and this
> new check.
> 
> Now the real question, which is a bit out of scope for this patch is
> why we even have XLOG_STATE_IOERROR?

I _think_ it was originally intended to prevent log shutdown
recursion when shutdowns trigger log IO errors and try to shut down
again.

> Wouldn't it make more sense
> to just user the shutdown flag in the mount structure and avoid the
> extra state complexity and thus clean up this whole mess?

I'd suggest that XLOG_FORCED_SHUTDOWN() is more appropriate in code
that has no reason to know anything about the xfs_mount state e.g.
the code in xlog_state_release_iclog() has a log and iclog context
and introducing a xfs-mount context to check for shutdown is a
fairly significant layering violation deep inside the internal log
implementation...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
