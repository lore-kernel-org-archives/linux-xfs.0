Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32216 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932342AbdJ0UjJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2017 16:39:09 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9RKd8J9013991
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2017 20:39:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9RKd6RP001621
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2017 20:39:07 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9RKd6Ls019454
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2017 20:39:06 GMT
Date: Fri, 27 Oct 2017 13:39:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: xfs-4.15-merge updated to 4eadcf9
Message-ID: <20171027203903.GR5483@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The xfs-4.15-merge branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  (Keep in mind we're probably still a couple of weeks
from the merge window opening...)

The new head of the korg/xfs-4.15-merge branch is commit:

4eadcf9 xfs: fix unused variable warning in xfs_buf_set_ref()

New Commits:

Brian Foster (6):
      [a53efbd] xfs: fail if xattr inactivation hits a hole
      [7561d27] xfs: buffer lru reference count error injection tag
      [99c2659] xfs: more robust recovery xlog buffer validation
      [9f2a450] xfs: fix log block underflow during recovery cycle verification
      [f1b92bbc] xfs: drain the buffer LRU on mount
      [4eadcf9] xfs: fix unused variable warning in xfs_buf_set_ref()

Christoph Hellwig (39):
      [abbf9e8] xfs: rewrite getbmap using the xfs_iext_* helpers
      [232b5194] xfs: simplify the xfs_getbmap interface
      [5e422f5] xfs: fix incorrect extent state in xfs_bmap_add_extent_unwritten_real
      [e3f0f75] xfs: use xfs_iext_get_extent instead of open coding it
      [b213d69] xfs: don't set XFS_BTCUR_BPRV_WASDEL in xfs_bunmapi
      [8280f6e] xfs: rename bno to end in __xfs_bunmapi
      [e1d7553] xfs: use xfs_bmap_del_extent_delay for the data fork as well
      [1b24b63] xfs: move some more code into xfs_bmap_del_extent_real
      [0173c68] xfs: use correct state defines in xfs_bmap_del_extent_{cow,delay}
      [491f6f8a] xfs: use the state defines in xfs_bmap_del_extent_real
      [48fd52b] xfs: refactor xfs_del_extent_real
      [3ffc18e] xfs: refactor xfs_bmap_add_extent_hole_delay
      [1abb9e5] xfs: refactor xfs_bmap_add_extent_hole_real
      [4dcb8869] xfs: refactor xfs_bmap_add_extent_delay_real
      [ca1862b] xfs: refactor delalloc accounting in xfs_bmap_add_extent_delay_real
      [79fa614] xfs: refactor xfs_bmap_add_extent_unwritten_real
      [a67d00a] xfs: pass a struct xfs_bmbt_irec to xfs_bmbt_update
      [e16cf9b] xfs: pass a struct xfs_bmbt_irec to xfs_bmbt_lookup_eq
      [b5cfbc2] xfs: replace xfs_bmbt_lookup_ge with xfs_bmbt_lookup_first
      [9b15070] xfs: remove all xfs_bmbt_set_* helpers except for xfs_bmbt_set_all
      [f038750] xfs: remove xfs_bmbt_get_state
      [060ea65] xfs: add a xfs_bmap_fork_to_state helper
      [35e62da] xfs: make better use of the 'state' variable in xfs_bmap_del_extent_real
      [d138604] xfs: remove post-bmap tracing in xfs_bmap_local_to_extents
      [ca5d8e5] xfs: move pre/post-bmap tracing into xfs_iext_update_extent
      [e8e0e17] xfs: remove XFS_BMAP_TRACE_EXLIST
      [42b67dc] xfs: remove the never fully implemented UUID fork format
      [66f3646] xfs: remove if_rdev
      [4ed36c6] xfs: inline xfs_shift_file_space into callers
      [6b18af0] xfs: remove XFS_BMAP_MAX_SHIFT_EXTENTS
      [ecfea3f] xfs: split xfs_bmap_shift_extents
      [bf80628] xfs: remove xfs_bmse_shift_one
      [11f75b3] xfs: update got in xfs_bmap_shift_update_extent
      [40591bd] xfs: don't rely on extent indices in xfs_bmap_collapse_extents
      [5936dc5] xfs: don't rely on extent indices in xfs_bmap_insert_extents
      [29b3e94] xfs: rewrite xfs_bmap_first_unused to make better use of xfs_iext_get_extent
      [9ad1a23a] xfs: add asserts for the mmap lock in xfs_{insert,collapse}_file_space
      [211e95b] xfs: merge xfs_bmap_read_extents into xfs_iread_extents
      [dc56015] xfs: add a new xfs_iext_lookup_extent_before helper

