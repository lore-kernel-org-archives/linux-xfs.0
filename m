Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34676 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751522AbeA0BKc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 20:10:32 -0500
Subject: [PATCH v3 0/7] xfs: reflink/scrub/quota fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 26 Jan 2018 17:10:09 -0800
Message-ID: <151701540938.3070.15043243007590700677.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, bfoster@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is a re-roll of five patches that have generated a lot of review
comments; hopefully they're ready to go.  Some of the patches already
have reviewed-bys, but the discussion so choppy I decided that I'd just
republish the whole set.

Running generic/232 with quotas and reflink demonstrated that there was
something wrong with the way we did quota accounting -- on an otherwise
idle system, fs-wide du block count numbers didn't match the quota
reports.  I started digging into why the quota accounting was wrong, and
the following are the results of my bug hunt.  Regression tests have
been sent to the fstests lists.

The first patch fixes reflink to break pnfs leases before reflinking as
we take the iolocks of both inodes.  Patches 2-3 restructure the locking
code to take shared locks on the source file whenever possible, to
reduce lock contention.

The fourth patch reorganizes the copy on write quota updating code to
reflect how the CoW fork works now.  In short, the CoW fork is entirely
in memory, so we can only use the in-memory quota reservation counters
for all CoW blocks; the accounting only becomes permanent if we remap an
extent into the data fork.

Patch 5 creates a separate i_cow_blocks counter to track all the CoW
blocks assigned to a file, which makes changing a file's uid/gid/prjid
easier, makes reporting cow blocks via stat easy, and enables various
cleanups.  This also makes it so that we avoid unnecesary eofblocks
scanning on a file with speculative cow preallocations.

Patches 6-7 fixes a serious corruption problem with direct io cow
writes.  If extent allocation returns no error and no mapping, we must
return ENOSPC to the caller because otherwise we pass a garbage mapping
to the dio code and the write shoots into space.  Bad.

Patch 8 fixes a problem with direct IO writes (regular and cow)
returning ENOSPC when there's plenty of free space.  When we allocate
into the CoW fork with the cow extent size hint set, the allocator
enlarges the allocation request to try to hit alignment goals.  However,
if the allocated extent does not actually fulfill any of the requested
range, we send a garbage zero-length extent back to the iomap code
(which also doesn't notice), and the write lands at the startblock of
the garbage extent.  The fix is to detect that we didn't fill the entire
requested range and fix up the returned mapping so that we always fill
the first block of the requested allocation and for CoW to check the
validity returned mappings before blowing things up.  This also fixes a
problem where a direct io overwrite can return ENOSPC to userspace
because of the same fragmentation problem.

Sorry the maintainer^Wpatches has been so volatile and rapidfire
recently; the end of the 4.15 cycle and some major $distrokernel
deadlines have made for a hellishly busy week.

--D
