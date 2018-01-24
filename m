Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35881 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965089AbeAXSoU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jan 2018 13:44:20 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E76CE60151
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:19 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B872B6A020
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFCv2 0/9] xfs: defer agfl block frees
Date: Wed, 24 Jan 2018 13:44:09 -0500
Message-Id: <20180124184418.40403-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's a second RFC of the mechanism to defer AGFL block frees. The
purpose of this change is to minimize log reservation consumption (and
thus reduce the likelihood of overruns) due to too many allocation
operations being performed in a single transaction context.

The major difference in this version is that rather than explicitly
plumb an xfs_defer_ops structure to the allocator code from specific
contexts where we want to defer AGFL block frees, we update struct
xfs_trans to carry an optional dfops reference and use that to decide
whether to defer such frees during AGFL fixups.

This approach implies a few additional thoughts:

- We eventually want to defer AGFL block frees by default (or at least
  from any code that already has a use for xfs_defer_ops).
- With most transactions converted, we can facilitate further cleanups
  where we've already had to manually plumb xfs_defer_ops to places that
  already have access to the associated transaction.
- Going further, we ultimately may be able to consider some further
  dfops interface cleanups, such as associating dfops to the tx via
  xfs_defer_init(), processing deferred ops at transaction commit time,
  rethinking how dfops memory is allocated, etc.

If the broader ideas to defer AGFL block frees and to do so via
refactoring the transaction/dfops relationship are acceptable, I'd like
to take an incremental approach (starting with enabling deferred AGFL
frees from the inode-related contexts modified in this series) to
incorporate this change so we can enable the behavior in the contexts
where it's known to be most effective without having to refactor the
world all at once.

With regard to testing, this series survives some basic xfstests testing
so far. I've also run some fairly basic "performance" tests to try and
assess how much of an effect this has on transaction regrants and
whether or not it's worth bumping transaction log counts to cover
regrants due to deferred AGFL frees. The final two patches are included
for reference purposes and discuss this further. In summary, the testing
I've done so far[1] suggests that bumping logcounts is probably overkill
given the low frequency of AGFL block frees relative to all transaction
commits.

Thoughts, reviews, flames appreciated.

Brian

rfcv2:
- Use transaction to carry deferred ops struct to allocation context.
- Remove dfops param from dir interfaces where possible.
- Defer AGFL block frees from more contexts.
- Define runtime stat for transaction regrant and logcount patch (to be
  potentially removed).
rfcv1: https://marc.info/?l=linux-xfs&m=151267309423883&w=2

[1] Some notes around regrant testing using xs_regrant_logspace.

* Sustained file removal test (known to reproduce log res. overruns):

 - for-next - 6641554
 - deferred AGFL frees - 6742268
 - deferred AGFL w/ tr_inactive - 6715692
 - deferred AGFL w/ inactive+truncate - 74138

Deferring AGFL block frees increases the regrant count by about ~1.5% in
this test. Upping the tr_inactive logcount reduced this by 0.4%. The
significant effect from the bump of the tr_truncate logcount shows that
this workload is dominated by bmap extent frees, so I don't think this
particular number is relevant to the patchset.

* fsstress test against a 15GB fs (runs for ~5m and
  consumes ~9GB of available space, repeated a couple runs, all using
  the same seed value):

 - for-next - 35469, 35616
 - deferred AGFL frees - 35446, 35445
 - deferred AGFL w/ patch 9 (AGFL count == 1) - 35510, 35412

This short, but more mixed workload doesn't show much of a difference
between the baseline and deferred AGFL free code (in fact the counts
drop, which suggests this is all just noise).

Brian Foster (9):
  xfs: create agfl block free helper function
  xfs: allow attach of dfops to transaction
  xfs: defer agfl block frees when dfops is available
  xfs: defer agfl block frees from deferred ops processing context
  xfs: defer agfl frees from inode inactivation
  xfs: defer frees from common inode allocation paths
  xfs: defer agfl frees from directory op transactions
  xfs: add a runtime stat for extra transaction log regrants
  xfs: add extra log count for transactions that defer agfl frees

 fs/xfs/libxfs/xfs_alloc.c      | 82 ++++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_alloc.h      |  2 ++
 fs/xfs/libxfs/xfs_defer.c      |  9 +++++
 fs/xfs/libxfs/xfs_defer.h      |  1 +
 fs/xfs/libxfs/xfs_dir2.c       | 16 ++++-----
 fs/xfs/libxfs/xfs_dir2.h       |  9 ++---
 fs/xfs/libxfs/xfs_ialloc.c     |  6 ++--
 fs/xfs/libxfs/xfs_ialloc.h     |  1 -
 fs/xfs/libxfs/xfs_trans_resv.h | 19 +++++-----
 fs/xfs/xfs_inode.c             | 69 ++++++++++++++++++-----------------
 fs/xfs/xfs_inode.h             |  3 +-
 fs/xfs/xfs_log.c               |  1 +
 fs/xfs/xfs_stats.h             |  3 +-
 fs/xfs/xfs_symlink.c           |  3 +-
 fs/xfs/xfs_trace.h             |  2 ++
 fs/xfs/xfs_trans.c             |  7 ++--
 fs/xfs/xfs_trans.h             |  1 +
 fs/xfs/xfs_trans_extfree.c     | 70 ++++++++++++++++++++++++++++++++++++
 18 files changed, 227 insertions(+), 77 deletions(-)

-- 
2.13.6

