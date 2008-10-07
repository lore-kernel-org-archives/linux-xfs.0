Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:39:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97LdsXk030953
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:39:55 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D67BC129BB4C
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:41:34 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id D31xwmk3UIgyPmAR for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:41:34 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKJA-0001g4-If
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:41:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] XFS: replace the mount inode list with radix tree traversals
Date: Wed,  8 Oct 2008 08:41:26 +1100
Message-Id: <1223415692-6354-1-git-send-email-david@fromorbit.com>
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

Before we make this change, move all the relevant sync code
into it's own file in the linux-2.6/ directory. This aggregates
VFS specific sync interfacing in the one file and will allow
all the subsequent change history to be associated with this
file so it is easy to find in future.
