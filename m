Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:11439 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752320AbdEMXpt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 May 2017 19:45:49 -0400
Date: Sun, 14 May 2017 09:45:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libxfs: use crc32c slice-by-8 variant by default
Message-ID: <20170513234545.GL17542@dastard>
References: <20170513193344.GK4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170513193344.GK4519@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Sat, May 13, 2017 at 12:33:44PM -0700, Darrick J. Wong wrote:
> The crc32c code used in xfsprogs was copied directly from the Linux
> kernel.  However, that code selects slice-by-4 by default, which isn't
> the fastest -- that's slice-by-8, which trades table size for speed.
> Fix some makefile dependency problems and explicitly select the
> algorithm we want.  With this patch applied, I see about a 10% drop in
> CPU time running xfs_repair.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/Makefile    |    4 ++--
>  libxfs/crc32defs.h |    3 +++
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index 0f3759e..c5dc382 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -124,7 +124,7 @@ LDIRT = gen_crc32table crc32table.h crc32selftest
>  
>  default: crc32selftest ltdepend $(LTLIBRARY)
>  
> -crc32table.h: gen_crc32table.c
> +crc32table.h: gen_crc32table.c crc32defs.h
>  	@echo "    [CC]     gen_crc32table"
>  	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -o gen_crc32table $<
>  	@echo "    [GENERATE] $@"
> @@ -135,7 +135,7 @@ crc32table.h: gen_crc32table.c
>  # systems/architectures. Hence we make sure that xfsprogs will never use a
>  # busted CRC calculation at build time and hence avoid putting bad CRCs down on
>  # disk.
> -crc32selftest: gen_crc32table.c crc32table.h crc32.c
> +crc32selftest: gen_crc32table.c crc32table.h crc32.c crc32defs.h
>  	@echo "    [TEST]    CRC32"
>  	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -D CRC32_SELFTEST=1 crc32.c -o $@
>  	$(Q) ./$@
> diff --git a/libxfs/crc32defs.h b/libxfs/crc32defs.h
> index 64cba2c..153f44c 100644
> --- a/libxfs/crc32defs.h
> +++ b/libxfs/crc32defs.h
> @@ -1,3 +1,6 @@
> +/* Use slice-by-8, which is the fastest variant. */
> +# define CRC_LE_BITS 64

I'm not sure this works on all platforms and builds, whereas the
existing slice-by-4 default should work for them all, but may not
be the fastest.

This code in the crc32defs.h:

#ifndef CRC_LE_BITS
#  ifdef CONFIG_64BIT
#  define CRC_LE_BITS 64
#  else
#  define CRC_LE_BITS 32
#  endif
#endif

kinda tells us what the "optimal" default should be.

And keep in mind that the kernel has arch-specific settings:

$ git grep CONFIG_CRC32_S
arch/mips/configs/bcm47xx_defconfig:CONFIG_CRC32_SARWATE=y
arch/mips/configs/db1xxx_defconfig:CONFIG_CRC32_SLICEBY4=y
arch/mips/configs/rt305x_defconfig:CONFIG_CRC32_SARWATE=y
arch/mips/configs/xway_defconfig:CONFIG_CRC32_SARWATE=y
arch/powerpc/configs/adder875_defconfig:CONFIG_CRC32_SLICEBY4=y
arch/powerpc/configs/ep88xc_defconfig:CONFIG_CRC32_SLICEBY4=y
arch/powerpc/configs/mpc866_ads_defconfig:CONFIG_CRC32_SLICEBY4=y
arch/powerpc/configs/mpc885_ads_defconfig:CONFIG_CRC32_SLICEBY4=y
arch/powerpc/configs/tqm8xx_defconfig:CONFIG_CRC32_SLICEBY4=y
....

Which says that certain mips and powerpc CPUs should be using
slice-by-4 or sarwate algorithms, not slice-by-8....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
