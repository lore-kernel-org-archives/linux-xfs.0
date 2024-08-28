Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42BB165F06
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 23:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724889222; cv=none; b=rppH5N6OSjdWGS78Q0qjhMjr4LNqmtZLXmYCTZ1CfpEppglS9e2e4C6sjhjY6uzXX+KqUFn2ZBenjwTlZ4Y0qOoTaFJ2kksg2FdMUQFA9NY8nx/PjDF9BbqkfdDsWC23NAjltgqq55ouH2s0CJ1T5b/gsbuU52c/Lw0c12ROYmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724889222; c=relaxed/simple;
	bh=UhhTsWUJWmcOPB22ovJyx4u08kZgk6sQloCezoPpxZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tw1CDCQ0U/hj9N8A9K8ONAT/0ddPB65kC6IIVcB3Yu6OKrODJaHIsy4e2dp5kLSUkrZAhU+LP90sYxYUAd/bbeu7E7WXPoxEk1nvTCVj5LB54eYzLEZph+vZsNa7ayPP4f/cHTzrF8qS1Hd7a6DjVpTjm0Ry4LO343wSphYD/JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E4f/vk2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E4f/vk2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE6FC4CEC0;
	Wed, 28 Aug 2024 23:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724889222;
	bh=UhhTsWUJWmcOPB22ovJyx4u08kZgk6sQloCezoPpxZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E4f/vk2cPwIvxIaVbtR8mbadr2zPyiaP/FiZJUitsptvj0kLJsAsIayX6EY6Anq4a
	 ONLC9tCJSMj0VNvJDcb3PXULa9Fsm1DLvuA5uAp2e3G5lxDgqbxSd+6SY8c2z8rXoT
	 xsFkAVKZKK7a3XRGU/wUPrzcgPgc3+Qc9opbWBWspd5yJQg1U4aQO+M4GKg5u2Woms
	 ocV/t6fE4NhRSgHeY5NbBP0bnV2m6R/HlZHp23JCHOoe64saCel2+prPFEx2fRNEo5
	 9UhBPvb0i91XEIl16GlgymIGzWlHiK8bIa3uKBRjuQYCMz1iG0mEAsCFyVGLPr8jqX
	 mJnfsOHlJvIFA==
Date: Wed, 28 Aug 2024 16:53:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sam James <sam@gentoo.org>
Cc: kernel@mattwhitlock.name, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [RFC PATCH] libxfs: compile with a C++ compiler
Message-ID: <20240828235341.GD6224@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <20240827234533.GE1977952@frogsfrogsfrogs>
 <87le0hbjms.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87le0hbjms.fsf@gentoo.org>

On Wed, Aug 28, 2024 at 01:01:31AM +0100, Sam James wrote:
> "Darrick J. Wong" <djwong@kernel.org> writes:
> 
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Apparently C++ compilers don't like the implicit void* casts that go on
> > in the system headers.  Compile a dummy program with the C++ compiler to
> > make sure this works, so Darrick has /some/ chance of figuring these
> > things out before the users do.
> 
> Thanks, this is a good idea. Double thanks for the quick fix.
> 
> 1) yes, it finds the breakage:
> Tested-by: Sam James <sam@gentoo.org>
> 
> 2) with the fix below (CC -> CXX):
> Reviewed-by: Sam James <sam@gentoo.org>
> 
> 3) another thing to think about is:
> * -pedantic?

-pedantic won't build because C++ doesn't support flexarrays:

In file included from ../include/xfs.h:61:
../include/xfs/xfs_fs.h:523:33: error: ISO C++ forbids flexible array member ‘bulkstat’ [-Werror=pedantic]
  523 |         struct xfs_bulkstat     bulkstat[];
      |                                 ^~~~~~~~

even if you wrap it in extern "C" { ... };

> * maybe do one for a bunch of standards? (I think systemd does every
> possible value [1])

That might be overkill since xfsprogs' build system doesn't have a good
mechanism for detecting if a compiler supports a particular standard.
I'm not even sure there's a good "reference" C++ standard to pick here,
since the kernel doesn't require a C++ compiler.

> * doing the above for C as well

Hmm, that's a good idea.

I think the only relevant standard here is C11 (well really gnu11),
because that's what the kernel compiles with since 5.18.  xfsprogs
doesn't specify any particular version of C, but perhaps we should match
the kernel every time they bump that up?

IOWs, should we build xfsprogs with -std=gnu11?  The commit changing the
kernel to gnu11 (e8c07082a810) remarks that gcc 5.1 supports it just
fine.  IIRC RHEL 7 only has 4.8.5 but it's now in extended support so
... who cares?  The oldest supported Debian stable has gcc 8.

