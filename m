Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16920 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752633AbdF1DuW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2017 23:50:22 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v5S3oK0H028141
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2017 03:50:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v5S3oKvd017828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2017 03:50:20 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v5S3oKXD018984
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2017 03:50:20 GMT
Date: Tue, 27 Jun 2017 20:50:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 3b22408
Message-ID: <20170628035019.GC4492@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they are not in this update, please resubmit
them to linux-xfs@vger.kernel.org so they can be picked up in the next
update.

*** NOTE ***

I am well aware that Brian, Christoph, and Andreas have some fixes for
log wrapping problems and a rewrite of SEEK_HOLE/DATA to use iomap and
will spend the next day or two reviewing those patch sets; this is
merely an interim rollup of everything else that I've collected for 4.13
so far.

--D

The new head of the for-next branch is commit:

50e0bdb xfs: grab dquots without taking the ilock

New Commits:

Arnd Bergmann (1):
      [0cbe48c] xfs: avoid harmless gcc-7 warnings

Brian Foster (11):
      [7912e7f] xfs: push buffer of flush locked dquot to avoid quotacheck deadlock
      [ccdab3d] xfs: define bug_on_assert debug mode sysfs tunable
      [1040960e] xfs: define fatal assert build time tunable
      [7d2d565] xfs: separate shutdown from ticket reservation print helper
      [e2f2342] xfs: refactor xlog_cil_insert_items() to facilitate transaction dump
      [d4ca1d5] xfs: dump transaction usage details on log reservation overrun
      [79e641c] xfs: release bli from transaction properly on fs shutdown
      [3d4b4a3] xfs: remove bli from AIL before release on transaction abort
      [3977543] xfs: free uncommitted transactions during log recovery
      [3e88a00] xfs: replace log_badcrc_factor knob with error injection tag
      [cf2cb78] xfs: free cowblocks and retry on buffered write ENOSPC

Christoph Hellwig (1):
      [3398a40] xfs: remove XFS_HSIZE

Darrick J. Wong (23):
      [d205a7d] xfs: refactor dir2 leaf readahead shadow buffer cleverness
      [e1a4e37] xfs: try to avoid blowing out the transaction reservation when bunmaping a shared extent
      [5a4c733] xfs: optimize _btree_query_all
      [c8ce540] xfs: remove double-underscore integer types
      [38dee37] xfs: always compile the btree inorder check functions
      [2678809] xfs: export various function for the online scrubber
      [118bb47] xfs: plumb in needed functions for range querying of various btrees
      [e936945] xfs: export _inobt_btrec_to_irec and _ialloc_cluster_alignment for scrub
      [378f681] xfs: check if an inode is cached and allocated
      [92ff728] xfs: reflink find shared should take a transaction
      [ea7cdd7] xfs: separate function to check if inode shares extents
      [d29cb3e] xfs: make _bmap_count_blocks consistent wrt delalloc extent behavior
      [e7f5d5c] xfs: refactor the ifork block counting function
      [8e8877e] xfs: return the hash value of a leaf1 directory block
      [acb9553] xfs: pass along transaction context when reading directory block buffers
      [ad017f6] xfs: pass along transaction context when reading xattr block buffers
      [5da8f2f] xfs: allow reading of already-locked remote symbolic link
      [61d819e] xfs: don't allow bmap on rt files
      [31965ef] xfs: make errortag a per-mountpoint structure
      [c684010] xfs: expose errortag knobs via sysfs
      [9e24cfd] xfs: remove unneeded parameter from XFS_TEST_ERROR
      [f8c4725] xfs: convert drop_writes to use the errortag mechanism
      [50e0bdb] xfs: grab dquots without taking the ilock

Jan Kara (1):
      [8ba3587] xfs: Don't clear SGID when inheriting ACLs

Shan Hai (1):
      [f990fc5] xfs: remove lsn relevant fields from xfs_trans structure and its users

kbuild test robot (1):
      [244e3de] xfs: fix semicolon.cocci warnings


