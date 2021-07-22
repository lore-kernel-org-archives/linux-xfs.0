Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51230C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 21:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 304BB60C41
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 21:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhGVVFH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 17:05:07 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:54463 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231336AbhGVVFH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 17:05:07 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 5CE5A108F41;
        Fri, 23 Jul 2021 07:45:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m6gVf-009czZ-Tx; Fri, 23 Jul 2021 07:45:39 +1000
Date:   Fri, 23 Jul 2021 07:45:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: external logs need to flush data device
Message-ID: <20210722214539.GP664593@dread.disaster.area>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-3-david@fromorbit.com>
 <20210722181445.GA559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722181445.GA559212@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=B4PrYx6SqdRHEH2S9rYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 11:14:45AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 22, 2021 at 11:53:32AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The recent journal flush/FUA changes replaced the flushing of the
> > data device on every iclog write with an up-front async data device
> > cache flush. Unfortunately, the assumption of which this was based
> > on has been proven incorrect by the flush vs log tail update
> > ordering issue. As the fix for that issue uses the
> > XLOG_ICL_NEED_FLUSH flag to indicate that data device needs a cache
> > flush, we now need to (once again) ensure that an iclog write to
> > external logs that need a cache flush to be issued actually issue a
> > cache flush to the data device as well as the log device.
> > 
> > Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 19 +++++++++++--------
> >  1 file changed, 11 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 96434cc4df6e..a3c4d48195d9 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -827,13 +827,6 @@ xlog_write_unmount_record(
> >  	/* account for space used by record data */
> >  	ticket->t_curr_res -= sizeof(ulf);
> >  
> > -	/*
> > -	 * For external log devices, we need to flush the data device cache
> > -	 * first to ensure all metadata writeback is on stable storage before we
> > -	 * stamp the tail LSN into the unmount record.
> > -	 */
> > -	if (log->l_targ != log->l_mp->m_ddev_targp)
> > -		blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
> >  	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
> >  }
> >  
> > @@ -1796,10 +1789,20 @@ xlog_write_iclog(
> >  	 * metadata writeback and causing priority inversions.
> >  	 */
> >  	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_IDLE;
> > -	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH)
> > +	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
> >  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> > +		/*
> > +		 * For external log devices, we also need to flush the data
> > +		 * device cache first to ensure all metadata writeback covered
> > +		 * by the LSN in this iclog is on stable storage. This is slow,
> > +		 * but it *must* complete before we issue the external log IO.
> 
> I'm a little confused about what's going on here.  We're about to write
> a log record to disk, with h_tail_lsn reflecting the tail of the log and
> h_lsn reflecting the current head of the log (i.e. this record).
> 
> If the log tail has moved forward since the last log record was written
> and this fs has an external log, we need to flush the data device
> because the AIL could have written logged items back into the filesystem
> and we need to ensure those items have been persisted before we write to
> the log the fact that the tail moved forward.  The AIL itself doesn't
> issue cache flushes (nor does it need to), so that's why we do that
> here.
> 
> Why don't we need a flush like this if only FUA is set?  Is it not
> possible to write a checkpoint that fits within a single iclog after the
> log tail has moved forward?

Yes, it is, and that is the race condition is exactly what the next
patch in the series addresses. If the log tail moves after the data
device cache flush was issued before we started writing the
checkpoint to the iclogs, then we detect that when releasing the
commit iclog and set the XLOG_ICL_NEED_FLUSH flag on it. That will
then trigger this code to issue a data device cache flush....

IOWs, for external logs, the XLOG_ICL_NEED_FLUSH flag indicates that
both the data device and the log device need a cache flush, rather
than just the log device. I think it could be split into two flags,
but then my head explodes thinking about log forces and trying to
determine what type of flush is implied (and what flags we'd need to
set) when we return log_flushed = true....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
