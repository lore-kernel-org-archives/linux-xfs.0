Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AFF2DFA3A
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 12:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011762; cv=none; b=oPGJqWZ0p9anW8Tl2QAZkAeQDGIlYlOSC3vwEMGbv+SuwkD7dM4l76RIFou7WDCDnDV3IKcOIYGgYgL7k/iNcnCwjEcWq4ZVL+ZpDGGH2lVw7Tht1h8QMQIHNnQsK4JAszxj1cMOAMjthsntBUpeWEtHcwJ0Y8f9y8tntuqfLxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011762; c=relaxed/simple;
	bh=nf4KHkYiUMfSby34isZxVszjEGyBhFRffV3bTd55wKE=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQuq60UQMt5Cehk8toIP3YdiPrHVOfam0jcgEjIJ533QOEmhHgSBt84R57adx1lrVGqZD8hYWCQAaIo/9fep0APBThgnDNPFiQChCvRmyM3vzWZwCqek+jLgmAjx8MZqJeKYbk7Mwpt21/1NKBYckrM0uCJxLC7l72G06nh2ifY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UDkoIbna; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UDkoIbna"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760011759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bZN4ztUTiT5ZmZGM7BBjCS8ev5mu0tO1xQHf+8Lw8Dg=;
	b=UDkoIbnalAR/OaM2g528iPBvL6dPuYmnaN5l6mveR3pRufLKs5JbVQuiYGqubu3kbcMJWq
	1Gin/WiXT5rMkGy9FpoDh7vOk34zFW02PJby/HYJXv+G+PtIa3bCqZAux85+BNzAwaPe9+
	HVl/YoRLgBzrUfsBR2uoaEvi/n+7nGY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-LPDN1gYLNXi8cp1T92DTXw-1; Thu, 09 Oct 2025 08:09:18 -0400
X-MC-Unique: LPDN1gYLNXi8cp1T92DTXw-1
X-Mimecast-MFC-AGG-ID: LPDN1gYLNXi8cp1T92DTXw_1760011757
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e7a2c3773so10120645e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 05:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011757; x=1760616557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bZN4ztUTiT5ZmZGM7BBjCS8ev5mu0tO1xQHf+8Lw8Dg=;
        b=QjjI2XKryBMh+rFyarBdXEMiqUlGTLojiiHFM3CGN8IhIi5P32zebRmRS4YNIOGYgA
         uirIFA729HTk40e142+1A+j/cUIntPTsy9CwHheZ+rIlwGv6q3XAqMv73mIQ7fG0kOW7
         WLLX4RSyT6m+wNBmgoGErD6oCWrWswaUR4YwnvbvY98Per5oFFqgP4vp+eIT1O0C8pR+
         Y7/GFI9fZPOorOLsV7+lYrOstSLv5FbHqRjSuZfszp4P12eShATqR94c2ixWc8RcErJE
         4HT74Z1IZFRL1q0aLlr7ibRzRCnJCoCnuSkOqdezRwSyBB0AK1PsGGjRc6rKICz6OnYM
         M7Og==
X-Gm-Message-State: AOJu0YwRFcAIRiLAx4dlpAaL7nFk+rGSyMncGw/8iUC/97YzsphdUess
	sRucGiKePhOfClCqT4i8pwpUg7pPdq6YETOHI719GWO3E1XanTXnrI2UNFexAwVaNDHoKSMYHd9
	ZTj1aokd1DjD0KtiburmWtTrPWgJVY8MfSkn78MjZp2IMBD4AEvePrpX8/XrQK0Rdm86oq63unF
	b9O3VTt4uZjkkpLFGDSY1LNLWE5D9RAUlatKDNdKX88YXg
X-Gm-Gg: ASbGncuiWOEbauUn16qHy4ce+YASfJbD1E3ibxMj/ha7oWytcdujNp6COfo4Hua1zVZ
	Cq8WvfHKaKG0h9xYFAcbOXiEFmAIxHomc7qxsfVaiDSr6FM1QfSaynionGm/T00UN6NS/3fB2YY
	TETwVTYI3UdVtGyNcwJCmy5ZRstRRVX5lY5UE3muisOTys8cMqbsGgA19M3KtM5PIGQ/6qekOyX
	jI8GOuoKkGCVifafWyceLeCM6IrIM4YhsJ3q/S5Pn2sl7EY3QIqlSh3hN0p8C2plcT4WSjAl+bN
	5dCtVKF4RbmlpQyG9OjyKGaySwRFpQ+enRk5HBaWwtbYaPRg7JNzKyfteZGVRjz7
