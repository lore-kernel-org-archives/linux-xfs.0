Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD6DC433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 12:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4283261353
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 12:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbhETMey (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 May 2021 08:34:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235016AbhETMec (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 May 2021 08:34:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621513991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OoyT/jLFcn6ZEQ1LcpToTLzN4XcAOSi/s/t/LnHpBN8=;
        b=XlByeIQ1PWg9HzRe1a39kruK4vxorPVboyKzy6H8TydHPBSbJMybl0zZBN2cDDOk2X83QG
        hYqW5gDNHBTkxGkvojjckh69JYEIS1/b3CCuAJQf+42UUrDrWctiQU1yW9/OQjSzCpl8wR
        CMsEhrNNj+saAWuik4OjpIxb8TIzqcA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-kkc5_0zYPnikkpYZSYVSSA-1; Thu, 20 May 2021 08:33:08 -0400
X-MC-Unique: kkc5_0zYPnikkpYZSYVSSA-1
Received: by mail-qv1-f71.google.com with SMTP id r11-20020a0cb28b0000b02901c87a178503so12964006qve.22
        for <linux-xfs@vger.kernel.org>; Thu, 20 May 2021 05:33:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OoyT/jLFcn6ZEQ1LcpToTLzN4XcAOSi/s/t/LnHpBN8=;
        b=RIrXsvtt4n9bxOhrhmc35WC5YAo2sOR+joM3vIDCkK12VOb5pa/LHRc6dUSU25Jm0F
         SIzY70Yuf6AWw9PiDp2mBsafujRd8AKGT5TkYFCO6nT/1Pp387pJ6VYmpI1MMTn7guUb
         8B0078vkPCLQ6MXaNEnh6bK7CN13TK3XL+jM2tVBmmNcjvFSwAkemUur/c4mtZ4PXBLS
         BHcJPozHRm6oTh6L3A4Wg88cfWDxhLu9WiO6XWnJ/XCYL5IhRrEe7b+UlllhXGjrCsUB
         pZaErbrh0TCz1LBD5Y3/dcmiuEKVVfBQtXISSvXxf6HEPgTu8+IAimfL+XB+xbj0cEYy
         2wLQ==
X-Gm-Message-State: AOAM532TWfEicGzlGWsVC1cDweVn+9Mxy/7iQwE345VfIqe9+cLT6fmy
        2FMiiUehm0uiaBQ6BpcS8ONO+sfc4HfdBpDEZzOyTA9m0h6uBmfhTWuFc+tCXnK0FGWim8CSvgB
        Brbzgk6bvOokCqvQgaYaZ
X-Received: by 2002:a05:620a:68d:: with SMTP id f13mr4979754qkh.31.1621513987731;
        Thu, 20 May 2021 05:33:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztlvcaFwBQz29N458UONCgBdcAVGyBk7MyPYtxZCuM+X+hrGr5+UNpLTOX4Hmc1OPNRfOi/A==
X-Received: by 2002:a05:620a:68d:: with SMTP id f13mr4979705qkh.31.1621513987278;
        Thu, 20 May 2021 05:33:07 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id k125sm1875629qkf.53.2021.05.20.05.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 05:33:06 -0700 (PDT)
Date:   Thu, 20 May 2021 08:33:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/45] xfs:_introduce xlog_write_partial()
Message-ID: <YKZXAI2qKAmq4HQ4@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-30-david@fromorbit.com>
 <YFNUALXWnRFFF8J7@bfoster>
 <20210519044903.GN2893@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519044903.GN2893@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 02:49:03PM +1000, Dave Chinner wrote:
> On Thu, Mar 18, 2021 at 09:22:08AM -0400, Brian Foster wrote:
> > On Fri, Mar 05, 2021 at 04:11:27PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Handle writing of a logvec chain into an iclog that doesn't have
> > > enough space to fit it all. The iclog has already been changed to
> > > WANT_SYNC by xlog_get_iclog_space(), so the entire remaining space
> > > in the iclog is exclusively owned by this logvec chain.
> > > 
> > > The difference between the single and partial cases is that
> > > we end up with partial iovec writes in the iclog and have to split
> > > a log vec regions across two iclogs. The state handling for this is
> > > currently awful and so we're building up the pieces needed to
> > > handle this more cleanly one at a time.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > FWIW, git --patience mode generates a more readable diff for this patch
> > than what it generates by default. I'm referring to that locally and
> > will try to leave feedback in the appropriate points here.
> > 
> > >  fs/xfs/xfs_log.c | 525 ++++++++++++++++++++++-------------------------
> > >  1 file changed, 251 insertions(+), 274 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index 590c1e6db475..10916b99bf0f 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -2099,166 +2099,250 @@ xlog_print_trans(
> > >  	}
> > >  }
> > >  
> > > -static xlog_op_header_t *
> > > -xlog_write_setup_ophdr(
> > > -	struct xlog_op_header	*ophdr,
> > > -	struct xlog_ticket	*ticket)
> > > -{
> > > -	ophdr->oh_clientid = XFS_TRANSACTION;
> > > -	ophdr->oh_res2 = 0;
> > > -	ophdr->oh_flags = 0;
> > > -	return ophdr;
> > > -}
> > > -
> > >  /*
> > > - * Set up the parameters of the region copy into the log. This has
> > > - * to handle region write split across multiple log buffers - this
> > > - * state is kept external to this function so that this code can
> > > - * be written in an obvious, self documenting manner.
> > > + * Write whole log vectors into a single iclog which is guaranteed to have
> > > + * either sufficient space for the entire log vector chain to be written or
> > > + * exclusive access to the remaining space in the iclog.
> > > + *
> > > + * Return the number of iovecs and data written into the iclog, as well as
> > > + * a pointer to the logvec that doesn't fit in the log (or NULL if we hit the
> > > + * end of the chain.
> > >   */
> > > -static int
> > > -xlog_write_setup_copy(
> > > +static struct xfs_log_vec *
> > > +xlog_write_single(
> > > +	struct xfs_log_vec	*log_vector,
> > 
> > So xlog_write_single() was initially for single CIL xlog_write() calls
> > and now it appears to be slightly different in that it writes as many
> > full log vectors that fit in the current iclog and cycles through
> > xlog_write_partial() (and back) to process log vectors that span iclogs
> > differently from those that don't.
> 
> Yes, that is what it does, but no, you've got the process and
> meaning backwards. I wrote xlog_write_single() it as it appears in
> this patch first, then split it out backwards to ease review. IOWs,
> "single" means "write everything that fits within this single
> iclog", not "only call this function if the entire lv chain fits
> inside a single iclog".
> 
> The latter is what I split out to make it simpler to review, but it
> was not the reason it was called xlog_write_single()....
> 
> > > +		do {
> > > +			/*
> > > +			 * Account for the continuation opheader before we get
> > > +			 * a new iclog. This is necessary so that we reserve
> > > +			 * space in the iclog for it.
> > > +			 */
> > > +			if (ophdr->oh_flags & XLOG_CONTINUE_TRANS) {
> > 
> > (Is this ever not true here?)
> 
> It is now, wasn't always. Fixed.
> 
> > 
> > > +				*len += sizeof(struct xlog_op_header);
> > > +				ticket->t_curr_res -= sizeof(struct xlog_op_header);
> > > +			}
> > > +			error = xlog_write_get_more_iclog_space(log, ticket,
> > > +					&iclog, log_offset, *len, record_cnt,
> > > +					data_cnt, contwr);
> > > +			if (error)
> > > +				return ERR_PTR(error);
> > > +			ptr = iclog->ic_datap + *log_offset;
> > > +
> > > +			ophdr = ptr;
> > >  			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> > > -			ophdr->oh_len = cpu_to_be32(reg->i_len -
> > > +			ophdr->oh_clientid = XFS_TRANSACTION;
> > > +			ophdr->oh_res2 = 0;
> > > +			ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
> > > +
> > > +			xlog_write_adv_cnt(&ptr, len, log_offset,
> > >  						sizeof(struct xlog_op_header));
> > > -			memcpy(ptr, reg->i_addr, reg->i_len);
> > > -			xlog_write_adv_cnt(&ptr, &len, &log_offset, reg->i_len);
> > > -			record_cnt++;
> > > -		}
> > > +			*data_cnt += sizeof(struct xlog_op_header);
> > > +
> > 
> > ... which switches to the next iclog, writes the continuation header...
> > 
> > > +			/*
> > > +			 * If rlen fits in the iclog, then end the region
> > > +			 * continuation. Otherwise we're going around again.
> > > +			 */
> > > +			reg_offset += rlen;
> > > +			rlen = reg->i_len - reg_offset;
> > > +			if (rlen <= iclog->ic_size - *log_offset)
> > > +				ophdr->oh_flags |= XLOG_END_TRANS;
> > > +			else
> > > +				ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
> > > +
> > > +			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
> > > +			ophdr->oh_len = cpu_to_be32(rlen);
> > > +
> > > +			xlog_verify_dest_ptr(log, ptr);
> > > +			memcpy(ptr, reg->i_addr + reg_offset, rlen);
> > > +			xlog_write_adv_cnt(&ptr, len, log_offset, rlen);
> > > +			(*record_cnt)++;
> > > +			*data_cnt += rlen;
> > > +
> > > +		} while (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
> > 
> > ... writes more of the region (iclog space permitting), and then
> > determines whether we need further continuations (and partial writes of
> > the same region) or can move onto the next region, until we're done with
> > the lv.
> 
> Yup.
> 
> > I think I follow the high level flow and it seems reasonable from a
> > functional standpoint, but this also seems like quite a bit of churn for
> > not much reduction in overall complexity. The higher level loop is much
> > more simple and I think the per lv/vector iteration is an improvement,
> > but we also seem to have duplicate functionality throughout the updated
> > code and have introduced new forms of complexity around the state
> > expectations for the transitions between the different write modes and
> > between each write mode and the higher level loop.
> 
> Just getting untangling the code to get it to this point
> has been hard enough. I've held off doing more factoring and
> changing this code so I can actaully test it and find the bugs I
> might have left in it.
> 
> Yes, it can be further improved by factoring the region copying
> stuff, but that's secondary to the major work of refactoring this
> code in the first place. The fact that you actually understood this
> fairly easily indicates just how much better this code already is
> compared to what is currently upstream....
> 

Heh. "You understood the patch, so it must be better!" :P

I've paged much of this out in the 2 months or so since this review was
posted, but my recollection is quite different. I use the existing code
as a baseline to confirm behavior and assess readability of the updated
code.

> > I.e., xlog_write_single() implements a straighforward loop to write out
> > full log vectors. That seems fine, but the outer loop of
> > xlog_write_partial() reimplements nearly the same per-region
> > functionality with some added flexibility to handle op header flags and
> > the special iclog processing associated with the continuation case. The
> > inner loop factors out the continuation iclog management bits and op
> > header injection, which I think is an improvement, but then duplicates
> > region copying (yet again) pretty much only to implement partial copies,
> > which really just involves offset management (i.e., fairly trivial
> > relative to the broader complexity of the function).
> > 
> > I dunno. I'd certainly need to stare more at this to cover all of the
> > details, but given the amount of swizzling going on in a single patch
> > I'm kind of wondering if/why we couldn't land on a single iterator in
> > the spirit of xlog_write_partial() in that it primarily iterates on
> > regions and factors out the grotty reservation and continuation
> > management bits, but doesn't unroll as much and leave so much duplicate
> > functionality around.
> > 
> > For example, it looks to me that xlog_write_partial() almost nearly
> > already supports a high level algorithm along the lines of the following
> > (pseudocode):
> > 
> > xlog_write(len)
> > {
> > 	get_iclog_space(len)
> > 
> > 	for_each_lv() {
> > 		for_each_reg() {
> > 			reg_offset = 0;
> > cont_write:
> > 			/* write as much as will fit in the iclog, return count,
> > 			 * and set ophdr cont flag based on write result */
> > 			reg_offset += write_region(reg, &len, &reg_offset, ophdr, ...);
> > 
> > 			/* handle continuation writes */
> > 			if (reg_offset != reg->i_len) {
> > 				get_more_iclog_space(len);
> > 				/* stamp a WAS_CONT op hdr, set END if rlen fits
> > 				 * into new space, then continue with the same region */
> > 				stamp_cont_op_hdr();
> > 				goto cont_write;
> > 			}
> > 
> > 			if (need_more_iclog_space(len))
> > 				get_more_iclog_space(len);
> > 		}
> > 	}
> > }
> 
> Yeah, na. That is exactly the mess that I've just untangled.
> 
> I don't want to rewrite this code again, and I don't want it more
> tightly tied to iclogs than it already is - I'm trying to move the
> code towards a common, simple fast path that knows nothing about
> iclogs and a slow path that handles the partial regions and
> obtaining a new buffer to write into. I want the two cases
> completely separate logic, because that makes both cases simpler to
> modify and reason about.
> 

Well, this review has been on the list for more than a couple months
now. Given the response seems to have appeared after the next version of
the series, I'm not sure it's worth digging my head back into the
details to try and make a more detailed argument. Suffice it to say that
I recall what I proposed as intended to be a fairly reasonable
incremental step from what you ended up at to replace the large amount
of resulting duplication with a single implementation that otherwise
preserves the majority of the other cleanups. Not a rewrite or anything
of the sort..

In any event, no single one of us is ultimately the authority on
"better" or "simple." I'm just providing feedback that I didn't find the
resulting factoring as a clear improvement, find it a bit annoying to
have to dig through duplicate implementations to locate the subtle and
unnecessary differences, and provided a suggestion on how to address
that concern (that doesn't involve rewriting the thing) with specific
details on how and why I think it improves readability. *shrug* Perhaps
others will look at this, disagree with that assessment and find the
separate functions more straightforward.

> Indeed, I want xlog_write to move away from iclogs because I want to
> use this code with direct mapped pmem regions, not just fixed memory
> buffers held in iclogs.
> 

That context and how that relates the proposed structure is not clear to
me. That said, I _thought_ I looked through far enough into this series
to grok how intertwined the resulting structure might have been with
subsequent patches in order to provide thoughtful feedback, but I could
be mistaken.

> IOWs, the code as it stands is a beginning, not an end. And even as
> a beginning, it works, is much better and faster than the current
> code, has been tested for some time now, can be further factored to
> make it simpler, easier to understand and provide infrastructure for
> new features.
> 
> 
> > That puts the whole thing back into a single high level walk and thus
> > reintroduces the need for some of the continuation vs. non-continuation
> > tracking wrt to the op header and iclog, but ISTM that complexity can be
> > managed by the continuation abstraction you've already started to
> > introduce (as opposed to the current scheme of conditionally
> > accumulating data_cnt). It might even be fine to dump some of the
> > requisite state into a context struct to carry between iclog reservation
> > and copy finish processing rather than pass around so many independent
> > and poorly named variables like the current upstream implementation
> > does, but that's probably getting too deep into the weeds.
> > 
> > FWIW, I can also see an approach of moving from the implementation in
> > this patch toward something like the above, but I'm not sure I'd want to
> > subject to the upstream code to that process...
> 
> This is exactly what upstream is for - iterative improvement via
> small steps. This is the first step of many, and what you propose
> takes the code in the wrong direction for the steps I've already
> taken and are planning to take.
> 
> Perfect is the enemy of good, and if upstream is not the place to
> make iterative improvements like this that build towards a bigger
> picture goal, then where the hell are we supposed to do them?
> 

Not every incremental development step is necessarily a suitable point
for an upstream release. My comment above is basically to say that I
think this refactoring is nearly to that point, but should go a bit
further to reduce the duplication. If the argument against that step is
dependence on future work, then propose the factoring close enough to
that work such that sufficient context is available to review.

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

