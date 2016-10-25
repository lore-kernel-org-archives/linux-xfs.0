Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40101 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753699AbcJYWsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 18:48:14 -0400
Date: Tue, 25 Oct 2016 15:48:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfsprogs: for-next branch updated to 077dd509197e
Message-ID: <20161025224809.GB23568@birch.djwong.org>
References: <20161025060756.GB23194@dastard>
 <20161025064147.GA23568@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161025064147.GA23568@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2016 at 11:41:48PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 25, 2016 at 05:07:56PM +1100, Dave Chinner wrote:
> > Hi Folks,
> > 
> > The for-next branch xfsprogs repository at:
> > 
> > git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > 
> > has just been updated. This is the libxfs sync with the 4.9-rc1
> > kernel code, along with all the fixes pending for 4.9-rc3. This
> > brings the tree up to the state where we can start adding all of
> > Darrick's userspace work to support shared data extents, and I can
> > catch up with all the other patches sitting on the list for
> > xfsprogs.
> > 
> > Darrick, can you compare these with your latest tree and point out
> > all the things I missed, even though the result compiles and seems
> > to run through xfstests fine. Also, if you rebase your next round of
> > userspace updates on this I can start reviewing them and pulling
> > them in...
> 
> Broadly speaking, the biggest points of divergence between our trees are
> libxfs/defer_item.c and updating logprint to reflect the rmap log item
> format changes that went into 4.8 last minute.  Also that libxfs resync
> cleanup thing I was hinting about last week but never got around to
> posting.  Oh, and all the stuff that changed in libxfs after I migrated
> all the reflink patches directly onto for-next and haphazardly ported to
> xfsprogs...
> 
> ...ugh.  Guess I'll just make a new branch and see which patches from
> the old one stick.  Eh? :P  (It's really not that divergent.)
> 
> Anyway, I'll go find the missing bits and send them out tomorrow.  Might
> even manage to send out the reflink patches at the same time, who knows?
> 
> :)
> 
> Anyway, thx for the import+push.

Tests passed, will patchbomb shortly.

--D

