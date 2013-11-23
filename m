Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E30B37F53
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 09:15:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CFAB7304066
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 07:15:35 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ytmuzxAGgiRBV5GP (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Nov 2013 07:15:34 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VkEvm-0001RA-DK
	for xfs@oss.sgi.com; Sat, 23 Nov 2013 15:15:34 +0000
Message-Id: <20131123151534.322383618@bombadil.infradead.org>
Date: Sat, 23 Nov 2013 07:11:57 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/7] xfs: remove efi_next_extent
References: <20131123151151.716201348@bombadil.infradead.org>
Content-Disposition: inline; filename=0006-xfs-remove-efi_next_extent.patch
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

As the new code shows much more clearly we always have a 1:1 relationship
between EFI and EFD items, and thus don't need to count the number of
extents that and EFD cancels out.  Thus we can remove the efi_next_extent
field and all logic related to it.

Also this makes clear that the only field we actually use in the EFD is
the efi_id, thus there's no need to even bother formatting the extents
into the EFD.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extfree_item.c |   37 ++++++++++---------------------------
 fs/xfs/xfs_extfree_item.h |    1 -
 fs/xfs/xfs_log_recover.c  |    2 +-
 fs/xfs/xfs_trans.h        |    2 +-
 4 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 7ed0e01..da0ac7c 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -47,14 +47,17 @@ xfs_efi_item_free(
 }
 
 /*
+ * This is called by the efd item code below to release references to the given
+ * efi item.
+ *
  * Freeing the efi requires that we remove it from the AIL if it has already
  * been placed there. However, the EFI may not yet have been placed in the AIL
- * when called by xfs_efi_release() from EFD processing due to the ordering of
- * committed vs unpin operations in bulk insert operations. Hence the reference
- * count to ensure only the last caller frees the EFI.
+ * when called by xfs_efd_item_committed due to the ordering of committed vs
+ * unpin operations in bulk insert operations. Hence the reference count to
+ * ensure only the last caller frees the EFI.
  */
-STATIC void
-__xfs_efi_release(
+void
+xfs_efi_release(
 	struct xfs_efi_log_item	*efip)
 {
 	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
@@ -120,8 +123,6 @@ xfs_efi_item_format(
 	elf->efi_id = efip->efi_id;
 
 	for (free = efip->efi_flist.xbf_first; free; free = free->xbfi_next) {
-		atomic_inc(&efip->efi_next_extent);
-
 		elf->efi_extents[e].ext_start = free->xbfi_startblock;
 		elf->efi_extents[e].ext_len = free->xbfi_blockcount;
 		e++;
@@ -161,7 +162,7 @@ xfs_efi_item_unpin(
 		xfs_efi_item_free(efip);
 		return;
 	}
-	__xfs_efi_release(efip);
+	xfs_efi_release(efip);
 }
 
 /*
@@ -240,7 +241,6 @@ xfs_efi_init(
 	efip = kmem_zone_zalloc(xfs_efi_zone, KM_SLEEP);
 	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
 
-	atomic_set(&efip->efi_next_extent, 0);
 	atomic_set(&efip->efi_refcount, 2);
 	efip->efi_id = (unsigned long)efip;
 
@@ -333,27 +333,10 @@ xfs_efi_item_from_disk(
 		return EFSCORRUPTED;
 	}
 
-	atomic_set(&efip->efi_next_extent, efip->efi_flist.xbf_count);
 	*efipp = efip;
 	return 0;
 }
 
-
-/*
- * This is called by the efd item code below to release references to the given
- * efi item.  Each efd calls this with the number of extents that it has
- * logged, and when the sum of these reaches the total number of extents logged
- * by this efi item we can free the efi item.
- */
-void
-xfs_efi_release(xfs_efi_log_item_t	*efip,
-		uint			nextents)
-{
-	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
-	if (atomic_sub_and_test(nextents, &efip->efi_next_extent))
-		__xfs_efi_release(efip);
-}
-
 static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_efd_log_item, efd_item);
@@ -479,7 +462,7 @@ xfs_efd_item_committed(
 	 * EFI got unpinned and freed before the EFD got aborted.
 	 */
 	if (!(lip->li_flags & XFS_LI_ABORTED))
-		xfs_efi_release(efdp->efd_efip, efdp->efd_flist.xbf_count);
+		xfs_efi_release(efdp->efd_efip);
 
 	kmem_zone_free(xfs_efd_zone, efdp);
 	return (xfs_lsn_t)-1;
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 724a7e4..e658d42 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -46,7 +46,6 @@ struct kmem_zone;
 typedef struct xfs_efi_log_item {
 	xfs_log_item_t		efi_item;
 	atomic_t		efi_refcount;
-	atomic_t		efi_next_extent;
 	unsigned long		efi_flags;	/* misc flags */
 	struct xfs_bmap_free	efi_flist;
 	unsigned long		efi_id;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 61e8587..b679a0b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3641,7 +3641,7 @@ xlog_recover_process_efi(
 			 * memory associated with it.
 			 */
 			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
-			xfs_efi_release(efip, efip->efi_flist.xbf_count);
+			xfs_efi_release(efip);
 			return XFS_ERROR(EIO);
 		}
 	}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index f6b4cf0..6723157 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -216,7 +216,7 @@ void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
-void		xfs_efi_release(struct xfs_efi_log_item *, uint);
+void		xfs_efi_release(struct xfs_efi_log_item *);
 struct xfs_efi_log_item *xfs_trans_log_efi(struct xfs_trans *,
 			struct xfs_bmap_free *);
 struct xfs_efd_log_item	*xfs_trans_log_efd(struct xfs_trans *,
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
