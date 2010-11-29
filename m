Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT0nXeB074621 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 18:49:34 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 271F513DF6D6
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 16:51:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	AVpXLBPfe4bW9GSF for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 16:51:13 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: RCU inode freeing and lookups V2
Date: Mon, 29 Nov 2010 11:50:24 +1100
Message-Id: <1290991826-20714-1-git-send-email-david@fromorbit.com>
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

This series converts the XFS inode cache to use SLAB_DESTROY_BY_RCU
for freeing of the inodes and uses RCU locking for all the lookups.
It uses the ip->i_ino values and ip->i_flags & XFS_IRECLAIM being
checked under the ip->i_flags_lock to detect inodes that have been
freed during lookups.

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
