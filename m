Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6Ekwuq065721 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 08:46:58 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yhVrrMW5B08joDSn for
	<xfs@oss.sgi.com>; Tue, 06 Nov 2012 06:48:54 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA6EmsGT025637
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 09:48:54 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id qA6EmrTq002581
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 09:48:53 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v6 00/10] speculative preallocation inode tracking
Date: Tue,  6 Nov 2012 09:50:37 -0500
Message-Id: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
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

Sorry for the delay. Here is v6 of the speculative prealloc tracking patchset.
The first 5 patches are basically unchanged, the xfs_quota_type() patch is
dropped and the subsequent patches have been reworked to gear the eofblocks
ioctl() to filter based on inode ID's rather than being quota-centric, related to
the following discussion:

http://oss.sgi.com/archives/xfs/2012-10/msg00439.html

My initial intent was to leave the ability to filter on multiple ID's
concurrently as a follow-on change, but it seemed relatively straightforward as I
was hacking on this so I included it in this set (patch 8). It is included as a
standalone patch so I can leave it or drop it if necessary.

This set has been tested via xfstests with debug on and off with no obvious
regressions and sanity tested via Dave's xfs_spaceman tool and the prealloc add-on
(which I will post an update for as well).

Brian

v6:
- Added reviewed-by's from Dave and Mark.
- Pad struct xfs_eofblocks out to 128 bytes.
- Replaced quota ID and quota type with specific inode ID fields and associated
  control flags.
- Minimum file size field to 64-bit.
- Various style and ioctl() validation fixes.
- Renamed background scanning control file and increased max interval to a 24H
  timeframe.

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
  xfs: add inode id filtering to eofblocks scan
  xfs: support multiple inode id filtering in eofblocks scan
  xfs: add minimum file size filtering to eofblocks scan
  xfs: add background scanning to clear eofblocks inodes

 fs/xfs/xfs_ag.h          |    1 +
 fs/xfs/xfs_fs.h          |   26 ++++++
 fs/xfs/xfs_globals.c     |    4 +-
 fs/xfs/xfs_icache.c      |  225 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_icache.h      |   12 ++-
 fs/xfs/xfs_inode.c       |   37 ++++++++
 fs/xfs/xfs_inode.h       |    1 +
 fs/xfs/xfs_ioctl.c       |   20 ++++
 fs/xfs/xfs_iomap.c       |    8 ++
 fs/xfs/xfs_iops.c        |    4 +
 fs/xfs/xfs_linux.h       |    1 +
 fs/xfs/xfs_mount.c       |    2 +
 fs/xfs/xfs_mount.h       |    3 +
 fs/xfs/xfs_qm_syscalls.c |    5 +-
 fs/xfs/xfs_super.c       |    9 ++
 fs/xfs/xfs_sysctl.c      |    9 ++
 fs/xfs/xfs_sysctl.h      |    1 +
 fs/xfs/xfs_trace.h       |    6 ++
 fs/xfs/xfs_vnodeops.c    |   27 +++---
 fs/xfs/xfs_vnodeops.h    |    1 +
 20 files changed, 375 insertions(+), 27 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
