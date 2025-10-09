Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96262D1907
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 12:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011769; cv=none; b=IU3od9iM5aZ+83woztKF19sToZ9p1zjmvl1VUV2GiBmdPNlTpsUQhU81W3ra3gSdlttZxM7PjOTAhvG0yJh0597Ysdw8DvKnhWT4gUM1WcgvuGxDTRFR4VfHoGNJy66IRA7yV4BO8Nf6q14/DrFMZuKKY1F0yOUX2vADaCzlIzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011769; c=relaxed/simple;
	bh=Oi8wEY/Ph/adY+YzAcEd7kEnTmOepRfznGVxzmX0tRI=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U5kIxYkgzVmexFqjjGWGx/Ed4Ru1xwPGSS3Lo6HISctXz4TtDByMmJRPdWusbIIDdtBth+1rUk1/rl51agmJ/x+wxDDfn3JfsxkE+VK39L7bz8PwgWFQ7tau19JZelxwDY0pz1ly9vHggfkNDNOWlR03l+VD52HzXnJGTtXFO2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=da4PH082; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="da4PH082"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760011766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NBHxwu59Q384NgISE5+bQs+TVFU4ZgJtgbzpNhS4o4s=;
	b=da4PH082GYPzIz42mI1emXvFQ0B5F+EcGbOOURWavSqgamgz9+oDUWdof79NszbdMMsI6d
	U9EzcU71mUoETPqX66G8kezlqbXzCQcj8Sz5ybMWtSZM1DFPZSOCLcBJYo7zIVQK0KdAnu
	M6YXtbuFRyYGb775/S34EwJWUw3nF1U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-jirCtdRbOemJRbHxyX0HuA-1; Thu, 09 Oct 2025 08:09:25 -0400
X-MC-Unique: jirCtdRbOemJRbHxyX0HuA-1
X-Mimecast-MFC-AGG-ID: jirCtdRbOemJRbHxyX0HuA_1760011764
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46fa88b5760so2988045e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 05:09:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011764; x=1760616564;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NBHxwu59Q384NgISE5+bQs+TVFU4ZgJtgbzpNhS4o4s=;
        b=Vq6uDrvQEZq3h6amxwdwhuZyUfz+WCi98G5CMk1cl48BBLK+alnxYBU4FAoFxSna0u
         BLgLX2x0r2e8BI/Y9IU/OnR57oSljV25qZCAaH6jRfIw7vAW7nuqdPyVsNQhXFPmtBah
         1H5CfqWukX8eItFvKnuBUM+g9zwXPoRa9ieiMyR+tnilyvmXGnoZVvk17WllaDTyvuUC
         1FJ4SDPzxyDM+FlI4wUKRjkVj5YpPmMJoVK5H7gYTGTTX2Q8eL5jbO/fNkWYwLyprVgX
         2T+1QgRYFP/jG7YkQWLL83kCdm0k5DIAYXHLxi8Wz2bCaVAXcj4BS0ot2kJePyVEYSU0
         rh+A==
X-Gm-Message-State: AOJu0YyzPyZZwEwcuWMqV/4QuKXtJUoelEdVevo9ys6G5lW9YEgWaAgZ
	txZMzc9fSJsXUoLEvtbCEf2WdrvG0lx4P7WRwOWP2whhPX++mqppPrfAQk7QWyqYQ/H/VhpSbXj
	8jZMEXLBA78/7qBMWMBrhaalvJX/76o0k5bHNJrFgBj/aEnPX4GWWQZftcBb5WacSDdhQOVhk63
	SeoP2iG51ASApkVJOx5WyI/zDRHtPc0jwYMeNa8qGnJkIS
X-Gm-Gg: ASbGncsiNvd8zGFeffMMUiyZkMjmm/AzzBia7WyqhKUP8R4S344wRT14+lrEgWsAkOU
	W6+gK0xHcJwrABYZWHK8/VqpbsXQ+Dn6H+foUyW+lPhaj1iA7fHYmEotn6u2oeX4h5i3kVuj18N
	LPhr8o1RlcM4n4j2FcMfXEzYWBifr2IuyT8v9R8xUs1S/N6BdTz3csPwIaMltXL6rjkvoZlyXD1
	buALZzG5Figso3hHVb2oZ+xQMBLnMxe/plaHZkI5Zog7uEiYnc112VTH0Z4HMj1o/uogGJaNkt7
	EQJIfR8yCWxx8gu57VmZiEB3og3ynWUx1huvqoJ2bU/V9pBiVAa4EuGqcd8z8G27
X-Received: by 2002:a05:600c:3d8b:b0:45b:7ce0:fb98 with SMTP id 5b1f17b1804b1-46fa9a9456fmr52700135e9.5.1760011763944;
        Thu, 09 Oct 2025 05:09:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzjJby1p7e4HKk2GTTEWVB9h5KdNaKsUgw2he05SzpEWzQojE/rj79ouii3GB0fKuXDl2Jug==
