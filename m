Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68AF7C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D992206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388916AbfIEWOF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:14:05 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34729 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732092AbfIEWOF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:14:05 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DB96143E93E;
        Fri,  6 Sep 2019 08:14:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i600w-0002hV-A3; Fri, 06 Sep 2019 08:14:02 +1000
Date:   Fri, 6 Sep 2019 08:14:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: factor debug code out of
 xlog_state_do_callback()
Message-ID: <20190905221402.GH1119@dread.disaster.area>
References: <20190905084717.30308-1-david@fromorbit.com>
 <20190905084717.30308-5-david@fromorbit.com>
 <20190905153006.GE2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905153006.GE2229799@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=daTqleTGaoIsKojjbx4A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:30:06AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 05, 2019 at 06:47:13PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Start making this function readable by lifting the debug code into
> > a conditional function.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 79 +++++++++++++++++++++++++++---------------------
> >  1 file changed, 44 insertions(+), 35 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 8380ed065608..2904bf0d17f3 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2628,6 +2628,48 @@ xlog_get_lowest_lsn(
> >  	return lowest_lsn;
> >  }
> >  
> > +#ifdef DEBUG
> > +/*
> > + * Make one last gasp attempt to see if iclogs are being left in limbo.  If the
> > + * above loop finds an iclog earlier than the current iclog and in one of the
> > + * syncing states, the current iclog is put into DO_CALLBACK and the callbacks
> > + * are deferred to the completion of the earlier iclog. Walk the iclogs in order
> > + * and make sure that no iclog is in DO_CALLBACK unless an earlier iclog is in
> > + * one of the syncing states.
> > + *
> > + * Note that SYNCING|IOERROR is a valid state so we cannot just check for
> > + * ic_state == SYNCING.
> > + */
> > +static void
> > +xlog_state_callback_check_state(
> > +	struct xlog		*log)
> > +{
> > +	struct xlog_in_core	*first_iclog = log->l_iclog;
> > +	struct xlog_in_core	*iclog = first_iclog;
> > +
> > +	do {
> > +		ASSERT(iclog->ic_state != XLOG_STATE_DO_CALLBACK);
> > +		/*
> > +		 * Terminate the loop if iclogs are found in states
> > +		 * which will cause other threads to clean up iclogs.
> > +		 *
> > +		 * SYNCING - i/o completion will go through logs
> > +		 * DONE_SYNC - interrupt thread should be waiting for
> > +		 *              l_icloglock
> > +		 * IOERROR - give up hope all ye who enter here
> > +		 */
> > +		if (iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> > +		    iclog->ic_state & XLOG_STATE_SYNCING ||
> 
> Code like this make my eyes twitch (Does ic_state track mutually
> exclusive state?  Or is it state flags?  I think it's the second!),
> but as this is simply refactoring debugging code...

Yup, it's just another of those little things about this code that
makes eyes cross and heads explode.  Fixing this is what Christoph
and I were talking about in the past version of this series -
pulling the ioerror state out of the iclog state machine state
flags...

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
