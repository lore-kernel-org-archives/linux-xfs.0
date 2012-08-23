Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7NFbAtC013742 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 10:37:10 -0500
Message-ID: <50364E68.6010305@sgi.com>
Date: Thu, 23 Aug 2012 10:38:16 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Replace lstat64 with cat in test 120
References: <20120822190605.279843301@sgi.com>
	<20120822194928.493451995@sgi.com> <20120823000212.GS19235@dastard>
In-Reply-To: <20120823000212.GS19235@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/22/2012 07:02 PM, Dave Chinner wrote:
> On Wed, Aug 22, 2012 at 02:49:06PM -0500, Rich Johnston wrote:
>> The later versions of libtool (i.e.2.4+) create a wrapper (bash script) for
>> lstat64 in the src directory.  The wrapper calls the real binary created by
>> libtool (.libs/lstat64)
>
> Doesn't happen here. libtool 2.4.2 generates a dynamically linked
> executable.
>

OK I agree I made an incorrect assumption that it would happen with 
later versions of libtool. It does happen with libtool 2.4 on openSUSE 
12.1 and could with other Linux distributions. No special modifications 
were made to the build environment.  I will correct the comment to 
reflect my exact error.

> $ libtool --version
> libtool (GNU libtool) 2.4.2
> Written by Gordon Matzigkeit <gord@gnu.ai.mit.edu>, 1996
>
> Copyright (C) 2011 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> $ rm src/lstat64
> $ make
> Building include
> Building lib
> Building ltp
> Building src
>      [CC]    lstat64
> Building aio-dio-regress
> Building m4
> $ file src/lstat64
> src/lstat64: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.26, BuildID[sha1]=0x7d7c9b54f75589968ca143cac23e1d3491ea3e17, not stripped

$ file src/lstat64
src/lstat64: POSIX shell script, ASCII text

$ file src/.libs/lstat64
src/.libs/lstat64: ELF 32-bit LSB executable, Intel 80386, version 1 
(SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.16, 
BuildID[sha1]=0xbaba36df9ff7ec91866d295866147dc5fcba7f23, not stripped

> $ ldd src/lstat64
>          linux-vdso.so.1 =>  (0x00007fffc4b72000)
> 	libattr.so.1 => /lib/x86_64-linux-gnu/libattr.so.1 (0x00007f67f24b7000)
> 	libhandle.so.1 => /lib/libhandle.so.1 (0x00007f67f22b3000)
> 	libacl.so.1 => /lib/x86_64-linux-gnu/libacl.so.1 (0x00007f67f20a9000)
> 	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f67f1d22000)
> 	/lib64/ld-linux-x86-64.so.2 (0x00007f67f26cf000)

$ ldd src/.libs/lstat64
	linux-gate.so.1 =>  (0xffffe000)
	libattr.so.1 => /lib/libattr.so.1 (0xb77b8000)
	libhandle.so.1 => /lib/libhandle.so.1 (0xb77b3000)
	libacl.so.1 => /lib/libacl.so.1 (0xb77a9000)
	libc.so.6 => /lib/libc.so.6 (0xb763d000)
	/lib/ld-linux.so.2 (0xb77cb000)

> $ ls -la src/.libs
> total 8
> drwxr-xr-x 2 dave dave 4096 Aug 23 09:45 .
> drwxr-xr-x 4 dave dave 4096 Aug 23 09:54 ..
> $

