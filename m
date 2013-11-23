Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 37F877F55
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 09:15:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD161AC005
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 07:15:36 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 0uSMSt2GKNqm7IZg (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Nov 2013 07:15:34 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VkEvm-0001Qb-9I
	for xfs@oss.sgi.com; Sat, 23 Nov 2013 15:15:34 +0000
Message-Id: <20131123151534.204073240@bombadil.infradead.org>
Date: Sat, 23 Nov 2013 07:11:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/7] xfs: defer EFI and EFD log formatting until iop_format
	time
References: <20131123151151.716201348@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0005-xfs-defer-EFI-and-EFD-log-formatting-until-iop_forma.patch
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

No need to allocate large chunks of memory to format each extent into
an array when logging the EFI or EFD items.  Instead just point to the
bmap free list and only generate the log format at iop_format time.

Also get rid of the now almost empty xfs_trans_extfree.c by merging it
into xfs_extfree_item.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile            |    1 -
 fs/xfs/xfs_bmap.c          |   51 ++++----
 fs/xfs/xfs_bmap.h          |    2 +
 fs/xfs/xfs_bmap_util.c     |   20 ++--
 fs/xfs/xfs_extfree_item.c  |  276 ++++++++++++++++++++++++--------------------
 fs/xfs/xfs_extfree_item.h  |   19 +--
 fs/xfs/xfs_log_recover.c   |   86 +++++++-------
 fs/xfs/xfs_super.c         |   10 +-
 fs/xfs/xfs_trans.h         |   18 +--
 fs/xfs/xfs_trans_extfree.c |  134 ---------------------
 10 files changed, 248 insertions(+), 369 deletions(-)
 delete mode 100644 fs/xfs/xfs_trans_extfree.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index c21f435..0555fb7 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -94,7 +94,6 @@ xfs-y				+= xfs_log.o \
 				   xfs_inode_item.o \
 				   xfs_trans_ail.o \
 				   xfs_trans_buf.o \
-				   xfs_trans_extfree.o \
 				   xfs_trans_inode.o \
 
 # optional features
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 3ef11b2..66bf92a 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -33,11 +33,11 @@
 #include "xfs_btree.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
