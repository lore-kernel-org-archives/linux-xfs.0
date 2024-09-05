Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7177C186608
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560521; cv=none; b=kM7j7/4C+WhcSDF3GkGHBUUTXdJ5+/O8m4t/7MoXdzbOOARMe3hqGRESVEws3q13qQFDZlzSW8kWFHn3/ZCusO4PyVl098++9MMOpzysSsP+KjT7GAK8jMQ3NrLH91rUcXhncWbXQywKg9NU193mohS8o+cHJDL4C1BTCDzE7IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560521; c=relaxed/simple;
	bh=FF6JMZWwQRcRleKVkDA6D0aj94NXEADuuw+p/iYLhGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRwbMw0goQY0rr4E0zmkQ8xgC3IOHclfUXQbVtQ/dQQDa6bnoXR7MvaPICjjqhrQ3/piVoSbC4bs9RUFOS1aMXwRLqIpKBRxAjJrLx2jy1jhzS8vEkhjN/x6OLvAZ8M6403DTbrTNjwa9B5B6d34/meKA74MJAKOymRfGd9t9Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DHgSiQ+2; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DHgSiQ+2"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-715cc93694fso1003042b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560519; x=1726165319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fRCmlKmYyIo2vUDZg14mFO8/fkqfqDMlbQVHLwmhVOA=;
        b=DHgSiQ+2Q4VqmoMdZ7YsUUvXxEcql3zJ1zaZczzN/mBgBhOmJf71v7PGhrpFrV0ozP
         4AzEQ7Cx+irDyCQpxrsbbCx0uPy3NH0QBFUVpGsukn9WyO+UvLh9nOlKHZ87jXlWqe3+
         l/6yVa9B85Ud64FylCNnTuh7cATwlSijxxyamiyX9RjndoWBwhNwC4r2VCKb25Qoaibk
         /W/Xwejy8KPIZ6UVADwKshVxAyMyADxLmQR8bHhRSscCSkTmRGcfAf/kYL+KQXWRsLlS
         47i33Yua+NiHt9kQ9Xxt2h8mlsDV0oGuaqziNCEGSCtT0+mOSPz6TT1/9qAptXckreIO
         YbDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560519; x=1726165319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRCmlKmYyIo2vUDZg14mFO8/fkqfqDMlbQVHLwmhVOA=;
        b=hADAR+IhGp8DBFeAIkFckJlzsy9K1YoBgbxbjVPWLa72iykXIpZv3UMoP/z4qPO2bh
         1vjvHDuNINF7EKeuMUpLlyPKiNnzvNz9IIXPCkByg/GT8H+u75XmQ4bhUCgCDLvOVbHI
         uwCzFcjjJBDtDHBX1tBfxONnkmIKv5EDMh0AfeuNDu7MrLVgjNff/LNVt1TlH0+KFU+A
         SmGevmjpnIxMOumIY9p/k2jZp7NhsLvsuwz3KJfhHKteGi0f/vbFu8gOPpCtDPK+qbkn
         VDF5aogGL5nrsGBj38PKL5mQTX053qNy/eDZnaZ62faNhQQOv2j2+r7jD9py1m6qhUS/
         iCUw==
X-Gm-Message-State: AOJu0YwsIBfmwMea0W991G36TWNkjCa3eTy6WrgtWWdhZaL5l334gFzp
	jkfAeAYP9eFlAIrUZPuUHC4Z4cwcFLoZHwsv6dKd36NTlN/DerE8//mcMRWd
X-Google-Smtp-Source: AGHT+IERZk1yo9NjR+kJQ3nTcxhFXAsOZPY5JMw2+Q4xDoial0SADCBw5sjzUL4UmgtG41PHscuF5g==
X-Received: by 2002:a17:902:e804:b0:1fc:568d:5f05 with SMTP id d9443c01a7336-205472c61acmr214965895ad.8.1725560518674;
        Thu, 05 Sep 2024 11:21:58 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:21:58 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 07/26] xfs: block reservation too large for minleft allocation
Date: Thu,  5 Sep 2024 11:21:24 -0700
Message-ID: <20240905182144.2691920-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
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
2.46.0.598.g6f2099f65c-goog

