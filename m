Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37198 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbeAHUAE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 15:00:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.21) with SMTP id w08JvelZ190823
        for <linux-xfs@vger.kernel.org>; Mon, 8 Jan 2018 20:00:04 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fcesmg4xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jan 2018 20:00:04 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w08K03OB028536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 8 Jan 2018 20:00:03 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w08K02Mt031473
        for <linux-xfs@vger.kernel.org>; Mon, 8 Jan 2018 20:00:03 GMT
Date: Mon, 8 Jan 2018 12:00:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: xfs-4.16-merge updated to ac503a4
Message-ID: <20180108200000.GU5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The xfs-4.16-merge branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

NOTE: Dave is midway through reviewing the patch series "xfs: online
scrub xref support", so I have not yet merged any of that series to
for-next.  If the review completes in time for the merge window then I
plan to merge it.

Thanks everybody for your review work in this release!

The new head of the xfs-4.16-merge branch is commit:

ac503a4 xfs: refactor the geometry structure filling function

New Commits:

Brian Foster (7):
      [2c8f626] xfs: print transaction log reservation on overrun
      [a6f4859] xfs: include inobt buffers in ifree tx log reservation
      [e8341d9] xfs: fix up agi unlinked list reservations
      [a606ebd] xfs: truncate transaction does not modify the inobt
      [f03c78f] xfs: include an allocfree res for inobt modifications
      [57af33e] xfs: refactor inode chunk alloc/free tx reservation
      [c017cb5] xfs: eliminate duplicate icreate tx reservation functions

Darrick J. Wong (29):
      [29c1c12] xfs: scrub inode nsec fields
      [5a9d929] iomap: report collisions between directio and buffered writes to userspace
      [5a0f433] xfs: ignore agfl read errors when not scrubbing agfl
      [e5b37fa] xfs: catch a few more error codes when scrubbing secondary sb
      [2b9e9b5] xfs: xfs_scrub_bmap should use for_each_xfs_iext
      [1ad1205] xfs: always grab transaction when scrubbing inode
      [d658e72] xfs: distinguish between corrupt inode and invalid inum in xfs_scrub_get_inode
      [59f6fec] xfs: remove XFS_FSB_SANITY_CHECK
      [8368a60] xfs: refactor long-format btree header verification routines
      [e1e55aa] xfs: refactor short form btree pointer verification
      [9101d37] xfs: remove XFS_WANT_CORRUPTED_RETURN from dir3 data verifiers
      [31ca03c] xfs: refactor xfs_verifier_error and xfs_buf_ioerror
      [a6a781a] xfs: have buffer verifier functions report failing address
      [bc1a09b] xfs: refactor verifier callers to print address of failing check
      [50aa90e] xfs: verify dinode header first
      [71493b8] xfs: move inode fork verifiers to xfs_dinode_verify
      [1e1bbd8] xfs: create structure verifier function for shortform xattrs
      [0795e00] xfs: create structure verifier function for short form symlinks
      [dc042c2] xfs: refactor short form directory structure verifier function
      [9cfb9b4] xfs: provide a centralized method for verifying inline fork data
      [8ba92d4] xfs: fail out of xfs_attr3_leaf_lookup_int if it looks corrupt
      [b557259] xfs: create a new buf_ops pointer to verify structure metadata
      [eeea798] xfs: separate dquot repair into a separate function
      [eebf3ca] xfs: standardize quota verification function outputs
      [d9418ed] xfs: teach error reporting functions to take xfs_failaddr_t
      [9c712a1] xfs: dump the first 128 bytes of any corrupt buffer
      [b872af2] xfs: trace log reservations at mount time
      [c368ebc] xfs: hoist xfs_fs_geometry to libxfs
      [ac503a4] xfs: refactor the geometry structure filling function

Eric Sandeen (3):
      [bfb3e9b] xfs: explicitly initialize meta_scrub_ops array by type
      [0a085dd] xfs: factor out scrub input checking
      [8e63083] xfs: move all scrub input checking to xfs_scrub_validate

Richard Wareing (1):
      [a015831] xfs: Show realtime device stats on statfs calls if realtime flags set