> 
> --D
> 
> > 
> > -Dave.
> > 
> > The new head of the for-next branch is commit:
> > 
> > 077dd509197e xfs: defer should abort intent items if the trans roll fails
> > 
> > New Commits:
> > 
> > Christoph Hellwig (3):
> >       [4488e42190ea] xfs: rewrite and optimize the delalloc write path
> >       [ece930fa14a3] xfs: refactor xfs_bunmapi_cow
> >       [2873ab2b8520] xfs: remove xfs_bunmapi_cow
> > 
> > Colin Ian King (1):
> >       [dd84fc92d7c4] xfs: remove redundant assignment of ifp
> > 
> > Darrick J. Wong (49):
> >       [11d87237b70f] xfs: track log done items directly in the deferred pending work item
> >       [a2fc338e64be] xfs: convert RUI log formats to use variable length arrays
> >       [45413937e67f] xfs: remove xfs_btree_bigkey
> >       [fc8c849d1ca5] xfs: create a standard btree size calculator code
> >       [2cccc8cee723] xfs: count the blocks in a btree
> >       [0590692ed11e] xfs: defer should allow ->finish_item to request a new transaction
> >       [cf8ce2204958] xfs: set up per-AG free space reservations
> >       [88ce079228b1] xfs: introduce refcount btree definitions
> >       [2a96beb95cb6] xfs: refcount btree add more reserved blocks
> >       [d8079fe03fe6] xfs: define the on-disk refcount btree format
> >       [dfa69e0a5cdd] xfs: account for the refcount btree in the alloc/free log reservation
> >       [bc859611285b] xfs: add refcount btree operations
> >       [a5a35c0d82f3] xfs: create refcount update intent log items
> >       [c1ea40108f36] xfs: log refcount intent items
> >       [56ef8c337692] xfs: adjust refcount of an extent of blocks in refcount btree
> >       [23a15a6c29c8] xfs: connect refcount adjust functions to upper layers
> >       [cfe32f0db83c] xfs: adjust refcount when unmapping file blocks
> >       [868c70e32419] xfs: reserve AG space for the refcount btree root
> >       [940973309b87] xfs: introduce reflink utility functions
> >       [0f7dadcf5bc9] xfs: create bmbt update intent log items
> >       [34f8f3e12ea5] xfs: log bmap intent items
> >       [34621a4761b8] xfs: map an inode's offset to an exact physical block
> >       [36b16da8bf88] xfs: pass bmapi flags through to bmap_del_extent
> >       [aeb88300f19d] xfs: implement deferred bmbt map/unmap operations
> >       [3d36acda7f86] xfs: return work remaining at the end of a bunmapi operation
> >       [f0b8028cb025] xfs: add reflink feature flag to geometry
> >       [9d3f10866346] xfs: don't allow reflinked dir/dev/fifo/socket/pipe files
> >       [cb8a004a12f7] xfs: introduce the CoW fork
> >       [cc66acaf151a] xfs: support bmapping delalloc extents in the CoW fork
> >       [1277a5e09266] xfs: support allocating delayed extents in CoW fork
> >       [d35205bac9f9] xfs: support removing extents from CoW fork
> >       [10e6550346b5] xfs: store in-progress CoW allocations in the refcount btree
> >       [464e5807ebc6] xfs: teach get_bmapx about shared extents and the CoW fork
> >       [104609946adc] xfs: create a separate cow extent size hint for the allocator
> >       [02cc8b2a1b04] xfs: preallocate blocks for worst-case btree expansion
> >       [68d06dce0646] xfs: try other AGs to allocate a BMBT block
> >       [043983327af8] xfs: increase log reservations for reflink
> >       [2b7e542877b1] xfs: add shared rmap map/unmap/convert log item types
> >       [6c6bdf6f7982] xfs: use interval query for rmap alloc operations on shared files
> >       [9c7bc093c30e] xfs: convert unwritten status of reverse mappings for shared files
> >       [183537ed6ee2] xfs: check for invalid inode reflink flags
> >       [378ed4e785ae] xfs: don't mix reflink and DAX mode for now
> >       [c7bf13987fdb] xfs: simulate per-AG reservations being critically low
> >       [2c834d2078b2] xfs: recognize the reflink feature bit
> >       [09a5b0e23115] xfs: implement swapext for rmap filesystems
> >       [22a693224bf7] xfs: rework refcount cow recovery error handling
> >       [2375c1f73b0d] libxfs: clean up _calc_dquots_per_chunk
> >       [b3fd8db7f773] xfs: add xfs_trim_extent
> >       [077dd509197e] xfs: defer should abort intent items if the trans roll fails
> > 
> > Dave Chinner (4):
> >       [1516533c8c83] libxfs_apply: filter commits from libxfs only
> >       [ae11d3088dd7] libxfs_apply: filterdiff can't handle /dev/null properly
> >       [85428dd23fd0] xfs: fix superblock inprogress check
> >       [1fccd5c892c9] xfs: remote attribute blocks aren't really userdata
> > 
> > Eric Biggers (1):
> >       [1e85c20d20e2] xfs: add some 'static' annotations
> > 
> > Eric Sandeen (1):
> >       [114c49821dfe] xfs: remove pointless error goto in xfs_bmap_remap_alloc
> > 
> > 
> > Code Diffstat:
> > 
> >  include/darwin.h            |    1 +
> >  include/freebsd.h           |   13 +-
> >  include/gnukfreebsd.h       |   11 +-
> >  include/irix.h              |   10 +-
> >  include/linux.h             |    1 +
> >  include/xfs_inode.h         |   10 +
> >  include/xfs_mount.h         |   42 ++
> >  include/xfs_trace.h         |   84 +++
> >  libxfs/Makefile             |    6 +
> >  libxfs/defer_item.c         |    3 +-
> >  libxfs/libxfs_io.h          |    2 +-
> >  libxfs/libxfs_priv.h        |    7 +-
> >  libxfs/rdwr.c               |   20 +-
> >  libxfs/xfs_ag_resv.c        |  337 +++++++++
> >  libxfs/xfs_ag_resv.h        |   35 +
> >  libxfs/xfs_alloc.c          |  155 +++--
> >  libxfs/xfs_alloc.h          |   25 +-
> >  libxfs/xfs_bmap.c           |  782 +++++++++++++++++----
> >  libxfs/xfs_bmap.h           |   79 ++-
> >  libxfs/xfs_bmap_btree.c     |   18 +
> >  libxfs/xfs_btree.c          |   67 +-
> >  libxfs/xfs_btree.h          |   44 +-
> >  libxfs/xfs_defer.c          |  111 ++-
> >  libxfs/xfs_defer.h          |    4 +-
> >  libxfs/xfs_dquot_buf.c      |    1 -
> >  libxfs/xfs_format.h         |   97 ++-
> >  libxfs/xfs_fs.h             |   10 +-
> >  libxfs/xfs_ialloc_btree.c   |    2 +-
> >  libxfs/xfs_inode_buf.c      |   24 +-
> >  libxfs/xfs_inode_buf.h      |    1 +
> >  libxfs/xfs_inode_fork.c     |   70 +-
> >  libxfs/xfs_inode_fork.h     |   28 +-
> >  libxfs/xfs_log_format.h     |  128 +++-
> >  libxfs/xfs_refcount.c       | 1697 ++++++++++++++++++++++++++++++++++++++++++++++
> >  libxfs/xfs_refcount.h       |   70 ++
> >  libxfs/xfs_refcount_btree.c |  450 ++++++++++++
> >  libxfs/xfs_refcount_btree.h |   74 ++
> >  libxfs/xfs_rmap.c           | 1120 +++++++++++++++++++++++++++---
> >  libxfs/xfs_rmap.h           |    7 +
> >  libxfs/xfs_rmap_btree.c     |   82 ++-
> >  libxfs/xfs_rmap_btree.h     |    7 +
> >  libxfs/xfs_sb.c             |   12 +-
> >  libxfs/xfs_shared.h         |    2 +
> >  libxfs/xfs_trans_resv.c     |   23 +-
> >  libxfs/xfs_trans_resv.h     |    3 +
> >  libxfs/xfs_trans_space.h    |    9 +
> >  libxfs/xfs_types.h          |    3 +-
> >  repair/phase5.c             |    3 +-
> >  tools/libxfs-apply          |   52 +-
> >  49 files changed, 5387 insertions(+), 455 deletions(-)
> >  create mode 100644 libxfs/xfs_ag_resv.c
> >  create mode 100644 libxfs/xfs_ag_resv.h
> >  create mode 100644 libxfs/xfs_refcount.c
> >  create mode 100644 libxfs/xfs_refcount.h
> >  create mode 100644 libxfs/xfs_refcount_btree.c
> >  create mode 100644 libxfs/xfs_refcount_btree.h
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
