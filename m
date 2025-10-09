Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D033B2D7DF8
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 12:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011722; cv=none; b=js5TArowdv1BDh5bpe7gyRQ+oPt84nJWzHdb6Sbu36Ny7CX8Q8by2TUiMAW2PT4vLl7lVbiP4fHRgHpE8VglnYY6w8qhfP64Yaf61YJiEmuISzMrldKiFHow+X9gXxVX0t+FABYIi4MKM2LfxWgEhfrFPXgO/eFx2fEW9JXAGTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011722; c=relaxed/simple;
	bh=6QfvR/1x2++zO2nwyaYUuQQ29p0quuYdphwpnqxT4DU=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tNdkeXUse8ZVUl1bc1kvEL+NynpeuUylJgIZgJbG28ichJhm96vh/o6Zyf5yF5m0Ogyj42SWoVXu1hivjRaY3uzSttEzIlTiDLJ8yFwVqFIZTLA39NwfVRRGYE3sF2wnJuD4eiHMoUYES8Xi45j5Si9qZ9j1M5vwRkerzJrFzx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=artfXaq6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="artfXaq6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760011719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AQfFS6QlFH1UkykIz1/cUfifIgEfM6RIMn9U76OPlAI=;
	b=artfXaq6tl+ctHU9jMR9tAv7sT9rVNkZHF52w/96fx0uaasQW8e417Y0vH/0ReUmh9TMBe
	iobrGuLbIPA3hQK9+3174uGceLnwetnwz3QCjjQLw6ftCavXn2jIvHJAD4/Ev+WLY+8sXn
	W7AkTnHrAdPVXZaCXkuI0Ome9PvDzKQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-0vnNddh5N7-YYAAXPr3U4Q-1; Thu, 09 Oct 2025 08:08:38 -0400
X-MC-Unique: 0vnNddh5N7-YYAAXPr3U4Q-1
X-Mimecast-MFC-AGG-ID: 0vnNddh5N7-YYAAXPr3U4Q_1760011717
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4256fae4b46so646629f8f.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 05:08:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011716; x=1760616516;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AQfFS6QlFH1UkykIz1/cUfifIgEfM6RIMn9U76OPlAI=;
        b=ZUCc6C4Ud90sEG+EPCJCvSDtRCdGtxWvBmWw+u56DvKas07wVH49/hyo1ZVxhN//sl
         upRdpAcgXFMX96PZ/VMxbEO9xo5ZrbgvcNiNJKKwyIWgyl3UY9mjgvYhWqzDPo+QrB3G
         Mj0cny0obraVmr4pz2Xn9SNhKpBcfXMEbvHeT6GTFUqsvHgx4s2ZuNRgoLiZoyqsw8P6
         ue1rCEik+2Mu9xaqU931K/ilbDXEpHMr2JO9ACNlTLCMq3YoewpStWcK2ShEyElnUJpQ
         MwBtHwT+lzNaj9IoAikEkHECQxriDb602VKGfMhdOG5Zt3an4EwylRGmkROboeyJm/WW
         S8aw==
X-Gm-Message-State: AOJu0YwFwFKzONYeity3jfxp7qudiYpykmj7eemg22kT5EajeLG2M8pG
	JBs5vk3YdMU7DbkacvoctBv3ThXVLLxb2xHT2XyDbdIcH+1eeH7llOnWOMSmVrCXXNTglwVD3Mm
	m20DB8leZokiOyg/lFX7GIUjq/9CMheT6iEh+J5uq+gpJBuiycMR62k+UCnCuVSAhLkd9xtzl9b
	p7RvfCCohWja3mHXFbUvw1QVPNa+RYEctKnpXlw1C2W76i
X-Gm-Gg: ASbGnct/awd/K682ZfBTWPt0T07L2xPtxQZys8FNPCTMYdpH8s68/+08T6I2rvpi7yA
	IynbX6e1ac/i6nBhDLFBu0hlSOdinzovK7WDSV9dHiOZqIF/qWtfqiwX/Tj79Tk5y0MrWk6Jvef
	y9An+GKtujdww8pkywOc4mdxatWHZtuqBiHfe952Mjb0R8scWBf+D/dtYoT/Gfy+6UuVXgXYbK7
	gcmLMXIVpyri5+XBlErjA86hMUD40mcQOvttv0GyNuiUPI7ug2M6dMqi04j92b1zLPikwRmq4Qx
	WojNpjRl+tXtwKcKrmcXcXjVuI2ZIvayF3d0g+PlOC6WW7iQPaHt/fYVmBeo2lfp
X-Received: by 2002:a05:6000:310b:b0:3e7:45c7:828e with SMTP id ffacd0b85a97d-4266e7e1843mr4378447f8f.33.1760011716095;
        Thu, 09 Oct 2025 05:08:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOw5vs6Ma78UpI2Hl1HR7QEROs0AMYrOokhW3ChlnjRjk05JCVdXdWcpvHify8bfVpS8/QOA==
