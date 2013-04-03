Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AB7397F9A
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 22:09:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9BE0330407A
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 20:09:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HS7Cz0eYbiDwXER5 for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 20:09:25 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UNE4g-00008j-0B
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 14:09:22 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UNE4f-0003FC-QF
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 14:09:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: don't free EFIs before the EFDs are committed
Date: Wed,  3 Apr 2013 14:09:21 +1100
Message-Id: <1364958561-12440-1-git-send-email-david@fromorbit.com>
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

Filesystems are occasionally being shut down with this error:

xfs_trans_ail_delete_bulk: attempting to delete a log item that is
not in the AIL.

It was diagnosed to be related to the EFI/EFD commit order when the
EFI and EFD are in different checkpoints and the EFD is committed
before the EFI here:

http://oss.sgi.com/archives/xfs/2013-01/msg00082.html

The real problem is that a single bit cannot fully describe the
states that the EFI/EFD processing can be in. These completion
states are:

EFI			EFI in AIL	EFD		Result
committed/unpinned	Yes		committed	OK
committed/pinned	No		committed	Shutdown
uncommitted		No		committed	Shutdown


Note that the "result" field is what should happen, not what does
happen. The current logic is broken and handles the first two cases
correctly by luck.  That is, the code will free the EFI if the
XFS_EFI_COMMITTED bit is *not* set, rather than if it is set. The
inverted logic "works" because if both EFI and EFD are committed,
then the first __xfs_efi_release() call clears the XFS_EFI_COMMITTED
bit, and the second frees the EFI item. Hence as long as
xfs_efi_item_committed() has been called, everything appears to be
fine.

It is the third case where the logic fails - where
xfs_efd_item_committed() is called before xfs_efi_item_committed(),
and that results in the EFI being freed before it has been
committed. That is the bug that triggered the shutdown, and hence
keeping track of whether the EFI has been committed or not is
insufficient to correctly order the EFI/EFD operations w.r.t. the
AIL.

What we really want is this: the EFI is always placed into the
AIL before the last reference goes away. The only way to guarantee
that is that the EFI is not freed until after it has been unpinned
*and* the EFD has been committed. That is, restructure the logic so
that the only case that can occur is the first case.

This can be done easily by replacing the XFS_EFI_COMMITTED with an
EFI reference count. The EFI is initialised with it's own count, and
that is not released until it is unpinned. However, there is a
complication to this method - the high level EFI/EFD code in
xfs_bmap_finish() does not hold direct references to the EFI
structure, and runs a transaction commit between the EFI and EFD
processing. Hence the EFI can be freed even before the EFD is
created using such a method.

Further, log recovery uses the AIL for tracking EFI/EFDs that need
to be recovered, but it uses the AIL *differently* to the EFI
transaction commit. Hence log recovery never pins or unpins EFIs, so
we can't drop the EFI reference count indirectly to free the EFI.

