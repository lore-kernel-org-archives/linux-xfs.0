Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 059A07CA1
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 04:23:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AB87E304059
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 02:23:38 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IAC0nuT8D8mkLnKd for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 02:23:36 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1anjgP-0004C4-2l
	for xfs@oss.sgi.com; Wed, 06 Apr 2016 19:23:29 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1anjft-0006il-Vk
	for xfs@oss.sgi.com; Wed, 06 Apr 2016 19:22:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfs: skip stale inodes in xfs_iflush_cluster
Date: Wed,  6 Apr 2016 19:22:51 +1000
Message-Id: <1459934574-25543-3-git-send-email-david@fromorbit.com>
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

We don't write back stale inodes, so we should skip them in
xfS_iflush_cluster, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
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
