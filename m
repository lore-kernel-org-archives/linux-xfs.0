Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE30F40F75B
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 12:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785499428; cv=none; b=HC5axWza/D4x62Pb4velkg2OTYeym5/7NqpXCpJLzVc2g6OAflx+nOuqO5rypKa/VC2sc14OFiQxVtrO9sV9uhlmQdQj65CJbEORnkwu7EVrBOn/xcZKfGqmnkdgNrMvtDZIEt+IfRBS/+DhcML/6QTgZmeCb2bEiseu0q13Ozk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785499428; c=relaxed/simple;
	bh=QW7C5r3pM1/vCX46LSIXEXAD21DECLDErAMKMLOiNy0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ubxftiohShtUuUvoOawXK7APTgqyBJkQp2Bm1+dm3F+FS79DCn5xFEMgFZExDadWxQwlhdBoHZJlMUpK67HARZvpEaVRTLS+unZdp8+yKBlSjZuyMHC+V5cOC5mhLtnoF87GUR23qWU0Q8Ttn6JszH1iJ37Af7+LPyOzJMMtvBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=RKW703sj; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="RKW703sj"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e99ef0902so48825485a.2
        for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 05:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1785499425; x=1786104225; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mhz95Ie+nEoib5CAw3va8pb49gr72Xo3exPDF8Fxc0Q=;
        b=RKW703sj56tFYBI+ew9hX4ZgptQamLgFSldys6htEya3Jd8BDck29/PjDKDss0TmxN
         8+BoAHIxXGtHadNg5pJCgn1UrZEPQfd7Lmu+vsx7VcXix25MSP3eCzTVgciFMCWoYCDU
         /GXC6safhu+gzN7GRoXM0COXDE0Lxp6sFiOlBFtYPnyjefvyWbjs1p7fvEXoCIbVfbUL
         gtZjEd3coDnOmYB+VEXBsNJVSR7bXgsOSTZclG8in5hIQFbIM6uZSdTHjv+w3TLS6yi2
         eTrjX5/8B6r6qRJ4eqMlY2fg0QZGm2kSO7tevI4hMq5mhM34SVChI1qddr3OZc9xDH40
         1oqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785499425; x=1786104225;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mhz95Ie+nEoib5CAw3va8pb49gr72Xo3exPDF8Fxc0Q=;
        b=AlCBGYi48PvUJY4yARZ8zwNIzjS02pGU4BivKLo5eCBSIineElqnQpqFs6JfChRtIe
         8PDdzUtbCd9skGukP0+5dW1QHzyNtgd2iLLYqVODu62ZPGHFEZhFrdGK4bR04IWEAZ6t
         eVV9UasOFudr4aQYTSvITZYBG3Kp4ZRNMELs7NVWggt7wb3in3njwn0bzn5aGwfvPrMk
         3xK1CRSikvCIKz14WTAf192M7Jzi9X1loy6gExhDNswfqFahq6wKuAcsGXWJGy1jKUbY
         WtYZJrO/ReGKBrqyFjSmaKkXW7oahH6IvjXDHZpopOlibiRygq0gdnDShtu3+wtdLMLt
         DHuw==
X-Forwarded-Encrypted: i=1; AHgh+RoPjxnTA3HB9vH/YFzheXDsCYKuRDTqT1Zh132uS6wq97S/6nFJN2P2v9moWKwbfnVtS4IwQ92p31Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx69j+VwkYmXVBxXv7eXqKH7mHdSnHKuZk0vs1wizSsWUDpCehm
	qGCQTaYtpYe+dSz6nUVgY6rREEyg+o4EmemF7Dbrw1FUgXjLjbd+JFWFgvIkGT7+z3U=
