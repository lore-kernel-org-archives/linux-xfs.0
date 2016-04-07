Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DB9FF7CB7
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 18:38:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A21928F8049
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 16:38:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iF8kiVAFjUoA2kzH for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 16:38:48 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aoJVK-00004s-Bo
	for xfs@oss.sgi.com; Fri, 08 Apr 2016 09:38:26 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aoJUo-0006G8-7l
	for xfs@oss.sgi.com; Fri, 08 Apr 2016 09:37:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: xfs_iflush_cluster has range issues
Date: Fri,  8 Apr 2016 09:37:49 +1000
Message-Id: <1460072271-23923-5-git-send-email-david@fromorbit.com>
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

xfs_iflush_cluster() does a gang lookup on the radix tree, meaning
it can find inodes beyond the current cluster if there is sparse
cache population. gang lookups return results in ascending index
order, so stop trying to cluster inodes once the first inode outside
the cluster mask is detected.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_inode.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6598104..b984be4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3194,11 +3194,20 @@ xfs_iflush_cluster(
 		 */
 		spin_lock(&cip->i_flags_lock);
 		if (!cip->i_ino ||
-		    __xfs_iflags_test(ip, XFS_ISTALE) ||
-		    (XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
+		    __xfs_iflags_test(ip, XFS_ISTALE)) {
 			spin_unlock(&cip->i_flags_lock);
 			continue;
 		}
+
+		/*
+		 * Once we fall off the end of the cluster, no point checking
+		 * any more inodes in the list because they will also all be
+		 * outside the cluster.
+		 */
+		if ((XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
+			spin_unlock(&cip->i_flags_lock);
+			break;
+		}
 		spin_unlock(&cip->i_flags_lock);
 
 		/*
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
