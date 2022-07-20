Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590A1C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 21:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiGTVcr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 17:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiGTVcr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 17:32:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385A35D0F5
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 14:32:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4EBAB82214
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 21:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E374C3411E;
        Wed, 20 Jul 2022 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658352763;
        bh=kCz4TbX0FfhHFFTYB2vxItmT0aKNQmuOQg8zg8+V56w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ja+EhdWhKtbyDnVj6zwbPgdK0YDkhCG14KkUnE2hGos5Pbxx2YvK+PM8wR93sqFBx
         ZuRb2qcJkx2k1k27yHmSwWd33JDRY5w3M7ScO8XNP0chBedK8Er1wkU+6u++FA+XZs
         2/5dzs+vIppEaAi5mymLSTWmraxWiSnIWkx1UMTtjrk1jxYrgPeFGvagTlA3guNi6C
         Y5W+X/3jswi2OPSNiJa4exb9WzZ6STz0D09Q8RntrH+/uJB8MPkqemeC5Mek3VeooY
         Nrrbqd1c8US/gKsJ80lU6XPj4iIUf2BaJ5xTDGXufO8IY2MUs2ufRs9/nQRIXIoGJ+
         f5OXbtokJaFXA==
Date:   Wed, 20 Jul 2022 14:32:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-xfs@vger.kernel.org, ross.zwisler@linux.intel.com,
        david@fromorbit.com, darrick.wong@oracle.com, sandeen@sandeen.net
Subject: Re: [PATCH] xfs_io: Make HAVE_MAP_SYNC more robust
Message-ID: <Yth0es3DkTQRAxJl@magnolia>
References: <20220720205307.2345230-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720205307.2345230-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 20, 2022 at 01:53:07PM -0700, Florian Fainelli wrote:
> MIPS platforms building with recent kernel headers and the musl-libc toolchain
> will expose the following build failure:
> 
> mmap.c: In function 'mmap_f':
> mmap.c:196:12: error: 'MAP_SYNC' undeclared (first use in this function); did you mean 'MS_SYNC'?
>   196 |    flags = MAP_SYNC | MAP_SHARED_VALIDATE;
>       |            ^~~~~~~~
>       |            MS_SYNC
> mmap.c:196:12: note: each undeclared identifier is reported only once for each function it appears in
> make[4]: *** [../include/buildrules:81: mmap.o] Error 1

Didn't we already fix this?
https://lore.kernel.org/linux-xfs/20220508193029.1277260-1-fontaine.fabrice@gmail.com/

Didn't we already fix this?
https://lore.kernel.org/linux-xfs/20181116162346.456255382F@mx7.valuehost.ru/

Oh, I guess the maintainer didn't apply either of these patches, so this
has been broken for years.

Well... MAP_SYNC has been with us for a while now, perhaps it makes more
sense to remove all the override cruft and make xfs_io not export -S if
if neither kernel headers nor libc define it?

--D

> 
> The reason for that is that the linux.h header file which intends to provide a fallback definition for MAP_SYNC and MAP_SHARED_VALIDATE is included too early through:
> 
> input.h -> libfrog/projects.h -> xfs.h -> linux.h and this happens
> *before* sys/mman.h is included.
> 
> sys/mman.h -> bits/mman.h which has a:
>   #undef MAP_SYNC
> 
> see: https://git.musl-libc.org/cgit/musl/tree/arch/mips/bits/mman.h#n21
> 
> The end result is that sys/mman.h being included for the first time
> ends-up overriding the HAVE_MAP_SYNC fallbacks.
> 
> To remedy that, make sure that linux.h is updated to include sys/mman.h
> such that its fallbacks are independent of the inclusion order. As a
> consequence this forces us to ensure that we do not re-define
> accidentally MAP_SYNC or MAP_SHARED_VALIDATE so we protect against that.
> 
> Fixes: dad796834cb9 ("xfs_io: add MAP_SYNC support to mmap()")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  include/linux.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux.h b/include/linux.h
> index 3d9f4e3dca80..c3cc8e30c677 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -252,8 +252,13 @@ struct fsxattr {
>  #endif
>  
>  #ifndef HAVE_MAP_SYNC
> +#include <sys/mman.h>
> +#ifndef MAP_SYNC
>  #define MAP_SYNC 0
> +#endif
> +#ifndef MAP_SHARED_VALIDATE
>  #define MAP_SHARED_VALIDATE 0
> +#endif
>  #else
>  #include <asm-generic/mman.h>
>  #include <asm-generic/mman-common.h>
> -- 
> 2.25.1
> 