-#include "xfs_extfree_item.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_extfree_item.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
@@ -591,6 +591,31 @@ xfs_bmap_validate_ret(
  * bmap free list manipulation functions
  */
 
+void
+_xfs_bmap_add_free(
+	xfs_fsblock_t		bno,		/* fs block number of extent */
+	xfs_filblks_t		len,		/* length of extent */
+	struct xfs_bmap_free	*flist)		/* list of extents */
+{
+	struct xfs_bmap_free_item *cur, *new, *prev;
+
+	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
+	new->xbfi_startblock = bno;
+	new->xbfi_blockcount = (xfs_extlen_t)len;
+	for (prev = NULL, cur = flist->xbf_first;
+	     cur != NULL;
+	     prev = cur, cur = cur->xbfi_next) {
+		if (cur->xbfi_startblock >= bno)
+			break;
+	}
+	if (prev)
+		prev->xbfi_next = new;
+	else
+		flist->xbf_first = new;
+	new->xbfi_next = cur;
+	flist->xbf_count++;
+}
+
 /*
  * Add the extent to the list of extents to be free at transaction end.
  * The list is maintained sorted (by block number).
@@ -599,12 +624,9 @@ void
 xfs_bmap_add_free(
 	xfs_fsblock_t		bno,		/* fs block number of extent */
 	xfs_filblks_t		len,		/* length of extent */
-	xfs_bmap_free_t		*flist,		/* list of extents */
-	xfs_mount_t		*mp)		/* mount point structure */
+	struct xfs_bmap_free	*flist,		/* list of extents */
+	struct xfs_mount	*mp)		/* mount point structure */
 {
-	xfs_bmap_free_item_t	*cur;		/* current (next) element */
-	xfs_bmap_free_item_t	*new;		/* new element */
-	xfs_bmap_free_item_t	*prev;		/* previous element */
 #ifdef DEBUG
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
@@ -620,22 +642,7 @@ xfs_bmap_add_free(
 	ASSERT(len < mp->m_sb.sb_agblocks);
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
-	ASSERT(xfs_bmap_free_item_zone != NULL);
-	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
-	new->xbfi_startblock = bno;
-	new->xbfi_blockcount = (xfs_extlen_t)len;
-	for (prev = NULL, cur = flist->xbf_first;
-	     cur != NULL;
-	     prev = cur, cur = cur->xbfi_next) {
-		if (cur->xbfi_startblock >= bno)
-			break;
-	}
-	if (prev)
-		prev->xbfi_next = new;
-	else
-		flist->xbf_first = new;
-	new->xbfi_next = cur;
-	flist->xbf_count++;
+	return _xfs_bmap_add_free(bno, len, flist);
 }
 
 /*
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 33b41f3..f24eb35 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -140,6 +140,8 @@ int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	xfs_bmap_add_free(xfs_fsblock_t bno, xfs_filblks_t len,
 		struct xfs_bmap_free *flist, struct xfs_mount *mp);
+void	_xfs_bmap_add_free(xfs_fsblock_t bno, xfs_filblks_t len,
+		struct xfs_bmap_free *flist);
 void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5887e41..d90ce2c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -30,11 +30,11 @@
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_trans.h"
-#include "xfs_extfree_item.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_extfree_item.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
@@ -89,10 +89,8 @@ xfs_bmap_finish(
 		return 0;
 	}
 	ntp = *tp;
-	efi = xfs_trans_get_efi(ntp, flist->xbf_count);
-	for (free = flist->xbf_first; free; free = free->xbfi_next)
-		xfs_trans_log_efi_extent(ntp, efi, free->xbfi_startblock,
-			free->xbfi_blockcount);
+
+	efi = xfs_trans_log_efi(ntp, flist);
 
 	tres.tr_logres = ntp->t_log_res;
 	tres.tr_logcount = ntp->t_log_count;
@@ -117,8 +115,8 @@ xfs_bmap_finish(
 	error = xfs_trans_reserve(ntp, &tres, 0, 0);
 	if (error)
 		return error;
-	efd = xfs_trans_get_efd(ntp, efi, flist->xbf_count);
-	for (free = flist->xbf_first; free != NULL; free = next) {
+
+	for (free = flist->xbf_first; free != NULL; free = free->xbfi_next) {
 		next = free->xbfi_next;
 		if ((error = xfs_free_extent(ntp, free->xbfi_startblock,
 				free->xbfi_blockcount))) {
@@ -138,8 +136,12 @@ xfs_bmap_finish(
 						   SHUTDOWN_META_IO_ERROR);
 			return error;
 		}
-		xfs_trans_log_efd_extent(ntp, efd, free->xbfi_startblock,
-			free->xbfi_blockcount);
+	}
+
+	efd = xfs_trans_log_efd(ntp, efi, flist);
+
+	for (free = flist->xbf_first; free != NULL; free = next) {
+		next = free->xbfi_next;
 		xfs_bmap_del_free(flist, NULL, free);
 	}
 	return 0;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 94bf5e7..7ed0e01 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_log_format.h"
+#include "xfs_shared.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
@@ -25,6 +26,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
+#include "xfs_bmap.h"
 #include "xfs_extfree_item.h"
 #include "xfs_log.h"
 
@@ -41,10 +43,7 @@ void
 xfs_efi_item_free(
 	struct xfs_efi_log_item	*efip)
 {
-	if (efip->efi_format.efi_nextents > XFS_EFI_MAX_FAST_EXTENTS)
-		kmem_free(efip);
-	else
-		kmem_zone_free(xfs_efi_zone, efip);
+	kmem_zone_free(xfs_efi_zone, efip);
 }
 
 /*
@@ -79,7 +78,7 @@ xfs_efi_item_sizeof(
 	struct xfs_efi_log_item *efip)
 {
 	return sizeof(struct xfs_efi_log_format) +
-	       (efip->efi_format.efi_nextents - 1) * sizeof(xfs_extent_t);
+	       (efip->efi_flist.xbf_count - 1) * sizeof(xfs_extent_t);
 }
 
 STATIC void
@@ -105,22 +104,28 @@ xfs_efi_item_format(
 	struct xfs_log_vec	*lv)
 {
 	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
+	struct xfs_efi_log_format *elf;
+	struct xfs_bmap_free_item *free;
 	struct xfs_log_iovec	*vec;
-	int			size;
+	int			e = 0;
 
-	ASSERT(atomic_read(&efip->efi_next_extent) ==
-				efip->efi_format.efi_nextents);
+	vec = xlog_first_iovec(lv);
+	vec->i_len = xfs_efi_item_sizeof(efip);
+	vec->i_type = XLOG_REG_TYPE_EFI_FORMAT;
 
-	efip->efi_format.efi_type = XFS_LI_EFI;
-	efip->efi_format.efi_size = 1;
+	elf = vec->i_addr;
+	elf->efi_type = XFS_LI_EFI;
+	elf->efi_size = 1;
+	elf->efi_nextents = efip->efi_flist.xbf_count;
+	elf->efi_id = efip->efi_id;
 
-	size = xfs_efi_item_sizeof(efip);
-	ASSERT(size >= sizeof(xfs_efi_log_format_t));
+	for (free = efip->efi_flist.xbf_first; free; free = free->xbfi_next) {
+		atomic_inc(&efip->efi_next_extent);
 
-	vec = xlog_first_iovec(lv);
-	memcpy(vec->i_addr, &efip->efi_format, size);
-	vec->i_len = size;
-	vec->i_type = XLOG_REG_TYPE_EFI_FORMAT;
+		elf->efi_extents[e].ext_start = free->xbfi_startblock;
+		elf->efi_extents[e].ext_len = free->xbfi_blockcount;
+		e++;
+	}
 
 	xlog_last_iovec(lv, vec);
 }
@@ -222,91 +227,118 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_committing = xfs_efi_item_committing
 };
 
-
 /*
  * Allocate and initialize an efi item with the given number of extents.
  */
-struct xfs_efi_log_item *
+STATIC struct xfs_efi_log_item *
 xfs_efi_init(
-	struct xfs_mount	*mp,
-	uint			nextents)
+	struct xfs_mount	*mp)
 
 {
 	struct xfs_efi_log_item	*efip;
-	uint			size;
-
-	ASSERT(nextents > 0);
-	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
-		size = (uint)(sizeof(xfs_efi_log_item_t) +
-			((nextents - 1) * sizeof(xfs_extent_t)));
-		efip = kmem_zalloc(size, KM_SLEEP);
-	} else {
-		efip = kmem_zone_zalloc(xfs_efi_zone, KM_SLEEP);
-	}
 
