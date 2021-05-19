Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05730C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 03:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C87D16135C
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 03:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239253AbhESDqO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 May 2021 23:46:14 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:47270 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235999AbhESDqN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 May 2021 23:46:13 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 6228967391;
        Wed, 19 May 2021 13:44:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljD8d-002doA-8N; Wed, 19 May 2021 13:44:51 +1000
Date:   Wed, 19 May 2021 13:44:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/45] xfs: introduce xlog_write_single()
Message-ID: <20210519034451.GM2893@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-29-david@fromorbit.com>
 <YFD7f+7h54WOIfKx@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFD7f+7h54WOIfKx@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=hlNQOcFrrv1gpfAAOH8A:9 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 16, 2021 at 02:39:59PM -0400, Brian Foster wrote:
> On Fri, Mar 05, 2021 at 04:11:26PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Introduce an optimised version of xlog_write() that is used when the
> > entire write will fit in a single iclog. This greatly simplifies the
> > implementation of writing a log vector chain into an iclog, and sets
> > the ground work for a much more understandable xlog_write()
> > implementation.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 56 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 22f97914ab99..590c1e6db475 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2214,6 +2214,52 @@ xlog_write_copy_finish(
> >  	return error;
> >  }
> >  
> > +/*
> > + * Write log vectors into a single iclog which is guaranteed by the caller
> > + * to have enough space to write the entire log vector into. Return the number
> > + * of log vectors written into the iclog.
> > + */
> > +static int
> > +xlog_write_single(
> > +	struct xfs_log_vec	*log_vector,
> > +	struct xlog_ticket	*ticket,
> > +	struct xlog_in_core	*iclog,
> > +	uint32_t		log_offset,
> > +	uint32_t		len)
> > +{
> > +	struct xfs_log_vec	*lv = log_vector;
> 
> This is initialized here and in the loop below.

Fixed.

> 
> > +	void			*ptr;
> > +	int			index = 0;
> > +	int			record_cnt = 0;
> > +
> > +	ASSERT(log_offset + len <= iclog->ic_size);
> > +
> > +	ptr = iclog->ic_datap + log_offset;
> > +	for (lv = log_vector; lv; lv = lv->lv_next) {
> > +		/*
> > +		 * Ordered log vectors have no regions to write so this
> > +		 * loop will naturally skip them.
> > +		 */
> > +		for (index = 0; index < lv->lv_niovecs; index++) {
> > +			struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
> > +			struct xlog_op_header	*ophdr = reg->i_addr;
> > +
> > +			ASSERT(reg->i_len % sizeof(int32_t) == 0);
> > +			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
> > +
> > +			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> > +			ophdr->oh_len = cpu_to_be32(reg->i_len -
> > +						sizeof(struct xlog_op_header));
> 
> Perhaps we should retain the xlog_verify_dest_ptr() call here? It's
> DEBUG code and otherwise compiled out, so shouldn't impact production

The pointer check does nothing to actually prevent memory
corruption. It only catches problems after we've already memcpy()d
off the end of the iclog in the previous loop. So if the last region
overruns the log, then it won't be triggered.

And, well, we've already checked and asserted that the copy is going
to fit entirely within the current iclog, so checking whether the
pointer has overrun outside the iclog buffer is both redundant and
too late.  Hence I removed it...

> > +			memcpy(ptr, reg->i_addr, reg->i_len);
> > +			xlog_write_adv_cnt(&ptr, &len, &log_offset, reg->i_len);
> > +			record_cnt++;
> > +		}
> > +	}
> > +	ASSERT(len == 0);
> > +	return record_cnt;
> > +}
> > +
> > +
> >  /*
> >   * Write some region out to in-core log
> >   *
> > @@ -2294,7 +2340,6 @@ xlog_write(
> >  			return error;
> >  
> >  		ASSERT(log_offset <= iclog->ic_size - 1);
> > -		ptr = iclog->ic_datap + log_offset;
> >  
> >  		/* Start_lsn is the first lsn written to. */
> >  		if (start_lsn && !*start_lsn)
> > @@ -2311,10 +2356,20 @@ xlog_write(
> >  						XLOG_ICL_NEED_FUA);
> >  		}
> >  
> > +		/* If this is a single iclog write, go fast... */
> > +		if (!contwr && lv == log_vector) {
> > +			record_cnt = xlog_write_single(lv, ticket, iclog,
> > +						log_offset, len);
> > +			len = 0;
> 
> I assume this is here to satisfy the assert further down in the
> function.. This seems a bit contrived when you consider we pass len to
> the helper, the helper reduces it and asserts that it goes to zero, then
> we do so again here just for another assert. Unless this is all just
> removed later, it might be more straightforward to pass a reference.
> 
> > +			data_cnt = len;
> 
> Similarly, this looks a bit odd because it seems data_cnt should be zero
> in the case where contwr == 0. xlog_state_get_iclog_space() has already
> bumped ->ic_offset by len (so xlog_state_finish_copy() doesn't need to
> via data_cnt).

Yes, it's entirely contrived to make it possible to split this code
out in a simple fashion to ease review of the simple, fast path case
this code will end up with. The next patch changes all this context
and the parameters passed to the function, but this was the only way
I could easily split the complex xlog_write() rewrite change into
something a little bit simpler....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
