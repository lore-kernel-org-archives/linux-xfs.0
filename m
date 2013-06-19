Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E85CE7FB2
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:36:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 83D49AC009
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:36:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	naB0nCepJGNVUGTl for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:36:25 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB44-0003AH-6l
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:16 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB44-0000DR-22
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/50] xfsprogs: patch queue for crc-dev
Date: Wed, 19 Jun 2013 15:35:23 +1000
Message-Id: <1371620173-712-1-git-send-email-david@fromorbit.com>
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

This is the latest patchset for the crc-dev branch of xfsprogs.
It follows up on the last series of 22 patches to get libxf sin sync
with the kernel code but adding all the changes from the kernel size
to remove __KERNEL__ from the code. Hence there's a fair bit more
code churn in the patch set, but overall the diffstat is a
significant reduction in code in libxfs. Like the kernel side
patchset, there is a lot of new files that are shared with the
kernel, and the diffstat reflects that:

90 files changed, 3573 insertions(+), 4863 deletions(-)
 rename include/{xfs_buf_item.h => xfs_buf_item_format.h} (62%)
 delete mode 100644 include/xfs_dfrag.h
 create mode 100644 include/xfs_dquot_format.h
 rename include/{xfs_extfree_item.h => xfs_extfree_item_format.h} (69%)
 create mode 100644 include/xfs_icreate_item.h
 create mode 100644 include/xfs_icreate_item_format.h
 delete mode 100644 include/xfs_inode.h
 create mode 100644 include/xfs_inode_buf.h
 create mode 100644 include/xfs_inode_fork.h
 rename include/{xfs_inode_item.h => xfs_inode_item_format.h} (61%)
 delete mode 100644 include/xfs_log.h
 create mode 100644 include/xfs_log_format.h
 delete mode 100644 include/xfs_log_priv.h
 delete mode 100644 include/xfs_mount.h
 delete mode 100644 include/xfs_quota.h
 create mode 100644 include/xfs_quota_defs.h
 delete mode 100644 include/xfs_rtalloc.h
 create mode 100644 include/xfs_rtalloc_defs.h
 delete mode 100644 include/xfs_symlink.h
 create mode 100644 include/xfs_symlink_remote.h
 delete mode 100644 include/xfs_trans.h
 create mode 100644 include/xfs_trans_format.h
 create mode 100644 include/xfs_trans_resv.h
 create mode 100644 libxfs/xfs_inode_buf.c
 rename libxfs/{xfs_inode.c => xfs_inode_fork.c} (82%)
 create mode 100644 libxfs/xfs_log_rlimit.c
 rename libxfs/{xfs_mount.c => xfs_sb.c} (94%)
 rename libxfs/{xfs_symlink.c => xfs_symlink_remote.c} (68%)
 rename libxfs/{xfs_trans.c => xfs_trans_resv.c} (67%)

Overall, it's a significant reduction in the amount of code, and it
cleans up quite a bit of the nasty header file dependency issues as
the majority of the new shared header files are not dependent on
each other. Having header files like xfs_mount.h, xfs_trans.h,
xfs_log.h and xfs_log_priv.h no longer present in userspace makes a
big difference to the clarity of the libxfs header files...

The only other major addition to the series is Jeff Liu's
log reservation calculation patchset, which allows mkfs to calculate
the minmum log size based on log reservation sizes rather than
transaction reservation sizes. This causes a significant increase in
the default size of the log for small filesystems - many xfstests now
fail because the default log size doesn't fit inside a 16MB
AG anymore. Hence mkfs will need some further tweaking here to avoid
those failures. xfs/216 gives a pretty good overview of the
difference in default sizes:

 QA output created by 216
-fssize=1g log      =internal log           bsize=4096   blocks=2560, version=2
-fssize=2g log      =internal log           bsize=4096   blocks=2560, version=2
-fssize=4g log      =internal log           bsize=4096   blocks=2560, version=2
-fssize=8g log      =internal log           bsize=4096   blocks=2560, version=2
-fssize=16g log      =internal log           bsize=4096   blocks=2560, version=2
-fssize=32g log      =internal log           bsize=4096   blocks=4096, version=2
+fssize=1g log      =internal log           bsize=4096   blocks=4896, version=2
+fssize=2g log      =internal log           bsize=4096   blocks=4896, version=2
+fssize=4g log      =internal log           bsize=4096   blocks=4896, version=2
+fssize=8g log      =internal log           bsize=4096   blocks=4896, version=2
+fssize=16g log      =internal log           bsize=4096   blocks=4896, version=2
+fssize=32g log      =internal log           bsize=4096   blocks=4896, version=2
 fssize=64g log      =internal log           bsize=4096   blocks=8192, version=2

Which indicate worst case log reservation is roughly 2x larger than
the worst case transaction reservation for small filesystems. I'm
surprised that we haven't had more problems with this in the past
than we have...

Thoughts, comments, flames?

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
