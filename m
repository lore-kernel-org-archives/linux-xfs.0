Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CB13769F0
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 23:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119135; cv=none; b=pjfqCtlxvkbHDciPAcnf373LlatCZRVLcTzIjNI8fKeUvcKR6ddgLV+sJXO7Ql7XxGv0nOMu3MaZTuM3GgusRtLQCZlmnI42MrC8t4l6mzRXuWoOW1WfJrG4+8Yi48GbPX4a1Ma2qaMJFho/vDBOoHyjyryr0LdrbfvJeUlk/RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119135; c=relaxed/simple;
	bh=34ap1K7kbyWVlcd9mB2pdQ0ZkMkiIgowUjtMbYIN040=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjQPKS6tXaB0DPzfI5P0j5/hbHUu/pnLhsCMrmRri4gqE5Yk421Y6EXc8mX0P+ZhuK0ko7ltejBHxyDWUpg4W8cFwhuia9xJ2DqN+d2sfIn1HXjKnPAOFHYwnlVJ1cDY02lYfUgkuOYR3s5y9/X+xtoZmsdhA8BZEgk3x1DGwws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=McvnBfwt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FIhEl2x3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="McvnBfwt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FIhEl2x3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790119132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i/tIfs4pdsaTuGtiHn1FmA7sCBuRcx2M4EnKPJdwW0w=;
	b=McvnBfwt6+VHkt7fwXqYw9cs7wVF7HsVH/j5XPJUrEIAKtLripQ+rm9lHTo5ejy7x8TAzo
	AI7Q+4GQUvVBi098lqhDdxbK1aeOfG51Wf4WfQxPOjFQxI3c+E8uZ3A2HtSZkRU5sAG6Pz
	zD02aKwU+7cWaktzChkwV+mXKlVzZ1s=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-u6Ln8lcXPHOT2G24QABOog-1; Tue, 22 Sep 2026 19:18:51 -0400
X-MC-Unique: u6Ln8lcXPHOT2G24QABOog-1
X-Mimecast-MFC-AGG-ID: u6Ln8lcXPHOT2G24QABOog_1790119131
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-939f925ba4eso71927285a.3
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 16:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790119131; x=1790723931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i/tIfs4pdsaTuGtiHn1FmA7sCBuRcx2M4EnKPJdwW0w=;
        b=FIhEl2x35XjQUg/BZGgVgrX/Kx9yv2Q+hMJ1RqD6maoWoSgp2jy6bdLs/Q1boJYgW2
         LWOR1gVS5WK0F7D0Gus/rhGJR9r4ksJMLdJ4KwjuLbu9wIxewH/Wmj+fa4GEakNrgqq1
         j6x1uSAlkBN3MFgfg5grG4Sc+kCfFyA1NYQny1HrGoiwxhIQtFtBxbbexCi8SC1I91y6
         0zxIL9QNntanIpUq6pK+INOM0t/etJTHyn20LoOtq5TEKYvCOM+6343/Z+A+MTFbL2UH
         VKZYpKa7Qc/DZcr6kOXcqKP6Y8YgNJY4keV+W09CqtZk6fEbwlwnwc7nCn0CtvVTyX5E
         o1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790119131; x=1790723931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i/tIfs4pdsaTuGtiHn1FmA7sCBuRcx2M4EnKPJdwW0w=;
        b=r1dvlk8VuWD2UB4yPkd0ZiMMfGyaIsYGt2Gs9l+oNFvL1qDG+gH7q9vfDCXT4okCYx
         Z4+9l6wjrDeXFsxt0sDJOEIsq62uTaWu+crEu+lcwENAkOqsxflRoIjYZAizS2Qp7WlD
         p26vdsW+HdVscgcDWnW96+ZKndI9u8Uox8e2K3IYLAR4jFT01qy6djMr1h30W3wm4X3d
         wzhpc2KuEEg551wzklUWTTI9JofxpshJZ/gM7ndr/vcHFKvvBy/xhSBIakX5gq1AHRtW
         DFos+Odc7Fwwtr1UfaP71UkR/NzkkuFsCIhGNoHDy19JYXjwt5TnXf5cHTlL0sAR5MAC
         HzNg==
X-Gm-Message-State: AFuF++nW++ySFhT+oEwFtexVwOP+gDMv6hNv3HKdiWXRoRJyw97AWQ87
	qx2m3bcwZElFA0weFtLBkEc0Y2V9B6Rupkox3QaWHcWJl5OQs6gHxIf9GFpgckgyg4rx1IqR08Z
	BLx9tX48rthORfqXj0NwuXqeXvxs2QnrblkAuavrZuMN7ZOPC2B3D9vUmrHgEGPfTMGCwtgEA/u
	1mx8gNO6fujNUQEWIvnx//SpQL/3Amic/mMvhpZk2AILw39Hw=
X-Gm-Gg: AYBFou1c/TW4HGqTn6TF2DfmMBAvtxl4fkBxUcz5Pm+hgbQKL62YqCIDHF75FVCHk7o
	w0H1ccK4yzQTCBCa/LdIYotJpNQvyNyPEG24rPKI48GZUyDizuAXGemvxAtY0nWdEpRvVfSA5MC
	fC3Npx/5v78pwxEH+jpDLC0XbHC6VPOD5KcYSONn8hUFIPltqMu6u7Zqv/Exw7HZc2LlMImnYAh
	GAP0zabcI2+5QiqmQGRSpJ8hPvNnhSCwguZdrAqxV3T1c+Baua3rJjrv4p9T/43XTEG5kmgqwl+
	m9U0SjWapzB6xwUgJmG4pAdTRjJVYP3OUX5zN3tI6PaNORJ927pT9/8cb+QtjNlWSPAoqjGAGUG
	RA9LXxRFPwGgIdHRX8AStbXOko2GREHMibr7ZXw==
