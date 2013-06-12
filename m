Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 859F27CBF
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:23:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22D1DAC001
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:22:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jlJaGcSYibtDNNL2 for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:22:57 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiCZ-00015v-0t
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:22:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiCY-0005ku-Rh
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:22:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/27] xfs: current patch queue for 3.11
Date: Wed, 12 Jun 2013 20:22:20 +1000
Message-Id: <1371032567-21772-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

This is an update of my current patch queue for the 3.11 release
cycle. This series starts on top of the patch series I posted for
3.10-rc6, and builds upon the series previously posted last week:

http://oss.sgi.com/pipermail/xfs/2013-June/027040.html

The additions to the series since then are basically for making
kernel/userspace code synchronisation much, much easier. it mostly
consists of splitting code into shared and kernel-only files, both
header and c files. Hence the majority of the diffstat comes from
moving code between files, not actually modifying them. The
diffstat looks a lot more frightening than it really is.

The result is, however, a massive reduction in the diff between the
shared files:

~/src/xfsprogs-dev$ for f in libxfs/xfs_*.c include/xfs_*h; do \
> echo $f; diff -u $f ../kern/xfsdev/fs/xfs/`basename $f`
> done |diffstat
diff: ../kern/xfsdev/fs/xfs/xfs_arch.h: No such file or directory
diff: ../kern/xfsdev/fs/xfs/xfs_btree_trace.h: No such file or directory
diff: ../kern/xfsdev/fs/xfs/xfs_metadump.h: No such file or directory
 xfs_alloc.c        |   29 
 xfs_alloc_btree.c  |   95 --
 xfs_attr.c         |   27 
 xfs_attr_leaf.c    |   29 
 xfs_attr_remote.c  |   26 
 xfs_bmap.c         |  270 ++++++
 xfs_bmap_btree.c   |  122 ---
 xfs_btree.c        |   65 +
 xfs_btree.h        |   38 
 xfs_da_btree.c     |   27 
 xfs_dir2.c         |   23 
 xfs_dir2_block.c   |   25 
 xfs_dir2_data.c    |   23 
 xfs_dir2_leaf.c    |   23 
 xfs_dir2_node.c    |   22 
 xfs_dir2_sf.c      |   20 
 xfs_ialloc.c       |   26 
 xfs_ialloc_btree.c |   95 --
 xfs_inode.c        |   35 
 xfs_rtalloc.c      | 1602 ++++++++++++++++++++++++++++++++++++++++-
 xfs_sb.c           |   64 +
 xfs_symlink.c      |  560 ++++++++++++++
 xfs_trace.h        | 2058 +++++++++++++++++++++++++++++++++++++++++++++++++----
 xfs_trans_resv.c   |   30 
 24 files changed, 4837 insertions(+), 497 deletions(-)

Without the matching userspace patchset, the kernel/user diffstat
comes out at:

45 files changed, 8336 insertions(+), 2406 deletions(-)

in which xfs_rtalloc.c, xfs_symlink.c and xfs_trace.h are unchanged.

So if we ignore xfs_trace.h as there is nothing common between user and
kernel space there, xfs_symlink as it only has a some kernel-only
functions at it's tail and xfs_rtalloc.c as I haven't touched it at
all, then the remaining diffstat between user and kernel space is
roughly +775/-300 lines, and most of that is in differences in
#include lines at the top of each file.

The generic btree code differs in tracing stubs (low priority so
been waiting for years to be fixed), and the xfs-bmap.c code
differences are a couple of kernel functions, mostly
xfs_bmap_finish() and xfs_bmap_rtalloc(). There's some more work
that can be done, esp.  w.r.t xfs_symlink.c and the rtalloc code
that will reduce this even further.

IOWs, compared to before these patches, there's almost no difference
at all. This is going to make user/kernel syncs a whole lot
easier, and it's already found a lot of little differences that have
been previously been missed when syncing the userspace code.

The last couple of patches also fix minor whitespace and comment
differences noticed in the userspace code, and also fix all the
situations where the userspace code triggeres compiler warnings
that the kernel has turned off. With the userspace patch set, we end
up with a clean, warning free compile on my build machines.

Thoughts, comments, flames?

Cheers,

