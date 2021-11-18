Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDB0C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 05:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59D1161B31
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 05:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242412AbhKRF0A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Nov 2021 00:26:00 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57187 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242408AbhKRFZ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Nov 2021 00:25:59 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7A814105E348;
        Thu, 18 Nov 2021 16:22:58 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mnZsv-00ABMy-Bg; Thu, 18 Nov 2021 16:22:57 +1100
Date:   Thu, 18 Nov 2021 16:22:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/16] xfs:_introduce xlog_write_partial()
Message-ID: <20211118052257.GX449541@dread.disaster.area>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-13-david@fromorbit.com>
 <20211117052151.GM24333@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117052151.GM24333@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6195e332
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=7-415B0cAAAA:8
        a=ppH-c5bXtpJ6MQKJtjgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 16, 2021 at 09:21:51PM -0800, Darrick J. Wong wrote:
> > Subject: [PATCH 12/16] xfs:_introduce xlog_write_partial()
> 
> Nit: There's still an        ^ underscore in the subject.

fixed.

> > +		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> > +		ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
> > +		if (rlen != reg->i_len)
> > +			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
> > +
> > +		xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
> > +		xlog_write_iovec(iclog, log_offset, reg->i_addr,
> > +				rlen, len, record_cnt, data_cnt);
> > +
> > +		/* If we wrote the whole region, move to the next. */
> > +		if (rlen == reg->i_len)
> > +			continue;
> >  
> > -	if (*partial_copy) {
> >  		/*
> > -		 * This iclog has already been marked WANT_SYNC by
> > -		 * xlog_state_get_iclog_space.
> > +		 * We now have a partially written iovec, but it can span
> > +		 * multiple iclogs so we loop here. First we release the iclog
> > +		 * we currently have, then we get a new iclog and add a new
> > +		 * opheader. Then we continue copying from where we were until
> > +		 * we either complete the iovec or fill the iclog. If we
> > +		 * complete the iovec, then we increment the index and go right
> > +		 * back to the top of the outer loop. if we fill the iclog, we
> > +		 * run the inner loop again.
> > +		 *
> > +		 * This is complicated by the tail of a region using all the
> > +		 * space in an iclog and hence requiring us to release the iclog
> > +		 * and get a new one before returning to the outer loop. We must
> > +		 * always guarantee that we exit this inner loop with at least
> > +		 * space for log transaction opheaders left in the current
> > +		 * iclog, hence we cannot just terminate the loop at the end
> > +		 * of the of the continuation. So we loop while there is no
> > +		 * space left in the current iclog, and check for the end of the
> > +		 * continuation after getting a new iclog.
> >  		 */
> > -		spin_lock(&log->l_icloglock);
> > -		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
> > -		*record_cnt = 0;
> > -		*data_cnt = 0;
> > -		goto release_iclog;
> > -	}
> > +		do {
> > +			/*
> > +			 * Ensure we include the continuation opheader in the
> > +			 * space we need in the new iclog by adding that size
> > +			 * to the length we require. This continuation opheader
> > +			 * needs to be accounted to the ticket as the space it
> > +			 * consumes hasn't been accounted to the lv we are
> > +			 * writing.
> > +			 */
> > +			error = xlog_write_get_more_iclog_space(ticket,
> > +					&iclog, log_offset,
> > +					*len + sizeof(struct xlog_op_header),
> 
> Hm.  The last time I saw this patch, it incremented *len by the sizeof
> expression, but now we merely pass (*len + sizeof(...)) into
> xlog_write_get_more_iclog_space.  Why is that?

The space required in the iclog includes an extra ophdr, but *len
tracks the amount of region data we've copied. The continuation
ophdr space is not included in the region data, so that space does
not affect how we account for copied data.

However, we do need account for the space used by the continuation
ophdr in the space we use - reservation space, *log_offset and
*data_cnt - because those are used to track offset into the iclog,
data space used in the iclog and transaction reservation consumed.
The continuation header accounting is done separately ....

> 
> The rest of this looks more or less like a slightly reorganized version
> that I looked at the from June, so that was the only question I had.
> 
> --D
> 
> > +					record_cnt, data_cnt, contwr);
> > +			if (error)
> > +				return error;
> > +
> > +			ophdr = iclog->ic_datap + *log_offset;
> > +			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> > +			ophdr->oh_clientid = XFS_TRANSACTION;
> > +			ophdr->oh_res2 = 0;
> > +			ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
> >  
> > -	*partial_copy = 0;
> > -	*partial_copy_len = 0;
> > +			ticket->t_curr_res -= sizeof(struct xlog_op_header);
> > +			*log_offset += sizeof(struct xlog_op_header);
> > +			*data_cnt += sizeof(struct xlog_op_header);

.... right here, immediately after we write it into the iclog data
buffer.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
