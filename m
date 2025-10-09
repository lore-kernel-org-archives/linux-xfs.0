Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562302D0C90
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 12:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011730; cv=none; b=GtxqgONKS0xZIJO5DhCIKicpiytUXO1fUazAQ/l7a2ZX/+2WH+oJwshTYJpcCinge24vUuFOTeBVoU2JM5rrWtCJ3TZjispW+JnjoeXBIIJYCKB2u5vzYWIYXyEgLnG3TIeogPxL6eKf+TMIBNHqd518E0xldkn2b3+TBfajScs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011730; c=relaxed/simple;
	bh=+gw6rmzj5Or2BkurGszar9GQ4ZRzhkKsecbPO6gGKJs=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bl8uEYKM30o9ayTK6G48TFbSGWBG25cHHdlNjLqP+rYcH15WJPgW9Mq2rK1r7DMGTv6I9GSb0TLhGB6hVqWB489WSSYq+8q5vCzolKvMTDaw8cig7C699bcgueaH5y/NLr9Q8hkF3hw1EjdMZoexqHerTcmP1zwxFS/xW5o5pK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UT2vJggF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UT2vJggF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760011727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ted5tJtKG5QTLyZkAhu4TF20Yg5g1czPl59nwTFdejI=;
	b=UT2vJggFbGMDi0xGAE6uO7tuvj0CGtosBzvz08Rs5TiB2FUkRM+Ez77io8+f2M7PmhcjWU
	EB+QzpdazjRSlTHfPxavFo1aY651e5SHiV/9KPeUH0XtiOlSbqCnUoDknDRWOO4GJWkHsR
	gePWRbqIsv/o1OC6rO989X66GCfFuig=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-dqdmhOiLNYScUvANvmvOag-1; Thu, 09 Oct 2025 08:08:46 -0400
X-MC-Unique: dqdmhOiLNYScUvANvmvOag-1
X-Mimecast-MFC-AGG-ID: dqdmhOiLNYScUvANvmvOag_1760011725
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ee888281c3so1029195f8f.3
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 05:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011725; x=1760616525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ted5tJtKG5QTLyZkAhu4TF20Yg5g1czPl59nwTFdejI=;
        b=fd4hNKuuzJd/U81H6xrap+1PWaTn6uszYaiMNL6QE0ipVixvSUJC+VXZNpHyrXkk/X
         4Kn6lviMCdj2z/m9ESV7Ld8nl5Gkq18j4bisazqsgqPralKIYokHBZZPwniMJJpEbO+F
         inL7LOcGLw4TdXsTz9jxwukhc9qrBVIaSRROjMAWPmhA1VfuQA6qEAJGIVKGANPrkyNx
         Z9T2eThs/3rFnwwyxm/H1fRXowstMs9g2MgppwuCh1MWzP0jkANxdxDyc4a+JRgB/mYq
         TdzP3tAulo8MXlvPVTWeAKWvyBJqZUpMOdM2Ez8cmYzkBpqbRfg0jZhodXbgMVXOUqQD
         YKfw==
X-Gm-Message-State: AOJu0YwFut/RvMrMiT19q8NSuR0xqZjbA9xGD9E1a8z7XwSjKY+ZlTM+
	/xSLt0eR7umgrfpwh8hXo79A113ksQoh4GC8adQY7PgR3sldHnNfSIRFKzjPjQMs7zWXsdnV4Eg
	ghNidQeJlLRVad+QU5EvOb9qIu741lSkb0xBV/O/1R0ztvQaqw8MgGiWUoXT4a6r15PK2nIgbT1
	4V/3CW10lRk2V6nTKjs6v6aJVKpbsYLZNvBYL+RAcCHJ9C
X-Gm-Gg: ASbGncvDbAxHmTKG5183mOYpZRP1IhW9E8rr6hACwO9+hlxwHeyN1pCULQeD7Uv7LUs
	pNp/ZYW4bDzo8oF9H2EbuLH2oV3OeGo7jovNT8URucpWIWpgxUU135FEiR+UmbXNhvVVsiQxGWG
	j3apQ82oWFtRPvKf94Sj0Mc0PyRBHm090gneGXleg1znc74U7OCYjysli9IDTIz0GEpSs8WXj2d
	sw8vxmk7fcYGnRBm5cjCqN0FwUTQwcLo+b/Up6SetAetO/3VwpGZRDfNzDHDXlgeiS8MYIlZSst
	zLan+auWFltMzlhAYH+F+WnCdY4SElbaRGUc3hQ7SbmWRsDL/9o3eJXYL7QMd2VU