X-Received: by 2002:a05:600d:4270:b0:46f:b42e:e38f with SMTP id 5b1f17b1804b1-46fb42ee4a2mr1097105e9.19.1760011756619;
        Thu, 09 Oct 2025 05:09:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYrz54NqbAT/MU8/COK/K4j8yBQ+hyGkNkXZvOp5MrDckyItfSA7Eu6CHYHL3DTQx8dceeIw==
X-Received: by 2002:a05:600d:4270:b0:46f:b42e:e38f with SMTP id 5b1f17b1804b1-46fb42ee4a2mr1096675e9.19.1760011755904;
        Thu, 09 Oct 2025 05:09:15 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9c0e35dsm83438835e9.8.2025.10.09.05.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:09:15 -0700 (PDT)
From: Fedor Pchelkin <aalbersh@redhat.com>
X-Google-Original-From: Fedor Pchelkin <pchelkin@ispras.ru>
Date: Thu, 9 Oct 2025 14:09:15 +0200
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH v2 3/11] xfs: refactor cmp_two_keys routines to take
 advantage of cmp_int()
Message-ID: <alfj4m74agon7kpvxlnwlmqkoqojzbvpnwqhisoz6iqwhkvw7u@ddhf3ee7odaz>
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

Source kernel commit: 3b583adf55c649d5ba37bcd1ca87644b0bc10b86

The net value of these functions is to determine the result of a
three-way-comparison between operands of the same type.

Simplify the code using cmp_int() to eliminate potential errors with
opencoded casts and subtractions. This also means we can change the return
value type of cmp_two_keys routines from int64_t to int and make the
interface a bit clearer.

Found by Linux Verification Center (linuxtesting.org).

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 include/platform_defs.h       |  2 ++
 libxfs/xfs_alloc_btree.c      | 21 ++++++++-------------
 libxfs/xfs_bmap_btree.c       | 18 +++---------------
 libxfs/xfs_btree.h            |  2 +-
 libxfs/xfs_ialloc_btree.c     |  6 +++---
 libxfs/xfs_refcount_btree.c   |  6 +++---
 libxfs/xfs_rmap_btree.c       | 29 ++++++++++++-----------------
 libxfs/xfs_rtrefcount_btree.c |  6 +++---
 libxfs/xfs_rtrmap_btree.c     | 29 ++++++++++++-----------------
 repair/rcbag_btree.c          | 28 +++++++++++-----------------
 scrub/inodes.c                |  2 --
 11 files changed, 58 insertions(+), 91 deletions(-)

diff --git a/include/platform_defs.h b/include/platform_defs.h
index 74a00583eb..fa66551d99 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -294,4 +294,6 @@
 	__a > __b ? (__a - __b) : (__b - __a);	\
 })
 
+#define cmp_int(l, r)		((l > r) - (l < r))
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 6e7af0020b..c3c69a9de3 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -211,7 +211,7 @@
 	return (int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
 }
 
-STATIC int64_t
+STATIC int
 xfs_bnobt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -220,29 +220,24 @@
 {
 	ASSERT(!mask || mask->alloc.ar_startblock);
 
-	return (int64_t)be32_to_cpu(k1->alloc.ar_startblock) -
-			be32_to_cpu(k2->alloc.ar_startblock);
+	return cmp_int(be32_to_cpu(k1->alloc.ar_startblock),
+		       be32_to_cpu(k2->alloc.ar_startblock));
 }
 
-STATIC int64_t
+STATIC int
 xfs_cntbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
 	const union xfs_btree_key	*mask)
 {
-	int64_t				diff;
-
 	ASSERT(!mask || (mask->alloc.ar_blockcount &&
 			 mask->alloc.ar_startblock));
 
-	diff =  be32_to_cpu(k1->alloc.ar_blockcount) -
-		be32_to_cpu(k2->alloc.ar_blockcount);
-	if (diff)
-		return diff;
-
-	return  be32_to_cpu(k1->alloc.ar_startblock) -
-		be32_to_cpu(k2->alloc.ar_startblock);
+	return cmp_int(be32_to_cpu(k1->alloc.ar_blockcount),
+		       be32_to_cpu(k2->alloc.ar_blockcount)) ?:
+	       cmp_int(be32_to_cpu(k1->alloc.ar_startblock),
+		       be32_to_cpu(k2->alloc.ar_startblock));
 }
 
 static xfs_failaddr_t
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 3fc23444f3..19eab66fad 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -377,29 +377,17 @@
 				      cur->bc_rec.b.br_startoff;
 }
 
