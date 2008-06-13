Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jun 2008 00:18:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5D7IGlB005405
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2008 00:18:17 -0700
Message-ID: <48522031.5060700@sgi.com>
Date: Fri, 13 Jun 2008 17:22:25 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] fix extent corruption in xfs_iext_irec_compact_full()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This function is used to compact the indirect extent list by moving
extents from one page to the previous to fill them up.  After we
move some extents to an earlier page we need to shuffle the remaining
extents to the start of the page.  The actual bug here is the second
argument to memmove() needs to index past the extents, that were copied
to the previous page, and move the remaining extents.  For pages that
are already full (ie ext_avail == 0) the compaction code has no net
effect so don't do it.

Thanks to Dave Chinner for pointing out the bug.

Lachlan

--- fs/xfs/xfs_inode.c_1.504	2008-06-05 16:46:33.000000000 +1000
+++ fs/xfs/xfs_inode.c	2008-06-05 17:39:20.000000000 +1000
@@ -4541,31 +4541,35 @@ xfs_iext_irec_compact_full(
 	ep_next = erp_next->er_extbuf;
 	while (erp_idx < nlists - 1) {
 		ext_avail = XFS_LINEAR_EXTS - erp->er_extcount;
-		ext_diff = MIN(ext_avail, erp_next->er_extcount);
-		memcpy(ep, ep_next, ext_diff * sizeof(xfs_bmbt_rec_t));
-		erp->er_extcount += ext_diff;
-		erp_next->er_extcount -= ext_diff;
-		/* Remove next page */
-		if (erp_next->er_extcount == 0) {
-			/*
-			 * Free page before removing extent record
-			 * so er_extoffs don't get modified in
-			 * xfs_iext_irec_remove.
-			 */
-			kmem_free(erp_next->er_extbuf);
-			erp_next->er_extbuf = NULL;
-			xfs_iext_irec_remove(ifp, erp_idx + 1);
-			erp = &ifp->if_u1.if_ext_irec[erp_idx];
-			nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
-		/* Update next page */
-		} else {
-			/* Move rest of page up to become next new page */
-			memmove(erp_next->er_extbuf, ep_next,
-				erp_next->er_extcount * sizeof(xfs_bmbt_rec_t));
-			ep_next = erp_next->er_extbuf;
-			memset(&ep_next[erp_next->er_extcount], 0,
-				(XFS_LINEAR_EXTS - erp_next->er_extcount) *
-				sizeof(xfs_bmbt_rec_t));
+		if (ext_avail) {
+			ext_diff = MIN(ext_avail, erp_next->er_extcount);
+			memcpy(ep, ep_next, ext_diff * sizeof(xfs_bmbt_rec_t));
+			erp->er_extcount += ext_diff;
+			erp_next->er_extcount -= ext_diff;
+			/* Remove next page */
+			if (erp_next->er_extcount == 0) {
+				/*
+				 * Free page before removing extent record
+				 * so er_extoffs don't get modified in
+				 * xfs_iext_irec_remove.
+				 */
+				kmem_free(erp_next->er_extbuf);
+				erp_next->er_extbuf = NULL;
+				xfs_iext_irec_remove(ifp, erp_idx + 1);
+				erp = &ifp->if_u1.if_ext_irec[erp_idx];
+				nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
+			/* Update next page */
+			} else {
+				/* Move rest of page up to become next new page */
+				memmove(erp_next->er_extbuf, &ep_next[ext_diff],
+					erp_next->er_extcount *
+					sizeof(xfs_bmbt_rec_t));
+				ep_next = erp_next->er_extbuf;
+				memset(&ep_next[erp_next->er_extcount], 0,
+					(XFS_LINEAR_EXTS -
+						erp_next->er_extcount) *
+					sizeof(xfs_bmbt_rec_t));
+			}
 		}
 		if (erp->er_extcount == XFS_LINEAR_EXTS) {
 			erp_idx++;
