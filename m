Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E7B29E0E8
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 16:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759942542; cv=none; b=WHUFI93d88niTpLPLIJz76Bl1Pv4WQf9bU5ftO+k6l4YV/cebQ0Mj9f6kM5o7cA1ol/XEvvLQPmAJGtsJdLJ5PJLxmihr8PLCY2LFsxhjbzOFANMsQOkAOU2Y1UD/r4iNI7PiQoDX9MDqCbIrsqwOlEd1WUXWoJVJcczNzfidrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759942542; c=relaxed/simple;
	bh=6XgRC2kxeAUc/E+oCurB3e5orxOCTs/vHSMpKz7J11Y=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L5Kj1bSJ7j0Lp5q193ihwvRDpwS4PK2kmzn4R1aUGk7supMOZ+BGCJxnD7EjyeGHPC+Ez+oLBmNokmH+USh8oCGAkB4YcRiwUpitfC/wAp4ZAO9yzBQirhwnI16cKkLoBp5Kc7OPV39EeE6DfliNT+34NTqOWN36q70dXFefrPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BC7C4CEE7;
	Wed,  8 Oct 2025 16:55:39 +0000 (UTC)
Date: Wed, 8 Oct 2025 18:55:37 +0200
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH 5/11] [PATCH] xfs: use a proper variable name and type for
 storing a comparison result
Message-ID: <gc5eiz3y6ymejva2fnsz2rumzs6ak6lby3lw2sb6ollp2w2mqh@64mxegsjzujy>
References: <cover.1759941416.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1759941416.patch-series@thinky>

Source kernel commit: 2717eb35185581988799bb0d5179409978f36a90

Perhaps that's just my silly imagination but 'diff' doesn't look good for
the name of a variable to hold a result of a three-way-comparison
(-1, 0, 1) which is what ->cmp_key_with_cur() does. It implies to contain
an actual difference between the two integer variables but that's not true
anymore after recent refactoring.

Declaring it as int64_t is also misleading now. Plain integer type is
more than enough.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_btree.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 15846f0ff6..facc35401f 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1982,7 +1982,7 @@
 	int			*stat)	/* success/failure */
 {
 	struct xfs_btree_block	*block;	/* current btree block */
-	int64_t			diff;	/* difference for the current key */
+	int			cmp_r;	/* current key comparison result */
 	int			error;	/* error return value */
 	int			keyno;	/* current key number */
 	int			level;	/* level in the btree */
@@ -2010,13 +2010,13 @@
 	 * on the lookup record, then follow the corresponding block
 	 * pointer down to the next level.
 	 */
-	for (level = cur->bc_nlevels - 1, diff = 1; level >= 0; level--) {
+	for (level = cur->bc_nlevels - 1, cmp_r = 1; level >= 0; level--) {
 		/* Get the block we need to do the lookup on. */
 		error = xfs_btree_lookup_get_block(cur, level, pp, &block);
 		if (error)
 			goto error0;
 
-		if (diff == 0) {
+		if (cmp_r == 0) {
 			/*
 			 * If we already had a key match at a higher level, we
 			 * know we need to use the first entry in this block.
@@ -2062,15 +2062,16 @@
 						keyno, block, &key);
 
 				/*
-				 * Compute difference to get next direction:
+				 * Compute comparison result to get next
+				 * direction:
 				 *  - less than, move right
 				 *  - greater than, move left
 				 *  - equal, we're done
 				 */
-				diff = cur->bc_ops->cmp_key_with_cur(cur, kp);
-				if (diff < 0)
+				cmp_r = cur->bc_ops->cmp_key_with_cur(cur, kp);
+				if (cmp_r < 0)
 					low = keyno + 1;
-				else if (diff > 0)
+				else if (cmp_r > 0)
 					high = keyno - 1;
 				else
 					break;
@@ -2086,7 +2087,7 @@
 			 * If we moved left, need the previous key number,
 			 * unless there isn't one.
 			 */
-			if (diff > 0 && --keyno < 1)
+			if (cmp_r > 0 && --keyno < 1)
 				keyno = 1;
 			pp = xfs_btree_ptr_addr(cur, keyno, block);
 
@@ -2099,7 +2100,7 @@
 	}
 
 	/* Done with the search. See if we need to adjust the results. */
-	if (dir != XFS_LOOKUP_LE && diff < 0) {
+	if (dir != XFS_LOOKUP_LE && cmp_r < 0) {
 		keyno++;
 		/*
 		 * If ge search and we went off the end of the block, but it's
@@ -2122,14 +2123,14 @@
 			*stat = 1;
 			return 0;
 		}
-	} else if (dir == XFS_LOOKUP_LE && diff > 0)
+	} else if (dir == XFS_LOOKUP_LE && cmp_r > 0)
 		keyno--;
 	cur->bc_levels[0].ptr = keyno;
 
 	/* Return if we succeeded or not. */
 	if (keyno == 0 || keyno > xfs_btree_get_numrecs(block))
 		*stat = 0;
-	else if (dir != XFS_LOOKUP_EQ || diff == 0)
+	else if (dir != XFS_LOOKUP_EQ || cmp_r == 0)
 		*stat = 1;
 	else
 		*stat = 0;
