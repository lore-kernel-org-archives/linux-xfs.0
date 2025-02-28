Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B6A1FE44A
	for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2025 08:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740731194; cv=none; b=CEGVyPfSyPo/Ma/b/YfRYUxkJstqHm6W2j/gsTPiYW81ikEoh3kNN3vzXfJgc4SJtk8qJaZPrS2ooFUgy7vBwupeOvYDEZ0XJVD7cX5sEB5zHrhdp4eCbJXVmbpx9JWZu9iVSKzZBwfaT+Chvw3s150Nhk48JJgICHa2H/KOAB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740731194; c=relaxed/simple;
	bh=R5za6kfM/B0Mc3xaexY40aSAfaYwHyaIJw0s6MCpdME=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IV6iFuYJ95ceXlDFu7m5Sz3yol4ZJ4Yjun30AaJ0mpd4jtnMdiYvSCPuVw4WITG8csOiDCfmZehZkM+RSYvCI6wdYShvhV5BYfc9JJdgEMFf59JH8HlMPqu+4bIRhsKILsn5t0oZp8qmJvFQWTvErY0eyQs6cqR5lbOc+JfzizQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dLKPebiG; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dLKPebiG"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2fea78afde5so2186889a91.2
        for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2025 00:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740731192; x=1741335992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TVk9ZrMKSnWNxSEv371Q6Yx8mOiAT98O5YL/nN8Mep4=;
        b=dLKPebiGDQVm30Lxkb8UxsGmSa83hR+FWeSXwdwsD7BnIbMZaaeuJNhARQslj3Rl2z
         oP74KkU460+B2lG2KXcckle7G4kyDK5DrzLe85GjDdCROOndM/XyK90GrqMI5hO6kvUT
         0PP57oAB1Drgy46M0FzrzHneqEzH9LZg3mDTdwmnUF2mncLcJsYJO4csIF+WpnO2xG7W
         bgAhJUceRh+aCq9j6pPfdRrnDjKf1JhJUY4UexrCii5XBr4wehg1g2yCar53N4Azcunh
         l8Dx+qs+MzK0uTYuF/uPBrJX4Oy/+OAhNPEkyuZBtlwlmvU30Jjy4Ny9Ub/HTggxcPoU
         HfoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740731192; x=1741335992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TVk9ZrMKSnWNxSEv371Q6Yx8mOiAT98O5YL/nN8Mep4=;
        b=woiZS0Yeg+xhr3JwgYHdAiCewhOSDogH6ywMkhfCpUfJu+d5WvHUJ45huPSdseFcGM
         sTPtZ7uKKWvU4u9ybOvWxnpKU0chH6uD6bYjGc27+9Q/iQnmlw1jlxaAEsLwMRW1/FMx
         OWRMwTK6Zdah2E736VOcrLflrN5B44B5W7I28zk/6au71uKvasm5g/PEwX677ReJglUS
         3Zl7GYAtmRdTdvkeuAszI9oU9LP0dWy6ZbTlXc4llqv2lzL+z8QEkS8xgASo4UOKDHJ5
         ra6ubAL5J0+ZgTFnKSVFEs63LtH8eXm5VroWMCO5DU3/xmZkytjCY4CICi1E1EgfaOVU
         wxTw==
X-Gm-Message-State: AOJu0Yxg1m+i0HPBAxbzY12jH61ZjRoVXNQ08d6twtsco4C08BzP4pkM
	PVgonWmjX0KhDRUE+RZkX/X356fx7aw8+n42d4sCSVCjaOt3/kGaaSEhkb20
X-Gm-Gg: ASbGnct/WIGtVheUjCl6X3UJFO8gj5HLn87ArvcnFVIaDSfC9QzpNsin5Nr6SUu/7a9
	mbn2orIJw5KmONyLFPonf0wcaV8nSb6Ei9nRvCDZm5IhmudcXlUo2fJQKfTLQLuLchH/Mq1q6VJ
	PdJrbEIr2GRFtVCi1r3O/qoNM+9uNA9t7uOsVHPphzwd7plNcV1ToxArOcPVDLZsaetuduRTqaq
	cg76X3iGDv7F3A4Pf1lfyj97vO8hV3tcECL0KqKE7hpc59hl38RWC/PI8OGniOpez5Bb+/V/wy5
	ajb79QN3fmcyANJ/pLM2zYdhbom2dw==
