Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 223E77CAF
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 00:32:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D8E3C8F8035
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 22:32:23 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	VWthDcRbqhCVgVyl for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 22:32:21 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aqDPP-0003p3-RM
	for xfs@oss.sgi.com; Wed, 13 Apr 2016 15:32:11 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aqDOq-0000bn-Bi
	for xfs@oss.sgi.com; Wed, 13 Apr 2016 15:31:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/11] xfs: fix inode validity check in xfs_iflush_cluster
Date: Wed, 13 Apr 2016 15:31:24 +1000
Message-Id: <1460525492-1170-4-git-send-email-david@fromorbit.com>
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

Some careless idiot(*) wrote crap code in commit 1a3e8f3 ("xfs:
convert inode cache lookups to use RCU locking") back in late 2010,
and so xfs_iflush_cluster checks the wrong inode for whether it is
still valid under RCU protection. Fix it to lock and check the
correct inode.

(*) Careless-idiot: Dave Chinner <dchinner@redhat.com>

cc: <stable@vger.kernel.org> # 3.10.x-
Discovered-by: Brain Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e97ae5d..e302f11 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3192,13 +3192,13 @@ xfs_iflush_cluster(
 		 * We need to check under the i_flags_lock for a valid inode
 		 * here. Skip it if it is not valid or the wrong inode.
 		 */
-		spin_lock(&ip->i_flags_lock);
-		if (!ip->i_ino ||
+		spin_lock(&iq->i_flags_lock);
+		if (!iq->i_ino ||
 		    (XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) != first_index) {
-			spin_unlock(&ip->i_flags_lock);
+			spin_unlock(&iq->i_flags_lock);
 			continue;
 		}
-		spin_unlock(&ip->i_flags_lock);
+		spin_unlock(&iq->i_flags_lock);
 
 		/*
 		 * Do an un-protected check to see if the inode is dirty and
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
