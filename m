Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C97D7F4E
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 00:44:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3F23C8F8039
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 22:44:46 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	lYlqFlULvslEvjG4 for <xfs@oss.sgi.com>;
	Sun, 30 Jun 2013 22:44:42 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UtWuj-0001Fu-4a
	for xfs@oss.sgi.com; Mon, 01 Jul 2013 15:44:37 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UtWuj-0002Pb-0G
	for xfs@oss.sgi.com; Mon, 01 Jul 2013 15:44:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: optimise CIL insertion during transaction commit [RFC]
Date: Mon,  1 Jul 2013 15:44:36 +1000
Message-Id: <1372657476-9241-1-git-send-email-david@fromorbit.com>
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

Note: This is an RFC right now - it'll need to be broken up into
several patches for final submission.

The CIL insertion during transaction commit currently does multiple
passes across the transaction objects and requires multiple memory
allocations per object that is to be inserted into the CIL. It is
quite inefficient, and as such xfs_log_commit_cil() and it's
children show up quite highly in profiles under metadata
modification intensive workloads.

The current insertion tries to minimise ithe number of times the
xc_cil_lock is grabbed and the hold times via a couple of methods:

	1. an initial loop across the transaction items outside the
	lock to allocate log vectors, buffers and copy the data into
	them.
	2. a second pass across the log vectors that then inserts
	them into the CIL, modifies the CIL state and frees the old
	vectors.

This is somewhat inefficient. While it minimises lock grabs, the
hold time is still quite high because we are freeing objects with
the spinlock held and so the hold times are much higher than they
need to be.

Optimisations that can be made:

	1. change IOP_SIZE() to return the size of the metadata to
	be logged with the number of vectors required. This means we
	can allocate the buffer to hold the metadata as part of the
	allocation for the log vector array. Once allocation instead
	of two.

	2. Store the size of the allocated region for the log vector
	in the log vector itself. This allows us to determine if we
	can just reuse the existing log vector for the new
	transactions. Avoids all memory allocation for that item.

	3. when setting up a new log vector, we don't need to
	hold the CIL lock while determining the difference in it's
	size when compared to the old one. Hence we can do all the
	accounting, swapping of the log vectors and freeing the old
	log vectors outside the xc_cil_lock.

	4. We can do all the CIL insertation of items and busy
	extents and the accounting under a single grab of the
	xc_cil_lock. This minimises the number of times we need to
	grab it and hence contention points are kept to a minimum

	5. the xc_cil_lock is used for serialising both the CIL and
	the push/commit ordering. Separate the two functions into
	different locks so push/commit ordering does not affect CIL
	insertion

	6. the xc_cil_lock shares cachelines with other locks.
	Separate them onto different cachelines.

The result is that my standard fsmark benchmark (8-way, 50m files)
on my standard test VM (8-way, 4GB RAM, 4xSSD in RAID0, 100TB fs)
gives the following results with a xfs-oss tree. No CRCs:

                vanilla         patched         Difference
create  (time)  483s            435s            -10.0%  (faster)
        (rate)  109k+/6k        122k+/-7k       +11.9%  (faster)

walk            339s            335s            (noise)
     (sys cpu)  1134s           1135s           (noise)

unlink          692s            645s             -6.8%  (faster)

So it's significantly faster than the current code, and lock_stat
reports lower contention on the xc_cil_lock, too. So, big win here.

With CRCs:

                vanilla         patched         Difference
create  (time)  510s            460s             -9.8%  (faster)
        (rate)  105k+/5.4k      117k+/-5k       +11.4%  (faster)

walk            494s            486s            (noise)
     (sys cpu)  1324s           1290s           (noise)

unlink          959s            889s             -7.3%  (faster)

Gains are of the same order, with walk and unlink still affected by
VFS LRU lock contention. IOWs, with this changes, filesystems with
CRCs enabled will still be faster than the old non-CRC kernels...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c     |   52 ++++---
 fs/xfs/xfs_dquot_item.c   |   22 +--
 fs/xfs/xfs_extfree_item.c |   50 ++++---
 fs/xfs/xfs_icreate_item.c |    9 +-
 fs/xfs/xfs_inode_item.c   |   52 ++++---
 fs/xfs/xfs_log.h          |    1 +
 fs/xfs/xfs_log_cil.c      |  366 +++++++++++++++++++++++----------------------
 fs/xfs/xfs_log_priv.h     |    7 +-
 fs/xfs/xfs_trans.h        |    4 +-
 9 files changed, 311 insertions(+), 252 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index bfc4e0c..9358504 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -39,6 +39,14 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 
 STATIC void	xfs_buf_do_callbacks(struct xfs_buf *bp);
 
+static inline int
+xfs_buf_log_format_size(
+	struct xfs_buf_log_format *blfp)
+{
+	return offsetof(struct xfs_buf_log_format, blf_data_map) +
+			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
+}
+
 /*
  * This returns the number of log iovecs needed to log the
  * given buf log item.
@@ -49,25 +57,27 @@ STATIC void	xfs_buf_do_callbacks(struct xfs_buf *bp);
  *
  * If the XFS_BLI_STALE flag has been set, then log nothing.
  */
