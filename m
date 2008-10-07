Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:53:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97Lr3U3005427
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:53:03 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 073504C633A
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:54:43 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id fljdH5SkHWFcBmiF for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:54:43 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKVs-00022W-99
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:54:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] XFS: Track reclaimable inodes in inode cache
Date: Wed,  8 Oct 2008 08:54:34 +1100
Message-Id: <1223416480-7701-1-git-send-email-david@fromorbit.com>
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
o clean up series based on review comments
o added bug fix to prevent looping when we overflow the AG
  inode number index (fixes sync code as well).