+	efip = kmem_zone_zalloc(xfs_efi_zone, KM_SLEEP);
 	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
-	efip->efi_format.efi_nextents = nextents;
-	efip->efi_format.efi_id = (__psint_t)(void*)efip;
+
 	atomic_set(&efip->efi_next_extent, 0);
 	atomic_set(&efip->efi_refcount, 2);
+	efip->efi_id = (unsigned long)efip;
 
 	return efip;
 }
 
 /*
- * Copy an EFI format buffer from the given buf, and into the destination
- * EFI format structure.
+ * Signal the intent to free all extents contained on the passed freelist.
+ */
+struct xfs_efi_log_item *
+xfs_trans_log_efi(
+	struct xfs_trans		*tp,
+	struct xfs_bmap_free		*flist)
+{
+	struct xfs_efi_log_item		*efi;
+
+	ASSERT(flist->xbf_count > 0);
+
+	efi = xfs_efi_init(tp->t_mountp);
+	xfs_trans_add_item(tp, &efi->efi_item);
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	efi->efi_item.li_desc->lid_flags |= XFS_LID_DIRTY;
+
+	/*
+	 * We use a structure assignment here to make life easier for the log
+	 * recovery code.  The structure must not be modified in the log item
+	 * code.
+	 */
+	efi->efi_flist = *flist;
+	return efi;
+}
+
+
+static inline int
+xfs_efi_format32_sizeof(
+	struct xfs_efi_log_format	*elf)
+{
+	return sizeof(struct xfs_efi_log_format_32) + 
+		(elf->efi_nextents - 1) * sizeof(struct xfs_extent_32);
+}
+
+static inline int
+xfs_efi_format64_sizeof(
+	struct xfs_efi_log_format	*elf)
+{
+	return sizeof(struct xfs_efi_log_format_64) + 
+		(elf->efi_nextents - 1) * sizeof(struct xfs_extent_64);
+}
+
+/*
+ * Create and EFI from a given buffer recovered from disk.
+ *
  * The given buffer can be in 32 bit or 64 bit form (which has different padding),
  * one of which will be the native format for this kernel.
- * It will handle the conversion of formats if necessary.
  */
 int
-xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
+xfs_efi_item_from_disk(
+	struct xfs_mount		*mp,
+	struct xfs_log_iovec		*vec,
+	struct xfs_efi_log_item		**efipp)
 {
-	xfs_efi_log_format_t *src_efi_fmt = buf->i_addr;
-	uint i;
-	uint len = sizeof(xfs_efi_log_format_t) + 
-		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_t);  
-	uint len32 = sizeof(xfs_efi_log_format_32_t) + 
-		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_32_t);  
-	uint len64 = sizeof(xfs_efi_log_format_64_t) + 
-		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_64_t);  
-
-	if (buf->i_len == len) {
-		memcpy((char *)dst_efi_fmt, (char*)src_efi_fmt, len);
-		return 0;
-	} else if (buf->i_len == len32) {
-		xfs_efi_log_format_32_t *src_efi_fmt_32 = buf->i_addr;
-
-		dst_efi_fmt->efi_type     = src_efi_fmt_32->efi_type;
-		dst_efi_fmt->efi_size     = src_efi_fmt_32->efi_size;
-		dst_efi_fmt->efi_nextents = src_efi_fmt_32->efi_nextents;
-		dst_efi_fmt->efi_id       = src_efi_fmt_32->efi_id;
-		for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
-			dst_efi_fmt->efi_extents[i].ext_start =
-				src_efi_fmt_32->efi_extents[i].ext_start;
-			dst_efi_fmt->efi_extents[i].ext_len =
-				src_efi_fmt_32->efi_extents[i].ext_len;
+	struct xfs_efi_log_item		*efip;
+	int				e;
+
+	efip = xfs_efi_init(mp);
+
+	if (vec->i_len == xfs_efi_format32_sizeof(vec->i_addr)) {
+		struct xfs_efi_log_format_32	*elf32 = vec->i_addr;
+
+		for (e = 0; e < elf32->efi_nextents; e++) {
+			_xfs_bmap_add_free(elf32->efi_extents[e].ext_start,
+					   elf32->efi_extents[e].ext_len,
+					   &efip->efi_flist);
 		}
-		return 0;
-	} else if (buf->i_len == len64) {
-		xfs_efi_log_format_64_t *src_efi_fmt_64 = buf->i_addr;
-
-		dst_efi_fmt->efi_type     = src_efi_fmt_64->efi_type;
-		dst_efi_fmt->efi_size     = src_efi_fmt_64->efi_size;
-		dst_efi_fmt->efi_nextents = src_efi_fmt_64->efi_nextents;
-		dst_efi_fmt->efi_id       = src_efi_fmt_64->efi_id;
-		for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
-			dst_efi_fmt->efi_extents[i].ext_start =
-				src_efi_fmt_64->efi_extents[i].ext_start;
-			dst_efi_fmt->efi_extents[i].ext_len =
-				src_efi_fmt_64->efi_extents[i].ext_len;
+		efip->efi_id = elf32->efi_id;
+	} else if (vec->i_len == xfs_efi_format64_sizeof(vec->i_addr)) {
+		struct xfs_efi_log_format_64	*elf64 = vec->i_addr;
+
+		for (e = 0; e < elf64->efi_nextents; e++) {
+			_xfs_bmap_add_free(elf64->efi_extents[e].ext_start,
+					   elf64->efi_extents[e].ext_len,
+					   &efip->efi_flist);
 		}
-		return 0;
+		efip->efi_id = elf64->efi_id;
+	} else {
+		xfs_warn(mp, "invalid inode free log item (size = %d)\n",
+			     vec->i_len);
+		xfs_efi_item_free(efip);
+		return EFSCORRUPTED;
 	}
-	return EFSCORRUPTED;
+
+	atomic_set(&efip->efi_next_extent, efip->efi_flist.xbf_count);
+	*efipp = efip;
+	return 0;
 }
 
+
 /*
  * This is called by the efd item code below to release references to the given
  * efi item.  Each efd calls this with the number of extents that it has
@@ -318,14 +350,8 @@ xfs_efi_release(xfs_efi_log_item_t	*efip,
 		uint			nextents)
 {
 	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
-	if (atomic_sub_and_test(nextents, &efip->efi_next_extent)) {
-		/* recovery needs us to drop the EFI reference, too */
-		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
-			__xfs_efi_release(efip);
-
+	if (atomic_sub_and_test(nextents, &efip->efi_next_extent))
 		__xfs_efi_release(efip);
-		/* efip may now have been freed, do not reference it again. */
-	}
 }
 
 static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
@@ -333,15 +359,6 @@ static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_efd_log_item, efd_item);
 }
 
