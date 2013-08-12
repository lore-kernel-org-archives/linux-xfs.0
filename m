Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7FE027F81
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3909D8F8059
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:50 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8COCBlzQ21PoF7v2 for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:48 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xt-To
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007MO-SX
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 11/17] xfs: factor xfs_create to
	prepare for O_TMPFILE
Date: Mon, 12 Aug 2013 23:20:01 +1000
Message-Id: <1376313607-28133-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1376313607-28133-1-git-send-email-david@fromorbit.com>
References: <1376313607-28133-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

O_TMPFILE support requires allocating an inode that is not attached to the
a current namespace - it's anonymous. The current inode allocation code runs
through xfs_create() which requires a parent inode and a name to be passed to
it. for O_TMPFILE, we do not have a parent inode or a name so we cannot use
the same calling conventions as xfs_create() to allocate a inode.

In this case, the inode is anonymous, so it is a property of the allocation
group it is allocated to, not the namespace. Hence all we really need to pass
from the VFS is a struct xfs_mount and the struct xfs_inode pointer that we
return the allocated inode in.

The allocation of the inode requires a different log reservation to mkdir/create
as there is no directory modification taking place, though we still need to
reserve/account quotas appropriately. We do not need to check if we can add the
entry to the directory, either.

Hence the majority of the inode allocation code is similar to that in
xfs_create, and so can be factored out of xfs_create() and reused.

The fact that a parent inode does not exist follows into xfs_dir_ialloc() and
xfs_ialloc(), too. xfs_dir_ialloc() does not actually use the parent inode, just
passes it through to xfs_ialloc(). xfs_ialloc() can handle a null parent inode,
but it results in a target inode number of 0 and so allocation will always
target AG 0, This will effectively serialise O_TMPFILE allocation and removal.

Hence we should separate the parent inode from the allocation target inode all
the way down to xfs_dialloc() while factoring this code. This will allow us to
use a separate AG rotor to direct allocation of temporary files around different
AGs, allowing them to the allocated and removed concurrently.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 96dda62..9c20a2c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -112,6 +112,7 @@ xfs_cleanup_inode(
 	iput(inode);
 }
 
+/* how much of this does tmpfile need? */
 STATIC int
 xfs_vn_mknod(
 	struct inode	*dir,
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
