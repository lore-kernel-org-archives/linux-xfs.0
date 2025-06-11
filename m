Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B0020C489
	for <linux-xfs@vger.kernel.org>; Wed, 11 Jun 2025 18:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749665996; cv=none; b=XsBegCkS32sessWcP1J+qlJEjJ38Nmf17wi+yVapt//YsrvBSVFszpmApmfwHe0K/X5WWtANaaxgvxa6TLy68dH+Ol96LhAUiRUw+5Jq23DILZNHX44Pmq5w312scED6I+rDgUc6D3Zb2ovw6kPR7/vH1lsAqRmgvWlWVnqm8NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749665996; c=relaxed/simple;
	bh=CBJ5v0snwTUHFjgEoNNBPiMRuZuVRuOJ1VUGxW+dWCk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kjd9outeNtWwGwtkDTLoYTWe1KoqQ+AM43cjPcfX491TsylEVeJMnzTeLqoAthhA1gpMik75xIfP6P1YoLLyUo27l4C6uZFoLxkjZY2AfcV3mUhpeihMfXVLRe52d7ugGsVmXbep/29Np0e2MZ2V4hgbYI+RgW6Q/b7GddlIjCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ReB/iQ83; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ReB/iQ83"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749665993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jEUizK/JdM0jM1g7Nv2DbkLt9xDAIjhS+yTOu6fCH8o=;
	b=ReB/iQ83lQYIC210Aw0ZMmBCPX+19xFdKOveB19KkBL6Xf3K9NB9HK/y7fyf19YfSq5/hG
	aSklOocN/HQzxipsUbZ9/1For5vbrojb/+qmP4jOSb5U0xT8CxpXvNlYhQPS+NCWKtxXtD
	gDaw/rn8uSKKDq06ehZfQ3BZMgd9xt0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-250-f7p4FizBP2SZv20t1vcT9w-1; Wed,
 11 Jun 2025 14:19:50 -0400
X-MC-Unique: f7p4FizBP2SZv20t1vcT9w-1
X-Mimecast-MFC-AGG-ID: f7p4FizBP2SZv20t1vcT9w_1749665989
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD9DC195608B
	for <linux-xfs@vger.kernel.org>; Wed, 11 Jun 2025 18:19:49 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.100])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4BA3230002C3
	for <linux-xfs@vger.kernel.org>; Wed, 11 Jun 2025 18:19:49 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: convert sparse inode alloc debug fallback to errortag
Date: Wed, 11 Jun 2025 14:23:23 -0400
Message-ID: <20250611182323.183512-4-bfoster@redhat.com>
In-Reply-To: <20250611182323.183512-1-bfoster@redhat.com>
References: <20250611182323.183512-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

XFS includes DEBUG logic to randomly fall into sparse inode chunk
allocation. This is to facilitate code coverage testing as sparse
allocation is really only required once an AG has insufficiently
large free extents to allocate a full inode chunk.

Similar to for the extent allocation path, convert this into an
errortag that is enabled by default to maintain current DEBUG mode
behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_errortag.h |  4 +++-
 fs/xfs/libxfs/xfs_ialloc.c   | 14 +++++---------
 fs/xfs/xfs_error.c           |  3 +++
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index c57d26619817..3a1404a24584 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -66,7 +66,8 @@
 #define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
 #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
 #define XFS_ERRTAG_AG_ALLOC_SKIP			46
-#define XFS_ERRTAG_MAX					47
+#define XFS_ERRTAG_SPARSE_IALLOC			47
+#define XFS_ERRTAG_MAX					48
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -117,5 +118,6 @@
 #define XFS_RANDOM_EXCHMAPS_FINISH_ONE			1
 #define XFS_RANDOM_METAFILE_RESV_CRITICAL		4
 #define XFS_RANDOM_AG_ALLOC_SKIP			2
+#define XFS_RANDOM_SPARSE_IALLOC			2
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 0c47b5c6ca7d..9901e09e7a5d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -707,7 +707,6 @@ xfs_ialloc_ag_alloc(
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_ino_geometry	*igeo = M_IGEO(tp->t_mountp);
 	uint16_t		allocmask = (uint16_t) -1;
-	int			do_sparse = 0;
 
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
@@ -716,13 +715,6 @@ xfs_ialloc_ag_alloc(
 	args.oinfo = XFS_RMAP_OINFO_INODES;
 	args.pag = pag;
 
-#ifdef DEBUG
-	/* randomly do sparse inode allocations */
-	if (xfs_has_sparseinodes(tp->t_mountp) &&
-	    igeo->ialloc_min_blks < igeo->ialloc_blks)
-		do_sparse = get_random_u32_below(2);
-#endif
-
 	/*
 	 * Locking will ensure that we don't have two callers in here
 	 * at one time.
@@ -742,8 +734,12 @@ xfs_ialloc_ag_alloc(
 	newino = be32_to_cpu(agi->agi_newino);
 	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
 		     igeo->ialloc_blks;
-	if (do_sparse)
+
+	if (xfs_has_sparseinodes(args.mp) &&
+	    igeo->ialloc_min_blks < igeo->ialloc_blks &&
+	    XFS_TEST_ERROR(false, args.mp, XFS_ERRTAG_SPARSE_IALLOC))
 		goto sparse_alloc;
+
 	if (likely(newino != NULLAGINO &&
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
 		args.prod = 1;
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index f1222e4e8c5f..480fabfadf39 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -65,6 +65,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_EXCHMAPS_FINISH_ONE,
 	XFS_RANDOM_METAFILE_RESV_CRITICAL,
 	XFS_RANDOM_AG_ALLOC_SKIP,
+	XFS_RANDOM_SPARSE_IALLOC,
 };
 
 struct xfs_errortag_attr {
@@ -189,6 +190,7 @@ XFS_ERRORTAG_ATTR_RW(write_delay_ms,	XFS_ERRTAG_WRITE_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(exchmaps_finish_one, XFS_ERRTAG_EXCHMAPS_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(metafile_resv_crit, XFS_ERRTAG_METAFILE_RESV_CRITICAL);
 __XFS_ERRORTAG_ATTR_RW(ag_alloc_skip,	XFS_ERRTAG_AG_ALLOC_SKIP,	true);
+__XFS_ERRORTAG_ATTR_RW(sparse_ialloc,	XFS_ERRTAG_SPARSE_IALLOC,	true);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -237,6 +239,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(exchmaps_finish_one),
 	XFS_ERRORTAG_ATTR_LIST(metafile_resv_crit),
 	XFS_ERRORTAG_ATTR_LIST(ag_alloc_skip),
+	XFS_ERRORTAG_ATTR_LIST(sparse_ialloc),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
-- 
2.49.0