-STATIC int64_t
+STATIC int
 xfs_bmbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
 	const union xfs_btree_key	*k2,
 	const union xfs_btree_key	*mask)
 {
-	uint64_t			a = be64_to_cpu(k1->bmbt.br_startoff);
-	uint64_t			b = be64_to_cpu(k2->bmbt.br_startoff);
-
 	ASSERT(!mask || mask->bmbt.br_startoff);
 
-	/*
-	 * Note: This routine previously casted a and b to int64 and subtracted
-	 * them to generate a result.  This lead to problems if b was the
-	 * "maximum" key value (all ones) being signed incorrectly, hence this
-	 * somewhat less efficient version.
-	 */
-	if (a > b)
-		return 1;
-	if (b > a)
-		return -1;
-	return 0;
+	return cmp_int(be64_to_cpu(k1->bmbt.br_startoff),
+		       be64_to_cpu(k2->bmbt.br_startoff));
 }
 
 static xfs_failaddr_t
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index e72a10ba7e..fecd9f0b93 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -184,7 +184,7 @@
 	 * each key field to be used in the comparison must contain a nonzero
 	 * value.
 	 */
-	int64_t (*cmp_two_keys)(struct xfs_btree_cur *cur,
+	int	(*cmp_two_keys)(struct xfs_btree_cur *cur,
 				const union xfs_btree_key *key1,
 				const union xfs_btree_key *key2,
 				const union xfs_btree_key *mask);
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index d56876c5be..973ae62d39 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -273,7 +273,7 @@
 			  cur->bc_rec.i.ir_startino;
 }
 
-STATIC int64_t
+STATIC int
 xfs_inobt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -282,8 +282,8 @@
 {
 	ASSERT(!mask || mask->inobt.ir_startino);
 
-	return (int64_t)be32_to_cpu(k1->inobt.ir_startino) -
-			be32_to_cpu(k2->inobt.ir_startino);
+	return cmp_int(be32_to_cpu(k1->inobt.ir_startino),
+		       be32_to_cpu(k2->inobt.ir_startino));
 }
 
 static xfs_failaddr_t
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 0924ab7eb7..668c788dca 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -187,7 +187,7 @@
 	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
 }
 
-STATIC int64_t
+STATIC int
 xfs_refcountbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -196,8 +196,8 @@
 {
 	ASSERT(!mask || mask->refc.rc_startblock);
 
-	return (int64_t)be32_to_cpu(k1->refc.rc_startblock) -
-			be32_to_cpu(k2->refc.rc_startblock);
+	return cmp_int(be32_to_cpu(k1->refc.rc_startblock),
+		       be32_to_cpu(k2->refc.rc_startblock));
 }
 
 STATIC xfs_failaddr_t
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index ea946616bf..ab207b9cc2 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -272,7 +272,7 @@
 	return 0;
 }
 
-STATIC int64_t
+STATIC int
 xfs_rmapbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -281,36 +281,31 @@
 {
 	const struct xfs_rmap_key	*kp1 = &k1->rmap;
 	const struct xfs_rmap_key	*kp2 = &k2->rmap;
-	int64_t				d;
-	__u64				x, y;
+	int				d;
 
 	/* Doesn't make sense to mask off the physical space part */
 	ASSERT(!mask || mask->rmap.rm_startblock);
 
-	d = (int64_t)be32_to_cpu(kp1->rm_startblock) -
-		     be32_to_cpu(kp2->rm_startblock);
+	d = cmp_int(be32_to_cpu(kp1->rm_startblock),
+		    be32_to_cpu(kp2->rm_startblock));
 	if (d)
 		return d;
 
 	if (!mask || mask->rmap.rm_owner) {
-		x = be64_to_cpu(kp1->rm_owner);
-		y = be64_to_cpu(kp2->rm_owner);
-		if (x > y)
-			return 1;
-		else if (y > x)
-			return -1;
+		d = cmp_int(be64_to_cpu(kp1->rm_owner),
+			    be64_to_cpu(kp2->rm_owner));
+		if (d)
+			return d;
 	}
 
 	if (!mask || mask->rmap.rm_offset) {
 		/* Doesn't make sense to allow offset but not owner */
 		ASSERT(!mask || mask->rmap.rm_owner);
 
-		x = offset_keymask(be64_to_cpu(kp1->rm_offset));
-		y = offset_keymask(be64_to_cpu(kp2->rm_offset));
-		if (x > y)
-			return 1;
-		else if (y > x)
-			return -1;
+		d = cmp_int(offset_keymask(be64_to_cpu(kp1->rm_offset)),
+			    offset_keymask(be64_to_cpu(kp2->rm_offset)));
+		if (d)
+			return d;
 	}
 
 	return 0;
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 7a4eec49ca..7fbbc6387c 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -168,7 +168,7 @@
 	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
 }
 
