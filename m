Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF979C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 03:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9532D61007
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 03:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238064AbhESDT4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 May 2021 23:19:56 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:60795 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237833AbhESDT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 May 2021 23:19:56 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 1042E1AFB95;
        Wed, 19 May 2021 13:18:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljCjC-002dLH-Kr; Wed, 19 May 2021 13:18:34 +1000
Date:   Wed, 19 May 2021 13:18:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/45] xfs: reserve space and initialise xlog_op_header
 in item formatting
Message-ID: <20210519031834.GK2893@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-26-david@fromorbit.com>
 <YFDGTRSdC/PtkVLv@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFDGTRSdC/PtkVLv@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=rEJzrc2eJ1LDOeUvH98A:9 a=_PaAOGKsZPXYtIGc:21 a=nh9ReM-P0FLscLe1:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 16, 2021 at 10:53:01AM -0400, Brian Foster wrote:
> On Fri, Mar 05, 2021 at 04:11:23PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Current xlog_write() adds op headers to the log manually for every
> > log item region that is in the vector passed to it. While
> > xlog_write() needs to stamp the transaction ID into the ophdr, we
> > already know it's length, flags, clientid, etc at CIL commit time.
> > 
> > This means the only time that xlog write really needs to format and
> > reserve space for a new ophdr is when a region is split across two
> > iclogs. Adding the opheader and accounting for it as part of the
> > normal formatted item region means we simplify the accounting
> > of space used by a transaction and we don't have to special case
> > reserving of space in for the ophdrs in xlog_write(). It also means
> > we can largely initialise the ophdr in transaction commit instead
> > of xlog_write, making the xlog_write formatting inner loop much
> > tighter.
> > 
> > xlog_prepare_iovec() is now too large to stay as an inline function,
> > so we move it out of line and into xfs_log.c.
> > 
> > Object sizes:
> > text	   data	    bss	    dec	    hex	filename
> > 1125934	 305951	    484	1432369	 15db31 fs/xfs/built-in.a.before
> > 1123360	 305951	    484	1429795	 15d123 fs/xfs/built-in.a.after
> > 
> > So the code is a roughly 2.5kB smaller with xlog_prepare_iovec() now
> > out of line, even though it grew in size itself.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Looks mostly reasonable, a couple or so questions...
> 
> >  fs/xfs/xfs_log.c     | 115 +++++++++++++++++++++++++++++--------------
> >  fs/xfs/xfs_log.h     |  42 +++-------------
> >  fs/xfs/xfs_log_cil.c |  25 +++++-----
> >  3 files changed, 99 insertions(+), 83 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 429cb1e7cc67..98de45be80c0 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -89,6 +89,62 @@ xlog_iclogs_empty(
> >  static int
> >  xfs_log_cover(struct xfs_mount *);
> >  
> > +/*
> > + * We need to make sure the buffer pointer returned is naturally aligned for the
> > + * biggest basic data type we put into it. We have already accounted for this
> > + * padding when sizing the buffer.
> > + *
> > + * However, this padding does not get written into the log, and hence we have to
> > + * track the space used by the log vectors separately to prevent log space hangs
> > + * due to inaccurate accounting (i.e. a leak) of the used log space through the
> > + * CIL context ticket.
> > + *
> > + * We also add space for the xlog_op_header that describes this region in the
> > + * log. This prepends the data region we return to the caller to copy their data
> > + * into, so do all the static initialisation of the ophdr now. Because the ophdr
> > + * is not 8 byte aligned, we have to be careful to ensure that we align the
> > + * start of the buffer such that the region we return to the call is 8 byte
> > + * aligned and packed against the tail of the ophdr.
> > + */
> > +void *
> > +xlog_prepare_iovec(
> > +	struct xfs_log_vec	*lv,
> > +	struct xfs_log_iovec	**vecp,
> > +	uint			type)
> > +{
> > +	struct xfs_log_iovec	*vec = *vecp;
> > +	struct xlog_op_header	*oph;
> > +	uint32_t		len;
> > +	void			*buf;
> > +
> > +	if (vec) {
> > +		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
> > +		vec++;
> > +	} else {
> > +		vec = &lv->lv_iovecp[0];
> > +	}
> > +
> > +	len = lv->lv_buf_len + sizeof(struct xlog_op_header);
> > +	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
> > +		lv->lv_buf_len = round_up(len, sizeof(uint64_t)) -
> > +					sizeof(struct xlog_op_header);
> > +	}
> > +
> > +	vec->i_type = type;
> > +	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
> > +
> > +	oph = vec->i_addr;
> > +	oph->oh_clientid = XFS_TRANSACTION;
> > +	oph->oh_res2 = 0;
> > +	oph->oh_flags = 0;
> > +
> > +	buf = vec->i_addr + sizeof(struct xlog_op_header);
> > +	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));
> 
> Why is it the buffer portion needs to be 8 byte aligned but not ->i_addr
> itself?

Same reason the returned buffer has always been 8 byte aligned -
because we cast ixit  to on-disk structures that assume 8 byte
memory alignment of the structure. e.g. when formatting inodes,
intents, etc.