-STATIC uint
+STATIC void
 xfs_buf_item_size_segment(
 	struct xfs_buf_log_item	*bip,
-	struct xfs_buf_log_format *blfp)
+	struct xfs_buf_log_format *blfp,
+	int			*nvecs,
+	int			*nbytes)
 {
 	struct xfs_buf		*bp = bip->bli_buf;
-	uint			nvecs;
 	int			next_bit;
 	int			last_bit;
 
 	last_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
 	if (last_bit == -1)
-		return 0;
+		return;
 
 	/*
 	 * initial count for a dirty buffer is 2 vectors - the format structure
 	 * and the first dirty region.
 	 */
-	nvecs = 2;
+	*nvecs += 2;
+	*nbytes += xfs_buf_log_format_size(blfp) + XFS_BLF_CHUNK;
 
 	while (last_bit != -1) {
 		/*
@@ -87,18 +97,17 @@ xfs_buf_item_size_segment(
 			break;
 		} else if (next_bit != last_bit + 1) {
 			last_bit = next_bit;
-			nvecs++;
+			(*nvecs)++;
 		} else if (xfs_buf_offset(bp, next_bit * XFS_BLF_CHUNK) !=
 			   (xfs_buf_offset(bp, last_bit * XFS_BLF_CHUNK) +
 			    XFS_BLF_CHUNK)) {
 			last_bit = next_bit;
-			nvecs++;
+			(*nvecs)++;
 		} else {
 			last_bit++;
 		}
+		*nbytes += XFS_BLF_CHUNK;
 	}
-
-	return nvecs;
 }
 
 /*
@@ -118,12 +127,13 @@ xfs_buf_item_size_segment(
  * If the XFS_BLI_STALE flag has been set, then log nothing but the buf log
  * format structures.
  */
-STATIC uint
+STATIC void
 xfs_buf_item_size(
-	struct xfs_log_item	*lip)
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
-	uint			nvecs;
 	int			i;
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
@@ -135,7 +145,11 @@ xfs_buf_item_size(
 		 */
 		trace_xfs_buf_item_size_stale(bip);
 		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		return bip->bli_format_count;
+		*nvecs += bip->bli_format_count;
+		for (i = 0; i < bip->bli_format_count; i++) {
+			*nbytes += xfs_buf_log_format_size(&bip->bli_formats[i]);
+		}
+		return;
 	}
 
 	ASSERT(bip->bli_flags & XFS_BLI_LOGGED);
@@ -147,7 +161,8 @@ xfs_buf_item_size(
 		 * commit, so no vectors are used at all.
 		 */
 		trace_xfs_buf_item_size_ordered(bip);
-		return XFS_LOG_VEC_ORDERED;
+		*nvecs = XFS_LOG_VEC_ORDERED;
+		return;
 	}
 
 	/*
@@ -159,13 +174,11 @@ xfs_buf_item_size(
 	 * count for the extra buf log format structure that will need to be
 	 * written.
 	 */
-	nvecs = 0;
 	for (i = 0; i < bip->bli_format_count; i++) {
-		nvecs += xfs_buf_item_size_segment(bip, &bip->bli_formats[i]);
+		xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
+					  nvecs, nbytes);
 	}
-
 	trace_xfs_buf_item_size(bip);
-	return nvecs;
 }
 
 static struct xfs_log_iovec *
@@ -192,8 +205,7 @@ xfs_buf_item_format_segment(
 	 * the actual size of the dirty bitmap rather than the size of the in
 	 * memory structure.
 	 */
-	base_size = offsetof(struct xfs_buf_log_format, blf_data_map) +
-			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
+	base_size = xfs_buf_log_format_size(blfp);
 
 	nvecs = 0;
 	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index f07a436..60c6e1f 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -44,14 +44,15 @@ static inline struct xfs_dq_logitem *DQUOT_ITEM(struct xfs_log_item *lip)
 /*
  * returns the number of iovecs needed to log the given dquot item.
  */
-STATIC uint
+STATIC void
 xfs_qm_dquot_logitem_size(
-	struct xfs_log_item	*lip)
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
 {
-	/*
-	 * we need only two iovecs, one for the format, one for the real thing
-	 */
-	return 2;
+	*nvecs += 2;
+	*nbytes += sizeof(struct xfs_dq_logformat) +
+		   sizeof(struct xfs_disk_dquot);
 }
 
 /*
@@ -286,11 +287,14 @@ static inline struct xfs_qoff_logitem *QOFF_ITEM(struct xfs_log_item *lip)
  * We only need 1 iovec for an quotaoff item.  It just logs the
  * quotaoff_log_format structure.
  */
-STATIC uint
+STATIC void
 xfs_qm_qoff_logitem_size(
-	struct xfs_log_item	*lip)
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
 {
-	return 1;
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_qoff_logitem);
 }
 
 /*
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 452920a..dc53e8f 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -73,11 +73,22 @@ __xfs_efi_release(
  * We only need 1 iovec for an efi item.  It just logs the efi_log_format
  * structure.
  */
