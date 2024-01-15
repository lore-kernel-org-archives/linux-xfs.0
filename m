Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD3B1B5BA
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 23:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="bPyqrvi8"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3bd5c4cffefso3518311b6e.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 15:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705359680; x=1705964480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AReH4fPhX0qnf2rGMtllGHRPMoAw4H7smgC9h2elFy0=;
        b=bPyqrvi80G9jtjJzDoRk4SM/l35+fLKrcZywoROhRN3/PizE5IplWy90ypl6nDj6+K
         51pfOaXDNtKNVBX5ZAquV95JcPQYrue7cQVETDqoLAUaPjmfdfVidlzE+EmPAmdYGbM7
         q4qgf/m8XpeIwvlA09dtMYqhG4hM0Xapv0ItNVH+OmyZ07pI9uVszZeEf0IOznB5733A
         YXDJjJ5wNJqLQ8Q2SO0Ghw5d2w033VcnJMrl+JMrvcJMj7OAv0XVQqtc3OX8n6iHr30Y
         oFnRZMppyD0emXOdNgAD9v6DFPtRP6AbnbNos5qvGo1HaUCVfbZoh3ovLjHWJ36pP+iu
         TVeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705359680; x=1705964480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AReH4fPhX0qnf2rGMtllGHRPMoAw4H7smgC9h2elFy0=;
        b=iHWrVLKotQF1gpignb8TZqteUSE6yg1USO616Ky6om+dRhpvG1pWtBP5Sw2tfLmtiu
         FoPmDmxI+xMrC4RlluoE45GX6Ophp3+/8rfz49mxQYPOBM4T8oWcCZoBKnlfFSrRicWK
         JOt7uzb9/X9UxGoVm2h3yw2Rjp0iyLkx286hA4aa5RMZxZixak3lCKJiu69atR5y6CAO
         GJ/7G8ILoandEAW37X+L0HULVKA5uwij26W7s1wEJHGAnq3hmCcvITHECopBPO9VgrJr
         5OoNanwmcLMAybOafGdJpdihswV9WEEpsd1HA/Eql7Qeo2rfNEjV40cRP/+jowgttOL/
         W08w==
X-Gm-Message-State: AOJu0YzXKkma5XKfSYOtL52pcJF4PBY9o1zMa7nknU+OCNofk7G0YQId
	g8Y+U1O+ancdJiPTTpLXcCGtUAQ0smF73gYFCAS2kNLkycQ=
X-Google-Smtp-Source: AGHT+IEYlcJQMm5bEb8rOiDx/77KPnN71bc52YGCAdpGz+zxZPCud2iakyhoXEj0f1EPTTWIVkPnhA==
X-Received: by 2002:a05:6808:1826:b0:3bd:5be7:def2 with SMTP id bh38-20020a056808182600b003bd5be7def2mr7489577oib.8.1705359680200;
        Mon, 15 Jan 2024 15:01:20 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id c23-20020aa78817000000b006d96dc803b3sm8366593pfo.12.2024.01.15.15.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 15:01:18 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rPVxE-00AtKJ-0l;
	Tue, 16 Jan 2024 10:01:15 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rPVxD-0000000H8fw-2xxB;
	Tue, 16 Jan 2024 10:01:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 08/12] xfs: use GFP_KERNEL in pure transaction contexts
Date: Tue, 16 Jan 2024 09:59:46 +1100
Message-ID: <20240115230113.4080105-9-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240115230113.4080105-1-david@fromorbit.com>
References: <20240115230113.4080105-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

When running in a transaction context, memory allocations are scoped
to GFP_NOFS. Hence we don't need to use GFP_NOFS contexts in pure
transaction context allocations - GFP_KERNEL will automatically get
converted to GFP_NOFS as appropriate.

