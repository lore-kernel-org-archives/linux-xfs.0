Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4B344D03B
	for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2026 18:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755213; cv=none; b=iqifkuaJcUTqAOdgTj3U5ES4QG+uah1TRX5IkngONft56BLi2PPtsQSv/WcLLWuZTMoagAVHD3nmpbZmN+XouFuQiGfO3qcSsSoH/DUTiEejNxoMddJEA3H8mpdFDPxde8jnpyyEO0J4qjCDrT/eZulOfSnOURDXC9ZgHztz3J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755213; c=relaxed/simple;
	bh=N59RXc2CEBMoEtWneUgr312ve9pBAjFkJ5zAfGT9q/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6L3QI78F/PXaVIhNHlk6NhWJkvYebDaHkHrX/jljIcoQR89FOmwqWmCA9WesPOHAsqHTzP79Iv8jk6gOybyUddpX7ufbtxTB4a5OnMg8NUvWMX3efvPemSTS6FsYMYKYxBSWGQUM3PiGP4Ay3cK9dxg2YOz6t4vmSpctmK97K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZiJW4xLv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QGDQ3WIC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZiJW4xLv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QGDQ3WIC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789755211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0YgoR3uHI0anogZNp/fT90b7yfgYBYVqDDnSj5wEEcA=;
	b=ZiJW4xLvwbhdg4DT1rWqGcVo+mEy9WTqawJhHtcGpsErF4BHhh9HDxYoM50CYFQ6HWQMcE
	rykMAVdBEzjdygkp7xoYi9DvP2KblEH0J4QhgOygHb4h9BnBGb2SGuaXGwUUe1lkadxrti
	jy19sCbIm1eF/Ie3POvWsBT1WGLIwnE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-2ych-qCvPgSbhcHq4bPlaQ-1; Fri, 18 Sep 2026 14:13:29 -0400
X-MC-Unique: 2ych-qCvPgSbhcHq4bPlaQ-1
X-Mimecast-MFC-AGG-ID: 2ych-qCvPgSbhcHq4bPlaQ_1789755209
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93a05d645acso245545085a.2
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2026 11:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789755209; x=1790360009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0YgoR3uHI0anogZNp/fT90b7yfgYBYVqDDnSj5wEEcA=;
        b=QGDQ3WICm5a7UBcazF0nuKIhLL8aCieK8CXfSQtppKKNsmHrqtTJO8ofSgezFQ7ru7
         pXylg6Yj5EfBiZ17g30vX18DHaMc+MQUb6Jhkd+5p2Xxfw6T9VdfXK9bvu2APtRKCoBg
         ZxGqPxOnP+Dto3SMBLVa6ShQWW4V9lacBgnNt5wTD6m+LA82ltBNuWMXr4ArIs9XdsKp
         FbY7SNr3wNICOr/sd0xCUupCoKy1kBX0iJIofHPY+/Xd7Pzyc67krNGYt3kCaivbYHww
         0OFOQMGFrTfzI0OG92FwFtWlyCwL+jsk+DgazM8S1oMBmi6TwCD6Rrr+6niTTMRFzdLh
         dHvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789755209; x=1790360009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0YgoR3uHI0anogZNp/fT90b7yfgYBYVqDDnSj5wEEcA=;
        b=sPPXnqm5uGNawqhcXCi+Q9a+QH5LCjsFsxLuA5hAXnQVNN25e7FXwIIFxwPYW4LoY7
         1RiXxVkSWpCdXKdwM/uAFvpQJxA6dblT6EAebhUrAw7BS8WlSIKxOgvSYfuz9XOOU2Qa
         0P2QbggNqFxyVVpded2VRUZ8CaqDJ/P5/7lMz9Fd490NYM1yfhDUtRu++0FpdfGOordS
         xOqHOe3rwNnvmofJnwnMhCOQHGfdp9WuUwymUQ1JLIo5PUGrcpBox/LXEeYuSJx3Wc5S
         8lPmWQLVvXYRl4tFWw+EAUwCa2mKAwu2dRVjDydwyGHdwrjl3QYEPvjLj0kfLGQDiAih
         njRw==
X-Gm-Message-State: AFuF++nG1a/yKDMvHZMYGXr3oAqSr9+6Dt6YpeiZDet7B9fKMKtV2CdT
	JbvqOb+i9IUM5EuFjtsa8yDhi/UZQzUtiQ69qvOtpR8PKS727meGhPN9Q5moXy6cHebZL+RVzs0
	CvtYBL/NVcfIupPYVxGIxdFldpCdb15OrOE+MHCaMnguzruIfgmmQco0srRqmCu44vZ5NcxW/8L
	JPawBxalfhMbMKQ5yM46jbMhKMktz6sED6S3mBG+9NcbSiNL8=
