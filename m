Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39311 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752046AbdKGWaT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2017 17:30:19 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA7MUIg9029963
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 22:30:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA7MUIX8010573
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 22:30:18 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA7MUHku018392
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 22:30:18 GMT
Date: Tue, 7 Nov 2017 14:30:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: xfs-4.15-merge updated to 181fdfe
Message-ID: <20171107223016.GC26910@magnolia>
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
the next update.

The biggest thing landing this time around is Christoph's rework of the
incore extent cache -- now it's a proper tree, which eliminates one
source of high-order memory allocations that could cause problems when
disk and memory are both heavily fragmented.

I'm still hoping to get some review of the series "xfs: various 4.15
scrub fixes" so that I can get them in during the merge window. :)

The new head of the xfs-4.15-merge branch is commit:

181fdfe xfs: mark xlog_verify_dest_ptr STATIC

New Commits:

Christoph Hellwig (29):
      [1bfd761] xfs: don't create overlapping extents in xfs_bmap_add_extent_delay_real
      [bf99971] xfs: remove a duplicate assignment in xfs_bmap_add_extent_delay_real
      [0d04554] xfs: treat idx as a cursor in xfs_bmap_add_extent_delay_real
      [41d196f] xfs: treat idx as a cursor in xfs_bmap_add_extent_hole_delay
      [1d2e008] xfs: treat idx as a cursor in xfs_bmap_add_extent_hole_real
      [a681847] xfs: treat idx as a cursor in xfs_bmap_add_extent_unwritten_real
      [657fcb2] xfs: treat idx as a cursor in xfs_bmap_del_extent_*
      [4263036] xfs: treat idx as a cursor in xfs_bmap_collapse_extents
      [f36bc22] xfs: pass an on-disk extent to xfs_bmbt_validate_extent
      [71565f4] xfs: iterate over extents in xfs_iextents_copy
      [906abed] xfs: iterate over extents in xfs_bmap_extents_to_btree
      [b2b1712] xfs: introduce the xfs_iext_cursor abstraction
      [41caabd] xfs: iterate backwards in xfs_reflink_cancel_cow_blocks
      [b121459] xfs: simplify xfs_reflink_convert_cow
      [4351881] xfs: remove support for inlining data/extents into the inode fork
      [135dcc1] xfs: allow unaligned extent records in xfs_bmbt_disk_set_all
      [6bdcf26] xfs: use a b+tree for the in-core extent list
      [0254c2f] xfs: remove the nr_extents argument to xfs_iext_insert
      [c38ccf5] xfs: remove the nr_extents argument to xfs_iext_remove
      [dac9c9b] xfs: pass struct xfs_bmbt_irec to xfs_bmbt_validate_extent
      [866d782] xfs: move xfs_bmbt_irec and xfs_exntst_t to xfs_types.h
      [fc41e2a] xfs: always define STATIC to static noinline
      [88aa5de] xfs: trivial sparse fixes for the new scrub code
      [4371155] xfs: mark xfs_errortag_ktype static
      [afd7245] xfs: remove unused debug counts for xfs_lock_inodes
      [a61a2c8] xfs: remove unreachable error injection code in xfs_qm_dqget
      [4483eb5] xfs: mark xfs_btree_check_lblock and xfs_btree_check_ptr static
      [e89fbb5] xfs: mark xlog_recover_check_summary STATIC
      [181fdfe] xfs: mark xlog_verify_dest_ptr STATIC

Colin Ian King (1):
      [c066411] xfs: remove redundant assignment to variable bit

Darrick J. Wong (4):
      [06b1132] xfs: remove inode log format typedef
      [e9e899a] xfs: move error injection tags into their own file
      [13791d3] xfs: scrub extended attribute leaf space
      [0dca060] xfs: scrub: avoid uninitialized return code

Dave Chinner (1):
      [5d0eda0] xfs: convert remaining xfs_sb_version_... checks to bool

Eryu Guan (1):
      [350976ae] xfs: truncate pagecache before writeback in xfs_setattr_size()


Code Diffstat:

 fs/xfs/Makefile                |    1 +
 fs/xfs/libxfs/xfs_ag_resv.c    |    1 +
 fs/xfs/libxfs/xfs_alloc.c      |    1 +
 fs/xfs/libxfs/xfs_bmap.c       |  506 ++++++++--------
 fs/xfs/libxfs/xfs_bmap.h       |   18 +-
 fs/xfs/libxfs/xfs_bmap_btree.c |  111 +---
 fs/xfs/libxfs/xfs_bmap_btree.h |   11 +-
 fs/xfs/libxfs/xfs_btree.c      |    5 +-
 fs/xfs/libxfs/xfs_dir2.c       |    1 +
 fs/xfs/libxfs/xfs_errortag.h   |  106 ++++
 fs/xfs/libxfs/xfs_format.h     |   26 +-
 fs/xfs/libxfs/xfs_ialloc.c     |    1 +
 fs/xfs/libxfs/xfs_iext_tree.c  | 1006 +++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.c  |    1 +
 fs/xfs/libxfs/xfs_inode_fork.c | 1275 ++--------------------------------------
 fs/xfs/libxfs/xfs_inode_fork.h |  136 ++---
 fs/xfs/libxfs/xfs_log_format.h |    4 +-
 fs/xfs/libxfs/xfs_refcount.c   |    1 +
 fs/xfs/libxfs/xfs_rmap.c       |    1 +
 fs/xfs/libxfs/xfs_rtbitmap.c   |    1 -
 fs/xfs/libxfs/xfs_types.h      |   16 +
 fs/xfs/scrub/attr.c            |  257 +++++++-
 fs/xfs/scrub/bmap.c            |   13 +-
 fs/xfs/scrub/btree.c           |    2 +-
 fs/xfs/scrub/dabtree.c         |    6 +-
 fs/xfs/scrub/dabtree.h         |    3 +-
 fs/xfs/scrub/dir.c             |   18 +-
 fs/xfs/scrub/scrub.c           |    2 +-
 fs/xfs/xfs.h                   |    1 -
 fs/xfs/xfs_bmap_util.c         |   27 +-
 fs/xfs/xfs_buf.c               |    1 +
 fs/xfs/xfs_dir2_readdir.c      |    8 +-
 fs/xfs/xfs_dquot.c             |   21 +-
 fs/xfs/xfs_error.c             |    3 +-
 fs/xfs/xfs_error.h             |   83 ---
 fs/xfs/xfs_inode.c             |   24 +-
 fs/xfs/xfs_inode_item.c        |    2 -
 fs/xfs/xfs_inode_item.h        |    2 +-
 fs/xfs/xfs_iomap.c             |   15 +-
 fs/xfs/xfs_iops.c              |   36 +-
 fs/xfs/xfs_linux.h             |   14 +-
 fs/xfs/xfs_log.c               |    3 +-
 fs/xfs/xfs_log_recover.c       |   12 +-
 fs/xfs/xfs_reflink.c           |   91 +--
 fs/xfs/xfs_trace.h             |   61 +-
 fs/xfs/xfs_trans_ail.c         |    1 +
 46 files changed, 1902 insertions(+), 2033 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_errortag.h
 create mode 100644 fs/xfs/libxfs/xfs_iext_tree.c
