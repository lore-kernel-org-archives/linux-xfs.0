Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5904329E0E
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 03:02:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 38F408F8039
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 01:02:37 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ILpbaPiF3ho0qqi5 for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 01:02:35 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/11] xfs: fully initialise temp leaf in
	xfs_attr3_leaf_unbalance
Date: Tue, 21 May 2013 18:02:05 +1000
Message-Id: <1369123330-9579-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1369123330-9579-1-git-send-email-david@fromorbit.com>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com

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