X-Received: by 2002:a05:6000:310b:b0:3e7:45c7:828e with SMTP id ffacd0b85a97d-4266e7e1843mr4378411f8f.33.1760011715237;
        Thu, 09 Oct 2025 05:08:35 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f0846sm35197463f8f.45.2025.10.09.05.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:08:34 -0700 (PDT)
From: Fedor Pchelkin <aalbersh@redhat.com>
X-Google-Original-From: Fedor Pchelkin <pchelkin@ispras.ru>
Date: Thu, 9 Oct 2025 14:08:34 +0200
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH v2 1/11] xfs: rename diff_two_keys routines
Message-ID: <aoknayw2agk6iqtep74g2dqsmn5hafyvbrslxqjgez3qwwi7am@hdfafyw2gicr>
References: <cover.1760011614.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1760011614.patch-series@thinky>

Source kernel commit: edce172444b4f489715a3df2e5d50893e74ce3da

One may think that diff_two_keys routines are used to compute the actual
difference between the arguments but they return a result of a
three-way-comparison of the passed operands. So it looks more appropriate
to denote them as cmp_two_keys.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c      |  8 ++++----
 libxfs/xfs_bmap_btree.c       |  4 ++--
 libxfs/xfs_btree.c            |  2 +-
 libxfs/xfs_btree.h            | 26 +++++++++++++-------------
 libxfs/xfs_ialloc_btree.c     |  6 +++---
 libxfs/xfs_refcount_btree.c   |  4 ++--
 libxfs/xfs_rmap_btree.c       |  6 +++---
 libxfs/xfs_rtrefcount_btree.c |  4 ++--
 libxfs/xfs_rtrmap_btree.c     |  6 +++---
 repair/rcbag_btree.c          |  4 ++--
 10 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 63b8db4ed0..85ce9f728f 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -212,7 +212,7 @@
 }
 
 STATIC int64_t
-xfs_bnobt_diff_two_keys(
+xfs_bnobt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -225,7 +225,7 @@
 }
 
 STATIC int64_t
-xfs_cntbt_diff_two_keys(
+xfs_cntbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -438,7 +438,7 @@
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_bnobt_key_diff,
 	.buf_ops		= &xfs_bnobt_buf_ops,
-	.diff_two_keys		= xfs_bnobt_diff_two_keys,
+	.cmp_two_keys		= xfs_bnobt_cmp_two_keys,
 	.keys_inorder		= xfs_bnobt_keys_inorder,
 	.recs_inorder		= xfs_bnobt_recs_inorder,
 	.keys_contiguous	= xfs_allocbt_keys_contiguous,
@@ -468,7 +468,7 @@
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_cntbt_key_diff,
 	.buf_ops		= &xfs_cntbt_buf_ops,
-	.diff_two_keys		= xfs_cntbt_diff_two_keys,
+	.cmp_two_keys		= xfs_cntbt_cmp_two_keys,
 	.keys_inorder		= xfs_cntbt_keys_inorder,
 	.recs_inorder		= xfs_cntbt_recs_inorder,
 	.keys_contiguous	= NULL, /* not needed right now */
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 40e0cb3016..eb3e5d70de 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -378,7 +378,7 @@
 }
 
 STATIC int64_t
-xfs_bmbt_diff_two_keys(
+xfs_bmbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -647,7 +647,7 @@
 	.init_high_key_from_rec	= xfs_bmbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
-	.diff_two_keys		= xfs_bmbt_diff_two_keys,
+	.cmp_two_keys		= xfs_bmbt_cmp_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index fce215f924..78cc31f61e 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -5055,7 +5055,7 @@
 	int				error;
 
 	ASSERT(cur->bc_ops->init_high_key_from_rec);
-	ASSERT(cur->bc_ops->diff_two_keys);
+	ASSERT(cur->bc_ops->cmp_two_keys);
 
 	/*
 	 * Find the leftmost record.  The btree cursor must be set
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 355b304696..1046bbf383 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -176,15 +176,15 @@
 			    const union xfs_btree_key *key);
 
 	/*
-	 * Difference between key2 and key1 -- positive if key1 > key2,
-	 * negative if key1 < key2, and zero if equal.  If the @mask parameter
-	 * is non NULL, each key field to be used in the comparison must
-	 * contain a nonzero value.
+	 * Compare key1 and key2 -- positive if key1 > key2, negative if
+	 * key1 < key2, and zero if equal.  If the @mask parameter is non NULL,
+	 * each key field to be used in the comparison must contain a nonzero
+	 * value.
 	 */
-	int64_t (*diff_two_keys)(struct xfs_btree_cur *cur,
-				 const union xfs_btree_key *key1,
-				 const union xfs_btree_key *key2,
-				 const union xfs_btree_key *mask);
+	int64_t (*cmp_two_keys)(struct xfs_btree_cur *cur,
+				const union xfs_btree_key *key1,
+				const union xfs_btree_key *key2,
+				const union xfs_btree_key *mask);
 
 	const struct xfs_buf_ops	*buf_ops;
 
@@ -546,7 +546,7 @@
 	const union xfs_btree_key	*key1,
 	const union xfs_btree_key	*key2)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, NULL) < 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, NULL) < 0;
 }
 
 static inline bool
