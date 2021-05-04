Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB98C433B4
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 00:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1996A61186
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 00:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhEDAVs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 May 2021 20:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhEDAVr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 May 2021 20:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDCBD610FB;
        Tue,  4 May 2021 00:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620087654;
        bh=xG9C2+AArrsKqsrXAb6IESiDpS3jFnqCxzhGnxSXM0I=;
        h=Date:From:To:Cc:Subject:From;
        b=PWIyGnbUZTTvyOSqX7Jeqo1TX5uCwzbgJPKOUvyFppKdUvsVsgrfRZm88z+ayWDuV
         ss6xgwCUL56oM3dbZWk0lylgHfOSrBeQhDok4+FuVIyPxx78k+m+6n50MS01NGE6k7
         c94A+wkS+0qmPZCi7zmL+wta7ybY9hZkLZrfOKhsgHRdNdqvToXcUkwLWy+t/f3WxL
         xSk5FMKMW/DxFoszN+AEA2rC+2Da/sI18lId+67qJ6TtpYZkCnYLJt7MgLZeSprM9G
         iGogDWBx0HuvrdEW2qLULwTutWbVPd0yBnT5YEjzDvlPFr+TXqxb2MzfVNFh9IoIJF
         L7R2HX4d/Pbeg==
Date:   Mon, 3 May 2021 17:20:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: mkfs is broken due to platform_zero_range
Message-ID: <20210504002053.GC7448@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

So... I have a machine with an nvme drive manufactured by a certain
manufacturer who isn't known for the quality of their firmware
implementation.  I'm pretty sure that this is a result of the use of
fallocate(FALLOC_FL_ZERO_RANGE) to zero the log during format.

If I format a device, mounting and repair both fail because the primary
superblock UUID doesn't match the log UUID:

[root@abacus654 ~]# btrace /dev/nvme0n1 > btrace.txt &
[root@abacus654 ~]# strace -s99 -o /tmp/a mkfs.xfs /dev/nvme0n1  -f
meta-data=/dev/nvme0n1           isize=512    agcount=6, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=1542990848, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Discarding blocks...Done.
[root@abacus654 ~]# fg
btrace /dev/nvme0n1 > btrace.txt^C

[root@abacus654 ~]# xfs_repair -n /dev/nvme0n1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
* ERROR: mismatched uuid in log
*            SB : 1f0e74b7-c3af-4da1-9f15-3aa3605faed7
*            log: 83a2835b-58f4-4e2d-bc3f-e063617363dd
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...

So then I looked at the log locations via xfs_db:

[root@abacus654 ~]# xfs_db -c 'sb' -c 'print logstart logblocks blocksize' -c 'convert fsb 805306374 daddr' /dev/nvme0n1
logstart = 805306374
logblocks = 521728
blocksize = 4096

[root@abacus654 ~]# xfs_db -c 'sb' -c 'convert fsb 805306374 daddr' /dev/nvme0n1
0x180000018 (6442450968)

Ok, so the log starts at (512b sector) 6442450968, which is byte offset
3298534895616 in /dev/nvme0n1.  Checking the strace log reveals:

[root@abacus654 ~]# grep 3298534895616 /tmp/a
fallocate(4, FALLOC_FL_ZERO_RANGE, 3298534895616, 2136997888) = 0
pwrite64(4, <buffer>, 1024, 3298534895616) = 1024

Which shows that first we instructed the device to zero the entire log,
and then we wrote the log head to the first 1024 bytes of the log.  If
we dump the log contents, we get:

[root@abacus654 ~]# dd if=/dev/nvme0n1 skip=805306371 count=521728 bs=4096 of=/tmp/badlog iflag=direct
[root@abacus654 ~]# od -tx1 -Ad -c /tmp/badlog
0000000  fe  ed  ba  be  00  00  00  01  00  00  00  02  00  00  02  00
        376 355 272 276  \0  \0  \0 001  \0  \0  \0 002  \0  \0 002  \0