-STATIC uint
+static inline int
+xfs_efi_item_sizeof(
+	struct xfs_efi_log_item *efip)
+{
+	return sizeof(struct xfs_efi_log_format) +
+	       (efip->efi_format.efi_nextents - 1) * sizeof(xfs_extent_t);
+}
+
+STATIC void
 xfs_efi_item_size(
-	struct xfs_log_item	*lip)
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
 {
-	return 1;
+	*nvecs += 1;
+	*nbytes += xfs_efi_item_sizeof(EFI_ITEM(lip));
 }
 
 /*
@@ -93,21 +104,17 @@ xfs_efi_item_format(
 	struct xfs_log_iovec	*log_vector)
 {
 	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
-	uint			size;
 
 	ASSERT(atomic_read(&efip->efi_next_extent) ==
 				efip->efi_format.efi_nextents);
 
 	efip->efi_format.efi_type = XFS_LI_EFI;
-
-	size = sizeof(xfs_efi_log_format_t);
-	size += (efip->efi_format.efi_nextents - 1) * sizeof(xfs_extent_t);
 	efip->efi_format.efi_size = 1;
 
 	log_vector->i_addr = &efip->efi_format;
-	log_vector->i_len = size;
+	log_vector->i_len = xfs_efi_item_sizeof(efip);
 	log_vector->i_type = XLOG_REG_TYPE_EFI_FORMAT;
-	ASSERT(size >= sizeof(xfs_efi_log_format_t));
+	ASSERT(log_vector->i_len >= sizeof(xfs_efi_log_format_t));
 }
 
 
@@ -333,11 +340,22 @@ xfs_efd_item_free(struct xfs_efd_log_item *efdp)
  * We only need 1 iovec for an efd item.  It just logs the efd_log_format
  * structure.
  */
-STATIC uint
+static inline int
+xfs_efd_item_sizeof(
+	struct xfs_efd_log_item *efdp)
+{
+	return sizeof(xfs_efd_log_format_t) +
+	       (efdp->efd_format.efd_nextents - 1) * sizeof(xfs_extent_t);
+}
+
+STATIC void
 xfs_efd_item_size(
-	struct xfs_log_item	*lip)
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
 {
-	return 1;
+	*nvecs += 1;
+	*nbytes += xfs_efd_item_sizeof(EFD_ITEM(lip));
 }
 
 /*
@@ -353,20 +371,16 @@ xfs_efd_item_format(
 	struct xfs_log_iovec	*log_vector)
 {
 	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
-	uint			size;
 
 	ASSERT(efdp->efd_next_extent == efdp->efd_format.efd_nextents);
 
 	efdp->efd_format.efd_type = XFS_LI_EFD;
-
-	size = sizeof(xfs_efd_log_format_t);
-	size += (efdp->efd_format.efd_nextents - 1) * sizeof(xfs_extent_t);
 	efdp->efd_format.efd_size = 1;
 
 	log_vector->i_addr = &efdp->efd_format;
-	log_vector->i_len = size;
+	log_vector->i_len = xfs_efd_item_sizeof(efdp);
 	log_vector->i_type = XLOG_REG_TYPE_EFD_FORMAT;
-	ASSERT(size >= sizeof(xfs_efd_log_format_t));
+	ASSERT(log_vector->i_len >= sizeof(xfs_efd_log_format_t));
 }
 
 /*
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 441a78a..5a5a593 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -40,11 +40,14 @@ static inline struct xfs_icreate_item *ICR_ITEM(struct xfs_log_item *lip)
  *
  * We only need one iovec for the icreate log structure.
  */
-STATIC uint
+STATIC void
 xfs_icreate_item_size(
-	struct xfs_log_item	*lip)
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
 {
-	return 1;
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_icreate_log);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index f76ff52..366b3bd 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -47,32 +47,44 @@ static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
  * inode core, and possibly one for the inode data/extents/b-tree root
  * and one for the inode attribute data/extents/b-tree root.
  */
-STATIC uint
+STATIC void
 xfs_inode_item_size(
-	struct xfs_log_item	*lip)
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
-	uint			nvecs = 2;
+
+	*nvecs += 2;
+	*nbytes += sizeof(struct xfs_inode_log_format) +
+		   xfs_icdinode_size(ip->i_d.di_version);
 
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
 		    ip->i_d.di_nextents > 0 &&
-		    ip->i_df.if_bytes > 0)
-			nvecs++;
+		    ip->i_df.if_bytes > 0) {
+			/* worst case, doesn't subtract delalloc extents */
+			*nbytes += ip->i_df.if_bytes;
+			*nvecs += 1;
+		}
 		break;
 
 	case XFS_DINODE_FMT_BTREE:
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
-		    ip->i_df.if_broot_bytes > 0)
-			nvecs++;
+		    ip->i_df.if_broot_bytes > 0) {
+			*nbytes += ip->i_df.if_broot_bytes;
+			*nvecs += 1;
+		}
 		break;
 
 	case XFS_DINODE_FMT_LOCAL:
 		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