X-Received: by 2002:a05:620a:45ab:b0:939:112:d526 with SMTP id af79cd13be357-93c250f8898mr139786685a.18.1790119130759;
        Tue, 22 Sep 2026 16:18:50 -0700 (PDT)
X-Received: by 2002:a05:620a:45ab:b0:939:112:d526 with SMTP id af79cd13be357-93c250f8898mr139783285a.18.1790119130245;
        Tue, 22 Sep 2026 16:18:50 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c248b84fasm91912285a.40.2026.09.22.16.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 16:18:49 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@infradead.org,
	djwong@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] xfs: share the AG rmap btree with the rt rmap btree
Date: Tue, 22 Sep 2026 18:17:08 -0500
Message-ID: <20260922231845.3266784-2-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922231845.3266784-1-sandeen@redhat.com>
References: <20260922231845.3266784-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The AG rmap btree and the realtime rmap btree have several identical
key and record ops. Share these to eliminate copied code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_rmap_btree.c   |  16 +--
 fs/xfs/libxfs/xfs_rmap_btree.h   |  26 ++++
 fs/xfs/libxfs/xfs_rtrmap_btree.c | 230 +++----------------------------
 3 files changed, 51 insertions(+), 221 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 10b3272238eb..5b283a5ddd13 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -170,7 +170,7 @@ static inline __be64 ondisk_rec_offset_to_key(const union xfs_btree_rec *rec)
 	return rec->rmap.rm_offset & ~cpu_to_be64(XFS_RMAP_OFF_UNWRITTEN);
 }
 
-STATIC void
+void
 xfs_rmapbt_init_key_from_rec(
 	union xfs_btree_key		*key,
 	const union xfs_btree_rec	*rec)
@@ -187,7 +187,7 @@ xfs_rmapbt_init_key_from_rec(
  * the startblock for all records, and if the record is for a data/attr
  * fork mapping, we add blockcount-1 to the offset too.
  */
-STATIC void
+void
 xfs_rmapbt_init_high_key_from_rec(
 	union xfs_btree_key		*key,
 	const union xfs_btree_rec	*rec)
@@ -209,7 +209,7 @@ xfs_rmapbt_init_high_key_from_rec(
 	key->rmap.rm_offset = cpu_to_be64(off);
 }
 
-STATIC void
+void
 xfs_rmapbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
@@ -243,7 +243,7 @@ static inline uint64_t offset_keymask(uint64_t offset)
 	return offset & ~XFS_RMAP_OFF_UNWRITTEN;
 }
 
-STATIC int
+int
 xfs_rmapbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
@@ -257,7 +257,7 @@ xfs_rmapbt_cmp_key_with_cur(
 		       offset_keymask(xfs_rmap_irec_offset_pack(rec)));
 }
 
-STATIC int
+int
 xfs_rmapbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -390,7 +390,7 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.verify_struct		= xfs_rmapbt_verify,
 };
 
-STATIC int
+int
 xfs_rmapbt_keys_inorder(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -420,7 +420,7 @@ xfs_rmapbt_keys_inorder(
 	return 0;
 }
 
-STATIC int
+int
 xfs_rmapbt_recs_inorder(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_rec	*r1,
@@ -450,7 +450,7 @@ xfs_rmapbt_recs_inorder(
 	return 0;
 }
 
-STATIC enum xbtree_key_contig
+enum xbtree_key_contig
 xfs_rmapbt_keys_contiguous(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key1,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 119b1567cd0e..7071dac745e1 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -11,6 +11,8 @@ struct xfs_btree_cur;
 struct xfs_mount;
 struct xbtree_afakeroot;
 struct xfbtree;
+union xfs_btree_key;
+union xfs_btree_rec;
 
 /* rmaps only exist on crc enabled filesystems */
 #define XFS_RMAP_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN
@@ -69,4 +71,28 @@ struct xfs_btree_cur *xfs_rmapbt_mem_cursor(struct xfs_perag *pag,
 int xfs_rmapbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
 		struct xfs_buftarg *btp, xfs_agnumber_t agno);
 
+/*
+ * Key and record btree ops.  The rmap on-disk key/record format is identical
+ * for the AG rmap btree and the realtime rmap btree, so these are shared by
+ * both.
+ */
+void xfs_rmapbt_init_key_from_rec(union xfs_btree_key *key,
+		const union xfs_btree_rec *rec);
+void xfs_rmapbt_init_high_key_from_rec(union xfs_btree_key *key,
+		const union xfs_btree_rec *rec);
+void xfs_rmapbt_init_rec_from_cur(struct xfs_btree_cur *cur,
+		union xfs_btree_rec *rec);
+int xfs_rmapbt_cmp_key_with_cur(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *key);
+int xfs_rmapbt_cmp_two_keys(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *k1, const union xfs_btree_key *k2,
+		const union xfs_btree_key *mask);
+int xfs_rmapbt_keys_inorder(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *k1, const union xfs_btree_key *k2);
+int xfs_rmapbt_recs_inorder(struct xfs_btree_cur *cur,
+		const union xfs_btree_rec *r1, const union xfs_btree_rec *r2);
+enum xbtree_key_contig xfs_rmapbt_keys_contiguous(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *key1, const union xfs_btree_key *key2,
+		const union xfs_btree_key *mask);
+
 #endif /* __XFS_RMAP_BTREE_H__ */
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

