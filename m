Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1950025AbdDZLlI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 07:41:08 -0400
Date: Wed, 26 Apr 2017 07:41:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 9fb0026
Message-ID: <20170426114106.GC10392@bfoster.bfoster>
References: <20170425175349.GM5205@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170425175349.GM5205@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Apr 25, 2017 at 10:53:49AM -0700, Darrick J. Wong wrote:
> Hi folks,
> 
> The for-next branch of the xfs-linux repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> 
> has just been updated.  This branch contains nearly all of the patches
> that I intend to merge for 4.12 -- many bug fixes and code refactoring,
> and the GETFSMAP ioctl.  The "remove unlinked inodes on ro mount"
> patches that proved controversial in my last announcement are not in
> this pile.
> 
> I'm still looking for a re-review of "xfs: reserve enough blocks to
> handle btree splits when remapping", btw.  Christoph reviewed the first
> iteration, but then I made some changes to fix compiler errors and some
> of Brian's suggestions.  This is (afaik) the only patch that I know of
> that could be a 4.12 patch but isn't already on the branch.
> 

Any thoughts on these[1] quotaoff fixes from a ways back (patches 2-5 in
the series, as patch 1 was an old variant of the quotacheck thing)?

Brian

[1]  http://www.spinics.net/lists/linux-xfs/msg04302.html

