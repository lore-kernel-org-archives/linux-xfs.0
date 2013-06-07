Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E29AF7F87
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 07:25:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C11B88F8059
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 05:25:36 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	oHVjx6I3CR8FFa9a for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 05:25:35 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkvjQ-0005TJ-Lj
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:24 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkvjG-00031W-IA
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/12] xfs: fully initialise temp leaf in
	xfs_attr3_leaf_unbalance
Date: Fri,  7 Jun 2013 22:24:58 +1000
Message-Id: <1370607901-11538-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1370607901-11538-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
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
 libxfs/xfs_attr_leaf.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index d9f5ec5..d7db336 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1971,14 +1971,24 @@ xfs_attr3_leaf_unbalance(
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
