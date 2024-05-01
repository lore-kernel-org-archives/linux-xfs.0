Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6531607B2;
	Wed,  1 May 2024 18:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588898; cv=none; b=qlRGBJDogF0l4KcFT4htfBT1Lfso6Cof9RzfOqxzSqkIMY2lhkmIZ+Um2bZYibUvAT8IuanMDi+Zn2FOUKwKk4wnUDhIwNygL7Hki/08w9RcdGIRFmvuimtueMcFREIMhyPbyaAAtw/90KKXUpyq53e98Gd6/k51efv4spcacmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588898; c=relaxed/simple;
	bh=E4g2Q1/p7/s0gG6PYDJq/7j+q1Io62v3H+EdvSsi0TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjxDQfgWqSSIdfnK3iZcBPNHbUbEUO3H0vCPGxTVg8ATzOr0EOH6RIJ5MhR8GpFGgIS+LeaaPwt6e3AGRGjUv40vs8rH1HnSpyx60nFUnuCK1VGAatqT79fkdkjroHTkRp0dv+6R4HuoSC6VzMNNrnYNn8/rOlxuj5KxBlBG6FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XOeek4ug; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XOeek4ug"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ed691fb83eso6259260b3a.1;
        Wed, 01 May 2024 11:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588896; x=1715193696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4advk/h02abBXT0rWwwx1h+0BdZU9l5bCpDfvIPf8xI=;
        b=XOeek4ug+xTD3q10EUt9rTXHcQqnT+Bhv3iPhTkjz54WNLkdlv9w6jQ8JMNvANnghX
         TzfaplkwC1hqICexasxXsl3zP1vi0SRiZ9Ox5Vd8x73Y1lDwnbWDByCp+3IUP+KdJtpU
         79NULL3vuD/INkBBAfarPQ6p3X4peHfM2hZy8xaVIIwDIRzxsVyCXtzelBnSbnYpoWkq
         +ltY63JCKf3ZyJbsA1x7xIaRSA+6/G/M5Musr7nfGefEtRQPWFx1vu7y/u9xHUYG9auE
         OXzST8P+nLEN6udRg2yM8qZEFSKa8n+FJGTgCi0d1ikRII+w9qeEYX3Mk10kJJj+SKgR
         Gybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588896; x=1715193696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4advk/h02abBXT0rWwwx1h+0BdZU9l5bCpDfvIPf8xI=;
        b=iCyhvg948zNByMBP2Nb9xbxTmjDS4uY5IJXBIEYtin/c/zb8G6ae+Y4Qm+UmVpV5ap
         H+UhzNdfrA8lfgpzpxQfs4uGS0hgFgKKXT7TCduH0T8R6JY1B6a1Lr0ML5QDIi1qlT7H
         izguPEiydD18KE1U2+4WUT37W/b9kA0ymNCJBRVCXvACWDlhtpdbYC6IRNAlDv4E6ZN4
         EG951BRUQZhy+3y/FmxGbHdy8bjKaCFzgwYedVu9ip0gvJ6pHGV+HVYc9okM3JMr8MPb
         5mcEV0vK+EoDnOmEdgGqKWWLYQ2IQ9xCp2WJ6sZgzFGuONjyP/aWqSACkFfZFhR79QD5
         0rlw==
X-Gm-Message-State: AOJu0YzNTVk+4rzmI2ql8+FE1C+mI02gmHVOHQcr5vLJQiM1S5dmmq8+
	kz4FJco5X8wSqWJKzWdfcgTidEMpSRHoWVB2A3vi7kTtGrjcDMNKEaEYGNsB
X-Google-Smtp-Source: AGHT+IGAvpb8IuXztwK7Vwcf5wHSt73yiOFQF5svxZnqHMZsmDOUnIsBA1lX4LjIPLPgMlk5vulCaQ==
X-Received: by 2002:a05:6a20:3c91:b0:1a3:ae18:f1e4 with SMTP id b17-20020a056a203c9100b001a3ae18f1e4mr3839818pzj.34.1714588896371;
        Wed, 01 May 2024 11:41:36 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:35 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Xiao Yang <yangx.jy@fujitsu.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 18/24] xfs: hoist refcount record merge predicates
Date: Wed,  1 May 2024 11:41:06 -0700
Message-ID: <20240501184112.3799035-18-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 9d720a5a658f5135861773f26e927449bef93d61 ]

Hoist these multiline conditionals into separate static inline helpers
to improve readability and set the stage for corruption fixes that will
be introduced in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c | 129 ++++++++++++++++++++++++++++++-----
 1 file changed, 113 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 3f34bafe18dd..4408893333a6 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -815,11 +815,119 @@ xfs_refcount_find_right_extents(
 /* Is this extent valid? */
 static inline bool
 xfs_refc_valid(
-	struct xfs_refcount_irec	*rc)
+	const struct xfs_refcount_irec	*rc)
 {
 	return rc->rc_startblock != NULLAGBLOCK;
 }
 