-STATIC int64_t
+STATIC int
 xfs_rtrefcountbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -177,8 +177,8 @@
 {
 	ASSERT(!mask || mask->refc.rc_startblock);
 
-	return (int64_t)be32_to_cpu(k1->refc.rc_startblock) -
-			be32_to_cpu(k2->refc.rc_startblock);
+	return cmp_int(be32_to_cpu(k1->refc.rc_startblock),
+		       be32_to_cpu(k2->refc.rc_startblock));
 }
 
 static xfs_failaddr_t
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 59a99bb42c..0492cd55d5 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -214,7 +214,7 @@
 	return 0;
 }
 
-STATIC int64_t
+STATIC int
 xfs_rtrmapbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -223,36 +223,31 @@
 {
 	const struct xfs_rmap_key	*kp1 = &k1->rmap;
 	const struct xfs_rmap_key	*kp2 = &k2->rmap;
-	int64_t				d;
-	__u64				x, y;
+	int				d;
 
 	/* Doesn't make sense to mask off the physical space part */
 	ASSERT(!mask || mask->rmap.rm_startblock);
 
-	d = (int64_t)be32_to_cpu(kp1->rm_startblock) -
-		     be32_to_cpu(kp2->rm_startblock);
+	d = cmp_int(be32_to_cpu(kp1->rm_startblock),
+		    be32_to_cpu(kp2->rm_startblock));
 	if (d)
 		return d;
 
 	if (!mask || mask->rmap.rm_owner) {
-		x = be64_to_cpu(kp1->rm_owner);
-		y = be64_to_cpu(kp2->rm_owner);
-		if (x > y)
-			return 1;
-		else if (y > x)
-			return -1;
+		d = cmp_int(be64_to_cpu(kp1->rm_owner),
+			    be64_to_cpu(kp2->rm_owner));
+		if (d)
+			return d;
 	}
 
 	if (!mask || mask->rmap.rm_offset) {
 		/* Doesn't make sense to allow offset but not owner */
 		ASSERT(!mask || mask->rmap.rm_owner);
 
-		x = offset_keymask(be64_to_cpu(kp1->rm_offset));
-		y = offset_keymask(be64_to_cpu(kp2->rm_offset));
-		if (x > y)
-			return 1;
-		else if (y > x)
-			return -1;
+		d = cmp_int(offset_keymask(be64_to_cpu(kp1->rm_offset)),
+			    offset_keymask(be64_to_cpu(kp2->rm_offset)));
+		if (d)
+			return d;
 	}
 
 	return 0;
diff --git a/repair/rcbag_btree.c b/repair/rcbag_btree.c
index 704e66e9fb..8a50bd03a5 100644
--- a/repair/rcbag_btree.c
+++ b/repair/rcbag_btree.c
@@ -72,7 +72,7 @@
 	return 0;
 }
 
-STATIC int64_t
+STATIC int
 rcbagbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -81,25 +81,19 @@
 {
 	const struct rcbag_key		*kp1 = (const struct rcbag_key *)k1;
 	const struct rcbag_key		*kp2 = (const struct rcbag_key *)k2;
+	int				d;
 
 	ASSERT(mask == NULL);
 
-	if (kp1->rbg_startblock > kp2->rbg_startblock)
-		return 1;
-	if (kp1->rbg_startblock < kp2->rbg_startblock)
-		return -1;
-
-	if (kp1->rbg_blockcount > kp2->rbg_blockcount)
-		return 1;
-	if (kp1->rbg_blockcount < kp2->rbg_blockcount)
-		return -1;
-
-	if (kp1->rbg_ino > kp2->rbg_ino)
-		return 1;
-	if (kp1->rbg_ino < kp2->rbg_ino)
-		return -1;
-
-	return 0;
+	d = cmp_int(kp1->rbg_startblock, kp2->rbg_startblock);
+	if (d)
+		return d;
+
+	d = cmp_int(kp1->rbg_blockcount, kp2->rbg_blockcount);
+	if (d)
+		return d;
+
+	return cmp_int(kp1->rbg_ino, kp2->rbg_ino);
 }
 
 STATIC int
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 2f3c87be79..4ed7cd9963 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -197,8 +197,6 @@
 	return seen_mask;
 }
 
-#define cmp_int(l, r)		((l > r) - (l < r))
-
 /* Compare two bulkstat records by inumber. */
 static int
 compare_bstat(

-- 
- Andrey

