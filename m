Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 997C78014
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F19E5AC001
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:33 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	sPXm3TmfMmG38MgG for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:31 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RS-0004I3-Ib
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RS-0002J4-HQ
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/49] xfsprogs: patches for crc-dev branch
Date: Fri, 19 Jul 2013 16:44:35 +1000
Message-Id: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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

This series is the matching patch series to my for-3.12 kernel
series posted here:

http://oss.sgi.com/pipermail/xfs/2013-July/028207.html

The first 3 patches add icreate transaction support to xfs_logprint.

The next 37 patches update the libxfs code to match the kernel code
in the above patch set - many of the transformations are identical,
and they bring the code bases mostly into synchronisation.

The next 6 patches introduce jeff Liu's transaciton reservation
patchset and integrate it into mkfs to ensure that mkfs.xfs doesn't
create logs that are too small. This version has the "default log
size larger than the AG size so mkfs fails" problems fixed, so all
the xfstests regressions it caused are gone.

THe last 3 patches introduce dirent filetype support into libxfs,
mkfs and xfs_db. xfs_repair can handle the new dirent structures
just fine, but it doesn't yet have code to validate that the
filetype in the dirent matches the inode it points to.

Anyway, this applies to a current crc-dev branch, and should compile
cleanly without warnings. If you do get warnings, let me know,
because I'm getting ready to a -Werror to the build so that it
breaks whenever someone introduces a compile time warning....

Comments, thoughts, flames?

Cheers,

Dave.