Darrick J. Wong (34):
      [ed438b4] xfs: return a distinct error code value for IGET_INCORE cache misses
      [21ec541] xfs: create block pointer check functions
      [f135761] xfs: refactor btree pointer checks
      [52c732e] xfs: refactor btree block header checking functions
      [91fb9af] xfs: create inode pointer verifiers
      [36fd6e8] xfs: create an ioctl to scrub AG metadata
      [a563718] xfs: dispatch metadata scrub subcommands
      [dcb660f] xfs: probe the scrub ioctl
      [4700d22] xfs: create helpers to record and deal with scrub problems
      [537964b] xfs: create helpers to scrub a metadata btree
      [cc3e094] xfs: scrub the shape of a metadata btree
      [37f3fa7] xfs: scrub btree keys and records
      [b6c1beb] xfs: create helpers to scan an allocation group
      [21fb4cb] xfs: scrub the secondary superblocks
      [ab9d5dc] xfs: scrub AGF and AGFL
      [a12890a] xfs: scrub the AGI
      [efa7a99] xfs: scrub free space btrees
      [3daa664] xfs: scrub inode btrees
      [c7e693d] xfs: scrub rmap btrees
      [edc09b5] xfs: scrub refcount btrees
      [80e4e12] xfs: scrub inodes
      [99d9d8d] xfs: scrub inode block mappings
      [7c4a07a] xfs: scrub directory/attribute btrees
      [a5c46e5] xfs: scrub directory metadata
      [df48196] xfs: scrub directory freespace
      [eec0482] xfs: scrub extended attributes
      [2a721db] xfs: scrub symbolic links
      [0f28b25] xfs: scrub directory parent pointers
      [29b0767] xfs: scrub realtime bitmap/summary
      [c2fc338] xfs: scrub quota information
      [9c92ee2] xfs: validate sb_logsunit is a multiple of the fs blocksize
      [bdaac93] xfs: refactor extended attribute list operation
      [8210f4d] xfs: abort dir/attr btree operation if btree is obviously weird
      [2fdbec5] xfs: compare btree block keys to parent block's keys during scrub

Hou Tao (1):
      [0bd8967] xfs: check kthread_should_stop() after the setting of task state


