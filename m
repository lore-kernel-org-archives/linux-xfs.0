Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E23B7F4E
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 14:01:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CA5A304067
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 12:01:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id h1SujpOeVPZBzIlI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2015 12:01:52 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 3B9F22652
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 19:01:51 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-184.bos.redhat.com [10.18.41.184])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7AJ1oZd005181
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 15:01:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 04/13] xfs: ensure EFD trans aborts on log recovery extent
	free failure
Date: Mon, 10 Aug 2015 15:01:40 -0400
Message-Id: <1439233309-19959-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
References: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
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

Log recovery attempts to free extents with leftover EFIs in the AIL
after initial processing. If the extent free fails (e.g., due to
unrelated fs corruption), the transaction is cancelled, though it might
not be dirtied at the time. If this is the case, the EFD does not abort
and thus does not release the EFI. This can lead to hangs as the EFI
pins the AIL.

Update xlog_recover_process_efi() to log the EFD in the transaction
before xfs_free_extent() errors are handled to ensure the transaction is
dirty, aborts the EFD and releases the EFI on error. Since this is a
requirement for EFD processing (and consistent with xfs_bmap_finish()),
update the EFD logging helper to do the extent free and unconditionally
log the EFD. This encodes the required EFD logging behavior into the
helper and reduces the likelihood of errors down the road.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c     | 21 +++++++--------------
 fs/xfs/xfs_log_recover.c   |  7 +++----
 fs/xfs/xfs_trans.h         |  7 +++----
 fs/xfs/xfs_trans_extfree.c | 32 +++++++++++++++++++++++---------
 4 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fa65f67..73aab0d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -112,24 +112,17 @@ xfs_bmap_finish(
 		return error;
 	}
 
+	/*
+	 * Get an EFD and free each extent in the list, logging to the EFD in
+	 * the process. The remaining bmap free list is cleaned up by the caller
+	 * on error.
+	 */
 	efd = xfs_trans_get_efd(*tp, efi, flist->xbf_count);
 	for (free = flist->xbf_first; free != NULL; free = next) {
 		next = free->xbfi_next;
 
-		/*
-		 * Free the extent and log the EFD to dirty the transaction
-		 * before handling errors. This ensures that the transaction is
-		 * aborted, which:
-		 *
-		 * 1.) releases the EFI and frees the EFD
-		 * 2.) shuts down the filesystem
-		 *
-		 * The bmap free list is cleaned up at a higher level.
-		 */
-		error = xfs_free_extent(*tp, free->xbfi_startblock,
-					free->xbfi_blockcount);
-		xfs_trans_log_efd_extent(*tp, efd, free->xbfi_startblock,
-					 free->xbfi_blockcount);
+		error = xfs_trans_free_extent(*tp, efd, free->xbfi_startblock,
+					      free->xbfi_blockcount);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9d8f242..c77dfb5 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -34,7 +34,6 @@
 #include "xfs_inode_item.h"
 #include "xfs_extfree_item.h"
 #include "xfs_trans_priv.h"
-#include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_quota.h"
 #include "xfs_cksum.h"
@@ -3779,11 +3778,11 @@ xlog_recover_process_efi(
 
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		extp = &(efip->efi_format.efi_extents[i]);
-		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len);
+		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
+					      extp->ext_len);
 		if (error)
 			goto abort_error;
-		xfs_trans_log_efd_extent(tp, efdp, extp->ext_start,
-					 extp->ext_len);
+
 	}
 
 	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index ba1660b..4643070 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -220,10 +220,9 @@ void		xfs_trans_log_efi_extent(xfs_trans_t *,
 struct xfs_efd_log_item	*xfs_trans_get_efd(xfs_trans_t *,
 				  struct xfs_efi_log_item *,
 				  uint);
-void		xfs_trans_log_efd_extent(xfs_trans_t *,
-					 struct xfs_efd_log_item *,
-					 xfs_fsblock_t,
-					 xfs_extlen_t);
+int		xfs_trans_free_extent(struct xfs_trans *,
+				      struct xfs_efd_log_item *, xfs_fsblock_t,
+				      xfs_extlen_t);
 int		xfs_trans_commit(struct xfs_trans *);
 int		__xfs_trans_roll(struct xfs_trans **, struct xfs_inode *, int *);
 int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index 284397d..a96ae54 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -25,6 +25,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_extfree_item.h"
+#include "xfs_alloc.h"
 
 /*
  * This routine is called to allocate an "extent free intention"
@@ -108,19 +109,30 @@ xfs_trans_get_efd(xfs_trans_t		*tp,
 }
 
 /*
- * This routine is called to indicate that the described
- * extent is to be logged as having been freed.  It should
- * be called once for each extent freed.
+ * Free an extent and log it to the EFD. Note that the transaction is marked
+ * dirty regardless of whether the extent free succeeds or fails to support the
+ * EFI/EFD lifecycle rules.
  */
-void
-xfs_trans_log_efd_extent(xfs_trans_t		*tp,
-			 xfs_efd_log_item_t	*efdp,
-			 xfs_fsblock_t		start_block,
-			 xfs_extlen_t		ext_len)
+int
+xfs_trans_free_extent(
+	struct xfs_trans	*tp,
+	struct xfs_efd_log_item	*efdp,
+	xfs_fsblock_t		start_block,
+	xfs_extlen_t		ext_len)
 {
 	uint			next_extent;
-	xfs_extent_t		*extp;
+	struct xfs_extent	*extp;
+	int			error;
 
+	error = xfs_free_extent(tp, start_block, ext_len);
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the EFI and frees the EFD
+	 * 2.) shuts down the filesystem
+	 */
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	efdp->efd_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 
@@ -130,4 +142,6 @@ xfs_trans_log_efd_extent(xfs_trans_t		*tp,
 	extp->ext_start = start_block;
 	extp->ext_len = ext_len;
 	efdp->efd_next_extent++;
+
+	return error;
 }
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
