Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF972253B67;
	Wed,  2 Jul 2025 09:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751449226; cv=none; b=AeCsGBtsmMAnaZ0RyUDWQnw7RRv6nEFUGG5AvyWECqlVjLOTDWMmidiM1TPd4XbkAgL1i9o+36NAxMNLIbN1sG7Dw5MZFc4WLA/r0vRtBO7UtMZ3NU/vc2tt4GuYe2Mn0AR4R0Ane1PTm7+Pnp4l84EeYOXxrYby5wK6LWq4lP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751449226; c=relaxed/simple;
	bh=RQYcNROOPLIn2tNT/r9qUAjCa4QFJ6VeikSfvlUZ3/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kL8vqAFg5Kuiy3RPfw5pToFWGRBPIMVtSKa8s1ZYLIrCp4b54fsrdTURd6UwX5lXNA1vFV6vbZ0JroGd5RBY57qGxXe8p9RmIPvJ20x6K7bnzfauiT7C5/JryOX9oJV1sJmuK64r5cwg3CRnle1g6dCQ8EzZXIWvbYcw2tSYsLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=J3C48x82; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="J3C48x82"
Received: from fedora.intra.ispras.ru (unknown [10.10.165.14])
	by mail.ispras.ru (Postfix) with ESMTPSA id 571494076B5F;
	Wed,  2 Jul 2025 09:40:14 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 571494076B5F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1751449214;
	bh=r6wtu7KOop3pbRUG/1WRnQPZWmDWqzWUwGwr/9/U5+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3C48x82vr4rytESnJXzvVtg0MehnOtHAzWmmMJs8rFqsbUPDd4OUSGFLITfIdlVf
	 TkVGwbCwYfRc2IVoNMfmtjXsgM9MMI2jIOgbwd/sJMZuPJAfrvadSi1fyLW+y0GO7H
	 SAaolmqrSRSZF9QJr4R4uyjvlJAseC3gMXHWMYUo=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH v2 5/6] xfs: use a proper variable name and type for storing a comparison result
Date: Wed,  2 Jul 2025 12:39:32 +0300
Message-ID: <20250702093935.123798-6-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250702093935.123798-1-pchelkin@ispras.ru>
References: <20250702093935.123798-1-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Perhaps that's just my silly imagination but 'diff' doesn't look good for
the name of a variable to hold a result of a three-way-comparison
(-1, 0, 1) which is what ->cmp_key_with_cur() does. It implies to contain
an actual difference between the two integer variables but that's not true
anymore after recent refactoring.

Declaring it as int64_t is also misleading now. Plain integer type is
more than enough.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---

v2: add R-b

 fs/xfs/libxfs/xfs_btree.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 99a63a178f25..d3591728998e 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1985,7 +1985,7 @@ xfs_btree_lookup(
 	int			*stat)	/* success/failure */
 {
 	struct xfs_btree_block	*block;	/* current btree block */
-	int64_t			diff;	/* difference for the current key */
+	int			cmp_r;	/* current key comparison result */
 	int			error;	/* error return value */
 	int			keyno;	/* current key number */
 	int			level;	/* level in the btree */
@@ -2013,13 +2013,13 @@ xfs_btree_lookup(
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
@@ -2065,15 +2065,16 @@ xfs_btree_lookup(
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
@@ -2089,7 +2090,7 @@ xfs_btree_lookup(
 			 * If we moved left, need the previous key number,
 			 * unless there isn't one.
 			 */
-			if (diff > 0 && --keyno < 1)
+			if (cmp_r > 0 && --keyno < 1)
 				keyno = 1;
 			pp = xfs_btree_ptr_addr(cur, keyno, block);
 
@@ -2102,7 +2103,7 @@ xfs_btree_lookup(
 	}
 
 	/* Done with the search. See if we need to adjust the results. */
-	if (dir != XFS_LOOKUP_LE && diff < 0) {
+	if (dir != XFS_LOOKUP_LE && cmp_r < 0) {
 		keyno++;
 		/*
 		 * If ge search and we went off the end of the block, but it's
@@ -2125,14 +2126,14 @@ xfs_btree_lookup(
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
-- 
2.50.0

