Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0A8goEX226352 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 02:42:51 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7885F1D1E072
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 00:45:01 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	0bLYAFHKWf86vhx8 for <xfs@oss.sgi.com>;
	Mon, 10 Jan 2011 00:45:01 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	7019538-1927428
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 19:14:59 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcDN3-0004x6-U6
	for xfs@oss.sgi.com; Mon, 10 Jan 2011 19:44:57 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PcDN1-00075k-5p
	for xfs@oss.sgi.com; Mon, 10 Jan 2011 19:44:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfsprogs: sync up with 2.6.38 kernel code V2
Date: Mon, 10 Jan 2011 19:44:48 +1100
Message-Id: <1294649091-27174-1-git-send-email-david@fromorbit.com>
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

This is version 2 of the 2.6.38 kernel code sync to userspace. It
currently passes xfstests on x86_64 with no new regressions
regardless of the filesystem block size combination I throw at it.

Note: this does not convert xfsprogs to the kernel xfs_trans_ijoin\
ijoin_ref interface, it maintains the older ijoin/ihold interface
because of the different way the inode reference counting works in
libxfs. More work will be needed to change it over to a manner
compatible with the current kernel API.

Note: log sector size handling needs to be sorted out. Specifically,
initialising l_sectbb_log/l_sectBBsize correctly and removing the
hacks in xlog_bread and friends (libxlog/xfs_log_recover.c) to work
around the fact they are not initialised correctly. (FWIW, I don't
think xfsprogs handles large log sector size correctly as a result,
and especially not if the log device sector size is different to the
data device sector size).

Version 2:
- split into three patches:
	- reintroduction of radix tree code
	- libxlog resync
		- includes required libxfs transaction code changes
		- updates logprint to use new interfaces
	- libxfs resync
		- updates libxfs
		- updates all xfsprogs to use new libxfs interfaces.
- fixes xfstest 033 cache_purge bug
	- was a problem in handling the XFS_ILI_HOLD flag removal.


---

The following changes since commit adfdbed6a014a412529864a66b09117e6a4bee64:

  Update xfsprogs Debian maintainer annotation, bump version. (2010-11-11 21:11:44 +1100)

are available in the git repository at:
  git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev kernel-2.6.38-sync

