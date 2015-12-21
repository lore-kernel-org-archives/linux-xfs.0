Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7D8297F37
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 17:59:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE9E7AC003
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 15:59:40 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	cG3cLH0uqvCjN18c for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 15:59:37 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aBAMN-00014U-HF
	for xfs@oss.sgi.com; Tue, 22 Dec 2015 10:59:23 +1100
Date: Tue, 22 Dec 2015 10:59:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to dbca016
Message-ID: <20151221235923.GY26718@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi folks,

The xfsprogs repository at

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

just been updated. Nothing huge here - a small amount of new
functionality (log format, sparse inode support in check) and
various fixes and cleanups.

The new head of the master branch is commit:

dbca016 libxfs: refactor short btree block verification

New Commits:

Brian Foster (4):
      [011207f] logprint: use correct ext. header count for unaligned size
      [20fbd45] libxfs: format the log with valid log record headers
      [571a78a] libxfs: conditionalize log format record size optimization
      [c7a8ea4] db: add the logformat command

Darrick J. Wong (7):
      [bb2f98b] xfs_db: make check work for sparse inodes
      [ab001d6] xfs_io: allow zero-length reflink/dedupe commands
      [2703398] repair: request inode buffers sized to fit one inode cluster
      [af2e7c6] libxfs: reorder xfs_bmap_add_free args
      [36e8786] libxfs: use a convenience variable instead of open-coding the fork
      [9fccb9f] libxfs: pack the agfl header structure so XFS_AGFL_SIZE is correct
      [dbca016] libxfs: refactor short btree block verification

Eric Sandeen (4):
      [98dd72d] mkfs: get sector size from host fs d_miniosz when mkfs'ing file
      [270dae6] xfs_io: document zero and help commands in manpage
      [a265445] xfs_quota: push id/name printing down into report_mount()
      [85dcd9a] xfs_quota: allow name lookup when reporting from ID range

Jan Tulak (1):
      [f814911] xfsprogs: Remove trailing blanks on various places

Vivek Trivedi (4):
      [5d3a5d8] xfs_io: fix a memory leak in imap_f
      [e59b15c] libxlog: fix integer overflow in xlog_find_verify_cycle
      [70fe4df] mkfs: fix unintentional integer overflow
      [5e2918c] xfs_db: remove unnessary checks in process_leaf_node_dir_v2_free


Code Diffstat:

 copy/xfs_copy.c           |   6 +-
 copy/xfs_copy.h           |   1 -
 db/Makefile               |   4 +-
 db/bmap.c                 |   2 +-
 db/check.c                | 327 +++++++++++++++++++++++++++++++++-------------
 db/command.c              |   2 +
 db/dir2sf.c               |   1 -
 db/frag.c                 |  10 +-
 db/inode.c                |   4 +-
 db/input.c                |   4 +-
 db/logformat.c            | 149 +++++++++++++++++++++
 db/logformat.h            |  19 +++
 db/metadump.c             |   2 +-
 db/sb.c                   |   4 +-
 db/symlink.c              |   1 -
 include/atomic.h          |   1 -
 include/builddefs.in      |   2 +-
 include/install-sh        |  16 +--
 include/kmem.h            |   2 +-
 include/libxfs.h          |   2 +-
 include/libxlog.h         |   4 +-
 include/xfs_mount.h       |   1 -
 io/fiemap.c               |   2 +-
 io/imap.c                 |   6 +-
 io/mmap.c                 |   2 +-
 io/parent.c               |   2 +-
 io/reflink.c              |  24 ++--
 libhandle/handle.c        |   2 +-
 libxcmd/paths.c           |   3 +-
 libxfs/Makefile           |   1 -
 libxfs/darwin.c           |   1 -
 libxfs/init.c             |   2 +-
 libxfs/kmem.c             |   3 +-
 libxfs/linux.c            |   8 +-
 libxfs/rdwr.c             |  89 ++++++++++---
 libxfs/util.c             |   4 +-
 libxfs/xfs_alloc_btree.c  |  30 +----
 libxfs/xfs_attr_leaf.c    |   2 +-
 libxfs/xfs_bmap.c         |  35 ++---
 libxfs/xfs_bmap.h         |   4 +-
 libxfs/xfs_bmap_btree.c   |   2 +-
 libxfs/xfs_btree.c        |  58 ++++++++
 libxfs/xfs_btree.h        |   3 +
 libxfs/xfs_dquot_buf.c    |   1 -
 libxfs/xfs_format.h       |   4 +-
 libxfs/xfs_ialloc.c       |  10 +-
 libxfs/xfs_ialloc_btree.c |  24 +---
 libxfs/xfs_rtbitmap.c     |   1 -
 libxfs/xfs_trans_resv.c   |   2 +-
 libxlog/xfs_log_recover.c |   2 +-
 logprint/log_misc.c       |   2 +
 logprint/log_print_all.c  |   8 +-
 m4/manual_format.m4       |   2 +-
 m4/package_aiodev.m4      |   1 -
 m4/package_libcdev.m4     |  14 +-
 man/man8/xfs_io.8         |  10 ++
 man/man8/xfs_quota.8      |   8 +-
 mdrestore/xfs_mdrestore.c |   2 +-
 mkfs/xfs_mkfs.c           |  11 +-
 quota/edit.c              |   8 +-
 quota/quota.h             |   1 -
 quota/report.c            |  67 ++++++----
 quota/state.c             |   6 +-
 repair/agheader.c         |   4 +-
 repair/attr_repair.c      |  32 ++---
 repair/da_util.c          |   2 +-
 repair/dinode.c           |  15 ++-
 repair/phase2.c           |   2 +-
 repair/phase5.c           |   2 +-
 repair/phase6.c           |   2 +-
 repair/prefetch.c         |   2 +-
 repair/protos.h           |   1 -
 repair/scan.c             |   1 -
 repair/versions.c         |   2 +-
 repair/xfs_repair.c       |   2 +-
 tools/libxfs-apply        |   2 +-
 76 files changed, 755 insertions(+), 345 deletions(-)
 create mode 100644 db/logformat.c
 create mode 100644 db/logformat.h
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
