Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41365 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbeJLD1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 23:27:52 -0400
Received: by mail-pg1-f196.google.com with SMTP id 23-v6so4664679pgc.8
        for <linux-xfs@vger.kernel.org>; Thu, 11 Oct 2018 12:59:05 -0700 (PDT)
Date: Thu, 11 Oct 2018 12:59:01 -0700
From: Brian Norris <briannorris@chromium.org>
Subject: Re: [PATCH] xfsprogs: don't include all xfs headers just for crc32
Message-ID: <20181011195859.GA114854@rodete-desktop-imager.corp.google.com>
References: <e1259a8b-b5aa-cfa2-aeab-13d63757d7a5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1259a8b-b5aa-cfa2-aeab-13d63757d7a5@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Oct 10, 2018 at 03:55:32PM -0500, Eric Sandeen wrote:
> Brian Norris reported that "The $BUILD_CC toolchain might have an
> older set of Linux headers than the $CC toolchain. It's generally
> unsafe to try to build both with the same definitions, but in
> particular, this one can cause compilation failures in the local
> crc32selftest build: [failure to find fsmap.h]"
> 
> It seems like the most straightforward thing to do here is include
> a specific set of system headers, instead of pulling in the whole
> xfs.h header chain which has multiple tests and definitions in
> place for headers that may or may not be there during the build.
> 
> Reported-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Brian, here's try #3, does this also work for you?

Tested-by: Brian Norris <briannorris@chromium.org>

This still leaves $BUILD_CFLAGS with bad entries, but as long as they
don't get used anywhere that matters, it'll be OK.

Brian

> diff --git a/libfrog/crc32.c b/libfrog/crc32.c
> index 1d52f68..220b33b 100644
> --- a/libfrog/crc32.c
> +++ b/libfrog/crc32.c
> @@ -29,8 +29,11 @@
>   * match the hardware acceleration available on Intel CPUs.
>   */
>  
> +#include <inttypes.h>
> +#include <asm/types.h>
> +#include <sys/time.h>
>  #include "platform_defs.h"
> -#include "xfs.h"
> +/* For endian conversion routines */
>  #include "xfs_arch.h"
>  #include "crc32defs.h"
>  
> 
