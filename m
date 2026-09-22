Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16FF3F929B
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 23:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119136; cv=none; b=jL/7N7MEtYv+fb0wTdCG0y/Rdx8LrgEa8kYR0zDoDkDFIrAgFvTpy8g8uzc7D1b4BK5Wg4of+/Z31vcvwfZSAOjHmWtdMye5OESyhLOFo+DKv7E8pD/0Rm7ypf99asyUWoJLlvkrr32fA/2RY7pQnz3zImUJ3FR5YV4n1EXXugw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119136; c=relaxed/simple;
	bh=drCjMPrlfLowcYGiEP04pzs9UYU53dJxnATRrZCnliQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwwKJ/S3J0rmla38GJNBOUlL5e+vMZR3e0vbYUo324s5GXQxxH2n1y9E50lI8aGHlnMPI1ATGR12j0APsgLDK6LJAi5aC3Xp/Ps1f9qV3ZP6A1NgT65x1l7Jvdrrb/c06JzsYtzjiouR6GtzZlk3N7spdqnU1HcmWqSldKzy92E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f3gqrQKw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=f7VPODSk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f3gqrQKw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="f7VPODSk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790119133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=03FKTGsh47LYo1389DL3V9yXI+OKunKpuCGh5JqFa2c=;
	b=f3gqrQKwDvW9jEERSx6hA2i6MPDAwzIRFSJL3Co0JTlfcOI5nw9FbIX6TdZLxHGCxWZJQG
	NHnY+kVEhPkuE3Elh1Hr2wzG9jdQsgWZxTdojHJcKd8tiI5nI9Bs2d1EEr8m7ljgQENohi
	hF8DnTdMUqa7DUill1Ny+4JS0ZBj3WI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-3zlkm3YUPb2f4dKmMm9-Qw-1; Tue, 22 Sep 2026 19:18:52 -0400
X-MC-Unique: 3zlkm3YUPb2f4dKmMm9-Qw-1
X-Mimecast-MFC-AGG-ID: 3zlkm3YUPb2f4dKmMm9-Qw_1790119132
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-90e87478402so8593906d6.1
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 16:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790119132; x=1790723932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=03FKTGsh47LYo1389DL3V9yXI+OKunKpuCGh5JqFa2c=;
        b=f7VPODSkJYaDxGonYET20KtSSU0CyeIzJQZ+yiWpB6Z7TCbS00sujt+lBuWxO7WBpc
         ICbXu56KQK+KWNJKR/rFaeLHtMq2Xc6MVOXEdMflgSViEY0H3NagxAJrkVP6l21/xKkE
         3qcihZrNCMrzFuAtyzJYCyNvE4DW2TTE7bXbRrVdF/os8unV22Hg0jxbUVPwsbOyzeWa
         tRWj0kiTRa1TOQmsNfeYQgGWh0vGigRY9sMp5PH9q6DlkIes4HEqSuSTGoauPqS9V3lQ
         Qw9Coc715pzZJPPbpzLfHRdVnZlvqXC+Rln0OI/97zIAY2lGYGxUnQmC6KAClOEGofj3
         D47g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790119132; x=1790723932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=03FKTGsh47LYo1389DL3V9yXI+OKunKpuCGh5JqFa2c=;
        b=Y+St6xSHokXMdLNlxlAsB2+bd4zuPkfaJnNYd1fckK+J267cSK593tekzOxQLVaX5T
         kOWxKObgP6r3gctRMjTNE3wZW3q56AeSd1ltq6MlNGpufbHWeTcIkzcIUkSTcrbGiYF7
         32WJ0iqXib9ePPGayDgMLr1Ry60XX/XbCXFoho+V6GtBqlbJl5GWuftRDxKLuokjKX/3
         gNH4AXkgZ0vUWN8dRkaWb6T0ugt6PrlLEvoMtRh9BAFmwUPAE9J7fGhlHGquDCCOxAvx
         ML7bujHwgupeMTlyafqRE6r7zNvY5Sq9Dvsalw65fVQ4jyBPh9dRYegMQFda2MySwlmf
         TKaA==
