Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0009EC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Nov 2021 23:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhKVXfW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231550AbhKVXfW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Nov 2021 18:35:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA33360F48;
        Mon, 22 Nov 2021 23:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637623934;
        bh=7mvwBCqU1RVd7InNv/a8rYsJBzqBjajU+75dLuUO/y0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h1aqRkM5hNP/+FMq96ydo/uxeaXT+nGo/wLN5+gvJps8spYftsNh0kySFwfxDMLNs
         hcGWAxPyNm7RkaZkFWlJ0ytSUnusME1LEXvDoRSzX58B8bm+kYmS++Po8KfO2pqEnG
         56iB7u0bnIWUW1lZjI6Dblrx5mMtleXSLr3/Cb+5mdUQXsuv2ThxB7oaM8vaIK6lH2
         KNw9BO2e1FcT6mP1s0vI8b2Js8j943GmrDHv0LiiK2okHrxzpNvWOdNissEbR+NObD
         hmMsquj97PgG+k5mxw/+v4JTMuF2DDCoVJ7YPk6OF8QhMyir4oUiLSsW45sS95jYHP
         DZj4W6ErTLqSQ==
Date:   Mon, 22 Nov 2021 15:32:14 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Helmut Grohne <helmut@subdivi.de>,
        Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] debian: Fix FTCBFS: Skip crc32 test (Closes: #999879)
Message-ID: <20211122233214.GB266024@magnolia>
References: <20211119171241.102173-1-bage@debian.org>
 <20211119171241.102173-3-bage@debian.org>
 <20211119231105.GA449541@dread.disaster.area>
 <YZikmB1aLZUX8FC7@alf.mars>
 <20211120171548.GB24307@magnolia>
 <20211120222009.GB449541@dread.disaster.area>
 <20211120222719.GC449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211120222719.GC449541@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 21, 2021 at 09:27:19AM +1100, Dave Chinner wrote:
> On Sun, Nov 21, 2021 at 09:20:09AM +1100, Dave Chinner wrote:
> > On Sat, Nov 20, 2021 at 09:15:48AM -0800, Darrick J. Wong wrote:
> > > On Sat, Nov 20, 2021 at 08:32:40AM +0100, Helmut Grohne wrote:
> > > > Hi Dave,
> > > > 
> > > > On Sat, Nov 20, 2021 at 10:11:05AM +1100, Dave Chinner wrote:
> > > > > I don't get it. The crcselftest does not use liburcu in
> > > > > any way, nor does it try to link against liburcu, so it should not
> > > > > fail because other parts of xfsprogs use liburcu.
> > > > > 
> > > > > What's the build error that occurs?
> > > > 
> > > > As the build log shows, that's not technically accurate. You can find
> > > > logs of test builds for various architecture combinations at
> > > > http://crossqa.debian.net/src/xfsprogs. This is also available as a link
> > > > called "cross" in https://tracker.debian.org/xfsprogs.
> > > > 
> > > > The relevant part is:
> > > > |     [TEST]    CRC32
> > > > | In file included from crc32.c:35:
> > > > | ../include/platform_defs.h:27:10: fatal error: urcu.h: No such file or directory
> > > > |    27 | #include <urcu.h>
> > > > |       |          ^~~~~~~~
> > > > | compilation terminated.
> > > > 
> > > > I failed to figure a good way of dropping either include directive.
> > > > 
> > > > > We need to fix the generic cross-build problem in the xfsprogs code,
> > > > > not slap a distro-specific build band-aid over it.
> > > > 
> > > > I fully agree with this in principle. However, when I fail to find that
> > > > upstreamable solution, I try to at least provide a Debian-specific
> > > > solution to iterate from.
> > > > 
> > > > Can you propose a way to drop either #include?
> > > 
> > > Frankly I don't really see the value in crc32selftest when cross
> > > compiling -- sure, the crc32c code works correctly on the build host,
> > > but that proves nothing about the (cross-)built binaries that end up in
> > > the package.
> > 
> > Yup, that's pretty much what I was getting at.
> 
> Though this is pretty simple and should just work, too:
> 
> --- a/libfrog/crc32.c
> +++ b/libfrog/crc32.c
> @@ -29,10 +29,11 @@
>   * match the hardware acceleration available on Intel CPUs.
>   */
>  
> +#include <stdio.h>
> +#include <sys/types.h>
>  #include <inttypes.h>
>  #include <asm/types.h>
>  #include <sys/time.h>
> -#include "platform_defs.h"
>  /* For endian conversion routines */
>  #include "xfs_arch.h"
>  #include "crc32defs.h"

That works for my system, though I don't do cross builds frequently so I
don't really know if it fixes those outside of my toy environment.  I'll
send a bigger patch to add selftest to mkfs/repair tomorrow.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
