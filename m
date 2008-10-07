Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 15:12:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97MCOsP011266
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 15:12:25 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A75BFA0129C
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 15:14:03 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id ke0a0ANOLmmBpM3E for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 15:14:03 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKoY-0002dd-RB
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 09:13:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] XFS: Add ail pointer into log items
Date: Wed,  8 Oct 2008 09:13:57 +1100
Message-Id: <1223417638-10050-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1223417638-10050-1-git-send-email-david@fromorbit.com>
References: <1223417638-10050-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Add an xfs_ail pointer to log items so that the log items can
reference the AIL directly during callbacks without needed a
struct xfs_mount.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_buf_item.c     |    5 ++++-
 fs/xfs/xfs_extfree_item.c |   28 ++++++++++++++++++----------
 fs/xfs/xfs_inode_item.c   |    1 +
 fs/xfs/xfs_trans.c        |    9 ++++++---
 fs/xfs/xfs_trans.h        |    1 +
 fs/xfs/xfs_trans_item.c   |   10 ++++++++++
 6 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index c557fd6..793e53c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -731,6 +731,7 @@ xfs_buf_item_init(
 	bip->bli_item.li_type = XFS_LI_BUF;
 	bip->bli_item.li_ops = &xfs_buf_item_ops;
 	bip->bli_item.li_mountp = mp;
+	bip->bli_item.li_ailp = mp->m_ail;
 	bip->bli_buf = bp;
 	xfs_buf_hold(bp);
 	bip->bli_format.blf_type = XFS_LI_BUF;
@@ -1123,11 +1124,13 @@ xfs_buf_iodone(
 	xfs_buf_log_item_t	*bip)
 {
 	struct xfs_mount	*mp;
+	struct xfs_ail		*ailp;
 
 	ASSERT(bip->bli_buf == bp);
 
 	xfs_buf_rele(bp);
 	mp = bip->bli_item.li_mountp;
+	ailp = bip->bli_item.li_ailp;
 
 	/*
 	 * If we are forcibly shutting down, this may well be
@@ -1138,7 +1141,7 @@ xfs_buf_iodone(
 	 *
 	 * Either way, AIL is useless if we're forcing a shutdown.
 	 */
-	spin_lock(&mp->m_ail->xa_lock);
+	spin_lock(&ailp->xa_lock);
 	/*
 	 * xfs_trans_delete_ail() drops the AIL lock.
 	 */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index f1dcd80..dab5737 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -108,10 +108,12 @@ xfs_efi_item_pin(xfs_efi_log_item_t *efip)
 STATIC void
 xfs_efi_item_unpin(xfs_efi_log_item_t *efip, int stale)
 {
-	xfs_mount_t	*mp;
+	xfs_mount_t		*mp;
+	struct xfs_ail		*ailp;
 
 	mp = efip->efi_item.li_mountp;
-	spin_lock(&mp->m_ail->xa_lock);
+	ailp = efip->efi_item.li_ailp;
+	spin_lock(&ailp->xa_lock);
 	if (efip->efi_flags & XFS_EFI_CANCELED) {
 		/*
 		 * xfs_trans_delete_ail() drops the AIL lock.
@@ -120,7 +122,7 @@ xfs_efi_item_unpin(xfs_efi_log_item_t *efip, int stale)
 		xfs_efi_item_free(efip);
 	} else {
 		efip->efi_flags |= XFS_EFI_COMMITTED;
-		spin_unlock(&mp->m_ail->xa_lock);
+		spin_unlock(&ailp->xa_lock);
 	}
 }
 
@@ -134,11 +136,13 @@ xfs_efi_item_unpin(xfs_efi_log_item_t *efip, int stale)
 STATIC void
 xfs_efi_item_unpin_remove(xfs_efi_log_item_t *efip, xfs_trans_t *tp)
 {
-	xfs_mount_t	*mp;
+	xfs_mount_t		*mp;
+	struct xfs_ail		*ailp;
 	xfs_log_item_desc_t	*lidp;
 
 	mp = efip->efi_item.li_mountp;
-	spin_lock(&mp->m_ail->xa_lock);
+	ailp = efip->efi_item.li_ailp;
+	spin_lock(&ailp->xa_lock);
 	if (efip->efi_flags & XFS_EFI_CANCELED) {
 		/*
 		 * free the xaction descriptor pointing to this item
@@ -153,7 +157,7 @@ xfs_efi_item_unpin_remove(xfs_efi_log_item_t *efip, xfs_trans_t *tp)
 		xfs_efi_item_free(efip);
 	} else {
 		efip->efi_flags |= XFS_EFI_COMMITTED;
-		spin_unlock(&mp->m_ail->xa_lock);
+		spin_unlock(&ailp->xa_lock);
 	}
 }
 
@@ -268,6 +272,7 @@ xfs_efi_init(xfs_mount_t	*mp,
 	efip->efi_item.li_type = XFS_LI_EFI;
 	efip->efi_item.li_ops = &xfs_efi_item_ops;
 	efip->efi_item.li_mountp = mp;
+	efip->efi_item.li_ailp = mp->m_ail;
 	efip->efi_format.efi_nextents = nextents;
 	efip->efi_format.efi_id = (__psint_t)(void*)efip;
 
@@ -345,14 +350,16 @@ void
 xfs_efi_release(xfs_efi_log_item_t	*efip,
 		uint			nextents)
 {
-	xfs_mount_t	*mp;
-	int		extents_left;
+	xfs_mount_t		*mp;
+	struct xfs_ail		*ailp;
+	int			extents_left;
 
 	mp = efip->efi_item.li_mountp;
+	ailp = efip->efi_item.li_ailp;
 	ASSERT(efip->efi_next_extent > 0);
 	ASSERT(efip->efi_flags & XFS_EFI_COMMITTED);
 
-	spin_lock(&mp->m_ail->xa_lock);
+	spin_lock(&ailp->xa_lock);
 	ASSERT(efip->efi_next_extent >= nextents);
 	efip->efi_next_extent -= nextents;
 	extents_left = efip->efi_next_extent;
@@ -363,7 +370,7 @@ xfs_efi_release(xfs_efi_log_item_t	*efip,
 		xfs_trans_delete_ail(mp, (xfs_log_item_t *)efip);
 		xfs_efi_item_free(efip);
 	} else {
-		spin_unlock(&mp->m_ail->xa_lock);
+		spin_unlock(&ailp->xa_lock);
 	}
 }
 
@@ -565,6 +572,7 @@ xfs_efd_init(xfs_mount_t	*mp,
 	efdp->efd_item.li_type = XFS_LI_EFD;
 	efdp->efd_item.li_ops = &xfs_efd_item_ops;
 	efdp->efd_item.li_mountp = mp;
+	efdp->efd_item.li_ailp = mp->m_ail;
 	efdp->efd_efip = efip;
 	efdp->efd_format.efd_nextents = nextents;
 	efdp->efd_format.efd_efi_id = efip->efi_format.efi_id;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 291d30a..47594f4 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -932,6 +932,7 @@ xfs_inode_item_init(
 	iip->ili_item.li_type = XFS_LI_INODE;
 	iip->ili_item.li_ops = &xfs_inode_item_ops;
 	iip->ili_item.li_mountp = mp;
+	iip->ili_item.li_ailp = mp->m_ail;
 	iip->ili_inode = ip;
 
 	/*
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 99ba0e2..5163e12 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1383,11 +1383,13 @@ xfs_trans_chunk_committed(
 	xfs_log_item_desc_t	*lidp;
 	xfs_log_item_t		*lip;
 	xfs_lsn_t		item_lsn;
-	struct xfs_mount	*mp;
 	int			i;
 
 	lidp = licp->lic_descs;
 	for (i = 0; i < licp->lic_unused; i++, lidp++) {
+		struct xfs_mount	*mp;
+		struct xfs_ail		*ailp;
+
 		if (xfs_lic_isfree(licp, i)) {
 			continue;
 		}
@@ -1425,7 +1427,8 @@ xfs_trans_chunk_committed(
 		 * the test below.
 		 */
 		mp = lip->li_mountp;
-		spin_lock(&mp->m_ail->xa_lock);
+		ailp = lip->li_ailp;
+		spin_lock(&ailp->xa_lock);
 		if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0) {
 			/*
 			 * This will set the item's lsn to item_lsn
@@ -1436,7 +1439,7 @@ xfs_trans_chunk_committed(
 			 */
 			xfs_trans_update_ail(mp, lip, item_lsn);
 		} else {
-			spin_unlock(&mp->m_ail->xa_lock);
+			spin_unlock(&ailp->xa_lock);
 		}
 
 		/*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index ae2ae3e..0df5154 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -768,6 +768,7 @@ typedef struct xfs_log_item {
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
 	struct xfs_log_item_desc	*li_desc;	/* ptr to current desc*/
 	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
+	struct xfs_ail			*li_ailp;	/* ptr to AIL */
 	uint				li_type;	/* item type */
 	uint				li_flags;	/* misc flags */
 	struct xfs_log_item		*li_bio_list;	/* buffer item list */
diff --git a/fs/xfs/xfs_trans_item.c b/fs/xfs/xfs_trans_item.c
index 3c666e8..e110bf5 100644
--- a/fs/xfs/xfs_trans_item.c
+++ b/fs/xfs/xfs_trans_item.c
@@ -22,6 +22,14 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
+/* XXX: from here down needed until struct xfs_trans has it's own ailp */
+#include "xfs_bit.h"
+#include "xfs_buf_item.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_dmapi.h"
+#include "xfs_mount.h"
 
 STATIC int	xfs_trans_unlock_chunk(xfs_log_item_chunk_t *,
 					int, int, xfs_lsn_t);
@@ -79,6 +87,7 @@ xfs_trans_add_item(xfs_trans_t *tp, xfs_log_item_t *lip)
 		lidp->lid_size = 0;
 		lip->li_desc = lidp;
 		lip->li_mountp = tp->t_mountp;
+		lip->li_ailp = tp->t_mountp->m_ail;
 		return lidp;
 	}
 
@@ -120,6 +129,7 @@ xfs_trans_add_item(xfs_trans_t *tp, xfs_log_item_t *lip)
 	lidp->lid_size = 0;
 	lip->li_desc = lidp;
 	lip->li_mountp = tp->t_mountp;
+	lip->li_ailp = tp->t_mountp->m_ail;
 	return lidp;
 }
 
-- 
1.5.6.5
