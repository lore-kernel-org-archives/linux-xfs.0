Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34770 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728598AbeJBUhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 16:37:07 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 699CF28BAC
        for <linux-xfs@vger.kernel.org>; Tue,  2 Oct 2018 13:53:37 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201259] [xfstests shared/010]: maybe pagecache contents is
 mutated after cycle mount
Date: Tue, 02 Oct 2018 13:53:37 +0000
Message-ID: <bug-201259-201763-uBQvTQHPQH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201259-201763@https.bugzilla.kernel.org/>
References: <bug-201259-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201259

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net

--- Comment #1 from Eric Sandeen (sandeen@sandeen.net) ---
In trying to get to a more targeted reproducer, this script clearly exposes
stale data, though I'm not seeing an md5sum change across the remount.  The
operations below are a subset of an fsstress sequence that caused a failure in
shared/010 for me.

---
#!/bin/bash

DEV=/dev/pmem0p2
MNT=/mnt/scratch

umount $MNT
xfs_io -d -c "pwrite -S 0x58 0 16g" $DEV
mkfs.xfs -m reflink=1 $DEV
mount $DEV $MNT

DONOR1=$MNT/donor1
DONOR2=$MNT/donor2
TARGET=$MNT/file

rm -f $DONOR1 $DONOR2 $TARGET

xfs_io -f -c "pwrite -S 0x72 0 1772544" $DONOR1
xfs_io -f -c "pwrite -S 0x52 0 840263" $DONOR2

touch $TARGET

xfs_io -f \
        -c "falloc -k 624393 840278"    \
        -c "reflink $DONOR1 925696 212992 57344" \
        -c "pwrite -S 0x57 1662464 74240" \
        -c "fdatasync" \
        -c "reflink $DONOR2 585728 5357568 122880" \
                $TARGET

md5sum $TARGET
umount $MNT
mount $DEV $MNT
md5sum $TARGET
xfs_bmap -vvp $TARGET
hexdump -C $TARGET
---

95580da3cda8eb09c23c8deefb347d77  /mnt/scratch/file
95580da3cda8eb09c23c8deefb347d77  /mnt/scratch/file
/mnt/scratch/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..415]:        hole                                   416
   1: [416..527]:      3648..3759        0 (3648..3759)       112 100000 (first
reflink)
   2: [528..1215]:     hole                                   688
   3: [1216..2863]:    192..1839         0 (192..1839)       1648 010000
(fallocated)
   4: [2864..3239]:    hole                                   376
   5: [3240..3455]:    5304..5519        0 (5304..5519)       216 000000
(pwrite)
   6: [3456..10463]:   hole                                  7008
   7: [10464..10703]:  6664..6903        0 (6664..6903)       240 100000 (2nd
reflink)


00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
(hole)
*
00034000  72 72 72 72 72 72 72 72  72 72 72 72 72 72 72 72  |rrrrrrrrrrrrrrrr|
(first reflink)
*
00042000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
(hole + fallocated)
*
00195e00  57 57 57 57 57 57 57 57  57 57 57 57 57 57 57 57  |WWWWWWWWWWWWWWWW|
(pwrite)
*
001a8000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58  |XXXXXXXXXXXXXXXX|
(stale 32k)
*
001b0000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
(hole)
*
0051c000  52 52 52 52 52 52 52 52  52 52 52 52 52 52 52 52  |RRRRRRRRRRRRRRRR|
(2nd reflink)
*
0053a000


the "XXXXXXX" is exposed stale data (no pwrite in the script wrote 'X', that is
the disk pattern)
The pattern starts right after the end of the pwrite call of the script.  There
also seems to be a reflinked extent prior to the pwrite.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
