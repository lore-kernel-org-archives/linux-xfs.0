Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N01Vvj084300 for <xfs@oss.sgi.com>; Wed, 22 Aug 2012 19:01:32 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iTXWPsVab2GuBMmw for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 17:02:13 -0700 (PDT)
Date: Thu, 23 Aug 2012 10:02:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: Replace lstat64 with cat in test 120
Message-ID: <20120823000212.GS19235@dastard>
References: <20120822190605.279843301@sgi.com>
	<20120822194928.493451995@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120822194928.493451995@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 22, 2012 at 02:49:06PM -0500, Rich Johnston wrote:
> The later versions of libtool (i.e.2.4+) create a wrapper (bash script) for
> lstat64 in the src directory.  The wrapper calls the real binary created by
> libtool (.libs/lstat64)

Doesn't happen here. libtool 2.4.2 generates a dynamically linked
executable.

$ libtool --version
libtool (GNU libtool) 2.4.2
Written by Gordon Matzigkeit <gord@gnu.ai.mit.edu>, 1996

Copyright (C) 2011 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
$ rm src/lstat64
$ make
Building include
Building lib
Building ltp
Building src
    [CC]    lstat64
Building aio-dio-regress
Building m4
$ file src/lstat64
src/lstat64: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.26, BuildID[sha1]=0x7d7c9b54f75589968ca143cac23e1d3491ea3e17, not stripped
$ ldd src/lstat64
        linux-vdso.so.1 =>  (0x00007fffc4b72000)
	libattr.so.1 => /lib/x86_64-linux-gnu/libattr.so.1 (0x00007f67f24b7000)
	libhandle.so.1 => /lib/libhandle.so.1 (0x00007f67f22b3000)
	libacl.so.1 => /lib/x86_64-linux-gnu/libacl.so.1 (0x00007f67f20a9000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f67f1d22000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f67f26cf000)
$ ls -la src/.libs
total 8
drwxr-xr-x 2 dave dave 4096 Aug 23 09:45 .
drwxr-xr-x 4 dave dave 4096 Aug 23 09:54 ..
$

> Test 120 only copies src/lstat64 to $SCRATCH_MNT.  If a later version of
> libtool is used then only the wrapper is copied to $SCRATCH_MNT and the wrapper
> will fail to find .libs/lstat64.
> 
>    ~/xfstests # diff 120.out 120.out.bad
>    /mnt/scratch/lstat64: error: `/mnt/scratch/.libs/lstat64' does not exist
>    This script is just a wrapper for lstat64.
>    See the libtool documentation for more information.

$ sudo ./check -X expunged generic/120
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test-2 3.0.39-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

generic/120      15s
Ran: generic/120
Passed all 1 tests
$

This is how it is built here:

$ make Q=
.....
    [CC]    lstat64
/usr/bin/libtool --quiet --tag=CC --mode=link gcc lstat64.c -o lstat64 -g -O2 -g -O2 -DDEBUG  -I../include -DVERSION=\"1.1.0\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -DHAVE_FALLOCATE   -lattr -lhandle -lacl   ../lib/libtest.la

I think this error indicates somethign wrong with your build
environment or platform, not that there is anything wrong with the
test. What system are you building on?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
