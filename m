Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53364 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbfHLAYR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Aug 2019 20:24:17 -0400
Date: Mon, 12 Aug 2019 10:23:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
Message-ID: <20190812002306.GH7777@dread.disaster.area>
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Deutschmann <whissi@gentoo.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Mon, Aug 12, 2019 at 01:30:46AM +0200, Thomas Deutschmann wrote:
> On 2019-08-12 00:53, Dave Chinner wrote:
> > How did you configure this build? Can you run a clean build without
> > configuring in any of the whacky compiler super-optimisations that
> > you have and see if that builds cleanly?
> 
> Just add
> 
>   --disable-static

yes, ok, that produces a link time error, but...
> 
> and you should be able to reproduce. This option will cause that 3x
> "-Wl,-O1 -Wl,--as-needed  " will be passed to the linker.

it does not produce that whacky linker command line you are getting:

    [LD]     xfs_copy
/bin/bash ../libtool --quiet --tag=CC --mode=link gcc -o xfs_copy   -static-libtool-libs  xfs_copy.o   ../libxfs/libxfs.la ../libxlog/libxlog.la ../libfrog/libfrog.la -luuid -lpthread -lrt  
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_new_probe_from_filename'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_topology_get_alignment_offset'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_probe_get_topology'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_do_fullprobe'
/usr/bin/ld: ../libxfs/.libs/libxfs.so: undefined reference to `xfs_ag_geom_health'
.....

In fact, the linker command is identical to the non-static build,
which implies the ../libxfs/libxfs.la library definition points
to something different:

# The name that we can dlopen(3).
dlname='libxfs.so.0'

# Names of this library.
library_names='libxfs.so.0.0.0 libxfs.so.0 libxfs.so'

# The name of the static archive.
old_library=

.....

And when static libraries are built:

# The name that we can dlopen(3).
dlname='libxfs.so.0'

# Names of this library.
library_names='libxfs.so.0.0.0 libxfs.so.0 libxfs.so'

# The name of the static archive.
old_library='libxfs.a'

....


Yeah, so there's teh difference - there should be no change to
the linker command line from --disable-static.

Really, I don't know why we support --disable-static at all.
Internal XFS libraries have to be statically linked because they are
not shipped as installed shared libraries. Hence not building the
static version of the library is wrong, and the shared version is
not used by anything. The default build dynamically links external
libraries, so there is nothing to be gained from disabling internal
static libraries.

Indeed, that's why we have the -static-libtool-libs option on the
linker command link, as commit ece49daeff1a ("xfsprogs: do not do
any dynamic linking of libtool libraries") explains:

    if --disable-static and --enable-shared are given on the command
    line, the link with xfsprogs's internal libraries fail because
    they have been dynamically compiled.
    
    Hence the following error:
    ld: attempted static link of dynamic object `../libxcmd/.libs/libxcmd.so'
    
    xfsprogs rely on the original behaviour of -static which was modified in
    Buildroot by [1].  But since commit [2] the build of xfsprogs tools is broken
    because they try to link statically with the static libuuid library
    (util-linux), which is not build for shared only build.
    
    The use of -static-libtool-libs allows to fallback to the dynamic linking for
    libuuid only:
    
    LD_TRACE_LOADED_OBJECTS=1 xfs_copy
            linux-gate.so.1 =>  (0xf7793000)
            libuuid.so.1 => /lib/libuuid.so.1 (0x465e1000)
            libpthread.so.0 => /lib/libpthread.so.0 (0x46db1000)
            librt.so.1 => /lib/librt.so.1 (0x46f21000)
            libc.so.6 => /lib/libc.so.6 (0x46bf1000)
            /lib/ld-linux.so.2 (0x46bce000)

So I'd be removing --disable-static from your build because it
really isn't doing anything useful...

That still doesn't explain where all the whacky gcc options are
coming from - that's got to be something specific to your build or
distro environment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
