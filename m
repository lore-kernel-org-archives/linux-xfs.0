Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37655 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942128AbcJFPwI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Oct 2016 11:52:08 -0400
Date: Thu, 6 Oct 2016 08:52:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to 1f08af52e7c9
Message-ID: <20161006155202.GA5619@birch.djwong.org>
References: <20161006111713.GD9806@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161006111713.GD9806@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 06, 2016 at 10:17:13PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> The for-next branch of the xfs kernel repository at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> 
> has just been updated. This update contains the shiny new reflink
> functionality written by Darrick. If you are not using reflink
> enabled filesystems, then you should see no new problems or
> regressions as a result ofthe merge. If you do, please let us know
> immediately.
> 
> For those of you that want to test the new reflink functionality,
> you'll need to grab Darrick's latest xfsprogs branch. You probably

https://github.com/djwong/xfsprogs/tree/for-dave-for-4.9-10

> also want to grab his latest xfstests branch, too, so you don't get

https://github.com/djwong/xfstests/tree/djwong-devel

> failures from the tests that were obviously broken by recent
> updates.

I'll send out a proper xfsprogs patchset after xfsprogs 4.9-rc1 is
tagged, with appropriate mods for whatever else gets queued up.

As for xfstests... I'll email them out by the end of the week.

> The xfsprogs reflink merge will occur after the kernel merge has
> occurred, similar to the way rmap supprot was handled in the last
> cycle. The xfstests runs with this series are not completely clean
> yet - I see 5-6 new test failures across different machines, but
> none of them are serious (e.g. unexpected ENOSPC errors causes
> generic/204 failure because reflink consumes more space) and will be
> fixed up over the next few weeks.
> 
> Darrick - for updates and fixes that need to be added to the 4.9
> tree, let's revert to the normal "send patch to mailing list"
> method for getting changes into the tree so everyone can pick them
> up and review them as soon as they are sent...

Ok.  All the changes made since the last patchbomb have been reviewer
suggestions and integrating the last patches Christoph posted on the
topic.

--D