$ git diff --stat -C -M --summary --minimal cdc4cb9..
 copy/xfs_copy.c                                |  12 +-
 db/bmroot.c                                    |   6 +-
 db/check.c                                     |  12 +-
 db/dir2.c                                      |  51 +-
 db/dir2.h                                      |   1 +
 db/dir2sf.c                                    |  61 ++-
 db/dir2sf.h                                    |   3 +
 db/field.c                                     |   7 +
 db/field.h                                     |   3 +
 db/inode.c                                     |  23 +-
 db/metadump.c                                  |  10 +-
 fsr/xfs_fsr.c                                  |   1 -
 include/Makefile                               |  24 +-
 include/libxfs.h                               |  98 +++-
 include/libxlog.h                              |  13 -
 include/platform_defs.h.in                     |   5 +
 include/swab.h                                 |   6 +-
 include/xfs_ag.h                               |  55 +-
 include/xfs_alloc_btree.h                      |   3 +-
 include/xfs_attr_leaf.h                        |   1 +
 include/xfs_attr_remote.h                      |  28 +-
 include/xfs_bmap.h                             |  54 +-
 include/xfs_bmap_btree.h                       |   5 +-
 include/xfs_btree.h                            |   3 +-
 include/xfs_buf_item.h                         | 172 ------
 include/xfs_da_btree.h                         |   1 +
 include/xfs_dfrag.h                            |  53 --
 include/xfs_dinode.h                           |   3 -
 include/xfs_dir2.h                             |  20 +-
 include/xfs_dir2_format.h                      | 208 +++++--
 include/xfs_extfree_item.h                     | 161 ------
 include/xfs_format.h                           | 169 ++++++
 include/xfs_fs.h                               |  41 +-
 include/xfs_ialloc.h                           |   8 +
 include/xfs_ialloc_btree.h                     |   3 +-
 include/xfs_inode.h                            | 631 ----------------------
 include/xfs_inode_buf.h                        |  52 ++
 include/xfs_inode_fork.h                       | 171 ++++++
 include/xfs_inode_item.h                       | 170 ------
 include/xfs_log.h                              | 189 -------
 include/xfs_log_format.h                       | 773 +++++++++++++++++++++++++++
 include/xfs_log_priv.h                         | 692 ------------------------
 include/xfs_mount.h                            | 403 --------------
 include/xfs_quota.h                            | 393 --------------
 include/xfs_quota_defs.h                       | 157 ++++++
 include/xfs_rtalloc.h                          | 166 ------
 include/xfs_sb.h                               |  58 +-
 include/xfs_symlink.h                          |  45 --
 include/xfs_trace.h                            |   1 +
 include/xfs_trans.h                            | 224 +-------
 include/xfs_trans_resv.h                       | 116 ++++
 include/xfs_types.h                            |  59 +-
 io/init.h                                      |   3 -
 libxfs/Makefile                                |  34 +-
 libxfs/init.c                                  |   5 +-
 libxfs/rdwr.c                                  |   3 -
 libxfs/trans.c                                 | 130 ++++-
 libxfs/util.c                                  | 122 ++++-
 libxfs/xfs.h                                   |  62 ++-
 libxfs/xfs_alloc.c                             |  37 +-
 libxfs/xfs_alloc_btree.c                       |  23 +-
 libxfs/xfs_attr.c                              |  39 +-
 libxfs/xfs_attr_leaf.c                         |   9 +-
 libxfs/xfs_attr_remote.c                       |   8 +-
 libxfs/xfs_bmap.c                              | 438 ++++-----------
 libxfs/xfs_bmap_btree.c                        |  14 +-
 libxfs/xfs_btree.c                             |  10 +
 libxfs/xfs_da_btree.c                          |  69 +--
 libxfs/xfs_dir2.c                              |  50 +-
 libxfs/xfs_dir2_block.c                        |  44 +-
 libxfs/xfs_dir2_data.c                         |  39 +-
 libxfs/xfs_dir2_leaf.c                         |  17 +-
 libxfs/xfs_dir2_node.c                         |  43 +-
 libxfs/xfs_dir2_priv.h                         |  44 +-
 libxfs/xfs_dir2_sf.c                           | 141 +++--
 libxfs/xfs_ialloc.c                            | 271 ++++++++--
 libxfs/xfs_ialloc_btree.c                      |  16 +-
 libxfs/xfs_inode_buf.c                         | 408 ++++++++++++++
 libxfs/{xfs_inode.c => xfs_inode_fork.c}       | 425 +--------------
 libxfs/xfs_log_rlimit.c                        | 135 +++++
 libxfs/xfs_rtalloc.c                           |   6 +-
 libxfs/{xfs_mount.c => xfs_sb.c}               | 118 +++-
 libxfs/{xfs_symlink.c => xfs_symlink_remote.c} |  52 +-
 libxfs/{xfs_trans.c => xfs_trans_resv.c}       | 379 +++++++------
 libxlog/xfs_log_recover.c                      |   3 +
 logprint/log_misc.c                            |  94 +++-
 logprint/log_print_all.c                       |  21 +
 mkfs/maxtrres.c                                |  58 +-
 mkfs/proto.c                                   |  24 +-
 mkfs/xfs_mkfs.c                                | 107 ++--
 mkfs/xfs_mkfs.h                                |   4 +-
 repair/attr_repair.c                           |   2 +
 repair/dir2.c                                  |  37 +-
 repair/dir2.h                                  |   1 +
 repair/incore_ino.c                            |   2 +
 repair/phase5.c                                |   3 +-
 repair/phase6.c                                | 111 ++--
 repair/phase7.c                                |   7 +-
 repair/scan.c                                  |   1 +
 99 files changed, 4251 insertions(+), 5042 deletions(-)
 delete mode 100644 include/xfs_buf_item.h
 delete mode 100644 include/xfs_dfrag.h
 delete mode 100644 include/xfs_extfree_item.h
 create mode 100644 include/xfs_format.h
 delete mode 100644 include/xfs_inode.h
 create mode 100644 include/xfs_inode_buf.h
 create mode 100644 include/xfs_inode_fork.h
 delete mode 100644 include/xfs_inode_item.h
 delete mode 100644 include/xfs_log.h
 create mode 100644 include/xfs_log_format.h
 delete mode 100644 include/xfs_log_priv.h
 delete mode 100644 include/xfs_mount.h
 delete mode 100644 include/xfs_quota.h
 create mode 100644 include/xfs_quota_defs.h
 delete mode 100644 include/xfs_rtalloc.h
 delete mode 100644 include/xfs_symlink.h
 create mode 100644 include/xfs_trans_resv.h
 create mode 100644 libxfs/xfs_inode_buf.c
 rename libxfs/{xfs_inode.c => xfs_inode_fork.c} (82%)
 create mode 100644 libxfs/xfs_log_rlimit.c
 rename libxfs/{xfs_mount.c => xfs_sb.c} (87%)
 rename libxfs/{xfs_symlink.c => xfs_symlink_remote.c} (68%)
 rename libxfs/{xfs_trans.c => xfs_trans_resv.c} (67%)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