We don't care about the ophdr itself, because it only contains
4 byte aligned variables (32 bit) and the log only requires them to
be 4 byte alignment of regions (asserts in xlog_write() that it
casts to ophdrs to update them...

> >  static void
> >  xlog_grant_sub_space(
> >  	struct xlog		*log,
> ...
> > @@ -2149,18 +2205,7 @@ xlog_write_calc_vec_length(
> >  			xlog_tic_add_region(ticket, vecp->i_len, vecp->i_type);
> >  		}
> >  	}
> > -
> > -	/* Don't account for regions with embedded ophdrs */
> > -	if (optype && headers > 0) {
> > -		headers--;
> > -		if (optype & XLOG_START_TRANS) {
> > -			ASSERT(headers >= 1);
> > -			headers--;
> > -		}
> > -	}
> > -
> >  	ticket->t_res_num_ophdrs += headers;
> > -	len += headers * sizeof(struct xlog_op_header);
> 
> Hm, this seems to suggest something was off wrt to ->t_res_num_ophdrs
> prior to this change.  Granted this looks like it's just a debug field,
> but the previous logic filtered out embedded op headers unconditionally
> whereas now it looks like we go back to accounting them. Am I missing
> something?

Nothign wrong here with the old or the new code. The old code *adds*
the unaccounted ophdr space for each region here, but now everything
has an embedded opheader it's accounted directly to the region size.
Hence the size of the regions we summed in the above loop already
accounts for the ophdr space and we no longer need to account for
opheaders individually here.

> > @@ -2404,21 +2448,25 @@ xlog_write(
> >  			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
> >  
> >  			/*
> > -			 * The XLOG_START_TRANS has embedded ophdrs for the
> > -			 * start record and transaction header. They will always
> > -			 * be the first two regions in the lv chain. Commit and
> > -			 * unmount records also have embedded ophdrs.
> > +			 * Regions always have their ophdr at the start of the
> > +			 * region, except for:
> > +			 * - a transaction start which has a start record ophdr
> > +			 *   before the first region ophdr; and
> > +			 * - the previous region didn't fully fit into an iclog
> > +			 *   so needs a continuation ophdr to prepend the region
> > +			 *   in this new iclog.
> >  			 */
> > -			if (optype) {
> > -				ophdr = reg->i_addr;
> > -				if (index)
> > -					optype &= ~XLOG_START_TRANS;
> > -			} else {
> > +			ophdr = reg->i_addr;
> > +			if (optype && index) {
> > +				optype &= ~XLOG_START_TRANS;
> > +			} else if (partial_copy) {
> >                                  ophdr = xlog_write_setup_ophdr(ptr, ticket);
> >  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
> >  					   sizeof(struct xlog_op_header));
> >  				added_ophdr = true;
> >  			}
> 
> So in the partial_copy continuation case we're still stamping an ophdr
> directly into the iclog. Otherwise we're processing/modifying flags and
> whatnot on the ophdr already stamped at commit time in the log vector.
> However, this is Ok because a relog would reformat the op header.

Right. We don't know ahead of time when a region is going to be
split across two iclogs, so we still have to handle the case of
adding a ophdr for a split region. This gets much simpler later on
in the series as the xlog_write() code is factored.

> > +			ASSERT(copy_len > 0);
> > +			memcpy(ptr, reg->i_addr + copy_off, copy_len);
> > +			xlog_write_adv_cnt(&ptr, &len, &log_offset, copy_len);
> > +
> 
> I assume the checks in xlog_write_copy_finish() to require a minimum of
> one op header worth of space in the iclog prevent doing a partial write
> across an embedded op header boundary, but it would be nice to have an
> assert or something that ensures that. For example, assert for something
> like if a partial_copy occurs, partial_copy_len was at least the length
> of an op header into the region.

This code is completely reworked later in the series and these
whacky corner cases largely go away. There's not much point in
making this "robust" because of this...

> 
> >  			if (added_ophdr)
> >  				copy_len += sizeof(struct xlog_op_header);
> >  			record_cnt++;
> ...
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 0c81c13e2cf6..7a5e6bdb7876 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -181,13 +181,20 @@ xlog_cil_alloc_shadow_bufs(
> >  		}
> >  
> >  		/*
> > -		 * We 64-bit align the length of each iovec so that the start
> > -		 * of the next one is naturally aligned.  We'll need to
> > -		 * account for that slack space here. Then round nbytes up
> > -		 * to 64-bit alignment so that the initial buffer alignment is
> > -		 * easy to calculate and verify.
> > +		 * We 64-bit align the length of each iovec so that the start of
> > +		 * the next one is naturally aligned.  We'll need to account for
> > +		 * that slack space here.
> > +		 *
> 
> Related to my question above, I'm a little confused by the (preexisting)
> comment. If the start of the next iovec is now the ophdr, doesn't that
> mean the "start of the next one (iovec)" is technically no longer
> naturally aligned?

The ophdr doesn't need to be 64 bit aligned, just the
buffer that is returned from xlog_prepare_iovec(). That means we
still have to guarantee space in the buffer for that to be rounded
to 64 bits if it's not already aligned. All of the iovecs might
require padding to align them, so the presence of the ophdr doesn't
really change anything at all here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
