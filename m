Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50660 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751028AbdFUTO6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 15:14:58 -0400
Subject: Re: [PATCH 3/3] libxfs: use crc32c slice-by-8 variant by default
References: <149755888982.3424.6925834871301440055.stgit@birch.djwong.org>
 <149755891632.3424.8018763268292554053.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c06c280e-278a-c80b-a412-8c9d4ec4e62d@sandeen.net>
Date: Wed, 21 Jun 2017 14:14:57 -0500
MIME-Version: 1.0
In-Reply-To: <149755891632.3424.8018763268292554053.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On 6/15/17 3:35 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The crc32c code used in xfsprogs was copied directly from the Linux
> kernel.  However, that code selects slice-by-4 by default, which isn't
> the fastest -- that's slice-by-8, which trades table size for speed.
> Fix some makefile dependency problems and explicitly select the
> algorithm we want.  With this patch applied, I see about a 10% drop in
> CPU time running xfs_repair.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

dchinner: are you ok with this now?  You had questions earlier,
but Darrick's explanations satisfied me, at least... 

> ---
>  libxfs/Makefile    |    4 ++--
>  libxfs/crc32defs.h |   34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index baba02f..d248c1f 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -122,7 +122,7 @@ LDIRT = gen_crc32table crc32table.h crc32selftest
>  
>  default: crc32selftest ltdepend $(LTLIBRARY)
>  
> -crc32table.h: gen_crc32table.c
> +crc32table.h: gen_crc32table.c crc32defs.h
>  	@echo "    [CC]     gen_crc32table"
>  	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -o gen_crc32table $<
>  	@echo "    [GENERATE] $@"
> @@ -133,7 +133,7 @@ crc32table.h: gen_crc32table.c
>  # systems/architectures. Hence we make sure that xfsprogs will never use a
>  # busted CRC calculation at build time and hence avoid putting bad CRCs down on
>  # disk.
> -crc32selftest: gen_crc32table.c crc32table.h crc32.c
> +crc32selftest: gen_crc32table.c crc32table.h crc32.c crc32defs.h
>  	@echo "    [TEST]    CRC32"
>  	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -D CRC32_SELFTEST=1 crc32.c -o $@
>  	$(Q) ./$@
> diff --git a/libxfs/crc32defs.h b/libxfs/crc32defs.h
> index 64cba2c..2999782 100644
> --- a/libxfs/crc32defs.h
> +++ b/libxfs/crc32defs.h
> @@ -1,4 +1,38 @@
>  /*
> + * Use slice-by-8, which is the fastest variant.
> + *
> + * Calculate checksum 8 bytes at a time with a clever slicing algorithm.
> + * This is the fastest algorithm, but comes with a 8KiB lookup table.
> + * Most modern processors have enough cache to hold this table without
> + * thrashing the cache.
> + *
> + * The Linux kernel uses this as the default implementation "unless you
> + * have a good reason not to".  The reason why Kconfig urges you to pick
> + * SLICEBY8 is because people challenged the assertion that we should
> + * always use slice by 8, so Darrick wrote a crc microbenchmark utility
> + * and ran it on as many machines as he could get his hands on to show
> + * that sb8 was the fastest.
> + *
> + * Every 64-bit machine (and most of the 32-bit ones too) saw the best
> + * results with sb8.  Any machine with more than 4K of cache saw better
> + * results.  The spreadsheet still exists today[1]; note that
> + * 'crc32-kern-le' corresponds to the slice by 4 algorithm which is the
> + * default unless CRC_LE_BITS is defined explicitly.
> + *
> + * FWIW, there are a handful of board defconfigs in the kernel that
> + * don't pick sliceby8.  These are all embedded 32-bit mips/ppc systems
> + * with very small cache sizes which experience cache thrashing with the
> + * slice by 8 algorithm, and therefore chose to pick defaults that are
> + * saner for their particular board configuration.  For nearly all of
> + * XFS' perceived userbase (which we assume are 32 and 64-bit machines
> + * with sufficiently large CPU cache and largeish storage devices) slice
> + * by 8 is the right choice.
> + *
> + * [1] https://goo.gl/0LSzsG ("crc32c_bench")
> + */
> +#define CRC_LE_BITS 64
> +
> +/*
>   * There are multiple 16-bit CRC polynomials in common use, but this is
>   * *the* standard CRC-32 polynomial, first popularized by Ethernet.
>   * x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x^1+x^0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