Dave.

 Documentation/filesystems/xfs.txt |  282 ++--
 fs/xfs/Makefile                   |   13 +-
 fs/xfs/xfs_acl.c                  |    3 +-
 fs/xfs/xfs_aops.c                 |   81 +-
 fs/xfs/xfs_attr.c                 |  390 +-----
 fs/xfs/xfs_attr.h                 |    9 +
 fs/xfs/xfs_attr_inactive.c        |  454 +++++++
 fs/xfs/xfs_attr_leaf.c            |  656 +--------
 fs/xfs/xfs_attr_leaf.h            |    2 +
 fs/xfs/xfs_attr_list.c            |  655 +++++++++
 fs/xfs/xfs_attr_remote.c          |   17 +-
 fs/xfs/xfs_bmap.c                 |  559 ++------
 fs/xfs/xfs_bmap.h                 |   10 +-
 fs/xfs/xfs_bmap_btree.c           |    4 +-
 fs/xfs/xfs_btree.h                |    2 -
 fs/xfs/xfs_buf.c                  |    1 +
 fs/xfs/xfs_buf_item.c             |   87 +-
 fs/xfs/xfs_buf_item.h             |    4 +-
 fs/xfs/xfs_da_btree.c             |    6 +-
 fs/xfs/xfs_dfrag.c                |    1 -
 fs/xfs/xfs_dir2.c                 |   35 -
 fs/xfs/xfs_dir2.h                 |   74 +
 fs/xfs/xfs_dir2_block.c           |  120 +-
 fs/xfs/xfs_dir2_data.c            |    1 +
 fs/xfs/xfs_dir2_format.h          |   27 +-
 fs/xfs/xfs_dir2_leaf.c            |  389 +-----
 fs/xfs/xfs_dir2_node.c            |    3 +
 fs/xfs/xfs_dir2_priv.h            |   33 +-
 fs/xfs/xfs_dir2_readdir.c         |  661 +++++++++
 fs/xfs/xfs_dir2_sf.c              |  103 +-
 fs/xfs/xfs_discard.c              |    1 +
 fs/xfs/xfs_export.c               |    1 -
 fs/xfs/xfs_extent_ops.c           | 1054 +++++++++++++++
 fs/xfs/xfs_extent_ops.h           |   30 +
 fs/xfs/xfs_file.c                 |    5 +-
 fs/xfs/xfs_fs.h                   |   17 +
 fs/xfs/xfs_ialloc.c               |   69 +-
 fs/xfs/xfs_ialloc.h               |    8 +
 fs/xfs/xfs_icache.c               |    1 -
 fs/xfs/xfs_icreate_item.c         |  195 +++
 fs/xfs/xfs_icreate_item.h         |   56 +
 fs/xfs/xfs_inode.c                | 2596 ++++++-----------------------------
 fs/xfs/xfs_inode.h                |  341 +----
 fs/xfs/xfs_inode_ops.c            | 2844 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode_ops.h            |  371 +++++
 fs/xfs/xfs_ioctl.c                |   37 +-
 fs/xfs/xfs_ioctl.h                |    6 +
 fs/xfs/xfs_ioctl32.c              |    1 -
 fs/xfs/xfs_iomap.c                |   13 +
 fs/xfs/xfs_iops.c                 |    3 +-
 fs/xfs/xfs_iops.h                 |   13 +
 fs/xfs/xfs_itable.c               |    3 +
 fs/xfs/xfs_log.c                  |   21 +-
 fs/xfs/xfs_log.h                  |    5 +-
 fs/xfs/xfs_log_cil.c              |   75 +-
 fs/xfs/xfs_log_recover.c          |  116 +-
 fs/xfs/xfs_mount.c                |  828 ++----------
 fs/xfs/xfs_mount.h                |   63 +-
 fs/xfs/xfs_quotaops.c             |    1 +
 fs/xfs/xfs_rename.c               |    1 -
 fs/xfs/xfs_rtalloc.c              |    4 +-
 fs/xfs/xfs_sb.c                   |  714 ++++++++++
 fs/xfs/xfs_sb.h                   |   26 +
 fs/xfs/xfs_super.c                |    9 +-
 fs/xfs/xfs_symlink.h              |    3 +-
 fs/xfs/xfs_trace.h                |    4 +
 fs/xfs/xfs_trans.c                |  618 +--------
 fs/xfs/xfs_trans.h                |   92 +-
 fs/xfs/xfs_trans_buf.c            |   34 +-
 fs/xfs/xfs_trans_priv.h           |    3 +
 fs/xfs/xfs_trans_resv.c           |  705 ++++++++++
 fs/xfs/xfs_trans_resv.h           |  135 ++
 fs/xfs/xfs_types.h                |    3 +-
 fs/xfs/xfs_vnodeops.c             | 1874 --------------------------
 fs/xfs/xfs_vnodeops.h             |   56 -
 fs/xfs/xfs_xattr.c                |    1 -
 76 files changed, 9378 insertions(+), 8360 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_inactive.c
 create mode 100644 fs/xfs/xfs_attr_list.c
 create mode 100644 fs/xfs/xfs_dir2_readdir.c
 create mode 100644 fs/xfs/xfs_extent_ops.c
 create mode 100644 fs/xfs/xfs_extent_ops.h
 create mode 100644 fs/xfs/xfs_icreate_item.c
 create mode 100644 fs/xfs/xfs_icreate_item.h
 create mode 100644 fs/xfs/xfs_inode_ops.c
 create mode 100644 fs/xfs/xfs_inode_ops.h
 create mode 100644 fs/xfs/xfs_sb.c
 create mode 100644 fs/xfs/xfs_trans_resv.c
 create mode 100644 fs/xfs/xfs_trans_resv.h
 delete mode 100644 fs/xfs/xfs_vnodeops.c
 delete mode 100644 fs/xfs/xfs_vnodeops.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