However, this doesn't prevent us from using a reference count here.
There is a 1:1 relationship between EFIs and EFDs, so when we
initialise the EFI we can take a reference count for the EFD as
well. This solves the xfs_bmap_finish() issue - the EFI will never
be freed until the EFD is processed. In terms of log recovery,
during the committing of the EFD we can look for the
XFS_EFI_RECOVERED bit being set and drop the EFI reference as well,
thereby ensuring everything works correctly there as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_extfree_item.c |   27 +++++++++++++--------------
 fs/xfs/xfs_extfree_item.h |   14 +++++++++-----
 fs/xfs/xfs_log_recover.c  |    1 +
 3 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index feb36d7..c0f3750 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -50,9 +50,8 @@ xfs_efi_item_free(
  * Freeing the efi requires that we remove it from the AIL if it has already
  * been placed there. However, the EFI may not yet have been placed in the AIL
  * when called by xfs_efi_release() from EFD processing due to the ordering of
- * committed vs unpin operations in bulk insert operations. Hence the
- * test_and_clear_bit(XFS_EFI_COMMITTED) to ensure only the last caller frees
- * the EFI.
+ * committed vs unpin operations in bulk insert operations. Hence the reference
+ * count to ensure only the last caller frees the EFI.
  */
 STATIC void
 __xfs_efi_release(
@@ -60,7 +59,7 @@ __xfs_efi_release(
 {
 	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
 
-	if (!test_and_clear_bit(XFS_EFI_COMMITTED, &efip->efi_flags)) {
+	if (atomic_dec_and_test(&efip->efi_refcount)) {
 		spin_lock(&ailp->xa_lock);
 		/* xfs_trans_ail_delete() drops the AIL lock. */
 		xfs_trans_ail_delete(ailp, &efip->efi_item,
@@ -126,8 +125,8 @@ xfs_efi_item_pin(
  * which the EFI is manipulated during a transaction.  If we are being asked to
  * remove the EFI it's because the transaction has been cancelled and by
  * definition that means the EFI cannot be in the AIL so remove it from the
- * transaction and free it.  Otherwise coordinate with xfs_efi_release() (via
- * XFS_EFI_COMMITTED) to determine who gets to free the EFI.
+ * transaction and free it.  Otherwise coordinate with xfs_efi_release()
+ * to determine who gets to free the EFI.
  */
 STATIC void
 xfs_efi_item_unpin(
@@ -171,19 +170,13 @@ xfs_efi_item_unlock(
 
 /*
  * The EFI is logged only once and cannot be moved in the log, so simply return
- * the lsn at which it's been logged.  For bulk transaction committed
- * processing, the EFI may be processed but not yet unpinned prior to the EFD
- * being processed. Set the XFS_EFI_COMMITTED flag so this case can be detected
- * when processing the EFD.
+ * the lsn at which it's been logged.
  */
 STATIC xfs_lsn_t
 xfs_efi_item_committed(
 	struct xfs_log_item	*lip,
 	xfs_lsn_t		lsn)
 {
-	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
-
-	set_bit(XFS_EFI_COMMITTED, &efip->efi_flags);
 	return lsn;
 }
 
@@ -241,6 +234,7 @@ xfs_efi_init(
 	efip->efi_format.efi_nextents = nextents;
 	efip->efi_format.efi_id = (__psint_t)(void*)efip;
 	atomic_set(&efip->efi_next_extent, 0);
+	atomic_set(&efip->efi_refcount, 2);
 
 	return efip;
 }
@@ -310,8 +304,13 @@ xfs_efi_release(xfs_efi_log_item_t	*efip,
 		uint			nextents)
 {
 	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
-	if (atomic_sub_and_test(nextents, &efip->efi_next_extent))
+	if (atomic_sub_and_test(nextents, &efip->efi_next_extent)) {
 		__xfs_efi_release(efip);
+
+		/* recovery needs us to drop the EFI reference, too */
+		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
+			__xfs_efi_release(efip);
+	}
 }
 
 static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 375f68e..4322224 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -114,16 +114,20 @@ typedef struct xfs_efd_log_format_64 {
  * Define EFI flag bits. Manipulated by set/clear/test_bit operators.
  */
 #define	XFS_EFI_RECOVERED	1
-#define	XFS_EFI_COMMITTED	2
 
 /*
- * This is the "extent free intention" log item.  It is used
- * to log the fact that some extents need to be free.  It is
- * used in conjunction with the "extent free done" log item
- * described below.
+ * This is the "extent free intention" log item.  It is used to log the fact
+ * that some extents need to be free.  It is used in conjunction with the
+ * "extent free done" log item described below.
+ *
+ * The EFI is reference counted so that it is not freed prior to both the EFI
+ * and EFD being committed and unpinned. This ensures that when the last
+ * reference goes away the EFI will always be in the AIL as it has been
+ * unpinned, regardless of whether the EFD is processed before or after the EFI.
  */
 typedef struct xfs_efi_log_item {
 	xfs_log_item_t		efi_item;
+	atomic_t		efi_refcount;
 	atomic_t		efi_next_extent;
 	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d1dba7c..3ca3380 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2948,6 +2948,7 @@ xlog_recover_process_efi(
 			 * This will pull the EFI from the AIL and
 			 * free the memory associated with it.
 			 */
+			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 			xfs_efi_release(efip, efip->efi_format.efi_nextents);
 			return XFS_ERROR(EIO);
 		}
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