$ ls -la src/.libs
total 1280
drwxr-xr-x 2 root root  4096 Aug 23 10:08 .
drwxr-xr-x 4 root root  4096 Aug 23 10:08 ..
-rwxr-xr-x 1 root root 24946 Aug 21 14:16 alloc
-rwxr-xr-x 1 root root 11801 Aug 21 14:16 append_reader
-rwxr-xr-x 1 root root 11960 Aug 21 14:16 append_writer
-rwxr-xr-x 1 root root 21376 Aug 21 14:16 bstat
-rwxr-xr-x 1 root root 20898 Aug 21 14:16 bulkstat_unlink_test
-rwxr-xr-x 1 root root 20521 Aug 21 14:16 bulkstat_unlink_test_modified
-rwxr-xr-x 1 root root 17668 Aug 21 14:16 devzero
-rwxr-xr-x 1 root root 20841 Aug 21 14:16 dirperf
-rwxr-xr-x 1 root root 27682 Aug 21 14:14 dirstress
-rwxr-xr-x 1 root root 20413 Aug 21 14:16 dmiperf
-rwxr-xr-x 1 root root 12714 Aug 21 14:16 fault
-rwxr-xr-x 1 root root 21188 Aug 21 14:16 feature
-rwxr-xr-x 1 root root 40220 Aug 21 14:16 fiemap-tester
-rwxr-xr-x 1 root root 12438 Aug 21 14:14 fill
-rwxr-xr-x 1 root root 20906 Aug 21 14:14 fill2
-rwxr-xr-x 1 root root 13656 Aug 21 14:16 fs_perms
-rwxr-xr-x 1 root root 24251 Aug 21 14:16 fstest
-rwxr-xr-x 1 root root 19137 Aug 21 14:16 fstrim
-rwxr-xr-x 1 root root 12038 Aug 21 14:16 ftrunc
-rwxr-xr-x 1 root root 18841 Aug 21 14:16 genhashnames
-rwxr-xr-x 1 root root 11955 Aug 21 14:16 getdevicesize
-rwxr-xr-x 1 root root 11311 Aug 21 14:14 getpagesize
-rwxr-xr-x 1 root root 13791 Aug 21 14:16 godown
-rwxr-xr-x 1 root root 18942 Aug 21 14:14 holes
-rwxr-xr-x 1 root root 12124 Aug 21 14:16 itrash
-rwxr-xr-x 1 root root 45189 Aug 21 14:16 locktest
-rwxr-xr-x 1 root root 18693 Aug 21 14:16 looptest
-rwxr-xr-x 1 root root 18328 Aug 23 10:08 lstat64
-rwxr-xr-x 1 root root 22628 Aug 21 14:16 makeextents
-rwxr-xr-x 1 root root 31482 Aug 21 14:16 metaperf
-rwxr-xr-x 1 root root 12651 Aug 21 14:16 mmapcat
-rwxr-xr-x 1 root root 17648 Aug 21 14:16 multi_open_unlink
-rwxr-xr-x 1 root root 29583 Aug 21 14:15 nametest
-rwxr-xr-x 1 root root 19834 Aug 21 14:15 permname
-rwxr-xr-x 1 root root 12107 Aug 21 14:16 preallo_rw_pattern_reader
-rwxr-xr-x 1 root root 12395 Aug 21 14:16 preallo_rw_pattern_wrhead 
src/lstat64
#! /bin/sh