X-Gm-Gg: AYBFou3sKJKtz+NMuKyZ9tzhXLg/0s54QD2pJmUHK0m3epZQI+tB+uvepcJc969rNVJ
	9LPKx4rcrRFiWleLpeCFyU3e1BCDG9FTsVtRa87kVky+6DrtWKIpj/hEJ9vOv2rClONArbyWTTe
	eueiJY3ubg/Tf9MAHojAfRvp3v3U/VOcNaAHEH60CeAGjDegLxKDwjet30zELJnLLRqGR9tBUwm
	Qrv6VD3OyMUv54Qc7SiX8WUicuPw0+BKodaypGHw5jlbCvHWiCx+fGBpyx3977KHGn6L5VcvPeg
	U4zZ+g8of7BkqSLhxnJ+k5VwFP/wanhith27ZNi2xCn03hB2K73WYNRhtw/1UWVWfWQgnXXCjER
	eKtuIBUIVsNeVl7dtqs0CXWz162M8cbQnM/8nsg==
X-Received: by 2002:a05:620a:700f:b0:93b:d79b:9a62 with SMTP id af79cd13be357-93bdca9c434mr515295685a.67.1789755208607;
        Fri, 18 Sep 2026 11:13:28 -0700 (PDT)
X-Received: by 2002:a05:620a:700f:b0:93b:d79b:9a62 with SMTP id af79cd13be357-93bdca9c434mr515287085a.67.1789755207910;
        Fri, 18 Sep 2026 11:13:27 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93beda707b7sm4583185a.10.2026.09.18.11.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:13:27 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] xfs: use the shared rmap btree ops for the rt rmap btree
Date: Fri, 18 Sep 2026 13:01:33 -0500
Message-ID: <20260918181324.2472127-3-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918181324.2472127-1-sandeen@redhat.com>
References: <20260918181324.2472127-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the (identical but for naming) AG variants of these ops are
exported, use them for realtime as well, to eliminate copied code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c | 230 +++----------------------------
 1 file changed, 17 insertions(+), 213 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 5901d7efd3f6..2f00d0698ae1 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -20,6 +20,7 @@
 #include "xfs_btree_staging.h"
 #include "xfs_metafile.h"
 #include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
@@ -113,60 +114,6 @@ xfs_rtrmapbt_get_dmaxrecs(
 	return xfs_rtrmapbt_droot_maxrecs(cur->bc_ino.forksize, level == 0);
 }
 
-/*
- * Convert the ondisk record's offset field into the ondisk key's offset field.
- * Fork and bmbt are significant parts of the rmap record key, but written
- * status is merely a record attribute.
- */
-static inline __be64 ondisk_rec_offset_to_key(const union xfs_btree_rec *rec)
-{
-	return rec->rmap.rm_offset & ~cpu_to_be64(XFS_RMAP_OFF_UNWRITTEN);
-}
-
-STATIC void
-xfs_rtrmapbt_init_key_from_rec(
-	union xfs_btree_key		*key,
-	const union xfs_btree_rec	*rec)
-{
-	key->rmap.rm_startblock = rec->rmap.rm_startblock;
-	key->rmap.rm_owner = rec->rmap.rm_owner;
-	key->rmap.rm_offset = ondisk_rec_offset_to_key(rec);
-}
-
-STATIC void
-xfs_rtrmapbt_init_high_key_from_rec(
-	union xfs_btree_key		*key,
-	const union xfs_btree_rec	*rec)
-{
-	uint64_t			off;
-	int				adj;
-
-	adj = be32_to_cpu(rec->rmap.rm_blockcount) - 1;
-
-	key->rmap.rm_startblock = rec->rmap.rm_startblock;
-	be32_add_cpu(&key->rmap.rm_startblock, adj);
-	key->rmap.rm_owner = rec->rmap.rm_owner;
-	key->rmap.rm_offset = ondisk_rec_offset_to_key(rec);
-	if (XFS_RMAP_NON_INODE_OWNER(be64_to_cpu(rec->rmap.rm_owner)) ||
-	    XFS_RMAP_IS_BMBT_BLOCK(be64_to_cpu(rec->rmap.rm_offset)))
-		return;
-	off = be64_to_cpu(key->rmap.rm_offset);
-	off = (XFS_RMAP_OFF(off) + adj) | (off & ~XFS_RMAP_OFF_MASK);
-	key->rmap.rm_offset = cpu_to_be64(off);
-}
-
-STATIC void
-xfs_rtrmapbt_init_rec_from_cur(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*rec)
-{
-	rec->rmap.rm_startblock = cpu_to_be32(cur->bc_rec.r.rm_startblock);
-	rec->rmap.rm_blockcount = cpu_to_be32(cur->bc_rec.r.rm_blockcount);
-	rec->rmap.rm_owner = cpu_to_be64(cur->bc_rec.r.rm_owner);
-	rec->rmap.rm_offset = cpu_to_be64(
-			xfs_rmap_irec_offset_pack(&cur->bc_rec.r));
-}
-
 STATIC void
 xfs_rtrmapbt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
