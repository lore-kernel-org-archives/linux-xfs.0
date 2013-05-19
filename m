Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3849229E36
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 18:52:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD01DAC001
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 16:52:02 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	wsCVePEyQ6kDlk4c for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 16:52:01 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UeDOC-00069z-VX
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:45 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UeDO2-0003zD-Sw
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/14] xfs: fully initialise temp leaf in
	xfs_attr3_leaf_unbalance
Date: Mon, 20 May 2013 09:51:20 +1000
Message-Id: <1369007481-15185-14-git-send-email-david@fromorbit.com>
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

xfs_attr3_leaf_unbalance() uses a temporary buffer for recombining
the entries in two leaves when the destination leaf requires
compaction. The temporary buffer ends up being copied back over the
original destination buffer, so the header in the temporary buffer
needs to contain all the information that is in the destination
buffer.

To make sure the temporary buffer is fully initialised, once we've
set up the temporary incore header appropriately, write is back to
the temporary buffer before starting to move entries around.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_leaf.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 0bce1b3..79ece72 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -2181,14 +2181,24 @@ xfs_attr3_leaf_unbalance(
 		struct xfs_attr_leafblock *tmp_leaf;
 		struct xfs_attr3_icleaf_hdr tmphdr;
 
-		tmp_leaf = kmem_alloc(state->blocksize, KM_SLEEP);
-		memset(tmp_leaf, 0, state->blocksize);
-		memset(&tmphdr, 0, sizeof(tmphdr));
+		tmp_leaf = kmem_zalloc(state->blocksize, KM_SLEEP);
+
+		/*
+		 * Copy the header into the temp leaf so that all the stuff
+		 * not in the incore header is present and gets copied back in
+		 * once we've moved all the entries.
+		 */
+		memcpy(tmp_leaf, save_leaf, xfs_attr3_leaf_hdr_size(save_leaf));
 
+		memset(&tmphdr, 0, sizeof(tmphdr));
 		tmphdr.magic = savehdr.magic;
 		tmphdr.forw = savehdr.forw;
 		tmphdr.back = savehdr.back;
 		tmphdr.firstused = state->blocksize;
+
+		/* write the header to the temp buffer to initialise it */
+		xfs_attr3_leaf_hdr_to_disk(tmp_leaf, &tmphdr);
+
 		if (xfs_attr3_leaf_order(save_blk->bp, &savehdr,
 					 drop_blk->bp, &drophdr)) {
 			xfs_attr3_leaf_moveents(drop_leaf, &drophdr, 0,
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