X-Gm-Gg: AR+sD11ody9wN8M85W8b0MZ1ZCIJrLiQU9DqsO2zNu1f/0YXsWZH+PCq54X/PRJsxdI
	86pk+1Q+ZeURv4hrjScNrVZSacJ7rcMu2Ym3TqQIB3htyh0S9HKRfXRRBoOjiE5iODr4UHt5ml1
	x/u50gKJYTGhGMzxcK3IUsJ0b8Fm8WKAoReei3XZ+M7+Lgfvo+Aa7Z3fEhF6vlv87FN8qBThUEf
	1sPPsYD8YjknxMKbzil42T/uT+PXud3Zm7XLsloZmMu/3RQnUqI2Xi+jamRdbceLwVhdVNMaJ3S
	fRvd0RGxUyTXgBHXP6i5vvzmBRB8B9fROW0SHMjZzAjCss1SmLQi6gxs4pwwQuBusnLPtlqUvfc
	DpIdb24M6mUreKLrLmKR1kqiDqq62F3y25sk/5+wNLUracn76epFXRPwlg12fWIT9Z/s7PXJ3gV
	OTcJos8N7SLqyVQCeo6/68BFYeATDBUK8W/dWKBif2hL7+GAQ16DUI4ff9jtC2GqZLBw==
X-Received: by 2002:a05:620a:2625:b0:92e:4859:49dd with SMTP id af79cd13be357-934965cc450mr241891085a.26.1785499425318;
        Fri, 31 Jul 2026 05:03:45 -0700 (PDT)
Received: from localhost ([146.190.222.192])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-9349bc4bbcasm41860085a.13.2026.07.31.05.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:03:44 -0700 (PDT)
From: David Lee <david.lee@trailofbits.com>
To: cem@kernel.org
Cc: David Lee <david.lee@trailofbits.com>,
	Kyle Zeng <kylebot@openai.com>,
	Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: validate btree block level on read
Date: Fri, 31 Jul 2026 12:03:42 +0000
Message-ID: <20260731120344.558808-1-david.lee@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Btree buffer verifiers validate record counts against the level stored in
the block itself.  Callers of xfs_btree_read_buf_block(), however, use
the returned block according to the level they are traversing.  A
corrupted sibling pointer can therefore return a verifier-valid block
from another level and cause out-of-bounds accesses when layout-specific
entries are moved.

Pass the expected level into xfs_btree_read_buf_block() and reject
blocks whose on-disk level differs before returning them.  This
centralizes the check for traversal and sibling reads.

Fixes: 3d3e6f64e22c ("xfs: verify btree blocks as they are read from disk")
Bug found and triaged by OpenAI Security Research and 
validated by Trail of Bits.

Assisted-by: Codex:gpt-5.6-sol gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
Trail of Bits has a reproducer for this bug that triggers ㅁ
KASAN use-after-free and can share if needed.

 fs/xfs/libxfs/xfs_btree.c         | 48 +++++++++++++++++++------------
 fs/xfs/libxfs/xfs_btree.h         |  2 +-
 fs/xfs/libxfs/xfs_btree_staging.c |  9 +++---
 3 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 60ef7f08b..b2db143bb 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1378,13 +1378,14 @@ xfs_btree_get_buf_block(
 }
 
 /*
- * Read in the buffer at the given ptr and return the buffer and
- * the block pointer within the buffer.
+ * Read in the buffer at the given ptr and return the buffer and the block
+ * pointer within the buffer.  The block must be at the expected level.
  */
 int
 xfs_btree_read_buf_block(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_ptr	*ptr,
+	int				level,
 	int				flags,
 	struct xfs_btree_block		**block,
 	struct xfs_buf			**bpp)
@@ -1409,6 +1410,14 @@ xfs_btree_read_buf_block(
 
 	xfs_btree_set_refs(cur, *bpp);
 	*block = XFS_BUF_TO_BLOCK(*bpp);
+	if (xfs_btree_get_level(*block) != level) {
+		xfs_buf_mark_corrupt(*bpp);
+		xfs_trans_brelse(cur->bc_tp, *bpp);
+		xfs_btree_mark_sick(cur);
+		*block = NULL;
+		*bpp = NULL;
+		return -EFSCORRUPTED;
+	}
 	return 0;
 }
 