+static inline bool
+xfs_refc_want_merge_center(
+	const struct xfs_refcount_irec	*left,
+	const struct xfs_refcount_irec	*cleft,
+	const struct xfs_refcount_irec	*cright,
+	const struct xfs_refcount_irec	*right,
+	bool				cleft_is_cright,
+	enum xfs_refc_adjust_op		adjust,
+	unsigned long long		*ulenp)
+{
+	unsigned long long		ulen = left->rc_blockcount;
+
+	/*
+	 * To merge with a center record, both shoulder records must be
+	 * adjacent to the record we want to adjust.  This is only true if
+	 * find_left and find_right made all four records valid.
+	 */
+	if (!xfs_refc_valid(left)  || !xfs_refc_valid(right) ||
+	    !xfs_refc_valid(cleft) || !xfs_refc_valid(cright))
+		return false;
+
+	/* There must only be one record for the entire range. */
+	if (!cleft_is_cright)
+		return false;
+
+	/* The shoulder record refcounts must match the new refcount. */
+	if (left->rc_refcount != cleft->rc_refcount + adjust)
+		return false;
+	if (right->rc_refcount != cleft->rc_refcount + adjust)
+		return false;
+
+	/*
+	 * The new record cannot exceed the max length.  ulen is a ULL as the
+	 * individual record block counts can be up to (u32 - 1) in length
+	 * hence we need to catch u32 addition overflows here.
+	 */
+	ulen += cleft->rc_blockcount + right->rc_blockcount;
+	if (ulen >= MAXREFCEXTLEN)
+		return false;
+
+	*ulenp = ulen;
+	return true;
+}
+
+static inline bool
+xfs_refc_want_merge_left(
+	const struct xfs_refcount_irec	*left,
+	const struct xfs_refcount_irec	*cleft,
+	enum xfs_refc_adjust_op		adjust)
+{
+	unsigned long long		ulen = left->rc_blockcount;
+
+	/*
+	 * For a left merge, the left shoulder record must be adjacent to the
+	 * start of the range.  If this is true, find_left made left and cleft
+	 * contain valid contents.
+	 */
+	if (!xfs_refc_valid(left) || !xfs_refc_valid(cleft))
+		return false;
+
+	/* Left shoulder record refcount must match the new refcount. */
+	if (left->rc_refcount != cleft->rc_refcount + adjust)
+		return false;
+
+	/*
+	 * The new record cannot exceed the max length.  ulen is a ULL as the
+	 * individual record block counts can be up to (u32 - 1) in length
+	 * hence we need to catch u32 addition overflows here.
+	 */
+	ulen += cleft->rc_blockcount;
+	if (ulen >= MAXREFCEXTLEN)
+		return false;
+
+	return true;
+}
+
+static inline bool
+xfs_refc_want_merge_right(
+	const struct xfs_refcount_irec	*cright,
+	const struct xfs_refcount_irec	*right,
+	enum xfs_refc_adjust_op		adjust)
+{
+	unsigned long long		ulen = right->rc_blockcount;
+
+	/*
+	 * For a right merge, the right shoulder record must be adjacent to the
+	 * end of the range.  If this is true, find_right made cright and right
+	 * contain valid contents.
+	 */
+	if (!xfs_refc_valid(right) || !xfs_refc_valid(cright))
+		return false;
+
+	/* Right shoulder record refcount must match the new refcount. */
+	if (right->rc_refcount != cright->rc_refcount + adjust)
+		return false;
+
+	/*
+	 * The new record cannot exceed the max length.  ulen is a ULL as the
+	 * individual record block counts can be up to (u32 - 1) in length
+	 * hence we need to catch u32 addition overflows here.
+	 */
+	ulen += cright->rc_blockcount;
+	if (ulen >= MAXREFCEXTLEN)
+		return false;
+
+	return true;
+}
+
 /*
  * Try to merge with any extents on the boundaries of the adjustment range.
  */
@@ -861,23 +969,15 @@ xfs_refcount_merge_extents(
 		 (cleft.rc_blockcount == cright.rc_blockcount);
 
 	/* Try to merge left, cleft, and right.  cleft must == cright. */
-	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount +
-			right.rc_blockcount;
-	if (xfs_refc_valid(&left) && xfs_refc_valid(&right) &&
-	    xfs_refc_valid(&cleft) && xfs_refc_valid(&cright) && cequal &&
-	    left.rc_refcount == cleft.rc_refcount + adjust &&
-	    right.rc_refcount == cleft.rc_refcount + adjust &&
-	    ulen < MAXREFCEXTLEN) {
+	if (xfs_refc_want_merge_center(&left, &cleft, &cright, &right, cequal,
+				adjust, &ulen)) {
 		*shape_changed = true;
 		return xfs_refcount_merge_center_extents(cur, &left, &cleft,
 				&right, ulen, aglen);
 	}
 
 	/* Try to merge left and cleft. */
-	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount;
-	if (xfs_refc_valid(&left) && xfs_refc_valid(&cleft) &&
-	    left.rc_refcount == cleft.rc_refcount + adjust &&
-	    ulen < MAXREFCEXTLEN) {
+	if (xfs_refc_want_merge_left(&left, &cleft, adjust)) {
 		*shape_changed = true;
 		error = xfs_refcount_merge_left_extent(cur, &left, &cleft,
 				agbno, aglen);
@@ -893,10 +993,7 @@ xfs_refcount_merge_extents(
 	}
 
 	/* Try to merge cright and right. */
-	ulen = (unsigned long long)right.rc_blockcount + cright.rc_blockcount;
-	if (xfs_refc_valid(&right) && xfs_refc_valid(&cright) &&
-	    right.rc_refcount == cright.rc_refcount + adjust &&
-	    ulen < MAXREFCEXTLEN) {
+	if (xfs_refc_want_merge_right(&cright, &right, adjust)) {
 		*shape_changed = true;
 		return xfs_refcount_merge_right_extent(cur, &right, &cright,
 				aglen);
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

