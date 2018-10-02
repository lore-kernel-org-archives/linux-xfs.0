Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51514 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727351AbeJBXIU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 19:08:20 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0925F2845C
        for <linux-xfs@vger.kernel.org>; Tue,  2 Oct 2018 16:24:09 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201259] [xfstests shared/010]: maybe pagecache contents is
 mutated after cycle mount
Date: Tue, 02 Oct 2018 16:24:09 +0000
Message-ID: <bug-201259-201763-KMBb066UgD@https.bugzilla.kernel.org/>
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

--- Comment #3 from Eric Sandeen (sandeen@sandeen.net) ---
Here's a slightly simpler test on smaller, block boundaries:

xfs_io -f -c "pwrite -S 0x72 0 4096" $DONOR1
xfs_io -f -c "pwrite -S 0x52 0 4096" $DONOR2

xfs_io -f \
        -c "falloc -k 8192 4096"        \
        -c "reflink $DONOR1 0 4096 4096" \
        -c "pwrite -S 0x57 65536 8192" \
        -c "fdatasync" \
        -c "reflink $DONOR2 0 131072 4096" \
                $TARGET

By block, it does these operations, all within 32 blocks:

          11111111112222222222333
012345678901234567890123456789012
   P
 R
                WW
                                R
P = preallocate
R = reflink
W = write

What we should get out is:

HRPHHHHHHHHHHHHHWWHHHHHHHHHHHHHHR

H = Hole

What we do get out is:

HRPHHHHHHHHHHHHHWWSSSSSSSSSSSSSSR

S = Stale

The extents:

 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          hole                                     8
   1: [8..15]:         112..119          0 (112..119)           8 100000
   2: [16..23]:        104..111          0 (104..111)           8 010000
   3: [24..127]:       hole                                   104
   4: [128..255]:      216..343          0 (216..343)         128 000000
   5: [256..263]:      120..127          0 (120..127)           8 100000

are lined up as (chars represent hole/reflink/prealloc/written/stale)

 H  R  P  HHHHHHHHHHHHH  WWSSSSSSSSSSSSSS  R
[E][E][E][      E      ][        E       ][E]

So the 5th extent is what has exposed the stale data, with written data only in
the first 2 blocks and another 14 blocks exposed up to the next reflinked
block.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
