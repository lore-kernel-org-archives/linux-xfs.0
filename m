Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:64768 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751062AbdJCIGK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 04:06:10 -0400
Date: Tue, 3 Oct 2017 19:06:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfsprogs: mkfs refactor
Message-ID: <20171003080607.GM15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

Hi Eric,

I've put the latest mkfs refactor code that I have up in place
you can pull it from. I've rebased it against the current for-next
tree (4.13.1 release) and fixed all the problems that xfstests
exposes. The only thing I haven't fixed is xfs/191 that does mkfs
command line behaviour verification because the refactored version
fixes several problems that the old mkfs didn't handle correctly
(e.g. being able to specify certain things like agsize in blocks or
sectors).

There's a small filter patch needed for xfstests that I'll post in
a reply to this pull request that will filter out the new "defaults
sourced from ..." output and so prevent spurious xfstests failures.

If you want I can tag the branch with a signed tag for you to pull
from (same process as Linus prefers) rather than just a branch in a
tree. If you'd prefer that I post this as patches instead, then let
me know and I'll bomb the list instead.

Cheers,

Dave.

The following changes since commit d4a36331dc383c7c7747e244b3ae20155ae92c98:

  xfsprogs: Release v4.13.1 (2017-09-26 20:45:05 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsprogs-dev mkfs-refactor

for you to fetch changes up to a4bc6d3c7bb5babc51f7341039dafcff5fcc6c7e:

  mkfs: tidy up definitions (2017-09-29 08:44:30 +1000)

----------------------------------------------------------------
Dave Chinner (42):
      mkfs: can't specify sector size of internal log
      mkfs: make subopt table const
      mkfs: introduce a structure to hold CLI options
      mkfs: add generic subopt parsing table
      mkfs: factor block subopts parser
      mkfs: factor data subopts parser
      mkfs: factor inode subopts parser
      mkfs: factor log subopts parser
      mkfs: factor meta subopts parser
      mkfs: factor naming subopts parser
      mkfs: factor rt subopts parser
      mkfs: factor sector subopts parser
      mkfs: Introduce mkfs configuration structure
      mkfs: factor printing of mkfs config
      mkfs: factor in memory superblock setup
      mkfs: factor out device preparation
      mkfs: factor writing AG headers
      mkfs: factor secondary superblock updates
      mkfs: introduce default configuration structure
      mkfs: rename top level CLI parameters
      mkfs: factor sectorsize validation
      mkfs: factor blocksize validation
      mkfs: factor log sector size validation
      mkfs: factor superblock feature validation
      mkfs: factor directory blocksize validation
      mkfs: factor inode size validation
      mkfs: factor out device size calculations
      mkfs: fix hidden parameter in DTOBT()
      mkfs: factor rtdev extent size validation
      mkfs: rework stripe calculations
      mkfs: factor device opening
      mkfs: factor data device validation
      mkfs: factor log device validation
      mkfs: factor rt device validation
      mkfs: factor AG geometry calculations
      mkfs: factor AG alignment
      mkfs: rework imaxpct calculation
      mkfs: factor initial mount setup
      mkfs: factor log size calculations
      mkfs: cleanup redundant temporary code
      mkfs: move error functions
      mkfs: tidy up definitions

 include/libxfs.h |    2 +-
 mkfs/xfs_mkfs.c  | 4645 ++++++++++++++++++++++++++++++------------------------
 2 files changed, 2602 insertions(+), 2045 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
