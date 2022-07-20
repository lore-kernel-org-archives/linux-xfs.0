Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF1A0C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 22:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiGTWQi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 18:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiGTWQh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 18:16:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB9B501B0
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 15:16:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 83F9BCE2328
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 22:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB362C3411E;
        Wed, 20 Jul 2022 22:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658355392;
        bh=fN6Nep64Axu6nLVeA0lI4qG6wpxShz9mB7C6Jp/E0vU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RdOxrUkPA3Z7+8RymLDKFgG5tJJeQsjVJoUC3X6nbW3FbQ9HNZPIGx/5PTr4yS515
         lmTMI1HlpbURcEQiRRUWaKwt2HXblyOjoSm1c7Oe6AHIah7qdU6H1jpcVWRPx6Tq4F
         OC84446kfr62lrNBYaDEeTy/oYQ7s31KTY0u9g9vW0l8bbSiKVlaGa4868jdkaKGPm
         p8/0DlbYE+KWPJBsRE4fNy0qrVPvFuA3eKBvm6oUCGQjamqpS0r1hDo4rZm8X4q1ob
         2pl54iyJTDw1bawm8DVM/9ZewEzPJK1uITBLoZ4oKeOQY5MaV775UFlbEPMCgrw1CM
         Mv01CJYfhy49A==
Date:   Wed, 20 Jul 2022 15:16:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Fabrice Fontaine <fontaine.fabrice@gmail.com>,
        info@mobile-stream.com, linux-xfs@vger.kernel.org,
        ross.zwisler@linux.intel.com, david@fromorbit.com,
        darrick.wong@oracle.com, sandeen@sandeen.net
Subject: Re: [PATCH] xfs_io: Make HAVE_MAP_SYNC more robust
Message-ID: <Yth+wCDIoo0zciq/@magnolia>
References: <20220720205307.2345230-1-f.fainelli@gmail.com>
 <Yth0es3DkTQRAxJl@magnolia>
 <b33b7a02-0780-feb9-ee83-9dab2cdf3361@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b33b7a02-0780-feb9-ee83-9dab2cdf3361@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 20, 2022 at 02:40:33PM -0700, Florian Fainelli wrote:
> On 7/20/22 14:32, Darrick J. Wong wrote:
> > On Wed, Jul 20, 2022 at 01:53:07PM -0700, Florian Fainelli wrote:
> >> MIPS platforms building with recent kernel headers and the musl-libc toolchain
> >> will expose the following build failure:
> >>
> >> mmap.c: In function 'mmap_f':
> >> mmap.c:196:12: error: 'MAP_SYNC' undeclared (first use in this function); did you mean 'MS_SYNC'?
> >>   196 |    flags = MAP_SYNC | MAP_SHARED_VALIDATE;
> >>       |            ^~~~~~~~
> >>       |            MS_SYNC
> >> mmap.c:196:12: note: each undeclared identifier is reported only once for each function it appears in
> >> make[4]: *** [../include/buildrules:81: mmap.o] Error 1
> > 
> > Didn't we already fix this?
> > https://lore.kernel.org/linux-xfs/20220508193029.1277260-1-fontaine.fabrice@gmail.com/
> > 
> > Didn't we already fix this?
> > https://lore.kernel.org/linux-xfs/20181116162346.456255382F@mx7.valuehost.ru/
> 
> First off, I was not aware of these two proposed solutions so
> apologies for submitting a third (are there more) one.

No worries :)

> The common problem I see with both proposed patches is that they
> specifically tackle io/mmap.c when really any inclusion order of
> linux.h

OH, yikes, this is what goes into include/linux.h (which is also
exported as /usr/include/xfs/linux.h):

#ifndef HAVE_MAP_SYNC
#define MAP_SYNC 0
#define MAP_SHARED_VALIDATE 0
#else
#include <asm-generic/mman.h>
#include <asm-generic/mman-common.h>
#endif /* HAVE_MAP_SYNC */

xfsprogs has no business exporting redefinitions of kernel symbols to
userspace.  This innocent looking program on an x64 system:

#include <stdio.h>
#include <sys/mman.h>
#include <xfs/xfs.h>

int main(int argc, char *argv[]) {
	printf("MAP_SYNC 0x%x\n", MAP_SYNC);
}

prints "MAP_SYNC 0x0", not the "MAP_SYNC 0x80000" that you'd expect.

Ok, all this override stuff needs to die.

> and sys/mman.h could and would lead to the the same problem to
> re-surface somewhere else in a different file. So sure enough there is
> only mmap.c now, but it has been identified that this specific include
> order is problematic so we ought to address it in a general way.

Exactly.

> > 
> > Oh, I guess the maintainer didn't apply either of these patches, so this
> > has been broken for years.
> 
> Fabrice's patch is only a few months old, and but
> "info@mobile-stream.com"'s is nearly 4 years old...

Yep.

> > 
> > Well... MAP_SYNC has been with us for a while now, perhaps it makes more
> > sense to remove all the override cruft and make xfs_io not export -S if
> > if neither kernel headers nor libc define it?
> 
> Sure that would work too, but we will still end up with some MAP_SYNC
> conditional code, so the original intent of always defining it seemed
> laudable.

Oh no, if I cleaned up xfs_io mmap command, I'd also get rid of the
override stuff too.  Working on it...

--D

> 
> > 
> > --D
> > 
> >>
> >> The reason for that is that the linux.h header file which intends to provide a fallback definition for MAP_SYNC and MAP_SHARED_VALIDATE is included too early through:
> >>
> >> input.h -> libfrog/projects.h -> xfs.h -> linux.h and this happens
> >> *before* sys/mman.h is included.
> >>
> >> sys/mman.h -> bits/mman.h which has a:
> >>   #undef MAP_SYNC
> >>
> >> see: https://git.musl-libc.org/cgit/musl/tree/arch/mips/bits/mman.h#n21
> >>
> >> The end result is that sys/mman.h being included for the first time
> >> ends-up overriding the HAVE_MAP_SYNC fallbacks.
> >>
> >> To remedy that, make sure that linux.h is updated to include sys/mman.h
> >> such that its fallbacks are independent of the inclusion order. As a
> >> consequence this forces us to ensure that we do not re-define
> >> accidentally MAP_SYNC or MAP_SHARED_VALIDATE so we protect against that.
> >>
> >> Fixes: dad796834cb9 ("xfs_io: add MAP_SYNC support to mmap()")
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >> ---
> >>  include/linux.h | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >> diff --git a/include/linux.h b/include/linux.h
> >> index 3d9f4e3dca80..c3cc8e30c677 100644
> >> --- a/include/linux.h
> >> +++ b/include/linux.h
> >> @@ -252,8 +252,13 @@ struct fsxattr {
> >>  #endif
> >>  
> >>  #ifndef HAVE_MAP_SYNC
> >> +#include <sys/mman.h>
> >> +#ifndef MAP_SYNC
> >>  #define MAP_SYNC 0
> >> +#endif
> >> +#ifndef MAP_SHARED_VALIDATE
> >>  #define MAP_SHARED_VALIDATE 0
> >> +#endif
> >>  #else
> >>  #include <asm-generic/mman.h>
> >>  #include <asm-generic/mman-common.h>
> >> -- 
> >> 2.25.1
> >>
> 
> 
> -- 
> Florian
