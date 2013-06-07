Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A5E67F56
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 00:46:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BFCC28F8052
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 22:45:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	yCQuFmaEZQpTEjPS for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 22:45:57 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkpUT-0004Xt-79
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 15:45:33 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkpUT-0003kL-2S
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 15:45:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/17] xfs: current patch queue for 3.11
Date: Fri,  7 Jun 2013 15:45:12 +1000
Message-Id: <1370583929-14276-1-git-send-email-david@fromorbit.com>
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

This is my current patch queue for the 3.11 release cycle. There is
an update to the mount option/sysctl documentation that includes
date for removal of deprecated mount options and sysctls in this, so
make sure you read it.

There are a couple of readahead plugging fixes to make sure we merge
adjacent readahead buffers before dispatching them. This makes a big
difference to directory and bulkstat performance when the IO
subsystem is IOPS bound.

There's a specualtive preallocation tweak to avoid speculative
prealloc for small files. This is primarily designed for workloads
that use small files exclusively like certain gluster/swift
workloads that are becoming more common.

Following this are a couple of patches to reduce the number of
buffer cache lookups we need to do when creating and unlinking
inodes. The inode create path now does not need to do IO to allocate
a new inode, which means it is more deterministic and less likely to
get blocked behind other IO operations.

Then there is a series of patches to introduce a new logical inode
create transaction for CRC enabld filesystems. This just logs a
small structure that indicates where the inodes being created exist,
and uses a new concept of "ordered buffers" to ensure that the
correct transactional life cycle is maintained for the inodes that
were allocated. This requires special ordered log vector support so
this information tracks correct through the CIL. This significantly
reduces the amoutn of log traffic needed by inode creation, as well
as removes one of the nasty warts around inode buffer handling in
log recovery.

Next is a patch to move all inode fork local to extent conversion
code into the callers that need the coversion, rather than having it
done implicitly by xfs_bmapi_write(). This clarifies the code paths 
that the directory and attribute code are using to do this
conversion by moving it directly into the functions that are doing
the short-form to block conversion.

Finally, there are a series of patches that move directory and
attribute code around to separate kerel only code from shared
userspace/kernel code. This greatly reduces the differences between
the shared files, and will make future userspace code
synchronisation much simpler and easy to do. There's more work to do
here, but this is the low hanging fruit....

Flames, comments, reviews all welcome.

-Dave.

$ git diff --stat --summary -C -M 6cb25a8..
 Documentation/filesystems/xfs.txt |  282 +++++++++++------
 fs/xfs/Makefile                   |    4 +
 fs/xfs/xfs_attr.c                 |  388 +----------------------
 fs/xfs/xfs_attr.h                 |    1 +
 fs/xfs/xfs_attr_inactive.c        |  453 +++++++++++++++++++++++++++
 fs/xfs/xfs_attr_leaf.c            |  643 +------------------------------------
 fs/xfs/xfs_attr_list.c            |  655 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap.c                 |  199 +++++-------
 fs/xfs/xfs_bmap.h                 |    1 +
 fs/xfs/xfs_buf_item.c             |   87 ++++--
 fs/xfs/xfs_buf_item.h             |    4 +-
 fs/xfs/xfs_dir2.c                 |   34 --
 fs/xfs/xfs_dir2.h                 |   71 +++++
 fs/xfs/xfs_dir2_block.c           |  120 +------
 fs/xfs/xfs_dir2_data.c            |    1 +
 fs/xfs/xfs_dir2_format.h          |   24 --
 fs/xfs/xfs_dir2_leaf.c            |  389 +----------------------
 fs/xfs/xfs_dir2_node.c            |    1 +
 fs/xfs/xfs_dir2_priv.h            |   33 +-
 fs/xfs/xfs_dir2_readdir.c         |  661 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dir2_sf.c              |  103 +-----
 fs/xfs/xfs_file.c                 |    3 +-
 fs/xfs/xfs_ialloc.c               |   67 +++-
 fs/xfs/xfs_ialloc.h               |    8 +
 fs/xfs/xfs_icreate_item.c         |  195 ++++++++++++
 fs/xfs/xfs_icreate_item.h         |   52 +++
 fs/xfs/xfs_inode.c                |   68 ++--
 fs/xfs/xfs_iomap.c                |   13 +
 fs/xfs/xfs_itable.c               |    3 +
 fs/xfs/xfs_log.c                  |   21 +-
 fs/xfs/xfs_log.h                  |    5 +-
 fs/xfs/xfs_log_cil.c              |   75 +++--
 fs/xfs/xfs_log_recover.c          |  116 ++++++-
 fs/xfs/xfs_super.c                |    8 +
 fs/xfs/xfs_trace.h                |    4 +
 fs/xfs/xfs_trans.c                |  118 ++++---
 fs/xfs/xfs_trans.h                |    5 +-
 fs/xfs/xfs_trans_buf.c            |   34 +-
 38 files changed, 2865 insertions(+), 2084 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_inactive.c
 create mode 100644 fs/xfs/xfs_attr_list.c
 create mode 100644 fs/xfs/xfs_dir2_readdir.c
 create mode 100644 fs/xfs/xfs_icreate_item.c
 create mode 100644 fs/xfs/xfs_icreate_item.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
