Return-Path: <SRS0=Ip4f=4C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F330C352A3
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 00:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5056217F4
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 00:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgBNAZn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 19:25:43 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49312 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727594AbgBNAZn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Feb 2020 19:25:43 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 085F53A6096;
        Fri, 14 Feb 2020 11:25:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j2Onb-0004Rw-94; Fri, 14 Feb 2020 11:25:39 +1100
Date:   Fri, 14 Feb 2020 11:25:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH, RFC] libxfs: use FALLOC_FL_ZERO_RANGE in
 libxfs_device_zero
Message-ID: <20200214002539.GW10776@dread.disaster.area>
References: <4bc3be27-b09d-a708-f053-6f7240642667@sandeen.net>
 <20200213234818.GV10776@dread.disaster.area>
 <15f9a679-c83e-fede-25fe-2f2cdf940d86@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15f9a679-c83e-fede-25fe-2f2cdf940d86@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=6ywtPXZoFtxdahtW_SoA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 13, 2020 at 05:57:17PM -0600, Eric Sandeen wrote:
> On 2/13/20 5:48 PM, Dave Chinner wrote:
> > On Thu, Feb 13, 2020 at 03:12:24PM -0600, Eric Sandeen wrote:
> >> I had a request from someone who cared about mkfs speed(!)
> >> over a slower network block device to look into using faster
> >> zeroing methods, particularly for the log, during mkfs.xfs.
> >>
> >> e2fsprogs already does this, thanks to some guy named Darrick:
> >>
> >> /*
> >>  * If we know about ZERO_RANGE, try that before we try PUNCH_HOLE because
> >>  * ZERO_RANGE doesn't unmap preallocated blocks.  We prefer fallocate because
> >>  * it always invalidates page cache, and libext2fs requires that reads after
> >>  * ZERO_RANGE return zeroes.
> >>  */
> >> static int __unix_zeroout(int fd, off_t offset, off_t len)
> >> {
> >>         int ret = -1;
> >>
> >> #if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_ZERO_RANGE)
> >>         ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, offset, len);
> >>         if (ret == 0)
> >>                 return 0;
> >> #endif
> >> #if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_PUNCH_HOLE) && defined(FALLOC_FL_KEEP_SIZE)
> >>         ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> >>                         offset,  len);
> >>         if (ret == 0)
> >>                 return 0;
> >> #endif
> >>         errno = EOPNOTSUPP;
> >>         return ret;
> >> }
> >>
> >> and nobody has exploded so far, AFAIK.  :)  So, floating this idea
> >> for xfsprogs.  I'm a little scared of the second #ifdef block above, but
> >> if that's really ok/consistent/safe we could add it too.
> > 
> > If FALLOC_FL_PUNCH_HOLE is defined, then FALLOC_FL_KEEP_SIZE is
> > guaranteed to be defined, so that condition check is somewhat
> > redundant. See commit 79124f18b335 ("fs: add hole punching to
> > fallocate")....
> 
> Style aside, is that 2nd zeroing method something we want to try?

Oh, I misunderstood what you were asking.  I don't think we want to
implement that.

e.g. If it's a pre-allocated image file or block device on
sparse-capable storage being mkfs'd, then the user really doesn't
want it punched out, do they?

And it's for the journal: any ENOSPC error from the block device in
the journal is immediately fatal to the filesystem. Hence I think
we should not punch out the journal blocks that already are allocated
in the storage.

And, really, the space may have already been punched out via
attempting to trim the device (i.e. "-K" mkfs option wasn't set), in
which case punching here is redundant.

Also, libxfs_device_zero() is called by xfs_repair: do we want
xfs_repair to be punching out blocks for the realtime bitmap and
summary storage? I don't think we want that to happen, either.

Fast zeroing, yes. Punching out allocated storage, no.

> >> +#define FALLOC_FL_COLLAPSE_RANGE 0x08
> >> +#endif
> >> +
> >> +#ifndef FALLOC_FL_ZERO_RANGE
> >> +#define FALLOC_FL_ZERO_RANGE 0x10
> >> +#endif
> >> +
> >> +#ifndef FALLOC_FL_INSERT_RANGE
> >> +#define FALLOC_FL_INSERT_RANGE 0x20
> >> +#endif
> >> +
> >> +#ifndef FALLOC_FL_UNSHARE_RANGE
> >> +#define FALLOC_FL_UNSHARE_RANGE 0x40
> >> +#endif
> > 
> > These were added to allow xfs_io to test these operations before
> > there was userspace support for them. I do not think we should
> > propagate them outside of xfs_io - if they are not supported by the
> > distro at build time, we shouldn't attempt to use them in mkfs.
> > 
> > i.e. xfs_io is test-enablement code for developers, mkfs.xfs is
> > production code for users, so different rules kinda exist for
> > them...
> 
> Fair enough.  people /could/ use newer xfsprogs on older kernels, but...
> those defines are getting pretty old by now in any case.

*nod*

> It's probably not terrible to just fail the build on a system that doesn't
> have falloc.h, by now?

That might be going a bit far. fallocate() in most cases is not
critical to the correct functioning of the production tools, so if
it's not present it shouldn't break anything.

> >> diff --git a/libxfs/Makefile b/libxfs/Makefile
> >> index fbcc963a..b4e8864b 100644
> >> --- a/libxfs/Makefile
> >> +++ b/libxfs/Makefile
> >> @@ -105,6 +105,10 @@ CFILES = cache.c \
> >>  #
> >>  #LCFLAGS +=
> >>  
> >> +ifeq ($(HAVE_FALLOCATE),yes)
> >> +LCFLAGS += -DHAVE_FALLOCATE
> >> +endif
> > 
> > HAVE_FALLOCATE comes from an autoconf test. I suspect that this
> > needs to be made more finegrained, testing for fallocate() features,
> > not just just whether the syscall exists. And the above should
> > probably be in include/builddefs.in so that it's available to all
> > of xfsprogs, not just libxfs code...
> 
> But that's testing the kernel on the build host, right?  What's the
> point of that?  Or am I misunderstanding?

Who builds their distro binaries on a userspace that doesn't contain
the headers and libaries the distro is going to ship with?

That's the whole point of "build-root" infrastructure, right? i.e.
build against what you are going to ship, not what is installed on
the build machine....

> >> +	fd = libxfs_device_to_fd(btp->dev);
> >> +	start_offset = LIBXFS_BBTOOFF64(start);
> >> +	end_offset = LIBXFS_BBTOOFF64(start + len) - start_offset;
> >> +
> >> +#if defined(HAVE_FALLOCATE)
> >> +	/* try to use special zeroing methods, fall back to writes if needed */
> >> +	len_bytes = LIBXFS_BBTOOFF64(len);
> >> +	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes);
> >> +	if (ret == 0)
> >> +		return 0;
> >> +#endif
> > 
> > I kinda dislike the "return if success" hidden inside the ifdef -
> > it's not a code pattern I'd expect to see. This is what I'd tend
> > to expect in include/linux.h:
> > 
> > #if defined(HAVE_FALLOCATE_ZERO_RANGE)
> > static inline int
> > platform_zero_range(
> > 	int		fd,
> > 	xfs_off_t	start_offset,
> > 	xfs_off_t	end_offset)
> > {
> > 	int		ret;
> > 
> > 	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes);
> > 	if (!ret)
> > 		return 0;
> > 	return -errno;
> > }
> > #else
> > #define platform_zero_range(fd, s, o)	(true)
> > #endif
> > 
> > and then the code in libxfs_device_zero() does:
> > 
> > 	error = platform_zero_range(fd, start_offset, len_bytes);
> > 	if (!error)
> > 		return 0;
> > 
> > without adding nasty #defines...
> 
> Yeah that's much better.  Tho I hate adding more platform_* stuff when really
> we're down to only one platform but maybe that's a project for another day.

There's more than one linux "platform" we have to support, and this
abstraction makes it easy to include new functionality in a clean
and autoconf detection friendly way... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