-		    ip->i_df.if_bytes > 0)
-			nvecs++;
+		    ip->i_df.if_bytes > 0) {
+			*nbytes += roundup(ip->i_df.if_bytes, 4);
+			*nvecs += 1;
+		}
 		break;
 
 	case XFS_DINODE_FMT_DEV:
@@ -85,7 +97,7 @@ xfs_inode_item_size(
 	}
 
 	if (!XFS_IFORK_Q(ip))
-		return nvecs;
+		return;
 
 
 	/*
@@ -95,28 +107,32 @@ xfs_inode_item_size(
 	case XFS_DINODE_FMT_EXTENTS:
 		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
 		    ip->i_d.di_anextents > 0 &&
-		    ip->i_afp->if_bytes > 0)
-			nvecs++;
+		    ip->i_afp->if_bytes > 0) {
+			*nbytes += ip->i_afp->if_bytes;
+			*nvecs += 1;
+		}
 		break;
 
 	case XFS_DINODE_FMT_BTREE:
 		if ((iip->ili_fields & XFS_ILOG_ABROOT) &&
-		    ip->i_afp->if_broot_bytes > 0)
-			nvecs++;
+		    ip->i_afp->if_broot_bytes > 0) {
+			*nbytes += ip->i_afp->if_broot_bytes;
+			*nvecs += 1;
+		}
 		break;
 
 	case XFS_DINODE_FMT_LOCAL:
 		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
-		    ip->i_afp->if_bytes > 0)
-			nvecs++;
+		    ip->i_afp->if_bytes > 0) {
+			*nbytes += roundup(ip->i_afp->if_bytes, 4);
+			*nvecs += 1;
+		}
 		break;
 
 	default:
 		ASSERT(0);
 		break;
 	}
-
-	return nvecs;
 }
 
 /*
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index e63d9e1..1c45848 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -27,6 +27,7 @@ struct xfs_log_vec {
 	struct xfs_log_item	*lv_item;	/* owner */
 	char			*lv_buf;	/* formatted buffer */
 	int			lv_buf_len;	/* size of formatted buffer */
+	int			lv_size;	/* size of allocated lv */
 };
 
 #define XFS_LOG_VEC_ORDERED	(-1)
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 02b9cf3..4425406 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -77,7 +77,85 @@ xlog_cil_init_post_recovery(
 	log->l_cilp->xc_ctx->ticket = xlog_cil_ticket_alloc(log);
 	log->l_cilp->xc_ctx->sequence = 1;
 	log->l_cilp->xc_ctx->commit_lsn = xlog_assign_lsn(log->l_curr_cycle,
-								log->l_curr_block);
+							  log->l_curr_block);
+}
+
+/*
+ * Prepare the log item for insertion into the CIL. Calculate the difference in
+ * log space and vectors it will consume, and if it is a new item pin it as
+ * well.
+ */
+STATIC void
+xfs_cil_prepare_item(
+	struct xlog		*log,
+	struct xfs_log_vec	*lv,
+	struct xfs_log_vec	*old_lv,
+	int			*len,
+	int			*diff_iovecs)
+{
+	if (old_lv) {
+		/* existing lv on log item, space used is a delta */
+		ASSERT(old_lv->lv_buf_len != lv->lv_buf_len ||
+		       old_lv->lv_niovecs != lv->lv_niovecs);
+		ASSERT(lv->lv_buf_len != XFS_LOG_VEC_ORDERED);
+
+		*len += lv->lv_buf_len - old_lv->lv_buf_len;
+		*diff_iovecs += lv->lv_niovecs - old_lv->lv_niovecs;
+	} else {
+		/* new lv, must pin the log item */
+		ASSERT(!lv->lv_item->li_lv);
+
+		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED) {
+			*len += lv->lv_buf_len;
+			*diff_iovecs += lv->lv_niovecs;
+		}
+		IOP_PIN(lv->lv_item);
+
+	}
+
+	/* attach new log vector to log item */
+	lv->lv_item->li_lv = lv;
+
+	/*
+	 * If this is the first time the item is being committed to the
+	 * CIL, store the sequence number on the log item so we can
+	 * tell in future commits whether this is the first checkpoint
+	 * the item is being committed into.
+	 */
+	if (!lv->lv_item->li_seq)
+		lv->lv_item->li_seq = log->l_cilp->xc_ctx->sequence;
+}
+
+STATIC void
+xlog_cil_lv_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	int	index;
+	char	*ptr;
+
+	/* format new vectors into array */
+	lip->li_ops->iop_format(lip, lv->lv_iovecp);
+
+	/* copy data into existing array */
+	ptr = lv->lv_buf;
+	for (index = 0; index < lv->lv_niovecs; index++) {
+		struct xfs_log_iovec *vec = &lv->lv_iovecp[index];
+
+		//printk("\tptr 0x%p, vlen 0x%x\n", ptr, vec->i_len);
+		memcpy(ptr, vec->i_addr, vec->i_len);
+		vec->i_addr = ptr;
+		ptr += vec->i_len;
+	}
+
+	/*
+	 * some size calculations for log vectors over-estimate, so we'll see
+	 * this as not using the entire buffer here. Hence just check ofr
+	 * overruns on debug kernels.
+	 */
+	//printk("ptr 0x%p, lvb 0x%p lvbe 0x%p\n",
+		//ptr, lv->lv_buf, lv->lv_buf + lv->lv_buf_len);
+	ASSERT(ptr > lv->lv_buf && ptr <= lv->lv_buf + lv->lv_buf_len);
 }
 
 /*
@@ -106,37 +184,37 @@ xlog_cil_init_post_recovery(
  * format the regions into the iclog as though they are being formatted
  * directly out of the objects themselves.
  */
