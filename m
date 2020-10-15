Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF7E2C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 21:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A35B2076A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 21:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgJOVmE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 17:42:04 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34108 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726392AbgJOVmD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 17:42:03 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 02CB058C7B6;
        Fri, 16 Oct 2020 08:42:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kTB0a-000vDe-4j; Fri, 16 Oct 2020 08:42:00 +1100
Date:   Fri, 16 Oct 2020 08:42:00 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/27] libxfs: convert sync IO buftarg engine to AIO
Message-ID: <20201015214200.GK7391@dread.disaster.area>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-28-david@fromorbit.com>
 <20201015182607.GA9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015182607.GA9832@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=dqtIDHtTHPJqPkzQoY4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 11:26:07AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 15, 2020 at 06:21:55PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Simple per-ag thread based completion engine. Will have issues with
> > large AG counts.
> 
> Hm, I missed how any of this is per-AG... all I saw was an aio control
> context that's attached to the buftarg.

Stale - I got rid of the per-ag AIO structures because having 500
completion threads in gdb is a PITA and it provided no better
performance. i.e. it had problems with large AG counts.

> > XXX: should this be combined with the struct btcache?
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  include/atomic.h           |   7 +-
> >  include/builddefs.in       |   2 +-
> >  include/platform_defs.h.in |   1 +
> >  libxfs/buftarg.c           | 202 +++++++++++++++++++++++++++++++------
> >  libxfs/xfs_buf.h           |   6 ++
> >  libxfs/xfs_buftarg.h       |   7 ++
> >  6 files changed, 191 insertions(+), 34 deletions(-)
> > 
> > diff --git a/include/atomic.h b/include/atomic.h
> > index 5860d7897ae5..8727fc4ddae9 100644
> > --- a/include/atomic.h
> > +++ b/include/atomic.h
> > @@ -27,8 +27,11 @@ typedef	int64_t	atomic64_t;
> >  #define atomic_inc_return(a)	uatomic_add_return(a, 1)
> >  #define atomic_dec_return(a)	uatomic_sub_return(a, 1)
> >  
> > -#define atomic_inc(a)		atomic_inc_return(a)
> > -#define atomic_dec(a)		atomic_inc_return(a)
> > +#define atomic_add(a, v)	uatomic_add(a, v)
> > +#define atomic_sub(a, v)	uatomic_sub(a, v)
> > +
> > +#define atomic_inc(a)		uatomic_inc(a)
> > +#define atomic_dec(a)		uatomic_dec(a)
> 
> Does this belong in the liburcu patch?

Probably.

> 
> >  
> >  #define atomic_dec_and_test(a)	(atomic_dec_return(a) == 0)
> >  
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index 78eddf4a9852..c20a48f6258c 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -29,7 +29,7 @@ LIBEDITLINE = @libeditline@
> >  LIBBLKID = @libblkid@
> >  LIBDEVMAPPER = @libdevmapper@
> >  LIBINIH = @libinih@
> > -LIBXFS = $(TOPDIR)/libxfs/libxfs.la
> > +LIBXFS = $(TOPDIR)/libxfs/libxfs.la -laio
> 
> This needs all the autoconf magic to complain if libaio isn't installed,
> right?

Yes.

> >  	/*
> > -	 * This is a bit of a hack until we get AIO that runs completions.
> > -	 * Success is treated as a completion here, but IO errors are handled as
> > -	 * a submission error and are handled by the caller. AIO will clean this
> > -	 * up.
> > +	 * don't overwrite existing errors - otherwise we can lose errors on
> > +	 * buffers that require multiple bios to complete.
> > +	 *
> > +	 * We check that the returned length was the same as specified for this
> > +	 * IO. Note that this onyl works for read and write - if we start
> > +	 * using readv/writev for discontiguous buffers then this needs more
> > +	 * work.
> 
> Interesting RFC, though I gather discontig buffers don't work yet?

Right they don't work yet. I mention that in a couple of places.

> Or hmm maybe there's something funny going on with
> xfs_buftarg_submit_io_map?  You didn't post a git branch link, so it's
> hard(er) to just rummage around on my own. :/
> 
> This seems like a reasonable restructuring to allow asynchronous io.
> It's sort of a pity that this isn't modular enough to allow multiple IO
> engines (synchronous system calls and io_uring come to mine) but that
> can come later.

Making it modular is easy enough, but that can be done independently
of this buffer cache enabling patchset.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
