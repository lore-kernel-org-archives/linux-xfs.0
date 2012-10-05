Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95Er7Fq058129 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 09:53:07 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kweXw2xdRpHBaAVC for
	<xfs@oss.sgi.com>; Fri, 05 Oct 2012 07:54:34 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q95EsWXS011893
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:54:33 -0400
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q95EFaMG019552
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 00/10] speculative preallocation inode tracking
Date: Fri,  5 Oct 2012 10:17:06 -0400
Message-Id: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,

This is v3 of the speculative preallocation inode tracking patchset. This
functionality tracks inodes with post-EOF speculative preallocation for the
purpose of background and on-demand trimming.

Background scanning occurs on a longish interval (5 minutes by default) and in
a best-effort mode (i.e., inodes are skipped due to lock contention or dirty
cache). The intent is to clear up post-EOF blocks on inodes that might have
allocations hanging around due to open-write-close sequences (NFS).

On demand scanning is provided via a new ioctl and supports various parameters
such as scan mode, filtering by quota id and minimum file size. A pending use
case for on demand scanning is for accurate quota accounting via the gluster
scale out filesystem (i.e., to free up preallocated space when near a usage
limit).

Brian

v5:
- Rebased against the die-xfssyncd-die patchset.
- Renamed xfs_inodes_free_eofblocks() to xfs_icache_free_eofblocks().
- Migrated xfs_can_free_eofblocks() from static inline to xfs_inode.c.
- Fixed xfs_eofblocks version field and added version check to ioctl().
- Reworked quota filtering to use standard quota fields. Added patch 7 to
  support.
- Split min. file size filtering into a separate patch.
- Reworked background scanning based on rebase. Created a new eofblocks
  workqueue, renamed the tunable and based its value in seconds.

v4:
- Fix the broken need_iolock parameter to the xfs_free_eofblocks() call in
  patch 5 (thanks to Ben M. for testing). This is a one line change. All
  other patches equivalent to v3. This version survives an xfstests run (with
  XFS_DEBUG enabled this time :P).

v3:
- Pushed dirty cache check up into patch 5 (minor clean up).
- Reworked xfs_can_free_eofblocks() in patch 3 as per Dave C.'s review.
- Rebased from linus' tree to the XFS tree.

v2:
- Remove unnecessary inode flag clear helper.
- Condense eofblocks set/clear tag functions.
- Move clear tag call into xfs_free_eofblocks().
- Modify AG walk infrastructure to support tag-based walk and utilize this
  functionality for the eofblocks scan (as opposed to the previous code
  duplicated from reclaim scanning).
- Improve ioctl functionality: new data structure fields/flags, validate quota
  is enabled.
- Increase default background scanning interval to 5 minutes, add tunable.

Brian Foster (10):
  xfs: add EOFBLOCKS inode tagging/untagging
  xfs: support a tag-based inode_ag_iterator
  xfs: create helper to check whether to free eofblocks on inode
  xfs: make xfs_free_eofblocks() non-static, return EAGAIN on trylock
    failure
  xfs: create function to scan and clear EOFBLOCKS inodes
  xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
  xfs: make xfs_quota_type() non-static
  xfs: add quota id filtering to eofblocks scan
  xfs: add minimum file size filtering to eofblocks scan
  xfs: add background scanning to clear eofblocks inodes

 fs/xfs/xfs_ag.h          |    1 +
 fs/xfs/xfs_fs.h          |   20 ++++
 fs/xfs/xfs_globals.c     |    1 +
 fs/xfs/xfs_icache.c      |  220 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_icache.h      |   12 ++-
 fs/xfs/xfs_inode.c       |   37 ++++++++
 fs/xfs/xfs_inode.h       |    1 +
 fs/xfs/xfs_ioctl.c       |   24 +++++
 fs/xfs/xfs_iomap.c       |    8 ++
 fs/xfs/xfs_iops.c        |    4 +
 fs/xfs/xfs_linux.h       |    1 +
 fs/xfs/xfs_mount.c       |    2 +
 fs/xfs/xfs_mount.h       |    3 +
 fs/xfs/xfs_qm_syscalls.c |    5 +-
 fs/xfs/xfs_quota.h       |    1 +
 fs/xfs/xfs_quotaops.c    |    2 +-
 fs/xfs/xfs_super.c       |    9 ++
 fs/xfs/xfs_sysctl.c      |    9 ++
 fs/xfs/xfs_sysctl.h      |    1 +
 fs/xfs/xfs_trace.h       |    6 ++
 fs/xfs/xfs_vnodeops.c    |   27 +++---
 fs/xfs/xfs_vnodeops.h    |    1 +
 22 files changed, 368 insertions(+), 27 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