Go through the code and convert all the obvious GFP_NOFS allocations
in transaction context to use GFP_KERNEL. This further reduces the
explicit use of GFP_NOFS in XFS.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c       |  3 ++-
 fs/xfs/libxfs/xfs_bmap.c       |  2 +-
 fs/xfs/libxfs/xfs_defer.c      |  6 +++---
 fs/xfs/libxfs/xfs_dir2.c       |  8 ++++----
 fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++----
 fs/xfs/libxfs/xfs_refcount.c   |  2 +-
 fs/xfs/libxfs/xfs_rmap.c       |  2 +-
 fs/xfs/xfs_attr_item.c         |  4 ++--
 fs/xfs/xfs_bmap_util.c         |  2 +-
 fs/xfs/xfs_buf.c               | 28 +++++++++++++++++-----------
 fs/xfs/xfs_log.c               |  3 ++-
 fs/xfs/xfs_mru_cache.c         |  2 +-
 12 files changed, 39 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 9976a00a73f9..269a57420859 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -891,7 +891,8 @@ xfs_attr_defer_add(
 
 	struct xfs_attr_intent	*new;
 
-	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	new = kmem_cache_zalloc(xfs_attr_intent_cache,
+			GFP_KERNEL | __GFP_NOFAIL);
 	new->xattri_op_flags = op_flags;
 	new->xattri_da_args = args;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 98aaca933bdd..fbdaa53deecd 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6098,7 +6098,7 @@ __xfs_bmap_add(
 			bmap->br_blockcount,
 			bmap->br_state);
 
-	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&bi->bi_list);
 	bi->bi_type = type;
 	bi->bi_owner = ip;
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 75689c151a54..8ae4401f6810 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -825,7 +825,7 @@ xfs_defer_alloc(
 	struct xfs_defer_pending	*dfp;
 
 	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
-			GFP_NOFS | __GFP_NOFAIL);
+			GFP_KERNEL | __GFP_NOFAIL);
 	dfp->dfp_ops = ops;
 	INIT_LIST_HEAD(&dfp->dfp_work);
 	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
@@ -888,7 +888,7 @@ xfs_defer_start_recovery(
 	struct xfs_defer_pending	*dfp;
 
 	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
-			GFP_NOFS | __GFP_NOFAIL);
+			GFP_KERNEL | __GFP_NOFAIL);
 	dfp->dfp_ops = ops;
 	dfp->dfp_intent = lip;
 	INIT_LIST_HEAD(&dfp->dfp_work);