-STATIC void
-xfs_efd_item_free(struct xfs_efd_log_item *efdp)
-{
-	if (efdp->efd_format.efd_nextents > XFS_EFD_MAX_FAST_EXTENTS)
-		kmem_free(efdp);
-	else
-		kmem_zone_free(xfs_efd_zone, efdp);
-}
-
 /*
  * This returns the number of iovecs needed to log the given efd item.
  * We only need 1 iovec for an efd item.  It just logs the efd_log_format
@@ -352,7 +369,7 @@ xfs_efd_item_sizeof(
 	struct xfs_efd_log_item *efdp)
 {
 	return sizeof(xfs_efd_log_format_t) +
-	       (efdp->efd_format.efd_nextents - 1) * sizeof(xfs_extent_t);
+	       (efdp->efd_flist.xbf_count - 1) * sizeof(xfs_extent_t);
 }
 
 STATIC void
@@ -378,18 +395,27 @@ xfs_efd_item_format(
 	struct xfs_log_vec	*lv)
 {
 	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
+	struct xfs_efd_log_format *efd;
 	struct xfs_log_iovec	*vec;
-
-	ASSERT(efdp->efd_next_extent == efdp->efd_format.efd_nextents);
-
-	efdp->efd_format.efd_type = XFS_LI_EFD;
-	efdp->efd_format.efd_size = 1;
+	struct xfs_bmap_free_item *free;
+	int			e = 0;
 
 	vec = xlog_first_iovec(lv);
-	memcpy(vec->i_addr, &efdp->efd_format, xfs_efd_item_sizeof(efdp));
-	vec->i_len = xfs_efd_item_sizeof(efdp);
 	vec->i_type = XLOG_REG_TYPE_EFD_FORMAT;
-	ASSERT(vec->i_len >= sizeof(xfs_efd_log_format_t));
+	vec->i_len = xfs_efd_item_sizeof(efdp);
+
+	efd = vec->i_addr;
+	efd->efd_type = XFS_LI_EFD;
+	efd->efd_size = 1;
+	efd->efd_efi_id = (unsigned long)efdp->efd_efip;
+
+	efd->efd_nextents = efdp->efd_flist.xbf_count;
+
+	for (free = efdp->efd_flist.xbf_first; free; free = free->xbfi_next) {
+		efd->efd_extents[e].ext_start = free->xbfi_startblock;
+		efd->efd_extents[e].ext_len = free->xbfi_blockcount;
+		e++;
+	}
 
 	xlog_last_iovec(lv, vec);
 }
@@ -431,7 +457,7 @@ xfs_efd_item_unlock(
 	struct xfs_log_item	*lip)
 {
 	if (lip->li_flags & XFS_LI_ABORTED)
-		xfs_efd_item_free(EFD_ITEM(lip));
+		kmem_zone_free(xfs_efd_zone, EFD_ITEM(lip));
 }
 
 /*
@@ -453,9 +479,9 @@ xfs_efd_item_committed(
 	 * EFI got unpinned and freed before the EFD got aborted.
 	 */
 	if (!(lip->li_flags & XFS_LI_ABORTED))
-		xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
+		xfs_efi_release(efdp->efd_efip, efdp->efd_flist.xbf_count);
 
-	xfs_efd_item_free(efdp);
+	kmem_zone_free(xfs_efd_zone, efdp);
 	return (xfs_lsn_t)-1;
 }
 
@@ -487,32 +513,32 @@ static const struct xfs_item_ops xfs_efd_item_ops = {
 	.iop_committing = xfs_efd_item_committing
 };
 
-/*
- * Allocate and initialize an efd item with the given number of extents.
- */
 struct xfs_efd_log_item *
-xfs_efd_init(
-	struct xfs_mount	*mp,
-	struct xfs_efi_log_item	*efip,
-	uint			nextents)
-
+xfs_trans_log_efd(
+	struct xfs_trans		*tp,
+	struct xfs_efi_log_item		*efip,
+	struct xfs_bmap_free		*flist)
 {
-	struct xfs_efd_log_item	*efdp;
-	uint			size;
-
-	ASSERT(nextents > 0);
-	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
-		size = (uint)(sizeof(xfs_efd_log_item_t) +
-			((nextents - 1) * sizeof(xfs_extent_t)));
-		efdp = kmem_zalloc(size, KM_SLEEP);
-	} else {
-		efdp = kmem_zone_zalloc(xfs_efd_zone, KM_SLEEP);
-	}
+	struct xfs_efd_log_item		*efdp;
+
+	ASSERT(flist->xbf_count > 0);
+
+	efdp = kmem_zone_zalloc(xfs_efd_zone, KM_SLEEP);
+
+	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
+			  &xfs_efd_item_ops);
+	xfs_trans_add_item(tp, &efdp->efd_item);
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	efdp->efd_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 
-	xfs_log_item_init(mp, &efdp->efd_item, XFS_LI_EFD, &xfs_efd_item_ops);
 	efdp->efd_efip = efip;
