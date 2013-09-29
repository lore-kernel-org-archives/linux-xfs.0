Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3905F7F57
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 18:37:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB411AC001
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 16:37:18 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FPwB01qBbevSxoyj for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 16:37:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQQY1-0005z6-Eh
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 09:37:09 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQQY1-0003W8-Dy
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 09:37:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: lockdep needs to know about 3 dquot-deep nesting
Date: Mon, 30 Sep 2013 09:37:03 +1000
Message-Id: <1380497826-13474-2-git-send-email-david@fromorbit.com>
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

Michael Semon reported that xfs/299 generated this lockdep warning:

=============================================
[ INFO: possible recursive locking detected ]
3.12.0-rc2+ #2 Not tainted
---------------------------------------------
touch/21072 is trying to acquire lock:
 (&xfs_dquot_other_class){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64

but task is already holding lock:
 (&xfs_dquot_other_class){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&xfs_dquot_other_class);
  lock(&xfs_dquot_other_class);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

7 locks held by touch/21072:
 #0:  (sb_writers#10){++++.+}, at: [<c11185b6>] mnt_want_write+0x1e/0x3e
 #1:  (&type->i_mutex_dir_key#4){+.+.+.}, at: [<c11078ee>] do_last+0x245/0xe40
 #2:  (sb_internal#2){++++.+}, at: [<c122c9e0>] xfs_trans_alloc+0x1f/0x35
 #3:  (&(&ip->i_lock)->mr_lock/1){+.+...}, at: [<c126cd1b>] xfs_ilock+0x100/0x1f1
 #4:  (&(&ip->i_lock)->mr_lock){++++-.}, at: [<c126cf52>] xfs_ilock_nowait+0x105/0x22f
 #5:  (&dqp->q_qlock){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64
 #6:  (&xfs_dquot_other_class){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64

The lockdep annotation for dquot lock nesting only understands
locking for user and "other" dquots, not user, group and quota
dquots. Fix the annotations to match the locking heirarchy we now
have.

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dquot.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 71520e6..1ee776d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -64,7 +64,8 @@ int xfs_dqerror_mod = 33;
 struct kmem_zone		*xfs_qm_dqtrxzone;
 static struct kmem_zone		*xfs_qm_dqzone;
 
-static struct lock_class_key xfs_dquot_other_class;
+static struct lock_class_key xfs_dquot_group_class;
+static struct lock_class_key xfs_dquot_project_class;
 
 /*
  * This is called to free all the memory associated with a dquot
@@ -703,8 +704,20 @@ xfs_qm_dqread(
 	 * Make sure group quotas have a different lock class than user
 	 * quotas.
 	 */
-	if (!(type & XFS_DQ_USER))
-		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_other_class);
+	switch (type) {
+	case XFS_DQ_USER:
+		/* uses the default lock class */
+		break;
+	case XFS_DQ_GROUP:
+		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_group_class);
+		break;
+	case XFS_DQ_PROJ:
+		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_project_class);
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
 
 	XFS_STATS_INC(xs_qm_dquot);
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
