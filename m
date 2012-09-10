Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8AIZk8J175854 for <xfs@oss.sgi.com>; Mon, 10 Sep 2012 13:35:47 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DOKt7pEPZzcBm8Al for
	<xfs@oss.sgi.com>; Mon, 10 Sep 2012 11:36:50 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8AIanTY021265
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2012 14:36:49 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8AIan4n011516
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2012 14:36:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/8] speculative preallocation inode tracking
Date: Mon, 10 Sep 2012 14:37:18 -0400
Message-Id: <1347302246-52710-1-git-send-email-bfoster@redhat.com>
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

This is v2 of the speculative preallocation inode tracking patchset. This
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

Brian Foster (8):
  xfs: add EOFBLOCKS inode tagging/untagging
  xfs: support a tag-based inode_ag_iterator
  xfs: create helper to check whether to free eofblocks on inode
  xfs: export xfs_free_eofblocks() and return EAGAIN on trylock failure
  xfs: create function to scan and clear EOFBLOCKS inodes
  xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
  xfs: add enhanced filtering to EOFBLOCKS scan
  xfs: add background scanning to clear EOFBLOCKS inodes

 fs/xfs/xfs_ag.h          |    1 +
 fs/xfs/xfs_fs.h          |   23 +++++
 fs/xfs/xfs_globals.c     |    1 +
 fs/xfs/xfs_ioctl.c       |   20 ++++
 fs/xfs/xfs_iomap.c       |    7 ++
 fs/xfs/xfs_iops.c        |    3 +
 fs/xfs/xfs_linux.h       |    1 +
 fs/xfs/xfs_mount.h       |    2 +
 fs/xfs/xfs_qm_syscalls.c |    5 +-
 fs/xfs/xfs_sync.c        |  215 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_sync.h        |   11 ++-
 fs/xfs/xfs_sysctl.c      |    9 ++
 fs/xfs/xfs_sysctl.h      |    1 +
 fs/xfs/xfs_trace.h       |    6 ++
 fs/xfs/xfs_vnodeops.c    |   27 +++---
 fs/xfs/xfs_vnodeops.h    |   24 +++++-
 16 files changed, 327 insertions(+), 29 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
