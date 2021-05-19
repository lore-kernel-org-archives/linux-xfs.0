Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F113AC43460
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 04:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFCA76135B
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 04:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbhESEu3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 00:50:29 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55582 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233822AbhESEu2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 00:50:28 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 050861043488;
        Wed, 19 May 2021 14:49:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljE8l-002epn-Bx; Wed, 19 May 2021 14:49:03 +1000
Date:   Wed, 19 May 2021 14:49:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/45] xfs:_introduce xlog_write_partial()
Message-ID: <20210519044903.GN2893@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-30-david@fromorbit.com>
 <YFNUALXWnRFFF8J7@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFNUALXWnRFFF8J7@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Bsuq2wMHWz3LXhTQCEYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 18, 2021 at 09:22:08AM -0400, Brian Foster wrote:
> On Fri, Mar 05, 2021 at 04:11:27PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Handle writing of a logvec chain into an iclog that doesn't have
> > enough space to fit it all. The iclog has already been changed to
> > WANT_SYNC by xlog_get_iclog_space(), so the entire remaining space
> > in the iclog is exclusively owned by this logvec chain.
> > 
> > The difference between the single and partial cases is that
> > we end up with partial iovec writes in the iclog and have to split
> > a log vec regions across two iclogs. The state handling for this is
> > currently awful and so we're building up the pieces needed to
> > handle this more cleanly one at a time.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> FWIW, git --patience mode generates a more readable diff for this patch
> than what it generates by default. I'm referring to that locally and
> will try to leave feedback in the appropriate points here.
> 
> >  fs/xfs/xfs_log.c | 525 ++++++++++++++++++++++-------------------------
> >  1 file changed, 251 insertions(+), 274 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 590c1e6db475..10916b99bf0f 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2099,166 +2099,250 @@ xlog_print_trans(
> >  	}
> >  }
> >  
> > -static xlog_op_header_t *
> > -xlog_write_setup_ophdr(
> > -	struct xlog_op_header	*ophdr,
> > -	struct xlog_ticket	*ticket)
> > -{
> > -	ophdr->oh_clientid = XFS_TRANSACTION;
> > -	ophdr->oh_res2 = 0;
> > -	ophdr->oh_flags = 0;
> > -	return ophdr;
> > -}
> > -
> >  /*
> > - * Set up the parameters of the region copy into the log. This has
> > - * to handle region write split across multiple log buffers - this
> > - * state is kept external to this function so that this code can
> > - * be written in an obvious, self documenting manner.
> > + * Write whole log vectors into a single iclog which is guaranteed to have
> > + * either sufficient space for the entire log vector chain to be written or
> > + * exclusive access to the remaining space in the iclog.
> > + *
> > + * Return the number of iovecs and data written into the iclog, as well as
> > + * a pointer to the logvec that doesn't fit in the log (or NULL if we hit the
> > + * end of the chain.
> >   */
> > -static int
> > -xlog_write_setup_copy(
> > +static struct xfs_log_vec *
> > +xlog_write_single(
> > +	struct xfs_log_vec	*log_vector,
> 
> So xlog_write_single() was initially for single CIL xlog_write() calls
> and now it appears to be slightly different in that it writes as many
> full log vectors that fit in the current iclog and cycles through
> xlog_write_partial() (and back) to process log vectors that span iclogs
> differently from those that don't.

Yes, that is what it does, but no, you've got the process and
meaning backwards. I wrote xlog_write_single() it as it appears in
this patch first, then split it out backwards to ease review. IOWs,
"single" means "write everything that fits within this single
iclog", not "only call this function if the entire lv chain fits
inside a single iclog".

The latter is what I split out to make it simpler to review, but it
was not the reason it was called xlog_write_single()....

> > +		do {
> > +			/*
> > +			 * Account for the continuation opheader before we get
> > +			 * a new iclog. This is necessary so that we reserve
> > +			 * space in the iclog for it.
> > +			 */
> > +			if (ophdr->oh_flags & XLOG_CONTINUE_TRANS) {
> 
> (Is this ever not true here?)

It is now, wasn't always. Fixed.

> 
> > +				*len += sizeof(struct xlog_op_header);
> > +				ticket->t_curr_res -= sizeof(struct xlog_op_header);
> > +			}
> > +			error = xlog_write_get_more_iclog_space(log, ticket,
> > +					&iclog, log_offset, *len, record_cnt,
> > +					data_cnt, contwr);
> > +			if (error)
> > +				return ERR_PTR(error);
> > +			ptr = iclog->ic_datap + *log_offset;
> > +
> > +			ophdr = ptr;
> >  			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> > -			ophdr->oh_len = cpu_to_be32(reg->i_len -
> > +			ophdr->oh_clientid = XFS_TRANSACTION;
> > +			ophdr->oh_res2 = 0;
> > +			ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
> > +
> > +			xlog_write_adv_cnt(&ptr, len, log_offset,
> >  						sizeof(struct xlog_op_header));
> > -			memcpy(ptr, reg->i_addr, reg->i_len);
> > -			xlog_write_adv_cnt(&ptr, &len, &log_offset, reg->i_len);
> > -			record_cnt++;
> > -		}
> > +			*data_cnt += sizeof(struct xlog_op_header);
> > +
> 
> ... which switches to the next iclog, writes the continuation header...
> 
> > +			/*
> > +			 * If rlen fits in the iclog, then end the region
> > +			 * continuation. Otherwise we're going around again.
> > +			 */
> > +			reg_offset += rlen;
> > +			rlen = reg->i_len - reg_offset;
> > +			if (rlen <= iclog->ic_size - *log_offset)
> > +				ophdr->oh_flags |= XLOG_END_TRANS;
> > +			else
> > +				ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
> > +
> > +			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
> > +			ophdr->oh_len = cpu_to_be32(rlen);
> > +
> > +			xlog_verify_dest_ptr(log, ptr);
> > +			memcpy(ptr, reg->i_addr + reg_offset, rlen);
> > +			xlog_write_adv_cnt(&ptr, len, log_offset, rlen);
> > +			(*record_cnt)++;
> > +			*data_cnt += rlen;
> > +
> > +		} while (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
> 
> ... writes more of the region (iclog space permitting), and then
> determines whether we need further continuations (and partial writes of
> the same region) or can move onto the next region, until we're done with
> the lv.

Yup.

> I think I follow the high level flow and it seems reasonable from a
> functional standpoint, but this also seems like quite a bit of churn for
> not much reduction in overall complexity. The higher level loop is much
> more simple and I think the per lv/vector iteration is an improvement,
> but we also seem to have duplicate functionality throughout the updated
> code and have introduced new forms of complexity around the state
> expectations for the transitions between the different write modes and
> between each write mode and the higher level loop.

Just getting untangling the code to get it to this point
has been hard enough. I've held off doing more factoring and
changing this code so I can actaully test it and find the bugs I
might have left in it.

Yes, it can be further improved by factoring the region copying
stuff, but that's secondary to the major work of refactoring this
code in the first place. The fact that you actually understood this
fairly easily indicates just how much better this code already is
compared to what is currently upstream....

> I.e., xlog_write_single() implements a straighforward loop to write out
> full log vectors. That seems fine, but the outer loop of
> xlog_write_partial() reimplements nearly the same per-region
> functionality with some added flexibility to handle op header flags and
> the special iclog processing associated with the continuation case. The
> inner loop factors out the continuation iclog management bits and op
> header injection, which I think is an improvement, but then duplicates
> region copying (yet again) pretty much only to implement partial copies,
> which really just involves offset management (i.e., fairly trivial
> relative to the broader complexity of the function).
> 
> I dunno. I'd certainly need to stare more at this to cover all of the
> details, but given the amount of swizzling going on in a single patch
> I'm kind of wondering if/why we couldn't land on a single iterator in
> the spirit of xlog_write_partial() in that it primarily iterates on
> regions and factors out the grotty reservation and continuation
> management bits, but doesn't unroll as much and leave so much duplicate
> functionality around.
> 
> For example, it looks to me that xlog_write_partial() almost nearly
> already supports a high level algorithm along the lines of the following
> (pseudocode):
> 
> xlog_write(len)
> {
> 	get_iclog_space(len)
> 
> 	for_each_lv() {
> 		for_each_reg() {
> 			reg_offset = 0;
> cont_write:
> 			/* write as much as will fit in the iclog, return count,
> 			 * and set ophdr cont flag based on write result */
> 			reg_offset += write_region(reg, &len, &reg_offset, ophdr, ...);
> 
> 			/* handle continuation writes */
> 			if (reg_offset != reg->i_len) {
> 				get_more_iclog_space(len);
> 				/* stamp a WAS_CONT op hdr, set END if rlen fits
> 				 * into new space, then continue with the same region */
> 				stamp_cont_op_hdr();
> 				goto cont_write;
> 			}
> 
> 			if (need_more_iclog_space(len))
> 				get_more_iclog_space(len);
> 		}
> 	}
> }

Yeah, na. That is exactly the mess that I've just untangled.

I don't want to rewrite this code again, and I don't want it more
tightly tied to iclogs than it already is - I'm trying to move the
code towards a common, simple fast path that knows nothing about
iclogs and a slow path that handles the partial regions and
obtaining a new buffer to write into. I want the two cases
completely separate logic, because that makes both cases simpler to
modify and reason about.

Indeed, I want xlog_write to move away from iclogs because I want to
use this code with direct mapped pmem regions, not just fixed memory
buffers held in iclogs.

IOWs, the code as it stands is a beginning, not an end. And even as
a beginning, it works, is much better and faster than the current
code, has been tested for some time now, can be further factored to
make it simpler, easier to understand and provide infrastructure for
new features.


> That puts the whole thing back into a single high level walk and thus
> reintroduces the need for some of the continuation vs. non-continuation
> tracking wrt to the op header and iclog, but ISTM that complexity can be
> managed by the continuation abstraction you've already started to
> introduce (as opposed to the current scheme of conditionally
> accumulating data_cnt). It might even be fine to dump some of the
> requisite state into a context struct to carry between iclog reservation
> and copy finish processing rather than pass around so many independent
> and poorly named variables like the current upstream implementation
> does, but that's probably getting too deep into the weeds.
> 
> FWIW, I can also see an approach of moving from the implementation in
> this patch toward something like the above, but I'm not sure I'd want to
> subject to the upstream code to that process...

This is exactly what upstream is for - iterative improvement via
small steps. This is the first step of many, and what you propose
takes the code in the wrong direction for the steps I've already
taken and are planning to take.

Perfect is the enemy of good, and if upstream is not the place to
make iterative improvements like this that build towards a bigger
picture goal, then where the hell are we supposed to do them?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