-static struct xfs_log_vec *
-xlog_cil_prepare_log_vecs(
-	struct xfs_trans	*tp)
+void
+xlog_cil_insert_format_items(
+	struct xlog		*log,
+	struct xfs_trans	*tp,
+	int			*diff_len,
+	int			*diff_iovecs)
 {
 	struct xfs_log_item_desc *lidp;
-	struct xfs_log_vec	*lv = NULL;
-	struct xfs_log_vec	*ret_lv = NULL;
-
 
 	/* Bail out if we didn't find a log item.  */
 	if (list_empty(&tp->t_items)) {
 		ASSERT(0);
-		return NULL;
+		return;
 	}
 
+	/* walk each transaction item */
 	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
-		struct xfs_log_vec *new_lv;
-		void	*ptr;
-		int	index;
-		int	len = 0;
-		uint	niovecs;
-		bool	ordered = false;
+		struct xfs_log_item	*lip = lidp->lid_item;
+		struct xfs_log_vec	*lv;
+		struct xfs_log_vec	*old_lv;
+		int			niovecs = 0;
+		int			nbytes = 0;
+		int			buf_size;
+		bool			ordered = false;
 
 		/* Skip items which aren't dirty in this transaction. */
 		if (!(lidp->lid_flags & XFS_LID_DIRTY))
 			continue;
 
-		/* Skip items that do not have any vectors for writing */
-		niovecs = IOP_SIZE(lidp->lid_item);
-		if (!niovecs)
-			continue;
+		/* get number of vecs and size of data to be stored */
+		lip->li_ops->iop_size(lip, &niovecs, &nbytes);
 
 		/*
 		 * Ordered items need to be tracked but we do not wish to write
@@ -146,111 +224,63 @@ xlog_cil_prepare_log_vecs(
 		if (niovecs == XFS_LOG_VEC_ORDERED) {
 			ordered = true;
 			niovecs = 0;
+			nbytes = 0;
 		}
 
-		new_lv = kmem_zalloc(sizeof(*new_lv) +
-				niovecs * sizeof(struct xfs_log_iovec),
-				KM_SLEEP|KM_NOFS);
-
-		new_lv->lv_item = lidp->lid_item;
-		new_lv->lv_niovecs = niovecs;
-		if (ordered) {
-			/* track as an ordered logvec */
-			new_lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
-			goto next;
-		}
-
-		/* The allocated iovec region lies beyond the log vector. */
-		new_lv->lv_iovecp = (struct xfs_log_iovec *)&new_lv[1];
-
-		/* build the vector array and calculate it's length */
-		IOP_FORMAT(new_lv->lv_item, new_lv->lv_iovecp);
-		for (index = 0; index < new_lv->lv_niovecs; index++)
-			len += new_lv->lv_iovecp[index].i_len;
-
-		new_lv->lv_buf_len = len;
-		new_lv->lv_buf = kmem_alloc(new_lv->lv_buf_len,
-				KM_SLEEP|KM_NOFS);
-		ptr = new_lv->lv_buf;
-
-		for (index = 0; index < new_lv->lv_niovecs; index++) {
-			struct xfs_log_iovec *vec = &new_lv->lv_iovecp[index];
-
-			memcpy(ptr, vec->i_addr, vec->i_len);
-			vec->i_addr = ptr;
-			ptr += vec->i_len;
-		}
-		ASSERT(ptr == new_lv->lv_buf + new_lv->lv_buf_len);
-
-next:
-		if (!ret_lv)
-			ret_lv = new_lv;
-		else
-			lv->lv_next = new_lv;
-		lv = new_lv;
-	}
-
-	return ret_lv;
-}
-
-/*
- * Prepare the log item for insertion into the CIL. Calculate the difference in
- * log space and vectors it will consume, and if it is a new item pin it as
- * well.
- */
-STATIC void
-xfs_cil_prepare_item(
-	struct xlog		*log,
-	struct xfs_log_vec	*lv,
-	int			*len,
-	int			*diff_iovecs)
-{
-	struct xfs_log_vec	*old = lv->lv_item->li_lv;
+		/* calc buffer size */
+		buf_size = sizeof(struct xfs_log_vec) + nbytes +
+				niovecs * sizeof(struct xfs_log_iovec);
 
-	if (old) {
-		/* existing lv on log item, space used is a delta */
-		ASSERT((old->lv_buf && old->lv_buf_len && old->lv_niovecs) ||
-			old->lv_buf_len == XFS_LOG_VEC_ORDERED);
+		/* compare to existing item size */
+		if (lip->li_lv && buf_size <= lip->li_lv->lv_size) {
+			/* same or smaller, optimise common overwrite case */
 
-		/*
-		 * If the new item is ordered, keep the old one that is already
-		 * tracking dirty or ordered regions
-		 */
-		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
-			ASSERT(!lv->lv_buf);
-			kmem_free(lv);
-			return;
+			/* format log item vectors into existing lv */
+			if (!ordered)
+				xlog_cil_lv_item_format(lip, lip->li_lv);
+			continue;
 		}
 
-		*len += lv->lv_buf_len - old->lv_buf_len;
-		*diff_iovecs += lv->lv_niovecs - old->lv_niovecs;
-		kmem_free(old->lv_buf);
-		kmem_free(old);
-	} else {
-		/* new lv, must pin the log item */
-		ASSERT(!lv->lv_item->li_lv);
+		/* different */
 
-		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED) {
-			*len += lv->lv_buf_len;
-			*diff_iovecs += lv->lv_niovecs;
+		/* allocate new data chunk */
+		lv = kmem_zalloc(buf_size, KM_SLEEP|KM_NOFS);
+		lv->lv_item = lip;
+		lv->lv_size = buf_size;
+		lv->lv_niovecs = niovecs;
+		if (ordered) {
+			/* track as an ordered logvec */
+			ASSERT(lip->li_lv == NULL);
+			lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
+			goto insert;
 		}
-		IOP_PIN(lv->lv_item);
 
+		/* The allocated iovec region lies beyond the log vector. */
+		lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
+
+		/* the allocated data region lies beyond the iovec region */
+		lv->lv_buf = (char *)lv + buf_size - nbytes;
+		lv->lv_buf_len = nbytes;
+
+		//printk("lv 0x%p, ivp 0x%p, buf 0x%p\n",
+			//lv, lv->lv_iovecp, lv->lv_buf);
+		//printk("size 0x%x, blen 0x%x, nvecs 0x%x\n",
+			//lv->lv_size, lv->lv_buf_len, lv->lv_niovecs);
+
+		/* format item in new lv */
+		xlog_cil_lv_item_format(lip, lv);
+insert:
+		/* update new CIL space usage */
+		old_lv = lip->li_lv;
+		xfs_cil_prepare_item(log, lv, old_lv, diff_len, diff_iovecs);
+
+		/* free old lv */
+		kmem_free(old_lv);
 	}
 
-	/* attach new log vector to log item */
-	lv->lv_item->li_lv = lv;
-
-	/*
-	 * If this is the first time the item is being committed to the
-	 * CIL, store the sequence number on the log item so we can
-	 * tell in future commits whether this is the first checkpoint
-	 * the item is being committed into.
-	 */
-	if (!lv->lv_item->li_seq)
-		lv->lv_item->li_seq = log->l_cilp->xc_ctx->sequence;
 }
 