-	efdp->efd_format.efd_nextents = nextents;
-	efdp->efd_format.efd_efi_id = efip->efi_format.efi_id;
 
+	/*
+	 * We use a structure assignment here to make life easier for the log
+	 * recovery code.  The structure must not be modified in the log item
+	 * code.
+	 */
+	efdp->efd_flist = *flist;
 	return efdp;
 }
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 0ffbce3..724a7e4 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -48,7 +48,8 @@ typedef struct xfs_efi_log_item {
 	atomic_t		efi_refcount;
 	atomic_t		efi_next_extent;
 	unsigned long		efi_flags;	/* misc flags */
-	xfs_efi_log_format_t	efi_format;
+	struct xfs_bmap_free	efi_flist;
+	unsigned long		efi_id;
 } xfs_efi_log_item_t;
 
 /*
@@ -59,23 +60,15 @@ typedef struct xfs_efi_log_item {
 typedef struct xfs_efd_log_item {
 	xfs_log_item_t		efd_item;
 	xfs_efi_log_item_t	*efd_efip;
-	uint			efd_next_extent;
-	xfs_efd_log_format_t	efd_format;
+	struct xfs_bmap_free	efd_flist;
 } xfs_efd_log_item_t;
 
-/*
- * Max number of extents in fast allocation path.
- */
-#define	XFS_EFD_MAX_FAST_EXTENTS	16
-
 extern struct kmem_zone	*xfs_efi_zone;
 extern struct kmem_zone	*xfs_efd_zone;
 
-xfs_efi_log_item_t	*xfs_efi_init(struct xfs_mount *, uint);
-xfs_efd_log_item_t	*xfs_efd_init(struct xfs_mount *, xfs_efi_log_item_t *,
-				      uint);
-int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
-					    xfs_efi_log_format_t *dst_efi_fmt);
 void			xfs_efi_item_free(xfs_efi_log_item_t *);
+int			xfs_efi_item_from_disk(struct xfs_mount *,
+					       struct xfs_log_iovec *,
+					       struct xfs_efi_log_item **);
 
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b6b669d..61e8587 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -33,7 +33,6 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 #include "xfs_inode_item.h"
-#include "xfs_extfree_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
@@ -42,6 +41,9 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_extfree_item.h"
 #include "xfs_dinode.h"
 #include "xfs_error.h"
 #include "xfs_dir2.h"
