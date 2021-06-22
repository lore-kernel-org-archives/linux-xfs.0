Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC72C2B9F4
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 22:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4E7261360
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 22:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhFVWpG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 18:45:06 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43804 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229800AbhFVWpG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jun 2021 18:45:06 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8314D862EED;
        Wed, 23 Jun 2021 08:42:48 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lvp6V-00FrcT-4x; Wed, 23 Jun 2021 08:42:47 +1000
Date:   Wed, 23 Jun 2021 08:42:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: don't nest icloglock inside ic_callback_lock
Message-ID: <20210622224247.GY664593@dread.disaster.area>
References: <20210622040604.1290539-1-david@fromorbit.com>
 <20210622040604.1290539-2-david@fromorbit.com>
 <YNHZ4Bsr27u53TxG@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNHZ4Bsr27u53TxG@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=HBr7i9jua8L27spiKpUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 22, 2021 at 08:38:56AM -0400, Brian Foster wrote:
> On Tue, Jun 22, 2021 at 02:06:01PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > It's completely unnecessary because callbacks are added to iclogs
> > without holding the icloglock, hence no amount of ordering between
> > the icloglock and ic_callback_lock will order the removal of
> > callbacks from the iclog.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 18 ++++--------------
> >  1 file changed, 4 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index e93cac6b5378..bb4390942275 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2773,11 +2773,8 @@ static void
> >  xlog_state_do_iclog_callbacks(
> >  	struct xlog		*log,
> >  	struct xlog_in_core	*iclog)
> > -		__releases(&log->l_icloglock)
> > -		__acquires(&log->l_icloglock)
> >  {
> >  	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
> > -	spin_unlock(&log->l_icloglock);
> >  	spin_lock(&iclog->ic_callback_lock);
> >  	while (!list_empty(&iclog->ic_callbacks)) {
> >  		LIST_HEAD(tmp);
> > @@ -2789,12 +2786,6 @@ xlog_state_do_iclog_callbacks(
> >  		spin_lock(&iclog->ic_callback_lock);
> >  	}
> >  
> > -	/*
> > -	 * Pick up the icloglock while still holding the callback lock so we
> > -	 * serialise against anyone trying to add more callbacks to this iclog
> > -	 * now we've finished processing.
> > -	 */
> 
> This makes sense wrt to the current locking, but I'd like to better
> understand what's being removed. When would we add callbacks to an iclog
> that's made it to this stage (i.e., already completed I/O)? Is this some
> historical case or attempt at defensive logic?

This was done in 2008. It's very likely that, at the time, nobody
(including me) understood the iclog state machine well enough to
determine if we could race with adding iclogs at this time. Maybe
they did race and this was a bandaid over, say, a shutdown race condition.
But, more likely, it was just defensive to try to prevent callbacks
from being added before the iclog was marked ACTIVE again...

Really, though, nobody is going to be able to tell you why the code
was written like this in the first place because even the author
doesn't remember...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