# lstat64 - temporary wrapper script for .libs/lstat64
# Generated by libtool (GNU libtool) 2.4
#
# The lstat64 program cannot be directly executed until all the libtool
# libraries that it depends on are installed.
#
# This wrapper script should never be moved out of the build directory.
# If it is, it will not operate correctly.
iter
-rwxr-xr-x 1 root root 12206 Aug 21 14:16 pwrite_mmap_blocked
-rwxr-xr-x 1 root root 35609 Aug 21 14:15 randholes
-rwxr-xr-x 1 root root 11425 Aug 21 14:16 rename
-rwxr-xr-x 1 root root 18977 Aug 21 14:16 resvtest
-rwxr-xr-x 1 root root 17openSUSE 12.1544 Aug 21 14:15 runas
-rwxr-xr-x 1 root root 20415 Aug 21 14:16 seek_copy_test
-rwxr-xr-x 1 root root 38136 Aug 21 14:16 seek_sanity_test
-rwxr-xr-x 1 root root 13713 Aug 21 14:16 stale_handle
-rwxr-xr-x 1 root root 13100 Aug 21 14:16 t_access_root
-rwxr-xr-x 1 root root 12099 Aug 21 14:16 t_dir_offset
-rwxr-xr-x 1 root root 12858 Aug 21 14:16 t_dir_offset2
-rwxr-xr-x 1 root root 11096 Aug 21 14:16 testx
-rwxr-xr-x 1 root root 12631 Aug 21 14:16 t_futimens
-rwxr-xr-x 1 root root 11685 Aug 21 14:16 t_holes
-rwxr-xr-x 1 root root 81838 Aug 21 14:16 t_immutable
-rwxr-xr-x 1 root root 12105 Aug 21 14:16 t_mmap_writev
-rwxr-xr-x 1 root root 21924 Aug 21 14:16 t_mtab
-rwxr-xr-x 1 root root 17474 Aug 21 14:16 trunc
-rwxr-xr-x 1 root root 19694 Aug 21 14:16 truncfile
-rwxr-xr-x 1 root root 12034 Aug 21 14:16 t_stripealign
-rwxr-xr-x 1 root root 12510 Aug 21 14:16 unwritten_mmap
-rwxr-xr-x 1 root root 18964 Aug 21 14:16 unwritten_sync
-rwxr-xr-x 1 root root 12282 Aug 21 14:16 usemem
-rwxr-xr-x 1 root root 11873 Aug 21 14:16 writemod
-rwxr-xr-x 1 root root 21055 Aug 21 14:16 xfsctl

head src/lstat64
#! /bin/sh

# lstat64 - temporary wrapper script for .libs/lstat64
# Generated by libtool (GNU libtool) 2.4
#
# The lstat64 program cannot be directly executed until all the libtool
# libraries that it depends on are installed.
#
# This wrapper script should never be moved out of the build directory.
# If it is, it will not operate correctly.

>
>> Test 120 only copies src/lstat64 to $SCRATCH_MNT.  If a later version of
>> libtool is used then only the wrapper is copied to $SCRATCH_MNT and the wrapper
>> will fail to find .libs/lstat64.
I will correct this comment too.
>>
>>     ~/xfstests # diff 120.out 120.out.bad
>>     /mnt/scratch/lstat64: error: `/mnt/scratch/.libs/lstat64' does not exist
>>     This script is just a wrapper for lstat64.
>>     See the libtool documentation for more information.
>
> $ sudo ./check -X expunged generic/120
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test-2 3.0.39-dgc+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
>
> generic/120      15s
> Ran: generic/120
> Passed all 1 tests
> $
>
> This is how it is built here:
>
> $ make Q=
> .....
>      [CC]    lstat64
> /usr/bin/libtool --quiet --tag=CC --mode=link gcc lstat64.c -o lstat64 -g -O2 -g -O2 -DDEBUG  -I../include -DVERSION=\"1.1.0\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -DHAVE_FALLOCATE   -lattr -lhandle -lacl   ../lib/libtest.la
>
     [CC]    lstat64
libtool: link: gcc lstat64.c -o .libs/lstat64 -g -O2 -g -O2 -DDEBUG 
-I../include -DVERSION=\"1.1.0\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 
-funsigned-char -fno-strict-aliasing -Wall -DHAVE_FALLOCATE  -lattr 
/root/xfstests/../xfsprogs/libhandle/.libs/libhandle.so -lacl 
../lib/.libs/libtest.a

> I think this error indicates somethign wrong with your build
> environment or platform, not that there is anything wrong with the
> test.

Don't agree, the build environment was not modified from the default 
installation and the script was created by libtool.

$ head src/lstat64
#! /bin/sh

# lstat64 - temporary wrapper script for .libs/lstat64
# Generated by libtool (GNU libtool) 2.4
#
# The lstat64 program cannot be directly executed until all the libtool
# libraries that it depends on are installed.
#
# This wrapper script should never be moved out of the build directory.
# If it is, it will not operate correctly.

Why take the risk of this error when /bin/cat is a perfectly acceptable 
substitution and would prevent the possibility of this happening.

  What system are you building on?

openSUSE 12.1

>
> Cheers,
>
> Dave.
>

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
