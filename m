Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3B7UbtD034903 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 02:30:37 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NjQvEEnFCqt13BZI for <xfs@oss.sgi.com>;
	Wed, 11 Apr 2012 00:30:34 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1SHs0d-0005Fz-Mc
	for xfs@oss.sgi.com; Wed, 11 Apr 2012 17:30:31 +1000
Date: Wed, 11 Apr 2012 17:30:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: xfstests 263 failures
Message-ID: <20120411073031.GU18323@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Folks,

I think I've found the cause of the fsx failures demonstrated by
fsx.

Firstly, the failure is that a mmap read is detecting non-zero data
beyond EOF when the page is mapped. The buffered read code does not
zero out the range beyond EOF in a page, so it makes the assumption
that it must be zero on disk.

Well, if a block exists beyond EOF (e.g. due to speculative
preallocation) when an unaligned DIO is written to that block, the
direct IO code won't always zero it. That's because it needs to be
marked as a new buffer to trigger sub-block zeroing. If the DIO
overlaps EOF, then the xfs_get_blocks() code will not mark the
buffer as new, hence won't zero the tail of the block.

I've managed to condense it down into a simple, reproducable script
that demonstrates the problem reliably:

#!/bin/bash

tf=/mnt/test/foo

rm -f $tf

# pattern a large extent
xfs_io -f -c "pwrite -S 0xaa 0 0x80000" -c s -c "bmap -vp" -c "truncate 0x60000" $tf

# create speculative delalloc beyond EOF. First close will truncate it,
# second write and close will leave it behind for the DIO write to land in.
xfs_io -f -c s -c "pwrite -S 0xbb 0x60000 0x2000" $tf
xfs_io -f -c s -c "pwrite -S 0xbb 0x60000 0x4000" $tf

# do unaligned dio write overlapping the EOF
xfs_io -f -d -c "pwrite 0x63c00 0x600" -c "bmap -vp" $tf

# mmap the region and read it, should see 0xaa patterns beyond
# 0x64200 from the original patterned extent if the direct IO has
# failed to zero the tail of the block.
xfs_io -f -c "mmap 0x63000 0x2000" -c "mread -f 0x63800 0x1000" $tf

---

Essentially, the test does this:

write a large extent containing "0xaa" in each byte:

   0                                                80
   +aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa+
                                                     EOF

Truncate back to 60

   0                                   60           80
   +aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa+aaaaaaaaaaaaa+
                                       EOF

Write 0xbb @ EOF twice to trigger persistent allocation beyond EOF

   0                                        64      80
   +aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbb+aaaaaaaa+
                                            EOF

Write 0xcd unaligned across EOF. Zoomed:

   ....      60                    64         65
   +aaaaaaaaa+bbbbbbbbbbbbbbbbbcdcd+cd+aaaaaaaa.....
                                      EOF

And what comes back is a bb/cd/aa pattern like this:

.....
000641d0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd ................
000641e0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd ................
000641f0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd ................
00064200:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa ................
00064210:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa ................
00064220:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa ................
00064230:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa ................

When what we should see is bb/cd/00 pattern from the mmap read like
this (ext4) as 0x64200 is the EOF:

000641d0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd ................
000641e0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd ................
000641f0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd ................
00064200:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
00064210:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
00064220:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................

I haven't been able to follow the maze of extremely dark, twisty and
mystifying passages of the ext4 DIO code to determine why it doesn't
have this problem.

The seemingly simple answer of marking unaligned maps beyond EOF as
new doesn't solve the problem - that causes writes with unaligned
start blocks to be zeroed, overwriting data. i.e. this result for
the above test:

   ....      60           63       64         65
   +aaaaaaaaa+bbbbbbbbbbbb+0000cdcd+cd+00000000.....
                                      EOF

because the front of the DIO write is unaligned.

Hence we cannot use "buffer new" to tell the DIO code to just zero
the unaligned tail because it means "zero both ends if they are
unaligned". However, the dio code will abort any zeroing if
buffer_new is not set....

I thought that maybe I could split the DIO up into two mappings -
one for before EOF and one for after EOF. That, unfortunately,
doesn't work either, because we might have a single sector DIO that
has EOF landing in the middle of it. Once again, we don't want to
zero the front end, but we do want to zero the rear end.

So I think this means I need to hack something into the DIO code
itself to detect an unaligned write to mapped blocks beyond EOF to
zero the remainder of the filesystem block.

Does anyone see any other way to deal with this problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