X-Received: by 2002:a05:600c:3d8b:b0:45b:7ce0:fb98 with SMTP id 5b1f17b1804b1-46fa9a9456fmr52699695e9.5.1760011763229;
        Thu, 09 Oct 2025 05:09:23 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9c162f0sm83845035e9.9.2025.10.09.05.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:09:22 -0700 (PDT)
From: Fedor Pchelkin <aalbersh@redhat.com>
X-Google-Original-From: Fedor Pchelkin <pchelkin@ispras.ru>
Date: Thu, 9 Oct 2025 14:09:22 +0200
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH v2 4/11] xfs: refactor cmp_key_with_cur routines to take
 advantage of cmp_int()
Message-ID: <cpkj5onrkm3x4vgevwnfaea2sbirpolhwp63bhrx5p3daxtl7e@zgviw4fwa4rt>
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

Source kernel commit: 734b871d6cf7d4f815bb1eff8c808289079701c2

The net value of these functions is to determine the result of a
three-way-comparison between operands of the same type.

Simplify the code using cmp_int() to eliminate potential errors with
opencoded casts and subtractions. This also means we can change the return
value type of cmp_key_with_cur routines from int64_t to int and make the
interface a bit clearer.

Found by Linux Verification Center (linuxtesting.org).

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_alloc_btree.c      | 17 +++++++----------
 libxfs/xfs_bmap_btree.c       |  6 +++---
 libxfs/xfs_btree.h            |  2 +-
 libxfs/xfs_ialloc_btree.c     |  6 +++---
 libxfs/xfs_refcount_btree.c   |  4 ++--
 libxfs/xfs_rmap_btree.c       | 28 ++++++----------------------
 libxfs/xfs_rtrefcount_btree.c |  4 ++--
 libxfs/xfs_rtrmap_btree.c     | 28 ++++++----------------------
 repair/rcbag_btree.c          | 30 ++++++++++++------------------
 9 files changed, 42 insertions(+), 83 deletions(-)

diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index c3c69a9de3..1604e1bb62 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -184,7 +184,7 @@
 		ptr->s = agf->agf_cnt_root;
 }
 
-STATIC int64_t
+STATIC int
 xfs_bnobt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
@@ -192,23 +192,20 @@
 	struct xfs_alloc_rec_incore	*rec = &cur->bc_rec.a;
 	const struct xfs_alloc_rec	*kp = &key->alloc;
 
-	return (int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
+	return cmp_int(be32_to_cpu(kp->ar_startblock),
+		       rec->ar_startblock);
 }
 
-STATIC int64_t
+STATIC int
 xfs_cntbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
 	struct xfs_alloc_rec_incore	*rec = &cur->bc_rec.a;
 	const struct xfs_alloc_rec	*kp = &key->alloc;
-	int64_t				diff;
-
-	diff = (int64_t)be32_to_cpu(kp->ar_blockcount) - rec->ar_blockcount;
-	if (diff)
-		return diff;
-
-	return (int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
+
+	return cmp_int(be32_to_cpu(kp->ar_blockcount), rec->ar_blockcount) ?:
+	       cmp_int(be32_to_cpu(kp->ar_startblock), rec->ar_startblock);
 }
 
 STATIC int
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 19eab66fad..252da347b0 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -368,13 +368,13 @@
 	xfs_bmbt_disk_set_all(&rec->bmbt, &cur->bc_rec.b);
 }
 
-STATIC int64_t
+STATIC int
 xfs_bmbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
-	return (int64_t)be64_to_cpu(key->bmbt.br_startoff) -
-				      cur->bc_rec.b.br_startoff;
+	return cmp_int(be64_to_cpu(key->bmbt.br_startoff),
+		       cur->bc_rec.b.br_startoff);
 }
 
 STATIC int
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index fecd9f0b93..1bf20d509a 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -175,7 +175,7 @@
 	 * Compare key value and cursor value -- positive if key > cur,
 	 * negative if key < cur, and zero if equal.
 	 */
