Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o31CdtnQ120125 for <xfs@oss.sgi.com>; Thu, 1 Apr 2010 07:39:55 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 649D81DCA1F4
	for <xfs@oss.sgi.com>; Thu,  1 Apr 2010 05:41:41 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	6OgheyeCzc3ECcgq for <xfs@oss.sgi.com>;
	Thu, 01 Apr 2010 05:41:41 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	19158697-1927428
	for <xfs@oss.sgi.com>; Thu, 01 Apr 2010 23:11:39 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1NxJiK-0002HV-Bg
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:36 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NxJiJ-0001nQ-WE
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8] xfs: bug fixes, cleanups and tracing
Date: Thu,  1 Apr 2010 23:41:23 +1100
Message-Id: <1270125691-29266-1-git-send-email-david@fromorbit.com>
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

The first two patches are reposts of reviewed patches not yet in the
dev tree.  Christoph, the sync fix has been cleaned up like you
suggested, you might want to pass an eye over it again.

The next two are log changes - the first is making the transaction
ID that identifies transactions on disk really unique. The second is
a bunch of tracing additions to log recovery that I wrote recently
to track down an issue with delayed logging causing corruptions
during recovery.

The last four are the start of cleaning up some of the dquot code.
They basicaly remove all the hand coded linked list operations and
obfuscated locking macros for all the lists that the dquots can
exist on. One patch also removes a duplicated reclaim algorithm
and uses the common function to implement both reclaim and shaking
of dquots. I haven't done a huge amount of testing on these yet, but
they've passed several runs of xfsqa on both single and quad
processor VMs so far.

As usual, the series can also be found in my git tree...

The following changes since commit 68a2ac777cca40ccc993512bcf457999be71cc36:
  Christoph Hellwig (1):
        xfs: clean up xlog_write_adv_cnt

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git working

Dave Chinner (8):
      xfs: ensure that sync updates the log tail correctly
      xfs: don't warn on EAGAIN in inode reclaim
      xfs: make the log ticket transaction id random
      xfs: add log item recovery tracing
      xfs: convert the per-mount dquot list to use list heads
      xfs: remove duplicate code from dquot reclaim
      xfs: convert the dquot hash list to use list heads
      xfs: convert the dquot free list to use list heads

 fs/xfs/linux-2.6/xfs_sync.c    |    4 +-
 fs/xfs/linux-2.6/xfs_trace.c   |    3 +
 fs/xfs/linux-2.6/xfs_trace.h   |  150 +++++++++++-
 fs/xfs/quota/xfs_dquot.c       |  120 ++++------
 fs/xfs/quota/xfs_dquot.h       |   14 +-
 fs/xfs/quota/xfs_qm.c          |  520 ++++++++++++++--------------------------
 fs/xfs/quota/xfs_qm.h          |   23 +--
 fs/xfs/quota/xfs_qm_stats.c    |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |   36 +--
 fs/xfs/quota/xfs_quota_priv.h  |   75 ------
 fs/xfs/xfs_buf_item.h          |    2 +-
 fs/xfs/xfs_log.c               |   40 ++-
 fs/xfs/xfs_log_recover.c       |   44 +++-
 13 files changed, 472 insertions(+), 561 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
