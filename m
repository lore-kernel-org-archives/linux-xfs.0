Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:20088 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728311AbeKIH4x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 02:56:53 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2]: dedupe/copy_file_range fixes
Date: Fri,  9 Nov 2018 09:19:07 +1100
Message-Id: <20181108221909.27602-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Hi folks,

Here's the first couple of fixes that fell out of the tree last
night after Darrick added and clone/dedupe_file_range to fsx and
copy_file_range to both fsx and fsstress yesterday. There will be
more coming.

FYI, do_splice_direct() is broken for direct IO on XFS. It's been
broken ever since the iomap infrastructure was introduced in 4.10
two years ago. Any code that can use splice to read data via direct
IO is definitely broken (copy_file_range demonstrates that). And my
initial testing on 64k block sizes indicates that direct IO writes
via splice are also broken because the short writes expose stale
data in partially written blocks.

As such, copy_file_range() is broken for direct IO on XFS w/o reflink
support (i.e. default configs). It has been broken since at least
4.10, and maybe as far back as when copy_file_range() was first
introduced in 4.5.

Yet in all this time, nobody has noticed that is is broken. That's
because nobody added test infrastructure support for the
copy_file_range() syscall. Sure we added a command to xfs_io to be
able to copy files via the interface, but that doesn't mean the
interface is exercised in any useful manner.

So, how long do you think it took fsx to find these problems? A few
hours? A few million operations? Nope. It took 32 operations and
0.3s - it failed on the second copy_file_range() call it made.
This is from generic/263:

skipping zero size read
truncating to largest ever: 0xe400
4 trunc from 0x0 to 0xe400
5 insert        from 0x6000 to 0x18000, (0x12000 bytes)
6 zero  from 0x91be to 0x1edf6, (0x15c38 bytes)
7 write 0x3ac00 thru    0x3cdff (0x2200 bytes)
8 mapread       0x36000 thru    0x3be19 (0x5e1a bytes)
9 mapwrite      0x73200 thru    0x7928c (0x608d bytes)
10 mapread      0x3d000 thru    0x3f9c2 (0x29c3 bytes)
11 collapse     from 0x2b000 to 0x45000, (0x1a000 bytes)
12 punch        from 0x495fa to 0x5f28d, (0x15c93 bytes)
13 falloc       from 0x2f42a to 0x4a8f4 (0x1b4ca bytes)
14 zero from 0x530b7 to 0x5f28d, (0xc1d6 bytes)
15 mapwrite     0x55e00 thru    0x70d6e (0x1af6f bytes)
16 read 0x2e000 thru    0x38fff (0xb000 bytes)
17 collapse     from 0x3f000 to 0x4f000, (0x10000 bytes)
18 copy from 0x28000 to 0x43000, (0x1b000 bytes) at 0x4400
19 collapse     from 0x2c000 to 0x45000, (0x19000 bytes)
20 write        0x54a00 thru    0x709ff (0x1c000 bytes)
21 read 0x53000 thru    0x69fff (0x17000 bytes)
22 mapwrite     0x1f200 thru    0x394bb (0x1a2bc bytes)
23 mapread      0x43000 thru    0x5a2d8 (0x172d9 bytes)
24 mapwrite     0x23000 thru    0x38812 (0x15813 bytes)
25 write        0x47800 thru    0x587ff (0x11000 bytes)
26 clone        from 0x3000 to 0x12000, (0xf000 bytes) at 0x61000
skipping unsupported clone range
27 read 0x6c000 thru    0x6efff (0x3000 bytes)
28 dedupe       from 0x12000 to 0x1e000, (0xc000 bytes) at 0x4000
skipping unsupported dedupe range
29 insert       from 0x31000 to 0x33000, (0x2000 bytes)
fallocating to largest ever: 0x49915
30 falloc       from 0x2deac to 0x49915 (0x1ba69 bytes)
31 dedupe       from 0x6f000 to 0x72000, (0x3000 bytes) at 0x25000
skipping unsupported dedupe range
32 copy from 0x4b000 to 0x64000, (0x19000 bytes) at 0x2800
copy range: 0x4b000 to 0x64000 at 0x2800
do_copy_range:: Resource temporarily unavailable

The ease of reproducing this bug indicates just how badly our
engineering processes have failed here. They simply haven't been
followed at all - we know that if we don't add test coverage with
new features and/or interfaces, then the new code will be buggy and
broken. Yet maintainers still seem to ignore whether code is
testable or even fit for purpose and merge new code that has not and
cannot be tested adequately now and into the future.

I'm not a happy camper right now.

-Dave.