@@ -3059,30 +3061,17 @@ xlog_recover_efi_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			lsn)
 {
-	int			error;
-	xfs_mount_t		*mp = log->l_mp;
-	xfs_efi_log_item_t	*efip;
-	xfs_efi_log_format_t	*efi_formatp;
-
-	efi_formatp = item->ri_buf[0].i_addr;
+	struct xfs_efi_log_item		*efip;
+	int				error;
 
-	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
-	if ((error = xfs_efi_copy_format(&(item->ri_buf[0]),
-					 &(efip->efi_format)))) {
-		xfs_efi_item_free(efip);
-		return error;
+	error = xfs_efi_item_from_disk(log->l_mp, &item->ri_buf[0], &efip);
+	if (!error) {
+		spin_lock(&log->l_ailp->xa_lock);
+		xfs_trans_ail_update(log->l_ailp, &efip->efi_item, lsn);
 	}
-	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
-
-	spin_lock(&log->l_ailp->xa_lock);
-	/*
-	 * xfs_trans_ail_update() drops the AIL lock.
-	 */
-	xfs_trans_ail_update(log->l_ailp, &efip->efi_item, lsn);
-	return 0;
+	return error;
 }
 
-
 /*
  * This routine is called when an efd format structure is found in
  * a committed transaction in the log.  It's purpose is to cancel
@@ -3119,7 +3108,7 @@ xlog_recover_efd_pass2(
 	while (lip != NULL) {
 		if (lip->li_type == XFS_LI_EFI) {
 			efip = (xfs_efi_log_item_t *)lip;
-			if (efip->efi_format.efi_id == efi_id) {
+			if (efip->efi_id == efi_id) {
 				/*
 				 * xfs_trans_ail_delete() drops the
 				 * AIL lock.
@@ -3626,34 +3615,33 @@ xlog_recover_process_efi(
 	xfs_mount_t		*mp,
 	xfs_efi_log_item_t	*efip)
 {
-	xfs_efd_log_item_t	*efdp;
-	xfs_trans_t		*tp;
-	int			i;
-	int			error = 0;
-	xfs_extent_t		*extp;
+	struct xfs_trans	*tp;
+	struct xfs_efd_log_item *efdp;
+	struct xfs_bmap_free_item *free, *next;
 	xfs_fsblock_t		startblock_fsb;
+	int			error = 0;
 
 	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
 
 	/*
-	 * First check the validity of the extents described by the
-	 * EFI.  If any are bad, then assume that all are bad and
-	 * just toss the EFI.
+	 * First check the validity of the extents described by the EFI.  If
+	 * any are bad, then assume that all are bad and just toss the EFI.
 	 */
-	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
-		extp = &(efip->efi_format.efi_extents[i]);
-		startblock_fsb = XFS_BB_TO_FSB(mp,
-				   XFS_FSB_TO_DADDR(mp, extp->ext_start));
-		if ((startblock_fsb == 0) ||
-		    (extp->ext_len == 0) ||
-		    (startblock_fsb >= mp->m_sb.sb_dblocks) ||
-		    (extp->ext_len >= mp->m_sb.sb_agblocks)) {
+	for (free = efip->efi_flist.xbf_first; free; free = free->xbfi_next) {
+		startblock_fsb =
+			XFS_BB_TO_FSB(mp,
+				XFS_FSB_TO_DADDR(mp, free->xbfi_startblock));
+
+		if (startblock_fsb == 0 ||
+		    free->xbfi_blockcount == 0 ||
+		    startblock_fsb >= mp->m_sb.sb_dblocks ||
+		    free->xbfi_blockcount >= mp->m_sb.sb_agblocks) {
 			/*
-			 * This will pull the EFI from the AIL and
-			 * free the memory associated with it.
+			 * This will pull the EFI from the AIL and free the
+			 * memory associated with it.
 			 */
 			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
-			xfs_efi_release(efip, efip->efi_format.efi_nextents);
+			xfs_efi_release(efip, efip->efi_flist.xbf_count);
 			return XFS_ERROR(EIO);
 		}
 	}
@@ -3662,15 +3650,19 @@ xlog_recover_process_efi(
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
 	if (error)
 		goto abort_error;
-	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
 
-	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
-		extp = &(efip->efi_format.efi_extents[i]);
-		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len);
+	for (free = efip->efi_flist.xbf_first; free; free = free->xbfi_next) {
+		error = xfs_free_extent(tp, free->xbfi_startblock,
+					    free->xbfi_blockcount);
 		if (error)
 			goto abort_error;
-		xfs_trans_log_efd_extent(tp, efdp, extp->ext_start,
-					 extp->ext_len);
+	}
+
+	efdp = xfs_trans_log_efd(tp, efip, &efip->efi_flist);
+
+	for (free = efip->efi_flist.xbf_first; free != NULL; free = next) {
+		next = free->xbfi_next;
+		xfs_bmap_del_free(&efip->efi_flist, NULL, free);
 	}
 
 	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d971f49..368232e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1620,15 +1620,13 @@ xfs_init_zones(void)
 	if (!xfs_buf_item_zone)
 		goto out_destroy_log_item_desc_zone;
 
-	xfs_efd_zone = kmem_zone_init((sizeof(xfs_efd_log_item_t) +
-			((XFS_EFD_MAX_FAST_EXTENTS - 1) *
-				 sizeof(xfs_extent_t))), "xfs_efd_item");
+	xfs_efd_zone =
+		kmem_zone_init(sizeof(struct xfs_efd_log_item), "xfs_efd_item");
 	if (!xfs_efd_zone)
 		goto out_destroy_buf_item_zone;
 
-	xfs_efi_zone = kmem_zone_init((sizeof(xfs_efi_log_item_t) +
-			((XFS_EFI_MAX_FAST_EXTENTS - 1) *
-				sizeof(xfs_extent_t))), "xfs_efi_item");
+	xfs_efi_zone =
+		kmem_zone_init(sizeof(struct xfs_efi_log_item), "xfs_efi_item");
 	if (!xfs_efi_zone)
 		goto out_destroy_efd_zone;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index b5bc1ab..f6b4cf0 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -20,6 +20,7 @@
 
 /* kernel only transaction subsystem defines */
 
+struct xfs_bmap_free;
 struct xfs_buf;
 struct xfs_buftarg;
 struct xfs_efd_log_item;
@@ -215,19 +216,12 @@ void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
-struct xfs_efi_log_item	*xfs_trans_get_efi(xfs_trans_t *, uint);
 void		xfs_efi_release(struct xfs_efi_log_item *, uint);
-void		xfs_trans_log_efi_extent(xfs_trans_t *,
-					 struct xfs_efi_log_item *,
-					 xfs_fsblock_t,
-					 xfs_extlen_t);
-struct xfs_efd_log_item	*xfs_trans_get_efd(xfs_trans_t *,
-				  struct xfs_efi_log_item *,
-				  uint);
-void		xfs_trans_log_efd_extent(xfs_trans_t *,
-					 struct xfs_efd_log_item *,
-					 xfs_fsblock_t,
-					 xfs_extlen_t);
+struct xfs_efi_log_item *xfs_trans_log_efi(struct xfs_trans *,
+			struct xfs_bmap_free *);
+struct xfs_efd_log_item	*xfs_trans_log_efd(struct xfs_trans *,
+			struct xfs_efi_log_item *,
+			struct xfs_bmap_free *);
 int		xfs_trans_commit(xfs_trans_t *, uint flags);
 int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 void		xfs_trans_cancel(xfs_trans_t *, int);
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
deleted file mode 100644
index 47978ba..0000000
--- a/fs/xfs/xfs_trans_extfree.c
+++ /dev/null
@@ -1,134 +0,0 @@
-/*
- * Copyright (c) 2000,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
-#include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
-#include "xfs_extfree_item.h"
-
-/*
- * This routine is called to allocate an "extent free intention"
- * log item that will hold nextents worth of extents.  The
- * caller must use all nextents extents, because we are not
- * flexible about this at all.
- */
-xfs_efi_log_item_t *
-xfs_trans_get_efi(xfs_trans_t	*tp,
-		  uint		nextents)
-{
-	xfs_efi_log_item_t	*efip;
-
-	ASSERT(tp != NULL);
-	ASSERT(nextents > 0);
-
-	efip = xfs_efi_init(tp->t_mountp, nextents);
-	ASSERT(efip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &efip->efi_item);
-	return efip;
-}
-
-/*
- * This routine is called to indicate that the described
- * extent is to be logged as needing to be freed.  It should
- * be called once for each extent to be freed.
- */
-void
-xfs_trans_log_efi_extent(xfs_trans_t		*tp,
-			 xfs_efi_log_item_t	*efip,
-			 xfs_fsblock_t		start_block,
-			 xfs_extlen_t		ext_len)
-{
-	uint			next_extent;
-	xfs_extent_t		*extp;
-
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	efip->efi_item.li_desc->lid_flags |= XFS_LID_DIRTY;
-
-	/*
-	 * atomic_inc_return gives us the value after the increment;
-	 * we want to use it as an array index so we need to subtract 1 from
-	 * it.
-	 */
-	next_extent = atomic_inc_return(&efip->efi_next_extent) - 1;
-	ASSERT(next_extent < efip->efi_format.efi_nextents);
-	extp = &(efip->efi_format.efi_extents[next_extent]);
-	extp->ext_start = start_block;
-	extp->ext_len = ext_len;
-}
-
-
-/*
- * This routine is called to allocate an "extent free done"
- * log item that will hold nextents worth of extents.  The
- * caller must use all nextents extents, because we are not
- * flexible about this at all.
- */
-xfs_efd_log_item_t *
-xfs_trans_get_efd(xfs_trans_t		*tp,
-		  xfs_efi_log_item_t	*efip,
-		  uint			nextents)
-{
-	xfs_efd_log_item_t	*efdp;
-
-	ASSERT(tp != NULL);
-	ASSERT(nextents > 0);
-
-	efdp = xfs_efd_init(tp->t_mountp, efip, nextents);
-	ASSERT(efdp != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &efdp->efd_item);
-	return efdp;
-}
-
-/*
- * This routine is called to indicate that the described
- * extent is to be logged as having been freed.  It should
- * be called once for each extent freed.
- */
-void
-xfs_trans_log_efd_extent(xfs_trans_t		*tp,
-			 xfs_efd_log_item_t	*efdp,
-			 xfs_fsblock_t		start_block,
-			 xfs_extlen_t		ext_len)
-{
-	uint			next_extent;
-	xfs_extent_t		*extp;
-
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	efdp->efd_item.li_desc->lid_flags |= XFS_LID_DIRTY;
-
-	next_extent = efdp->efd_next_extent;
-	ASSERT(next_extent < efdp->efd_format.efd_nextents);
-	extp = &(efdp->efd_format.efd_extents[next_extent]);
-	extp->ext_start = start_block;
-	extp->ext_len = ext_len;
-	efdp->efd_next_extent++;
-}
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
