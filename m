Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4NLn7sh025342 for <xfs@oss.sgi.com>; Mon, 23 May 2011 16:49:07 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201105232149.p4NLn2PV022851@stout.americas.sgi.com>
Date: Mon, 23 May 2011 16:49:02 -0500
Subject: [GIT PULL] XFS update 1 for 2.6.40-rc1
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

The following changes since commit ea2b50ef4c9e030749ae473e95258f477c3a68ca:

  Merge branch 'x86-apic-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-05-23 12:54:15 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (6):
      xfs: optimize AGFL refills
      xfs: do not immediately reuse busy extent ranges
      xfs: exact busy extent tracking
      xfs: reduce the number of pagb_lock roundtrips in xfs_alloc_clear_busy
      xfs: fix compiler warning in xfs_trace.h
      xfs: add an x86 compat handler for XFS_IOC_ZERO_RANGE

Dave Chinner (10):
      xfs: ensure reclaim cursor is reset correctly at end of AG
      xfs: exit AIL push work correctly when AIL is empty
      xfs: always push the AIL to the target
      xfs: make AIL target updates and compares 32bit safe.
      xfs: fix race condition in AIL push trigger
      xfs: fix duplicate workqueue initialisation
      xfs: fix xfs_itruncate_start tracing
      xfs: avoid getting stuck during async inode flushes
      xfs: reset buffer pointers before freeing them
      xfs: obey minleft values during extent allocation correctly

David Sterba (1):
      xfs: cleanup duplicate initializations

Joe Perches (1):
      xfs: kill off xfs_printk()

 fs/xfs/linux-2.6/xfs_buf.c     |   22 +-
 fs/xfs/linux-2.6/xfs_buf.h     |    1 +
 fs/xfs/linux-2.6/xfs_ioctl32.c |    3 +-
 fs/xfs/linux-2.6/xfs_ioctl32.h |    1 +
 fs/xfs/linux-2.6/xfs_linux.h   |    1 +
 fs/xfs/linux-2.6/xfs_message.c |   20 +-
 fs/xfs/linux-2.6/xfs_message.h |    7 +-
 fs/xfs/linux-2.6/xfs_super.c   |    4 -
 fs/xfs/linux-2.6/xfs_sync.c    |   11 +
 fs/xfs/linux-2.6/xfs_trace.h   |   76 ++---
 fs/xfs/xfs_ag.h                |    1 -
 fs/xfs/xfs_alloc.c             |  844 +++++++++++++++++++++++++++------------
 fs/xfs/xfs_alloc.h             |   15 +-
 fs/xfs/xfs_alloc_btree.c       |   13 +-
 fs/xfs/xfs_dfrag.c             |    6 +-
 fs/xfs/xfs_inode.c             |    2 +-
 fs/xfs/xfs_inode_item.c        |    1 -
 fs/xfs/xfs_log.c               |   15 +-
 fs/xfs/xfs_log.h               |    2 -
 fs/xfs/xfs_log_cil.c           |    5 +-
 fs/xfs/xfs_log_priv.h          |    2 +
 fs/xfs/xfs_log_recover.c       |   75 ++--
 fs/xfs/xfs_mount.c             |    4 +-
 fs/xfs/xfs_trans.c             |    6 +-
 fs/xfs/xfs_trans_ail.c         |   47 ++-
 fs/xfs/xfs_types.h             |    2 -
 26 files changed, 748 insertions(+), 438 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