@@ -555,7 +555,7 @@
 	const union xfs_btree_key	*key1,
 	const union xfs_btree_key	*key2)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, NULL) > 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, NULL) > 0;
 }
 
 static inline bool
@@ -564,7 +564,7 @@
 	const union xfs_btree_key	*key1,
 	const union xfs_btree_key	*key2)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, NULL) == 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, NULL) == 0;
 }
 
 static inline bool
@@ -602,7 +602,7 @@
 	const union xfs_btree_key	*key2,
 	const union xfs_btree_key	*mask)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, mask) < 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, mask) < 0;
 }
 
 static inline bool
@@ -612,7 +612,7 @@
 	const union xfs_btree_key	*key2,
 	const union xfs_btree_key	*mask)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2, mask) > 0;
+	return cur->bc_ops->cmp_two_keys(cur, key1, key2, mask) > 0;
 }
 
 static inline bool
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 4cccac145d..d5f55f7466 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -274,7 +274,7 @@
 }
 
 STATIC int64_t
-xfs_inobt_diff_two_keys(
+xfs_inobt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -431,7 +431,7 @@
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_inobt_buf_ops,
-	.diff_two_keys		= xfs_inobt_diff_two_keys,
+	.cmp_two_keys		= xfs_inobt_cmp_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
 	.keys_contiguous	= xfs_inobt_keys_contiguous,
@@ -461,7 +461,7 @@
 	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_finobt_buf_ops,
-	.diff_two_keys		= xfs_inobt_diff_two_keys,
+	.cmp_two_keys		= xfs_inobt_cmp_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
 	.keys_contiguous	= xfs_inobt_keys_contiguous,
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index efb9af710f..63417b873c 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -188,7 +188,7 @@
 }
 
 STATIC int64_t
-xfs_refcountbt_diff_two_keys(
+xfs_refcountbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -340,7 +340,7 @@
 	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
 	.key_diff		= xfs_refcountbt_key_diff,
 	.buf_ops		= &xfs_refcountbt_buf_ops,
-	.diff_two_keys		= xfs_refcountbt_diff_two_keys,
+	.cmp_two_keys		= xfs_refcountbt_cmp_two_keys,
 	.keys_inorder		= xfs_refcountbt_keys_inorder,
 	.recs_inorder		= xfs_refcountbt_recs_inorder,
 	.keys_contiguous	= xfs_refcountbt_keys_contiguous,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index f4da35050d..0481850e46 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -273,7 +273,7 @@
 }
 
 STATIC int64_t
-xfs_rmapbt_diff_two_keys(
+xfs_rmapbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -516,7 +516,7 @@
 	.init_ptr_from_cur	= xfs_rmapbt_init_ptr_from_cur,
 	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
-	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
@@ -633,7 +633,7 @@
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
 	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_mem_buf_ops,
-	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index a532476407..1f563a724c 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -169,7 +169,7 @@
 }
 
 STATIC int64_t
-xfs_rtrefcountbt_diff_two_keys(
+xfs_rtrefcountbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -387,7 +387,7 @@
 	.init_ptr_from_cur	= xfs_rtrefcountbt_init_ptr_from_cur,
 	.key_diff		= xfs_rtrefcountbt_key_diff,
 	.buf_ops		= &xfs_rtrefcountbt_buf_ops,
-	.diff_two_keys		= xfs_rtrefcountbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rtrefcountbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrefcountbt_keys_inorder,
 	.recs_inorder		= xfs_rtrefcountbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrefcountbt_keys_contiguous,
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index d46fb67bb5..5b3836fccc 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -215,7 +215,7 @@
 }
 
 STATIC int64_t
-xfs_rtrmapbt_diff_two_keys(
+xfs_rtrmapbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -512,7 +512,7 @@
 	.init_ptr_from_cur	= xfs_rtrmapbt_init_ptr_from_cur,
 	.key_diff		= xfs_rtrmapbt_key_diff,
 	.buf_ops		= &xfs_rtrmapbt_buf_ops,
-	.diff_two_keys		= xfs_rtrmapbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
 	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
@@ -621,7 +621,7 @@
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
 	.key_diff		= xfs_rtrmapbt_key_diff,
 	.buf_ops		= &xfs_rtrmapbt_mem_buf_ops,
-	.diff_two_keys		= xfs_rtrmapbt_diff_two_keys,
+	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
 	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
diff --git a/repair/rcbag_btree.c b/repair/rcbag_btree.c
index bed7c7a8f6..404b509f64 100644
--- a/repair/rcbag_btree.c
+++ b/repair/rcbag_btree.c
@@ -73,7 +73,7 @@
 }
 
 STATIC int64_t
-rcbagbt_diff_two_keys(
+rcbagbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
@@ -222,7 +222,7 @@
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
 	.key_diff		= rcbagbt_key_diff,
 	.buf_ops		= &rcbagbt_mem_buf_ops,
-	.diff_two_keys		= rcbagbt_diff_two_keys,
+	.cmp_two_keys		= rcbagbt_cmp_two_keys,
 	.keys_inorder		= rcbagbt_keys_inorder,
 	.recs_inorder		= rcbagbt_recs_inorder,
 };

-- 
- Andrey

