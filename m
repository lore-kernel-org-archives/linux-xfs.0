Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB7817FD5
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:37:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC5D9304043
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:37:00 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Ow4deSX4jiCawXIb for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:36:58 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiPt-0001BC-4z
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:37 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiPs-0006mS-V0
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/22] xfsprogs: sync up with 3.11 kernel code
Date: Wed, 12 Jun 2013 20:36:12 +1000
Message-Id: <1371033394-26006-1-git-send-email-david@fromorbit.com>
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

This is the xfsprogs patchset that goes along with the 3.11 kernel
code patchset I just posted. It introduces all the support needed for
the new icreate transaction, and syncs all the header and c files to
the kernel code that has been modified to minimise the diffs between
kernel and userspace. It also fixes all the outstanding compile
warnigns I get here.

A benefit of the sync-up with the kernel code is that all the fixes
made to the kernel that were missed from the userspace code have now
been picked up.

This patchset is built on top of the current crc-dev branch of the
git://oss.sgi.com/xfs/cmds/xfsprogs.git repository. It is not
dependent on the 3.11 kernel changes, so will work just fine on a
kernel 3.10 kernel as well.

Ben, is is possible to get this committed quickly to the crc-dev
branch so that people don't have to find the latest patch set to
keep up with what I'm doing?

Comments, thoughts, flames, testing?

Cheers,

Dave.

$ git diff --stat --summary -C -M 94edda8..
 copy/xfs_copy.c                          |   12 +-
 db/bmroot.c                              |    6 +-
 include/Makefile                         |    6 +-
 include/libxfs.h                         |   38 ++-
 include/libxlog.h                        |    1 +
 include/platform_defs.h.in               |    5 +
 include/swab.h                           |    6 +-
 include/xfs_ag.h                         |    2 +-
 include/xfs_alloc_btree.h                |    3 +-
 include/xfs_attr_leaf.h                  |    1 +
 include/xfs_attr_remote.h                |   28 +--
 include/xfs_bmap.h                       |   15 +-
 include/xfs_bmap_btree.h                 |    3 +-
 include/xfs_btree.h                      |    3 +-
 include/xfs_buf_item.h                   |    4 +-
 include/xfs_dir2.h                       |   34 ++-
 include/xfs_dir2_format.h                |   39 +---
 include/xfs_extfree_item.h               |   14 +-
 include/xfs_fs.h                         |   26 ++-
 include/xfs_ialloc.h                     |    8 +
 include/xfs_ialloc_btree.h               |    3 +-
 include/xfs_icreate_item.h               |   56 +++++
 include/xfs_inode.h                      |  339 +--------------------------
 include/xfs_log.h                        |    5 +-
 include/xfs_log_priv.h                   |    1 -
 include/xfs_mount.h                      |  403 --------------------------------
 include/xfs_quota.h                      |    2 +
 include/xfs_sb.h                         |   19 ++
 include/xfs_symlink.h                    |   22 ++
 include/xfs_trace.h                      |    1 +
 include/xfs_trans.h                      |   91 +-------
 include/xfs_trans_resv.h                 |  135 +++++++++++
 io/init.h                                |    3 -
 libxfs/Makefile                          |    4 +-
 libxfs/init.c                            |    2 +-
 libxfs/rdwr.c                            |    1 -
 libxfs/trans.c                           |  118 ++++++++++
 libxfs/xfs.h                             |   23 +-
 libxfs/xfs_alloc.c                       |   31 ++-
 libxfs/xfs_alloc_btree.c                 |   23 +-
 libxfs/xfs_attr.c                        |    6 +-
 libxfs/xfs_attr_leaf.c                   |   50 ++--
 libxfs/xfs_attr_remote.c                 |    8 +-
 libxfs/xfs_bmap.c                        |  212 +++++++----------
 libxfs/xfs_bmap_btree.c                  |   14 +-
 libxfs/xfs_btree.c                       |   10 +
 libxfs/xfs_da_btree.c                    |   69 +++---
 libxfs/xfs_dir2.c                        |   45 ++++
 libxfs/xfs_dir2_block.c                  |   19 +-
 libxfs/xfs_dir2_data.c                   |   20 +-
 libxfs/xfs_dir2_leaf.c                   |    4 +-
 libxfs/xfs_dir2_node.c                   |   32 +--
 libxfs/xfs_ialloc.c                      |  266 ++++++++++++++++++---
 libxfs/xfs_ialloc_btree.c                |   16 +-
 libxfs/xfs_inode.c                       |  170 +++++++-------
 libxfs/xfs_rtalloc.c                     |    4 +-
 libxfs/{xfs_mount.c => xfs_sb.c}         |   61 ++++-
 libxfs/xfs_symlink.c                     |   29 +++
 libxfs/{xfs_trans.c => xfs_trans_resv.c} |  314 ++++++++++++-------------
 logprint/log_misc.c                      |   36 +++
 logprint/log_print_all.c                 |   21 ++
 mkfs/maxtrres.c                          |    8 +-
 repair/attr_repair.c                     |    2 +
 repair/incore_ino.c                      |    2 +
 repair/scan.c                            |    1 +
 65 files changed, 1483 insertions(+), 1472 deletions(-)
 create mode 100644 include/xfs_icreate_item.h
 delete mode 100644 include/xfs_mount.h
 create mode 100644 include/xfs_trans_resv.h
 rename libxfs/{xfs_mount.c => xfs_sb.c} (94%)
 rename libxfs/{xfs_trans.c => xfs_trans_resv.c} (79%)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
