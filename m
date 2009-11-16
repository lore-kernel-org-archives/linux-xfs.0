Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAGJq0kP221900 for <xfs@oss.sgi.com>; Mon, 16 Nov 2009 13:52:00 -0600
Received: from millhouse.houseofnate.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52C7918857DA
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2009 11:52:20 -0800 (PST)
Received: from millhouse.houseofnate.net
	(dsl092-086-237.bos1.dsl.speakeasy.net [66.92.86.237]) by
	cuda.sgi.com with ESMTP id kDqZ5hyS1vQnpnHr for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2009 11:52:20 -0800 (PST)
Message-ID: <4B01AD54.3030008@houseofnate.net>
Date: Mon, 16 Nov 2009 14:51:48 -0500
From: "Nathaniel W. Turner" <nate@houseofnate.net>
MIME-Version: 1.0
Subject: [PATCH] xfs: copy li_lsn before dropping AIL lock
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Access to log items on the AIL is generally protected by m_ail_lock;
this is particularly needed when we're getting or setting the 64-bit
li_lsn on a 32-bit platform.  This patch fixes a couple places where we
were accessing the log item after dropping the AIL lock on 32-bit
machines.

This can result in a partially-zeroed log->l_tail_lsn if
xfs_trans_ail_delete is racing with xfs_trans_ail_update, and in at
least some cases, this can leave the l_tail_lsn with a zero cycle
number, which means xlog_space_left will think the log is full (unless
CONFIG_XFS_DEBUG is set, in which case we'll trip an ASSERT), leading to
processes stuck forever in xlog_grant_log_space.

Thanks to Adrian VanderSpek for first spotting the race potential and to
Dave Chinner for debug assistance.

Signed-off-by: Nathaniel W. Turner <nate@houseofnate.net>
---
  fs/xfs/xfs_trans_ail.c |   23 ++++++++++++++++++++---
  1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index f31271c..2ffc570 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -467,6 +467,7 @@ xfs_trans_ail_update(
  {
  	xfs_log_item_t		*dlip = NULL;
  	xfs_log_item_t		*mlip;	/* ptr to minimum lip */
+	xfs_lsn_t		tail_lsn;

  	mlip = xfs_ail_min(ailp);

@@ -483,8 +484,16 @@ xfs_trans_ail_update(

  	if (mlip == dlip) {
  		mlip = xfs_ail_min(ailp);
+		/*
+		 * It is not safe to access mlip after the AIL lock is
+		 * dropped, so we must get a copy of li_lsn before we do
+		 * so.  This is especially important on 32-bit platforms
+		 * where accessing and updating 64-bit values like li_lsn
+		 * is not atomic.
+		 */
+		tail_lsn = mlip->li_lsn;
  		spin_unlock(&ailp->xa_lock);
-		xfs_log_move_tail(ailp->xa_mount, mlip->li_lsn);
+		xfs_log_move_tail(ailp->xa_mount, tail_lsn);
  	} else {
  		spin_unlock(&ailp->xa_lock);
  	}
@@ -514,6 +523,7 @@ xfs_trans_ail_delete(
  {
  	xfs_log_item_t		*dlip;
  	xfs_log_item_t		*mlip;
+	xfs_lsn_t		tail_lsn;

  	if (lip->li_flags & XFS_LI_IN_AIL) {
  		mlip = xfs_ail_min(ailp);
@@ -527,9 +537,16 @@ xfs_trans_ail_delete(

  		if (mlip == dlip) {
  			mlip = xfs_ail_min(ailp);
+			/*
+			 * It is not safe to access mlip after the AIL lock
+			 * is dropped, so we must get a copy of li_lsn
+			 * before we do so.  This is especially important
+			 * on 32-bit platforms where accessing and updating
+			 * 64-bit values like li_lsn is not atomic.
+			 */
+			tail_lsn = mlip ? mlip->li_lsn : 0;
  			spin_unlock(&ailp->xa_lock);
-			xfs_log_move_tail(ailp->xa_mount,
-						(mlip ? mlip->li_lsn : 0));
+			xfs_log_move_tail(ailp->xa_mount, tail_lsn);
  		} else {
  			spin_unlock(&ailp->xa_lock);
  		}
-- 
Nathaniel W. Turner
http://houseofnate.net/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
