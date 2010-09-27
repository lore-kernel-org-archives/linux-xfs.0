Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8R1lNfs150679 for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 20:47:23 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A827E7934B
	for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 19:01:12 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	jBhnLxVL4HBYI3ZQ for <xfs@oss.sgi.com>;
	Sun, 26 Sep 2010 19:01:12 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40283926-1927428
	for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 11:18:15 +0930 (CST)
Received: from [192.168.1.9] (helo=disturbed) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1P02pB-0002sL-DB
	for xfs@oss.sgi.com; Mon, 27 Sep 2010 11:48:13 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1P02ou-0003pT-Sg
	for xfs@oss.sgi.com; Mon, 27 Sep 2010 11:47:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/18] xfs: metadata scalability V4
Date: Mon, 27 Sep 2010 11:47:35 +1000
Message-Id: <1285552073-14663-1-git-send-email-david@fromorbit.com>
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

xfs: Metadata scalability patchset V4

Version 4:
o removed xfs_ichgtime by open coding the only unlogged time change
  and moved xfs_trans_ichgtime() to xfs_trans_inode.c
o cleaned up trylock semantics in per-ag reclaim locking algorithm.
o made xfs_inode_ag_walk_grab() STATIC.

Version 3:
o added CIL background push fixup. While it is a correctness bug fix,
  it also signifincantly speeds up sustained workloads. This version
  of the patch has addresed the review comments.
o cleaned up some typos and removed useless comments around timestamp
  changes
o changed xfs_buf_get_uncached() parameters to pass the buftarg first.
o split inode walk batch lookup in two patches to separate out grabbing and
  releasing inodes from the batch lookups.

Version 2:
o dropped inode cache RCU/spinlock conversion (needs more testing)
o dropped buffer cache LRU/no page cache conversion (needs more testing)
o added CIL item insertion cleanup as suggested by Christoph.
o added flags to xfs_buf_get_uncached() and xfs_buf_read_uncached()
  to control memory allocation flags.
o cleaned up buffer page allocation failure path
o reworked inode reclaim shrinker scalability
	- separated reclaim AG walk from sync walks
	- implemented batch lookups for both sync and reclaim walks
	- added per-ag reclaim serialisation locks and traversal
	  cursors

This patchset started out as a "convert the buffer cache to rbtrees"
patch, and just gew from there as I peeled the onion from one
bottleneck to another. The second version of this patch does not go
as far as the first version - it drops the more radical changes as
they are not ready for integration yet.

The lock contention reductions allowed by the RCU inode cache
lookups are replaced by more efficient lookup mechanisms during
inode cache walking - using batching mechanisms as originally
suggested by Nick Piggin. The code is a lot more efficient than
Nick's proof of concept as it uses batched gang lookups on the radix
trees. These batched lookups show almost the same performance
improvement as the RCU lookup did but without changing the locking
algorithms at all.  This batching would be necessary for efficient
reclaim walks regardless of whether the sync walk is protected by
RCU or the current rwlock.

I dropped the no-page-cache conversion patches for the buffer cache
as well, as they need more work and testing before they are ready.

The shrinker rework improves parallel unlink performance
substantially more than just single threading the shrinker execution
and does not have the OOM problems that single threading the
shrinker had. It avoids the OOM problems by ensuring that every
shrinker call does some work or sleeps while waiting for an AG to do
some work on. The lookup optimisations done for gang lookups ensure
that the scanning is as efficient as possible, so overall shrinker
overhead has gone down significantly.

Performance numbers here are 8-way fs_mark create to 50M files, and
8-way rm -rf to remove the files created.

			wall time	fs_mark rate
2.6.36-rc4:
	create:		13m10s		65k file/s
	unlink:		23m58s		N/A

2.6.36-rc4 + v1-patchset:
	create:		 9m47s		95k files/s
	unlink:		14m16s		N/A

2.6.36-rc3 + v2-patchset:
	create:		10m32s		85k file/s
	unlink:		11m49s		N/A

2.6.36-rc4 + v3-patchset
	create:		10m03s		90k file/s
	unlink:		11m29s		N/A

Also, the new CIL push patch has greatly improved 8-way 1 billion inode create
and unlink times, with create dropping from 4h38m to 3h41m, and 8-way unlink
dropping from 5h36m to 4h28m.

The patches are available in the following git tree. The branch is
based on the current OSS xfs tree, and as such is based on
2.6.36-rc4. This is a rebase of the previous branch.

The following changes since commit e89318c670af3959db3aa483da509565f5a2536c:

  xfs: eliminate some newly-reported gcc warnings (2010-09-16 12:56:42 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git metadata-scale

Dave Chinner (18):
      xfs: force background CIL push under sustained load
      xfs: reduce the number of CIL lock round trips during commit
      xfs: remove debug assert for per-ag reference counting
      xfs: lockless per-ag lookups
      xfs: don't use vfs writeback for pure metadata modifications
      xfs: rename xfs_buf_get_nodaddr to be more appropriate
      xfs: introduced uncached buffer read primitve
      xfs: store xfs_mount in the buftarg instead of in the xfs_buf
      xfs: kill XBF_FS_MANAGED buffers
      xfs: use unhashed buffers for size checks
      xfs: remove buftarg hash for external devices
      xfs: split inode AG walking into separate code for reclaim
      xfs: split out inode walk inode grabbing
      xfs: implement batched inode lookups for AG walking
      xfs: batch inode reclaim lookup
      xfs: serialise inode reclaim within an AG
      xfs: convert buffer cache hash to rbtree
      xfs: pack xfs_buf structure more tightly

 fs/xfs/linux-2.6/xfs_buf.c     |  200 +++++++++++---------
 fs/xfs/linux-2.6/xfs_buf.h     |   50 +++---
 fs/xfs/linux-2.6/xfs_ioctl.c   |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c    |   35 ----
 fs/xfs/linux-2.6/xfs_super.c   |   15 +-
 fs/xfs/linux-2.6/xfs_sync.c    |  413 +++++++++++++++++++++++-----------------
 fs/xfs/linux-2.6/xfs_sync.h    |    4 +-
 fs/xfs/linux-2.6/xfs_trace.h   |    4 +-
 fs/xfs/quota/xfs_qm_syscalls.c |   14 +--
 fs/xfs/xfs_ag.h                |    9 +
 fs/xfs/xfs_attr.c              |   31 +--
 fs/xfs/xfs_buf_item.c          |    3 +-
 fs/xfs/xfs_fsops.c             |   11 +-
 fs/xfs/xfs_inode.h             |    1 -
 fs/xfs/xfs_inode_item.c        |    9 -
 fs/xfs/xfs_log.c               |    3 +-
 fs/xfs/xfs_log_cil.c           |  244 +++++++++++++-----------
 fs/xfs/xfs_log_priv.h          |   37 ++--
 fs/xfs/xfs_log_recover.c       |   19 +-
 fs/xfs/xfs_mount.c             |  152 ++++++++-------
 fs/xfs/xfs_mount.h             |    2 +
 fs/xfs/xfs_rename.c            |   12 +-
 fs/xfs/xfs_rtalloc.c           |   29 ++--
 fs/xfs/xfs_trans.h             |    1 +
 fs/xfs/xfs_trans_inode.c       |   30 +++
 fs/xfs/xfs_utils.c             |    4 +-
 fs/xfs/xfs_vnodeops.c          |   23 ++-
 27 files changed, 732 insertions(+), 625 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