-	int64_t (*cmp_key_with_cur)(struct xfs_btree_cur *cur,
+	int	(*cmp_key_with_cur)(struct xfs_btree_cur *cur,
 				    const union xfs_btree_key *key);
 
 	/*
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 973ae62d39..dab9b61bd2 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -264,13 +264,13 @@
 	ptr->s = agi->agi_free_root;
 }
 
-STATIC int64_t
+STATIC int
 xfs_inobt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
-	return (int64_t)be32_to_cpu(key->inobt.ir_startino) -
-			  cur->bc_rec.i.ir_startino;
+	return cmp_int(be32_to_cpu(key->inobt.ir_startino),
+		       cur->bc_rec.i.ir_startino);
 }
 
 STATIC int
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 668c788dca..44d942e9d0 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -173,7 +173,7 @@
 	ptr->s = agf->agf_refcount_root;
 }
 
-STATIC int64_t
+STATIC int
 xfs_refcountbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
@@ -184,7 +184,7 @@
 
 	start = xfs_refcount_encode_startblock(irec->rc_startblock,
 			irec->rc_domain);
-	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
+	return cmp_int(be32_to_cpu(kp->rc_startblock), start);
 }
 
 STATIC int
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index ab207b9cc2..d7b9fccc3a 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -242,34 +242,18 @@
 	return offset & ~XFS_RMAP_OFF_UNWRITTEN;
 }
 
-STATIC int64_t
+STATIC int
 xfs_rmapbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
 	struct xfs_rmap_irec		*rec = &cur->bc_rec.r;
 	const struct xfs_rmap_key	*kp = &key->rmap;
-	__u64				x, y;
-	int64_t				d;
-
-	d = (int64_t)be32_to_cpu(kp->rm_startblock) - rec->rm_startblock;
-	if (d)
-		return d;
-
-	x = be64_to_cpu(kp->rm_owner);
-	y = rec->rm_owner;
-	if (x > y)
-		return 1;
-	else if (y > x)
-		return -1;
-
-	x = offset_keymask(be64_to_cpu(kp->rm_offset));
-	y = offset_keymask(xfs_rmap_irec_offset_pack(rec));
-	if (x > y)
-		return 1;
-	else if (y > x)
-		return -1;
-	return 0;
+
+	return cmp_int(be32_to_cpu(kp->rm_startblock), rec->rm_startblock) ?:
+	       cmp_int(be64_to_cpu(kp->rm_owner), rec->rm_owner) ?:
+	       cmp_int(offset_keymask(be64_to_cpu(kp->rm_offset)),
+		       offset_keymask(xfs_rmap_irec_offset_pack(rec)));
 }
 
 STATIC int
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 7fbbc6387c..77191f073a 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -154,7 +154,7 @@
 	ptr->l = 0;
 }
 
-STATIC int64_t
+STATIC int
 xfs_rtrefcountbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
@@ -165,7 +165,7 @@
 
 	start = xfs_refcount_encode_startblock(irec->rc_startblock,
 			irec->rc_domain);
-	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
+	return cmp_int(be32_to_cpu(kp->rc_startblock), start);
 }
 
 STATIC int
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 0492cd55d5..633dca0333 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -184,34 +184,18 @@
 	return offset & ~XFS_RMAP_OFF_UNWRITTEN;
 }
 
-STATIC int64_t
+STATIC int
 xfs_rtrmapbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
 	struct xfs_rmap_irec		*rec = &cur->bc_rec.r;
 	const struct xfs_rmap_key	*kp = &key->rmap;
-	__u64				x, y;
-	int64_t				d;
-
-	d = (int64_t)be32_to_cpu(kp->rm_startblock) - rec->rm_startblock;
-	if (d)
-		return d;
-
-	x = be64_to_cpu(kp->rm_owner);
-	y = rec->rm_owner;
-	if (x > y)
-		return 1;
-	else if (y > x)
-		return -1;
-
-	x = offset_keymask(be64_to_cpu(kp->rm_offset));
-	y = offset_keymask(xfs_rmap_irec_offset_pack(rec));
-	if (x > y)
-		return 1;
-	else if (y > x)
-		return -1;
-	return 0;
+
+	return cmp_int(be32_to_cpu(kp->rm_startblock), rec->rm_startblock) ?:
+	       cmp_int(be64_to_cpu(kp->rm_owner), rec->rm_owner) ?:
+	       cmp_int(offset_keymask(be64_to_cpu(kp->rm_offset)),
+		       offset_keymask(xfs_rmap_irec_offset_pack(rec)));
 }
 
 STATIC int
diff --git a/repair/rcbag_btree.c b/repair/rcbag_btree.c
index 8a50bd03a5..86a28f2ab8 100644
--- a/repair/rcbag_btree.c
+++ b/repair/rcbag_btree.c
@@ -46,30 +46,24 @@
 	bag_rec->rbg_refcount = bag_irec->rbg_refcount;
 }
 
-STATIC int64_t
+STATIC int
 rcbagbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
 	struct rcbag_rec		*rec = (struct rcbag_rec *)&cur->bc_rec;
 	const struct rcbag_key		*kp = (const struct rcbag_key *)key;
-
-	if (kp->rbg_startblock > rec->rbg_startblock)
-		return 1;
-	if (kp->rbg_startblock < rec->rbg_startblock)
-		return -1;
-
-	if (kp->rbg_blockcount > rec->rbg_blockcount)
-		return 1;
-	if (kp->rbg_blockcount < rec->rbg_blockcount)
-		return -1;
-
-	if (kp->rbg_ino > rec->rbg_ino)
-		return 1;
-	if (kp->rbg_ino < rec->rbg_ino)
-		return -1;
-
-	return 0;
+	int				d;
+
+	d = cmp_int(kp->rbg_startblock, rec->rbg_startblock);
+	if (d)
+		return d;
+
+	d = cmp_int(kp->rbg_blockcount, rec->rbg_blockcount);
+	if (d)
+		return d;
+
+	return cmp_int(kp->rbg_ino, rec->rbg_ino);
 }
 
 STATIC int

-- 
- Andrey

