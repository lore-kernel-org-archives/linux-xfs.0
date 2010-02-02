Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1329Z6u204147 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 20:09:36 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A97791C9B81E
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 18:10:43 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	02JsoSRNQr7JT6HS for <xfs@oss.sgi.com>;
	Tue, 02 Feb 2010 18:10:43 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	12207864-1927428
	for <xfs@oss.sgi.com>; Wed, 03 Feb 2010 12:40:42 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NcS7X-0003nd-7k
	for xfs@oss.sgi.com; Wed, 03 Feb 2010 10:25:23 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NcS7W-0006ih-1X
	for xfs@oss.sgi.com; Wed, 03 Feb 2010 10:25:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/10] Delayed write metadata writeback V4
Date: Wed,  3 Feb 2010 10:24:54 +1100
Message-Id: <1265153104-29680-1-git-send-email-david@fromorbit.com>
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

Version 4
- rework inode reclaim checks for better legibility
- add warning to reclaim code when delwri flush errors occur
- kill XFS_ITEM_FLUSHING now it is not used
- clean up sync_mode flags being pushed into xfs_iflush()
- kill the now unused xfs_bawrite() function
- include Christoph's fsync cache flush fix
- rework the inode locking and call to xfs_fsync() when doing
  synchronous inode writes to close races between the fsync and
  the background delwri flush afterwards.

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


The patch series (plus the couple of previous bug fixes that haven't been
pulled into the tree on oss yet) are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/dgc/xfs for-2.6.34

Christoph Hellwig (1):
      xfs: remove invalid barrier optimization from xfs_fsync

Dave Chinner (11):
      xfs: don't hold onto reserved blocks on remount,ro
      xfs: turn off sign warnings
      xfs: Make inode reclaim states explicit
      xfs: Use delayed write for inodes rather than async V2
      xfs: Don't issue buffer IO direct from AIL push V2
      xfs: Sort delayed write buffers before dispatch
      xfs: Use delay write promotion for dquot flushing
      xfs: kill the unused XFS_QMOPT_* flush flags V2
      xfs: move the inode locking outside xfs_fsync()
      xfs: xfs_fs_write_inode() can fail to write inodes synchronously V2
      xfs: kill xfs_bawrite

 fs/xfs/Makefile               |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c    |  135 ++++++++++++++++++++++++++--------------
 fs/xfs/linux-2.6/xfs_buf.h    |    3 +-
 fs/xfs/linux-2.6/xfs_file.c   |    6 ++-
 fs/xfs/linux-2.6/xfs_lrw.c    |    5 +-
 fs/xfs/linux-2.6/xfs_super.c  |   82 ++++++++++++++++++-------
 fs/xfs/linux-2.6/xfs_sync.c   |  138 +++++++++++++++++++++++++++++++++-------
 fs/xfs/linux-2.6/xfs_trace.h  |    1 +
 fs/xfs/quota/xfs_dquot.c      |   38 +++++-------
 fs/xfs/quota/xfs_dquot_item.c |   87 ++++----------------------
 fs/xfs/quota/xfs_dquot_item.h |    4 -
 fs/xfs/quota/xfs_qm.c         |   14 ++---
 fs/xfs/xfs_buf_item.c         |   64 ++++++++++---------
 fs/xfs/xfs_inode.c            |   86 ++------------------------
 fs/xfs/xfs_inode.h            |   11 +---
 fs/xfs/xfs_inode_item.c       |  108 +++++++-------------------------
 fs/xfs/xfs_inode_item.h       |    6 --
 fs/xfs/xfs_mount.c            |   13 ++++-
 fs/xfs/xfs_mount.h            |    1 +
 fs/xfs/xfs_quota.h            |    8 +--
 fs/xfs/xfs_trans.h            |    3 +-
 fs/xfs/xfs_trans_ail.c        |   13 ++--
 fs/xfs/xfs_vnodeops.c         |   46 +++++--------
 fs/xfs/xfs_vnodeops.h         |    2 +-
 24 files changed, 415 insertions(+), 461 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
