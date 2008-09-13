Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 07:09:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DE95tE016907
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:09:12 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F5D81ADE15B
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:10:35 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id XPg00LuXEbtFB4EA for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:10:35 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] XFS: Combine Linux and XFS inodes
Date: Sun, 14 Sep 2008 00:10:24 +1000
Message-Id: <1221315027-29951-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

XFS currently has to deal with two separate inode lifecycles
which makes for complexity in inode lookups and reclaim. We
also have the problem of not always having a linux inode around
when it might be useful to have it.

To avoid these lifecycle problems, this series embedѕ the linux
inode inside the struct xfs_inode and changes the way we reference
the two inodes. We can no longer check for a null linux inode -
instead we have to check to see if it is valid or not by checking
either the linux inode or xfs inode state flags. While this means
that inodes waiting for reclaim use more memory, this is not the
common state for inodes and they will soon be completely freed so
the additional memeory use in this state is only temporary.

This combining of the inodes simplifies the inode and reclaim logic,
making it possible to do reclaim via radix tree tags (an upcoming
patch series) and to be able to use RCU locking on the radix trees.
The fact that we don't have a simple mechanism to determine the
reclaim state of the inode makes RCU locking very complex, and this
complexity is removed by having a combined inode structure.

This patch series also changes the way XFS caches inodes. It no
longer uses the linux inode cache as the primary lookup cache -
instead we rely solely on the XFS inode caches. This avoids the
inode_lock in lookups that hit the cache - we should get much
better parallelism out of inode lookup than we currently do now.

In future, we should also be able to cull duplicate fields out of
the xfs and linux inodes reducing the overall memory usage of
the active inode cache. This provides scope for continuing to
reduce the memory footprint of the XFS inode cache.
