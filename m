Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C0i77o124890 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 18:44:07 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E63D256223
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 16:36:26 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	wiDzD6mCjvhw6TBb for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 16:36:26 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52672234-1927428
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 11:06:25 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcohC-0000UP-1H
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:36:14 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pcogu-0002Fz-Fi
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:35:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 0/12] xfs: rework error logging infrastructure
Date: Wed, 12 Jan 2011 11:35:41 +1100
Message-Id: <1294792553-8378-1-git-send-email-david@fromorbit.com>
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

This series completely reworks the cmn_err logging infrastructure
by replacing it with a simple, consistent API that can be used everwhere.
IOWs, this series replaces the various cmn_err APIs:

	cmn_err()
	xfs_cmn_err()
	xfs_fs_cmn_err()
	xfs_fs_mount_cmn_err()
	xfs_fs_repair_cmn_err()
	xlog_warn()
	xlog_panic()
	xlog_exit()

With the following log level specific functions:

	xfs_emerg(mp, ....)
	xfs_alert(mp, ....)
	xfs_alert_tag(mp, int tag, ....)
	xfs_crit(mp, ....)
	xfs_err(mp, ....)
	xfs_warn(mp, ....)
	xfs_notice(mp, ....)
	xfs_info(mp, ....)
	xfs_debug(mp, ....)

and a generic printk function that uses the kernel log level
definitions(e.g.  KERN_WARN):

	xfs_printk(level, mp, ....)


This provides all the log messages with a common format.  If mp &&
mp->m_fsname exist, then the format is:

	"XFS (device name): <log message>"

otherwise it is:

	"XFS: <log message>"

Hence we end up with log messages looking like this:

Normal mount:
XFS (vda): Mounting Filesystem
XFS (vda): Ending clean mount

Bad mount options:
XFS (vdb): unknown mount option [foobar].
XFS (vdb): Filesystem has duplicate UUID - can't mount

Quota check:
XFS (vdb): Mounting Filesystem
XFS (vdb): Ending clean mount
XFS (vdb): Quotacheck needed: Please wait.
XFS (vdb): Quotacheck: Done.

Log recovery warnings:
XFS (vdb): Mounting Filesystem
XFS (vdb): Invalid block length (0x2000) for buffer
XFS (vdb): Ending clean mount
....
XFS (vdb): Mounting Filesystem
XFS (vdb): recovery required on read-only device.
XFS (vdb): write access unavailable, cannot proceed.
XFS (vdb): log mount/recovery failed: error 30
XFS (vdb): log mount failed
XFS (vdb): Disabling barriers, underlying device is readonly
XFS (vdb): Mounting filesystem in no-recovery mode.  Filesystem will be inconsistent.


Forced shutdown:
XFS (vdb): Mounting Filesystem
XFS (vdb): Ending clean mount
XFS (vdb): xfs_log_force: error 5 returned.
XFS (vdb): xfs_log_force: error 5 returned.
XFS (vdb): xfs_do_force_shutdown(0x1) called from line 1046 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xffffffff814acd93
XFS (vdb): xfs_log_force: error 5 returned.
XFS (vdb): xfs_log_force: error 5 returned.

And so on.

The other main change that pervades this series is that as I've
touched each log messsage that quotes the function name, I've
converted them to "%s:....", __func__, ... format. This shortens the
message format string and also makes it easier to grep the source
code to find the function definition.

Comments welcome.

Diffstat:

 fs/xfs/Makefile                |    2 +-
 fs/xfs/linux-2.6/kmem.c        |    9 +-
 fs/xfs/linux-2.6/xfs_aops.c    |    6 +-
 fs/xfs/linux-2.6/xfs_buf.c     |   17 ++--
 fs/xfs/linux-2.6/xfs_linux.h   |   22 ++++
 fs/xfs/linux-2.6/xfs_printk.c  |  133 ++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_printk.h  |   38 +++++++
 fs/xfs/linux-2.6/xfs_super.c   |  127 ++++++++++-------------
 fs/xfs/linux-2.6/xfs_sync.c    |    5 +-
 fs/xfs/linux-2.6/xfs_sysctl.c  |   25 ++++-
 fs/xfs/quota/xfs_dquot.c       |   48 +++++----
 fs/xfs/quota/xfs_dquot_item.c  |    5 +-
 fs/xfs/quota/xfs_qm.c          |   42 ++++----
 fs/xfs/quota/xfs_qm_bhv.c      |    3 +-
 fs/xfs/quota/xfs_qm_syscalls.c |   85 ++++++++--------
 fs/xfs/quota/xfs_trans_dquot.c |    5 +-
 fs/xfs/support/debug.c         |  115 ---------------------
 fs/xfs/support/debug.h         |   54 ----------
 fs/xfs/xfs_bmap.c              |   17 ++--
 fs/xfs/xfs_buf_item.c          |   15 ++--
 fs/xfs/xfs_da_btree.c          |    9 +-
 fs/xfs/xfs_dfrag.c             |    4 +-
 fs/xfs/xfs_dir2.c              |    2 +-
 fs/xfs/xfs_dir2_node.c         |   25 ++---
 fs/xfs/xfs_error.c             |   53 ++--------
 fs/xfs/xfs_error.h             |   29 +-----
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
 41 files changed, 808 insertions(+), 884 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
