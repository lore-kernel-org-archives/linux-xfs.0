Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8F7137F3F
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2014 21:03:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B867304043
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2014 19:03:41 -0700 (PDT)
Received: from mail-yk0-f179.google.com (mail-yk0-f179.google.com
	[209.85.160.179]) by cuda.sgi.com with ESMTP id
	WvZuwiWjPSo2sUYs (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Aug 2014 19:03:36 -0700 (PDT)
Received: by mail-yk0-f179.google.com with SMTP id 142so3821263ykq.38
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2014 19:03:36 -0700 (PDT)
Received: from yholen.semon.net (rrcs-97-76-23-49.se.biz.rr.com. [97.76.23.49])
	by mx.google.com with ESMTPSA id m23sm180876yhi.44.2014.08.17.19.03.35
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Sun, 17 Aug 2014 19:03:35 -0700 (PDT)
Message-ID: <53F15EEF.4090308@gmail.com>
Date: Sun, 17 Aug 2014 22:03:27 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: xfsdump completes very prematurely in low RAM, commit found
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi!  I had some phantom issues that are chasing me through this 3.17
merge window period.  While chasing those issues, I decided to do an
xfsdump of a v5/finobt XFS system rescued from PEBKAC issues.  The
xfsdump completed rather prematurely, ending like this test case
output...

xfsdump: dumping special file ino 4194523 mode 0x21b0
xfsdump: dumping special file ino 4194524 mode 0x21b0
xfsdump: dumping special file ino 4194525 mode 0x21b0
xfsdump: dumping special file ino 4194526 mode 0x21b0
xfsdump: dumping special file ino 4194527 mode 0x21b0
xfsdump: ending media file
xfsdump: media file size 4512992 bytes
xfsdump: ending stream: 23 seconds elapsed
xfsdump: dump size (non-dir files) : 4452088 bytes
xfsdump: dump complete: 23 seconds elapsed
xfsdump: Dump Summary:
xfsdump:   stream 0 /mnt/xfstests-scratch/blah.0.dump OK (success)
xfsdump: Dump Status: SUCCESS

That looks fine for a lack of obvious error messages.  However, it
should end like this:

xfsdump: dumping regular file ino 13653551 offset 0 to offset 12154 (size 12154)
xfsdump: dumping regular file ino 13653555 offset 0 to offset 16554 (size 16554)
xfsdump: dumping regular file ino 13653556 offset 0 to offset 185 (size 185)
xfsdump: dumping regular file ino 13653557 offset 0 to offset 471 (size 471)
xfsdump: dumping special file ino 13653558 mode 0xa1ff
xfsdump: ending media file
xfsdump: media file size 1999127056 bytes
xfsdump: ending stream: 465 seconds elapsed
xfsdump: dump size (non-dir files) : 1963549104 bytes
xfsdump: dump complete: 465 seconds elapsed
xfsdump: Dump Summary:
xfsdump:   stream 0 /mnt/xfstests-scratch/blah.0.dump OK (success)
xfsdump: Dump Status: SUCCESS

Note that I haven't freed enough time to check this on v4-superblock XFS.
I've tested v5 and v5/finobt XFS filesystems, 4k block size, no external
logdev or rtdev.  The earliest kernel tested was an old 3.16.0-rc2
kernel left lying around referenced by lilo.conf, and that kernel was OK.
Not sure if this kernel has XFS quota support in it, need to recheck.

The test commands, meant to back up $TEST_DEV to $SCRATCH_DEV, was this:

#!/bin/sh
mount $TEST_DEV $TEST_DIR
mount $SCRATCH_DEV $SCRATCH_MNT
rm -v $SCRATCH_MNT/blah.0.dump
xfsdump -v 2 -l 0 -L tl -M tm -f $SCRATCH_MNT/blah.0.dump $TEST_DEV

Bisect brought me here:

root@oldsvrhw:/usr/src/kernel-git/linux# git bisect bad
c7cb51dcb0a38624d42eeabb38502fa54a4d774b is the first bad commit
[33mcommit c7cb51dcb0a38624d42eeabb38502fa54a4d774b[m
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Thu Jul 24 12:18:47 2014 +1000

     xfs: fix error handling at xfs_inumbers
     
     From: Jie Liu <jeff.liu@oracle.com>
     
     To fetch the file system number tables, we currently just ignore the
     errors and proceed to loop over the next AG or bump agino to the next
     chunk in case of btree operations failed, that is not properly because
     those errors might hint us potential file system problems.
     
     This patch rework xfs_inumbers() to handle the btree operation errors
     as well as the loop conditions.
     
     Signed-off-by: Jie Liu <jeff.liu@oracle.com>
     Reviewed-by: Dave Chinner <dchinner@redhat.com>
     Signed-off-by: Dave Chinner <david@fromorbit.com>

:040000 040000 ec78dc86468ee00df7a63bba97a135b8c6a84a95 2e447774a8f85b1b8d43ffa9fd28cbea3402d717 M	fs

Maybe Jeff's patch is doing its job.  After all, on several successful
test runs, the kernel was sending messages like (paraphrased) "BUG: bad
state in page table" to remote syslog.  The Pentium III PC has too
little memory (512 MB) to do this job.  However, I think that the
xfsdump should last more than 23 seconds before causing issues.

Might someone try an xfsdump or two to see if this are still working
to most people's satisfaction, on a kernel past 3.16.0-rc2 that has
this commit in it?

Thanks!

Michael

[Full xfsdump for the failed case is below:]

xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.4 (dump format 3.0)
xfsdump: level 0 dump of oldsvrhw:/mnt/xfstests-test
xfsdump: dump date: Sun Aug 17 20:11:48 2014
xfsdump: session id: 8bc58167-a96a-4628-9143-13fa7fb20df9
xfsdump: session label: "tl"
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 2178363264 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsdump: dumping directory ino 96
xfsdump: dumping directory ino 99
xfsdump: dumping non-directory files
xfsdump: dumping special file ino 100 mode 0xa1ff
xfsdump: dumping regular file ino 101 offset 0 to offset 35680 (size 35680)
xfsdump: dumping regular file ino 102 offset 0 to offset 4468 (size 4468)
xfsdump: dumping regular file ino 103 offset 0 to offset 109680 (size 109680)
xfsdump: dumping special file ino 104 mode 0xa1ff
xfsdump: dumping regular file ino 105 offset 0 to offset 32192 (size 32192)
xfsdump: dumping regular file ino 106 offset 0 to offset 24640 (size 24640)
xfsdump: dumping regular file ino 107 offset 0 to offset 925012 (size 925012)
xfsdump: dumping special file ino 108 mode 0xa1ff
xfsdump: dumping special file ino 109 mode 0xa1ff
xfsdump: dumping regular file ino 110 offset 0 to offset 29252 (size 29252)
xfsdump: dumping regular file ino 111 offset 0 to offset 9824 (size 9824)
xfsdump: dumping regular file ino 112 offset 0 to offset 47008 (size 47008)
xfsdump: dumping regular file ino 113 offset 0 to offset 53888 (size 53888)
xfsdump: dumping regular file ino 114 offset 0 to offset 55232 (size 55232)
xfsdump: dumping regular file ino 115 offset 0 to offset 51776 (size 51776)
xfsdump: dumping regular file ino 116 offset 0 to offset 57312 (size 57312)
xfsdump: dumping regular file ino 117 offset 0 to offset 30592 (size 30592)
xfsdump: dumping regular file ino 118 offset 0 to offset 26784 (size 26784)
xfsdump: dumping regular file ino 119 offset 0 to offset 30528 (size 30528)
xfsdump: dumping special file ino 120 mode 0xa1ff
xfsdump: dumping regular file ino 121 offset 0 to offset 129152 (size 129152)
xfsdump: dumping regular file ino 122 offset 0 to offset 134348 (size 134348)
xfsdump: dumping special file ino 123 mode 0xa1ff
xfsdump: dumping regular file ino 124 offset 0 to offset 110432 (size 110432)
xfsdump: dumping regular file ino 125 offset 0 to offset 39072 (size 39072)
xfsdump: dumping regular file ino 126 offset 0 to offset 56704 (size 56704)
xfsdump: dumping regular file ino 127 offset 0 to offset 60804 (size 60804)
xfsdump: dumping regular file ino 128 offset 0 to offset 100648 (size 100648)
xfsdump: dumping regular file ino 129 offset 0 to offset 195400 (size 195400)
xfsdump: dumping regular file ino 130 offset 0 to offset 115296 (size 115296)
xfsdump: dumping regular file ino 131 offset 0 to offset 33344 (size 33344)
xfsdump: dumping regular file ino 132 offset 0 to offset 24096 (size 24096)
xfsdump: dumping regular file ino 133 offset 0 to offset 20260 (size 20260)
xfsdump: dumping special file ino 134 mode 0xa1ff
xfsdump: dumping special file ino 135 mode 0xa1ff
xfsdump: dumping regular file ino 136 offset 0 to offset 108544 (size 108544)
xfsdump: dumping regular file ino 137 offset 0 to offset 25376 (size 25376)
xfsdump: dumping regular file ino 138 offset 0 to offset 43832 (size 43832)
xfsdump: dumping regular file ino 139 offset 0 to offset 137504 (size 137504)
xfsdump: dumping regular file ino 140 offset 0 to offset 24576 (size 24576)
xfsdump: dumping regular file ino 141 offset 0 to offset 27360 (size 27360)
xfsdump: dumping regular file ino 142 offset 0 to offset 102080 (size 102080)
xfsdump: dumping regular file ino 143 offset 0 to offset 108416 (size 108416)
xfsdump: dumping regular file ino 144 offset 0 to offset 22720 (size 22720)
xfsdump: dumping regular file ino 145 offset 0 to offset 104480 (size 104480)
xfsdump: dumping regular file ino 146 offset 0 to offset 35040 (size 35040)
xfsdump: dumping regular file ino 147 offset 0 to offset 32096 (size 32096)
xfsdump: dumping regular file ino 148 offset 0 to offset 26976 (size 26976)
xfsdump: dumping regular file ino 149 offset 0 to offset 7004 (size 7004)
xfsdump: dumping regular file ino 150 offset 0 to offset 66212 (size 66212)
xfsdump: dumping regular file ino 151 offset 0 to offset 24276 (size 24276)
xfsdump: dumping special file ino 152 mode 0xa1ff
xfsdump: dumping regular file ino 153 offset 0 to offset 534580 (size 534580)
xfsdump: dumping regular file ino 154 offset 0 to offset 9848 (size 9848)
xfsdump: dumping special file ino 155 mode 0xa1ff
xfsdump: dumping regular file ino 156 offset 0 to offset 359024 (size 359024)
xfsdump: dumping regular file ino 157 offset 0 to offset 27136 (size 27136)
xfsdump: dumping regular file ino 158 offset 0 to offset 2301 (size 2301)
xfsdump: dumping regular file ino 159 offset 0 to offset 5927 (size 5927)
xfsdump: dumping special file ino 4194464 mode 0x21b0
xfsdump: dumping special file ino 4194465 mode 0x21b0
xfsdump: dumping special file ino 4194466 mode 0x21b0
xfsdump: dumping special file ino 4194467 mode 0x21b0
xfsdump: dumping special file ino 4194468 mode 0x21b0
xfsdump: dumping special file ino 4194469 mode 0x21b0
xfsdump: dumping special file ino 4194470 mode 0x21b0
xfsdump: dumping special file ino 4194471 mode 0x21b0
xfsdump: dumping special file ino 4194472 mode 0x21b0
xfsdump: dumping special file ino 4194473 mode 0x21b0
xfsdump: dumping special file ino 4194474 mode 0x21b0
xfsdump: dumping special file ino 4194475 mode 0x21b0
xfsdump: dumping special file ino 4194476 mode 0x21b0
xfsdump: dumping special file ino 4194477 mode 0x21b0
xfsdump: dumping special file ino 4194478 mode 0x21b0
xfsdump: dumping special file ino 4194479 mode 0x21b0
xfsdump: dumping special file ino 4194480 mode 0x21b0
xfsdump: dumping special file ino 4194481 mode 0x21b0
xfsdump: dumping special file ino 4194482 mode 0x21b0
xfsdump: dumping special file ino 4194483 mode 0x21b0
xfsdump: dumping special file ino 4194484 mode 0x21b0
xfsdump: dumping special file ino 4194485 mode 0x21b0
xfsdump: dumping special file ino 4194486 mode 0x21b0
xfsdump: dumping special file ino 4194487 mode 0x21b0
xfsdump: dumping special file ino 4194488 mode 0x21b0
xfsdump: dumping special file ino 4194489 mode 0x21b0
xfsdump: dumping special file ino 4194490 mode 0x21b0
xfsdump: dumping special file ino 4194491 mode 0x21b0
xfsdump: dumping special file ino 4194492 mode 0x21b0
xfsdump: dumping special file ino 4194493 mode 0x21b0
xfsdump: dumping special file ino 4194494 mode 0x21b0
xfsdump: dumping special file ino 4194495 mode 0x21b0
xfsdump: dumping special file ino 4194496 mode 0x21b0
xfsdump: dumping special file ino 4194497 mode 0x21b0
xfsdump: dumping special file ino 4194498 mode 0x21b0
xfsdump: dumping special file ino 4194499 mode 0x21b0
xfsdump: dumping special file ino 4194500 mode 0x21b0
xfsdump: dumping special file ino 4194501 mode 0x21b0
xfsdump: dumping special file ino 4194502 mode 0x21b0
xfsdump: dumping special file ino 4194503 mode 0x21b0
xfsdump: dumping special file ino 4194504 mode 0x21b0
xfsdump: dumping special file ino 4194505 mode 0x21b0
xfsdump: dumping special file ino 4194506 mode 0x21b0
xfsdump: dumping special file ino 4194507 mode 0x21b0
xfsdump: dumping special file ino 4194508 mode 0x21b0
xfsdump: dumping special file ino 4194509 mode 0x21b0
xfsdump: dumping special file ino 4194510 mode 0x21b0
xfsdump: dumping special file ino 4194511 mode 0x21b0
xfsdump: dumping special file ino 4194512 mode 0x21b0
xfsdump: dumping special file ino 4194513 mode 0x21b0
xfsdump: dumping special file ino 4194514 mode 0x21b0
xfsdump: dumping special file ino 4194515 mode 0x21b0
xfsdump: dumping special file ino 4194516 mode 0x21b0
xfsdump: dumping special file ino 4194517 mode 0x21b0
xfsdump: dumping special file ino 4194518 mode 0x21b0
xfsdump: dumping special file ino 4194519 mode 0x21b0
xfsdump: dumping special file ino 4194520 mode 0x21b0
xfsdump: dumping special file ino 4194521 mode 0x21b0
xfsdump: dumping special file ino 4194522 mode 0x21b0
xfsdump: dumping special file ino 4194523 mode 0x21b0
xfsdump: dumping special file ino 4194524 mode 0x21b0
xfsdump: dumping special file ino 4194525 mode 0x21b0
xfsdump: dumping special file ino 4194526 mode 0x21b0
xfsdump: dumping special file ino 4194527 mode 0x21b0
xfsdump: ending media file
xfsdump: media file size 4512992 bytes
xfsdump: ending stream: 23 seconds elapsed
xfsdump: dump size (non-dir files) : 4452088 bytes
xfsdump: dump complete: 23 seconds elapsed
xfsdump: Dump Summary:
xfsdump:   stream 0 /mnt/xfstests-scratch/blah.0.dump OK (success)
xfsdump: Dump Status: SUCCESS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
