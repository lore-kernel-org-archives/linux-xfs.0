Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p067Fw8f030925 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 01:15:58 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6304E4F4963
	for <xfs@oss.sgi.com>; Wed,  5 Jan 2011 23:18:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	VcrJRgeFoarXtEGC for <xfs@oss.sgi.com>;
	Wed, 05 Jan 2011 23:18:04 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	6689646-1927428
	for <xfs@oss.sgi.com>; Thu, 06 Jan 2011 17:48:03 +1030 (CDT)
Received: from dave by dastard with local (Exim 4.72)
	(envelope-from <david@fromorbit.com>) id 1Pak6j-00052W-MU
	for xfs@oss.sgi.com; Thu, 06 Jan 2011 18:18:01 +1100
Date: Thu, 6 Jan 2011 18:18:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: libxfs: sync files with 2.6.38 kernel code
Message-ID: <20110106071801.GG8322@dastard>
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

Folks,

Seeing as the current patch is over the list limits (it's 670k),
I pushed the current xfsprogs branch I'm working on to
git.kernel.org.

Some things to note:

Note: this does not convert xfsprogs to the kernel
xfs_trans_ijoin\ijoin_ref interface, it maintains the older
ijoin/ihold interface because of the different way the inode
reference counting works in libxfs. More work will be needed to
change it over to a manner compatible with the current kernel API.

Note: log sector size handling needs to be sorted out. Specifically,
initialising l_sectbb_log/l_sectBBsize correctly and removing the
hacks in xlog_bread and friends (libxlog/xfs_log_recover.c) to work
around the fact they are not initialised correctly. (FWIW, I don't
think xfsprogs handles large log sector size correctly as a result,
and especially not if the log device sector size is different to the
data device sector size).

Note: the patch re-introduces the radix-tree code that xfs_repair
previously used as part of libxfs. This can probably be separated
out into a preparatory patch.

Note: all the new trace points are being aggregated at
include/xfs_trace.h and defined to ((void) 0). If we want to do
something with them for userspace, then we can do something
different here as required.

Testing:

Currently passes xfstests on x86_64 w/ 4k block sizes. On 512 byte block/2k
directory block filesystems repair is giving this additional output on test
033:

+cache_purge: shake on cache 0x67a060 left 1 nodes!?

The same test run saw test 104 generating:

+_check_xfs_filesystem: filesystem on /dev/vdb is inconsistent (c) (see 104.full)

which appears to be due to this output:

*** xfs_check output ***
XFS: Invalid block length (0x2000) given for buffer

Which may be a result of the above xlog_bread issues. I haven't confirmed
whether this is a regression or not yet.

The tree/branch can be found here:

The following changes since commit adfdbed6a014a412529864a66b09117e6a4bee64:

  Update xfsprogs Debian maintainer annotation, bump version. (2010-11-11 21:11:44 +1100)

are available in the git repository at:
  git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev kernel-2.6.38-sync

Dave Chinner (3):
      repair: warn if running in low memory mode
      xfs_repair: multithread phase 2
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
 include/xfs_buf_item.h     |   51 +-
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
 repair/phase2.c            |   16 +-
 repair/phase6.c            |   76 +-
 repair/prefetch.c          |   29 +-
 repair/rt.c                |    2 +-
 repair/scan.c              |  303 +++++----
 repair/scan.h              |   37 -
 repair/xfs_repair.c        |   10 +-
 98 files changed, 6011 insertions(+), 5581 deletions(-)
 create mode 100644 include/atomic.h
 create mode 100644 include/radix-tree.h
 delete mode 100644 include/xfs_imap.h
 create mode 100644 include/xfs_trace.h
 create mode 100644 libxfs/radix-tree.c
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
