Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 59AAD7CA0
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 00:32:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1CB9930405F
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 22:32:22 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GQvyzGSDQ7iRGONV for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 22:32:20 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aqDPP-0003p4-Rz
	for xfs@oss.sgi.com; Wed, 13 Apr 2016 15:32:11 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aqDOq-0000bs-C6
	for xfs@oss.sgi.com; Wed, 13 Apr 2016 15:31:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/11] xfs: skip stale inodes in xfs_iflush_cluster
Date: Wed, 13 Apr 2016 15:31:25 +1000
Message-Id: <1460525492-1170-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1460525492-1170-1-git-send-email-david@fromorbit.com>
References: <1460525492-1170-1-git-send-email-david@fromorbit.com>
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

We don't write back stale inodes so we should skip them in
xfs_iflush_cluster, too.

cc: <stable@vger.kernel.org> # 3.10.x-
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e302f11..ad0ad8d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3194,6 +3194,7 @@ xfs_iflush_cluster(
 		 */
 		spin_lock(&iq->i_flags_lock);
 		if (!iq->i_ino ||
+		    __xfs_iflags_test(iq, XFS_ISTALE) ||
 		    (XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) != first_index) {
 			spin_unlock(&iq->i_flags_lock);
 			continue;
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
