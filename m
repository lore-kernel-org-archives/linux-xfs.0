Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD1X9Jn148789 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 19:33:09 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD56A1CBC360
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 17:34:59 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	pX4pS3cIjqB5HWyi for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 17:34:59 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: RCU inode freeing and lookups V3
Date: Mon, 13 Dec 2010 12:32:34 +1100
Message-Id: <1292203957-15819-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: paulmck@linux.vnet.ibm.com, eric.dumazet@gmail.com

This series converts the XFS inode cache to use RCU freeing
for freeing of the inodes and uses RCU locking for all the lookups.
It uses the ip->i_ino values and ip->i_flags & XFS_IRECLAIM being
checked under the ip->i_flags_lock to detect inodes that have been
freed during lookups.

Version 3:
- add patch for specific RCU freeing of inodes rather than relying
  on an external tree to provide RCU freeing functionality. This
  uses standard RCU freeing mechanisms rather than
  SLAB_DESTROY_BY_RCU. This is kept as a separate patch to minimise
  the merge conflict issues that may arise if the change is made
  through VFS code first.
- Drop specific references to SLAB_DESTROY_BY_RCU, but keep all the
  lookup guards for reclaimed/reused inodes as they are mostly the
  same for both methods of RCU inode freeing.

Version 2:
- check ip->i_ino under i_flags lock on cache hit
- remove duplicate ip->i_ino == 0 check in xfs_dqrele_inode
- Fixed inode cluster walks to check for valid i_ino under
  i_flags_lock.
- Fixed ag walk lookups to check i_ino under i_flags_lock.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