> Note: I noticed that the fs/xfs/ directory changed since the last batch
> of updates I sent (the statx support patch got merged), so if people
> encounter merge problems or really want me to, I'm open to rebasing
> against -rc8.  FWIW, for-next is based off -rc4 since that was the first
> rc that booted reliably for me on all my test platforms.
> 
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
> 
> The new head of the for-next branch is commit:
> 
> c4cf1ac xfs: better log intent item refcount checking
> 
> New Commits:
> 
> Brian Foster (4):
>       [696a562] xfs: use dedicated log worker wq to avoid deadlock with cil wq
>       [3b4683c] xfs: drop iolock from reclaim context to appease lockdep
>       [cb52ee3] xfs: prevent multi-fsb dir readahead from reading random blocks
>       [20e8a06] xfs: fix up quotacheck buffer list error handling
> 
> Calvin Owens (1):
>       [105664d] xfs: Honor FALLOC_FL_KEEP_SIZE when punching ends of files
> 
> Chandan Rajendra (1):
>       [a008c31] iomap_dio_rw: Prevent reading file data beyond iomap_dio->i_size
> 
> Christoph Hellwig (18):
>       [9c4f29d] xfs: factor out a xfs_bmap_is_real_extent helper
>       [63fbb4c] xfs: remove the ISUNWRITTEN macro
>       [254133f] xfs: fold __xfs_trans_roll into xfs_trans_roll
>       [52813fb] xfs: fix integer truncation in xfs_bmap_remap_alloc
>       [39e07da] xfs: remove attr fork handling in xfs_bmap_finish_one
>       [6d04558] xfs: pass individual arguments to xfs_bmap_add_extent_hole_real
>       [6ebd5a4] xfs: introduce xfs_bmapi_remap
>       [bf8eadb] xfs: remove xfs_bmap_remap_alloc
>       [7590632] xfs: remove bmap block allocation retries
>       [895e9bf] xfs: remove the unused XFS_MAXLINK_1 define
>       [37f7f9b] xfs: remove unused values from xfs_exntst_t
>       [0c1d9e4] xfs: simplify validation of the unwritten extent bit
>       [fad5656] xfs: use NULL instead of 0 to initialize a pointer in xfs_getfsmap
>       [ef2b67e] xfs: use NULL instead of 0 to initialize a pointer in xfs_ioc_getfsmap
>       [e2a6419] xfs: corruption needs to respect endianess too!
>       [9d17e14] xfs: fix __user annotations for xfs_ioc_getfsmap
>       [3f88a15] xfs: don't use bool values in trace buffers
>       [27af1bb] xfs: remove xfs_trans_ail_delete_bulk
> 
> Darrick J. Wong (14):
>       [005c5db] xfs: rework the inline directory verifiers
>       [f1c0e20] xfs: fix kernel memory exposure problems
>       [be6324c] xfs: fix over-copying of getbmap parameters from userspace
>       [80c9f49] vfs: add common GETFSMAP ioctl definitions
>       [08438b1] xfs: plumb in needed functions for range querying of the freespace btrees
>       [2d520bf] xfs: provide a query_range function for freespace btrees
>       [e9a2599] xfs: create a function to query all records in a btree
>       [fb3c3de] xfs: add a couple of queries to iterate free extents in the rtbitmap
>       [e89c041] xfs: implement the GETFSMAP ioctl
>       [a1cae72] xfs: have getfsmap fall back to the freesp btrees when rmap is not present
>       [4c934c7] xfs: report realtime space information via the rtbitmap
>       [84358536d] xfs: actually report xattr extents via iomap
>       [12e4a38] xfs: fix getfsmap userspace memory corruption while setting OF_LAST
>       [c4cf1ac] xfs: better log intent item refcount checking
> 
> Eric Sandeen (6):
>       [bc593ee] xfs: fix up inode validation failure message
>       [d956f81] xfs: simplify xfs_calc_dquots_per_chunk
>       [5146d0b] xfs: remove custom do_div implementations
>       [023cc84] xfs: handle array index overrun in xfs_dir2_leaf_readbuf()
>       [9011540] xfs: remove use of do_div with 32-bit dividend in quota
>       [4f1adf3] xfs: more do_div cleanups
> 
> Hou Tao (1):
>       [42bf9db] xfs: remove the trailing newline used in the fmt parameter of TP_printk
> 
> Nikolay Borisov (1):
>       [422e5b5] xfs: Remove obsolete declaration of xfs_buf_get_empty
> 
> 
> Code Diffstat:
> 
>  fs/iomap.c                      |   3 +
>  fs/xfs/Makefile                 |   1 +
>  fs/xfs/libxfs/xfs_alloc.c       |  57 +++
>  fs/xfs/libxfs/xfs_alloc.h       |  12 +
>  fs/xfs/libxfs/xfs_alloc_btree.c | 172 ++++++--
>  fs/xfs/libxfs/xfs_bmap.c        | 354 +++++++--------
>  fs/xfs/libxfs/xfs_bmap.h        |  14 +-
>  fs/xfs/libxfs/xfs_bmap_btree.c  |  43 --
>  fs/xfs/libxfs/xfs_bmap_btree.h  |  22 +-
>  fs/xfs/libxfs/xfs_btree.c       |  15 +
>  fs/xfs/libxfs/xfs_btree.h       |   2 +
>  fs/xfs/libxfs/xfs_dir2_priv.h   |   3 +-
>  fs/xfs/libxfs/xfs_dir2_sf.c     |  63 ++-
>  fs/xfs/libxfs/xfs_dquot_buf.c   |   7 +-
>  fs/xfs/libxfs/xfs_format.h      |  11 -
>  fs/xfs/libxfs/xfs_fs.h          |  13 +
>  fs/xfs/libxfs/xfs_inode_buf.c   |   2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c  | 125 ++----
>  fs/xfs/libxfs/xfs_inode_fork.h  |   2 +-
>  fs/xfs/libxfs/xfs_rmap.c        |  56 ++-
>  fs/xfs/libxfs/xfs_rmap.h        |   4 +
>  fs/xfs/libxfs/xfs_rtbitmap.c    |  70 +++
>  fs/xfs/xfs_aops.c               |   8 +-
>  fs/xfs/xfs_bmap_item.c          |   1 +
>  fs/xfs/xfs_bmap_util.c          |  30 +-
>  fs/xfs/xfs_buf.c                |  24 +
>  fs/xfs/xfs_buf.h                |   2 +-
>  fs/xfs/xfs_dir2_readdir.c       |  15 +-
>  fs/xfs/xfs_extfree_item.c       |   1 +
>  fs/xfs/xfs_fsmap.c              | 940 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_fsmap.h              |  53 +++
>  fs/xfs/xfs_inode.c              |  28 +-
>  fs/xfs/xfs_inode_item.c         |  29 +-
>  fs/xfs/xfs_ioctl.c              |  89 +++-
>  fs/xfs/xfs_ioctl32.c            |   2 +
>  fs/xfs/xfs_iomap.c              |   8 +-
>  fs/xfs/xfs_itable.c             |   2 +-
>  fs/xfs/xfs_linux.h              |  85 ----
>  fs/xfs/xfs_log.c                |   4 +-
>  fs/xfs/xfs_mount.h              |   5 +-
>  fs/xfs/xfs_qm.c                 |  11 +-
>  fs/xfs/xfs_refcount_item.c      |   1 +
>  fs/xfs/xfs_reflink.c            |  21 +-
>  fs/xfs/xfs_rmap_item.c          |   1 +
>  fs/xfs/xfs_rtalloc.h            |  22 +-
>  fs/xfs/xfs_super.c              |   8 +
>  fs/xfs/xfs_trace.c              |   1 +
>  fs/xfs/xfs_trace.h              | 144 ++++--
>  fs/xfs/xfs_trans.c              |  39 +-
>  fs/xfs/xfs_trans.h              |   3 +-
>  fs/xfs/xfs_trans_ail.c          |  71 ++-
>  fs/xfs/xfs_trans_priv.h         |  15 +-
>  include/uapi/linux/fsmap.h      | 112 +++++
>  53 files changed, 2124 insertions(+), 702 deletions(-)
>  create mode 100644 fs/xfs/xfs_fsmap.c
>  create mode 100644 fs/xfs/xfs_fsmap.h
>  create mode 100644 include/uapi/linux/fsmap.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
