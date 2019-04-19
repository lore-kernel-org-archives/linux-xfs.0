Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34508 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfDSAVC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Apr 2019 20:21:02 -0400
Subject: [PATCH v2 0/5] xfs: scrub filesystem summary counters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 18 Apr 2019 17:20:58 -0700
Message-ID: <155563325882.112668.3605935077532891922.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

Hi all,

This patch series introduces a totally new filesystem summary counter
online scrub feature.  Whereas previous iterations froze the filesystem
to count inodes and free blocks, this one drastically reduces overhead
by loosening its precision somewhat.  Instead of freezing the fs, we
"locklessly" compute the expected summary counter values using incore
per-AG counters.  Once the expected value is computed, we employ
thresholding to check that the counter values are in the right ballpark
but aren't necessarily exactly correct.

The first patch implements a per-cpu counter of the number of blocks
being held in delayed allocation reservations.  This should represent
the difference between the incore fdblocks counter and the one that
would be recorded on disk if one were to iterate all the committed
metadata structures.

Patch #2 renames some confusingly named functions in xfs_icache.c so
that the file no longer uses "reclaim" when referring to memory
reclamation and garbage collecting of speculative preallocations.

Patch #3 enables the scrub code to pause the posteof and cowblocks
background reclamation workers temporarily to reduce perturbations in
the summary counters while the scrubber runs.  This isn't totally
foolproof since they can be re-armed, but we only need ballpark
correctness.

Patch #4 teaches the AGF and AGI header scrub functions to check the
incore per-AG counters against the on-disk headers.

Finally, patch #5 implements the actual fs summary counter scrubber
code.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-summary-counters

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-summary-counters
