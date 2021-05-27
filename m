Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FCAC4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1BFE613B4
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbhE0SFX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 14:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233918AbhE0SFW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 14:05:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74D6A613B4;
        Thu, 27 May 2021 18:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622138629;
        bh=lCpzysh+xAJyv8+g+Y6pS0OY/sBJoRAknh8np/iIkWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ISWyi7A5vKUInMqRRDtWw++T6+mGsVTmqTPw+WLNhHuZl7LGuLyCG+s3Hab9z/ERO
         isnhnrp3hVnb8kL0jdVoIBF2w1M4GH+v0dLhF8btucnjCSOlPrnaHIo4PfK867QSHW
         nnl46yorj0wvoJJdeTr1Qza+e1179jMhJS2Z1wKsaPU7Wke/SsNjKTB9tJgZFLPB38
         DvpGH7n/93q2dDBRWmgNoj+mLa6S/8VCDyZTpfQUc9WX6el9kgCE2JsZG32s7BWWR0
         YvrY9zoAc3X+5D1j1IuutizVGG3qqQExPRuRXUK7aFizqTP7oR0Q2CYlh/M/VgV4cQ
         YtPwjsW22fA3Q==
Date:   Thu, 27 May 2021 11:03:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/45] xfs:_introduce xlog_write_partial()
Message-ID: <20210527180348.GC2402049@locust>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-30-david@fromorbit.com>
 <YFNUALXWnRFFF8J7@bfoster>
 <20210519044903.GN2893@dread.disaster.area>
 <YKZXAI2qKAmq4HQ4@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKZXAI2qKAmq4HQ4@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 20, 2021 at 08:33:04AM -0400, Brian Foster wrote:

<snipping the earlier comments out because I want only to respond to the
discussion pertaining to handling of large patchsets>

