Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 39AA67F4E
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 14:01:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4569AC006
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 12:01:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DhmmPvDv4ZuNGyUv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2015 12:01:51 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id D817D19EF37
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 19:01:50 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-184.bos.redhat.com [10.18.41.184])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7AJ1orL002495
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 15:01:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 01/13] xfs: disentagle EFI release from the extent count
Date: Mon, 10 Aug 2015 15:01:37 -0400
Message-Id: <1439233309-19959-2-git-send-email-bfoster@redhat.com>
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

Release of the EFI either occurs based on the reference count or the
extent count. The extent count used is either the count tracked in the
EFI or EFD, depending on the particular situation. In either case, the
count is initialized to the final value and thus always matches the
current efi_next_extent value once the EFI is completely constructed.
For example, the EFI extent count is increased as the extents are logged
in xfs_bmap_finish() and the full free list is always completely
processed. Therefore, the count is guaranteed to be complete once the
EFI transaction is committed. The EFD uses the efd_nextents counter to
release the EFI. This counter is initialized to the count of the EFI
when the EFD is created. Thus the EFD, as currently used, has no concept
of partial EFI release based on extent count.

Given that the EFI extent count is always released in whole, use of the
extent count for reference counting is unnecessary. Remove this level of
the API and release the EFI based on the core reference count. The
efi_next_extent counter remains because it is still used to track the
slot to log the next extent to free.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_extfree_item.c | 21 +++++++++------------
 fs/xfs/xfs_extfree_item.h |  1 +
 fs/xfs/xfs_log_recover.c  |  2 +-
 fs/xfs/xfs_trans.h        |  1 -
 4 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index adc8f8f..6ff738f 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -149,7 +149,7 @@ xfs_efi_item_unpin(
 		xfs_efi_item_free(efip);
 		return;
 	}
-	__xfs_efi_release(efip);
+	xfs_efi_release(efip);
 }
 
 /*
@@ -307,18 +307,15 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
  * by this efi item we can free the efi item.
  */
 void
-xfs_efi_release(xfs_efi_log_item_t	*efip,
-		uint			nextents)
+xfs_efi_release(
+	struct xfs_efi_log_item	*efip)
 {
-	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
-	if (atomic_sub_and_test(nextents, &efip->efi_next_extent)) {
-		/* recovery needs us to drop the EFI reference, too */
-		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
-			__xfs_efi_release(efip);
-
+	/* recovery needs us to drop the EFI reference, too */
+	if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
 		__xfs_efi_release(efip);
-		/* efip may now have been freed, do not reference it again. */
-	}
+
+	__xfs_efi_release(efip);
+	/* efip may now have been freed, do not reference it again. */
 }
 
 static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
@@ -442,7 +439,7 @@ xfs_efd_item_committed(
 	 * EFI got unpinned and freed before the EFD got aborted.
 	 */
 	if (!(lip->li_flags & XFS_LI_ABORTED))
-		xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
+		xfs_efi_release(efdp->efd_efip);
 
 	xfs_efd_item_free(efdp);
 	return (xfs_lsn_t)-1;
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 0ffbce3..399562e 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -77,5 +77,6 @@ xfs_efd_log_item_t	*xfs_efd_init(struct xfs_mount *, xfs_efi_log_item_t *,
 int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
 					    xfs_efi_log_format_t *dst_efi_fmt);
 void			xfs_efi_item_free(xfs_efi_log_item_t *);
+void			xfs_efi_release(struct xfs_efi_log_item *);
 
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c674b40..9d8f242 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3766,7 +3766,7 @@ xlog_recover_process_efi(
 			 * free the memory associated with it.
 			 */
 			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
-			xfs_efi_release(efip, efip->efi_format.efi_nextents);
+			xfs_efi_release(efip);
 			return -EIO;
 		}
 	}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 3b21b4e..f48e839 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -213,7 +213,6 @@ void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 struct xfs_efi_log_item	*xfs_trans_get_efi(xfs_trans_t *, uint);
-void		xfs_efi_release(struct xfs_efi_log_item *, uint);
 void		xfs_trans_log_efi_extent(xfs_trans_t *,
 					 struct xfs_efi_log_item *,
 					 xfs_fsblock_t,
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