+
 /*
  * Insert the log items into the CIL and calculate the difference in space
  * consumed by the item. Add the space to the checkpoint ticket and calculate
@@ -261,53 +291,49 @@ xfs_cil_prepare_item(
 static void
 xlog_cil_insert_items(
 	struct xlog		*log,
-	struct xfs_log_vec	*log_vector,
+	struct xfs_trans	*tp,
 	struct xlog_ticket	*ticket)
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
-	struct xfs_log_vec	*lv;
+	struct xfs_log_item_desc *lidp;
 	int			len = 0;
 	int			diff_iovecs = 0;
 	int			iclog_space;
 
-	ASSERT(log_vector);
+	ASSERT(tp);
 
 	/*
-	 * Do all the accounting aggregation and switching of log vectors
-	 * around in a separate loop to the insertion of items into the CIL.
-	 * Then we can do a separate loop to update the CIL within a single
-	 * lock/unlock pair. This reduces the number of round trips on the CIL
-	 * lock from O(nr_logvectors) to O(1) and greatly reduces the overall
-	 * hold time for the transaction commit.
-	 *
-	 * If this is the first time the item is being placed into the CIL in
-	 * this context, pin it so it can't be written to disk until the CIL is
-	 * flushed to the iclog and the iclog written to disk.
-	 *
 	 * We can do this safely because the context can't checkpoint until we
 	 * are done so it doesn't matter exactly how we update the CIL.
 	 */
+	xlog_cil_insert_format_items(log, tp, &len, &diff_iovecs);
+
+
+	/*
+	 * Now (re-)position everything modified at the tail of the CIL.
+	 * We do this here so we only need to take the CIL lock once during
+	 * the transaction commit.
+	 */
 	spin_lock(&cil->xc_cil_lock);