X-Google-Smtp-Source: AGHT+IGw6VnXtab9C8H+CAvGEDy5XvfN6iQfiDS/VjNs63Lh32c9LW6SWBepJkUQYREOwxoJ2SzlUw==
X-Received: by 2002:a17:90b:1e4f:b0:2fe:a545:4c84 with SMTP id 98e67ed59e1d1-2febac1253amr3434856a91.34.1740731191829;
        Fri, 28 Feb 2025 00:26:31 -0800 (PST)
Received: from localhost ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fe8284f091sm5287192a91.45.2025.02.28.00.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 00:26:31 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH 1/2] xfs: remove unnecessary checks for __GFP_NOFAIL allocation.
Date: Fri, 28 Feb 2025 16:26:21 +0800
Message-Id: <20250228082622.2638686-2-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250228082622.2638686-1-sunjunchao2870@gmail.com>
References: <20250228082622.2638686-1-sunjunchao2870@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The __GFP_NOFAIL flag ensures that allocation will not fail.
So remove the unnecessary checks.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 4 ----
 fs/xfs/libxfs/xfs_dir2.c     | 8 --------
 fs/xfs/xfs_buf.c             | 4 ----
 fs/xfs/xfs_mru_cache.c       | 6 ------
 fs/xfs/xfs_super.c           | 2 --
 5 files changed, 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 17d9e6154f19..d4c6ad6be5e1 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2718,10 +2718,6 @@ xfs_dabuf_map(
 	if (nirecs > 1) {
 		map = kzalloc(nirecs * sizeof(struct xfs_buf_map),
 				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
-		if (!map) {
-			error = -ENOMEM;
-			goto out_free_irecs;
-		}
 		*mapp = map;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 1775abcfa04d..7d837510dc3b 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -249,8 +249,6 @@ xfs_dir_init(
 		return error;
 
 	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
-	if (!args)
-		return -ENOMEM;
 
 	args->geo = dp->i_mount->m_dir_geo;
 	args->dp = dp;
@@ -342,8 +340,6 @@ xfs_dir_createname(
 	}
 
 	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
-	if (!args)
-		return -ENOMEM;
 
 	args->geo = dp->i_mount->m_dir_geo;
 	args->name = name->name;
@@ -504,8 +500,6 @@ xfs_dir_removename(
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
 	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
-	if (!args)
-		return -ENOMEM;
 
 	args->geo = dp->i_mount->m_dir_geo;
 	args->name = name->name;
@@ -564,8 +558,6 @@ xfs_dir_replace(
 		return rval;
 
 	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
-	if (!args)
-		return -ENOMEM;
 
 	args->geo = dp->i_mount->m_dir_geo;
 	args->name = name->name;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 15bb790359f8..4b53dde32689 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -182,8 +182,6 @@ xfs_buf_get_maps(
 
 	bp->b_maps = kzalloc(map_count * sizeof(struct xfs_buf_map),
 			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
-	if (!bp->b_maps)
-		return -ENOMEM;
 	return 0;
 }
 
@@ -326,8 +324,6 @@ xfs_buf_alloc_kmem(
 		gfp_mask |= __GFP_ZERO;
 
 	bp->b_addr = kmalloc(size, gfp_mask);
-	if (!bp->b_addr)
-		return -ENOMEM;
 
 	if (((unsigned long)(bp->b_addr + size - 1) & PAGE_MASK) !=
 	    ((unsigned long)bp->b_addr & PAGE_MASK)) {
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index d0f5b403bdbe..0d08d6b5e5be 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -333,17 +333,11 @@ xfs_mru_cache_create(
 		return -EINVAL;
 
 	mru = kzalloc(sizeof(*mru), GFP_KERNEL | __GFP_NOFAIL);
-	if (!mru)
-		return -ENOMEM;
 
 	/* An extra list is needed to avoid reaping up to a grp_time early. */
 	mru->grp_count = grp_count + 1;
 	mru->lists = kzalloc(mru->grp_count * sizeof(*mru->lists),
 				GFP_KERNEL | __GFP_NOFAIL);
-	if (!mru->lists) {
-		err = -ENOMEM;
-		goto exit;
-	}
 
 	for (grp = 0; grp < mru->grp_count; grp++)
 		INIT_LIST_HEAD(mru->lists + grp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0055066fb1d9..59a600d8de7c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2075,8 +2075,6 @@ xfs_init_fs_context(
 	int			i;
 
 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
-	if (!mp)
-		return -ENOMEM;
 
 	spin_lock_init(&mp->m_sb_lock);
 	for (i = 0; i < XG_TYPE_MAX; i++)
-- 
2.39.5

