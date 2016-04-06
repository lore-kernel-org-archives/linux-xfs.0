Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F6C27CA1
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 04:23:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 727CB8F8039
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 02:23:42 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	832iIJpD1LiMc3sK for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 02:23:38 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1anjgP-0004C5-3F
	for xfs@oss.sgi.com; Wed, 06 Apr 2016 19:23:29 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1anjft-0006iq-WB
	for xfs@oss.sgi.com; Wed, 06 Apr 2016 19:22:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] xfs: xfs_iflush_cluster has range issues
Date: Wed,  6 Apr 2016 19:22:52 +1000
Message-Id: <1459934574-25543-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1459934574-25543-1-git-send-email-david@fromorbit.com>
References: <1459934574-25543-1-git-send-email-david@fromorbit.com>
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
it can find inode beyond the current cluster if there is sparse
cache population. gang lookups return results in ascending index
order, so stop trying to cluster iodes once the first inode outside
the cluster mask is detected.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
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
