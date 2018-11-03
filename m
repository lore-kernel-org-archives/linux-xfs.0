Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56788 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725924AbeKCMOx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Nov 2018 08:14:53 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 628AE2B384
        for <linux-xfs@vger.kernel.org>; Sat,  3 Nov 2018 03:05:07 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201259] [xfstests shared/010]: maybe pagecache contents is
 mutated after cycle mount
Date: Sat, 03 Nov 2018 03:05:06 +0000
Message-ID: <bug-201259-201763-y1z53z33qd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201259-201763@https.bugzilla.kernel.org/>
References: <bug-201259-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201259

--- Comment #6 from Zorro Lang (zlang@redhat.com) ---
After upstream merged the patch of this bug, I still can reproduce a shared/010
failure:

FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 xxxxxxxx 4.19.0+
MKFS_OPTIONS  -- -f -m reflink=1 -b size=1024 /dev/mapper/xxxxxxxx-xfscratch
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0
/dev/mapper/xxxxxxxxx-xfscratch /mnt/scratch

shared/010 160s ... - output mismatch (see
/home/xfstests-dev/results//shared/010.out.bad)
    --- tests/shared/010.out    2018-10-16 23:31:53.924269141 -0400
    +++ /home/xfstests-dev/results//shared/010.out.bad  2018-11-02
12:20:39.858510419 -0400
    @@ -1,2 +1,4 @@
     QA output created by 010
    +/mnt/scratch/dir/p0/da/d51XX/f6dXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX: FAILED
    +md5sum: WARNING: 1 computed checksum did NOT match
     Silence is golden
    ...
    (Run 'diff -u tests/shared/010.out
/home/xfstests-dev/results//shared/010.out.bad'  to see the entire diff)
Ran: shared/010
Failures: shared/010
Failed 1 of 1 tests

But maybe it's a new issue, due to I can't reproduce this bug by the reproducer
on comment#1:

# bash reproducer.sh
umount: /mnt/scratch: not mounted.
wrote 17179869184/17179869184 bytes at offset 0
16.000 GiB, 4194304 ops; 0:16:47.88 (16.256 MiB/sec and 4161.4915 ops/sec)
meta-data=/dev/mapper/xxxxxxxx-xfscratch isize=512    agcount=16,
agsize=8192000 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=131072000, imaxpct=25
         =                       sunit=64     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=64000, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
wrote 1772544/1772544 bytes at offset 0
2 MiB, 433 ops; 0.0170 sec (99.111 MiB/sec and 25386.9606 ops/sec)
wrote 840263/840263 bytes at offset 0
821 KiB, 206 ops; 0.0083 sec (96.419 MiB/sec and 24786.4276 ops/sec)
linked 57344/57344 bytes at offset 212992
56 KiB, 1 ops; 0.0030 sec (17.698 MiB/sec and 323.6246 ops/sec)
wrote 74240/74240 bytes at offset 1662464
72 KiB, 19 ops; 0.0010 sec (65.984 MiB/sec and 17707.3625 ops/sec)
linked 122880/122880 bytes at offset 5357568
120 KiB, 1 ops; 0.0037 sec (31.477 MiB/sec and 268.6006 ops/sec)
a42583dd3f7edb0c00e7356c89d3e58c  /mnt/scratch/file
a42583dd3f7edb0c00e7356c89d3e58c  /mnt/scratch/file
/mnt/scratch/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..415]:        hole                                   416
   1: [416..527]:      4880..4991        0 (4880..4991)       112 101111
   2: [528..1215]:     hole                                   688
   3: [1216..2863]:    1024..2671        0 (1024..2671)      1648 010101
   4: [2864..3239]:    hole                                   376
   5: [3240..3583]:    2672..3015        0 (2672..3015)       344 001111
   6: [3584..10463]:   hole                                  6880
   7: [10464..10703]:  7800..8039        0 (7800..8039)       240 101111
 FLAG Values:
    0100000 Shared extent
    0010000 Unwritten preallocated extent
    0001000 Doesn't begin on stripe unit
    0000100 Doesn't end   on stripe unit
    0000010 Doesn't begin on stripe width
    0000001 Doesn't end   on stripe width
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00034000  72 72 72 72 72 72 72 72  72 72 72 72 72 72 72 72  |rrrrrrrrrrrrrrrr|
*
00042000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00195e00  57 57 57 57 57 57 57 57  57 57 57 57 57 57 57 57  |WWWWWWWWWWWWWWWW|
*
001a8000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
0051c000  52 52 52 52 52 52 52 52  52 52 52 52 52 52 52 52  |RRRRRRRRRRRRRRRR|
*
0053a000

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
