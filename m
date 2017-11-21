Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751181AbdKUPGA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Nov 2017 10:06:00 -0500
Date: Tue, 21 Nov 2017 10:05:57 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: tr_ifree transaction log reservation calculation
Message-ID: <20171121150557.GA5014@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com

Hi all,

I'm looking into a bug that appears to reflect the fairly rare
xfs_inactive_ifree() transaction overruns that have been reported in the
past. To summarize, the cause of the overrun appears to be that the
pre-inode-chunk-free agfl fixup ends up freeing a single agfl block that
leads to multiple [cnt|bno]bt joins that repopulate the agfl and cause
several more iterations in xfs_alloc_fix_freelist(). These extra
iterations combine with a couple other conditions that ultimately result
in consuming most or all of the anticipated cntbt log reservation before
we actually get to freeing the inode chunk:

- left+right contiguous blocks that require 2 cntbt record removals and
  an insert with a new length key
- the overrun is the first transaction in a CIL ctx and thus consumes
  the CIL ticket reservation
- the transaction spans a log buffer and thus requires additional space
  for split region headers

Note that I don't believe the above are problems, but rather this
suggests how we probably get away with the higher level problem in most
cases where this additional "worst case" reservation goes unused.

I ended up looking at tr_ifree while investigating some options to
resolve this problem and am slightly confused by the reservation
calculation. In particular, we do this for the inobt portion of the
operation (i.e., "the inode btree: max depth * blocksize"):

                xfs_calc_buf_res(2 + mp->m_ialloc_blks +   
                                 mp->m_in_maxlevels, 0) +  

... where it looks to me that we only incorporate the overhead of the
inobt buffers rather than the buffer content themselves. Is this
expected/appropriate, or should we be passing something like
XFS_FSB_TO_B(mp, 1) there rather than 0? As it is, while this is not
related to the allocation btrees, it does happen to add enough
reservation to the transaction to avoid the overrun. Then again, it
might not technically be appropriate to add that reservation since the
inobt and free space btree updates are separated by a transaction roll.

That aside, the next best option for dealing with this situation seems
to be to limit the number of agfl fixups that can occur per-transaction.
Yet another option might be to roll the transaction in certain
situations (i.e., let the deferred op handling give us a new transaction
if an agfl fixup resulted in a split/join), but I suspect that could get
more involved as we may want to keep the agf locked across that
sequence, etc.

Thoughts? Can anyone shed some light on this reservation? Thanks!

Brian
