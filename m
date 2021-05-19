Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F2BC43461
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 03:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47FCD6135F
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 03:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352976AbhESD3B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 May 2021 23:29:01 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:60015 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237742AbhESD3A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 May 2021 23:29:00 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 683691140A8C;
        Wed, 19 May 2021 13:27:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljCrt-002dYk-HK; Wed, 19 May 2021 13:27:33 +1000
Date:   Wed, 19 May 2021 13:27:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/45] xfs: log ticket region debug is largely useless
Message-ID: <20210519032733.GL2893@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-27-david@fromorbit.com>
 <YFDG5mYRTvSL1Wjo@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFDG5mYRTvSL1Wjo@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=SVAgNjfy79dt-6jacGEA:9 a=6XwLLKi-Up6M22eq:21 a=P3dcUMCUKnSXYNad:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 16, 2021 at 10:55:34AM -0400, Brian Foster wrote:
> On Fri, Mar 05, 2021 at 04:11:24PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xlog_tic_add_region() is used to trace the regions being added to a
> > log ticket to provide information in the situation where a ticket
> > reservation overrun occurs. The information gathered is stored int
> > the ticket, and dumped if xlog_print_tic_res() is called.
> > 
> > For a front end struct xfs_trans overrun, the ticket only contains
> > reservation tracking information - the ticket is never handed to the
> > log so has no regions attached to it. The overrun debug information in this
> > case comes from xlog_print_trans(), which walks the items attached
> > to the transaction and dumps their attached formatted log vectors
> > directly. It also dumps the ticket state, but that only contains
> > reservation accounting and nothing else. Hence xlog_print_tic_res()
> > never dumps region or overrun information from this path.
> > 
> > xlog_tic_add_region() is actually called from xlog_write(), which
> > means it is being used to track the regions seen in a
> > CIL checkpoint log vector chain. In looking at CIL behaviour
> > recently, I've seen 32MB checkpoints regularly exceed 250,000
> > regions in the LV chain. The log ticket debug code can track *15*
> > regions. IOWs, if there is a ticket overrun in the CIL code, the
> > ticket region tracking code is going to be completely useless for
> > determining what went wrong. The only thing it can tell us is how
> > much of an overrun occurred, and we really don't need extra debug
> > information in the log ticket to tell us that.
> > 
> > Indeed, the main place we call xlog_tic_add_region() is also adding
> > up the number of regions and the space used so that xlog_write()
> > knows how much will be written to the log. This is exactly the same
> > information that log ticket is storing once we take away the useless
> > region tracking array. Hence xlog_tic_add_region() is not useful,
> > but can be called 250,000 times a CIL push...
> > 
> > Just strip all that debug "information" out of the of the log ticket
> > and only have it report reservation space information when an
> > overrun occurs. This also reduces the size of a log ticket down by
> > about 150 bytes...
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_log.c      | 107 +++---------------------------------------
> >  fs/xfs/xfs_log_priv.h |  17 -------
> >  2 files changed, 6 insertions(+), 118 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> > index 7f601c1c9f45..8ee6a5f74396 100644
> > --- a/fs/xfs/xfs_log_priv.h
> > +++ b/fs/xfs/xfs_log_priv.h
> > @@ -139,16 +139,6 @@ enum xlog_iclog_state {
> >  /* Ticket reservation region accounting */ 
> >  #define XLOG_TIC_LEN_MAX	15
> >  
> 
> This is unused now.

Removed.

> 
> > -/*
> > - * Reservation region
> > - * As would be stored in xfs_log_iovec but without the i_addr which
> > - * we don't care about.
> > - */
> > -typedef struct xlog_res {
> > -	uint	r_len;	/* region length		:4 */
> > -	uint	r_type;	/* region's transaction type	:4 */
> > -} xlog_res_t;
> > -
> >  typedef struct xlog_ticket {
> >  	struct list_head   t_queue;	 /* reserve/write queue */
> >  	struct task_struct *t_task;	 /* task that owns this ticket */
> > @@ -159,13 +149,6 @@ typedef struct xlog_ticket {
> >  	char		   t_ocnt;	 /* original count		 : 1  */
> >  	char		   t_cnt;	 /* current count		 : 1  */
> >  	char		   t_flags;	 /* properties of reservation	 : 1  */
> > -
> > -        /* reservation array fields */
> > -	uint		   t_res_num;                    /* num in array : 4 */
> > -	uint		   t_res_num_ophdrs;		 /* num op hdrs  : 4 */
> 
> I'm curious why we wouldn't want to retain the ophdr count..? That's
> managed separately from the _add_region() bits and provides some info on
> the total number of vectors, etc. Otherwise looks reasonable.

Because we calculate it when we build the lv chain in a push and
only use the value the checkpoint transaction header. This is now
entirely encapsulated within the CIL push code and is no longer
something the xlog_write() needs to know because it doesn't build on
disk transaction headers. If we need debug to track how long the
lvchain is, then grab it the CIL code where it is already known...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
