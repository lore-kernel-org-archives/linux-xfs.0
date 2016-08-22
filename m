Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3B627CA0
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 01:20:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7E0F78F8035
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 23:20:17 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	FkaoEokRwuORGZ5K for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2016 23:20:14 -0700 (PDT)
Date: Mon, 22 Aug 2016 16:20:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: for-next branch updated to c563396
Message-ID: <20160822062011.GU19025@dastard>
References: <20160821235610.GM19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160821235610.GM19025@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

[and now with the correct xfs@oss.sgi.com address]

Hi Folks,

The for-next branch of the xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated. It now contains full reverse mapping btree
support, which can be turned on at mkfs time via "-m rmapbt=1".
Filesystems using reverse mappings are bleeding edge experimental at
thsi point in time, so don't use this for any data you actually care
about right now.

*IMPORTANT*: Using reverse mapping functionality requires a
*4.8-rc3* kernel or more recent (Linus tagged 4.8-rc3 about 30
minutes ago) due to a small change in on-disk format required for
efficient accounting. If you use a 4.8-rc[12] kernel, you will see
corruptions when you update your kernel to -rc3 or later. For those
of you who have existing rmapbt=1 filesystems, please update your
xfsprogs and kernel at the same time and remake those filesystems.
Running repair should also fix up the on-disk accounted we added,
so mkfs may not be necessary.

>From this point onwards, however, the rmapbt on-disk format will be
stable and will not change without the use of feature bits to tell
the kernel about the change.

-Dave.

The new head of the master branch is commit:

c563396 mkfs.xfs: create filesystems with reverse-mappings

New Commits:

Darrick J. Wong (35):
      [de2f203] libxfs: fix xfs_isset pointer calculation
      [59d2274] xfs_buflock: add a tool that can be used to find buffer deadlocks
      [1c47bd6] xfs_io: bmap should print 'delalloc', not '-2'
      [2110aea] xfs_repair: preserve in-core meta_uuid while zeroing unused sb portions
      [9e1c66c] mkfs: fix library ordering
      [7079b3d] xfs_logprint: move the EFI copying/printing functions to a redo items file
      [c4c32d8] xfs_logprint: fix formatting issues with the EFI printing code
      [a481a58] man: document the DAX fsxattr inode flag
      [80afb9a] xfs_io: add free-extent error injection type
      [8511b71] xfs: store rmapbt block count in the AGF
      [59b8636] xfs: remove OWN_AG rmap when allocating a block from the AGFL
      [794a560] libxfs: fix various oddities in the kernel import
      [dc3bce0] libxfs: add deferred ops item handlers for userspace
      [a9d7b98] xfs_db: display rmap btree contents
      [e3dcc17] xfs_db: spot check rmapbt
      [e434854] xfs_db: copy the rmap btree
      [86bb49e] xfs_db: introduce the 'fsmap' command to find what owns a set of fsblocks
      [f6b78a5] xfs_growfs: report rmapbt presence
      [dea764e] xfs_io: add rmap-finish error injection type
      [4428538] xfs_logprint: support rmap redo items
      [0f94fa4] xfs_repair: use rmap btree data to check block types
      [7ddb50f] xfs_repair: fix fino_bno calculation when rmapbt is enabled
      [9c9990b] xfs_repair: create a slab API for allocating arrays in large chunks
      [9e0f480] xfs_repair: collect reverse-mapping data for refcount/rmap tree rebuilding
      [1102c15] xfs_repair: record and merge raw rmap data
      [00efc33] xfs_repair: add inode bmbt block rmaps
      [713b681] xfs_repair: add fixed-location per-AG rmaps
      [11b9e51] xfs_repair: check existing rmapbt entries against observed rmaps
      [934b554] xfs_repair: rebuild reverse-mapping btree
      [62cf990] xfs_repair: add per-AG btree blocks to rmap data and add to rmapbt
      [b7f12e5] xfs_repair: merge data & attr fork reverse mappings
      [6584173] xfs_repair: look for mergeable rmaps
      [a418fe7] xfs_repair: check for impossible rmap record field combinations
      [e5cc9d5] mkfs: set agsize prior to calculating minimum log size
      [c563396] mkfs.xfs: create filesystems with reverse-mappings


Code Diffstat:

 db/Makefile              |   2 +-
 db/agf.c                 |   9 +
 db/btblock.c             | 100 ++++++
 db/btblock.h             |   5 +
 db/check.c               |  85 ++++-
 db/command.c             |   2 +
 db/field.c               |  19 ++
 db/field.h               |   9 +
 db/fsmap.c               | 172 ++++++++++
 db/fsmap.h               |  20 ++
 db/metadump.c            |  74 ++++
 db/type.c                |   5 +
 db/type.h                |   2 +-
 growfs/xfs_growfs.c      |  14 +-
 include/libxfs.h         |   3 +-
 include/xfs_multidisk.h  |   4 +-
 include/xfs_trans.h      |   3 +
 io/bmap.c                |   2 +
 io/inject.c              |   6 +-
 libxfs/Makefile          |   1 +
 libxfs/defer_item.c      | 258 ++++++++++++++
 libxfs/init.c            |   4 +
 libxfs/libxfs_api_defs.h |  13 +
 libxfs/xfs_alloc.c       |  19 ++
 libxfs/xfs_format.h      |  13 +-
 libxfs/xfs_rmap_btree.c  |   6 +
 libxfs/xfs_rmap_btree.h  |   7 -
 logprint/Makefile        |   2 +-
 logprint/log_misc.c      | 155 +--------
 logprint/log_print_all.c |  72 +---
 logprint/log_redo.c      | 382 +++++++++++++++++++++
 logprint/logprint.h      |  11 +-
 man/man3/xfsctl.3        |   5 +
 man/man8/mkfs.xfs.8      |  20 ++
 man/man8/xfs_db.8        |  65 +++-
 mkfs/Makefile            |   2 +-
 mkfs/maxtrres.c          |   8 +-
 mkfs/xfs_mkfs.c          | 142 ++++++--
 repair/Makefile          |   4 +-
 repair/agheader.c        |   4 +
 repair/dinode.c          |  15 +
 repair/incore.h          |  16 +-
 repair/phase4.c          |  62 ++++
 repair/phase5.c          | 456 +++++++++++++++++++++++--
 repair/rmap.c            | 924 ++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h            |  55 +++
 repair/scan.c            | 491 ++++++++++++++++++++++++++-
 repair/slab.c            | 456 +++++++++++++++++++++++++
 repair/slab.h            |  60 ++++
 repair/xfs_repair.c      |  10 +-
 tools/xfsbuflock.py      | 205 +++++++++++
 51 files changed, 4159 insertions(+), 320 deletions(-)
 create mode 100644 db/fsmap.c
 create mode 100644 db/fsmap.h
 create mode 100644 libxfs/defer_item.c
 create mode 100644 logprint/log_redo.c
 create mode 100644 repair/rmap.c
 create mode 100644 repair/rmap.h
 create mode 100644 repair/slab.c
 create mode 100644 repair/slab.h
 create mode 100755 tools/xfsbuflock.py
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