@@ -175,69 +122,6 @@ xfs_rtrmapbt_init_ptr_from_cur(
 	ptr->l = 0;
 }
 
-/*
- * Mask the appropriate parts of the ondisk key field for a key comparison.
- * Fork and bmbt are significant parts of the rmap record key, but written
- * status is merely a record attribute.
- */
-static inline uint64_t offset_keymask(uint64_t offset)
-{
-	return offset & ~XFS_RMAP_OFF_UNWRITTEN;
-}
-
-STATIC int
-xfs_rtrmapbt_cmp_key_with_cur(
-	struct xfs_btree_cur		*cur,
-	const union xfs_btree_key	*key)
-{
-	struct xfs_rmap_irec		*rec = &cur->bc_rec.r;
-	const struct xfs_rmap_key	*kp = &key->rmap;
-
-	return cmp_int(be32_to_cpu(kp->rm_startblock), rec->rm_startblock) ?:
-	       cmp_int(be64_to_cpu(kp->rm_owner), rec->rm_owner) ?:
-	       cmp_int(offset_keymask(be64_to_cpu(kp->rm_offset)),
-		       offset_keymask(xfs_rmap_irec_offset_pack(rec)));
-}
-
-STATIC int
-xfs_rtrmapbt_cmp_two_keys(
-	struct xfs_btree_cur		*cur,
-	const union xfs_btree_key	*k1,
-	const union xfs_btree_key	*k2,
-	const union xfs_btree_key	*mask)
-{
-	const struct xfs_rmap_key	*kp1 = &k1->rmap;
-	const struct xfs_rmap_key	*kp2 = &k2->rmap;
-	int				d;
-
-	/* Doesn't make sense to mask off the physical space part */
-	ASSERT(!mask || mask->rmap.rm_startblock);
-
-	d = cmp_int(be32_to_cpu(kp1->rm_startblock),
-		    be32_to_cpu(kp2->rm_startblock));
-	if (d)
-		return d;
-
-	if (!mask || mask->rmap.rm_owner) {
-		d = cmp_int(be64_to_cpu(kp1->rm_owner),
-			    be64_to_cpu(kp2->rm_owner));
-		if (d)
-			return d;
-	}
-
-	if (!mask || mask->rmap.rm_offset) {
-		/* Doesn't make sense to allow offset but not owner */
-		ASSERT(!mask || mask->rmap.rm_owner);
-
-		d = cmp_int(offset_keymask(be64_to_cpu(kp1->rm_offset)),
-			    offset_keymask(be64_to_cpu(kp2->rm_offset)));
-		if (d)
-			return d;
-	}
-
-	return 0;
-}
-
 static xfs_failaddr_t
 xfs_rtrmapbt_verify(
 	struct xfs_buf		*bp)
@@ -304,86 +188,6 @@ const struct xfs_buf_ops xfs_rtrmapbt_buf_ops = {
 	.verify_struct		= xfs_rtrmapbt_verify,
 };
 
