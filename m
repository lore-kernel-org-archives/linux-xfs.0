Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD4WMB7158242 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 22:32:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 923CA1CBC730
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:34:12 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	Qmn0TOePX5VUQgdi for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:34:12 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49483524-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:04:11 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS06p-000211-HU
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:33:59 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS05L-0004iN-Dd
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:32:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/9] xfs: fix EFI transaction cancellation.
Date: Mon, 13 Dec 2010 15:32:15 +1100
Message-Id: <1292214743-18073-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1292214743-18073-1-git-send-email-david@fromorbit.com>
References: <1292214743-18073-1-git-send-email-david@fromorbit.com>
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

XFS_EFI_CANCELED has not been set in the code base since
xfs_efi_cancel() was removed back in 2006 by commit
065d312e15902976d256ddaf396a7950ec0350a8 ("[XFS] Remove unused
iop_abort log item operation), and even then xfs_efi_cancel() was
never called. I haven't tracked it back further than that (beyond
git history), but it indicates that the handling of EFIs in
cancelled transactions has been broken for a long time.

Basically, when we get an IOP_UNPIN(lip, 1); call from
xfs_trans_uncommit() (i.e. remove == 1), if we don't free the log
item descriptor we leak it. Fix the behviour to be correct and kill
the XFS_EFI_CANCELED flag.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_extfree_item.c |   20 +++++++++-----------
 fs/xfs/xfs_extfree_item.h |    1 -
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a55e687..5997efa 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -99,10 +99,11 @@ xfs_efi_item_pin(
 }
 
 /*
- * While EFIs cannot really be pinned, the unpin operation is the
- * last place at which the EFI is manipulated during a transaction.
- * Here we coordinate with xfs_efi_cancel() to determine who gets to
- * free the EFI.
+ * While EFIs cannot really be pinned, the unpin operation is the last place at
+ * which the EFI is manipulated during a transaction.  If we are being asked to
+ * remove the EFI it's because the transaction has been cancelled and by
+ * definition that means the EFI cannot be in the AIL so remove it from the
+ * transaction and free it.
  */
 STATIC void
 xfs_efi_item_unpin(
@@ -113,17 +114,14 @@ xfs_efi_item_unpin(
 	struct xfs_ail		*ailp = lip->li_ailp;
 
 	spin_lock(&ailp->xa_lock);
-	if (efip->efi_flags & XFS_EFI_CANCELED) {
-		if (remove)
-			xfs_trans_del_item(lip);
-
-		/* xfs_trans_ail_delete() drops the AIL lock. */
-		xfs_trans_ail_delete(ailp, lip);
+	if (remove) {
+		ASSERT(!(lip->li_flags & XFS_LI_IN_AIL));
+		xfs_trans_del_item(lip);
 		xfs_efi_item_free(efip);
 	} else {
 		efip->efi_flags |= XFS_EFI_COMMITTED;
-		spin_unlock(&ailp->xa_lock);
 	}
+	spin_unlock(&ailp->xa_lock);
 }
 
 /*
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 0d22c56..f7834ec 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -115,7 +115,6 @@ typedef struct xfs_efd_log_format_64 {
  */
 #define	XFS_EFI_RECOVERED	0x1
 #define	XFS_EFI_COMMITTED	0x2
-#define	XFS_EFI_CANCELED	0x4
 
 /*
  * This is the "extent free intention" log item.  It is used
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
