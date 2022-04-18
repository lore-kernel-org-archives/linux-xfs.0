Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02244C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Apr 2022 23:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbiDRXFH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Apr 2022 19:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbiDRXFG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Apr 2022 19:05:06 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF9E0BC2A
        for <linux-xfs@vger.kernel.org>; Mon, 18 Apr 2022 16:02:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 129B110E5BA1;
        Tue, 19 Apr 2022 09:02:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ngaNy-001lj6-Jb; Tue, 19 Apr 2022 09:02:22 +1000
Date:   Tue, 19 Apr 2022 09:02:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Fabrice Fontaine <fontaine.fabrice@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] io/mmap.c: fix musl build on mips64
Message-ID: <20220418230222.GN1544202@dread.disaster.area>
References: <20220418203606.760110-1-fontaine.fabrice@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418203606.760110-1-fontaine.fabrice@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=625dee00
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=NEAV23lmAAAA:8 a=YRHvXXt1AAAA:8
        a=pGLkceISAAAA:8 a=7-415B0cAAAA:8 a=pXdvw13oSBbM9zxNHrUA:9
        a=CjuIK1q_8ugA:10 a=9bw_jnHfPby8klRCszyn:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 18, 2022 at 10:36:06PM +0200, Fabrice Fontaine wrote:
> musl undefines MAP_SYNC on some architectures such as mips64 since
> version 1.1.20 and
> https://github.com/ifduyue/musl/commit/9b57db3f958d9adc3b1c7371b5c6723aaee448b7
> resulting in the following build failure:
> 
> mmap.c: In function 'mmap_f':
> mmap.c:196:33: error: 'MAP_SYNC' undeclared (first use in this function); did you mean 'MS_SYNC'?
>   196 |                         flags = MAP_SYNC | MAP_SHARED_VALIDATE;
>       |                                 ^~~~~~~~
>       |                                 MS_SYNC
> 
> To fix this build failure, include <sys/mman.h> before the other
> includes
> 
> Fixes:
>  - http://autobuild.buildroot.org/results/3296194907baf7d3fe039f59bcbf595aa8107a28
> 
> Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
> ---
>  io/mmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io/mmap.c b/io/mmap.c
> index 8c048a0a..b8609295 100644
> --- a/io/mmap.c
> +++ b/io/mmap.c
> @@ -4,9 +4,9 @@
>   * All Rights Reserved.
>   */
>  
> +#include <sys/mman.h>
>  #include "command.h"
>  #include "input.h"
> -#include <sys/mman.h>
>  #include <signal.h>
>  #include "init.h"
>  #include "io.h"

I can't see how this makes any difference to the problem, nor can I
see why you are having this issues.

From the configure output:

....
checking for MAP_SYNC... no
....

It is clear that the build has detected that MAP_SYNC does not exist
on this platform, and that means HAVE_MAP_SYNC will not be defined.
That means when xfs_io is built, io/Makefile does not add
-DHAVE_MAP_SYNC to the cflags, and so when io/mmap.c includes
io/io.h -> xfs.h -> linux.h we hit this code:

#ifndef HAVE_MAP_SYNC
#define MAP_SYNC 0
#define MAP_SHARED_VALIDATE 0
#else
#include <asm-generic/mman.h>
#include <asm-generic/mman-common.h>
#endif /* HAVE_MAP_SYNC */

Given that this is the last include in the io/mmap.c file, it should
not matter what musl is doing - this define should be overriding it
completely.

Ooooh.

input.h -> libfrog/projects.h -> xfs.h -> linux.h.

Ok, we've tangled up header includes, and that's why moving the
sys/mman.h header fixes the warning. Right, we need to untangle the
headers.

.... and my build + test rack just had a total internal power
failure of some kind, so that's as far as I can go right now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
