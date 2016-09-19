Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:14949 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755785AbcISFuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Sep 2016 01:50:40 -0400
Date: Mon, 19 Sep 2016 15:50:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] libxfs: cross-compile fixes
Message-ID: <20160919055018.GC340@dastard>
References: <1473241376-10922-1-git-send-email-ralph.sennhauser@gmail.com>
 <1473493051-12838-1-git-send-email-ralph.sennhauser@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473493051-12838-1-git-send-email-ralph.sennhauser@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Sep 10, 2016 at 09:37:31AM +0200, Ralph Sennhauser wrote:
> ---
> 
> Based on the earlier discussion this seems to be the preferred way of
> handling things.
> 
> Should I split it into 3 patches?
> Do you want something different to happen when cross-compiling?
> 
> Cheers
> Ralph
> 
> ---
>  configure.ac         |  3 +++
>  include/builddefs.in |  1 +
>  libxfs/Makefile      | 10 ++++++++--
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index 62608bd..ad492e5 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -114,11 +114,15 @@ DEBUG = -DNDEBUG
>  
>  LDIRT = gen_crc32table crc32table.h crc32selftest
>  
> +ifeq ($(CROSS_COMPILING),no)
> +BUILD_CFLAGS:=$(CFLAGS)
> +endif

This seems like the wrong place to define something like this. We
define CFLAGS in include/builddefs.in, and I think BUILD_CFLAGS
should be defined there, too. It should probably only drop the
platform specific flags, rather than everything in the corss
compiling case.

> @@ -128,9 +132,11 @@ crc32table.h: gen_crc32table.c
>  # busted CRC calculation at build time and hence avoid putting bad CRCs down on
>  # disk.
>  crc32selftest: gen_crc32table.c crc32table.h crc32.c
> +ifeq ($(CROSS_COMPILING),no)
>  	@echo "    [TEST]    CRC32"
> -	$(Q) $(BUILD_CC) $(CFLAGS) -D CRC32_SELFTEST=1 crc32.c -o $@
> +	$(Q) $(CC) $(CFLAGS) -D CRC32_SELFTEST=1 crc32.c -o $@
>  	$(Q) ./$@
> +endif

That looks wrong. If CROSS_COMPILING == no, then BUILD_CC has
already been set to CC by the configure script, and CFLAGS is just
fine to use here.

I think what needs to be done here is that the crc32selftest /rule/
needs to be conditional on CROSS_COMPILING, not the /execution/
of the rule. If nothing is dependent on crc32selftest, then it won't
get executed. i.e. this requires dependency manipulation, not
execution changes.

CRC_SRC = crc32table.h crc32.c
ifeq ($(CROSS_COMPILING),no)
	TARGETS = crc32selftest
else
	TARGETS = $CRC_SRC
endif

default: $TARGETS ltdepend $(LTLIBRARY)

.....
crc32selftest: gen_crc32table.c $CRC_SRC
....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
