Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Jul 2008 20:27:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m683RqHx026698
	for <xfs@oss.sgi.com>; Mon, 7 Jul 2008 20:27:52 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D817A2C6098
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2008 20:28:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 2xb8or1kFH8UUaBx for <xfs@oss.sgi.com>; Mon, 07 Jul 2008 20:28:55 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 528B1AC3593
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2008 22:28:55 -0500 (CDT)
Message-ID: <4872DEF8.6060704@sandeen.net>
Date: Mon, 07 Jul 2008 22:28:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove shouting-indirection macros  from xfs_trans.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

compile-tested, fairly easy to inspect with:

quilt diff --diff="diff -iu"

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

 xfs_bmap.c       |    6 ++---
 xfs_trans.c      |   12 +++++-----
 xfs_trans.h      |   11 ---------
 xfs_trans_buf.c  |   12 +++++-----
 xfs_trans_item.c |   66 +++++++++++++++++++++++++++----------------------------
 xfsidbg.c        |    6 ++---
 6 files changed, 51 insertions(+), 62 deletions(-)

Index: linux/fs/xfs/xfs_bmap.c
===================================================================
RCS file: /cvs/xfs-linux/xfs_bmap.c,v
retrieving revision 1.394
diff -u -r1.394 xfs_bmap.c
--- linux/fs/xfs/xfs_bmap.c	20 Jun 2008 16:19:53 -0000	1.394
+++ linux/fs/xfs/xfs_bmap.c	8 Jul 2008 03:24:32 -0000
@@ -6096,7 +6096,7 @@
 		tp = cur->bc_tp;
 		licp = &tp->t_items;
 		while (!bp && licp != NULL) {
-			if (XFS_LIC_ARE_ALL_FREE(licp)) {
+			if (xfs_lic_are_all_free(licp)) {
 				licp = licp->lic_next;
 				continue;
 			}
@@ -6106,11 +6106,11 @@
 				xfs_buf_log_item_t	*bip;
 				xfs_buf_t		*lbp;
 
-				if (XFS_LIC_ISFREE(licp, i)) {
+				if (xfs_lic_isfree(licp, i)) {
 					continue;
 				}
 
-				lidp = XFS_LIC_SLOT(licp, i);
+				lidp = xfs_lic_slot(licp, i);
 				lip = lidp->lid_item;
 				if (lip->li_type != XFS_LI_BUF)
 					continue;
Index: linux/fs/xfs/xfs_trans.c
===================================================================
RCS file: /cvs/xfs-linux/xfs_trans.c,v
retrieving revision 1.185
diff -u -r1.185 xfs_trans.c
--- linux/fs/xfs/xfs_trans.c	9 May 2008 04:27:47 -0000	1.185
+++ linux/fs/xfs/xfs_trans.c	8 Jul 2008 03:24:32 -0000
@@ -253,7 +253,7 @@
 	tp->t_mountp = mp;
 	tp->t_items_free = XFS_LIC_NUM_SLOTS;
 	tp->t_busy_free = XFS_LBC_NUM_SLOTS;
-	XFS_LIC_INIT(&(tp->t_items));
+	xfs_lic_init(&(tp->t_items));
 	XFS_LBC_INIT(&(tp->t_busy));
 	return tp;
 }
@@ -282,7 +282,7 @@
 	ntp->t_mountp = tp->t_mountp;
 	ntp->t_items_free = XFS_LIC_NUM_SLOTS;
 	ntp->t_busy_free = XFS_LBC_NUM_SLOTS;
-	XFS_LIC_INIT(&(ntp->t_items));
+	xfs_lic_init(&(ntp->t_items));
 	XFS_LBC_INIT(&(ntp->t_busy));
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -1169,7 +1169,7 @@
 		while (licp != NULL) {
 			lidp = licp->lic_descs;
 			for (i = 0; i < licp->lic_unused; i++, lidp++) {
-				if (XFS_LIC_ISFREE(licp, i)) {
+				if (xfs_lic_isfree(licp, i)) {
 					continue;
 				}
 
@@ -1253,7 +1253,7 @@
 	 * Special case the chunk embedded in the transaction.
 	 */
 	licp = &(tp->t_items);
-	if (!(XFS_LIC_ARE_ALL_FREE(licp))) {
+	if (!(xfs_lic_are_all_free(licp))) {
 		xfs_trans_chunk_committed(licp, tp->t_lsn, abortflag);
 	}
 
@@ -1262,7 +1262,7 @@
 	 */
 	licp = licp->lic_next;
 	while (licp != NULL) {
-		ASSERT(!XFS_LIC_ARE_ALL_FREE(licp));
+		ASSERT(!xfs_lic_are_all_free(licp));
 		xfs_trans_chunk_committed(licp, tp->t_lsn, abortflag);
 		next_licp = licp->lic_next;
 		kmem_free(licp);
@@ -1325,7 +1325,7 @@
 
 	lidp = licp->lic_descs;
 	for (i = 0; i < licp->lic_unused; i++, lidp++) {
-		if (XFS_LIC_ISFREE(licp, i)) {
+		if (xfs_lic_isfree(licp, i)) {
 			continue;
 		}
 
Index: linux/fs/xfs/xfs_trans.h
===================================================================
RCS file: /cvs/xfs-linux/xfs_trans.h,v
retrieving revision 1.149
diff -u -r1.149 xfs_trans.h
--- linux/fs/xfs/xfs_trans.h	11 Mar 2008 15:02:32 -0000	1.149
+++ linux/fs/xfs/xfs_trans.h	8 Jul 2008 03:24:33 -0000
@@ -210,62 +210,52 @@
  * lic_unused to the right value (0 matches all free).  The
  * lic_descs.lid_index values are set up as each desc is allocated.
  */
-#define	XFS_LIC_INIT(cp)	xfs_lic_init(cp)
 static inline void xfs_lic_init(xfs_log_item_chunk_t *cp)
 {
 	cp->lic_free = XFS_LIC_FREEMASK;
 }
 
-#define	XFS_LIC_INIT_SLOT(cp,slot)	xfs_lic_init_slot(cp, slot)
 static inline void xfs_lic_init_slot(xfs_log_item_chunk_t *cp, int slot)
 {
 	cp->lic_descs[slot].lid_index = (unsigned char)(slot);
 }
 
-#define	XFS_LIC_VACANCY(cp)		xfs_lic_vacancy(cp)
 static inline int xfs_lic_vacancy(xfs_log_item_chunk_t *cp)
 {
 	return cp->lic_free & XFS_LIC_FREEMASK;
 }
 
-#define	XFS_LIC_ALL_FREE(cp)		xfs_lic_all_free(cp)
 static inline void xfs_lic_all_free(xfs_log_item_chunk_t *cp)
 {
 	cp->lic_free = XFS_LIC_FREEMASK;
 }
 
-#define	XFS_LIC_ARE_ALL_FREE(cp)	xfs_lic_are_all_free(cp)
 static inline int xfs_lic_are_all_free(xfs_log_item_chunk_t *cp)
 {
 	return ((cp->lic_free & XFS_LIC_FREEMASK) == XFS_LIC_FREEMASK);
 }
 
-#define	XFS_LIC_ISFREE(cp,slot)	xfs_lic_isfree(cp,slot)
 static inline int xfs_lic_isfree(xfs_log_item_chunk_t *cp, int slot)
 {
 	return (cp->lic_free & (1 << slot));
 }
 
-#define	XFS_LIC_CLAIM(cp,slot)		xfs_lic_claim(cp,slot)
 static inline void xfs_lic_claim(xfs_log_item_chunk_t *cp, int slot)
 {
 	cp->lic_free &= ~(1 << slot);
 }
 
-#define	XFS_LIC_RELSE(cp,slot)		xfs_lic_relse(cp,slot)
 static inline void xfs_lic_relse(xfs_log_item_chunk_t *cp, int slot)
 {
 	cp->lic_free |= 1 << slot;
 }
 
-#define	XFS_LIC_SLOT(cp,slot)		xfs_lic_slot(cp,slot)
 static inline xfs_log_item_desc_t *
 xfs_lic_slot(xfs_log_item_chunk_t *cp, int slot)
 {
 	return &(cp->lic_descs[slot]);
 }
 
-#define	XFS_LIC_DESC_TO_SLOT(dp)	xfs_lic_desc_to_slot(dp)
 static inline int xfs_lic_desc_to_slot(xfs_log_item_desc_t *dp)
 {
 	return (uint)dp->lid_index;
@@ -278,7 +268,6 @@
  * All of this yields the address of the chunk, which is
  * cast to a chunk pointer.
  */
-#define	XFS_LIC_DESC_TO_CHUNK(dp)	xfs_lic_desc_to_chunk(dp)
 static inline xfs_log_item_chunk_t *
 xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
 {
Index: linux/fs/xfs/xfs_trans_buf.c
===================================================================
RCS file: /cvs/xfs-linux/xfs_trans_buf.c,v
retrieving revision 1.130
diff -u -r1.130 xfs_trans_buf.c
--- linux/fs/xfs/xfs_trans_buf.c	10 Apr 2008 04:25:55 -0000	1.130
+++ linux/fs/xfs/xfs_trans_buf.c	8 Jul 2008 03:24:33 -0000
@@ -1021,16 +1021,16 @@
 	bp = NULL;
 	len = BBTOB(len);
 	licp = &tp->t_items;
-	if (!XFS_LIC_ARE_ALL_FREE(licp)) {
+	if (!xfs_lic_are_all_free(licp)) {
 		for (i = 0; i < licp->lic_unused; i++) {
 			/*
 			 * Skip unoccupied slots.
 			 */
-			if (XFS_LIC_ISFREE(licp, i)) {
+			if (xfs_lic_isfree(licp, i)) {
 				continue;
 			}
 
-			lidp = XFS_LIC_SLOT(licp, i);
+			lidp = xfs_lic_slot(licp, i);
 			blip = (xfs_buf_log_item_t *)lidp->lid_item;
 			if (blip->bli_item.li_type != XFS_LI_BUF) {
 				continue;
@@ -1074,7 +1074,7 @@
 	bp = NULL;
 	len = BBTOB(len);
 	for (licp = &tp->t_items; licp != NULL; licp = licp->lic_next) {
-		if (XFS_LIC_ARE_ALL_FREE(licp)) {
+		if (xfs_lic_are_all_free(licp)) {
 			ASSERT(licp == &tp->t_items);
 			ASSERT(licp->lic_next == NULL);
 			return NULL;
@@ -1083,11 +1083,11 @@
 			/*
 			 * Skip unoccupied slots.
 			 */
-			if (XFS_LIC_ISFREE(licp, i)) {
+			if (xfs_lic_isfree(licp, i)) {
 				continue;
 			}
 
-			lidp = XFS_LIC_SLOT(licp, i);
+			lidp = xfs_lic_slot(licp, i);
 			blip = (xfs_buf_log_item_t *)lidp->lid_item;
 			if (blip->bli_item.li_type != XFS_LI_BUF) {
 				continue;
Index: linux/fs/xfs/xfs_trans_item.c
===================================================================
RCS file: /cvs/xfs-linux/xfs_trans_item.c,v
retrieving revision 1.47
diff -u -r1.47 xfs_trans_item.c
--- linux/fs/xfs/xfs_trans_item.c	9 May 2008 04:27:47 -0000	1.47
+++ linux/fs/xfs/xfs_trans_item.c	8 Jul 2008 03:24:33 -0000
@@ -53,11 +53,11 @@
 		 * Initialize the chunk, and then
 		 * claim the first slot in the newly allocated chunk.
 		 */
-		XFS_LIC_INIT(licp);
-		XFS_LIC_CLAIM(licp, 0);
+		xfs_lic_init(licp);
+		xfs_lic_claim(licp, 0);
 		licp->lic_unused = 1;
-		XFS_LIC_INIT_SLOT(licp, 0);
-		lidp = XFS_LIC_SLOT(licp, 0);
+		xfs_lic_init_slot(licp, 0);
+		lidp = xfs_lic_slot(licp, 0);
 
 		/*
 		 * Link in the new chunk and update the free count.
@@ -88,14 +88,14 @@
 	 */
 	licp = &tp->t_items;
 	while (licp != NULL) {
-		if (XFS_LIC_VACANCY(licp)) {
+		if (xfs_lic_vacancy(licp)) {
 			if (licp->lic_unused <= XFS_LIC_MAX_SLOT) {
 				i = licp->lic_unused;
-				ASSERT(XFS_LIC_ISFREE(licp, i));
+				ASSERT(xfs_lic_isfree(licp, i));
 				break;
 			}
 			for (i = 0; i <= XFS_LIC_MAX_SLOT; i++) {
-				if (XFS_LIC_ISFREE(licp, i))
+				if (xfs_lic_isfree(licp, i))
 					break;
 			}
 			ASSERT(i <= XFS_LIC_MAX_SLOT);
@@ -108,12 +108,12 @@
 	 * If we find a free descriptor, claim it,
 	 * initialize it, and return it.
 	 */
-	XFS_LIC_CLAIM(licp, i);
+	xfs_lic_claim(licp, i);
 	if (licp->lic_unused <= i) {
 		licp->lic_unused = i + 1;
-		XFS_LIC_INIT_SLOT(licp, i);
+		xfs_lic_init_slot(licp, i);
 	}
-	lidp = XFS_LIC_SLOT(licp, i);
+	lidp = xfs_lic_slot(licp, i);
 	tp->t_items_free--;
 	lidp->lid_item = lip;
 	lidp->lid_flags = 0;
@@ -136,9 +136,9 @@
 	xfs_log_item_chunk_t	*licp;
 	xfs_log_item_chunk_t	**licpp;
 
-	slot = XFS_LIC_DESC_TO_SLOT(lidp);
-	licp = XFS_LIC_DESC_TO_CHUNK(lidp);
-	XFS_LIC_RELSE(licp, slot);
+	slot = xfs_lic_desc_to_slot(lidp);
+	licp = xfs_lic_desc_to_chunk(lidp);
+	xfs_lic_relse(licp, slot);
 	lidp->lid_item->li_desc = NULL;
 	tp->t_items_free++;
 
@@ -154,7 +154,7 @@
 	 * Also decrement the transaction structure's count of free items
 	 * by the number in a chunk since we are freeing an empty chunk.
 	 */
-	if (XFS_LIC_ARE_ALL_FREE(licp) && (licp != &(tp->t_items))) {
+	if (xfs_lic_are_all_free(licp) && (licp != &(tp->t_items))) {
 		licpp = &(tp->t_items.lic_next);
 		while (*licpp != licp) {
 			ASSERT(*licpp != NULL);
@@ -207,20 +207,20 @@
 	/*
 	 * If it's not in the first chunk, skip to the second.
 	 */
-	if (XFS_LIC_ARE_ALL_FREE(licp)) {
+	if (xfs_lic_are_all_free(licp)) {
 		licp = licp->lic_next;
 	}
 
 	/*
 	 * Return the first non-free descriptor in the chunk.
 	 */
-	ASSERT(!XFS_LIC_ARE_ALL_FREE(licp));
+	ASSERT(!xfs_lic_are_all_free(licp));
 	for (i = 0; i < licp->lic_unused; i++) {
-		if (XFS_LIC_ISFREE(licp, i)) {
+		if (xfs_lic_isfree(licp, i)) {
 			continue;
 		}
 
-		return XFS_LIC_SLOT(licp, i);
+		return xfs_lic_slot(licp, i);
 	}
 	cmn_err(CE_WARN, "xfs_trans_first_item() -- no first item");
 	return NULL;
@@ -242,18 +242,18 @@
 	xfs_log_item_chunk_t	*licp;
 	int			i;
 
-	licp = XFS_LIC_DESC_TO_CHUNK(lidp);
+	licp = xfs_lic_desc_to_chunk(lidp);
 
 	/*
 	 * First search the rest of the chunk. The for loop keeps us
 	 * from referencing things beyond the end of the chunk.
 	 */
-	for (i = (int)XFS_LIC_DESC_TO_SLOT(lidp) + 1; i < licp->lic_unused; i++) {
-		if (XFS_LIC_ISFREE(licp, i)) {
+	for (i = (int)xfs_lic_desc_to_slot(lidp) + 1; i < licp->lic_unused; i++) {
+		if (xfs_lic_isfree(licp, i)) {
 			continue;
 		}
 
-		return XFS_LIC_SLOT(licp, i);
+		return xfs_lic_slot(licp, i);
 	}
 
 	/*
@@ -266,13 +266,13 @@
 	}
 
 	licp = licp->lic_next;
-	ASSERT(!XFS_LIC_ARE_ALL_FREE(licp));
+	ASSERT(!xfs_lic_are_all_free(licp));
 	for (i = 0; i < licp->lic_unused; i++) {
-		if (XFS_LIC_ISFREE(licp, i)) {
+		if (xfs_lic_isfree(licp, i)) {
 			continue;
 		}
 
-		return XFS_LIC_SLOT(licp, i);
+		return xfs_lic_slot(licp, i);
 	}
 	ASSERT(0);
 	/* NOTREACHED */
@@ -300,9 +300,9 @@
 	/*
 	 * Special case the embedded chunk so we don't free it below.
 	 */
-	if (!XFS_LIC_ARE_ALL_FREE(licp)) {
+	if (!xfs_lic_are_all_free(licp)) {
 		(void) xfs_trans_unlock_chunk(licp, 1, abort, NULLCOMMITLSN);
-		XFS_LIC_ALL_FREE(licp);
+		xfs_lic_all_free(licp);
 		licp->lic_unused = 0;
 	}
 	licp = licp->lic_next;
@@ -311,7 +311,7 @@
 	 * Unlock each item in each chunk and free the chunks.
 	 */
 	while (licp != NULL) {
-		ASSERT(!XFS_LIC_ARE_ALL_FREE(licp));
+		ASSERT(!xfs_lic_are_all_free(licp));
 		(void) xfs_trans_unlock_chunk(licp, 1, abort, NULLCOMMITLSN);
 		next_licp = licp->lic_next;
 		kmem_free(licp);
@@ -347,7 +347,7 @@
 	/*
 	 * Special case the embedded chunk so we don't free.
 	 */
-	if (!XFS_LIC_ARE_ALL_FREE(licp)) {
+	if (!xfs_lic_are_all_free(licp)) {
 		freed = xfs_trans_unlock_chunk(licp, 0, 0, commit_lsn);
 	}
 	licpp = &(tp->t_items.lic_next);
@@ -358,10 +358,10 @@
 	 * and free empty chunks.
 	 */
 	while (licp != NULL) {
-		ASSERT(!XFS_LIC_ARE_ALL_FREE(licp));
+		ASSERT(!xfs_lic_are_all_free(licp));
 		freed += xfs_trans_unlock_chunk(licp, 0, 0, commit_lsn);
 		next_licp = licp->lic_next;
-		if (XFS_LIC_ARE_ALL_FREE(licp)) {
+		if (xfs_lic_are_all_free(licp)) {
 			*licpp = next_licp;
 			kmem_free(licp);
 			freed -= XFS_LIC_NUM_SLOTS;
@@ -402,7 +402,7 @@
 	freed = 0;
 	lidp = licp->lic_descs;
 	for (i = 0; i < licp->lic_unused; i++, lidp++) {
-		if (XFS_LIC_ISFREE(licp, i)) {
+		if (xfs_lic_isfree(licp, i)) {
 			continue;
 		}
 		lip = lidp->lid_item;
@@ -421,7 +421,7 @@
 		 */
 		if (!(freeing_chunk) &&
 		    (!(lidp->lid_flags & XFS_LID_DIRTY) || abort)) {
-			XFS_LIC_RELSE(licp, i);
+			xfs_lic_relse(licp, i);
 			freed++;
 		}
 	}
Index: linux/fs/xfs/xfsidbg.c
===================================================================
RCS file: /cvs/xfs-linux/xfsidbg.c,v
retrieving revision 1.353
diff -u -r1.353 xfsidbg.c
--- linux/fs/xfs/xfsidbg.c	25 Jun 2008 16:26:57 -0000	1.353
+++ linux/fs/xfs/linux/fs/xfs/xfsidbg.c	8 Jul 2008 03:24:35 -0000
@@ -6951,17 +6951,17 @@
 	licp = &tp->t_items;
 	chunk = 0;
 	while (licp != NULL) {
-		if (XFS_LIC_ARE_ALL_FREE(licp)) {
+		if (xfs_lic_are_all_free(licp)) {
 			licp = licp->lic_next;
 			chunk++;
 			continue;
 		}
 		for (i = 0; i < licp->lic_unused; i++) {
-			if (XFS_LIC_ISFREE(licp, i)) {
+			if (xfs_lic_isfree(licp, i)) {
 				continue;
 			}
 
-			lidp = XFS_LIC_SLOT(licp, i);
+			lidp = xfs_lic_slot(licp, i);
 			kdb_printf("\n");
 			kdb_printf("chunk %d index %d item 0x%p size %d\n",
 				chunk, i, lidp->lid_item, lidp->lid_size);