X-Received: by 2002:a05:6000:1445:b0:3f1:ee44:8c00 with SMTP id ffacd0b85a97d-42666ab9597mr4839457f8f.10.1760011724362;
        Thu, 09 Oct 2025 05:08:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8NJp9EixzoLi4jS2OnWunmvSnCUIR28fmfE4MSalHh+Gk1VUKLQpHKThonGVMPaQNHi0Eyg==
X-Received: by 2002:a05:6000:1445:b0:3f1:ee44:8c00 with SMTP id ffacd0b85a97d-42666ab9597mr4839422f8f.10.1760011723617;
        Thu, 09 Oct 2025 05:08:43 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46faf112fdbsm45534675e9.8.2025.10.09.05.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:08:43 -0700 (PDT)
From: Fedor Pchelkin <aalbersh@redhat.com>
X-Google-Original-From: Fedor Pchelkin <pchelkin@ispras.ru>
Date: Thu, 9 Oct 2025 14:08:42 +0200
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH v2 2/11] xfs: rename key_diff routines
Message-ID: <rx7m7nfzpmqwhhgl6j2eyccfxc6bymq4cvnw4xl3yzibvqpqnh@ldjontznpth3>
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

Source kernel commit: 82b63ee160016096436aa026a27c8d85d40f3fb1

key_diff routines compare a key value with a cursor value. Make the naming
to be a bit more self-descriptive.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c      | 8 ++++----
 libxfs/xfs_bmap_btree.c       | 4 ++--
 libxfs/xfs_btree.c            | 2 +-
 libxfs/xfs_btree.h            | 9 ++++++---
 libxfs/xfs_ialloc_btree.c     | 6 +++---
 libxfs/xfs_refcount_btree.c   | 4 ++--
 libxfs/xfs_rmap_btree.c       | 6 +++---
 libxfs/xfs_rtrefcount_btree.c | 4 ++--
 libxfs/xfs_rtrmap_btree.c     | 6 +++---
 repair/rcbag_btree.c          | 4 ++--
 10 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 85ce9f728f..6e7af0020b 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -185,7 +185,7 @@
 }
 
 STATIC int64_t
-xfs_bnobt_key_diff(
+xfs_bnobt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -196,7 +196,7 @@
 }
 
 STATIC int64_t
-xfs_cntbt_key_diff(
+xfs_cntbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -436,7 +436,7 @@
 	.init_high_key_from_rec	= xfs_bnobt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
-	.key_diff		= xfs_bnobt_key_diff,
+	.cmp_key_with_cur	= xfs_bnobt_cmp_key_with_cur,
 	.buf_ops		= &xfs_bnobt_buf_ops,
 	.cmp_two_keys		= xfs_bnobt_cmp_two_keys,
 	.keys_inorder		= xfs_bnobt_keys_inorder,
@@ -466,7 +466,7 @@
 	.init_high_key_from_rec	= xfs_cntbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
-	.key_diff		= xfs_cntbt_key_diff,
+	.cmp_key_with_cur	= xfs_cntbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_cntbt_buf_ops,
 	.cmp_two_keys		= xfs_cntbt_cmp_two_keys,
 	.keys_inorder		= xfs_cntbt_keys_inorder,
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index eb3e5d70de..3fc23444f3 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -369,7 +369,7 @@
 }
 
 STATIC int64_t
