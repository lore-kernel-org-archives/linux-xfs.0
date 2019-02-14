Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50254 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387484AbfBNSqc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 13:46:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1EIclYC005216
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 18:46:31 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2qhrekssmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 18:46:30 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1EIkT53011840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 18:46:30 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1EIkTls007594
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 18:46:29 GMT
Date: Thu, 14 Feb 2019 10:46:28 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 95489fc2945b
Message-ID: <20190214184628.GJ32253@magnolia>
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

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

I am still in the process of reviewing Christoph's "small fixes and
optimizations for delalloc and reflink" series as well as the series I
sent earlier in the week to fix various unlinked inode handling errors,
so there will be another for-next update before the merge window opens.

The new head of the for-next branch is commit:

670105de15cd xfs: compile time offset checks for common v4/v5 metadata

New Commits:

Brian Foster (15):
      [9f9bc034b849] xfs: update fork seq counter on data fork changes
      [d9252d526ba6] xfs: validate writeback mapping using data fork seq counter
      [3b3508980730] xfs: remove superfluous writeback mapping eof trimming
      [627209fbcc2f] xfs: create delalloc bmapi wrapper for full extent allocation
      [c2b3164320b5] xfs: use the latest extent at writeback delalloc conversion time
      [75d023031499] xfs: clarify documentation for the function to reverify buffers
      [e34d3e74eb8f] xfs: always check magic values in on-disk byte order
      [01e68f40bf78] xfs: create a separate finobt verifier
      [8473fee340e3] xfs: distinguish between inobt and finobt magic values
      [27df4f5045fc] xfs: split up allocation btree verifier
      [b8f89801664f] xfs: distinguish between bnobt and cntbt magic values
      [09f420197d7c] xfs: use verifier magic field in dir2 leaf verifiers
      [39708c20ab51] xfs: miscellaneous verifier magic value fixups
      [8764f98351fa] xfs: factor xfs_da3_blkinfo verification into common helper
      [670105de15cd] xfs: compile time offset checks for common v4/v5 metadata

Darrick J. Wong (24):
      [435dcf0787fd] xfs: never try to scrub more than 64 inodes per inobt record
      [c050fdfeb575] xfs: check the ir_startino alignment directly
      [22234c62f98b] xfs: check inobt record alignment on big block filesystems
      [a1954242facb] xfs: hoist inode cluster checks out of loop
      [b9454fe056bd] xfs: clean up the inode cluster checking in the inobt scrub
      [4539b8a78078] xfs: scrub big block inode btrees correctly
      [f9e63342b858] xfs: consolidate scrub dinode mapping code into a single function
      [3258cb208cab] xfs: abort xattr scrub if fatal signals are pending
      [f8c1d7023e25] xfs: scrub should flag dir/attr offsets that aren't mappable with xfs_dablk_t
      [87c9607df2ff] xfs: fix off-by-one error in rtbitmap cross-reference
      [e5d7d51b340a] xfs: check directory name validity
      [654805367d98] xfs: check attribute name validity
      [5837f62592ef] xfs: clean up iunlink functions
      [7d36c19538d3] xfs: add xfs_verify_agino_or_null helper
      [9a4a5118644e] xfs: refactor AGI unlinked bucket updates
      [86bfd3750fb3] xfs: strengthen AGI unlinked inode bucket pointer checks
      [f2fc16a3d7c1] xfs: refactor inode unlinked pointer update functions
      [23ffa52cc792] xfs: refactor unlinked list search and mapping to a separate function
      [b1d2a068ea63] xfs: refactor inode update in iunlink_remove
      [4664c66c91a1] xfs: add tracepoints for high level iunlink operations
      [9b2471797942] xfs: cache unlinked pointers in an rhashtable
      [2bfe7069f71e] xfs: add inode magic to inode verifier
      [4260baac629e] xfs: add magic numbers to dquot buffer ops
      [9228d751ebf9] xfs: use buf ops magic to detect btree block type

Marco Benatto (1):
      [d519da41e2b7] xfs: Introduce XFS_PTAG_VERIFIER_ERROR panic mask

