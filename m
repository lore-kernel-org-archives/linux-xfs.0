Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jul 2008 05:42:51 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6KCghqn022200
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 05:42:44 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8EBF1905F6A
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 05:43:51 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id lOxy4l9qH8oj2ODl for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 05:43:51 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KKYGT-0007ib-1F
	for xfs@oss.sgi.com; Sun, 20 Jul 2008 22:43:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] XFS: sanitise VFS inode extraction
Date: Sun, 20 Jul 2008 22:43:45 +1000
Message-Id: <1216557828-29056-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Getting the VFS inode from the XFS inode is done in a variety of
ways right now - direct deference or one of two XFS_ITOV macros.
This should be consiѕtent throughout the code - this patch
series does that in a way that is consistent with the opposite
XFS_I() conversion. We now use VFS_I() to extract the VFS inode
from the XFS inode.

Diffstat:

 xfs/linux-2.6/xfs_export.c  |    6 +++---
 xfs/linux-2.6/xfs_fs_subr.c |    6 +++---
 xfs/linux-2.6/xfs_ioctl.c   |    4 ++--
 xfs/linux-2.6/xfs_iops.c    |   16 ++++++++--------
 xfs/linux-2.6/xfs_iops.h    |    6 ------
 xfs/linux-2.6/xfs_linux.h   |    2 +-
 xfs/linux-2.6/xfs_lrw.c     |    2 +-
 xfs/linux-2.6/xfs_super.c   |    6 +++---
 xfs/linux-2.6/xfs_vnode.c   |    2 +-
 xfs/quota/xfs_dquot.c       |    2 +-
 xfs/quota/xfs_qm_syscalls.c |    2 +-
 xfs/xfs_bmap.c              |    2 +-
 xfs/xfs_dfrag.c             |    4 ++--
 xfs/xfs_iget.c              |    7 ++++---
 xfs/xfs_inode.c             |    4 ++--
 xfs/xfs_inode.h             |   24 +++++++++++++++++++-----
 xfs/xfs_itable.c            |    2 +-
 xfs/xfs_utils.c             |    4 ++--
 xfs/xfs_utils.h             |    4 ++--
 xfs/xfs_vfsops.c            |   10 +++++-----
 xfs/xfs_vnodeops.c          |   12 ++++++------
 21 files changed, 68 insertions(+), 59 deletions(-)