-STATIC int
-xfs_rtrmapbt_keys_inorder(
-	struct xfs_btree_cur		*cur,
-	const union xfs_btree_key	*k1,
-	const union xfs_btree_key	*k2)
-{
-	uint32_t			x;
-	uint32_t			y;
-	uint64_t			a;
-	uint64_t			b;
-
-	x = be32_to_cpu(k1->rmap.rm_startblock);
-	y = be32_to_cpu(k2->rmap.rm_startblock);
-	if (x < y)
-		return 1;
-	else if (x > y)
-		return 0;
-	a = be64_to_cpu(k1->rmap.rm_owner);
-	b = be64_to_cpu(k2->rmap.rm_owner);
-	if (a < b)
-		return 1;
-	else if (a > b)
-		return 0;
-	a = offset_keymask(be64_to_cpu(k1->rmap.rm_offset));
-	b = offset_keymask(be64_to_cpu(k2->rmap.rm_offset));
-	if (a <= b)
-		return 1;
-	return 0;
-}
-
-STATIC int
-xfs_rtrmapbt_recs_inorder(
-	struct xfs_btree_cur		*cur,
-	const union xfs_btree_rec	*r1,
-	const union xfs_btree_rec	*r2)
-{
-	uint32_t			x;
-	uint32_t			y;
-	uint64_t			a;
-	uint64_t			b;
-
-	x = be32_to_cpu(r1->rmap.rm_startblock);
-	y = be32_to_cpu(r2->rmap.rm_startblock);
-	if (x < y)
-		return 1;
-	else if (x > y)
-		return 0;
-	a = be64_to_cpu(r1->rmap.rm_owner);
-	b = be64_to_cpu(r2->rmap.rm_owner);
-	if (a < b)
-		return 1;
-	else if (a > b)
-		return 0;
-	a = offset_keymask(be64_to_cpu(r1->rmap.rm_offset));
-	b = offset_keymask(be64_to_cpu(r2->rmap.rm_offset));
-	if (a <= b)
-		return 1;
-	return 0;
-}
-
-STATIC enum xbtree_key_contig
-xfs_rtrmapbt_keys_contiguous(
-	struct xfs_btree_cur		*cur,
-	const union xfs_btree_key	*key1,
-	const union xfs_btree_key	*key2,
-	const union xfs_btree_key	*mask)
-{
-	ASSERT(!mask || mask->rmap.rm_startblock);
-
-	/*
-	 * We only support checking contiguity of the physical space component.
-	 * If any callers ever need more specificity than that, they'll have to
-	 * implement it here.
-	 */
-	ASSERT(!mask || (!mask->rmap.rm_owner && !mask->rmap.rm_offset));
-
-	return xbtree_key_contig(be32_to_cpu(key1->rmap.rm_startblock),
-				 be32_to_cpu(key2->rmap.rm_startblock));
-}
-
 static inline void
 xfs_rtrmapbt_move_ptrs(
 	struct xfs_mount	*mp,
@@ -486,16 +290,16 @@ const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 	.get_minrecs		= xfs_rtrmapbt_get_minrecs,
 	.get_maxrecs		= xfs_rtrmapbt_get_maxrecs,
 	.get_dmaxrecs		= xfs_rtrmapbt_get_dmaxrecs,
-	.init_key_from_rec	= xfs_rtrmapbt_init_key_from_rec,
-	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
-	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
+	.init_key_from_rec	= xfs_rmapbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_rmapbt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rtrmapbt_init_ptr_from_cur,
-	.cmp_key_with_cur	= xfs_rtrmapbt_cmp_key_with_cur,
+	.cmp_key_with_cur	= xfs_rmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rtrmapbt_buf_ops,
-	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
-	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
-	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
-	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
+	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
+	.keys_inorder		= xfs_rmapbt_keys_inorder,
+	.recs_inorder		= xfs_rmapbt_recs_inorder,
+	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
 	.broot_realloc		= xfs_rtrmapbt_broot_realloc,
 };
 
@@ -595,16 +399,16 @@ const struct xfs_btree_ops xfs_rtrmapbt_mem_ops = {
 	.free_block		= xfbtree_free_block,
 	.get_minrecs		= xfbtree_get_minrecs,
 	.get_maxrecs		= xfbtree_get_maxrecs,
-	.init_key_from_rec	= xfs_rtrmapbt_init_key_from_rec,
-	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
-	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
+	.init_key_from_rec	= xfs_rmapbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_rmapbt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
-	.cmp_key_with_cur	= xfs_rtrmapbt_cmp_key_with_cur,
+	.cmp_key_with_cur	= xfs_rmapbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rtrmapbt_mem_buf_ops,
-	.cmp_two_keys		= xfs_rtrmapbt_cmp_two_keys,
-	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
-	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
-	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
+	.cmp_two_keys		= xfs_rmapbt_cmp_two_keys,
+	.keys_inorder		= xfs_rmapbt_keys_inorder,
+	.recs_inorder		= xfs_rmapbt_recs_inorder,
+	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
 };
 
 /* Create a cursor for an in-memory btree. */
-- 
2.55.0

