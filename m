Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40226 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751224AbdAOUcB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Jan 2017 15:32:01 -0500
Subject: Re: [RFC] libxfs: cross-compile fixes
References: <1473241376-10922-1-git-send-email-ralph.sennhauser@gmail.com>
 <1473493051-12838-1-git-send-email-ralph.sennhauser@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <704667b9-d8d4-974b-6be7-aef2ef275b12@sandeen.net>
Date: Sun, 15 Jan 2017 14:32:00 -0600
MIME-Version: 1.0
In-Reply-To: <1473493051-12838-1-git-send-email-ralph.sennhauser@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ralph Sennhauser <ralph.sennhauser@gmail.com>, linux-xfs@vger.kernel.org

On 9/10/16 2:37 AM, Ralph Sennhauser wrote:
> ---
> 
> Based on the earlier discussion this seems to be the preferred way of
> handling things.
> 
> Should I split it into 3 patches?
> Do you want something different to happen when cross-compiling?

Hi Ralph -

I just merged a patch to for-next to address cross-compiling;
it was on the list prior to this one.

Can you confirm that it resolves your issues?

Thanks,
-Eric
 
> Cheers
> Ralph
> 
> ---
>  configure.ac         |  3 +++
>  include/builddefs.in |  1 +
>  libxfs/Makefile      | 10 ++++++++--
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 79053e5..89334d6 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -10,11 +10,14 @@ AC_PROG_LIBTOOL
>  
>  AC_PROG_CC
>  if test $cross_compiling = no; then
> +  CROSS_COMPILING=no
>    BUILD_CC="$CC"
>    AC_SUBST(BUILD_CC)
>  else
> +  CROSS_COMPILING=yes
>    AC_CHECK_PROGS(BUILD_CC, gcc cc)
>  fi
> +AC_SUBST(CROSS_COMPILING)
>  
>  AC_ARG_ENABLE(shared,
>  [ --enable-shared=[yes/no] Enable use of shared libraries [default=yes]],,
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 7153d7a..0c4ce36 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -26,6 +26,7 @@ MALLOCLIB = @malloc_lib@
>  LOADERFLAGS = @LDFLAGS@
>  LTLDFLAGS = @LDFLAGS@
>  CFLAGS = @CFLAGS@
> +CROSS_COMPILING = @CROSS_COMPILING@
>  
>  LIBRT = @librt@
>  LIBUUID = @libuuid@
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
> +
>  default: crc32selftest ltdepend $(LTLIBRARY)
>  
>  crc32table.h: gen_crc32table.c
>  	@echo "    [CC]     gen_crc32table"
> -	$(Q) $(BUILD_CC) $(CFLAGS) -o gen_crc32table $<
> +	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -o gen_crc32table $<
>  	@echo "    [GENERATE] $@"
>  	$(Q) ./gen_crc32table > crc32table.h
>  
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
>  
>  # set up include/xfs header directory
>  include $(BUILDRULES)
> 
