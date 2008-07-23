Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 17:40:14 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N0e7nY026470
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 17:40:07 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B85B191C93A
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 17:41:16 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id PVA8CMCGWjD9UPfA for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 17:41:16 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KLSPp-0000y6-SL
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 10:41:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] XFS: replace the mount inode list with radix tree traversals V2
Date: Wed, 23 Jul 2008 10:41:09 +1000
Message-Id: <1216773673-3620-1-git-send-email-david@fromorbit.com>
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