Code Diffstat:

 fs/xfs/Kconfig                 |   17 +
 fs/xfs/Makefile                |   28 +
 fs/xfs/libxfs/xfs_alloc.c      |   49 ++
 fs/xfs/libxfs/xfs_alloc.h      |    4 +
 fs/xfs/libxfs/xfs_attr_leaf.c  |    6 +-
 fs/xfs/libxfs/xfs_bmap.c       | 1773 +++++++++++++++-------------------------
 fs/xfs/libxfs/xfs_bmap.h       |   48 +-
 fs/xfs/libxfs/xfs_bmap_btree.c |  171 +---
 fs/xfs/libxfs/xfs_bmap_btree.h |   11 +-
 fs/xfs/libxfs/xfs_btree.c      |  258 +++---
 fs/xfs/libxfs/xfs_btree.h      |   32 +-
 fs/xfs/libxfs/xfs_da_btree.c   |   22 +-
 fs/xfs/libxfs/xfs_dir2.c       |   23 +-
 fs/xfs/libxfs/xfs_dir2.h       |   17 +
 fs/xfs/libxfs/xfs_format.h     |    9 +-
 fs/xfs/libxfs/xfs_fs.h         |   77 ++
 fs/xfs/libxfs/xfs_ialloc.c     |   90 ++
 fs/xfs/libxfs/xfs_ialloc.h     |    7 +
 fs/xfs/libxfs/xfs_inode_fork.c |  120 ++-
 fs/xfs/libxfs/xfs_inode_fork.h |   10 +-
 fs/xfs/libxfs/xfs_log_format.h |   20 +-
 fs/xfs/libxfs/xfs_rtbitmap.c   |   12 +
 fs/xfs/libxfs/xfs_types.h      |    6 +
 fs/xfs/scrub/agheader.c        |  599 ++++++++++++++
 fs/xfs/scrub/alloc.c           |  102 +++
 fs/xfs/scrub/attr.c            |  260 ++++++
 fs/xfs/scrub/bmap.c            |  366 +++++++++
 fs/xfs/scrub/btree.c           |  516 ++++++++++++
 fs/xfs/scrub/btree.h           |   57 ++
 fs/xfs/scrub/common.c          |  572 +++++++++++++
 fs/xfs/scrub/common.h          |  143 ++++
 fs/xfs/scrub/dabtree.c         |  588 +++++++++++++
 fs/xfs/scrub/dabtree.h         |   58 ++
 fs/xfs/scrub/dir.c             |  826 +++++++++++++++++++
 fs/xfs/scrub/ialloc.c          |  337 ++++++++
 fs/xfs/scrub/inode.c           |  611 ++++++++++++++
 fs/xfs/scrub/parent.c          |  317 +++++++
 fs/xfs/scrub/quota.c           |  304 +++++++
 fs/xfs/scrub/refcount.c        |   99 +++
 fs/xfs/scrub/rmap.c            |  138 ++++
 fs/xfs/scrub/rtbitmap.c        |  108 +++
 fs/xfs/scrub/scrub.c           |  392 +++++++++
 fs/xfs/scrub/scrub.h           |  115 +++
 fs/xfs/scrub/symlink.c         |   92 +++
 fs/xfs/scrub/trace.c           |   59 ++
 fs/xfs/scrub/trace.h           |  499 +++++++++++
 fs/xfs/scrub/xfs_scrub.h       |   29 +
 fs/xfs/xfs_attr.h              |    5 +-
 fs/xfs/xfs_attr_inactive.c     |   69 +-
 fs/xfs/xfs_attr_list.c         |  157 ++--
 fs/xfs/xfs_bmap_util.c         |  725 +++++++---------
 fs/xfs/xfs_bmap_util.h         |   10 +-
 fs/xfs/xfs_buf.c               |   15 +
 fs/xfs/xfs_buf.h               |    5 +-
 fs/xfs/xfs_dir2_readdir.c      |    2 +-
 fs/xfs/xfs_error.c             |    3 +
 fs/xfs/xfs_error.h             |    4 +-
 fs/xfs/xfs_file.c              |    2 +-
 fs/xfs/xfs_icache.c            |    2 +-
 fs/xfs/xfs_inode.c             |    9 +-
 fs/xfs/xfs_inode.h             |    4 +-
 fs/xfs/xfs_inode_item.c        |   27 +-
 fs/xfs/xfs_ioctl.c             |  154 ++--
 fs/xfs/xfs_ioctl32.c           |    1 +
 fs/xfs/xfs_iops.c              |   16 +-
 fs/xfs/xfs_itable.c            |   13 +-
 fs/xfs/xfs_itable.h            |    2 -
 fs/xfs/xfs_linux.h             |    7 +
 fs/xfs/xfs_log.c               |   30 +-
 fs/xfs/xfs_log_recover.c       |   50 +-
 fs/xfs/xfs_reflink.c           |   19 +-
 fs/xfs/xfs_rtalloc.h           |    2 +
 fs/xfs/xfs_trace.h             |    5 +-
 fs/xfs/xfs_trans_ail.c         |   21 +-
 74 files changed, 9174 insertions(+), 2182 deletions(-)
 create mode 100644 fs/xfs/scrub/agheader.c
 create mode 100644 fs/xfs/scrub/alloc.c
 create mode 100644 fs/xfs/scrub/attr.c
 create mode 100644 fs/xfs/scrub/bmap.c
 create mode 100644 fs/xfs/scrub/btree.c
 create mode 100644 fs/xfs/scrub/btree.h
 create mode 100644 fs/xfs/scrub/common.c
 create mode 100644 fs/xfs/scrub/common.h
 create mode 100644 fs/xfs/scrub/dabtree.c
 create mode 100644 fs/xfs/scrub/dabtree.h
 create mode 100644 fs/xfs/scrub/dir.c
 create mode 100644 fs/xfs/scrub/ialloc.c
 create mode 100644 fs/xfs/scrub/inode.c
 create mode 100644 fs/xfs/scrub/parent.c
 create mode 100644 fs/xfs/scrub/quota.c
 create mode 100644 fs/xfs/scrub/refcount.c
 create mode 100644 fs/xfs/scrub/rmap.c
 create mode 100644 fs/xfs/scrub/rtbitmap.c
 create mode 100644 fs/xfs/scrub/scrub.c
 create mode 100644 fs/xfs/scrub/scrub.h
 create mode 100644 fs/xfs/scrub/symlink.c
 create mode 100644 fs/xfs/scrub/trace.c
 create mode 100644 fs/xfs/scrub/trace.h
 create mode 100644 fs/xfs/scrub/xfs_scrub.h