Dave Chinner (5):
      repair: warn if running in low memory mode
      xfs_repair: multithread phase 2
      libxfs: reintroduce old xfs_repair radix-tree code
      libxlog: sync up with 2.6.38 kernel code
      libxfs: sync files with 2.6.38 kernel code

 db/attr.c                  |   16 +-
 db/attrset.c               |    5 +-
 db/bmap.c                  |   18 +-
 db/bmap.h                  |    4 +-
 db/check.c                 |   50 +-
 db/convert.c               |    6 +-
 db/dir2sf.c                |    6 +-
 db/field.c                 |    2 +-
 db/frag.c                  |    6 +-
 db/inode.c                 |  124 ++--
 db/metadump.c              |   20 +-
 include/Makefile           |    5 +-
 include/atomic.h           |   31 +
 include/hlist.h            |   76 ++
 include/libxfs.h           |   44 +-
 include/libxlog.h          |   16 +-
 include/list.h             |   11 +
 include/radix-tree.h       |   76 ++
 include/xfs_ag.h           |  100 ++-
 include/xfs_alloc.h        |   58 +-
 include/xfs_arch.h         |   32 -
 include/xfs_attr_leaf.h    |   12 -
 include/xfs_attr_sf.h      |   42 +-
 include/xfs_bit.h          |   10 +-
 include/xfs_bmap.h         |  133 ++--
 include/xfs_bmap_btree.h   |   20 +-
 include/xfs_btree.h        |   31 +-
 include/xfs_btree_trace.h  |   17 -
 include/xfs_buf_item.h     |   50 +-
 include/xfs_da_btree.h     |   21 +-
 include/xfs_dfrag.h        |    5 +-
 include/xfs_dinode.h       |  149 ++---
 include/xfs_dir2.h         |    4 +-
 include/xfs_dir2_data.h    |    2 +-
 include/xfs_dir2_node.h    |    2 -
 include/xfs_dir2_sf.h      |    7 -
 include/xfs_extfree_item.h |   17 +-
 include/xfs_fs.h           |   30 +-
 include/xfs_ialloc.h       |   30 +-
 include/xfs_ialloc_btree.h |   23 +-
 include/xfs_imap.h         |   38 -
 include/xfs_inode.h        |  210 +++---
 include/xfs_inode_item.h   |   32 +-
 include/xfs_inum.h         |    1 -
 include/xfs_log.h          |   70 +-
 include/xfs_log_priv.h     |  331 +++++++--
 include/xfs_log_recover.h  |   25 +-
 include/xfs_mount.h        |  259 ++-----
 include/xfs_quota.h        |  160 ++--
 include/xfs_rtalloc.h      |   19 +-
 include/xfs_sb.h           |  168 +++--
 include/xfs_trace.h        |   85 +++
 include/xfs_trans.h        |  648 +++--------------
 include/xfs_trans_space.h  |    2 +-
 include/xfs_types.h        |   18 +-
 libxfs/Makefile            |    2 +-
 libxfs/init.c              |  133 +++-
 libxfs/logitem.c           |  371 +---------
 libxfs/radix-tree.c        |  805 ++++++++++++++++++++
 libxfs/trans.c             |  211 ++----
 libxfs/util.c              |   75 +-
 libxfs/xfs.h               |   49 +-
 libxfs/xfs_alloc.c         |  599 ++++++++--------
 libxfs/xfs_alloc_btree.c   |   46 +-
 libxfs/xfs_attr.c          |  138 ++--
 libxfs/xfs_attr_leaf.c     |  135 ++--
 libxfs/xfs_bmap.c          | 1773 ++++++++++++++++++++++----------------------
 libxfs/xfs_bmap_btree.c    |  129 ++--
 libxfs/xfs_btree.c         |   96 ++-
 libxfs/xfs_da_btree.c      |   48 +-
 libxfs/xfs_dir2.c          |   31 +-
 libxfs/xfs_dir2_block.c    |   28 +-
 libxfs/xfs_dir2_leaf.c     |   21 +-
 libxfs/xfs_dir2_node.c     |   29 +-
 libxfs/xfs_dir2_sf.c       |   24 +-
 libxfs/xfs_ialloc.c        | 1157 +++++++++++++++--------------
 libxfs/xfs_ialloc_btree.c  |   35 +-
 libxfs/xfs_inode.c         |  277 ++++----
 libxfs/xfs_mount.c         |  123 +---
 libxfs/xfs_trans.c         |  492 +++++++++++--
 libxlog/xfs_log_recover.c  |  606 ++++++++-------
 logprint/log_misc.c        |    2 +-
 logprint/log_print_all.c   |   13 +-
 logprint/log_print_trans.c |    4 +-
 mkfs/proto.c               |   18 +-
 mkfs/xfs_mkfs.c            |    3 +-
 repair/attr_repair.c       |   14 +-
 repair/dino_chunks.c       |   12 +-
 repair/dinode.c            |  275 ++++----
 repair/dir.c               |   18 +-
 repair/dir2.c              |   22 +-
 repair/incore.h            |    3 +
 repair/phase2.c            |   20 +-
 repair/phase6.c            |   76 +-
 repair/prefetch.c          |   29 +-
 repair/rt.c                |    2 +-
 repair/scan.c              |  294 +++++----
 repair/scan.h              |   39 +-
 repair/xfs_repair.c        |   26 +-
 99 files changed, 6094 insertions(+), 5586 deletions(-)
 create mode 100644 include/atomic.h
 create mode 100644 include/hlist.h
 create mode 100644 include/radix-tree.h
 delete mode 100644 include/xfs_imap.h
 create mode 100644 include/xfs_trace.h
 create mode 100644 libxfs/radix-tree.c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