> > > I think I follow the high level flow and it seems reasonable from a
> > > functional standpoint, but this also seems like quite a bit of churn for
> > > not much reduction in overall complexity. The higher level loop is much
> > > more simple and I think the per lv/vector iteration is an improvement,
> > > but we also seem to have duplicate functionality throughout the updated
> > > code and have introduced new forms of complexity around the state
> > > expectations for the transitions between the different write modes and
> > > between each write mode and the higher level loop.
> > 
> > Just getting untangling the code to get it to this point
> > has been hard enough. I've held off doing more factoring and
> > changing this code so I can actaully test it and find the bugs I
> > might have left in it.
> > 
> > Yes, it can be further improved by factoring the region copying
> > stuff, but that's secondary to the major work of refactoring this
> > code in the first place. The fact that you actually understood this
> > fairly easily indicates just how much better this code already is
> > compared to what is currently upstream....
> > 
> 
> Heh. "You understood the patch, so it must be better!" :P
> 
> I've paged much of this out in the 2 months or so since this review was
> posted, but my recollection is quite different. I use the existing code
> as a baseline to confirm behavior and assess readability of the updated
> code.
> 
> > > I.e., xlog_write_single() implements a straighforward loop to write out
> > > full log vectors. That seems fine, but the outer loop of
> > > xlog_write_partial() reimplements nearly the same per-region
> > > functionality with some added flexibility to handle op header flags and
> > > the special iclog processing associated with the continuation case. The
> > > inner loop factors out the continuation iclog management bits and op
> > > header injection, which I think is an improvement, but then duplicates
> > > region copying (yet again) pretty much only to implement partial copies,
> > > which really just involves offset management (i.e., fairly trivial
> > > relative to the broader complexity of the function).
> > > 
> > > I dunno. I'd certainly need to stare more at this to cover all of the
> > > details, but given the amount of swizzling going on in a single patch
> > > I'm kind of wondering if/why we couldn't land on a single iterator in
> > > the spirit of xlog_write_partial() in that it primarily iterates on
> > > regions and factors out the grotty reservation and continuation
> > > management bits, but doesn't unroll as much and leave so much duplicate
> > > functionality around.
> > > 
> > > For example, it looks to me that xlog_write_partial() almost nearly
> > > already supports a high level algorithm along the lines of the following
> > > (pseudocode):
> > > 
> > > xlog_write(len)
> > > {
> > > 	get_iclog_space(len)
> > > 
> > > 	for_each_lv() {
> > > 		for_each_reg() {
> > > 			reg_offset = 0;
> > > cont_write:
> > > 			/* write as much as will fit in the iclog, return count,
> > > 			 * and set ophdr cont flag based on write result */
> > > 			reg_offset += write_region(reg, &len, &reg_offset, ophdr, ...);
> > > 
> > > 			/* handle continuation writes */
> > > 			if (reg_offset != reg->i_len) {
> > > 				get_more_iclog_space(len);
> > > 				/* stamp a WAS_CONT op hdr, set END if rlen fits
> > > 				 * into new space, then continue with the same region */
> > > 				stamp_cont_op_hdr();
> > > 				goto cont_write;
> > > 			}
> > > 
> > > 			if (need_more_iclog_space(len))
> > > 				get_more_iclog_space(len);
> > > 		}
> > > 	}
> > > }
> > 
> > Yeah, na. That is exactly the mess that I've just untangled.
> > 
> > I don't want to rewrite this code again, and I don't want it more
> > tightly tied to iclogs than it already is - I'm trying to move the
> > code towards a common, simple fast path that knows nothing about
> > iclogs and a slow path that handles the partial regions and
> > obtaining a new buffer to write into. I want the two cases
> > completely separate logic, because that makes both cases simpler to
> > modify and reason about.
> > 
> 
> Well, this review has been on the list for more than a couple months
> now. Given the response seems to have appeared after the next version of
> the series, I'm not sure it's worth digging my head back into the
> details to try and make a more detailed argument. Suffice it to say that
> I recall what I proposed as intended to be a fairly reasonable
> incremental step from what you ended up at to replace the large amount
> of resulting duplication with a single implementation that otherwise
> preserves the majority of the other cleanups. Not a rewrite or anything
> of the sort..
> 
> In any event, no single one of us is ultimately the authority on
> "better" or "simple." I'm just providing feedback that I didn't find the
> resulting factoring as a clear improvement, find it a bit annoying to
> have to dig through duplicate implementations to locate the subtle and
> unnecessary differences, and provided a suggestion on how to address
> that concern (that doesn't involve rewriting the thing) with specific
> details on how and why I think it improves readability. *shrug* Perhaps
> others will look at this, disagree with that assessment and find the
> separate functions more straightforward.

Admittedly I did look at the:

	xlog_verify_dest_ptr(log, ptr);
	memcpy(ptr, reg->i_addr + reg_offset, rlen);
	xlog_write_adv_cnt(&ptr, len, log_offset, rlen);
	(*record_cnt)++;
	*data_cnt += rlen;

sprinkled in three places and wondered why that couldn't have been a
single function.  Eh, well.

Leaving the ophdr manipulations as separate clauses actually helps me to
figure out /why/ they're different.

> 
> > Indeed, I want xlog_write to move away from iclogs because I want to
> > use this code with direct mapped pmem regions, not just fixed memory
> > buffers held in iclogs.
> > 
> 
> That context and how that relates the proposed structure is not clear to
> me. That said, I _thought_ I looked through far enough into this series
> to grok how intertwined the resulting structure might have been with
> subsequent patches in order to provide thoughtful feedback, but I could
> be mistaken.
> 
> > IOWs, the code as it stands is a beginning, not an end. And even as
> > a beginning, it works, is much better and faster than the current
> > code, has been tested for some time now, can be further factored to
> > make it simpler, easier to understand and provide infrastructure for
> > new features.
> > 
> > 
> > > That puts the whole thing back into a single high level walk and thus
> > > reintroduces the need for some of the continuation vs. non-continuation
> > > tracking wrt to the op header and iclog, but ISTM that complexity can be
> > > managed by the continuation abstraction you've already started to
> > > introduce (as opposed to the current scheme of conditionally
> > > accumulating data_cnt). It might even be fine to dump some of the
> > > requisite state into a context struct to carry between iclog reservation
> > > and copy finish processing rather than pass around so many independent
> > > and poorly named variables like the current upstream implementation
> > > does, but that's probably getting too deep into the weeds.
> > > 
> > > FWIW, I can also see an approach of moving from the implementation in
> > > this patch toward something like the above, but I'm not sure I'd want to
> > > subject to the upstream code to that process...
> > 
> > This is exactly what upstream is for - iterative improvement via
> > small steps. This is the first step of many, and what you propose
> > takes the code in the wrong direction for the steps I've already
> > taken and are planning to take.
> > 
> > Perfect is the enemy of good, and if upstream is not the place to
> > make iterative improvements like this that build towards a bigger
> > picture goal, then where the hell are we supposed to do them?
> > 
> 
> Not every incremental development step is necessarily a suitable point
> for an upstream release. My comment above is basically to say that I
> think this refactoring is nearly to that point, but should go a bit
> further to reduce the duplication. If the argument against that step is
> dependence on future work, then propose the factoring close enough to
> that work such that sufficient context is available to review.

For a short patchset I agree, but I don't think dumping the /next/ forty
patches on the list as an RFC is going to help much.  We're keyed to the
kernel release cycle, which means (to me anyway) that the criteria is a
little different for Gigantic Patchsets that are never going to land in
a single cycle.

Whereas for small patchsets I think it's reasonable to ask that all the
weird warts get fixed by the end of review, for bigger things I think
it's ok to lower that standard to "Can we understand it in case the
author disappears; and does it not introduce obvious regressions"?

I've applied the same principle to this really long story arc of adding
parent pointers to the filesystem -- yes, the delayed xattrs series has
some strange things in it structurally, but I was ok with only asking
for obvious cleanups (like fixing the naming inconsistencies) so that we
can get to the next series, which justifies all the slicing and dicing
by turning the xattr state machine into a deferred log item.

Posting the full set as a git branch somewhere so at least we can pull
it and see the even bigger picture might, though.  It's helped immensely
for reviewing the delayed xattrs series and throwing some early feedback
to Allison w.r.t. deferred xattrs.

All right, back to the latest posting.

--D

> 
> Brian
> 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
