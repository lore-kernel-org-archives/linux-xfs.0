Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8T0osQh009355 for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 19:50:55 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6CE51D97DF6
	for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 17:51:51 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	w0T9MVdIMYI8bDHn for <xfs@oss.sgi.com>;
	Tue, 28 Sep 2010 17:51:51 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40572139-1927428
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 10:21:50 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1P0ktg-00068d-UN
	for xfs@oss.sgi.com; Wed, 29 Sep 2010 10:51:48 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1P0ktY-0001Tx-96
	for xfs@oss.sgi.com; Wed, 29 Sep 2010 10:51:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: reduce lock traffic on incore sb lock
Date: Wed, 29 Sep 2010 10:51:40 +1000
Message-Id: <1285721500-5671-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Under heavy parallel unlink workloads, the incore superblock lock is
heavily trafficed in xfs_mod_incore_sb_batch(). This is despite the
fact that the counters being modified are typically the counters
that are per-cpu and do not require the lock. IOWs, we are locking
and unlocking the superblock lock needlessly, and the result is that
it is third most heavily contended lock in the system under these
workloads.

Fix this by only locking the superblock lock when we are modifying a
counter protected by it. This completely removes the m_sb_lock from
lock_stat traces during create/remove workloads.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 396d324..adc4ab9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1883,21 +1883,23 @@ xfs_mod_incore_sb(
  * Either all of the specified deltas will be applied or none of
  * them will.  If any modified field dips below 0, then all modifications
  * will be backed out and EINVAL will be returned.
+ *
+ * The @m_sb_lock is be taken and dropped on demand according to the type of
+ * counter being modified to minimise lock traffic as this can be a very hot
+ * lock.
  */
 int
 xfs_mod_incore_sb_batch(xfs_mount_t *mp, xfs_mod_sb_t *msb, uint nmsb, int rsvd)
 {
 	int		status=0;
 	xfs_mod_sb_t	*msbp;
+	int		locked = 0;
 
 	/*
 	 * Loop through the array of mod structures and apply each
 	 * individually.  If any fail, then back out all those
-	 * which have already been applied.  Do all of this within
-	 * the scope of the m_sb_lock so that all of the changes will
-	 * be atomic.
+	 * which have already been applied.
 	 */
-	spin_lock(&mp->m_sb_lock);
 	msbp = &msb[0];
 	for (msbp = &msbp[0]; msbp < (msb + nmsb); msbp++) {
 		/*
@@ -1911,16 +1913,22 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp, xfs_mod_sb_t *msb, uint nmsb, int rsvd)
 		case XFS_SBS_IFREE:
 		case XFS_SBS_FDBLOCKS:
 			if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) {
-				spin_unlock(&mp->m_sb_lock);
+				if (locked) {
+					locked = 0;
+					spin_unlock(&mp->m_sb_lock);
+				}
 				status = xfs_icsb_modify_counters(mp,
 							msbp->msb_field,
 							msbp->msb_delta, rsvd);
-				spin_lock(&mp->m_sb_lock);
 				break;
 			}
 			/* FALLTHROUGH */
 #endif
 		default:
+			if (!locked) {
+				spin_lock(&mp->m_sb_lock);
+				locked = 1;
+			}
 			status = xfs_mod_incore_sb_unlocked(mp,
 						msbp->msb_field,
 						msbp->msb_delta, rsvd);
@@ -1949,17 +1957,23 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp, xfs_mod_sb_t *msb, uint nmsb, int rsvd)
 			case XFS_SBS_IFREE:
 			case XFS_SBS_FDBLOCKS:
 				if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) {
-					spin_unlock(&mp->m_sb_lock);
+					if (locked) {
+						locked = 0;
+						spin_unlock(&mp->m_sb_lock);
+					}
 					status = xfs_icsb_modify_counters(mp,
 							msbp->msb_field,
 							-(msbp->msb_delta),
 							rsvd);
-					spin_lock(&mp->m_sb_lock);
 					break;
 				}
 				/* FALLTHROUGH */
 #endif
 			default:
+				if (!locked) {
+					spin_lock(&mp->m_sb_lock);
+					locked = 1;
+				}
 				status = xfs_mod_incore_sb_unlocked(mp,
 							msbp->msb_field,
 							-(msbp->msb_delta),
@@ -1970,7 +1984,8 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp, xfs_mod_sb_t *msb, uint nmsb, int rsvd)
 			msbp--;
 		}
 	}
-	spin_unlock(&mp->m_sb_lock);
+	if (locked)
+		spin_unlock(&mp->m_sb_lock);
 	return status;
 }
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
