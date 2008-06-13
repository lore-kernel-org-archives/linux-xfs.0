Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jun 2008 06:22:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5DDM9pf008133
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2008 06:22:10 -0700
Date: Fri, 13 Jun 2008 09:23:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix extent corruption in xfs_iext_irec_compact_full()
Message-ID: <20080613132304.GA28190@infradead.org>
References: <48522031.5060700@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48522031.5060700@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 13, 2008 at 05:22:25PM +1000, Lachlan McIlroy wrote:
> This function is used to compact the indirect extent list by moving
> extents from one page to the previous to fill them up.  After we
> move some extents to an earlier page we need to shuffle the remaining
> extents to the start of the page.  The actual bug here is the second
> argument to memmove() needs to index past the extents, that were copied
> to the previous page, and move the remaining extents.  For pages that
> are already full (ie ext_avail == 0) the compaction code has no net
> effect so don't do it.
>
> Thanks to Dave Chinner for pointing out the bug.


Looks good but this function needs a lot more comments.  Below is a
version of the patch with some more comments describing what's going
on that I came up with when trying to understand what this patch does
in detail:


Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-06-13 14:58:33.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-06-13 15:15:25.000000000 +0200
@@ -4532,39 +4532,63 @@ xfs_iext_irec_compact_full(
 	int		nlists;			/* number of irec's (ex lists) */
 
 	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
+
 	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
 	erp = ifp->if_u1.if_ext_irec;
 	ep = &erp->er_extbuf[erp->er_extcount];
 	erp_next = erp + 1;
 	ep_next = erp_next->er_extbuf;
+
 	while (erp_idx < nlists - 1) {
+		/*
+		 * Check how many extent records are available in this irec.
+		 * If there is none skip the whole exercise.
+		 */
 		ext_avail = XFS_LINEAR_EXTS - erp->er_extcount;
-		ext_diff = MIN(ext_avail, erp_next->er_extcount);
-		memcpy(ep, ep_next, ext_diff * sizeof(xfs_bmbt_rec_t));
-		erp->er_extcount += ext_diff;
-		erp_next->er_extcount -= ext_diff;
-		/* Remove next page */
-		if (erp_next->er_extcount == 0) {
+		if (ext_avail) {
+
+			/*
+			 * Copy over as many as possible extent records into
+			 * the previous page.
+			 */
+			ext_diff = MIN(ext_avail, erp_next->er_extcount);
+			memcpy(ep, ep_next, ext_diff * sizeof(xfs_bmbt_rec_t));
+			erp->er_extcount += ext_diff;
+			erp_next->er_extcount -= ext_diff;
+
 			/*
-			 * Free page before removing extent record
-			 * so er_extoffs don't get modified in
-			 * xfs_iext_irec_remove.
+			 * If the next irec is empty now we can simply
+			 * remove it.
 			 */
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
+
+			/*
+			 * If the next irec is not empty move up the content
+			 * that has not been copied to the previous page to
+			 * the beggining of this one.
+			 */
+			} else {
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
+
 		if (erp->er_extcount == XFS_LINEAR_EXTS) {
 			erp_idx++;
 			if (erp_idx < nlists)