Code Diffstat:

 fs/xfs/Kconfig                     |  13 ++
 fs/xfs/libxfs/xfs_ag_resv.c        |   3 +-
 fs/xfs/libxfs/xfs_alloc.c          |   8 +-
 fs/xfs/libxfs/xfs_alloc.h          |   2 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |  26 ++-
 fs/xfs/libxfs/xfs_attr.c           |  26 ++-
 fs/xfs/libxfs/xfs_attr_remote.c    |  13 +-
 fs/xfs/libxfs/xfs_attr_sf.h        |  10 +-
 fs/xfs/libxfs/xfs_bit.h            |  24 +--
 fs/xfs/libxfs/xfs_bmap.c           |  51 ++++--
 fs/xfs/libxfs/xfs_bmap.h           |   2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |  34 +++-
 fs/xfs/libxfs/xfs_btree.c          |  52 +++---
 fs/xfs/libxfs/xfs_btree.h          |  33 ++--
 fs/xfs/libxfs/xfs_cksum.h          |  16 +-
 fs/xfs/libxfs/xfs_da_btree.c       |  12 +-
 fs/xfs/libxfs/xfs_da_btree.h       |   8 +-
 fs/xfs/libxfs/xfs_da_format.c      |  28 +--
 fs/xfs/libxfs/xfs_da_format.h      |  64 +++----
 fs/xfs/libxfs/xfs_dir2.c           |   3 +-
 fs/xfs/libxfs/xfs_dir2.h           |   8 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  14 +-
 fs/xfs/libxfs/xfs_dir2_node.c      |  10 +-
 fs/xfs/libxfs/xfs_dir2_priv.h      |  10 +-
 fs/xfs/libxfs/xfs_dir2_sf.c        |   2 +-
 fs/xfs/libxfs/xfs_format.h         | 112 ++++++------
 fs/xfs/libxfs/xfs_fs.h             |  16 +-
 fs/xfs/libxfs/xfs_ialloc.c         |  53 +++---
 fs/xfs/libxfs/xfs_ialloc.h         |   5 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  36 +++-
 fs/xfs/libxfs/xfs_inode_buf.c      |   7 +-
 fs/xfs/libxfs/xfs_inode_buf.h      |  31 ++--
 fs/xfs/libxfs/xfs_log_format.h     | 256 ++++++++++++++--------------
 fs/xfs/libxfs/xfs_log_recover.h    |   2 +-
 fs/xfs/libxfs/xfs_quota_defs.h     |   6 +-
 fs/xfs/libxfs/xfs_refcount.c       |  16 +-
 fs/xfs/libxfs/xfs_refcount.h       |  16 ++
 fs/xfs/libxfs/xfs_refcount_btree.c |  12 +-
 fs/xfs/libxfs/xfs_rmap.c           |  14 +-
 fs/xfs/libxfs/xfs_rmap.h           |  11 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  34 ++--
 fs/xfs/libxfs/xfs_rtbitmap.c       |   4 +-
 fs/xfs/libxfs/xfs_sb.c             |   4 +-
 fs/xfs/libxfs/xfs_types.h          |  46 ++---
 fs/xfs/xfs.h                       |   4 +
 fs/xfs/xfs_acl.c                   |   6 +-
 fs/xfs/xfs_acl.h                   |   1 +
 fs/xfs/xfs_aops.c                  |  11 +-
 fs/xfs/xfs_attr.h                  |   3 +
 fs/xfs/xfs_attr_list.c             |  61 ++++---
 fs/xfs/xfs_bmap_item.c             |  17 +-
 fs/xfs/xfs_bmap_util.c             | 164 ++++++++++--------
 fs/xfs/xfs_bmap_util.h             |   4 +
 fs/xfs/xfs_buf.c                   |  62 ++++++-
 fs/xfs/xfs_buf.h                   |   1 +
 fs/xfs/xfs_buf_item.c              |  21 ++-
 fs/xfs/xfs_dir2_readdir.c          | 341 +++++++++++--------------------------
 fs/xfs/xfs_discard.c               |   4 +-
 fs/xfs/xfs_dquot.c                 |  16 +-
 fs/xfs/xfs_error.c                 | 308 +++++++++++++++++++++++++--------
 fs/xfs/xfs_error.h                 |  44 +++--
 fs/xfs/xfs_file.c                  |   3 +-
 fs/xfs/xfs_fsops.c                 |  16 +-
 fs/xfs/xfs_fsops.h                 |   4 +-
 fs/xfs/xfs_globals.c               |   5 +
 fs/xfs/xfs_icache.c                |  52 +++++-
 fs/xfs/xfs_icache.h                |   4 +
 fs/xfs/xfs_inode.c                 |  17 +-
 fs/xfs/xfs_inode.h                 |   4 +-
 fs/xfs/xfs_ioctl.c                 |  27 ++-
 fs/xfs/xfs_ioctl.h                 |  10 +-
 fs/xfs/xfs_ioctl32.h               |   6 +-
 fs/xfs/xfs_iomap.c                 |   4 +-
 fs/xfs/xfs_iops.c                  |   4 +-
 fs/xfs/xfs_itable.c                |   2 +-
 fs/xfs/xfs_itable.h                |   2 +
 fs/xfs/xfs_linux.h                 |  20 +--
 fs/xfs/xfs_log.c                   |  87 +++++++---
 fs/xfs/xfs_log.h                   |   2 +-
 fs/xfs/xfs_log_cil.c               |  91 ++++++----
 fs/xfs/xfs_log_priv.h              |   3 +-
 fs/xfs/xfs_log_recover.c           |  49 ++++--
 fs/xfs/xfs_message.c               |   5 +-
 fs/xfs/xfs_mount.c                 |  26 +--
 fs/xfs/xfs_mount.h                 |  60 +++----
 fs/xfs/xfs_qm.c                    |  28 ++-
 fs/xfs/xfs_qm_bhv.c                |   2 +-
 fs/xfs/xfs_reflink.c               | 101 ++++++-----
 fs/xfs/xfs_reflink.h               |   8 +-
 fs/xfs/xfs_rtalloc.c               |   8 +-
 fs/xfs/xfs_rtalloc.h               |   3 +
 fs/xfs/xfs_stats.c                 |   8 +-
 fs/xfs/xfs_stats.h                 | 190 ++++++++++-----------
 fs/xfs/xfs_super.c                 |  26 +--
 fs/xfs/xfs_symlink.c               |   6 +-
 fs/xfs/xfs_symlink.h               |   1 +
 fs/xfs/xfs_sysctl.h                |   1 +
 fs/xfs/xfs_sysfs.c                 |  81 ++-------
 fs/xfs/xfs_trace.h                 |  40 ++---
 fs/xfs/xfs_trans.h                 |   8 +-
 fs/xfs/xfs_trans_bmap.c            |  11 +-
 fs/xfs/xfs_trans_buf.c             |  21 ++-
 fs/xfs/xfs_trans_rmap.c            |   2 +-
 103 files changed, 1833 insertions(+), 1436 deletions(-)
