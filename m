Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE7B3C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 23:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A841820714
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 23:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgCYXZG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 19:25:06 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33147 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727395AbgCYXZG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 19:25:06 -0400
Received: from dread.disaster.area (pa49-195-110-5.pa.nsw.optusnet.com.au [49.195.110.5])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0ED4F3A2C9C;
        Thu, 26 Mar 2020 10:25:02 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jHFOO-0005Ri-K8; Thu, 26 Mar 2020 10:25:00 +1100
Date:   Thu, 26 Mar 2020 10:25:00 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/8] xfs: don't try to write a start record into every
 iclog
Message-ID: <20200325232500.GK10776@dread.disaster.area>
References: <20200324174459.770999-1-hch@lst.de>
 <20200324174459.770999-2-hch@lst.de>
 <20200325123314.GC10922@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325123314.GC10922@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=UL8WcDbXXJQENuhYI/M0Yg==:117 a=UL8WcDbXXJQENuhYI/M0Yg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=NS49Kn1OSDdhHCRSESkA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 08:33:14AM -0400, Brian Foster wrote:
> On Tue, Mar 24, 2020 at 06:44:52PM +0100, Christoph Hellwig wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The xlog_write() function iterates over iclogs until it completes
> > writing all the log vectors passed in. The ticket tracks whether
> > a start record has been written or not, so only the first iclog gets
> > a start record. We only ever pass single use tickets to
> > xlog_write() so we only ever need to write a start record once per
> > xlog_write() call.
> > 
> > Hence we don't need to store whether we should write a start record
> > in the ticket as the callers provide all the information we need to
> > determine if a start record should be written. For the moment, we
> > have to ensure that we clear the XLOG_TIC_INITED appropriately so
> > the code in xfs_log_done() still works correctly for committing
> > transactions.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > [hch: use an need_start_rec bool]
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_log.c | 63 ++++++++++++++++++++++++------------------------
> >  1 file changed, 32 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 2a90a483c2d6..bf071552094a 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> ...
> > @@ -2372,25 +2359,29 @@ xlog_write(
> >  	int			record_cnt = 0;
> >  	int			data_cnt = 0;
> >  	int			error = 0;
> > +	bool			need_start_rec = true;
> >  
> >  	*start_lsn = 0;
> >  
> > -	len = xlog_write_calc_vec_length(ticket, log_vector);
> >  
> >  	/*
> >  	 * Region headers and bytes are already accounted for.
> >  	 * We only need to take into account start records and
> >  	 * split regions in this function.
> >  	 */
> > -	if (ticket->t_flags & XLOG_TIC_INITED)
> > -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> > +	if (ticket->t_flags & XLOG_TIC_INITED) {
> > +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> > +		ticket->t_flags &= ~XLOG_TIC_INITED;
> > +	}
> >  
> >  	/*
> >  	 * Commit record headers need to be accounted for. These
> >  	 * come in as separate writes so are easy to detect.
> >  	 */
> > -	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
> > -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> > +	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> > +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> > +		need_start_rec = false;
> > +	}
> 
> Hmm.. I was asking for a comment update in v1 for this logic change.
> Looking through it again, what happens here if
> xfs_log_write_unmount_record() clears the UNMOUNT_TRANS flag for that
> summary counter check? That looks like a potential behavior change wrt
> to the start record..

xfs_log_write_unmount_record() clears the XLOG_TIC_INITED
flag before calling xlog_write(), so the current code never writes
out a start record for the unmount record. i.e. the unmount
record is a single region with the unmount log item in it, and
AFAICT this code does not change the behaviour of the unmount record
write at all.

FWIW, that error injection code looks dodgy - it turns the unmount
record into an XFS_LOG transaction type with an invalid log item
type (0). That probably should be flagged as corruption, not be
silently ignored by recovery. IOWs, I think the error injection code
was wrong to begin with - if we want to ensure the log is dirty at
unmount, we should just skip writing the unmount record altogether.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
