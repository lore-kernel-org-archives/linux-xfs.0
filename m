Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 51F887F4E
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 18:37:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2392B8F8040
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 16:37:20 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jxLE28UcqLA1RBJ2 for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 16:37:18 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQQY1-0005z9-G7
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 09:37:09 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQQY1-0003WN-FL
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 09:37:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: open code inc_inode_iversion when logging an inode
Date: Mon, 30 Sep 2013 09:37:06 +1000
Message-Id: <1380497826-13474-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1380497826-13474-1-git-send-email-david@fromorbit.com>
References: <1380497826-13474-1-git-send-email-david@fromorbit.com>
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

Michael L Semon reported that generic/069 runtime increased on v5
superblocks by 100% compared to v4 superblocks. his perf-based
analysis pointed directly at the timestamp updates being done by the
write path in this workload. The append writers are doing 4-byte
writes, so there are lots of timestamp updates occurring.

The thing is, they aren't being triggered by timestamp changes -
they are being triggered by the inode change counter needing to be
updated. That is, every write(2) system call needs to bump the inode
version count, and it does that through the timestamp update
mechanism. Hence for v5 filesystems, test generic/069 is running 3
orders of magnitude more timestmap update transactions on v5
filesystems due to the fact it does a huge number of *4 byte*
write(2) calls.

This isn't a real world scenario we really need to address - anyone
doing such sequential IO should be using fwrite(3), not write(2).
i.e. fwrite(3) buffers the writes in userspace to minimise the
number of write(2) syscalls, and the problem goes away.

However, there is a small change we can make to improve the
situation - removing the expensive lock operation on the change
counter update.  All inode version counter changes in XFS occur
under the ip->i_ilock during a transaction, and therefore we
don't actually need the spin lock that provides exclusive access to
it through inc_inode_iversion().

Hence avoid the lock and just open code the increment ourselves when
logging the inode.

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 53dfe46..e6601c1 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -118,8 +118,7 @@ xfs_trans_log_inode(
 	 */
 	if (!(ip->i_itemp->ili_item.li_desc->lid_flags & XFS_LID_DIRTY) &&
 	    IS_I_VERSION(VFS_I(ip))) {
-		inode_inc_iversion(VFS_I(ip));
-		ip->i_d.di_changecount = VFS_I(ip)->i_version;
+		ip->i_d.di_changecount = ++VFS_I(ip)->i_version;
 		flags |= XFS_ILOG_CORE;
 	}
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
