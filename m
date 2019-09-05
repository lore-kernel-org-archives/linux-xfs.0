Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C49C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47536206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfIEWCc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:02:32 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:51777 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbfIEWCc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:02:32 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 37C9B362A69;
        Fri,  6 Sep 2019 08:02:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5zpj-0002gB-5u; Fri, 06 Sep 2019 08:02:27 +1000
Date:   Fri, 6 Sep 2019 08:02:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: push the AIL in xlog_grant_head_wake
Message-ID: <20190905220227.GF1119@dread.disaster.area>
References: <20190905084717.30308-1-david@fromorbit.com>
 <20190905084717.30308-2-david@fromorbit.com>
 <20190905151828.GB2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905151828.GB2229799@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=jsumu6f6cOcLEIrt22UA:9
        a=vp9kFnaW6L_ijzrO:21 a=aQQdaBWmy3sqUWLn:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:18:28AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 05, 2019 at 06:47:10PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > In the situation where the log is full and the CIL has not recently
> > flushed, the AIL push threshold is throttled back to the where the
> > last write of the head of the log was completed. This is stored in
> > log->l_last_sync_lsn. Hence if the CIL holds > 25% of the log space
> > pinned by flushes and/or aggregation in progress, we can get the
> > situation where the head of the log lags a long way behind the
> > reservation grant head.
> > 
> > When this happens, the AIL push target is trimmed back from where
> > the reservation grant head wants to push the log tail to, back to
> > where the head of the log currently is. This means the push target
> > doesn't reach far enough into the log to actually move the tail
> > before the transaction reservation goes to sleep.
> > 
> > When the CIL push completes, it moves the log head forward such that
> > the AIL push target can now be moved, but that has no mechanism for
> > puhsing the log tail. Further, if the next tail movement of the log
> > is not large enough wake the waiter (i.e. still not enough space for
> > it to have a reservation granted), we don't wake anything up, and
> > hence we do not update the AIL push target to take into account the
> > head of the log moving and allowing the push target to be moved
> > forwards.
> > 
> > To avoid this particular condition, if we fail to wake the first
> > waiter on the grant head because we don't have enough space,
> > push on the AIL again. This will pick up any movement of the log
> > head and allow the push target to move forward due to completion of
> > CIL pushing.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index b159a9e9fef0..5e21450fb8f5 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -214,15 +214,36 @@ xlog_grant_head_wake(
> >  {
> >  	struct xlog_ticket	*tic;
> >  	int			need_bytes;
> > +	bool			woken_task = false;
> >  
> >  	list_for_each_entry(tic, &head->waiters, t_queue) {
> > +		/*
> > +		 * The is a chance that the size of the CIL checkpoints in
> > +		 * progress result at the last AIL push resulted in the log head
> > +		 * (l_last_sync_lsn) not reflecting where the log head now is.
> 
> That's a bit difficult to understand...

Yup I failed to edit it properly and left an extra "result" in the
sentence...

> "There is a chance that the size of the CIL checkpoints in progress at
> the last AIL push results in the last committed log head (l_last_sync_lsn)
> not reflecting where the log head is now." ?
> 
> (Did I get that right?)

*nod*.

> > +		 * Hence when we are woken here, it may be the head of the log
> > +		 * that has moved rather than the tail. In that case, the tail
> > +		 * didn't move and there won't be space available until the AIL
> > +		 * push target is updated and the tail pushed again. If the AIL
> > +		 * is already pushed to it's target, we will hang here until
> 
> Nit: "its", not "it is".
> 
> Other than that I think I can tell what this is doing now. :)

In reading this again, it is all a bit clunky. I've revised it a bit
more to more concisely describe the situation:

	/*
	 * The is a chance that the size of the CIL checkpoints in
	 * progress at the last AIL push target calculation resulted in
	 * limiting the target to the log head (l_last_sync_lsn) at the
	 * time. This may not reflect where the log head is now as the
	 * CIL checkpoints may have completed.
	 *
	 * Hence when we are woken here, it may be that the head of the
	 * log that has moved rather than the tail. As the tail didn't
	 * move, there still won't be space available for the
	 * reservation we require.  However, if the AIL has already
	 * pushed to the target defined by the old log head location, we
	 * will hang here waiting for something else to update the AIL
	 * push target.
	 *
	 * Therefore, if there isn't space to wake the first waiter on
	 * the grant head, we need to push the AIL again to ensure the
	 * target reflects both the current log tail and log head
	 * position before we wait for the tail to move again.
	 */

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
