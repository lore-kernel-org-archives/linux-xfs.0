Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EFFFD29E22
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 18:52:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 719C0AC004
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 16:52:04 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9oIQF2qAFw2QVyhG for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 16:52:01 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UeDON-0006AS-0K
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:55 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UeDO2-0003zH-Ts
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/14] xfs: fully initialise temp leaf in
	xfs_attr3_leaf_compact
Date: Mon, 20 May 2013 09:51:21 +1000
Message-Id: <1369007481-15185-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1369007481-15185-1-git-send-email-david@fromorbit.com>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
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

xfs_attr3_leaf_compact() uses a temporary buffer for compacting the
the entries in a leaf. It copies the the original buffer into the
temporary buffer, then zeros the original buffer completely. It then
copies the entries back into the original buffer.  However, the
original buffer has not been correctly initialised, and so the
movement of the entries goes horribly wrong.

Make sure the zeroed destination buffer is fully initialised, and
once we've set up the destination incore header appropriately, write
is back to the buffer before starting to move entries around.

While debugging this, the _d/_s prefixes weren't sufficient to
remind me what buffer was what, so rename then all _src/_dst.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_leaf.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 79ece72..5b03d15 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -1445,11 +1445,12 @@ xfs_attr3_leaf_add_work(
 STATIC void
 xfs_attr3_leaf_compact(
 	struct xfs_da_args	*args,
-	struct xfs_attr3_icleaf_hdr *ichdr_d,
+	struct xfs_attr3_icleaf_hdr *ichdr_dst,
 	struct xfs_buf		*bp)
 {
-	xfs_attr_leafblock_t	*leaf_s, *leaf_d;
-	struct xfs_attr3_icleaf_hdr ichdr_s;
+	struct xfs_attr_leafblock *leaf_src;
+	struct xfs_attr_leafblock *leaf_dst;
+	struct xfs_attr3_icleaf_hdr ichdr_src;
 	struct xfs_trans	*trans = args->trans;
 	struct xfs_mount	*mp = trans->t_mountp;
 	char			*tmpbuffer;
@@ -1457,29 +1458,38 @@ xfs_attr3_leaf_compact(
 	trace_xfs_attr_leaf_compact(args);
 
 	tmpbuffer = kmem_alloc(XFS_LBSIZE(mp), KM_SLEEP);
-	ASSERT(tmpbuffer != NULL);
 	memcpy(tmpbuffer, bp->b_addr, XFS_LBSIZE(mp));
 	memset(bp->b_addr, 0, XFS_LBSIZE(mp));
+	leaf_src = (xfs_attr_leafblock_t *)tmpbuffer;
+	leaf_dst = bp->b_addr;
 
 	/*
-	 * Copy basic information
+	 * Copy the on-disk header back into the destination buffer to ensure
+	 * all the information in the header that is not part of the incore
+	 * header structure is preserved.
 	 */
-	leaf_s = (xfs_attr_leafblock_t *)tmpbuffer;
-	leaf_d = bp->b_addr;
-	ichdr_s = *ichdr_d;	/* struct copy */
-	ichdr_d->firstused = XFS_LBSIZE(mp);
-	ichdr_d->usedbytes = 0;
-	ichdr_d->count = 0;
-	ichdr_d->holes = 0;
-	ichdr_d->freemap[0].base = xfs_attr3_leaf_hdr_size(leaf_s);
-	ichdr_d->freemap[0].size = ichdr_d->firstused - ichdr_d->freemap[0].base;
+	memcpy(bp->b_addr, tmpbuffer, xfs_attr3_leaf_hdr_size(leaf_src));
+
+	/* Initialise the incore headers */
+	ichdr_src = *ichdr_dst;	/* struct copy */
+	ichdr_dst->firstused = XFS_LBSIZE(mp);
+	ichdr_dst->usedbytes = 0;
+	ichdr_dst->count = 0;
+	ichdr_dst->holes = 0;
+	ichdr_dst->freemap[0].base = xfs_attr3_leaf_hdr_size(leaf_src);
+	ichdr_dst->freemap[0].size = ichdr_dst->firstused -
+						ichdr_dst->freemap[0].base;
+
+
+	/* write the header back to initialise the underlying buffer */
+	xfs_attr3_leaf_hdr_to_disk(leaf_dst, ichdr_dst);
 
 	/*
 	 * Copy all entry's in the same (sorted) order,
 	 * but allocate name/value pairs packed and in sequence.
 	 */
-	xfs_attr3_leaf_moveents(leaf_s, &ichdr_s, 0, leaf_d, ichdr_d, 0,
-				ichdr_s.count, mp);
+	xfs_attr3_leaf_moveents(leaf_src, &ichdr_src, 0, leaf_dst, ichdr_dst, 0,
+				ichdr_src.count, mp);
 	/*
 	 * this logs the entire buffer, but the caller must write the header
 	 * back to the buffer when it is finished modifying it.
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
