Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C555D7F6C
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B4A8A8F8033
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:39 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0Li1Os4EW48hP6Be for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:37 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0482-00047t-I5
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:22 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0482-0001wc-Eb
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/49] current patch queue for 3.12
Date: Fri, 19 Jul 2013 16:24:31 +1000
Message-Id: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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

The following mass of patches is my current patch queue I have
pending for the 3.12 cycle. There are 4 main pieces in this:

1. kernel/user libxfs rework
	This is the first 34 patches of the series, and they have
	the single aim of removing all the differences between the
	shared userspace and kernel code. There are several new
	header files created for shared user/kernel definitions to
	remove all the __KERNEL__ sections from our header files.
	The result is about 1500 lines of code in headers files are
	no longer needlessly shared with userspace.

	Similarly, the C code itself is split up in such a ways that
	kernel only functionality is separated from the shared code.
	For example, all the readdir code is moved to
	xfs_dir2_readdir.c, and all the attribute listing code is
	moved to xfs_attr_list.c This means that the files shared
	with userpace are now mostly identical (except for
	#includes) and don't have big diffs when kernel-only code
	was cut out of the userspace versions. The only remaining
	significant differences are in xfs_rtalloc.c (needs
	splitting into kernel only/shared versions) and the generic
	btree code (different tracing in userspace).

2. Log space reservation rework from Jeff Liu
	Rebasing on the above work, and now takes into account the
	log stripe unit when determining the maximum transaction
	reservation size. This will warning if a filesystem config
	is mounted where the log may actually be physically too
	small because old mkfs programs didn't take into account the
	log stripe unit when calculating the minimum size.

3. CIL commit optimisation patchset
	This is a split up version of the RFC patch that has had a
	lot more testing and now doesn't randomly assert fail.

4. Directory entry file type support
	This adds a single byte field into the directory entries
	that indicate the type of inode that the dirent points to.
	This brings XFS up to the same functionality as ext4 and
	btrfs, and enables us to support whiteout dirents for union
	mounts. It also greatly speeds use directory traversals as
	we no longer need to stat every inode to find out which ones
	are subdirectories that need to be walked.

I have one remaining bit of functionality to complete for 3.12, and
that is a new extent swap implementation for CRC enabled
filesystems. I hope to have that complete and ready for review
within a week.

This series will be followed by an xfsprogs patchset that
complements this series to be applied to the crc-dev branch. It
makes all the same changes and gives us the most similar
code base between kernel and userspace that we've had in many, many
years....

Comments, flames, testing and crazy emails all welcome.

Cheers,

Dave.

$ git diff --stat -C -M --summary --minimal 47188d3..3899f80
 fs/xfs/Makefile             |   20 +-
 fs/xfs/xfs_acl.c            |    4 +-
 fs/xfs/xfs_ag.h             |   53 -
 fs/xfs/xfs_alloc.c          |    6 +-
 fs/xfs/xfs_aops.c           |    4 +-
 fs/xfs/xfs_attr.c           |  426 +-----
 fs/xfs/xfs_attr.h           |    9 +
 fs/xfs/xfs_attr_inactive.c  |  453 ++++++
 fs/xfs/xfs_attr_leaf.c      |  655 +-------
 fs/xfs/xfs_attr_leaf.h      |    2 +
 fs/xfs/xfs_attr_list.c      |  655 ++++++++
 fs/xfs/xfs_attr_remote.c    |   18 +-
 fs/xfs/xfs_bmap.c           |  817 +---------
 fs/xfs/xfs_bmap.h           |   56 +-
 fs/xfs/xfs_bmap_btree.c     |    6 +-
 fs/xfs/xfs_bmap_util.c      | 2026 ++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h      |  110 ++
 fs/xfs/xfs_btree.h          |    2 -
 fs/xfs/xfs_buf.c            |    1 +
 fs/xfs/xfs_buf_item.c       |   52 +-
 fs/xfs/xfs_buf_item.h       |  100 +-
 fs/xfs/xfs_da_btree.c       |    8 +-
 fs/xfs/xfs_da_btree.h       |    1 +
 fs/xfs/xfs_dfrag.c          |  459 ------
 fs/xfs/xfs_dfrag.h          |   53 -
 fs/xfs/xfs_dir2.c           |   42 +-
 fs/xfs/xfs_dir2.h           |   45 +
 fs/xfs/xfs_dir2_block.c     |  122 +-
 fs/xfs/xfs_dir2_data.c      |   25 +-
 fs/xfs/xfs_dir2_format.h    |  186 ++-
 fs/xfs/xfs_dir2_leaf.c      |  404 +----
 fs/xfs/xfs_dir2_node.c      |   14 +-
 fs/xfs/xfs_dir2_priv.h      |   49 +-
 fs/xfs/xfs_dir2_readdir.c   |  696 +++++++++
 fs/xfs/xfs_dir2_sf.c        |  240 ++-
 fs/xfs/xfs_discard.c        |    5 +-
 fs/xfs/xfs_dquot.c          |    8 +-
 fs/xfs/xfs_dquot_item.c     |   23 +-
 fs/xfs/xfs_error.c          |    1 -
 fs/xfs/xfs_export.c         |    5 +-
 fs/xfs/xfs_extfree_item.c   |   50 +-
 fs/xfs/xfs_extfree_item.h   |   88 +-
 fs/xfs/xfs_file.c           |    3 +-
 fs/xfs/xfs_filestream.c     |    8 +-
 fs/xfs/xfs_filestream.h     |    4 -
 fs/xfs/xfs_format.h         |  169 ++
 fs/xfs/xfs_fs.h             |   32 +
 fs/xfs/xfs_fsops.c          |    8 +-
 fs/xfs/xfs_ialloc.c         |    3 +-
 fs/xfs/xfs_icache.c         |    3 +-
 fs/xfs/xfs_icache.h         |    7 +
 fs/xfs/xfs_icreate_item.c   |   21 +-
 fs/xfs/xfs_icreate_item.h   |   18 -
 fs/xfs/xfs_inode.c          | 3732 ++++++++++++++++++---------------------------
 fs/xfs/xfs_inode.h          |  312 +---
 fs/xfs/xfs_inode_buf.c      |  444 ++++++
 fs/xfs/xfs_inode_buf.h      |   52 +
 fs/xfs/xfs_inode_fork.c     | 1921 +++++++++++++++++++++++
 fs/xfs/xfs_inode_fork.h     |  171 +++
 fs/xfs/xfs_inode_item.c     |   53 +-
 fs/xfs/xfs_inode_item.h     |  115 +-
 fs/xfs/xfs_ioctl.c          |  113 +-
 fs/xfs/xfs_ioctl.h          |   10 +
 fs/xfs/xfs_ioctl32.c        |    4 +-
 fs/xfs/xfs_iomap.c          |   21 +-
 fs/xfs/xfs_iops.c           |   40 +-
 fs/xfs/xfs_iops.h           |   13 +
 fs/xfs/xfs_linux.h          |   32 +
 fs/xfs/xfs_log.c            |  109 +-
 fs/xfs/xfs_log.h            |   90 +-
 fs/xfs/xfs_log_cil.c        |  369 ++---
 fs/xfs/xfs_log_format.h     |  846 ++++++++++
 fs/xfs/xfs_log_priv.h       |  155 +-
 fs/xfs/xfs_log_recover.c    |   12 +-
 fs/xfs/xfs_log_rlimit.c     |  145 ++
 fs/xfs/xfs_mount.c          |  833 +---------
 fs/xfs/xfs_mount.h          |  113 +-
 fs/xfs/xfs_qm.c             |   13 +-
 fs/xfs/xfs_qm_bhv.c         |    1 +
 fs/xfs/xfs_qm_syscalls.c    |   15 +-
 fs/xfs/xfs_quota.h          |  260 +---
 fs/xfs/xfs_quota_defs.h     |  157 ++
 fs/xfs/xfs_quotaops.c       |    4 +-
 fs/xfs/xfs_rename.c         |  346 -----
 fs/xfs/xfs_rtalloc.c        |   28 +-
 fs/xfs/xfs_rtalloc.h        |   53 +-
 fs/xfs/xfs_sb.c             |  771 ++++++++++
 fs/xfs/xfs_sb.h             |   59 +-
 fs/xfs/xfs_super.c          |    6 +-
 fs/xfs/xfs_symlink.c        |  189 +--
 fs/xfs/xfs_symlink.h        |   41 +-
 fs/xfs/xfs_symlink_remote.c |  200 +++
 fs/xfs/xfs_trace.c          |    1 +
 fs/xfs/xfs_trans.c          |  709 +--------
 fs/xfs/xfs_trans.h          |  293 +---
 fs/xfs/xfs_trans_dquot.c    |    1 +
 fs/xfs/xfs_trans_priv.h     |    3 +
 fs/xfs/xfs_trans_resv.c     |  769 ++++++++++
 fs/xfs/xfs_trans_resv.h     |  116 ++
 fs/xfs/xfs_types.h          |   60 +-
 fs/xfs/xfs_utils.c          |  314 ----
 fs/xfs/xfs_utils.h          |   27 -
 fs/xfs/xfs_vnodeops.c       | 1870 -----------------------
 fs/xfs/xfs_vnodeops.h       |   55 -
 fs/xfs/xfs_xattr.c          |    2 +-
 105 files changed, 12629 insertions(+), 11714 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_inactive.c
 create mode 100644 fs/xfs/xfs_attr_list.c
 create mode 100644 fs/xfs/xfs_bmap_util.c
 create mode 100644 fs/xfs/xfs_bmap_util.h
 delete mode 100644 fs/xfs/xfs_dfrag.c
 delete mode 100644 fs/xfs/xfs_dfrag.h
 create mode 100644 fs/xfs/xfs_dir2_readdir.c
 create mode 100644 fs/xfs/xfs_format.h
 create mode 100644 fs/xfs/xfs_inode_buf.c
 create mode 100644 fs/xfs/xfs_inode_buf.h
 create mode 100644 fs/xfs/xfs_inode_fork.c
 create mode 100644 fs/xfs/xfs_inode_fork.h
 create mode 100644 fs/xfs/xfs_log_format.h
 create mode 100644 fs/xfs/xfs_log_rlimit.c
 create mode 100644 fs/xfs/xfs_quota_defs.h
 delete mode 100644 fs/xfs/xfs_rename.c
 create mode 100644 fs/xfs/xfs_sb.c
 create mode 100644 fs/xfs/xfs_symlink_remote.c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
