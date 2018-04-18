Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59374 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCon (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:44:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2fnYK010644
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:42 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2hdrxnrjyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:42 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2igZV019223
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:42 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3I2igl3028247
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:42 GMT
Subject: [PATCH 3/9] xfs: check directory bestfree information in the
 verifier
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:44:41 -0700
Message-ID: <152401948094.12719.1844400961326629038.stgit@magnolia>
In-Reply-To: <152401946245.12719.18338955003321437040.stgit@magnolia>
References: <152401946245.12719.18338955003321437040.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a variant of xfs_dir2_data_freefind that is suitable for use in a
verifier.  Because _freefind is called by the verifier, we simply
duplicate the _freefind function, convert the ASSERTs to return
__this_address, and modify the verifier to call our new function.  Once
we've made it impossible for directory blocks with bad bestfree data to
make it into the filesystem we can remove the DEBUG code from the
regular _freefind function.

Underlying argument: corruption of on-disk metadata should return
-EFSCORRUPTED instead of blowing ASSERTs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c |  121 +++++++++++++++++++++++++++++------------
 1 file changed, 86 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index cb67ec7..bc5c0ba 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -33,6 +33,11 @@
 #include "xfs_cksum.h"
 #include "xfs_log.h"
 
+static xfs_failaddr_t xfs_dir2_data_freefind_verify(
+		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
+		struct xfs_dir2_data_unused *dup,
+		struct xfs_dir2_data_free **bf_ent);
+
 /*
  * Check the consistency of the data block.
  * The input can also be a block-format directory.
@@ -52,6 +57,7 @@ __xfs_dir3_data_check(
 	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
 	xfs_dir2_data_unused_t	*dup;		/* unused entry */
 	char			*endp;		/* end of useful data */
+	xfs_failaddr_t		fa;
 	int			freeseen;	/* mask of bestfrees seen */
 	xfs_dahash_t		hash;		/* hash of current name */
 	int			i;		/* leaf index */
@@ -154,7 +160,9 @@ __xfs_dir3_data_check(
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
 			    (char *)dup - (char *)hdr)
 				return __this_address;
-			dfp = xfs_dir2_data_freefind(hdr, bf, dup);
+			fa = xfs_dir2_data_freefind_verify(hdr, bf, dup, &dfp);
+			if (fa)
+				return fa;
 			if (dfp) {
 				i = (int)(dfp - bf);
 				if ((freeseen & (1 << i)) != 0)
@@ -381,55 +389,98 @@ xfs_dir3_data_readahead(
 }
 
 /*
- * Given a data block and an unused entry from that block,
- * return the bestfree entry if any that corresponds to it.
+ * Find the bestfree entry that exactly coincides with unused directory space
+ * or a verifier error because the bestfree data are bad.
  */
-xfs_dir2_data_free_t *
-xfs_dir2_data_freefind(
-	struct xfs_dir2_data_hdr *hdr,		/* data block header */
-	struct xfs_dir2_data_free *bf,		/* bestfree table pointer */
-	struct xfs_dir2_data_unused *dup)	/* unused space */
+static xfs_failaddr_t
+xfs_dir2_data_freefind_verify(
+	struct xfs_dir2_data_hdr	*hdr,
+	struct xfs_dir2_data_free	*bf,
+	struct xfs_dir2_data_unused	*dup,
+	struct xfs_dir2_data_free	**bf_ent)
 {
-	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
-	xfs_dir2_data_aoff_t	off;		/* offset value needed */
-#ifdef DEBUG
-	int			matched;	/* matched the value */
-	int			seenzero;	/* saw a 0 bestfree entry */
-#endif
+	struct xfs_dir2_data_free	*dfp;
+	xfs_dir2_data_aoff_t		off;
+	bool				matched = false;
+	bool				seenzero = false;
 
+	*bf_ent = NULL;
 	off = (xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr);
 
-#ifdef DEBUG
 	/*
 	 * Validate some consistency in the bestfree table.
 	 * Check order, non-overlapping entries, and if we find the
 	 * one we're looking for it has to be exact.
 	 */
-	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
-	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
-	for (dfp = &bf[0], seenzero = matched = 0;
-	     dfp < &bf[XFS_DIR2_DATA_FD_COUNT];
-	     dfp++) {
+	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
 		if (!dfp->offset) {
-			ASSERT(!dfp->length);
-			seenzero = 1;
+			if (dfp->length)
+				return __this_address;
+			seenzero = true;
 			continue;
 		}
-		ASSERT(seenzero == 0);
+		if (seenzero)
+			return __this_address;
 		if (be16_to_cpu(dfp->offset) == off) {
-			matched = 1;
-			ASSERT(dfp->length == dup->length);
-		} else if (off < be16_to_cpu(dfp->offset))
-			ASSERT(off + be16_to_cpu(dup->length) <= be16_to_cpu(dfp->offset));
-		else
-			ASSERT(be16_to_cpu(dfp->offset) + be16_to_cpu(dfp->length) <= off);
-		ASSERT(matched || be16_to_cpu(dfp->length) >= be16_to_cpu(dup->length));
-		if (dfp > &bf[0])
-			ASSERT(be16_to_cpu(dfp[-1].length) >= be16_to_cpu(dfp[0].length));
+			matched = true;
+			if (dfp->length != dup->length)
+				return __this_address;
+		} else if (be16_to_cpu(dfp->offset) > off) {
+			if (off + be16_to_cpu(dup->length) >
+			    be16_to_cpu(dfp->offset))
+				return __this_address;
+		} else {
+			if (be16_to_cpu(dfp->offset) +
+			    be16_to_cpu(dfp->length) > off)
+				return __this_address;
+		}
+		if (!matched &&
+		    be16_to_cpu(dfp->length) < be16_to_cpu(dup->length))
+			return __this_address;
+		if (dfp > &bf[0] &&
+		    be16_to_cpu(dfp[-1].length) < be16_to_cpu(dfp[0].length))
+			return __this_address;
 	}
-#endif
+
+	/*
+	 * If this is smaller than the smallest bestfree entry,
+	 * it can't be there since they're sorted.
+	 */
+	if (be16_to_cpu(dup->length) <
+	    be16_to_cpu(bf[XFS_DIR2_DATA_FD_COUNT - 1].length))
+		return NULL;
+	/*
+	 * Look at the three bestfree entries for our guy.
+	 */
+	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
+		if (!dfp->offset)
+			return NULL;
+		if (be16_to_cpu(dfp->offset) == off) {
+			*bf_ent = dfp;
+			return NULL;
+		}
+	}
+	/*
+	 * Didn't find it.  This only happens if there are duplicate lengths.
+	 */
+	return NULL;
+}
+
+/*
+ * Given a data block and an unused entry from that block,
+ * return the bestfree entry if any that corresponds to it.
+ */
+xfs_dir2_data_free_t *
+xfs_dir2_data_freefind(
+	struct xfs_dir2_data_hdr *hdr,		/* data block header */
+	struct xfs_dir2_data_free *bf,		/* bestfree table pointer */
+	struct xfs_dir2_data_unused *dup)	/* unused space */
+{
+	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
+	xfs_dir2_data_aoff_t	off;		/* offset value needed */
+
+	off = (xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr);
+
 	/*
 	 * If this is smaller than the smallest bestfree entry,
 	 * it can't be there since they're sorted.

