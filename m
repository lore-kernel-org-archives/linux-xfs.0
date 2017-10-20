Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54614 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753036AbdJTQwd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 12:52:33 -0400
MIME-Version: 1.0
From: Anatoly Pugachev <matorola@gmail.com>
Date: Fri, 20 Oct 2017 19:52:31 +0300
Message-ID: <CADxRZqwUfeGJOxsdEyaOHHJPmQUp8sNkxQdZPOKjyEejeZXMmA@mail.gmail.com>
Subject: [fstests] hardcoded values in common/rc for xfs (and probably others)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests <fstests@vger.kernel.org>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

Hello!

While running generic/012 on xfs filesystem created on sparc64 linux
(pagesize 8k) with "mkfs.xfs -b size=8192 /dev/vdiskb1" (but not with
the default mkfs.xfs which will use 4k block size) , I'm getting the
following output:

root@ttip:xfstests-dev# cat local.config
export TEST_DIR=/testvol
export TEST_DEV=/dev/vdiskb1
export SCRATCH_DEV_POOL="/dev/loop0 /dev/loop1 /dev/loop2"
export SCRATCH_MNT=/1/scratch
export MKFS_OPTIONS="-m reflink=1"

root@ttip:xfstests-dev# mkfs.xfs -b size=8192 -m reflink=1 -f /dev/vdiskb1
meta-data=/dev/vdiskb1           isize=512    agcount=4, agsize=983008 blks
         =                       sectsz=8192  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0,
rmapbt=0, reflink=1
data     =                       bsize=8192   blocks=3932032, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=8192   ascii-ci=0 ftype=1
log      =internal log           bsize=8192   blocks=2160, version=2
         =                       sectsz=8192  sunit=1 blks, lazy-count=1
realtime =none                   extsz=8192   blocks=0, rtextents=0

root@ttip:xfstests-dev# ./check generic/012
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/sparc64 ttip 4.14.0-rc5
MKFS_OPTIONS  -- -f -m reflink=1 /dev/loop0
MOUNT_OPTIONS -- /dev/loop0 /1/scratch

generic/012 2s ... [not run] xfs_io fcollapse failed (old kernel/wrong
fs/bad args?)
Not run: generic/012
Passed all 0 tests

root@ttip:xfstests-dev# xfs_io -V
xfs_io version 4.13.1


debugging it, comes from the following xfs_io command:

root@ttip:xfstests-dev# mount /dev/vdiskb1 /testvol/
root@ttip:xfstests-dev# /opt/xfsprogs/sbin/xfs_io -i -F -f -c "pwrite
0 20k" -c fsync -c "fcollapse 4k 8k" /testvol/248329.xfs_io 2>&1
wrote 20480/20480 bytes at offset 0
20 KiB, 3 ops; 0.0000 sec (95.741 MiB/sec and 14705.8824 ops/sec)
fallocate: Invalid argument


While chatting in #xfs irc channel, Darrick told that there is should
not be hardcoded values (like 4k for fcollapse) in generic/012, but it
comes from _require_xfs_io_command() from common/rc, quote:

19:19 < djwong> anyway... fcollapse (and finsert) both requires that
the offset/length arguments are block-aligned
19:19 < djwong> hence you can't fcollapse starting at 4k on an fs with 8k blocks

And it's not only generic/012, it fails generic/0{16,17,21,22} (and
probably more) as well.

Can someone look into this issue?
Thanks.
