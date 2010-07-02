Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o62NqDpp003807 for <xfs@oss.sgi.com>; Fri, 2 Jul 2010 18:52:13 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201007022354.o62NsucI020931@stout.americas.sgi.com>
Date: Fri, 02 Jul 2010 18:54:55 -0500
Subject: [GIT PULL] XFS update for 2.6.35-rc4
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

These five commits implement a few security-related changes to XFS.
One enforces more strict permission checks for swapping file
extents.  Others do a better job of validating information from
untrustworthy sources before using it.

					-Alex

The following changes since commit 123f94f22e3d283dfe68742b269c245b0501ad82:

  Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-07-02 09:52:58 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (1):
      xfs: always use iget in bulkstat

Dan Rosenberg (1):
      xfs: prevent swapext from operating on write-only files

Dave Chinner (3):
      xfs: validate untrusted inode numbers during lookup
      xfs: rename XFS_IGET_BULKSTAT to XFS_IGET_UNTRUSTED
      xfs: remove block number from inode lookup code

 fs/xfs/linux-2.6/xfs_export.c  |   11 +-
 fs/xfs/linux-2.6/xfs_ioctl.c   |    7 +-
 fs/xfs/linux-2.6/xfs_ioctl32.c |   15 +--
 fs/xfs/quota/xfs_qm.c          |   18 +--
 fs/xfs/quota/xfs_qm_syscalls.c |   27 ++--
 fs/xfs/xfs_dfrag.c             |    5 +-
 fs/xfs/xfs_ialloc.c            |  142 ++++++++++++---------
 fs/xfs/xfs_iget.c              |   10 +-
 fs/xfs/xfs_inode.c             |    5 +-
 fs/xfs/xfs_inode.h             |    6 +-
 fs/xfs/xfs_itable.c            |  285 ++++++----------------------------------
 fs/xfs/xfs_itable.h            |   17 ---
 fs/xfs/xfs_log_recover.c       |    2 +-
 fs/xfs/xfs_mount.c             |    2 +-
 fs/xfs/xfs_rtalloc.c           |    4 +-
 fs/xfs/xfs_trans_inode.c       |    2 +-
 fs/xfs/xfs_vnodeops.c          |    2 +-
 17 files changed, 172 insertions(+), 388 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
