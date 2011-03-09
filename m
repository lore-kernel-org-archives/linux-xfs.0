Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2967awe023132 for <xfs@oss.sgi.com>; Wed, 9 Mar 2011 00:07:36 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E38513407BF
	for <xfs@oss.sgi.com>; Tue,  8 Mar 2011 22:10:30 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	EvC0eBP3tIVLQ730 for <xfs@oss.sgi.com>;
	Tue, 08 Mar 2011 22:10:30 -0800 (PST)
Received: from dave by dastard with local (Exim 4.72)
	(envelope-from <david@fromorbit.com>) id 1PxCbJ-0001AF-Is
	for xfs@oss.sgi.com; Wed, 09 Mar 2011 17:10:25 +1100
Date: Wed, 9 Mar 2011 17:10:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT] xfs: message infrastructure rework
Message-ID: <20110309061025.GT15097@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Alex,

Can you please pull the messaging infrastructure rework from the
tree below? It is based onteh current xfs-oss/master branch, so
should be completely up to date.

Cheers,

Dave.

The following changes since commit eeb2036b8a148629b762ae6d85cff0be8106f081:

  xfs: zero proper structure size for geometry calls (2011-03-01 21:19:59 -0600)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git xfs-message

Dave Chinner (11):
      xfs: introduce new logging API.
      xfs: Convert linux-2.6/ files to new logging interface
      xfs: Convert xlog_warn to new logging interface
      xfs: convert xfs_cmn_err to xfs_alert_tag
      xfs: kill xfs_fs_repair_cmn_err() macro
      xfs: kill xfs_fs_mount_cmn_err() macro
      xfs: convert xfs_fs_cmn_err to new error logging API
      xfs: rename xfs_cmn_err_fsblock_zero()
      xfs: convert the quota debug prints to new API
      xfs: Convert remaining cmn_err() callers to new API
      xfs: kill support/debug.[ch]

 fs/xfs/Makefile                |    5 +-
 fs/xfs/linux-2.6/kmem.c        |    9 +-
 fs/xfs/linux-2.6/xfs_aops.c    |    6 +-
 fs/xfs/linux-2.6/xfs_buf.c     |   17 ++--
 fs/xfs/linux-2.6/xfs_linux.h   |   23 ++++-
 fs/xfs/linux-2.6/xfs_message.c |  133 ++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_message.h |   38 +++++++
 fs/xfs/linux-2.6/xfs_super.c   |  127 ++++++++++-------------
 fs/xfs/linux-2.6/xfs_sync.c    |    5 +-
 fs/xfs/linux-2.6/xfs_sysctl.c  |    2 +-
 fs/xfs/quota/xfs_dquot.c       |   48 +++++----
 fs/xfs/quota/xfs_dquot_item.c  |    5 +-
 fs/xfs/quota/xfs_qm.c          |   42 ++++----
 fs/xfs/quota/xfs_qm_bhv.c      |    3 +-
 fs/xfs/quota/xfs_qm_syscalls.c |   85 ++++++++--------
 fs/xfs/quota/xfs_trans_dquot.c |    5 +-
 fs/xfs/support/debug.c         |  107 -------------------
 fs/xfs/support/debug.h         |   61 -----------
 fs/xfs/xfs_bmap.c              |   17 ++--
 fs/xfs/xfs_buf_item.c          |   15 ++--
 fs/xfs/xfs_da_btree.c          |    9 +-
 fs/xfs/xfs_dfrag.c             |    4 +-
 fs/xfs/xfs_dir2.c              |    2 +-
 fs/xfs/xfs_dir2_node.c         |   25 ++---
 fs/xfs/xfs_error.c             |   22 ++--
 fs/xfs/xfs_error.h             |   19 +---
 fs/xfs/xfs_fsops.c             |    6 +-
 fs/xfs/xfs_ialloc.c            |   82 ++++++---------
 fs/xfs/xfs_inode.c             |  124 ++++++++++------------
 fs/xfs/xfs_iomap.c             |   12 +-
 fs/xfs/xfs_log.c               |  124 +++++++++++------------
 fs/xfs/xfs_log_priv.h          |    4 -
 fs/xfs/xfs_log_recover.c       |  223 +++++++++++++++++++--------------------
 fs/xfs/xfs_mount.c             |  148 ++++++++++++++-------------
 fs/xfs/xfs_quota.h             |    3 +-
 fs/xfs/xfs_rtalloc.c           |    8 +-
 fs/xfs/xfs_rtalloc.h           |    2 +-
 fs/xfs/xfs_rw.c                |   40 +++----
 fs/xfs/xfs_trans_ail.c         |    2 +-
 fs/xfs/xfs_trans_buf.c         |    6 +-
 fs/xfs/xfs_vnodeops.c          |   13 +--
 41 files changed, 785 insertions(+), 846 deletions(-)
 create mode 100644 fs/xfs/linux-2.6/xfs_message.c
 create mode 100644 fs/xfs/linux-2.6/xfs_message.h
 delete mode 100644 fs/xfs/support/debug.c
 delete mode 100644 fs/xfs/support/debug.h
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
