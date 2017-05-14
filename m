Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49185 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752948AbdENBZh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 May 2017 21:25:37 -0400
Date: Sat, 13 May 2017 18:25:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] libxfs: use crc32c slice-by-8 variant by default
Message-ID: <20170514012522.GL4519@birch.djwong.org>
References: <20170513193344.GK4519@birch.djwong.org>
 <20170513234545.GL17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170513234545.GL17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Sun, May 14, 2017 at 09:45:45AM +1000, Dave Chinner wrote:
> On Sat, May 13, 2017 at 12:33:44PM -0700, Darrick J. Wong wrote:
> > The crc32c code used in xfsprogs was copied directly from the Linux
> > kernel.  However, that code selects slice-by-4 by default, which isn't
> > the fastest -- that's slice-by-8, which trades table size for speed.
> > Fix some makefile dependency problems and explicitly select the
> > algorithm we want.  With this patch applied, I see about a 10% drop in
> > CPU time running xfs_repair.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libxfs/Makefile    |    4 ++--
> >  libxfs/crc32defs.h |    3 +++
> >  2 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/libxfs/Makefile b/libxfs/Makefile
> > index 0f3759e..c5dc382 100644
> > --- a/libxfs/Makefile
> > +++ b/libxfs/Makefile
> > @@ -124,7 +124,7 @@ LDIRT = gen_crc32table crc32table.h crc32selftest
> >  
> >  default: crc32selftest ltdepend $(LTLIBRARY)
> >  
> > -crc32table.h: gen_crc32table.c
> > +crc32table.h: gen_crc32table.c crc32defs.h
> >  	@echo "    [CC]     gen_crc32table"
> >  	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -o gen_crc32table $<
> >  	@echo "    [GENERATE] $@"
> > @@ -135,7 +135,7 @@ crc32table.h: gen_crc32table.c
> >  # systems/architectures. Hence we make sure that xfsprogs will never use a
> >  # busted CRC calculation at build time and hence avoid putting bad CRCs down on
> >  # disk.
> > -crc32selftest: gen_crc32table.c crc32table.h crc32.c
> > +crc32selftest: gen_crc32table.c crc32table.h crc32.c crc32defs.h
> >  	@echo "    [TEST]    CRC32"
> >  	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -D CRC32_SELFTEST=1 crc32.c -o $@
> >  	$(Q) ./$@
> > diff --git a/libxfs/crc32defs.h b/libxfs/crc32defs.h
> > index 64cba2c..153f44c 100644
> > --- a/libxfs/crc32defs.h
> > +++ b/libxfs/crc32defs.h
> > @@ -1,3 +1,6 @@
> > +/* Use slice-by-8, which is the fastest variant. */
> > +# define CRC_LE_BITS 64
> 
> I'm not sure this works on all platforms and builds, whereas the
> existing slice-by-4 default should work for them all

That's why we have a selftest to ensure that the implementation isn't
busted no matter which method we pick.

> but may not be the fastest.
> 
> This code in the crc32defs.h:
> 
> #ifndef CRC_LE_BITS
> #  ifdef CONFIG_64BIT
> #  define CRC_LE_BITS 64
> #  else
> #  define CRC_LE_BITS 32
> #  endif
> #endif
> 
> kinda tells us what the "optimal" default should be.

I know what the code says, I was the person who pushed all that code to
Linus back in 2012 in preparation to add checksums to ext4. :)

That particular hunk is a remnant of the pre-Kconfig method of picking a
variant (and probably should have been ripped out long ago).  Note that the
kernel picks SLICEBY8 by default (I will address the nine exceptions you
pointed out later):

config CRC32_SLICEBY8
	bool "Slice by 8 bytes"
	help
	  Calculate checksum 8 bytes at a time with a clever slicing algorithm.
	  This is the fastest algorithm, but comes with a 8KiB lookup table.
	  Most modern processors have enough cache to hold this table without
	  thrashing the cache.

	  This is the default implementation choice.  Choose this one unless
	  you have a good reason not to.

config CRC32_SLICEBY4
	bool "Slice by 4 bytes"
	help
	  Calculate checksum 4 bytes at a time with a clever slicing algorithm.
	  This is a bit slower than slice by 8, but has a smaller 4KiB lookup
	  table.

	  Only choose this option if you know what you are doing.

config CRC32_SARWATE
	bool "Sarwate's Algorithm (one byte at a time)"
	help
	  Calculate checksum a byte at a time using Sarwate's algorithm.  This
	  is not particularly fast, but has a small 256 byte lookup table.

	  Only choose this option if you know what you are doing.

config CRC32_BIT
	bool "Classic Algorithm (one bit at a time)"
	help
	  Calculate checksum one bit at a time.  This is VERY slow, but has
	  no lookup table.  This is provided as a debugging option.

	  Only choose this option if you are debugging crc32.

Notice how all of the non-SLICEBY8 options tell you to not to choose
that option unless you know what you're doing?  The reason why Kconfig
urges you to pick SLICEBY8 is because people challenged my assertion
that we should use slice by 8 by default, so I wrote a little crc
microbenchmark utility and ran it on as many machines as I could get my
hands on to show that slice by 8 was the fastest.

Every 64-bit machine (and most of the 32-bit ones too) saw the best
results with sb8.  Any machine with more than 4K of cache saw better
results.  The spreadsheet still exists today[1]; note that
'crc32-kern-le' corresponds to the sliceby4 algorithm.

Of course there were questions about "What if my particular board
actually does better with something else?", so after a number of rounds
of bikeshedding we ended up with the Kconfig system that's still there
today.  Hence:

> And keep in mind that the kernel has arch-specific settings:
> 
> $ git grep CONFIG_CRC32_S
> arch/mips/configs/bcm47xx_defconfig:CONFIG_CRC32_SARWATE=y
> arch/mips/configs/db1xxx_defconfig:CONFIG_CRC32_SLICEBY4=y
> arch/mips/configs/rt305x_defconfig:CONFIG_CRC32_SARWATE=y
> arch/mips/configs/xway_defconfig:CONFIG_CRC32_SARWATE=y
> arch/powerpc/configs/adder875_defconfig:CONFIG_CRC32_SLICEBY4=y
> arch/powerpc/configs/ep88xc_defconfig:CONFIG_CRC32_SLICEBY4=y
> arch/powerpc/configs/mpc866_ads_defconfig:CONFIG_CRC32_SLICEBY4=y
> arch/powerpc/configs/mpc885_ads_defconfig:CONFIG_CRC32_SLICEBY4=y
> arch/powerpc/configs/tqm8xx_defconfig:CONFIG_CRC32_SLICEBY4=y
> ....
> 
> Which says that certain mips and powerpc CPUs should be using
> slice-by-4 or sarwate algorithms, not slice-by-8....

All nine of those systems are embedded 32-bit mips/ppc systems with very
small cache sizes which experience cache thrashing with the slice-by-8
algorithm, and therefore chose to pick defaults that are saner for their
particular board configuration.  For nearly all of XFS' perceived
userbase (which I assume are 32 and 64-bit machines with sufficiently
large CPU cache and largeish storage devices) I think slice by 8 is the
right choice.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
