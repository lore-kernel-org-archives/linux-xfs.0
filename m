Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:1437 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750742AbdIGG7n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 02:59:43 -0400
Date: Thu, 7 Sep 2017 16:59:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] spaceman: Add missing link to libuuid
Message-ID: <20170907065926.GY17782@dastard>
References: <20170907021900.41040-1-raj.khem@gmail.com>
 <20170907024017.GX17782@dastard>
 <CAMKF1souYmZRaQuBoOv-xR6+S8kj9oHpzZ_rN6V4ecnOr=RuFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMKF1souYmZRaQuBoOv-xR6+S8kj9oHpzZ_rN6V4ecnOr=RuFQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Khem Raj <raj.khem@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 06, 2017 at 09:11:11PM -0700, Khem Raj wrote:
> On Wed, Sep 6, 2017 at 7:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Sep 06, 2017 at 07:19:00PM -0700, Khem Raj wrote:
> >> When uuid is enabled then we see linking failures with gold linker e.g.
> >>
> >> libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_compare'
> >> libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_copy'
> >> clang-5.0: error: linker command failed with exit code 1 (use -v to see invocation)
> >
> > That's libxfs, not xfs_spaceman....
> 
> yes its libxfs but its linking spaceman, I chopped the error logs too
> much I guess.

xfs_spaceman does not link against libuuid:

$ ldd spaceman/xfs_spaceman 
	linux-vdso.so.1 (0x00007ffca4f68000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fa36f358000)
	/lib64/ld-linux-x86-64.so.2 (0x00007fa36f6f7000)

Nor libxfs - if it linked against libxfs, it would have to pull in
4 other libraries, including libuuid:

$ ldd repair/xfs_repair 
	linux-vdso.so.1 (0x00007ffd96bb4000)
	libuuid.so.1 => /lib/x86_64-linux-gnu/libuuid.so.1 (0x00007f5da2d4f000)
	librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f5da2b47000)
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f5da292a000)
	libblkid.so.1 => /lib/x86_64-linux-gnu/libblkid.so.1 (0x00007f5da26e4000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f5da2345000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f5da2f54000)

So whatever build error you are having has nothing to do with
xfs_spaceman. Have you installed all the necessary libraries?

> >> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> >> ---
> >>  spaceman/Makefile | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/spaceman/Makefile b/spaceman/Makefile
> >> index 95ec3c0..060e0af 100644
> >> --- a/spaceman/Makefile
> >> +++ b/spaceman/Makefile
> >> @@ -9,7 +9,7 @@ LTCOMMAND = xfs_spaceman
> >>  HFILES = init.h space.h
> >>  CFILES = init.c file.c prealloc.c trim.c
> >>
> >> -LLDLIBS = $(LIBXCMD)
> >> +LLDLIBS = $(LIBXCMD) $(LIBUUID)
> >
> > And spaceman doesn't link against libxfs, nor does libxcmd or
> > spaceman use uuids so I don't see why this fixes a problem with
> > libxfs...
> 
> I was just following what other binaries were doing, otherwise I agree
> libuuid should appear in DT_NEEDED flags in libxfs.so so linkers can
> pull it in automatically.
> 
> try using
> 
> LDFLAGS = "-fuse-ld=gold" if you want to reproduce the problem on your end.

$ gold -V
GNU gold (GNU Binutils for Debian 2.29) 1.14
$ make distclean
....
$ LDFLAGS="-fuse-ld=gold" make -j8 Q=
....
[LD]     xfs_spaceman
/bin/bash ../libtool --quiet --tag=CC --mode=link gcc -o xfs_spaceman -fuse-ld=gold -fuse-ld=gold  -fuse-ld=gold  -fuse-ld=gold -static  init.o file.o prealloc.o trim.o freesp.o   ../libxcmd/libxcmd.la
.....
$ ldd spaceman/xfs_spaceman 
	linux-vdso.so.1 (0x00007ffc943e4000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f2def2e2000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f2def681000)

TOT builds just fine here on debian unstable using the gold linker,
and again this shows that spaceman does not link against libuuid.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
