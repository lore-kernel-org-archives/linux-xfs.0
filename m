Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7554729DFC
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D9ED4AC028
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:19:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cJPJmXFHob7aDavn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:19:57 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id DFF9FB4C4A
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 18:19:56 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92IJu3i023974
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 14:19:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 00/18] xfsprogs: format the log correctly on v5 supers
Date: Fri,  2 Oct 2015 14:19:37 -0400
Message-Id: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,

Here is v3 of the userspace v5 log formatting fixes. This version is based on
the latest variant of the kernel metadata LSN verification patch:

  http://oss.sgi.com/pipermail/xfs/2015-September/043846.html

The updates are relatively minor with the exception of added support for
xfs_copy. Patches 1-6 update libxfs/libxlog to support max. metadata LSN
tracking, cycle-specific log formatting and otherwise prepare for subsequent
fixes. Patches 7-11 update xfs_repair to no longer zero the log by default and
format v5 logs correctly based on the maximum seen metadata LSN. Patches 12-13
update the xfs_db uuid and metadump commands to bump the cycle number when
formatting v5 logs. Patch 14 is an independent bug fix to enable xfs_copy to
detect and warn about a dirty log in the source filesystem. Patches 15-18
refactor and fix xfs_copy to also bump the cycle number when formatting v5 logs.

Thoughts, reviews, flames appreciated.

Brian

v3:
- Rebased on latest LSN validation kernel patch.
- Added comment for dummy log clearing tid.
- Seed max lsn value from initial log state in xfs_repair.
- Added xfs_copy fixes (non-dup. dirty log fix + v5 log format fixes).
v2: http://oss.sgi.com/pipermail/xfs/2015-September/043630.html
- Rebase to latest kernel variant of invalid metadata LSN detection.
- Added support for xfs_db's uuid command and xfs_metadump.
v1: http://oss.sgi.com/pipermail/xfs/2015-August/043397.html

Brian Foster (18):
  libxfs: validate metadata LSNs against log on v5 superblocks
  libxfs: track largest metadata LSN in use via verifiers
  libxfs: don't hardcode cycle 1 into unmount op header
  libxfs: pass lsn param to log clear and record header logging helpers
  libxfs: add ability to clear log to arbitrary log cycle
  libxlog: pull struct xlog out of xlog_is_dirty()
  xfs_repair: track log state throughout all recovery phases
  xfs_repair: process the log in no_modify mode
  xfs_repair: format the log with forward cycle number on v5 supers
  xfs_repair: don't clear the log by default
  xfs_repair: seed the max lsn from log state in phase 2
  xfs_db: do not reset current lsn from uuid command on v5 supers
  db/metadump: bump lsn when log is cleared on v5 supers
  xfs_copy: check for dirty log on non-duplicate copies
  xfs_copy: genericize write helper to facilitate separate log buf
  xfs_copy: store data buf alignment in buf data structure
  xfs_copy: refactor log format code into new helper
  xfs_copy: format v5 sb logs correctly

 Makefile                    |   2 +-
 copy/Makefile               |   4 +-
 copy/xfs_copy.c             | 196 +++++++++++++++++++++++++++++++++++---------
 copy/xfs_copy.h             |   1 +
 db/init.c                   |  25 +++---
 db/metadump.c               |  21 ++++-
 db/sb.c                     |  18 +++-
 include/libxfs.h            |  13 ++-
 include/libxlog.h           |   3 +-
 include/xfs_mount.h         |   6 ++
 libxfs/libxfs_priv.h        |   2 +
 libxfs/rdwr.c               | 160 ++++++++++++++++++++++++++++++------
 libxfs/util.c               |  41 +++++++++
 libxfs/xfs_alloc.c          |  12 ++-
 libxfs/xfs_attr_leaf.c      |   2 +
 libxfs/xfs_btree.c          |  16 +++-
 libxfs/xfs_da_btree.c       |   3 +
 libxfs/xfs_dir2_block.c     |   2 +
 libxfs/xfs_dir2_data.c      |   2 +
 libxfs/xfs_dir2_leaf.c      |   2 +
 libxfs/xfs_dir2_node.c      |   2 +
 libxfs/xfs_ialloc.c         |   9 +-
 libxfs/xfs_sb.c             |   9 ++
 libxfs/xfs_symlink_remote.c |   3 +
 libxlog/util.c              |  37 +++++----
 mkfs/xfs_mkfs.c             |   4 +-
 repair/phase2.c             |  90 +++++++++++++-------
 repair/xfs_repair.c         |  79 +++++++++++++++++-
 28 files changed, 614 insertions(+), 150 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
