Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40484 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725648AbfHLEb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 00:31:57 -0400
Date: Mon, 12 Aug 2019 14:30:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
Message-ID: <20190812043046.GB6129@dread.disaster.area>
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812031123.GA6129@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Deutschmann <whissi@gentoo.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Mon, Aug 12, 2019 at 01:11:23PM +1000, Dave Chinner wrote:
> On Mon, Aug 12, 2019 at 03:21:28AM +0200, Thomas Deutschmann wrote:
> > On 2019-08-12 02:23, Dave Chinner wrote:
> > > That still doesn't explain where all the whacky gcc options are
> > > coming from - that's got to be something specific to your build or
> > > distro environment.
> > 
> > Mh, at the moment it looks like xfsprogs' build system is adding
> > $LDFLAGS multiple times when LDFLAGS is set in environment.
> > 
> > In a clear environment, do:
> > 
> > > tar -xaf xfsprogs-5.2.0.tar.xz
> > > cd xfsprogs-5.2.0
> > > export CFLAGS="-O2 -pipe -march=ivybridge -mtune=ivybridge -mno-xsaveopt"
> > > export LDFLAGS="-Wl,-O1 -Wl,--as-needed"
>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Don't do this.
> 
> "--as-needed" is the default linker behaviour since gcc 4.x. You do
> not need this. As for passing "-O1" to the linker, that's not going
> to do anything measurable for you. Use --enable-lto to turn on link
> time optimisations if they are supported by the compiler.

Ok, I could reproduce your link time failure for a while with
--enable-lto, but I ran 'make distclean' and the problem went away
completely. And I can build with your options successfully, too:

$ make realclean
$ make configure
<builds new configure script>
$ LDFLAGS="-Wl,-O1 -Wl,--as-needed" ./configure
.....
$ make -j32
<builds successfully>
$ touch copy/xfs_copy.c
$ make Q=
....
Building copy
/usr/bin/make --no-print-directory Q= -q -C copy || /usr/bin/make --no-print-directory Q= -C copy
gcc -MM -g -O2 -D_FILE_OFFSET_BITS=64   -g -O2 -DDEBUG -DVERSION=\"5.2.0\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -I../libxfs -DENABLE_GETTEXT -D_GNU_SOURCE -funsigned-char -fno-strict-aliasing -Wall -DHAVE_MNTENT -DHAVE_FSETXATTR -DENABLE_BLKID -DHAVE_GETFSMAP  xfs_copy.c > .dep
rm -f .dep
    [CC]     xfs_copy.o
gcc -g -O2 -D_FILE_OFFSET_BITS=64   -g -O2 -DDEBUG -DVERSION=\"5.2.0\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -I../libxfs -DENABLE_GETTEXT -D_GNU_SOURCE -funsigned-char -fno-strict-aliasing -Wall -DHAVE_MNTENT -DHAVE_FSETXATTR -DENABLE_BLKID -DHAVE_GETFSMAP  -c xfs_copy.c
    [LD]     xfs_copy
/bin/bash ../libtool --quiet --tag=CC --mode=link gcc -o xfs_copy  -Wl,-O1 -Wl,--as-needed -static-libtool-libs  xfs_copy.o   ../libxfs/libxfs.la ../libxlog/libxlog.la ../libfrog/libfrog.la -luuid -lpthread -lrt  
Building db
....

So, before you try to build, start with

$ make realclean; make configure

to make sure you are running a configure script that is built from
the release tarball source code, then run your custom build and
see what happens.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
