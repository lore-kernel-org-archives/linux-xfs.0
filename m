Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbeHUSdT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Aug 2018 14:33:19 -0400
Date: Tue, 21 Aug 2018 08:12:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: 4.19 merge, part 3
Message-ID: <20180821151244.GC4334@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, agruenba@redhat.com, Christoph Hellwig <hch@infradead.org>

Hi Linus,

Here are a few fixes that I've queued up for 4.19.  I need to recover
from some medical events, so don't be too surprised if the next pull
request(s) come from Dave Chinner.

--D

The following changes since commit 01239d77b9dd978863d1a75f0d095ab942a1fe66:

  xfs: fix a null pointer dereference in xfs_bmap_extents_to_btree (2018-08-12 08:37:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.19-merge-7

for you to fetch changes up to 7d5e049e72c4cb933b557c78cbd63285dd8102ce:

  iomap: fix WARN_ON_ONCE on uninitialized variable (2018-08-14 08:17:02 -0700)

----------------------------------------------------------------
Changes since last update:
- Fix an uninitialized variable
- Don't use obviously garbage AG header counters to calculate
  transaction reservations
- Trigger icount recalculation on bad icount when monting.

----------------------------------------------------------------
Darrick J. Wong (3):
      xfs: recalculate summary counters at mount time if icount is bad
      xfs: sanity check ag header values in xrep_calc_ag_resblks
      iomap: fix WARN_ON_ONCE on uninitialized variable

 fs/iomap.c            |  2 +-
 fs/xfs/scrub/repair.c | 46 +++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_mount.c    |  1 +
 3 files changed, 29 insertions(+), 20 deletions(-)
