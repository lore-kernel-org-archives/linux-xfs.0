Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44968 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbfHKWyS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Aug 2019 18:54:18 -0400
Date: Mon, 12 Aug 2019 08:53:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
Message-ID: <20190811225307.GF7777@dread.disaster.area>
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Deutschmann <whissi@gentoo.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Sun, Aug 11, 2019 at 03:06:13PM +0200, Thomas Deutschmann wrote:
> Hi,
> 
> building xfsprogs-5.2.0 is failing with the following error:
> 
> >     [CC]     xfs_copy.o
> > x86_64-pc-linux-gnu-gcc -O2 -pipe -march=ivybridge -mtune=ivybridge -mno-xsaveopt -frecord-gcc-switches -D_FILE_OFFSET_BITS=64 -O2 -pipe -march=ivybridge -mtune=ivybridge -mno-xsaveopt -frecord-gcc-switches  -O2 -pipe -march=ivybridge -mtune=ivybridge -mno-xsaveopt -frecord-gcc-switches -DNDEBUG -DVERSION=\"5.2.0\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -I../libxfs -DENABLE_GETTEXT -D_GNU_SOURCE -funsigned-char -fno-strict-aliasing -Wall -DHAVE_MNTENT -DHAVE_FSETXATTR -DENABLE_BLKID -DHAVE_GETFSMAP  -c xfs_copy.c
> >     [LD]     xfs_copy
> > /bin/bash ../libtool --quiet --tag=CC --mode=link x86_64-pc-linux-gnu-gcc -o xfs_copy -Wl,-O1 -Wl,--as-needed  -Wl,-O1 -Wl,--as-needed   -Wl,-O1 -Wl,--as-needed   -Wl,-O1 -Wl,--as-needed   xfs_copy.o   ../libxfs/libxfs.la ../libxlog/libxlog.la ../libfrog/libfrog.la -luuid -lpthread -lrt  
> > /usr/lib/gcc/x86_64-pc-linux-gnu/9.1.0/../../../../x86_64-pc-linux-gnu/bin/ld: ../libxfs/.libs/libxfs.so: undefined reference to `xfs_ag_geom_health'
> > collect2: error: ld returned 1 exit status
> > gmake[2]: *** [../include/buildrules:65: xfs_copy] Error 1
> > gmake[1]: *** [include/buildrules:36: copy] Error 2
> > make: *** [Makefile:92: default] Error 2

That's quite a set of custom compiler options you have there. It's
complaining about a reference to a function that is dead code in
the build that is called from other dead code in the build. i.e the
linker or compiler has elided one part of the dead code, but not all
of it. The build works if nothing is elided or all the dead code is
elided, so that seems like a toolchain problem more that anything.

FWIW, the default build w. gcc-8.3.0 on debian unstable is fine:

gcc -MM -g -O2 -D_FILE_OFFSET_BITS=64   -g -O2 -DDEBUG -DVERSION=\"5.2.0\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -I../libxfs -DENABLE_GETTEXT -D_GNU_SOURCE -funsigned-char -fno-strict-aliasing -Wall -DHAVE_MNTENT -DHAVE_FSETXATTR -DENABLE_BLKID -DHAVE_GETFSMAP  xfs_copy.c > .dep
rm -f .dep
    [CC]     xfs_copy.o
gcc -g -O2 -D_FILE_OFFSET_BITS=64   -g -O2 -DDEBUG -DVERSION=\"5.2.0\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -I../libxfs -DENABLE_GETTEXT -D_GNU_SOURCE -funsigned-char -fno-strict-aliasing -Wall -DHAVE_MNTENT -DHAVE_FSETXATTR -DENABLE_BLKID -DHAVE_GETFSMAP  -c xfs_copy.c
    [LD]     xfs_copy
/bin/bash ../libtool --quiet --tag=CC --mode=link gcc -o xfs_copy   -static-libtool-libs  xfs_copy.o   ../libxfs/libxfs.la ../libxlog/libxlog.la ../libfrog/libfrog.la -luuid -lpthread -lrt

And it tells me that your whacky set of options to the
linker pass (which repeats 3x "-Wl,-O1 -Wl,--as-needed  " instead of
"-static-libtool-libs") is likely the problem.

Yup, that's the problem. If I run your linker command on my
successful build to relink the xfs-copy binary:

/bin/bash ../libtool --quiet --tag=CC --mode=link gcc -o xfs_copy -Wl,-O1 -Wl,--as-needed  -Wl,-O1 -Wl,--as-needed   -Wl,-O1 -Wl,--as-needed   -Wl,-O1 -Wl,--as-needed   xfs_copy.o   ../libxfs/libxfs.la ../libxlog/libxlog.la ../libfrog/libfrog.la -luuid -lpthread -lrt
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_new_probe_from_filename'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_topology_get_alignment_offset'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_probe_get_topology'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_do_fullprobe'
/usr/bin/ld: ../libxfs/.libs/libxfs.so: undefined reference to `xfs_ag_geom_health'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_topology_get_logical_sector_size'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_topology_get_optimal_io_size'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_probe_lookup_value'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_free_probe'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_topology_get_physical_sector_size'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_probe_enable_partitions'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_topology_get_minimum_io_size'

There's all sorts of problems with undefined references to code not
used by xfs_copy. Ok, so the problem is at your end with custom
build options, not a problem with the code or the default build.

How did you configure this build? Can you run a clean build without
configuring in any of the whacky compiler super-optimisations that
you have and see if that builds cleanly?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
