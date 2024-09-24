Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E7D1AD409;
	Tue, 24 Sep 2024 18:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203149; cv=none; b=CLF/E5Q40YyyMUZrG9tvSFLnxmN+cDV7T4ZOwm3c42rxXejzg776qNJzHEEooOVBqV4rbi+WVoWL0JCGLIORJPqblmRQSysrobwQMqm5UANFBPzO4gTMKoQ9nIr0K2xHKCY0G3pUzxUfpGheXHV3eku2AgBxOuj51PLZ/gOLVS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203149; c=relaxed/simple;
	bh=nVkPEga5SASg04QlCwOXOWsDhCoXJMVkpFru9hMKEOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meJnL+Vkeo2+75rGUlqngkj610nrzcPTgzkJrzX1Kc7zVLbIWDAwOQtv7JfILZBxNAXkpvhdpKqOMqapU/Zv5cTf69DW7UNA+4qhyXmBcy2NLZ5lX/DUWjr4mr9jKJThUX+L823ANd3cOUiCee9ZIN8wAu8bNp34S1EqNasPxhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CgXUYbqI; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CgXUYbqI"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2db928dbd53so4569800a91.2;
        Tue, 24 Sep 2024 11:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203147; x=1727807947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Siw42Xfz6n/3KOogFrORz0GkFjImJ3UQ18BTeV0byfk=;
        b=CgXUYbqIJv8LEhuCmVLJsR/iwRAi/a9vOqWVGvfbZRYqbfkRi2b0EzO80cFRIvgBOj
         OqAZ2mZfF9nBJGbV6eAtw6xbQxwZv3sWyB6JxNTr4m/8dTrHy83FWBTarJdJu0FeyS7N
         wUCSmA6TA46KmsKMH4NAYo8PPkfS+Y25BWVlOInyJETWPLbVPCvhZMs4IQTp5/8+hp88
         vOUw/20zolJBooWjrHNNiBcX7FijYT/kd6OYWGnJDsom/1pyLMYXkD4LY/yiQAjnicIH
         mg0lj6+Uo2fpuDdMLxmTwQVEuq5BZvq/s1ZsEhX+mAMnpxsIdSpBtKwmbumZb/ZfkLX8
         wdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203147; x=1727807947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Siw42Xfz6n/3KOogFrORz0GkFjImJ3UQ18BTeV0byfk=;
        b=WDeCY6rZJ/SPRT/zyenm1mTdEaVB2n5ueskzQwmWop39a8kM4YZnyqXT8RzQKtqCa9
         qCbHaHv9I4hxpKZIoxZcayuL0no3xPW/9OOoihAcXh1mpOXpKzSJdHFmrYWsWP7YJImX
         f3C4i0RVRDIUE2Na4cEXd9+5H0n86R9uoEEi2KvgayEchvUH0c6QpsmaOATmjnqljMLJ
         1G9yu8cOaJNMHP8fdIvb2gGnGws/hCr8JtQAAe8axHTD8L6HCYXiNaHHqs3D20Ng+vA2
         jN/zxqlMK17nHipvfCd9Sz86PA1a81e5aM1o/+ywMfk72EEwj+G2OHd4VcJXrb+a/oUK
         RTCw==
X-Gm-Message-State: AOJu0YwYArYyyKNhvS5dTNrXl0PIsxNCat1PZlRCplXuA7t/dvYdEtiI
	59KLSnCEg1gx6HCotEtMYmIL17QzfJOqMemOANFtIm3Fuy4PpJLsnzVahtAR
X-Google-Smtp-Source: AGHT+IEQE1LCTSG9DGhQpN8V2ChKBNUATpWLXunAXQ0dvoFO5Azu/FxXwhAuJZasAbzS2UTElLLasg==
X-Received: by 2002:a17:90b:234e:b0:2c9:7219:1db0 with SMTP id 98e67ed59e1d1-2e06ae282d8mr100897a91.3.1727203147035;
        Tue, 24 Sep 2024 11:39:07 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:06 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 07/26] xfs: block reservation too large for minleft allocation
Date: Tue, 24 Sep 2024 11:38:32 -0700
Message-ID: <20240924183851.1901667-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit d5753847b216db0e553e8065aa825cfe497ad143 ]

When we enter xfs_bmbt_alloc_block() without having first allocated
a data extent (i.e. tp->t_firstblock == NULLFSBLOCK) because we
are doing something like unwritten extent conversion, the transaction
block reservation is used as the minleft value.

This works for operations like unwritten extent conversion, but it
assumes that the block reservation is only for a BMBT split. THis is
not always true, and sometimes results in larger than necessary
minleft values being set. We only actually need enough space for a
btree split, something we already handle correctly in
xfs_bmapi_write() via the xfs_bmapi_minleft() calculation.

We should use xfs_bmapi_minleft() in xfs_bmbt_alloc_block() to
calculate the number of blocks a BMBT split on this inode is going to
require, not use the transaction block reservation that contains the
maximum number of blocks this transaction may consume in it...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c       |  2 +-
 fs/xfs/libxfs/xfs_bmap.h       |  2 ++
 fs/xfs/libxfs/xfs_bmap_btree.c | 19 +++++++++----------
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 018837bd72c8..9dc33cdc2ab9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4242,7 +4242,7 @@ xfs_bmapi_convert_unwritten(
 	return 0;
 }
 
-static inline xfs_extlen_t
+xfs_extlen_t
 xfs_bmapi_minleft(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 16db95b11589..08c16e4edc0f 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -220,6 +220,8 @@ int	xfs_bmap_add_extent_unwritten_real(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_iext_cursor *icur, struct xfs_btree_cur **curp,
 		struct xfs_bmbt_irec *new, int *logflagsp);
+xfs_extlen_t xfs_bmapi_minleft(struct xfs_trans *tp, struct xfs_inode *ip,
+		int fork);
 
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP = 1,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index cfa052d40105..18de4fbfef4e 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -213,18 +213,16 @@ xfs_bmbt_alloc_block(
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
 		args.type = XFS_ALLOCTYPE_START_BNO;
+
 		/*
-		 * Make sure there is sufficient room left in the AG to
-		 * complete a full tree split for an extent insert.  If
-		 * we are converting the middle part of an extent then
-		 * we may need space for two tree splits.
-		 *
-		 * We are relying on the caller to make the correct block
-		 * reservation for this operation to succeed.  If the
-		 * reservation amount is insufficient then we may fail a
-		 * block allocation here and corrupt the filesystem.
+		 * If we are coming here from something like unwritten extent
+		 * conversion, there has been no data extent allocation already
+		 * done, so we have to ensure that we attempt to locate the
+		 * entire set of bmbt allocations in the same AG, as
+		 * xfs_bmapi_write() would have reserved.
 		 */
-		args.minleft = args.tp->t_blk_res;
+		args.minleft = xfs_bmapi_minleft(cur->bc_tp, cur->bc_ino.ip,
+						cur->bc_ino.whichfork);
 	} else if (cur->bc_tp->t_flags & XFS_TRANS_LOWMODE) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
@@ -248,6 +246,7 @@ xfs_bmbt_alloc_block(
 		 * successful activate the lowspace algorithm.
 		 */
 		args.fsbno = 0;
+		args.minleft = 0;
 		args.type = XFS_ALLOCTYPE_FIRST_AG;
 		error = xfs_alloc_vextent(&args);
 		if (error)
-- 
2.46.0.792.g87dc391469-goog