-xfs_bmbt_key_diff(
+xfs_bmbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -646,7 +646,7 @@
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
 	.init_high_key_from_rec	= xfs_bmbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
-	.key_diff		= xfs_bmbt_key_diff,
+	.cmp_key_with_cur	= xfs_bmbt_cmp_key_with_cur,
 	.cmp_two_keys		= xfs_bmbt_cmp_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
 	.keys_inorder		= xfs_bmbt_keys_inorder,
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 78cc31f61e..15846f0ff6 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -2067,7 +2067,7 @@
 				 *  - greater than, move left
 				 *  - equal, we're done
 				 */
-				diff = cur->bc_ops->key_diff(cur, kp);
+				diff = cur->bc_ops->cmp_key_with_cur(cur, kp);
 				if (diff < 0)
 					low = keyno + 1;
 				else if (diff > 0)
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 1046bbf383..e72a10ba7e 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -171,9 +171,12 @@
 	void	(*init_high_key_from_rec)(union xfs_btree_key *key,
 					  const union xfs_btree_rec *rec);
 
-	/* difference between key value and cursor value */
-	int64_t (*key_diff)(struct xfs_btree_cur *cur,
-			    const union xfs_btree_key *key);
+	/*
+	 * Compare key value and cursor value -- positive if key > cur,
+	 * negative if key < cur, and zero if equal.
+	 */
+	int64_t (*cmp_key_with_cur)(struct xfs_btree_cur *cur,
+				    const union xfs_btree_key *key);
 
 	/*
 	 * Compare key1 and key2 -- positive if key1 > key2, negative if
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index d5f55f7466..d56876c5be 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -265,7 +265,7 @@
 }
 
 STATIC int64_t
-xfs_inobt_key_diff(
+xfs_inobt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -429,7 +429,7 @@
 	.init_high_key_from_rec	= xfs_inobt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
-	.key_diff		= xfs_inobt_key_diff,
+	.cmp_key_with_cur	= xfs_inobt_cmp_key_with_cur,
 	.buf_ops		= &xfs_inobt_buf_ops,
 	.cmp_two_keys		= xfs_inobt_cmp_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
@@ -459,7 +459,7 @@
 	.init_high_key_from_rec	= xfs_inobt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
-	.key_diff		= xfs_inobt_key_diff,
+	.cmp_key_with_cur	= xfs_inobt_cmp_key_with_cur,
 	.buf_ops		= &xfs_finobt_buf_ops,
 	.cmp_two_keys		= xfs_inobt_cmp_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 63417b873c..0924ab7eb7 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -174,7 +174,7 @@
 }
 
 STATIC int64_t
-xfs_refcountbt_key_diff(
+xfs_refcountbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -338,7 +338,7 @@
 	.init_high_key_from_rec	= xfs_refcountbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_refcountbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
-	.key_diff		= xfs_refcountbt_key_diff,
+	.cmp_key_with_cur	= xfs_refcountbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_refcountbt_buf_ops,
 	.cmp_two_keys		= xfs_refcountbt_cmp_two_keys,
 	.keys_inorder		= xfs_refcountbt_keys_inorder,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 0481850e46..ea946616bf 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -243,7 +243,7 @@
 }
 
 STATIC int64_t
-xfs_rmapbt_key_diff(
+xfs_rmapbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -514,7 +514,7 @@
 	.init_high_key_from_rec	= xfs_rmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rmapbt_init_ptr_from_cur,
-	.key_diff		= xfs_rmapbt_key_diff,
+	.cmp_key_with_cur	= xfs_rmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
 	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
@@ -631,7 +631,7 @@
 	.init_high_key_from_rec	= xfs_rmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
-	.key_diff		= xfs_rmapbt_key_diff,
+	.cmp_key_with_cur	= xfs_rmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rmapbt_mem_buf_ops,
 	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 1f563a724c..7a4eec49ca 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -155,7 +155,7 @@
 }
 
 STATIC int64_t
-xfs_rtrefcountbt_key_diff(
+xfs_rtrefcountbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -385,7 +385,7 @@
 	.init_high_key_from_rec	= xfs_rtrefcountbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrefcountbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rtrefcountbt_init_ptr_from_cur,
-	.key_diff		= xfs_rtrefcountbt_key_diff,
+	.cmp_key_with_cur	= xfs_rtrefcountbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rtrefcountbt_buf_ops,
 	.cmp_two_keys		= xfs_rtrefcountbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrefcountbt_keys_inorder,
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 5b3836fccc..59a99bb42c 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -185,7 +185,7 @@
 }
 
 STATIC int64_t
-xfs_rtrmapbt_key_diff(
+xfs_rtrmapbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -510,7 +510,7 @@
 	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rtrmapbt_init_ptr_from_cur,
-	.key_diff		= xfs_rtrmapbt_key_diff,
+	.cmp_key_with_cur	= xfs_rtrmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rtrmapbt_buf_ops,
 	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
@@ -619,7 +619,7 @@
 	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
-	.key_diff		= xfs_rtrmapbt_key_diff,
+	.cmp_key_with_cur	= xfs_rtrmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rtrmapbt_mem_buf_ops,
 	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
diff --git a/repair/rcbag_btree.c b/repair/rcbag_btree.c
index 404b509f64..704e66e9fb 100644
--- a/repair/rcbag_btree.c
+++ b/repair/rcbag_btree.c
@@ -47,7 +47,7 @@
 }
 
 STATIC int64_t
-rcbagbt_key_diff(
+rcbagbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
@@ -220,7 +220,7 @@
 	.init_key_from_rec	= rcbagbt_init_key_from_rec,
 	.init_rec_from_cur	= rcbagbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
-	.key_diff		= rcbagbt_key_diff,
+	.cmp_key_with_cur	= rcbagbt_cmp_key_with_cur,
 	.buf_ops		= &rcbagbt_mem_buf_ops,
 	.cmp_two_keys		= rcbagbt_cmp_two_keys,
 	.keys_inorder		= rcbagbt_keys_inorder,

-- 
- Andrey