X-Gm-Message-State: AFuF++k+nJOMIo3GVT3UYawW06un0jlRQHekU+XrKnvU47ia8zwktmHg
	UKTZCHSl3prHv9M0vzRNn62XTXH4P8ILNz2U/z+oLcO7rBwXlbk+XEgoiArD1nfCQ+NdtZt6oLY
	QLNuxFrPjfTW0D4vVqS5E0JzQs5NPuiBQTJJveG/oiNGnM3q8F3+Sm860O3ku/ku9nrGdji6XVk
	A15V/03cnF3k8uUhNxGQ/kd8VJC3AcVt0jv0oypvNXkMv0mfw=
X-Gm-Gg: AYBFou2Gh2UFnQX/LM/88n2aC0HVgT9bbc2A1f6DsTwplwr2aQlElFdNyDMdf/tg6L1
	K9koPsU6iWh9QVKSRjhaiFpaaIu1gWEYJj+5zKgYl0eLA87y2Xq1P8iuVAl58JfOvm8LbGXT1JM
	NHN2Dl6F8erzXPrr//Nu/V19WY4bTqWIj58YwNVFEMRDVBJKX+pt3x/KNb0eCqodLqTS8kqkeXd
	UBZAplIVarEpKGU+FAjBYO5wFPwZDa4Heol24cYuZ5GEAtZSeEx7f803ONkQ4flhROHpD2iYM3w
	IRFR6/7svB2QdgxyXeS67BPvNTHjm+IEQdbofjWPDWhlxuhrCfhBnjPe6O7g8bthABcOgrB4mrI
	Fm/+lyJCO/ru3DT+Yqr+62jcNeeZ72My8CCh9mMV+Qt5+wfis
X-Received: by 2002:a05:620a:600d:b0:93b:d7a1:ba10 with SMTP id af79cd13be357-93c2523785emr150380885a.59.1790119131789;
        Tue, 22 Sep 2026 16:18:51 -0700 (PDT)
X-Received: by 2002:a05:620a:600d:b0:93b:d7a1:ba10 with SMTP id af79cd13be357-93c2523785emr150376985a.59.1790119131322;
        Tue, 22 Sep 2026 16:18:51 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c248b84fasm91912285a.40.2026.09.22.16.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 16:18:50 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@infradead.org,
	djwong@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] xfs: share the AG refcount btree with the rt refcount btree
Date: Tue, 22 Sep 2026 18:17:09 -0500
Message-ID: <20260922231845.3266784-3-sandeen@redhat.com>
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

The AG refcount btree and the realtime refcount btree have several
identical key and record ops. Share these to eliminate copied code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount_btree.c   |  16 ++--
 fs/xfs/libxfs/xfs_refcount_btree.h   |  26 ++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 113 +++------------------------
 3 files changed, 43 insertions(+), 112 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 7e5f92c1ac56..2c6148a97994 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -127,7 +127,7 @@ xfs_refcountbt_get_maxrecs(
 	return cur->bc_mp->m_refc_mxr[level != 0];
 }
 
-STATIC void
+void
 xfs_refcountbt_init_key_from_rec(
 	union xfs_btree_key		*key,
 	const union xfs_btree_rec	*rec)
@@ -135,7 +135,7 @@ xfs_refcountbt_init_key_from_rec(
 	key->refc.rc_startblock = rec->refc.rc_startblock;
 }
 
-STATIC void
+void
 xfs_refcountbt_init_high_key_from_rec(
 	union xfs_btree_key		*key,
 	const union xfs_btree_rec	*rec)
@@ -147,7 +147,7 @@ xfs_refcountbt_init_high_key_from_rec(
 	key->refc.rc_startblock = cpu_to_be32(x);
 }
 
-STATIC void
+void
 xfs_refcountbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
@@ -174,7 +174,7 @@ xfs_refcountbt_init_ptr_from_cur(
 	ptr->s = agf->agf_refcount_root;
 }
 
-STATIC int
+int
 xfs_refcountbt_cmp_key_with_cur(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
@@ -188,7 +188,7 @@ xfs_refcountbt_cmp_key_with_cur(
 	return cmp_int(be32_to_cpu(kp->rc_startblock), start);
 }
 
-STATIC int
+int
 xfs_refcountbt_cmp_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -283,7 +283,7 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 	.verify_struct		= xfs_refcountbt_verify,
 };
 
