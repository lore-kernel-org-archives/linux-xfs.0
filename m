Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o241jL6N126561 for <xfs@oss.sgi.com>; Wed, 3 Mar 2010 19:45:21 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 612F413F180C
	for <xfs@oss.sgi.com>; Wed,  3 Mar 2010 17:46:48 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	OVsFdLsvYAjDjFWA for <xfs@oss.sgi.com>;
	Wed, 03 Mar 2010 17:46:48 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	16018852-1927428
	for <xfs@oss.sgi.com>; Thu, 04 Mar 2010 12:16:47 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1Nn09F-0004ai-Qv
	for xfs@oss.sgi.com; Thu, 04 Mar 2010 12:46:45 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nn08y-000236-73
	for xfs@oss.sgi.com; Thu, 04 Mar 2010 12:46:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: Increase the default size of the reserved blocks pool
Date: Thu,  4 Mar 2010 12:46:25 +1100
Message-Id: <1267667185-7736-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1267667185-7736-1-git-send-email-david@fromorbit.com>
References: <1267667185-7736-1-git-send-email-david@fromorbit.com>
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

The current default size of the reserved blocks pool is easy to deplete
with certain workloads, in particular workloads that do lots of concurrent
delayed allocation extent conversions.  If enough transactions are running
in parallel and the entire pool is consumed then subsequent calls to
xfs_trans_reserve() will fail with ENOSPC.  Also add a rate limited
warning so we know if this starts happening again.

This is an updated version of an old patch from Lachlan McIlroy.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_mount.c |   49 +++++++++++++++++++++++++++++--------------------
 1 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index c207fef..e79b56b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1097,13 +1097,15 @@ xfs_default_resblks(xfs_mount_t *mp)
 	__uint64_t resblks;
 
 	/*
-	 * We default to 5% or 1024 fsbs of space reserved, whichever is smaller.
-	 * This may drive us straight to ENOSPC on mount, but that implies
-	 * we were already there on the last unmount. Warn if this occurs.
+	 * We default to 5% or 8192 fsbs of space reserved, whichever is
+	 * smaller.  This is intended to cover concurrent allocation
+	 * transactions when we initially hit enospc. These each require a 4
+	 * block reservation. Hence by default we cover roughly 2000 concurrent
+	 * allocation reservations.
 	 */
 	resblks = mp->m_sb.sb_dblocks;
 	do_div(resblks, 20);
-	resblks = min_t(__uint64_t, resblks, 1024);
+	resblks = min_t(__uint64_t, resblks, 8192);
 	return resblks;
 }
 
@@ -1417,6 +1419,9 @@ xfs_mountfs(
 	 * when at ENOSPC. This is needed for operations like create with
 	 * attr, unwritten extent conversion at ENOSPC, etc. Data allocations
 	 * are not allowed to use this reserved space.
+	 *
+	 * This may drive us straight to ENOSPC on mount, but that implies
+	 * we were already there on the last unmount. Warn if this occurs.
 	 */
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		resblks = xfs_default_resblks(mp);
@@ -1725,26 +1730,30 @@ xfs_mod_incore_sb_unlocked(
 				lcounter += rem;
 			}
 		} else {				/* Taking blocks away */
-
 			lcounter += delta;
+			if (lcounter >= 0) {
+				mp->m_sb.sb_fdblocks = lcounter +
+							XFS_ALLOC_SET_ASIDE(mp);
+				return 0;
+			}
 
-		/*
-		 * If were out of blocks, use any available reserved blocks if
-		 * were allowed to.
-		 */
+			/*
+			 * We are out of blocks, use any available reserved
+			 * blocks if were allowed to.
+			 */
+			if (!rsvd)
+				return XFS_ERROR(ENOSPC);
 
-			if (lcounter < 0) {
-				if (rsvd) {
-					lcounter = (long long)mp->m_resblks_avail + delta;
-					if (lcounter < 0) {
-						return XFS_ERROR(ENOSPC);
-					}
-					mp->m_resblks_avail = lcounter;
-					return 0;
-				} else {	/* not reserved */
-					return XFS_ERROR(ENOSPC);
-				}
+			lcounter = (long long)mp->m_resblks_avail + delta;
+			if (lcounter >= 0) {
+				mp->m_resblks_avail = lcounter;
+				return 0;
 			}
+			printk_once(KERN_WARNING
+				"Filesystem \"%s\": reserve blocks depleted! "
+				"Consider increasing reserve pool size.",
+				mp->m_fsname);
+			return XFS_ERROR(ENOSPC);
 		}
 
 		mp->m_sb.sb_fdblocks = lcounter + XFS_ALLOC_SET_ASIDE(mp);
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
