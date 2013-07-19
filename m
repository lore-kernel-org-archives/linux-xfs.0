Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 05B1B7F8B
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C96B9304043
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:41 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	d5gEnocwvZOhWC8R for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:39 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0483-00048H-Ed
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0483-00020D-DJ
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 43/49] xfs: return log item size in IOP_SIZE
Date: Fri, 19 Jul 2013 16:25:14 +1000
Message-Id: <1374215120-7271-44-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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

To begin optimising the CIL commit process, we need to have IOP_SIZE
return both the number of vectors and the size of the data pointed
to by the vectors. This enables us to calculate the size ofthe
memory allocation needed before the formatting step and reduces the
number of memory allocations per item by one.

WhIle there, kill the IOP_SIZE macro.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c     | 52 ++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_dquot_item.c   | 22 ++++++++++++--------
 fs/xfs/xfs_extfree_item.c | 50 ++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_icreate_item.c |  9 +++++---
 fs/xfs/xfs_inode_item.c   | 53 +++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_log_cil.c      | 10 ++++++---
 fs/xfs/xfs_trans.h        |  3 +--
 7 files changed, 126 insertions(+), 73 deletions(-)

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
index f76ff52..3780811 100644
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
+			*nbytes += XFS_IFORK_DSIZE(ip);
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
@@ -95,28 +107,33 @@ xfs_inode_item_size(
 	case XFS_DINODE_FMT_EXTENTS:
 		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
 		    ip->i_d.di_anextents > 0 &&
-		    ip->i_afp->if_bytes > 0)
-			nvecs++;
+		    ip->i_afp->if_bytes > 0) {
+			/* worst case, doesn't subtract unused space */
+			*nbytes += XFS_IFORK_ASIZE(ip);
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
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 02b9cf3..4e10872 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -122,19 +122,23 @@ xlog_cil_prepare_log_vecs(
 	}
 
 	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
+		struct xfs_log_item *lip = lidp->lid_item;
 		struct xfs_log_vec *new_lv;
 		void	*ptr;
 		int	index;
 		int	len = 0;
-		uint	niovecs;
+		uint	niovecs = 0;
+		uint	nbytes = 0;
 		bool	ordered = false;
 
 		/* Skip items which aren't dirty in this transaction. */
 		if (!(lidp->lid_flags & XFS_LID_DIRTY))
 			continue;
 
+		/* get number of vecs and size of data to be stored */
+		lip->li_ops->iop_size(lip, &niovecs, &nbytes);
+
 		/* Skip items that do not have any vectors for writing */
-		niovecs = IOP_SIZE(lidp->lid_item);
 		if (!niovecs)
 			continue;
 
@@ -152,7 +156,7 @@ xlog_cil_prepare_log_vecs(
 				niovecs * sizeof(struct xfs_log_iovec),
 				KM_SLEEP|KM_NOFS);
 
-		new_lv->lv_item = lidp->lid_item;
+		new_lv->lv_item = lip;
 		new_lv->lv_niovecs = niovecs;
 		if (ordered) {
 			/* track as an ordered logvec */
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 7eb81cc..97144ec 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -67,7 +67,7 @@ typedef struct xfs_log_item {
 	{ XFS_LI_ABORTED,	"ABORTED" }
 
 struct xfs_item_ops {
-	uint (*iop_size)(xfs_log_item_t *);
+	void (*iop_size)(xfs_log_item_t *, int *, int *);
 	void (*iop_format)(xfs_log_item_t *, struct xfs_log_iovec *);
 	void (*iop_pin)(xfs_log_item_t *);
 	void (*iop_unpin)(xfs_log_item_t *, int remove);
@@ -77,7 +77,6 @@ struct xfs_item_ops {
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
 };
 
-#define IOP_SIZE(ip)		(*(ip)->li_ops->iop_size)(ip)
 #define IOP_FORMAT(ip,vp)	(*(ip)->li_ops->iop_format)(ip, vp)
 #define IOP_PIN(ip)		(*(ip)->li_ops->iop_pin)(ip)
 #define IOP_UNPIN(ip, remove)	(*(ip)->li_ops->iop_unpin)(ip, remove)
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