@@ -1733,7 +1742,8 @@ xfs_btree_increment(
 
 		ptrp = xfs_btree_ptr_addr(cur, cur->bc_levels[lev].ptr, block);
 		--lev;
-		error = xfs_btree_read_buf_block(cur, ptrp, 0, &block, &bp);
+		error = xfs_btree_read_buf_block(cur, ptrp, lev, 0, &block,
+						 &bp);
 		if (error)
 			goto error0;
 
@@ -1827,7 +1837,8 @@ xfs_btree_decrement(
 
 		ptrp = xfs_btree_ptr_addr(cur, cur->bc_levels[lev].ptr, block);
 		--lev;
-		error = xfs_btree_read_buf_block(cur, ptrp, 0, &block, &bp);
+		error = xfs_btree_read_buf_block(cur, ptrp, lev, 0, &block,
+						 &bp);
 		if (error)
 			goto error0;
 		xfs_btree_setbuf(cur, lev, bp);
@@ -1904,7 +1915,7 @@ xfs_btree_lookup_get_block(
 		return 0;
 	}
 
-	error = xfs_btree_read_buf_block(cur, pp, 0, blkp, &bp);
+	error = xfs_btree_read_buf_block(cur, pp, level, 0, blkp, &bp);
 	if (error)
 		return error;
 
@@ -1912,10 +1923,6 @@ xfs_btree_lookup_get_block(
 	if (xfs_btree_check_block_owner(cur, *blkp) != NULL)
 		goto out_bad;
 
-	/* Did we get the level we were looking for? */
-	if (be16_to_cpu((*blkp)->bb_level) != level)
-		goto out_bad;
-
 	/* Check that internal nodes have at least one record. */
 	if (level != 0 && be16_to_cpu((*blkp)->bb_numrecs) == 0)
 		goto out_bad;
@@ -2457,7 +2464,7 @@ xfs_btree_lshift(
 		goto out0;
 
 	/* Set up the left neighbor as "left". */
-	error = xfs_btree_read_buf_block(cur, &lptr, 0, &left, &lbp);
+	error = xfs_btree_read_buf_block(cur, &lptr, level, 0, &left, &lbp);
 	if (error)
 		goto error0;
 
@@ -2653,7 +2660,7 @@ xfs_btree_rshift(
 		goto out0;
 
 	/* Set up the right neighbor as "right". */
-	error = xfs_btree_read_buf_block(cur, &rptr, 0, &right, &rbp);
+	error = xfs_btree_read_buf_block(cur, &rptr, level, 0, &right, &rbp);
 	if (error)
 		goto error0;
 
@@ -2940,8 +2947,8 @@ __xfs_btree_split(
 	 * point back to right instead of to left.
 	 */
 	if (!xfs_btree_ptr_is_null(cur, &rrptr)) {
-		error = xfs_btree_read_buf_block(cur, &rrptr,
-							0, &rrblock, &rrbp);
+		error = xfs_btree_read_buf_block(cur, &rrptr, level, 0,
+						 &rrblock, &rrbp);
 		if (error)
 			goto error0;
 		xfs_btree_set_sibling(cur, rrblock, &rptr, XFS_BB_LEFTSIB);
@@ -3365,7 +3372,8 @@ xfs_btree_new_root(
 		lbp = bp;
 		xfs_btree_buf_to_ptr(cur, lbp, &lptr);
 		left = block;
-		error = xfs_btree_read_buf_block(cur, &rptr, 0, &right, &rbp);
+		error = xfs_btree_read_buf_block(cur, &rptr,
+						 cur->bc_nlevels - 1, 0, &right, &rbp);
 		if (error)
 			goto error0;
 		bp = rbp;
@@ -3376,7 +3384,8 @@ xfs_btree_new_root(
 		xfs_btree_buf_to_ptr(cur, rbp, &rptr);
 		right = block;
 		xfs_btree_get_sibling(cur, right, &lptr, XFS_BB_LEFTSIB);
-		error = xfs_btree_read_buf_block(cur, &lptr, 0, &left, &lbp);
+		error = xfs_btree_read_buf_block(cur, &lptr,
+						 cur->bc_nlevels - 1, 0, &left, &lbp);
 		if (error)
 			goto error0;
 		bp = lbp;
@@ -4394,7 +4403,8 @@ xfs_btree_delrec(
 		rptr = cptr;
 		right = block;
 		rbp = bp;
-		error = xfs_btree_read_buf_block(cur, &lptr, 0, &left, &lbp);
+		error = xfs_btree_read_buf_block(cur, &lptr, level, 0, &left,
+						 &lbp);
 		if (error)
 			goto error0;
 
@@ -4411,7 +4421,8 @@ xfs_btree_delrec(
 		lptr = cptr;
 		left = block;
 		lbp = bp;
-		error = xfs_btree_read_buf_block(cur, &rptr, 0, &right, &rbp);
+		error = xfs_btree_read_buf_block(cur, &rptr, level, 0, &right,
+						 &rbp);
 		if (error)
 			goto error0;
 
@@ -4483,7 +4494,8 @@ xfs_btree_delrec(
 	/* If there is a right sibling, point it to the remaining block. */
 	xfs_btree_get_sibling(cur, left, &cptr, XFS_BB_RIGHTSIB);
 	if (!xfs_btree_ptr_is_null(cur, &cptr)) {
-		error = xfs_btree_read_buf_block(cur, &cptr, 0, &rrblock, &rrbp);
+		error = xfs_btree_read_buf_block(cur, &cptr, level, 0,
+						 &rrblock, &rrbp);
 		if (error)
 			goto error0;
 		xfs_btree_set_sibling(cur, rrblock, &lptr, XFS_BB_LEFTSIB);
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 60e78572e..2153ee08d 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -650,7 +650,7 @@ int xfs_btree_get_buf_block(struct xfs_btree_cur *cur,
 		const union xfs_btree_ptr *ptr, struct xfs_btree_block **block,
 		struct xfs_buf **bpp);
 int xfs_btree_read_buf_block(struct xfs_btree_cur *cur,
-		const union xfs_btree_ptr *ptr, int flags,
+		const union xfs_btree_ptr *ptr, int level, int flags,
 		struct xfs_btree_block **block, struct xfs_buf **bpp);
 void xfs_btree_set_sibling(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, const union xfs_btree_ptr *ptr,
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index c3c7ea548..a8af4f834 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -385,6 +385,7 @@ xfs_btree_bload_leaf(
 STATIC int
 xfs_btree_bload_node(
 	struct xfs_btree_cur	*cur,
+	unsigned int		level,
 	unsigned int		recs_this_block,
 	union xfs_btree_ptr	*child_ptr,
 	struct xfs_btree_block	*block)
@@ -407,8 +408,8 @@ xfs_btree_bload_node(
 		 * been reclaimed.  LRU refs will be set on the block, which is
 		 * desirable if the new btree commits.
 		 */
-		ret = xfs_btree_read_buf_block(cur, child_ptr, 0, &child_block,
-				&child_bp);
+		ret = xfs_btree_read_buf_block(cur, child_ptr, level - 1, 0,
+					       &child_block, &child_bp);
 		if (ret)
 			return ret;
 
@@ -767,8 +768,8 @@ xfs_btree_bload(
 			trace_xfs_btree_bload_block(cur, level, i, blocks,
 					&ptr, nr_this_block);
 
-			ret = xfs_btree_bload_node(cur, nr_this_block,
-					&child_ptr, block);
+			ret = xfs_btree_bload_node(cur, level, nr_this_block,
+						   &child_ptr, block);
 			if (ret)
 				goto out;
 
