Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jul 2008 05:18:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6KCInvU019355
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 05:18:49 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C1BEE63FE5
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 05:19:57 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id AuCeePSjt5UmH7vR for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 05:19:57 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KKXtK-0006cT-IA
	for xfs@oss.sgi.com; Sun, 20 Jul 2008 22:19:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] XFS: replace the mount inode list with radix tree traversals
Date: Sun, 20 Jul 2008 22:19:50 +1000
Message-Id: <1216556394-17529-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The list of all inodes on a mount is superfluous. We can traverse
all inodes now by walking the per-AG inode radix trees without
needing a separate list. This enables us to remove a bunch of
complex list traversal code and remove another two pointers from
the xfs_inode.

Also, by replacing the sync traversal with an ascending inode
number traversal, we will issue better inode I/O patterns for
writeback triggered by xfssyncd or unmount.

Diffstat for the change:

 xfs/quota/xfs_qm_syscalls.c |  120 ++++++--------
 xfs/xfs_iget.c              |   42 -----
 xfs/xfs_inode.c             |   39 ----
 xfs/xfs_inode.h             |   11 -
 xfs/xfs_mount.c             |    7
 xfs/xfs_mount.h             |    1
 xfs/xfs_vfsops.c            |  366 ++++++++++++--------------------------------
 xfs/xfs_vnodeops.c          |   42 ++---
 8 files changed, 176 insertions(+), 452 deletions(-)
