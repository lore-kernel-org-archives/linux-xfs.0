Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 39A517F73
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 16:15:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C66DBAC001
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 14:15:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RHwVyDsSLdU7IYav (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 14:15:31 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 4C993373BD1
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 21:15:31 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t77LFUqv020038
	for <xfs@oss.sgi.com>; Fri, 7 Aug 2015 17:15:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 01/12] xfs: disentagle EFI release from the extent count
Date: Fri,  7 Aug 2015 17:15:17 -0400
Message-Id: <1438982128-38618-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
References: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
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

Given this along with the fact that the EFI is always completely
constructed before error can occur, eliminate the unnecessary extent
count manipulation and release the EFI directly based on reference
count. The efi_next_extent counter remains because it is still used to
track the slot to log the next extent to free.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_extfree_item.c | 20 ++++++++------------
 fs/xfs/xfs_extfree_item.h |  1 +
 fs/xfs/xfs_log_recover.c  |  2 +-
 fs/xfs/xfs_trans.h        |  1 -
 4 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index adc8f8f..42c9b05 100644
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
@@ -307,18 +307,14 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
  * by this efi item we can free the efi item.
  */
 void
-xfs_efi_release(xfs_efi_log_item_t	*efip,
-		uint			nextents)
+xfs_efi_release(struct xfs_efi_log_item	*efip)
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
@@ -442,7 +438,7 @@ xfs_efd_item_committed(
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
