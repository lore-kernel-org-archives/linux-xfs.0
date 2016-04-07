Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 195D37CB7
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 18:38:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84ED6AC005
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 16:38:49 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	YPL8LNwsZLmuQqCH for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 16:38:31 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aoJVK-00004r-BR
	for xfs@oss.sgi.com; Fri, 08 Apr 2016 09:38:26 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aoJUo-0006G3-7M
	for xfs@oss.sgi.com; Fri, 08 Apr 2016 09:37:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfs: skip stale inodes in xfs_iflush_cluster
Date: Fri,  8 Apr 2016 09:37:48 +1000
Message-Id: <1460072271-23923-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1460072271-23923-1-git-send-email-david@fromorbit.com>
References: <1460072271-23923-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2718d10..6598104 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3190,10 +3190,11 @@ xfs_iflush_cluster(
 		 * because this is an RCU protected lookup, we could find a
 		 * recently freed or even reallocated inode during the lookup.
 		 * We need to check under the i_flags_lock for a valid inode
-		 * here. Skip it if it is not valid or the wrong inode.
+		 * here. Skip it if it is not valid, stale or the wrong inode.
 		 */
 		spin_lock(&cip->i_flags_lock);
 		if (!cip->i_ino ||
+		    __xfs_iflags_test(ip, XFS_ISTALE) ||
 		    (XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
 			spin_unlock(&cip->i_flags_lock);
 			continue;
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
