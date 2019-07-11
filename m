Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59398 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727479AbfGKGC4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jul 2019 02:02:56 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B0E7728A4E
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2019 06:02:54 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204129] New: [xfstests generic/127]: fsx find corruption on xfs
Date: Thu, 11 Jul 2019 06:02:52 +0000
Message-ID: <bug-204129-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204129

            Bug ID: 204129
           Summary: [xfstests generic/127]: fsx find corruption on xfs
           Product: File System
           Version: 2.5
    Kernel Version: 5.2.0-rc4 xfs-5.3-merge-10
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

generic/127 fails on x86_64 (with tiny chance):

FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 xxxxx 5.2.0-rc4+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda3
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda3
/mnt/xfstests/mnt2

generic/127 1269s ... - output mismatch (see
/var/lib/xfstests/results//generic/127.out.bad)
    --- tests/generic/127.out   2019-07-09 11:33:11.000000000 -0400
    +++ /var/lib/xfstests/results//generic/127.out.bad  2019-07-10
16:19:46.040467067 -0400
    @@ -10,4 +10,10042 @@
     === FSX Standard Mode, No Memory Mapping ===
     All 100000 operations completed A-OK!
     === FSX Standard Mode, Memory Mapping ===
    -All 100000 operations completed A-OK!
    +ltp/fsx -f -q -l 262144 -o 65536 -S 191110531 -N 100000 fsx_std_mmap
    +READ BAD DATA: offset = 0x7b1a, size = 0xa50c, fname =
/mnt/xfstests/mnt1/fsx_std_mmap
    +OFFSET     GOOD    BAD     RANGE
    ...
    (Run 'diff -u /var/lib/xfstests/tests/generic/127.out
/var/lib/xfstests/results//generic/127.out.bad'  to see the entire diff)
Ran: generic/127
Failures: generic/127
Failed 1 of 1 tests

# cat results/tests/generic/127.out.bad
QA output created by 127
=== FSX Light Mode, No Memory Mapping ===
All 100000 operations completed A-OK!
=== FSX Light Mode, Memory Mapping ===
All 100000 operations completed A-OK!
=== FSX Standard Mode, No Memory Mapping ===
All 100000 operations completed A-OK!
=== FSX Standard Mode, Memory Mapping ===
All 100000 operations completed A-OK!
=== FSX Standard Mode, No Memory Mapping ===
All 100000 operations completed A-OK!
=== FSX Standard Mode, Memory Mapping ===
ltp/fsx -f -q -l 262144 -o 65536 -S 191110531 -N 100000 fsx_std_mmap
READ BAD DATA: offset = 0x7b1a, size = 0xa50c, fname =
/mnt/xfstests/mnt1/fsx_std_mmap
OFFSET  GOOD    BAD     RANGE
0x0b000 0x0000  0x0791  0x00000
operation# (mod 256) for the bad data may be 7
0x0b001 0x0000  0x9107  0x00001
operation# (mod 256) for the bad data may be 7
0x0b002 0x0000  0x0768  0x00002
operation# (mod 256) for the bad data may be 7
0x0b003 0x0000  0x6807  0x00003
operation# (mod 256) for the bad data may be 7
0x0b004 0x0000  0x0771  0x00004
operation# (mod 256) for the bad data may be 7
0x0b005 0x0000  0x7107  0x00005
operation# (mod 256) for the bad data may be 7
0x0b006 0x0000  0x07da  0x00006
operation# (mod 256) for the bad data may be 7
0x0b007 0x0000  0xda07  0x00007
operation# (mod 256) for the bad data may be 7
0x0b008 0x0000  0x0779  0x00008
operation# (mod 256) for the bad data may be 7
0x0b009 0x0000  0x7907  0x00009
operation# (mod 256) for the bad data may be 7
0x0b00a 0x0000  0x07c5  0x0000a
operation# (mod 256) for the bad data may be 7
0x0b00b 0x0000  0xc507  0x0000b
operation# (mod 256) for the bad data may be 7
0x0b00c 0x0000  0x0794  0x0000c
operation# (mod 256) for the bad data may be 7
0x0b00d 0x0000  0x9407  0x0000d
operation# (mod 256) for the bad data may be 7
0x0b00e 0x0000  0x07f6  0x0000e
operation# (mod 256) for the bad data may be 7
0x0b00f 0x0000  0xf607  0x0000f
operation# (mod 256) for the bad data may be 7
LOG DUMP (67705 total operations):
67706(122 mod 256): MAPREAD  0x11fb9 thru 0x1afee       (0x9036 bytes)
67707(123 mod 256): INSERT 0x1a000 thru 0x1bfff (0x2000 bytes)
67708(124 mod 256): CLONE 0x2000 thru 0xbfff    (0xa000 bytes) to 0x15000 thru
0x1efff  JJJJ******
67709(125 mod 256): CLONE 0x0 thru 0xafff       (0xb000 bytes) to 0xf000 thru
0x19fff
67710(126 mod 256): TRUNCATE DOWN       from 0x29000 to 0x212f5
67711(127 mod 256): FALLOC   0x1892c thru 0x28212       (0xf8e6 bytes)
EXTENDING
67712(128 mod 256): DEDUPE 0x1a000 thru 0x1dfff (0x4000 bytes) to 0x16000 thru
0x19fff
67713(129 mod 256): FALLOC   0x2b296 thru 0x39011       (0xdd7b bytes) PAST_EOF
67714(130 mod 256): COPY 0xedc3 thru 0x16683    (0x78c1 bytes) to 0x42c7 thru
0xbb87
67715(131 mod 256): TRUNCATE UP from 0x28212 to 0x36467
....
....
67694(110 mod 256): ZERO     0x344d0 thru 0x35ccc       (0x17fd bytes)
67695(111 mod 256): MAPWRITE 0x143f4 thru 0x20f16       (0xcb23 bytes)
67696(112 mod 256): TRUNCATE DOWN       from 0x3bf04 to 0x26c12
67697(113 mod 256): COPY 0x14e5 thru 0x858a     (0x70a6 bytes) to 0xadf4 thru
0x11e99   ******EEEE
67698(114 mod 256): COLLAPSE 0x16000 thru 0x23fff       (0xe000 bytes)
67699(115 mod 256): ZERO     0x102f4 thru 0x18c11       (0x891e bytes)
67700(116 mod 256): INSERT 0x2000 thru 0xbfff   (0xa000 bytes)  ******IIII
67701(117 mod 256): READ     0x13b94 thru 0x1d4a4       (0x9911 bytes)
67702(118 mod 256): COPY 0x1a4d9 thru 0x1ad72   (0x89a bytes) to 0x1141b thru
0x11cb4
67703(119 mod 256): TRUNCATE UP from 0x22c12 to 0x23e43
67704(120 mod 256): WRITE    0x22bb1 thru 0x30f77       (0xe3c7 bytes) EXTEND
67705(121 mod 256): MAPREAD  0x7b1a thru 0x12025        (0xa50c bytes) 
***RRRR***
Log of operations saved to "/mnt/xfstests/mnt1/fsx_std_mmap.fsxops"; replay
with --replay-ops
Correct content saved for comparison
(maybe hexdump "/mnt/xfstests/mnt1/fsx_std_mmap" vs
"/mnt/xfstests/mnt1/fsx_std_mmap.fsxgood")

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