Code Diffstat:

 fs/direct-io.c                     |  24 ++++-
 fs/iomap.c                         |  12 ++-
 fs/xfs/libxfs/xfs_alloc.c          |  95 ++++++++++--------
 fs/xfs/libxfs/xfs_alloc_btree.c    |  47 +++++----
 fs/xfs/libxfs/xfs_attr_leaf.c      | 120 ++++++++++++++++++----
 fs/xfs/libxfs/xfs_attr_leaf.h      |   1 +
 fs/xfs/libxfs/xfs_attr_remote.c    | 104 ++++++++++++-------
 fs/xfs/libxfs/xfs_bmap.c           |   4 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |  58 +++++------
 fs/xfs/libxfs/xfs_btree.c          |  83 ++++++++++++----
 fs/xfs/libxfs/xfs_btree.h          |  14 +--
 fs/xfs/libxfs/xfs_da_btree.c       |  68 +++++++++----
 fs/xfs/libxfs/xfs_da_format.h      |   6 ++
 fs/xfs/libxfs/xfs_dir2.c           |   5 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |  37 +++----
 fs/xfs/libxfs/xfs_dir2_data.c      | 155 +++++++++++++++++------------
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  87 ++++++++++------
 fs/xfs/libxfs/xfs_dir2_node.c      |  85 +++++++++-------
 fs/xfs/libxfs/xfs_dir2_priv.h      |  12 ++-
 fs/xfs/libxfs/xfs_dir2_sf.c        |  26 ++---
 fs/xfs/libxfs/xfs_dquot_buf.c      | 174 ++++++++++++++------------------
 fs/xfs/libxfs/xfs_ialloc.c         |  40 ++++----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  36 ++++---
 fs/xfs/libxfs/xfs_inode_buf.c      | 126 +++++++++++++++++------
 fs/xfs/libxfs/xfs_inode_buf.h      |   4 +-
 fs/xfs/libxfs/xfs_inode_fork.c     | 151 ++++++++--------------------
 fs/xfs/libxfs/xfs_inode_fork.h     |  14 +++
 fs/xfs/libxfs/xfs_log_rlimit.c     |   2 +-
 fs/xfs/libxfs/xfs_quota_defs.h     |   9 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  40 +++++---
 fs/xfs/libxfs/xfs_rmap_btree.c     |  40 +++++---
 fs/xfs/libxfs/xfs_sb.c             |  97 ++++++++++++++++--
 fs/xfs/libxfs/xfs_sb.h             |   4 +
 fs/xfs/libxfs/xfs_shared.h         |   4 +
 fs/xfs/libxfs/xfs_symlink_remote.c |  73 ++++++++++----
 fs/xfs/libxfs/xfs_trans_resv.c     | 199 +++++++++++++++++--------------------
 fs/xfs/scrub/agheader.c            |  33 +++---
 fs/xfs/scrub/bmap.c                |   5 +-
 fs/xfs/scrub/common.c              |  44 +++++---
 fs/xfs/scrub/common.h              |   2 -
 fs/xfs/scrub/inode.c               |  14 ++-
 fs/xfs/scrub/quota.c               |   7 --
 fs/xfs/scrub/rtbitmap.c            |  12 +--
 fs/xfs/scrub/scrub.c               | 190 +++++++++++++++++++++++------------
 fs/xfs/scrub/scrub.h               |  11 ++
 fs/xfs/xfs_buf.c                   |  10 +-
 fs/xfs/xfs_buf.h                   |   5 +-
 fs/xfs/xfs_dquot.c                 |  62 +-----------
 fs/xfs/xfs_error.c                 |  27 +++--
 fs/xfs/xfs_error.h                 |  11 +-
 fs/xfs/xfs_fsops.c                 |  77 --------------
 fs/xfs/xfs_fsops.h                 |   1 -
 fs/xfs/xfs_icache.c                |   5 +
 fs/xfs/xfs_inode.c                 |  34 ++++++-
 fs/xfs/xfs_inode.h                 |   2 +
 fs/xfs/xfs_ioctl.c                 |   5 +-
 fs/xfs/xfs_ioctl32.c               |   3 +-
 fs/xfs/xfs_linux.h                 |   2 +
 fs/xfs/xfs_log.c                   |   4 +-
 fs/xfs/xfs_log_recover.c           |  28 ++++--
 fs/xfs/xfs_qm.c                    |  29 +++---
 fs/xfs/xfs_super.c                 |   8 ++
 fs/xfs/xfs_trace.h                 |  32 +++++-
 fs/xfs/xfs_trans.c                 |  22 ++++
 include/linux/fs.h                 |   1 +
 65 files changed, 1624 insertions(+), 1118 deletions(-)