YueHaibing (1):
      [e88db81645d3] xfs: remove duplicated xfs_defer.h


Code Diffstat:

 Documentation/filesystems/xfs.txt  |   3 +-
 fs/xfs/libxfs/xfs_ag.c             |   6 +-
 fs/xfs/libxfs/xfs_alloc.c          |  12 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |  74 ++--
 fs/xfs/libxfs/xfs_attr.c           |  17 +
 fs/xfs/libxfs/xfs_attr.h           |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |  21 +-
 fs/xfs/libxfs/xfs_attr_remote.c    |   8 +-
 fs/xfs/libxfs/xfs_bmap.c           |  68 +++-
 fs/xfs/libxfs/xfs_bmap.h           |   3 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |  13 +-
 fs/xfs/libxfs/xfs_da_btree.c       |  49 ++-
 fs/xfs/libxfs/xfs_da_format.h      |   3 +
 fs/xfs/libxfs/xfs_dir2.c           |  17 +
 fs/xfs/libxfs/xfs_dir2.h           |   1 +
 fs/xfs/libxfs/xfs_dir2_block.c     |  10 +-
 fs/xfs/libxfs/xfs_dir2_data.c      |  12 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c      | 100 ++---
 fs/xfs/libxfs/xfs_dir2_node.c      |  10 +-
 fs/xfs/libxfs/xfs_dquot_buf.c      |   4 +
 fs/xfs/libxfs/xfs_errortag.h       |   4 +-
 fs/xfs/libxfs/xfs_ialloc.c         |   3 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  25 +-
 fs/xfs/libxfs/xfs_iext_tree.c      |  13 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |  11 +-
 fs/xfs/libxfs/xfs_inode_fork.h     |   2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   3 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |   3 +-
 fs/xfs/libxfs/xfs_sb.c             |   5 +-
 fs/xfs/libxfs/xfs_shared.h         |   4 +-
 fs/xfs/libxfs/xfs_symlink_remote.c |   3 +-
 fs/xfs/libxfs/xfs_types.c          |  24 ++
 fs/xfs/libxfs/xfs_types.h          |   3 +
 fs/xfs/scrub/agheader.c            |   8 +-
 fs/xfs/scrub/agheader_repair.c     |  12 +-
 fs/xfs/scrub/attr.c                |  11 +
 fs/xfs/scrub/bmap.c                |  27 ++
 fs/xfs/scrub/dir.c                 |   6 +
 fs/xfs/scrub/ialloc.c              | 332 +++++++++++-----
 fs/xfs/scrub/repair.c              |   3 +-
 fs/xfs/scrub/repair.h              |   3 -
 fs/xfs/scrub/rtbitmap.c            |   5 +-
 fs/xfs/scrub/trace.h               |  45 +++
 fs/xfs/xfs_aops.c                  |  73 ++--
 fs/xfs/xfs_buf.c                   |  54 ++-
 fs/xfs/xfs_buf.h                   |   4 +-
 fs/xfs/xfs_error.c                 |   6 +-
 fs/xfs/xfs_error.h                 |   1 +
 fs/xfs/xfs_globals.c               |   2 +-
 fs/xfs/xfs_inode.c                 | 751 +++++++++++++++++++++++++++----------
 fs/xfs/xfs_inode.h                 |   3 +
 fs/xfs/xfs_iomap.c                 | 171 +++------
 fs/xfs/xfs_log_recover.c           |  14 +-
 fs/xfs/xfs_mount.c                 |   5 +
 fs/xfs/xfs_mount.h                 |   7 +
 fs/xfs/xfs_ondisk.h                |  21 ++
 fs/xfs/xfs_trace.h                 |  78 ++++
 fs/xfs/xfs_trans_bmap.c            |   1 -
 fs/xfs/xfs_trans_buf.c             |   2 +-
 fs/xfs/xfs_trans_extfree.c         |   1 -
 fs/xfs/xfs_trans_refcount.c        |   1 -
 fs/xfs/xfs_trans_rmap.c            |   1 -
 62 files changed, 1474 insertions(+), 710 deletions(-)
