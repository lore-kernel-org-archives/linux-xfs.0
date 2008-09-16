Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 22:05:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G552aC002198
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:05:02 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A01C444085
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:06:33 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id F4pHVwKjvdgx3Ucn for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:06:33 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KfSli-0007So-Gj
	for xfs@oss.sgi.com; Tue, 16 Sep 2008 15:06:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] XFS: Track reclaimable inodes in inode cache V2.
Date: Tue, 16 Sep 2008 15:06:25 +1000
Message-Id: <1221541590-28469-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Move the tracking of reclaimable inodes into the inode radix trees.
This currently does not replace the reclaim flags in the inode,
rather it allows traversal of all reclaimable inodes by walking the
per-AG inode radix trees without needing a separate list. This
enables us to remove a struct list_head from the struct xfs_inode
and the xfs_mount, as well as a filesystem global lock which also
has the benefit of removing a point of serialisation during inode
reclaim.

Like the matching sync code, this also allows reclaim of inodes
in ascending inode numbers which substantially improves I/O
patterns during reclaim driven inode flushing.

Version 2:
o reorder series to put all re-arrangement at the start
o rediff as prior patch set was updated
