Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEGPqh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 May 2019 11:46:37 -0400
Date: Tue, 7 May 2019 08:46:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: new features for 5.2
Message-ID: <20190507154635.GT5207@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net, hch@lst.de

Hi Linus,

Here's a big pile of new stuff for XFS for 5.2.  XFS has grown the
ability to report metadata health status to userspace after online fsck
checks the filesystem.  The online metadata checking code is (I really
hope) feature complete with the addition of checks for the global fs
counters, though it'll remain EXPERIMENTAL for now.

There are also fixes for thundering herds of writeback completions and
some other deadlocks, fixes for theoretical integer overflow attacks on
space accounting, and removal of the long-defunct 'mntpt' option which
was deprecated in the mid-2000s and (it turns out) totally broken since
2011 (and nobody complained...).

The branch merges cleanly against this morning's HEAD (as well as HEAD +
iomap-5.2-merge) and survived an overnight run of xfstests.  Let me know
if you run into anything weird along the way.  FYI, I will also be out
for about 10 days starting Thursday, so if anything urgent comes up
during that time, please don't hesitate to ask Dave or Eric.

--D

The following changes since commit dc4060a5dc2557e6b5aa813bf5b73677299d62d2:

  Linux 5.1-rc5 (2019-04-14 15:17:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.2-merge-4

for you to fetch changes up to 910832697cf85536c7fe26edb8bc6f830c4b9bb6:

  xfs: change some error-less functions to void types (2019-05-01 20:26:30 -0700)

----------------------------------------------------------------
Changes for Linux 5.2:

- Fix some more buffer deadlocks when performing an unmount after a hard
  shutdown.
- Fix some minor space accounting issues.
- Fix some use after free problems.
- Make the (undocumented) FITRIM behavior consistent with other filesystems.
- Embiggen the xfs geometry ioctl's data structure.
- Introduce a new AG geometry ioctl.
- Introduce a new online health reporting infrastructure and ioctl for
  userspace to query a filesystem's health status.
- Enhance online scrub and repair to update the health reports.
- Reduce thundering herd problems when writeback io completes.
- Fix some transaction reservation type errors.
- Fix integer overflow problems with delayed alloc reservation counters.
- Fix some problems where we would exit to userspace without unlocking.
- Fix inconsistent behavior when finishing deferred ops fails.
- Strengthen scrub to check incore data against ondisk metadata.
- Remove long-broken mntpt mount option.
- Add an online scrub function for the filesystem summary counters,
  which should make online metadata scrub more or less feature complete
  for now.
- Various cleanups.

----------------------------------------------------------------
Brian Foster (7):
      xfs: fix use after free in buf log item unlock assert
      xfs: wake commit waiters on CIL abort before log item abort
      xfs: shutdown after buf release in iflush cluster abort path
      xfs: don't account extra agfl blocks as available
      xfs: make tr_growdata a permanent transaction
      xfs: assert that we don't enter agfl freeing with a non-permanent transaction
      xfs: add missing error check in xfs_prepare_shift()

Christoph Hellwig (1):
      xfs: don't parse the mtpt mount option

Darrick J. Wong (27):
      xfs: track metadata health status
      xfs: replace the BAD_SUMMARY mount flag with the equivalent health code
      xfs: clear BAD_SUMMARY if unmounting an unhealthy filesystem
      xfs: add a new ioctl to describe allocation group geometry
      xfs: report fs and rt health via geometry structure
      xfs: report AG health via AG geometry ioctl
      xfs: report inode health via bulkstat
      xfs: refactor scrub context initialization
      xfs: collapse scrub bool state flags into a single unsigned int
      xfs: hoist the already_fixed variable to the scrub context
      xfs: scrub/repair should update filesystem metadata health
      xfs: scrub should only cross-reference with healthy btrees
      xfs: implement per-inode writeback completion queues
      xfs: remove unused m_data_workqueue
      xfs: merge adjacent io completions of the same type
      xfs: abort unaligned nowait directio early
      xfs: widen quota block counters to 64-bit integers
      xfs: widen inode delalloc block counter to 64-bits
      xfs: kill the xfs_dqtrx_t typedef
      xfs: unlock inode when xfs_ioctl_setattr_get_trans can't get transaction
      xfs: fix broken bhold behavior in xrep_roll_ag_trans
      xfs: track delayed allocation reservations across the filesystem
      xfs: rename the speculative block allocation reclaim toggle functions
      xfs: allow scrubbers to pause background reclaim
      xfs: scrub should check incore counters against ondisk headers
      xfs: always rejoin held resources during defer roll
      xfs: add online scrub for superblock counters

Dave Chinner (1):
      xfs: bump XFS_IOC_FSGEOMETRY to v5 structures

Eric Sandeen (1):
      xfs: change some error-less functions to void types

Wang Shilong (1):
      xfs,fstrim: fix to return correct minlen

 fs/xfs/Makefile                |   3 +
 fs/xfs/libxfs/xfs_ag.c         |  54 ++++++
 fs/xfs/libxfs/xfs_ag.h         |   2 +
 fs/xfs/libxfs/xfs_alloc.c      |  13 +-
 fs/xfs/libxfs/xfs_attr.c       |  35 ++--
 fs/xfs/libxfs/xfs_attr.h       |   2 +-
 fs/xfs/libxfs/xfs_bmap.c       |  17 +-
 fs/xfs/libxfs/xfs_defer.c      |  14 +-
 fs/xfs/libxfs/xfs_dquot_buf.c  |   4 +-
 fs/xfs/libxfs/xfs_fs.h         | 139 +++++++++++----
 fs/xfs/libxfs/xfs_health.h     | 190 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_quota_defs.h |   2 +-
 fs/xfs/libxfs/xfs_sb.c         |  18 +-
 fs/xfs/libxfs/xfs_sb.h         |   2 +-
 fs/xfs/libxfs/xfs_trans_resv.c |   6 +-
 fs/xfs/libxfs/xfs_types.c      |   2 +-
 fs/xfs/libxfs/xfs_types.h      |   2 +
 fs/xfs/scrub/agheader.c        |  20 +++
 fs/xfs/scrub/common.c          |  47 ++++-
 fs/xfs/scrub/common.h          |   4 +
 fs/xfs/scrub/fscounters.c      | 366 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.c          | 237 +++++++++++++++++++++++++
 fs/xfs/scrub/health.h          |  14 ++
 fs/xfs/scrub/ialloc.c          |   4 +-
 fs/xfs/scrub/parent.c          |   2 +-
 fs/xfs/scrub/quota.c           |   2 +-
 fs/xfs/scrub/repair.c          |  34 ++--
 fs/xfs/scrub/repair.h          |   5 +-
 fs/xfs/scrub/scrub.c           |  49 ++++--
 fs/xfs/scrub/scrub.h           |  27 ++-
 fs/xfs/scrub/trace.h           |  63 ++++++-
 fs/xfs/xfs_aops.c              | 135 ++++++++++++--
 fs/xfs/xfs_aops.h              |   1 -
 fs/xfs/xfs_bmap_util.c         |   2 +
 fs/xfs/xfs_buf_item.c          |   4 +-
 fs/xfs/xfs_discard.c           |   3 +-
 fs/xfs/xfs_dquot.c             |  17 +-
 fs/xfs/xfs_file.c              |   6 +-
 fs/xfs/xfs_fsops.c             |   3 +-
 fs/xfs/xfs_fsops.h             |   2 +-
 fs/xfs/xfs_health.c            | 392 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c            |  11 +-
 fs/xfs/xfs_icache.h            |   4 +-
 fs/xfs/xfs_inode.c             |  31 ++--
 fs/xfs/xfs_inode.h             |  17 +-
 fs/xfs/xfs_ioctl.c             |  62 ++++---
 fs/xfs/xfs_ioctl32.c           |   9 +-
 fs/xfs/xfs_itable.c            |   2 +
 fs/xfs/xfs_log.c               |   3 +-
 fs/xfs/xfs_log_cil.c           |  21 ++-
 fs/xfs/xfs_log_recover.c       |  10 +-
 fs/xfs/xfs_mount.c             |  35 +++-
 fs/xfs/xfs_mount.h             |  32 +++-
 fs/xfs/xfs_qm.c                |   3 +-
 fs/xfs/xfs_qm.h                |   8 +-
 fs/xfs/xfs_quota.h             |  37 ++--
 fs/xfs/xfs_super.c             |  41 ++---
 fs/xfs/xfs_trace.h             |  76 ++++++++
 fs/xfs/xfs_trans_dquot.c       |  52 +++---
 59 files changed, 2085 insertions(+), 313 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_health.h
 create mode 100644 fs/xfs/scrub/fscounters.c
 create mode 100644 fs/xfs/scrub/health.c
 create mode 100644 fs/xfs/scrub/health.h
 create mode 100644 fs/xfs/xfs_health.c
