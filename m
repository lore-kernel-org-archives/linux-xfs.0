Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0P6Lrfb037510 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 00:21:53 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 365FD188905
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2010 22:22:55 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	nciQgg62HnC6OvK1 for <xfs@oss.sgi.com>;
	Sun, 24 Jan 2010 22:22:55 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11585216-1927428
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 16:52:54 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NZILY-0002xH-5M
	for xfs@oss.sgi.com; Mon, 25 Jan 2010 17:22:48 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NZILX-0003no-1d
	for xfs@oss.sgi.com; Mon, 25 Jan 2010 17:22:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/7] Delayed write metadata writeback V3
Date: Mon, 25 Jan 2010 17:22:37 +1100
Message-Id: <1264400564-19704-1-git-send-email-david@fromorbit.com>
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

(a.k.a. kill async inode writeback V3)

While I started with killing async inode writeback, the series has
grown. It's not really limited to inode writeback - it touches dquot
flushing, changes the way the AIL pushes on buffers, adds xfsbufd
sortingi for delayed write buffers, adds a real non-blocking mode to
inode reclaim and avoids physical inode writeback from the VFS while
fixing bugs in handling delayed write inodes.  Hence this is more
about enabling efficient delayed write metadata than it is able
killing async inode writeback.

The idea behind this series is to make metadata buffers get
written from xfsbufd via the delayed write queue rather than being
issued asynchronously from all over the place. To do this, async
buffer writeback is almost entirely removed from XFS, replaced
instead by delayed writes and a method to expedite flushing of
delayed write buffers when required.

The result of funnelling all the buffer IO into a single place
is that we can more tightly control and therefore optimise the
submission of metadata IO. Aggregating the buffers before dispatch
allows much better sort efficiency of the buffers as the sort window
is not limited to the size of the elevator congestion hysteresis
limit. Hence we can approach 100% merge effeciency on large numbers
of buffers when dispatched for IO and greatly reduce the amount
of seeking metadata writeback causes.

The major change is to the inode flushing and reclaim code. Delayed
write inodes hold the flush lock for much longer than for async
writeback, and hence blocking on the flush lock can cause extremely
long latencies without other mechanisms to expedite the release of
the flush locks. To prevent needing to flush inodes immeidately,
all operations are done non-blocking unless synchronous. THis
required a significant rework of the inode reclaim code, but it
greatly simplified other pieces of code (e.g. log item pushing).

Version 3
- rework inode reclaim to:
	- separate it from xfs_iflush return values
	- provide a non-blocking mode for background operation
- apply delwri buffer promotion tricks to dquot flushing
- kill unneeded dquot flushing flags, similar to inode flushing flag
  removal
- fix sync inode flush bug when trying to flush delwri inodes

Version 2:
- use generic list sort function
- when unmounting, push the delwri buffers first, then do sync inode
  reclaim so that reclaim doesn't block for 15 seconds waiting for
  delwri inode buffers to be aged and written before the inodes can
  be reclaimed.

Performance numbers for this version are the same as V2, which were
as follows:

Perf results (average of 3 runs) on a debug XFS build (means allocation
patterns are randomly varied, so runtimes are also a bit variable):

Untar 2.6.32 kernel tarball, sync, then remove:

                  Untar+sync     rm -rf
xfs-dev:           25.2s          13.0s
xfs-dev-delwri-1:  22.5s           9.1s
xfs-dev-delwri-2:  21.9s           8.4s

4 processes each creating 100,000, five byte files in separate
directories concurrently, then 4 processes removing a directory each
concurrently.

                  create          rm -rf
xfs-dev:           8m32s           4m10s
xfs-dev-delwri-1:  4m55s           3m42s
xfs-dev-delwri-2:  4m56s           3m33s


The patch series (plus the couple of previous bug fixes) are
available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/dgc/xfs for-2.6.34

Dave Chinner (9):
      xfs: don't hold onto reserved blocks on remount,ro
      xfs: turn off sign warnings
      xfs: Make inode reclaim states explicit
      xfs: Use delayed write for inodes rather than async
      xfs: Don't issue buffer IO direct from AIL push
      xfs: Sort delayed write buffers before dispatch
      xfs: Use delay write promotion for dquot flushing
      xfs: kill the unused XFS_QMOPT_* flush flags
      xfs: xfs_fs_write_inode() can fail to write inodes synchronously

 fs/xfs/Makefile               |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c    |  117 +++++++++++++++++++++++++++++---------
 fs/xfs/linux-2.6/xfs_buf.h    |    2 +
 fs/xfs/linux-2.6/xfs_super.c  |   72 ++++++++++++++++++------
 fs/xfs/linux-2.6/xfs_sync.c   |  124 ++++++++++++++++++++++++++++++++--------
 fs/xfs/linux-2.6/xfs_trace.h  |    1 +
 fs/xfs/quota/xfs_dquot.c      |   38 +++++-------
 fs/xfs/quota/xfs_dquot_item.c |   87 ++++------------------------
 fs/xfs/quota/xfs_dquot_item.h |    4 -
 fs/xfs/quota/xfs_qm.c         |   14 ++---
 fs/xfs/xfs_buf_item.c         |   64 ++++++++++++----------
 fs/xfs/xfs_inode.c            |   86 ++--------------------------
 fs/xfs/xfs_inode.h            |   11 +---
 fs/xfs/xfs_inode_item.c       |  108 +++++++----------------------------
 fs/xfs/xfs_inode_item.h       |    6 --
 fs/xfs/xfs_mount.c            |   13 ++++-
 fs/xfs/xfs_mount.h            |    1 +
 fs/xfs/xfs_quota.h            |    8 +--
 fs/xfs/xfs_trans_ail.c        |    7 ++
 19 files changed, 367 insertions(+), 398 deletions(-)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
