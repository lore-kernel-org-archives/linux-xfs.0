Return-Path: <SRS0=ZFeo=CV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54104C10DAA
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Sep 2020 05:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CD1A207EA
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Sep 2020 05:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgILFqe convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 12 Sep 2020 01:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbgILFqd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 12 Sep 2020 01:46:33 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209243] New: fsx IO_URING reading get BAD DATA
Date:   Sat, 12 Sep 2020 05:46:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-209243-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209243

            Bug ID: 209243
           Summary: fsx IO_URING reading get BAD DATA
           Product: File System
           Version: 2.5
    Kernel Version: 5.9.0-rc4 with xfs-5.10-merge-1
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

Description of problem:

I've maken xfstests' fsstress and fsx support IO_URING read/write, refer to
below patchset:
https://marc.info/?l=fstests&m=159980858202447&w=2

But the fsx io_uring test on XFS failed:

# ./ltp/fsx -U -R -W -l $((128000*5)) -o 128000 /mnt/scratch/foo
truncating to largest ever: 0x8d1ef
copying to largest ever: 0x94e29
zero_range to largest ever: 0x9c400
READ BAD DATA: offset = 0xadf4, size = 0x1de1d, fname = /mnt/scratch/foo
OFFSET  GOOD    BAD     RANGE
0x17000 0x7e57  0x0000  0x00000
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x17001 0x577e  0x0000  0x00001
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x17002 0x7e81  0x0000  0x00002
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x17003 0x817e  0x0000  0x00003
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x17004 0x7ee5  0x0000  0x00004
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x17005 0xe57e  0x0000  0x00005
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x17006 0x7ec3  0x0000  0x00006
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x17007 0xc37e  0x0000  0x00007
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x17008 0x7e60  0x0000  0x00008
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x17009 0x607e  0x0000  0x00009
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x1700a 0x7ee4  0x0000  0x0000a
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x1700b 0xe47e  0x0000  0x0000b
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x1700c 0x7e16  0x0000  0x0000c
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x1700d 0x167e  0x0000  0x0000d
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x1700e 0x7ebb  0x0000  0x0000e
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x1700f 0xbb7e  0x0000  0x0000f
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
LOG DUMP (6784 total operations):
1(  1 mod 256): TRUNCATE UP     from 0x0 to 0x8d1ef     ******WWWW
2(  2 mod 256): CLONE 0x74000 thru 0x7ffff      (0xc000 bytes) to 0x11000 thru
0x1cfff  ******JJJJ
3(  3 mod 256): COPY 0x896df thru 0x8d1ee       (0x3b10 bytes) to 0x39fd3 thru
0x3dae2
4(  4 mod 256): READ     0x5c4d2 thru 0x72c7d   (0x167ac bytes)
5(  5 mod 256): COPY 0x4fad2 thru 0x676c1       (0x17bf0 bytes) to 0x213f7 thru
0x38fe6
...
...
6775(119 mod 256): WRITE    0x42e2b thru 0x546bf        (0x11895 bytes)
6776(120 mod 256): TRUNCATE DOWN        from 0x7ebed to 0x4a2e5
6777(121 mod 256): READ     0x1c41 thru 0x10ef9 (0xf2b9 bytes)
6778(122 mod 256): PUNCH    0x2ba67 thru 0x466da        (0x1ac74 bytes)
6779(123 mod 256): INSERT 0x3c000 thru 0x59fff  (0x1e000 bytes)
6780(124 mod 256): ZERO     0x2648e thru 0x3bdfc        (0x1596f bytes)
6781(125 mod 256): WRITE    0x2532d thru 0x3b5ed        (0x162c1 bytes)
6782(126 mod 256): WRITE    0xc049 thru 0x20ea9 (0x14e61 bytes) ***WWWW
6783(127 mod 256): FALLOC   0x2420 thru 0x19c4f (0x1782f bytes) INTERIOR
6784(128 mod 256): READ     0xadf4 thru 0x28c10 (0x1de1d bytes) ***RRRR***
Log of operations saved to "/mnt/scratch/foo.fsxops"; replay with --replay-ops
Correct content saved for comparison
(maybe hexdump "/mnt/scratch/foo" vs "/mnt/scratch/foo.fsxgood")

I'll upload foo foo.fsxgood, foo.fsxops and foo.fsxlog files later.

It's easily to reproduce on my system, by the arguments I used above. But same
test can't reproduce this error on ext4.

Version-Release number of selected component (if applicable):
Fedora with upstream xfs-linux for-next HEAD = commit
18a1031619dece8f46b7deb2da477c8134d0bf89 xfs-5.10-merge-1

How reproducible:
100%

Steps to Reproduce:
1. mkfs.xfs -f /dev/mapper/testvg-scratchdev
meta-data=/dev/mapper/testvg-scratchdev isize=512    agcount=4, agsize=1966080
blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=7864320, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=3840, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
2. git clone latest xfstests-dev, and merge the patchset
https://marc.info/?l=fstests&m=159980858202447&w=2
3. build xfstests
4. mount /dev/mapper/testvg-scratchdev /mnt/scratch
5. ./xfstests/ltp/fsx -U -R -W -l $((128000*5)) -o 128000 /mnt/scratch/foo

Additional info:
1) To avoid the same mistake of
https://bugzilla.kernel.org/show_bug.cgi?id=208827, I've tried to deal with the
short read/write of io_uring in fsx. 

2) General fsx test(fsx -S 0 -U /mnt/scratch/foo) doesn't fail, but only when I
specify the "-o" option of fsx, the test fails.

3) Can't reproduce same failure on ext4 by keep running same test on ext4 one
hour.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
