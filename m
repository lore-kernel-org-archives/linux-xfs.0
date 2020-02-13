Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3E6C352A3
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 23:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04D6324671
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 23:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgBMXs0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 18:48:26 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39064 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727594AbgBMXs0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Feb 2020 18:48:26 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3A3D5822798;
        Fri, 14 Feb 2020 10:48:19 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j2ODS-0004As-Mv; Fri, 14 Feb 2020 10:48:18 +1100
Date:   Fri, 14 Feb 2020 10:48:18 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH, RFC] libxfs: use FALLOC_FL_ZERO_RANGE in
 libxfs_device_zero
Message-ID: <20200213234818.GV10776@dread.disaster.area>
References: <4bc3be27-b09d-a708-f053-6f7240642667@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bc3be27-b09d-a708-f053-6f7240642667@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=g9RGLWMb-twFe10-mMIA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 13, 2020 at 03:12:24PM -0600, Eric Sandeen wrote:
> I had a request from someone who cared about mkfs speed(!)
> over a slower network block device to look into using faster
> zeroing methods, particularly for the log, during mkfs.xfs.
> 
> e2fsprogs already does this, thanks to some guy named Darrick:
> 
> /*
>  * If we know about ZERO_RANGE, try that before we try PUNCH_HOLE because
>  * ZERO_RANGE doesn't unmap preallocated blocks.  We prefer fallocate because
>  * it always invalidates page cache, and libext2fs requires that reads after
>  * ZERO_RANGE return zeroes.
>  */
> static int __unix_zeroout(int fd, off_t offset, off_t len)
> {
>         int ret = -1;
> 
> #if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_ZERO_RANGE)
>         ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, offset, len);
>         if (ret == 0)
>                 return 0;
> #endif
> #if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_PUNCH_HOLE) && defined(FALLOC_FL_KEEP_SIZE)
>         ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
>                         offset,  len);
>         if (ret == 0)
>                 return 0;
> #endif
>         errno = EOPNOTSUPP;
>         return ret;
> }
> 
> and nobody has exploded so far, AFAIK.  :)  So, floating this idea
> for xfsprogs.  I'm a little scared of the second #ifdef block above, but
> if that's really ok/consistent/safe we could add it too.

If FALLOC_FL_PUNCH_HOLE is defined, then FALLOC_FL_KEEP_SIZE is
guaranteed to be defined, so that condition check is somewhat
redundant. See commit 79124f18b335 ("fs: add hole punching to
fallocate")....

> The patch moves some defines around too, I could split that up and resend
> if this isn't laughed out of the room.
> 
> Thanks,
> -Eric
> 
> =====
> 
> libxfs: use FALLOC_FL_ZERO_RANGE in libxfs_device_zero
> 
> I had a request from someone who cared about mkfs speed(!)
> over a slower network block device to look into using faster
> zeroing methods, particularly for the log, during mkfs.
> 
> Using FALLOC_FL_ZERO_RANGE is faster in this case than writing
> a bunch of zeros across a wire.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/include/linux.h b/include/linux.h
> index 8f3c32b0..425badb5 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -113,6 +113,26 @@ static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
>  	uuid_copy(*dst, *src);
>  }
>  
> +#ifndef FALLOC_FL_PUNCH_HOLE
> +#define FALLOC_FL_PUNCH_HOLE	0x02
> +#endif
> +
> +#ifndef FALLOC_FL_COLLAPSE_RANGE
> +#define FALLOC_FL_COLLAPSE_RANGE 0x08
> +#endif
> +
> +#ifndef FALLOC_FL_ZERO_RANGE
> +#define FALLOC_FL_ZERO_RANGE 0x10
> +#endif
> +
> +#ifndef FALLOC_FL_INSERT_RANGE
> +#define FALLOC_FL_INSERT_RANGE 0x20
> +#endif
> +
> +#ifndef FALLOC_FL_UNSHARE_RANGE
> +#define FALLOC_FL_UNSHARE_RANGE 0x40
> +#endif

These were added to allow xfs_io to test these operations before
there was userspace support for them. I do not think we should
propagate them outside of xfs_io - if they are not supported by the
distro at build time, we shouldn't attempt to use them in mkfs.

i.e. xfs_io is test-enablement code for developers, mkfs.xfs is
production code for users, so different rules kinda exist for
them...

> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index fbcc963a..b4e8864b 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -105,6 +105,10 @@ CFILES = cache.c \
>  #
>  #LCFLAGS +=
>  
> +ifeq ($(HAVE_FALLOCATE),yes)
> +LCFLAGS += -DHAVE_FALLOCATE
> +endif

HAVE_FALLOCATE comes from an autoconf test. I suspect that this
needs to be made more finegrained, testing for fallocate() features,
not just just whether the syscall exists. And the above should
probably be in include/builddefs.in so that it's available to all
of xfsprogs, not just libxfs code...

> +
>  FCFLAGS = -I.
>  
>  LTLIBS = $(LIBPTHREAD) $(LIBRT)
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 0d9d7202..94f63bbf 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -4,6 +4,9 @@
>   * All Rights Reserved.
>   */
>  
> +#if defined(HAVE_FALLOCATE)
> +#include <linux/falloc.h>
> +#endif

Urk. That should be in include/linux.h, right?

>  
>  #include "libxfs_priv.h"
>  #include "init.h"
> @@ -60,9 +63,21 @@ int
>  libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>  {
>  	xfs_off_t	start_offset, end_offset, offset;
> -	ssize_t		zsize, bytes;
> +	ssize_t		zsize, bytes, len_bytes;
>  	char		*z;
> -	int		fd;
> +	int		ret, fd;
> +
> +	fd = libxfs_device_to_fd(btp->dev);
> +	start_offset = LIBXFS_BBTOOFF64(start);
> +	end_offset = LIBXFS_BBTOOFF64(start + len) - start_offset;
> +
> +#if defined(HAVE_FALLOCATE)
> +	/* try to use special zeroing methods, fall back to writes if needed */
> +	len_bytes = LIBXFS_BBTOOFF64(len);
> +	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes);
> +	if (ret == 0)
> +		return 0;
> +#endif

I kinda dislike the "return if success" hidden inside the ifdef -
it's not a code pattern I'd expect to see. This is what I'd tend
to expect in include/linux.h:

#if defined(HAVE_FALLOCATE_ZERO_RANGE)
static inline int
platform_zero_range(
	int		fd,
	xfs_off_t	start_offset,
	xfs_off_t	end_offset)
{
	int		ret;

	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes);
	if (!ret)
		return 0;
	return -errno;
}
#else
#define platform_zero_range(fd, s, o)	(true)
#endif

and then the code in libxfs_device_zero() does:

	error = platform_zero_range(fd, start_offset, len_bytes);
	if (!error)
		return 0;

without adding nasty #defines...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