-STATIC int
+int
 xfs_refcountbt_keys_inorder(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
@@ -293,7 +293,7 @@ xfs_refcountbt_keys_inorder(
 	       be32_to_cpu(k2->refc.rc_startblock);
 }
 
-STATIC int
+int
 xfs_refcountbt_recs_inorder(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_rec	*r1,
@@ -304,7 +304,7 @@ xfs_refcountbt_recs_inorder(
 		be32_to_cpu(r2->refc.rc_startblock);
 }
 
-STATIC enum xbtree_key_contig
+enum xbtree_key_contig
 xfs_refcountbt_keys_contiguous(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key1,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index beb93bef6a81..40eedfae6846 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -15,6 +15,8 @@ struct xfs_btree_cur;
 struct xfs_mount;
 struct xfs_perag;
 struct xbtree_afakeroot;
+union xfs_btree_key;
+union xfs_btree_rec;
 
 /*
  * Btree block header size
@@ -69,4 +71,28 @@ unsigned int xfs_refcountbt_maxlevels_ondisk(void);
 int __init xfs_refcountbt_init_cur_cache(void);
 void xfs_refcountbt_destroy_cur_cache(void);
 
+/*
+ * Key and record btree ops.  The refcount on-disk key/record format is
+ * identical for the AG refcount btree and the realtime refcount btree, so
+ * these are shared by both.
+ */
+void xfs_refcountbt_init_key_from_rec(union xfs_btree_key *key,
+		const union xfs_btree_rec *rec);
+void xfs_refcountbt_init_high_key_from_rec(union xfs_btree_key *key,
+		const union xfs_btree_rec *rec);
+void xfs_refcountbt_init_rec_from_cur(struct xfs_btree_cur *cur,
+		union xfs_btree_rec *rec);
+int xfs_refcountbt_cmp_key_with_cur(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *key);
+int xfs_refcountbt_cmp_two_keys(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *k1, const union xfs_btree_key *k2,
+		const union xfs_btree_key *mask);
+int xfs_refcountbt_keys_inorder(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *k1, const union xfs_btree_key *k2);
+int xfs_refcountbt_recs_inorder(struct xfs_btree_cur *cur,
+		const union xfs_btree_rec *r1, const union xfs_btree_rec *r2);
+enum xbtree_key_contig xfs_refcountbt_keys_contiguous(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *key1, const union xfs_btree_key *key2,
+		const union xfs_btree_key *mask);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index e91ff14577f9..697f5e622685 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -20,6 +20,7 @@
 #include "xfs_btree_staging.h"
 #include "xfs_rtrefcount_btree.h"
 #include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_error.h"
@@ -113,41 +114,6 @@ xfs_rtrefcountbt_get_dmaxrecs(
 	return xfs_rtrefcountbt_droot_maxrecs(cur->bc_ino.forksize, level == 0);
 }
 
-STATIC void
-xfs_rtrefcountbt_init_key_from_rec(
-	union xfs_btree_key		*key,
-	const union xfs_btree_rec	*rec)
-{
-	key->refc.rc_startblock = rec->refc.rc_startblock;
-}
-
-STATIC void
-xfs_rtrefcountbt_init_high_key_from_rec(
-	union xfs_btree_key		*key,
-	const union xfs_btree_rec	*rec)
-{
-	__u32				x;
-
-	x = be32_to_cpu(rec->refc.rc_startblock);
-	x += be32_to_cpu(rec->refc.rc_blockcount) - 1;
-	key->refc.rc_startblock = cpu_to_be32(x);
-}
-
-STATIC void
-xfs_rtrefcountbt_init_rec_from_cur(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*rec)
-{
-	const struct xfs_refcount_irec *irec = &cur->bc_rec.rc;
-	uint32_t		start;
-
-	start = xfs_refcount_encode_startblock(irec->rc_startblock,
-			irec->rc_domain);
-	rec->refc.rc_startblock = cpu_to_be32(start);
-	rec->refc.rc_blockcount = cpu_to_be32(cur->bc_rec.rc.rc_blockcount);
-	rec->refc.rc_refcount = cpu_to_be32(cur->bc_rec.rc.rc_refcount);
-}
-
 STATIC void
 xfs_rtrefcountbt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
@@ -156,33 +122,6 @@ xfs_rtrefcountbt_init_ptr_from_cur(
 	ptr->l = 0;
 }
 
-STATIC int
-xfs_rtrefcountbt_cmp_key_with_cur(
-	struct xfs_btree_cur		*cur,
-	const union xfs_btree_key	*key)
-{
-	const struct xfs_refcount_key	*kp = &key->refc;
-	const struct xfs_refcount_irec	*irec = &cur->bc_rec.rc;
-	uint32_t			start;
-
-	start = xfs_refcount_encode_startblock(irec->rc_startblock,
-			irec->rc_domain);
-	return cmp_int(be32_to_cpu(kp->rc_startblock), start);
-}
-
-STATIC int
-xfs_rtrefcountbt_cmp_two_keys(
-	struct xfs_btree_cur		*cur,
-	const union xfs_btree_key	*k1,
-	const union xfs_btree_key	*k2,
-	const union xfs_btree_key	*mask)
-{
-	ASSERT(!mask || mask->refc.rc_startblock);
-
-	return cmp_int(be32_to_cpu(k1->refc.rc_startblock),
-		       be32_to_cpu(k2->refc.rc_startblock));
-}
-
 static xfs_failaddr_t
 xfs_rtrefcountbt_verify(
 	struct xfs_buf		*bp)
@@ -249,40 +188,6 @@ const struct xfs_buf_ops xfs_rtrefcountbt_buf_ops = {
 	.verify_struct		= xfs_rtrefcountbt_verify,
 };
 
-STATIC int
-xfs_rtrefcountbt_keys_inorder(
-	struct xfs_btree_cur		*cur,
-	const union xfs_btree_key	*k1,
-	const union xfs_btree_key	*k2)
-{
-	return be32_to_cpu(k1->refc.rc_startblock) <
-	       be32_to_cpu(k2->refc.rc_startblock);
-}
-
-STATIC int
-xfs_rtrefcountbt_recs_inorder(
-	struct xfs_btree_cur		*cur,
-	const union xfs_btree_rec	*r1,
-	const union xfs_btree_rec	*r2)
-{
-	return  be32_to_cpu(r1->refc.rc_startblock) +
-		be32_to_cpu(r1->refc.rc_blockcount) <=
-		be32_to_cpu(r2->refc.rc_startblock);
-}
-
-STATIC enum xbtree_key_contig
-xfs_rtrefcountbt_keys_contiguous(
-	struct xfs_btree_cur		*cur,
-	const union xfs_btree_key	*key1,
-	const union xfs_btree_key	*key2,
-	const union xfs_btree_key	*mask)
-{
-	ASSERT(!mask || mask->refc.rc_startblock);
-
-	return xbtree_key_contig(be32_to_cpu(key1->refc.rc_startblock),
-				 be32_to_cpu(key2->refc.rc_startblock));
-}
-
 static inline void
 xfs_rtrefcountbt_move_ptrs(
 	struct xfs_mount	*mp,
@@ -383,16 +288,16 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 	.get_minrecs		= xfs_rtrefcountbt_get_minrecs,
 	.get_maxrecs		= xfs_rtrefcountbt_get_maxrecs,
 	.get_dmaxrecs		= xfs_rtrefcountbt_get_dmaxrecs,
-	.init_key_from_rec	= xfs_rtrefcountbt_init_key_from_rec,
-	.init_high_key_from_rec	= xfs_rtrefcountbt_init_high_key_from_rec,
-	.init_rec_from_cur	= xfs_rtrefcountbt_init_rec_from_cur,
+	.init_key_from_rec	= xfs_refcountbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_refcountbt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_refcountbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rtrefcountbt_init_ptr_from_cur,
-	.cmp_key_with_cur	= xfs_rtrefcountbt_cmp_key_with_cur,
+	.cmp_key_with_cur	= xfs_refcountbt_cmp_key_with_cur,
 	.buf_ops		= &xfs_rtrefcountbt_buf_ops,
-	.cmp_two_keys		= xfs_rtrefcountbt_cmp_two_keys,
-	.keys_inorder		= xfs_rtrefcountbt_keys_inorder,
-	.recs_inorder		= xfs_rtrefcountbt_recs_inorder,
-	.keys_contiguous	= xfs_rtrefcountbt_keys_contiguous,
+	.cmp_two_keys		= xfs_refcountbt_cmp_two_keys,
+	.keys_inorder		= xfs_refcountbt_keys_inorder,
+	.recs_inorder		= xfs_refcountbt_recs_inorder,
+	.keys_contiguous	= xfs_refcountbt_keys_contiguous,
 	.broot_realloc		= xfs_rtrefcountbt_broot_realloc,
 };
 
-- 
2.55.0

