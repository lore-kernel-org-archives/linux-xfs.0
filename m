Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B61D329E10
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 01:38:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 93B598F8033
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 23:38:55 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	toZaMzCtptrILUoX for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 23:38:54 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ugr4p-0008Fn-Sr
	for xfs@oss.sgi.com; Mon, 27 May 2013 16:38:39 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ugr4p-0003xP-PE
	for xfs@oss.sgi.com; Mon, 27 May 2013 16:38:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/9] xfs: disable swap extents ioctl on CRC enabled filesystems
Date: Mon, 27 May 2013 16:38:24 +1000
Message-Id: <1369636707-15150-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1369636707-15150-1-git-send-email-david@fromorbit.com>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
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

Currently, swapping extents from one inode to another is a simple
act of switching data and attribute forks from one inode to another.
This, unfortunately in no longer so simple with CRC enabled
filesystems as there is owner information embedded into the BMBT
blocks that are swapped between inodes. Hence swapping the forks
between inodes results in the inodes having mapping blocks that
point to the wrong owner and hence are considered corrupt.

To fix this we need an extent tree block or record based swap
algorithm so that the BMBT block owner information can be updated
atomically in the swap transaction. This is a significant piece of
new work, so for the moment simply don't allow swap extent
operations to succeed on CRC enabled filesystems.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dfrag.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index f852b08..c407e1c 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -219,6 +219,14 @@ xfs_swap_extents(
 	int		taforkblks = 0;
 	__uint64_t	tmp;
 
+	/*
+	 * We have no way of updating owner information in the BMBT blocks for
+	 * each inode on CRC enabled filesystems, so to avoid corrupting the
+	 * this metadata we simply don't allow extent swaps to occur.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		return XFS_ERROR(EINVAL);
+
 	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
 	if (!tempifp) {
 		error = XFS_ERROR(ENOMEM);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