-	for (lv = log_vector; lv; ) {
-		struct xfs_log_vec *next = lv->lv_next;
+	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
+		struct xfs_log_item	*lip = lidp->lid_item;
 
-		ASSERT(lv->lv_item->li_lv || list_empty(&lv->lv_item->li_cil));
-		lv->lv_next = NULL;
+		/* Skip items which aren't dirty in this transaction. */
+		if (!(lidp->lid_flags & XFS_LID_DIRTY))
+			continue;
 
-		/*
-		 * xfs_cil_prepare_item() may free the lv, so move the item on
-		 * the CIL first.
-		 */
-		list_move_tail(&lv->lv_item->li_cil, &cil->xc_cil);
-		xfs_cil_prepare_item(log, lv, &len, &diff_iovecs);
-		lv = next;
+		list_move_tail(&lip->li_cil, &cil->xc_cil);
 	}
 
 	/* account for space used by new iovec headers  */
 	len += diff_iovecs * sizeof(xlog_op_header_t);
 	ctx->nvecs += diff_iovecs;
 
+	/* attach the transaction to the CIL if it has any busy extents */
+	if (!list_empty(&tp->t_busy))
+		list_splice_init(&tp->t_busy, &ctx->busy_extents);
+
 	/*
 	 * Now transfer enough transaction reservation to the context ticket
 	 * for the checkpoint. The context ticket is special - the unit
@@ -350,7 +376,6 @@ xlog_cil_free_logvec(
 
 	for (lv = log_vector; lv; ) {
 		struct xfs_log_vec *next = lv->lv_next;
-		kmem_free(lv->lv_buf);
 		kmem_free(lv);
 		lv = next;
 	}
@@ -376,9 +401,9 @@ xlog_cil_committed(
 	xfs_extent_busy_clear(mp, &ctx->busy_extents,
 			     (mp->m_flags & XFS_MOUNT_DISCARD) && !abort);
 
-	spin_lock(&ctx->cil->xc_cil_lock);
+	spin_lock(&ctx->cil->xc_push_lock);
 	list_del(&ctx->committing);
-	spin_unlock(&ctx->cil->xc_cil_lock);
+	spin_unlock(&ctx->cil->xc_push_lock);
 
 	xlog_cil_free_logvec(ctx->lv_chain);
 
@@ -433,7 +458,7 @@ xlog_cil_push(
 	down_write(&cil->xc_ctx_lock);
 	ctx = cil->xc_ctx;
 
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	push_seq = cil->xc_push_seq;
 	ASSERT(push_seq <= ctx->sequence);
 
@@ -444,10 +469,10 @@ xlog_cil_push(
 	 */
 	if (list_empty(&cil->xc_cil)) {
 		cil->xc_push_seq = 0;
-		spin_unlock(&cil->xc_cil_lock);
+		spin_unlock(&cil->xc_push_lock);
 		goto out_skip;
 	}
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 
 
 	/* check for a previously pushed seqeunce */
@@ -515,9 +540,9 @@ xlog_cil_push(
 	 * that higher sequences will wait for us to write out a commit record
 	 * before they do.
 	 */
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	list_add(&ctx->committing, &cil->xc_committing);
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 	up_write(&cil->xc_ctx_lock);
 
 	/*
@@ -552,7 +577,7 @@ xlog_cil_push(
 	 * order the commit records so replay will get them in the right order.
 	 */
 restart:
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	list_for_each_entry(new_ctx, &cil->xc_committing, committing) {
 		/*
 		 * Higher sequences will wait for this one so skip them.
@@ -565,11 +590,11 @@ restart:
 			 * It is still being pushed! Wait for the push to
 			 * complete, then start again from the beginning.
 			 */
-			xlog_wait(&cil->xc_commit_wait, &cil->xc_cil_lock);
+			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
 			goto restart;
 		}
 	}
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 
 	/* xfs_log_done always frees the ticket on error. */
 	commit_lsn = xfs_log_done(log->l_mp, tic, &commit_iclog, 0);
@@ -588,10 +613,10 @@ restart:
 	 * callbacks to the iclog we can assign the commit LSN to the context
 	 * and wake up anyone who is waiting for the commit to complete.
 	 */
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	ctx->commit_lsn = commit_lsn;
 	wake_up_all(&cil->xc_commit_wait);
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 
 	/* release the hounds! */
 	return xfs_log_release_iclog(log->l_mp, commit_iclog);
@@ -644,12 +669,12 @@ xlog_cil_push_background(
 	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
 		return;
 
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	if (cil->xc_push_seq < cil->xc_current_sequence) {
 		cil->xc_push_seq = cil->xc_current_sequence;
 		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
 	}
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 
 }
 
@@ -672,14 +697,14 @@ xlog_cil_push_foreground(
 	 * If the CIL is empty or we've already pushed the sequence then
 	 * there's no work we need to do.
 	 */
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
-		spin_unlock(&cil->xc_cil_lock);
+		spin_unlock(&cil->xc_push_lock);
 		return;
 	}
 
 	cil->xc_push_seq = push_seq;
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 
 	/* do the push now */
 	xlog_cil_push(log);