@@ -979,7 +979,7 @@ xfs_defer_ops_capture(
 		return ERR_PTR(error);
 
 	/* Create an object to capture the defer ops. */
-	dfc = kzalloc(sizeof(*dfc), GFP_NOFS | __GFP_NOFAIL);
+	dfc = kzalloc(sizeof(*dfc), GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&dfc->dfc_list);
 	INIT_LIST_HEAD(&dfc->dfc_dfops);
 
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 728f72f0d078..8c9403b33191 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -236,7 +236,7 @@ xfs_dir_init(
 	if (error)
 		return error;
 
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -273,7 +273,7 @@ xfs_dir_createname(
 		XFS_STATS_INC(dp->i_mount, xs_dir_create);
 	}
 
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -435,7 +435,7 @@ xfs_dir_removename(
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -496,7 +496,7 @@ xfs_dir_replace(
 	if (rval)
 		return rval;
 
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 709fda3d742f..136d5d7b9de9 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -402,7 +402,7 @@ xfs_iroot_realloc(
 		if (ifp->if_broot_bytes == 0) {
 			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
 			ifp->if_broot = kmalloc(new_size,
-						GFP_NOFS | __GFP_NOFAIL);
+						GFP_KERNEL | __GFP_NOFAIL);
 			ifp->if_broot_bytes = (int)new_size;
 			return;
 		}
@@ -417,7 +417,7 @@ xfs_iroot_realloc(
 		new_max = cur_max + rec_diff;
 		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
-					 GFP_NOFS | __GFP_NOFAIL);
+					 GFP_KERNEL | __GFP_NOFAIL);
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
 		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
@@ -443,7 +443,7 @@ xfs_iroot_realloc(
 	else
 		new_size = 0;
 	if (new_size > 0) {
-		new_broot = kmalloc(new_size, GFP_NOFS | __GFP_NOFAIL);
+		new_broot = kmalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
 		/*
 		 * First copy over the btree block header.
 		 */
@@ -512,7 +512,7 @@ xfs_idata_realloc(
 
 	if (byte_diff) {
 		ifp->if_data = krealloc(ifp->if_data, new_size,
-					GFP_NOFS | __GFP_NOFAIL);
+					GFP_KERNEL | __GFP_NOFAIL);
 		if (new_size == 0)
 			ifp->if_data = NULL;
 		ifp->if_bytes = new_size;
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 6709a7f8bad5..7df52daa22cf 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1449,7 +1449,7 @@ __xfs_refcount_add(
 			blockcount);
 
 	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
-			GFP_NOFS | __GFP_NOFAIL);
+			GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
 	ri->ri_startblock = startblock;
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 76bf7f48cb5a..0bd1f47b2c2b 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2559,7 +2559,7 @@ __xfs_rmap_add(
 			bmap->br_blockcount,
 			bmap->br_state);
 
-	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
 	ri->ri_owner = owner;
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2a142cefdc3d..0bf25a2ba3b6 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -226,7 +226,7 @@ xfs_attri_init(
 {
 	struct xfs_attri_log_item	*attrip;
 
-	attrip = kmem_cache_zalloc(xfs_attri_cache, GFP_NOFS | __GFP_NOFAIL);
+	attrip = kmem_cache_zalloc(xfs_attri_cache, GFP_KERNEL | __GFP_NOFAIL);
 
 	/*
 	 * Grab an extra reference to the name/value buffer for this log item.
@@ -666,7 +666,7 @@ xfs_attr_create_done(
 
 	attrip = ATTRI_ITEM(intent);
 
-	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
+	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_KERNEL | __GFP_NOFAIL);
 
 	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
 			  &xfs_attrd_item_ops);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c2531c28905c..cb2a4b940292 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -66,7 +66,7 @@ xfs_zero_extent(
 	return blkdev_issue_zeroout(target->bt_bdev,
 		block << (mp->m_super->s_blocksize_bits - 9),
 		count_fsb << (mp->m_super->s_blocksize_bits - 9),
-		GFP_NOFS, 0);
+		GFP_KERNEL, 0);
 }
 
 /*
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a09ffbbb0dda..de99368000b4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -190,7 +190,7 @@ xfs_buf_get_maps(
 	}
 
 	bp->b_maps = kzalloc(map_count * sizeof(struct xfs_buf_map),
-				GFP_NOFS | __GFP_NOFAIL);
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	if (!bp->b_maps)
 		return -ENOMEM;
 	return 0;
@@ -222,7 +222,8 @@ _xfs_buf_alloc(
 	int			i;
 
 	*bpp = NULL;
-	bp = kmem_cache_zalloc(xfs_buf_cache, GFP_NOFS | __GFP_NOFAIL);
+	bp = kmem_cache_zalloc(xfs_buf_cache,
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 
 	/*
 	 * We don't want certain flags to appear in b_flags unless they are
@@ -325,7 +326,7 @@ xfs_buf_alloc_kmem(
 	struct xfs_buf	*bp,
 	xfs_buf_flags_t	flags)
 {
-	gfp_t		gfp_mask = GFP_NOFS | __GFP_NOFAIL;
+	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL;
 	size_t		size = BBTOB(bp->b_length);
 
 	/* Assure zeroed buffer for non-read cases. */
@@ -356,13 +357,11 @@ xfs_buf_alloc_pages(
 	struct xfs_buf	*bp,
 	xfs_buf_flags_t	flags)
 {
-	gfp_t		gfp_mask = __GFP_NOWARN;
+	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
 	long		filled = 0;
 
 	if (flags & XBF_READ_AHEAD)
 		gfp_mask |= __GFP_NORETRY;
-	else
-		gfp_mask |= GFP_NOFS;
 
 	/* Make sure that we have a page list */
 	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
@@ -429,11 +428,18 @@ _xfs_buf_map_pages(
 
 		/*
 		 * vm_map_ram() will allocate auxiliary structures (e.g.
-		 * pagetables) with GFP_KERNEL, yet we are likely to be under
-		 * GFP_NOFS context here. Hence we need to tell memory reclaim
-		 * that we are in such a context via PF_MEMALLOC_NOFS to prevent
-		 * memory reclaim re-entering the filesystem here and
-		 * potentially deadlocking.
+		 * pagetables) with GFP_KERNEL, yet we often under a scoped nofs
+		 * context here. Mixing GFP_KERNEL with GFP_NOFS allocations
+		 * from the same call site that can be run from both above and
+		 * below memory reclaim causes lockdep false positives. Hence we
+		 * always need to force this allocation to nofs context because
+		 * we can't pass __GFP_NOLOCKDEP down to auxillary structures to
+		 * prevent false positive lockdep reports.
+		 *
+		 * XXX(dgc): I think dquot reclaim is the only place we can get
+		 * to this function from memory reclaim context now. If we fix
+		 * that like we've fixed inode reclaim to avoid writeback from
+		 * reclaim, this nofs wrapping can go away.
 		 */
 		nofs_flag = memalloc_nofs_save();
 		do {
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ee39639bb92b..1f68569e62ca 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3518,7 +3518,8 @@ xlog_ticket_alloc(
 	struct xlog_ticket	*tic;
 	int			unit_res;
 
-	tic = kmem_cache_zalloc(xfs_log_ticket_cache, GFP_NOFS | __GFP_NOFAIL);
+	tic = kmem_cache_zalloc(xfs_log_ticket_cache,
+			GFP_KERNEL | __GFP_NOFAIL);
 
 	unit_res = xlog_calc_unit_res(log, unit_bytes, &tic->t_iclog_hdrs);
 
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index ce496704748d..7443debaffd6 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -428,7 +428,7 @@ xfs_mru_cache_insert(
 	if (!mru || !mru->lists)
 		return -EINVAL;
 
-	if (radix_tree_preload(GFP_NOFS))
+	if (radix_tree_preload(GFP_KERNEL))
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&elem->list_node);
-- 
2.43.0