--D

> I know that sounds a bit like overkill, but systemd
> does it and it's cheap to do it versus the blowup if something goes
> wrong. I don't have a strong opinion on this or how far you want to go
> with it.
> 
> [1] https://github.com/systemd/systemd/blob/3317aedff0901e08a8efc8346ad76b184d5d40ea/src/systemd/meson.build#L60
> 
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  configure.ac         |    1 +
> >  include/builddefs.in |    7 +++++++
> >  libxfs/Makefile      |    8 +++++++-
> >  libxfs/dummy.cpp     |   15 +++++++++++++++
> >  4 files changed, 30 insertions(+), 1 deletion(-)
> >  create mode 100644 libxfs/dummy.cpp
> >
> > diff --git a/configure.ac b/configure.ac
> > index 0ffe2e5dfc53..04544f85395b 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -9,6 +9,7 @@ AC_PROG_INSTALL
> >  LT_INIT
> >  
> >  AC_PROG_CC
> > +AC_PROG_CXX
> >  AC_ARG_VAR(BUILD_CC, [C compiler for build tools])
> >  if test "${BUILD_CC+set}" != "set"; then
> >    if test $cross_compiling = no; then
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index 44f95234d21b..0f312b8b88fe 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -14,6 +14,7 @@ MALLOCLIB = @malloc_lib@
> >  LOADERFLAGS = @LDFLAGS@
> >  LTLDFLAGS = @LDFLAGS@
> >  CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 -Wno-address-of-packed-member
> > +CXXFLAGS = @CXXFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 -Wno-address-of-packed-member
> >  BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64
> >  
> >  # make sure we don't pick up whacky LDFLAGS from the make environment and
> > @@ -234,9 +235,15 @@ ifeq ($(ENABLE_GETTEXT),yes)
> >  GCFLAGS += -DENABLE_GETTEXT
> >  endif
> >  
> > +# Override these if C++ needs other options
> > +SANITIZER_CXXFLAGS = $(SANITIZER_CFLAGS)
> > +GCXXFLAGS = $(GCFLAGS)
> > +PCXXFLAGS = $(PCFLAGS)
> > +
> >  BUILD_CFLAGS += $(GCFLAGS) $(PCFLAGS)
> >  # First, Sanitizer, Global, Platform, Local CFLAGS
> >  CFLAGS += $(FCFLAGS) $(SANITIZER_CFLAGS) $(OPTIMIZER) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
> > +CXXFLAGS += $(FCXXFLAGS) $(SANITIZER_CXXFLAGS) $(OPTIMIZER) $(GCXXFLAGS) $(PCXXFLAGS) $(LCXXFLAGS)
> >  
> >  include $(TOPDIR)/include/buildmacros
> >  
> > diff --git a/libxfs/Makefile b/libxfs/Makefile
> > index 1185a5e6cb26..bb851ab74204 100644
> > --- a/libxfs/Makefile
> > +++ b/libxfs/Makefile
> > @@ -125,6 +125,8 @@ CFILES = buf_mem.c \
> >  	xfs_trans_space.c \
> >  	xfs_types.c
> >  
> > +LDIRT += dummy.o
> > +
> >  #
> >  # Tracing flags:
> >  # -DMEM_DEBUG		all zone memory use
> > @@ -144,7 +146,11 @@ LTLIBS = $(LIBPTHREAD) $(LIBRT)
> >  # don't try linking xfs_repair with a debug libxfs.
> >  DEBUG = -DNDEBUG
> >  
> > -default: ltdepend $(LTLIBRARY)
> > +default: ltdepend $(LTLIBRARY) dummy.o
> > +
> > +dummy.o: dummy.cpp
> > +	@echo "    [CXX]    $@"
> > +	$(Q)$(CC) $(CXXFLAGS) -c $<
> 
> $(CXX) ;)
> 
> >  
> >  # set up include/xfs header directory
> >  include $(BUILDRULES)
> > diff --git a/libxfs/dummy.cpp b/libxfs/dummy.cpp
> > new file mode 100644
> > index 000000000000..a872c00ad84b
> > --- /dev/null
> > +++ b/libxfs/dummy.cpp
> > @@ -0,0 +1,15 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2024 Oracle.  All Rights Reserved.
> > + * Author: Darrick J. Wong <djwong@kernel.org>
> > + */
> > +#include "include/xfs.h"
> > +#include "include/handle.h"
> > +#include "include/jdm.h"
> > +
> > +/* Dummy program to test C++ compilation of user-exported xfs headers */
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +	return 0;
> > +}
> 
> cheers,
> sam