@@ -706,41 +731,23 @@ xfs_log_commit_cil(
 	int			flags)
 {
 	struct xlog		*log = mp->m_log;
+	struct xfs_cil		*cil = log->l_cilp;
 	int			log_flags = 0;
-	struct xfs_log_vec	*log_vector;
 
 	if (flags & XFS_TRANS_RELEASE_LOG_RES)
 		log_flags = XFS_LOG_REL_PERM_RESERV;
 
-	/*
-	 * Do all the hard work of formatting items (including memory
-	 * allocation) outside the CIL context lock. This prevents stalling CIL
-	 * pushes when we are low on memory and a transaction commit spends a
-	 * lot of time in memory reclaim.
-	 */
-	log_vector = xlog_cil_prepare_log_vecs(tp);
-	if (!log_vector)
-		return ENOMEM;
-
 	/* lock out background commit */
-	down_read(&log->l_cilp->xc_ctx_lock);
+	down_read(&cil->xc_ctx_lock);
 	if (commit_lsn)
-		*commit_lsn = log->l_cilp->xc_ctx->sequence;
+		*commit_lsn = cil->xc_ctx->sequence;
 
 	/* xlog_cil_insert_items() destroys log_vector list */
-	xlog_cil_insert_items(log, log_vector, tp->t_ticket);
+	xlog_cil_insert_items(log, tp, tp->t_ticket);
 
 	/* check we didn't blow the reservation */
 	if (tp->t_ticket->t_curr_res < 0)
-		xlog_print_tic_res(log->l_mp, tp->t_ticket);
-
-	/* attach the transaction to the CIL if it has any busy extents */
-	if (!list_empty(&tp->t_busy)) {
-		spin_lock(&log->l_cilp->xc_cil_lock);
-		list_splice_init(&tp->t_busy,
-					&log->l_cilp->xc_ctx->busy_extents);
-		spin_unlock(&log->l_cilp->xc_cil_lock);
-	}
+		xlog_print_tic_res(mp, tp->t_ticket);
 
 	tp->t_commit_lsn = *commit_lsn;
 	xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
@@ -800,7 +807,7 @@ xlog_cil_force_lsn(
 	 * on commits for those as well.
 	 */
 restart:
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	list_for_each_entry(ctx, &cil->xc_committing, committing) {
 		if (ctx->sequence > sequence)
 			continue;
@@ -809,7 +816,7 @@ restart:
 			 * It is still being pushed! Wait for the push to
 			 * complete, then start again from the beginning.
 			 */
-			xlog_wait(&cil->xc_commit_wait, &cil->xc_cil_lock);
+			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
 			goto restart;
 		}
 		if (ctx->sequence != sequence)
@@ -817,7 +824,7 @@ restart:
 		/* found it! */
 		commit_lsn = ctx->commit_lsn;
 	}
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 	return commit_lsn;
 }
 
@@ -875,6 +882,7 @@ xlog_cil_init(
 	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
+	spin_lock_init(&cil->xc_push_lock);
 	init_rwsem(&cil->xc_ctx_lock);
 	init_waitqueue_head(&cil->xc_commit_wait);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index edd0964..56654931 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -278,13 +278,16 @@ struct xfs_cil {
 	struct xlog		*xc_log;
 	struct list_head	xc_cil;
 	spinlock_t		xc_cil_lock;
-	struct xfs_cil_ctx	*xc_ctx;
+
+	struct xfs_cil_ctx	*xc_ctx ____cacheline_aligned_in_smp;
 	struct rw_semaphore	xc_ctx_lock;
+
+	spinlock_t		xc_push_lock ____cacheline_aligned_in_smp;
 	struct list_head	xc_committing;
 	wait_queue_head_t	xc_commit_wait;
+	xfs_lsn_t		xc_push_seq;
 	xfs_lsn_t		xc_current_sequence;
 	struct work_struct	xc_push_work;
-	xfs_lsn_t		xc_push_seq;
 };
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 8e67284..157e9c4 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -140,7 +140,7 @@ typedef struct xfs_log_item {
 	{ XFS_LI_ABORTED,	"ABORTED" }
 
 struct xfs_item_ops {
-	uint (*iop_size)(xfs_log_item_t *);
+	void (*iop_size)(xfs_log_item_t *, int *, int *);
 	void (*iop_format)(xfs_log_item_t *, struct xfs_log_iovec *);
 	void (*iop_pin)(xfs_log_item_t *);
 	void (*iop_unpin)(xfs_log_item_t *, int remove);
@@ -150,8 +150,6 @@ struct xfs_item_ops {
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
 };
 
-#define IOP_SIZE(ip)		(*(ip)->li_ops->iop_size)(ip)
-#define IOP_FORMAT(ip,vp)	(*(ip)->li_ops->iop_format)(ip, vp)
 #define IOP_PIN(ip)		(*(ip)->li_ops->iop_pin)(ip)
 #define IOP_UNPIN(ip, remove)	(*(ip)->li_ops->iop_unpin)(ip, remove)
 #define IOP_PUSH(ip, list)	(*(ip)->li_ops->iop_push)(ip, list)
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