> 
> Cheers,
> 
> Dave.
> 
> The new head of the for-next branch is commit:
> 
> 1f08af52e7c9 xfs: implement swapext for rmap filesystems
> 
> New Commits:
> 
> Darrick J. Wong (63):
>       [0a6eab8bd4e0] vfs: support FS_XFLAG_COWEXTSIZE and get/set of CoW extent size hint
>       [71be6b4942dd] vfs: add a FALLOC_FL_UNSHARE mode to fallocate to unshare a range of blocks
>       [9cdafd8a769b] xfs: return an error when an inline directory is too small
>       [c75c752d0374] xfs: define tracepoints for refcount btree activities
>       [46eeb521b952] xfs: introduce refcount btree definitions
>       [af30dfa14411] xfs: refcount btree add more reserved blocks
>       [1946b91cee4f] xfs: define the on-disk refcount btree format
>       [ac4fef69386a] xfs: add refcount btree support to growfs
>       [f310bd2ecd37] xfs: account for the refcount btree in the alloc/free log reservation
>       [bdf28630b721] xfs: add refcount btree operations
>       [baf4bcacb715] xfs: create refcount update intent log items
>       [f997ee213717] xfs: log refcount intent items
>       [3172725814f9] xfs: adjust refcount of an extent of blocks in refcount btree
>       [33ba61292084] xfs: connect refcount adjust functions to upper layers
>       [62aab20f0875] xfs: adjust refcount when unmapping file blocks
>       [a90c00f05554] xfs: add refcount btree block detection to log recovery
>       [d0e853f3600c] xfs: reserve AG space for the refcount btree root
>       [350a27a6a65c] xfs: introduce reflink utility functions
>       [6413a01420c2] xfs: create bmbt update intent log items
>       [77d61fe45e72] xfs: log bmap intent items
>       [f65306ea5246] xfs: map an inode's offset to an exact physical block
>       [4847acf868bb] xfs: pass bmapi flags through to bmap_del_extent
>       [9f3afb57d5f1] xfs: implement deferred bmbt map/unmap operations
>       [17c12bcd3030] xfs: when replaying bmap operations, don't let unlinked inodes get reaped
>       [4453593be6c5] xfs: return work remaining at the end of a bunmapi operation
>       [53aa1c34f4eb] xfs: define tracepoints for reflink activities
>       [f0ec1b8ef11d] xfs: add reflink feature flag to geometry
>       [11715a21bc30] xfs: don't allow reflinked dir/dev/fifo/socket/pipe files
>       [3993baeb3c52] xfs: introduce the CoW fork
>       [be51f8119c2f] xfs: support bmapping delalloc extents in the CoW fork
>       [2a06705cd595] xfs: create delalloc extents in CoW fork
>       [60b4984fc392] xfs: support allocating delayed extents in CoW fork
>       [ef4736678fc3] xfs: allocate delayed extents in CoW fork
>       [4862cfe825c0] xfs: support removing extents from CoW fork
>       [43caeb187deb] xfs: move mappings from cow fork to data fork after copy-write
>       [db1327b16c2b] xfs: report shared extent mappings to userspace correctly
>       [0613f16cd201] xfs: implement CoW for directio writes
>       [aa8968f227a8] xfs: cancel CoW reservations and clear inode reflink flag when freeing blocks
>       [5e7e605c4d1b] xfs: cancel pending CoW reservations when destroying inodes
>       [174edb0e46e5] xfs: store in-progress CoW allocations in the refcount btree
>       [862bb360ef56] xfs: reflink extents from one file to another
>       [9fe26045e98f] xfs: add clone file and clone range vfs functions
>       [cc714660bb8b] xfs: add dedupe range vfs function
>       [f86f403794b1] xfs: teach get_bmapx about shared extents and the CoW fork
>       [f0bc4d134b46] xfs: swap inode reflink flags when swapping inode extents
>       [98cc2db5b8b2] xfs: unshare a range of blocks via fallocate
>       [f7ca35227253] xfs: create a separate cow extent size hint for the allocator
>       [84d6961910ea] xfs: preallocate blocks for worst-case btree expansion
>       [6fa164b865e4] xfs: don't allow reflink when the AG is low on space
>       [90e2056d76ad] xfs: try other AGs to allocate a BMBT block
>       [83104d449e8c] xfs: garbage collect old cowextsz reservations
>       [80de462e090c] xfs: increase log reservations for reflink
>       [0e07c039bac5] xfs: add shared rmap map/unmap/convert log item types
>       [ceeb9c832eec] xfs: use interval query for rmap alloc operations on shared files
>       [3f165b334e51] xfs: convert unwritten status of reverse mappings for shared files
>       [e153aa7990a0] xfs: set a default CoW extent size of 32 blocks
>       [c8e156ac336d] xfs: check for invalid inode reflink flags
>       [4f435ebe7d04] xfs: don't mix reflink and DAX mode for now
>       [a35eb41519ab] xfs: simulate per-AG reservations being critically low
>       [e54b5bf9d7ae] xfs: recognize the reflink feature bit
>       [e06259aa08fb] xfs: various swapext cleanups
>       [39aff5fdb91e] xfs: refactor swapext code
>       [1f08af52e7c9] xfs: implement swapext for rmap filesystems
> 
> 
> Code Diffstat:
> 
>  fs/open.c                          |    5 +
>  fs/xfs/Makefile                    |    7 +
>  fs/xfs/libxfs/xfs_ag_resv.c        |   15 +-
>  fs/xfs/libxfs/xfs_alloc.c          |   23 +
>  fs/xfs/libxfs/xfs_bmap.c           |  575 ++++++++++++-
>  fs/xfs/libxfs/xfs_bmap.h           |   67 +-
>  fs/xfs/libxfs/xfs_bmap_btree.c     |   18 +
>  fs/xfs/libxfs/xfs_btree.c          |    8 +-
>  fs/xfs/libxfs/xfs_btree.h          |   16 +
>  fs/xfs/libxfs/xfs_defer.h          |    2 +
>  fs/xfs/libxfs/xfs_format.h         |   97 ++-
>  fs/xfs/libxfs/xfs_fs.h             |   10 +-
>  fs/xfs/libxfs/xfs_inode_buf.c      |   24 +-
>  fs/xfs/libxfs/xfs_inode_buf.h      |    1 +
>  fs/xfs/libxfs/xfs_inode_fork.c     |   70 +-
>  fs/xfs/libxfs/xfs_inode_fork.h     |   28 +-
>  fs/xfs/libxfs/xfs_log_format.h     |  118 ++-
>  fs/xfs/libxfs/xfs_refcount.c       | 1700 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_refcount.h       |   70 ++
>  fs/xfs/libxfs/xfs_refcount_btree.c |  451 +++++++++++
>  fs/xfs/libxfs/xfs_refcount_btree.h |   74 ++
>  fs/xfs/libxfs/xfs_rmap.c           | 1120 +++++++++++++++++++++++---
>  fs/xfs/libxfs/xfs_rmap.h           |    7 +
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   82 +-
>  fs/xfs/libxfs/xfs_rmap_btree.h     |    7 +
>  fs/xfs/libxfs/xfs_sb.c             |    9 +
>  fs/xfs/libxfs/xfs_shared.h         |    2 +
>  fs/xfs/libxfs/xfs_trans_resv.c     |   23 +-
>  fs/xfs/libxfs/xfs_trans_resv.h     |    3 +
>  fs/xfs/libxfs/xfs_trans_space.h    |    9 +
>  fs/xfs/libxfs/xfs_types.h          |    3 +-
>  fs/xfs/xfs_aops.c                  |  222 ++++-
>  fs/xfs/xfs_aops.h                  |    4 +-
>  fs/xfs/xfs_bmap_item.c             |  508 ++++++++++++
>  fs/xfs/xfs_bmap_item.h             |   98 +++
>  fs/xfs/xfs_bmap_util.c             |  589 ++++++++++----
>  fs/xfs/xfs_dir2_readdir.c          |    3 +-
>  fs/xfs/xfs_error.h                 |   10 +-
>  fs/xfs/xfs_file.c                  |  221 ++++-
>  fs/xfs/xfs_fsops.c                 |  107 ++-
>  fs/xfs/xfs_fsops.h                 |    3 +
>  fs/xfs/xfs_globals.c               |    5 +-
>  fs/xfs/xfs_icache.c                |  243 +++++-
>  fs/xfs/xfs_icache.h                |    7 +
>  fs/xfs/xfs_inode.c                 |   51 ++
>  fs/xfs/xfs_inode.h                 |   19 +
>  fs/xfs/xfs_inode_item.c            |    2 +-
>  fs/xfs/xfs_ioctl.c                 |   75 +-
>  fs/xfs/xfs_iomap.c                 |   35 +-
>  fs/xfs/xfs_iomap.h                 |    3 +-
>  fs/xfs/xfs_iops.c                  |    1 +
>  fs/xfs/xfs_itable.c                |    8 +-
>  fs/xfs/xfs_linux.h                 |    1 +
>  fs/xfs/xfs_log_recover.c           |  357 ++++++++
>  fs/xfs/xfs_mount.c                 |   32 +
>  fs/xfs/xfs_mount.h                 |    8 +
>  fs/xfs/xfs_ondisk.h                |    3 +
>  fs/xfs/xfs_pnfs.c                  |    7 +
>  fs/xfs/xfs_refcount_item.c         |  539 +++++++++++++
>  fs/xfs/xfs_refcount_item.h         |  101 +++
>  fs/xfs/xfs_reflink.c               | 1702 +++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_reflink.h               |   58 ++
>  fs/xfs/xfs_rmap_item.c             |   12 +
>  fs/xfs/xfs_stats.c                 |    1 +
>  fs/xfs/xfs_stats.h                 |   18 +-
>  fs/xfs/xfs_super.c                 |   85 ++
>  fs/xfs/xfs_sysctl.c                |    9 +
>  fs/xfs/xfs_sysctl.h                |    1 +
>  fs/xfs/xfs_trace.h                 |  742 ++++++++++++++++-
>  fs/xfs/xfs_trans.h                 |   29 +
>  fs/xfs/xfs_trans_bmap.c            |  249 ++++++
>  fs/xfs/xfs_trans_refcount.c        |  264 ++++++
>  fs/xfs/xfs_trans_rmap.c            |    9 +
>  include/linux/falloc.h             |    3 +-
>  include/uapi/linux/falloc.h        |   18 +
>  include/uapi/linux/fs.h            |    4 +-
>  76 files changed, 10697 insertions(+), 413 deletions(-)
>  create mode 100644 fs/xfs/libxfs/xfs_refcount.c
>  create mode 100644 fs/xfs/libxfs/xfs_refcount.h
>  create mode 100644 fs/xfs/libxfs/xfs_refcount_btree.c
>  create mode 100644 fs/xfs/libxfs/xfs_refcount_btree.h
>  create mode 100644 fs/xfs/xfs_bmap_item.c
>  create mode 100644 fs/xfs/xfs_bmap_item.h
>  create mode 100644 fs/xfs/xfs_refcount_item.c
>  create mode 100644 fs/xfs/xfs_refcount_item.h
>  create mode 100644 fs/xfs/xfs_reflink.c
>  create mode 100644 fs/xfs/xfs_reflink.h
>  create mode 100644 fs/xfs/xfs_trans_bmap.c
>  create mode 100644 fs/xfs/xfs_trans_refcount.c
> -- 
> Dave Chinner
> david@fromorbit.com