<snip>
0000304  1f  0e  74  b7  c3  af  4d  a1  9f  15  3a  a3  60  5f  ae  d7
        037 016   t 267 303 257   M 241 237 025   : 243   `   _ 256 327

Ok, so this is the 1024 bytes that we wrote out, and it matches the rest
of the filesystem.  Note the 1f 0e 74 b7 c3 af... sequence near byte
304, which is the fs uuid according to xlog_rec_header.  This looks good
so far.  But then we get to the next 1024 bytes:

0001024  fe  ed  ba  be  00  00  00  01  00  00  00  02  00  00  7e  00
        376 355 272 276  \0  \0  \0 001  \0  \0  \0 002  \0  \0   ~  \0
<snip>
0001328  83  a2  83  5b  58  f4  4e  2d  bc  3f  e0  63  61  73  63  dd
        203 242 203   [   X 364   N   - 274   ? 340   c   a   s   c 335

Notice the UUID here doesn't match -- it's the 83 a2 83 5b... sequence
that repair complained about above.  Clearly, the log zeroing didn't
work, and mkfs didn't even try a trivial check that the accelerated
zeroing worked properly.

Indeed, I can even re-zero the entire log from the command line:

[root@abacus654 ~]# btrace /dev/nvme0n1 > btrace2.txt &
[root@abacus654 ~]# strace -s99 -e fallocate xfs_io -c 'fzero 3298534895616 2136997888' /dev/nvme0n1
fallocate(3, FALLOC_FL_ZERO_RANGE, 3298534895616, 2136997888) = 0
[root@abacus654 ~]# fg
btrace /dev/nvme0n1 > btrace.txt^C

And then re-excerpt the log:

[root@abacus654 ~]# dd if=/dev/nvme0n1 skip=805306371 count=521728 bs=4096 of=/tmp/badlog2 iflag=direct
[root@abacus654 ~]# od -tx1 -Ad -c /tmp/badlog2 | less
0000000  fe  ed  ba  be  00  00  00  01  00  00  00  02  00  00  02  00
        376 355 272 276  \0  \0  \0 001  \0  \0  \0 002  \0  \0 002  \0
0000016  00  00  00  01  00  00  00  00  00  00  00  01  00  00  00  00
         \0  \0  \0 001  \0  \0  \0  \0  \0  \0  \0 001  \0  \0  \0  \0
0000032  00  00  00  00  ff  ff  ff  ff  00  00  00  01  b0  c0  d0  d0
         \0  \0  \0  \0 377 377 377 377  \0  \0  \0 001 260 300 320 320
0000048  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0000288  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  01
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0 001
0000304  1f  0e  74  b7  c3  af  4d  a1  9f  15  3a  a3  60  5f  ae  d7
        037 016   t 267 303 257   M 241 237 025   : 243   `   _ 256 327

Which should have zeroed the log completely.  Looking at the block trace
from the mkfs run, I see:

[root@abacus654 ~]# grep 6442450968 btrace.txt
259,0    4     5907     0.118525480 26004  Q  WS 6442450968 + 4173824 [mkfs.xfs]
259,0    4     5908     0.118541800     0  C  WS 6442450968 + 4173824 [0]
259,0    4     5909     0.118572240 26004  Q  WS 6442450968 + 2 [mkfs.xfs]
259,0    4     5910     0.118588160     0  C  WS 6442450968 + 2 [0]

So we did in fact issue a write to the device, but we can still read
the previous contents after the write completes!  Hooray, the device
firmware is broken!

If I look at the block trace from the xfs_io zero-range invocation, I
see:

[root@abacus654 ~]# grep 6442450968 btrace2.txt
259,0    6        1 1266874889.701085336 26385  Q  WS 6442450968 + 4173824 [xfs_io]
259,0    6        2 1266874889.701172696     0  C  WS 6442450968 + 4173824 [0]

So the kernel indeed sent the write request, but a subsequent re-read of
the log contents still shows the old log contents, which is why repair
and mount get mad.

Note that a standard overwite of the log causes a subsequent re-read
to produce zeroes:

[root@abacus654 ~]# dd if=/dev/zero of=/dev/nvme0n1 seek=805306371 count=521728 bs=4096 oflag=direct,sync
521728+0 records in
521728+0 records out
2136997888 bytes (2.1 GB, 2.0 GiB) copied, 9.75987 s, 219 MB/s
[root@abacus654 ~]# dd if=/dev/nvme0n1 skip=805306371 count=521728 bs=4096 of=/tmp/badlog3 iflag=direct
521728+0 records in
521728+0 records out
2136997888 bytes (2.1 GB, 2.0 GiB) copied, 8.55764 s, 250 MB/s
[root@abacus654 ~]# od -tx1 -Ad -c /tmp/badlog3 | less
[root@abacus654 ~]# ^C
[root@abacus654 ~]# od -tx1 -Ad -c /tmp/badlog3 | head -n15
0000000  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
2136997888

And the format works this time too:

[root@abacus654 ~]# strace -s99 -o /tmp/a mkfs.xfs /dev/nvme0n1  -f
meta-data=/dev/nvme0n1           isize=512    agcount=6, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=1542990848, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Discarding blocks...Done.
(reverse-i-search)`-n': od -tx1 -Ad -c /tmp/badlog3 | head ^C15
[root@abacus654 ~]# xfs_repair -n /dev/nvme0n1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...

In conclusion, the drive firmware is broken.

Question: Should we be doing /some/ kind of re-read after a zeroing the
log to detect these sh*tty firmwares and fall back to a pwrite()?

--D
