Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36982 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbdICHVX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 03:21:23 -0400
Received: by mail-pg0-f67.google.com with SMTP id t193so2631809pgc.4
        for <linux-xfs@vger.kernel.org>; Sun, 03 Sep 2017 00:21:23 -0700 (PDT)
Date: Sun, 3 Sep 2017 00:21:20 -0700
From: Khem Raj <raj.khem@gmail.com>
Subject: Re: [PATCH] Rename progname as it is provided by libc
Message-ID: <20170903072120.bqlcn76qzc3qze6z@apollo>
References: <20170902215451.29265-1-raj.khem@gmail.com>
 <20170902222003.GD10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20170902222003.GD10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 08:20:03AM +1000, Dave Chinner wrote:
> On Sat, Sep 02, 2017 at 02:54:51PM -0700, Khem Raj wrote:
> > Rename local variable progname to avoid a clash with libc
> > global symbols
>=20
> What libc is causing this problem?
>=20
> And why is it considered ok for that libc to pollute the global
> variable namespace with it's own internal variables?

A closer look reveals that its getting the function from another local libr=
ary which is used
on the linker commandline. below is full cmdline

=2E./arm-bec-linux-musleabi-libtool --quiet --tag=3DCC --mode=3Dlink ../../=
recipe-sysroot-native/usr/bin/arm-bec-linux-musleabi/arm-bec-linux-musleabi=
-clang -march=3Darmv7ve -mthumb -mfpu=3Dneon-vfpv4 -mfloat-abi=3Dhard -mcpu=
=3Dcortex-a7 -mlittle-endian -D__extern_always_inline=3Dinline -no-integrat=
ed-as -Wno-error=3Dunused-command-line-argument -Qunused-arguments -fstack-=
protector-strong  -D_FORTIFY_SOURCE=3D2 -Wformat -Wformat-security -Werror=
=3Dformat-security --sysroot=3D/mnt/a/oe/build/tmp/work/cortexa7t2hf-neon-v=
fpv4-bec-linux-musleabi/xfsprogs/4.12.0-r0/recipe-sysroot -o xfs_io -Wl,-O1=
 -Wl,--hash-style=3Dgnu -Wl,--as-needed -fstack-protector-strong -Wl,-z,rel=
ro,-z,now -Wl,-O1 -Wl,--hash-style=3Dgnu -Wl,--as-needed -fstack-protector-=
strong -Wl,-z,relro,-z,now  -Wl,-O1 -Wl,--hash-style=3Dgnu -Wl,--as-needed =
-fstack-protector-strong -Wl,-z,relro,-z,now  -Wl,-O1 -Wl,--hash-style=3Dgn=
u -Wl,--as-needed -fstack-protector-strong -Wl,-z,relro,-z,now -static-libt=
ool-libs  init.o attr.o bmap.o cowextsize.o encrypt.o file.o freeze.o fsync=
=2Eo getrusage.o imap.o link.o mmap.o open.o parent.o pread.o prealloc.o pw=
rite.o reflink.o seek.o shutdown.o stat.o sync.o truncate.o utimes.o fadvis=
e.o madvise.o mincore.o sendfile.o fiemap.o inject.o resblks.o copy_file_ra=
nge.o sync_file_range.o readdir.o fsmap.o   ../libxcmd/libxcmd.la ../libhan=
dle/libhandle.la -luuid -lpthread -lreadline


libxfs.so.0                   init.o (progname)

and also from init.o object from current directory

$ readelf -sW init.o | grep progname                                       =
                                                                           =
                                                                          (=
09-03 00:17)
    56: 00000004     4 OBJECT  GLOBAL DEFAULT  COM progname

readelf -sW ../libxfs/.libs/libxfs.so.0 | grep progname                    =
                                                                           =
                                                                        (09=
-03 00:19)
   214: 0005d004     4 OBJECT  GLOBAL DEFAULT   18 progname

Thats what is causing the conflict.

>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
