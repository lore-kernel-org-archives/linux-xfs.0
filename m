Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7C81B7F4
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 23:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="qvFbP8HB"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-206b77b9f4bso3279147fac.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 15:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705359682; x=1705964482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SV9QjzfGsvQbo1gkDdrlKefSvyf8EjT8FJkpSDYyly0=;
        b=qvFbP8HB83tja9vH1g6U7uaiDqQ589lpghp33cG6BQ/8PxGxj11/IWP/ZhGtflNNe0
         vP8Hk5R/Fv/iB/2eusMNzt3bfG3iB7VcSek65NZsPWs3w/vlT3lga926BaA7tjbsW1vk
         d6PaNJuPoojwXJc3+TYfmVLSEff5QQRpFqgKR0IWVUYadIYS3bcrci8rTdLnDbJh4LGV
         y9EwRtoXRyDNbDLXe0FHZHgkx9JE6+EYElmJ6RP4S/Fv+ucCQjmDGnweWRC0MZZ6R9em
         VKW95HU82iQucvXJAtbAyK65CcOWVrBsTcFfvN3IRC/WzxvjZQDVofU0rAricmI9tM0m
         WY0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705359682; x=1705964482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SV9QjzfGsvQbo1gkDdrlKefSvyf8EjT8FJkpSDYyly0=;
        b=OPK5U2E7XjsyrX7JkJTBqjZaKjonG7JK4vG4T1BuLNCoOX9lqr05fEiiuPRIPL8xBl
         4CCeTWXRbNTxztoBuPJnWpmaOWGnJPxiF7BLCpXsQB63vUFBwEDHteSzEcnXzfkTIxX/
         TMVj+i43ISwtQ8rVvpOsVl6GhOl1b2463TvNI6ZXxcV0D08SuxmUEHsIfbkWgQFOwl11
         6xDRliCjKb9cXSj6vXc8HC9Viv91leH6xOj4Bnw+YzWb/ERj6uUDGgvGRQ6SghWKip8q
         ixqPAGWnvdOTpMhE/o/CnV3fobe7tDyohPP9B+C8OSXtds7dIOcVExCVEMpfoXU2HSs6
         dnXQ==
X-Gm-Message-State: AOJu0Yx/BxrhMr3ng2Rm3NrAiez7oirlYYvXEehndIrfcvYTGvTE5j5o
	9ZpvMWGIooOcPEkBZ8ESu2CB4/6/68v+HZGhDbJqkGV/USU=
X-Google-Smtp-Source: AGHT+IH5YyQYuAbS6UC7fILc/Ang/MLpCQ2O5Fowtke05VgEuDlesHyvrDLX7ibqM9BNUcYWC4ee+g==
X-Received: by 2002:a05:6871:514:b0:205:ffca:b185 with SMTP id s20-20020a056871051400b00205ffcab185mr10532971oal.42.1705359682310;
        Mon, 15 Jan 2024 15:01:22 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id p26-20020a635b1a000000b005cdb499acd0sm8808054pgb.42.2024.01.15.15.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 15:01:19 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rPVxE-00AtJs-02;
	Tue, 16 Jan 2024 10:01:15 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rPVxD-0000000H8d1-1yWD;
	Tue, 16 Jan 2024 10:01:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 01/12] xfs: convert kmem_zalloc() to kzalloc()
Date: Tue, 16 Jan 2024 09:59:39 +1100
Message-ID: <20240115230113.4080105-2-david@fromorbit.com>
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

There's no reason to keep the kmem_zalloc() around anymore, it's
just a thin wrapper around kmalloc(), so lets get rid of it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/kmem.h                     |  7 -------
 fs/xfs/libxfs/xfs_ag.c            |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c     |  3 ++-
 fs/xfs/libxfs/xfs_btree_staging.c |  2 +-
 fs/xfs/libxfs/xfs_da_btree.c      |  5 +++--
 fs/xfs/libxfs/xfs_defer.c         |  2 +-
 fs/xfs/libxfs/xfs_dir2.c          | 18 +++++++++---------
 fs/xfs/libxfs/xfs_iext_tree.c     | 12 ++++++++----
 fs/xfs/xfs_attr_item.c            |  4 ++--
 fs/xfs/xfs_buf.c                  |  6 +++---
 fs/xfs/xfs_buf_item.c             |  4 ++--
 fs/xfs/xfs_error.c                |  4 ++--
 fs/xfs/xfs_extent_busy.c          |  3 ++-
 fs/xfs/xfs_itable.c               |  8 ++++----
 fs/xfs/xfs_iwalk.c                |  3 ++-
 fs/xfs/xfs_log.c                  |  5 +++--
 fs/xfs/xfs_log_cil.c              |  4 ++--
 fs/xfs/xfs_log_recover.c          | 10 +++++-----
 fs/xfs/xfs_mru_cache.c            |  7 ++++---
 fs/xfs/xfs_qm.c                   |  3 ++-
 fs/xfs/xfs_refcount_item.c        |  4 ++--
 fs/xfs/xfs_rmap_item.c            |  3 ++-
 fs/xfs/xfs_trans_ail.c            |  3 ++-
 23 files changed, 64 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index b987dc2c6851..bce31182c9e8 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -62,13 +62,6 @@ static inline void  kmem_free(const void *ptr)
 	kvfree(ptr);
 }
 
-
-static inline void *
-kmem_zalloc(size_t size, xfs_km_flags_t flags)
-{
-	return kmem_alloc(size, flags | KM_ZERO);
-}
-
 /*
  * Zone interfaces
  */
diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 39d9525270b7..96a6bfd58931 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -381,7 +381,7 @@ xfs_initialize_perag(
 			continue;
 		}
 
-		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
+		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (!pag) {
 			error = -ENOMEM;
 			goto out_unwind_new_pags;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6374bf107242..ab4223bf51ee 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2250,7 +2250,8 @@ xfs_attr3_leaf_unbalance(
 		struct xfs_attr_leafblock *tmp_leaf;
 		struct xfs_attr3_icleaf_hdr tmphdr;
 
-		tmp_leaf = kmem_zalloc(state->args->geo->blksize, 0);
+		tmp_leaf = kzalloc(state->args->geo->blksize,
+				GFP_KERNEL | __GFP_NOFAIL);
 
 		/*
 		 * Copy the header into the temp leaf so that all the stuff
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index e276eba87cb1..eff29425fd76 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -406,7 +406,7 @@ xfs_btree_bload_prep_block(
 
 		/* Allocate a new incore btree root block. */
 		new_size = bbl->iroot_size(cur, level, nr_this_block, priv);
-		ifp->if_broot = kmem_zalloc(new_size, 0);
+		ifp->if_broot = kzalloc(new_size, GFP_KERNEL);
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 5457188bb4de..73aae6543906 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2518,7 +2518,7 @@ xfs_dabuf_map(
 	int			error = 0, nirecs, i;
 
 	if (nfsb > 1)
-		irecs = kmem_zalloc(sizeof(irec) * nfsb, KM_NOFS);
+		irecs = kzalloc(sizeof(irec) * nfsb, GFP_NOFS | __GFP_NOFAIL);
 
 	nirecs = nfsb;
 	error = xfs_bmapi_read(dp, bno, nfsb, irecs, &nirecs,
@@ -2531,7 +2531,8 @@ xfs_dabuf_map(
 	 * larger one that needs to be free by the caller.
 	 */
 	if (nirecs > 1) {
-		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map), KM_NOFS);
+		map = kzalloc(nirecs * sizeof(struct xfs_buf_map),
+				GFP_NOFS | __GFP_NOFAIL);
 		if (!map) {
 			error = -ENOMEM;
 			goto out_free_irecs;
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 66a17910d021..07d318b1f807 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -979,7 +979,7 @@ xfs_defer_ops_capture(
 		return ERR_PTR(error);
 
 	/* Create an object to capture the defer ops. */
-	dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
+	dfc = kzalloc(sizeof(*dfc), GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&dfc->dfc_list);
 	INIT_LIST_HEAD(&dfc->dfc_dfops);
 
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index a76673281514..54915a302e96 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -104,10 +104,10 @@ xfs_da_mount(
 	ASSERT(mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
 	ASSERT(xfs_dir2_dirblock_bytes(&mp->m_sb) <= XFS_MAX_BLOCKSIZE);
 
-	mp->m_dir_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
-				    KM_MAYFAIL);
-	mp->m_attr_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
-				     KM_MAYFAIL);
+	mp->m_dir_geo = kzalloc(sizeof(struct xfs_da_geometry),
+				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	mp->m_attr_geo = kzalloc(sizeof(struct xfs_da_geometry),
+				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!mp->m_dir_geo || !mp->m_attr_geo) {
 		kmem_free(mp->m_dir_geo);
 		kmem_free(mp->m_attr_geo);
@@ -236,7 +236,7 @@ xfs_dir_init(
 	if (error)
 		return error;
 
-	args = kmem_zalloc(sizeof(*args), KM_NOFS);
+	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -273,7 +273,7 @@ xfs_dir_createname(
 		XFS_STATS_INC(dp->i_mount, xs_dir_create);
 	}
 
-	args = kmem_zalloc(sizeof(*args), KM_NOFS);
+	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -372,7 +372,7 @@ xfs_dir_lookup(
 	 * lockdep Doing this avoids having to add a bunch of lockdep class
 	 * annotations into the reclaim path for the ilock.
 	 */
-	args = kmem_zalloc(sizeof(*args), KM_NOFS);
+	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 	args->geo = dp->i_mount->m_dir_geo;
 	args->name = name->name;
 	args->namelen = name->len;
@@ -441,7 +441,7 @@ xfs_dir_removename(
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
-	args = kmem_zalloc(sizeof(*args), KM_NOFS);
+	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -502,7 +502,7 @@ xfs_dir_replace(
 	if (rval)
 		return rval;
 
-	args = kmem_zalloc(sizeof(*args), KM_NOFS);
+	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index f4e6b200cdf8..4522f3c7a23f 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -398,7 +398,8 @@ static void
 xfs_iext_grow(
 	struct xfs_ifork	*ifp)
 {
-	struct xfs_iext_node	*node = kmem_zalloc(NODE_SIZE, KM_NOFS);
+	struct xfs_iext_node	*node = kzalloc(NODE_SIZE,
+						GFP_NOFS | __GFP_NOFAIL);
 	int			i;
 
 	if (ifp->if_height == 1) {
@@ -454,7 +455,8 @@ xfs_iext_split_node(
 	int			*nr_entries)
 {
 	struct xfs_iext_node	*node = *nodep;
-	struct xfs_iext_node	*new = kmem_zalloc(NODE_SIZE, KM_NOFS);
+	struct xfs_iext_node	*new = kzalloc(NODE_SIZE,
+						GFP_NOFS | __GFP_NOFAIL);
 	const int		nr_move = KEYS_PER_NODE / 2;
 	int			nr_keep = nr_move + (KEYS_PER_NODE & 1);
 	int			i = 0;
@@ -542,7 +544,8 @@ xfs_iext_split_leaf(
 	int			*nr_entries)
 {
 	struct xfs_iext_leaf	*leaf = cur->leaf;
-	struct xfs_iext_leaf	*new = kmem_zalloc(NODE_SIZE, KM_NOFS);
+	struct xfs_iext_leaf	*new = kzalloc(NODE_SIZE,
+						GFP_NOFS | __GFP_NOFAIL);
 	const int		nr_move = RECS_PER_LEAF / 2;
 	int			nr_keep = nr_move + (RECS_PER_LEAF & 1);
 	int			i;
@@ -583,7 +586,8 @@ xfs_iext_alloc_root(
 {
 	ASSERT(ifp->if_bytes == 0);
 
-	ifp->if_data = kmem_zalloc(sizeof(struct xfs_iext_rec), KM_NOFS);
+	ifp->if_data = kzalloc(sizeof(struct xfs_iext_rec),
+					GFP_NOFS | __GFP_NOFAIL);
 	ifp->if_height = 1;
 
 	/* now that we have a node step into it */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 9e02111bd890..2e454a0d6f19 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -512,8 +512,8 @@ xfs_attri_recover_work(
 	if (error)
 		return ERR_PTR(error);
 
-	attr = kmem_zalloc(sizeof(struct xfs_attr_intent) +
-			   sizeof(struct xfs_da_args), KM_NOFS);
+	attr = kzalloc(sizeof(struct xfs_attr_intent) +
+			sizeof(struct xfs_da_args), GFP_NOFS | __GFP_NOFAIL);
 	args = (struct xfs_da_args *)(attr + 1);
 
 	attr->xattri_da_args = args;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ec4bd7a24d88..710ea4c97122 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -189,8 +189,8 @@ xfs_buf_get_maps(
 		return 0;
 	}
 
-	bp->b_maps = kmem_zalloc(map_count * sizeof(struct xfs_buf_map),
-				KM_NOFS);
+	bp->b_maps = kzalloc(map_count * sizeof(struct xfs_buf_map),
+				GFP_NOFS | __GFP_NOFAIL);
 	if (!bp->b_maps)
 		return -ENOMEM;
 	return 0;
@@ -2002,7 +2002,7 @@ xfs_alloc_buftarg(
 #if defined(CONFIG_FS_DAX) && defined(CONFIG_MEMORY_FAILURE)
 	ops = &xfs_dax_holder_operations;
 #endif
-	btp = kmem_zalloc(sizeof(*btp), KM_NOFS);
+	btp = kzalloc(sizeof(*btp), GFP_NOFS | __GFP_NOFAIL);
 
 	btp->bt_mount = mp;
 	btp->bt_bdev_handle = bdev_handle;
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 023d4e0385dd..ec93d34188c8 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -805,8 +805,8 @@ xfs_buf_item_get_format(
 		return;
 	}
 
-	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
-				0);
+	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
+				GFP_KERNEL | __GFP_NOFAIL);
 }
 
 STATIC void
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index b2cbbba3e15a..456520d60cd0 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -240,8 +240,8 @@ xfs_errortag_init(
 {
 	int ret;
 
-	mp->m_errortag = kmem_zalloc(sizeof(unsigned int) * XFS_ERRTAG_MAX,
-			KM_MAYFAIL);
+	mp->m_errortag = kzalloc(sizeof(unsigned int) * XFS_ERRTAG_MAX,
+				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!mp->m_errortag)
 		return -ENOMEM;
 
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 2ccde32c9a9e..b90c3dd43e03 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -32,7 +32,8 @@ xfs_extent_busy_insert_list(
 	struct rb_node		**rbp;
 	struct rb_node		*parent = NULL;
 
-	new = kmem_zalloc(sizeof(struct xfs_extent_busy), 0);
+	new = kzalloc(sizeof(struct xfs_extent_busy),
+			GFP_KERNEL | __GFP_NOFAIL);
 	new->agno = pag->pag_agno;
 	new->bno = bno;
 	new->length = len;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 14462614fcc8..14211174267a 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -197,8 +197,8 @@ xfs_bulkstat_one(
 
 	ASSERT(breq->icount == 1);
 
-	bc.buf = kmem_zalloc(sizeof(struct xfs_bulkstat),
-			KM_MAYFAIL);
+	bc.buf = kzalloc(sizeof(struct xfs_bulkstat),
+			GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!bc.buf)
 		return -ENOMEM;
 
@@ -289,8 +289,8 @@ xfs_bulkstat(
 	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
 		return 0;
 
-	bc.buf = kmem_zalloc(sizeof(struct xfs_bulkstat),
-			KM_MAYFAIL);
+	bc.buf = kzalloc(sizeof(struct xfs_bulkstat),
+			GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!bc.buf)
 		return -ENOMEM;
 
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index b3275e8d47b6..8dbb7c054b28 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -663,7 +663,8 @@ xfs_iwalk_threaded(
 		if (xfs_pwork_ctl_want_abort(&pctl))
 			break;
 
-		iwag = kmem_zalloc(sizeof(struct xfs_iwalk_ag), 0);
+		iwag = kzalloc(sizeof(struct xfs_iwalk_ag),
+				GFP_KERNEL | __GFP_NOFAIL);
 		iwag->mp = mp;
 
 		/*
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a1650fc81382..d38cfaadc726 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1528,7 +1528,7 @@ xlog_alloc_log(
 	int			error = -ENOMEM;
 	uint			log2_size = 0;
 
-	log = kmem_zalloc(sizeof(struct xlog), KM_MAYFAIL);
+	log = kzalloc(sizeof(struct xlog), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!log) {
 		xfs_warn(mp, "Log allocation failed: No memory!");
 		goto out;
@@ -1605,7 +1605,8 @@ xlog_alloc_log(
 		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
 				sizeof(struct bio_vec);
 
-		iclog = kmem_zalloc(sizeof(*iclog) + bvec_size, KM_MAYFAIL);
+		iclog = kzalloc(sizeof(*iclog) + bvec_size,
+				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (!iclog)
 			goto out_free_iclog;
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 67a99d94701e..3c705f22b0ab 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -100,7 +100,7 @@ xlog_cil_ctx_alloc(void)
 {
 	struct xfs_cil_ctx	*ctx;
 
-	ctx = kmem_zalloc(sizeof(*ctx), KM_NOFS);
+	ctx = kzalloc(sizeof(*ctx), GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents.extent_list);
 	INIT_LIST_HEAD(&ctx->log_items);
@@ -1747,7 +1747,7 @@ xlog_cil_init(
 	struct xlog_cil_pcp	*cilpcp;
 	int			cpu;
 
-	cil = kmem_zalloc(sizeof(*cil), KM_MAYFAIL);
+	cil = kzalloc(sizeof(*cil), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!cil)
 		return -ENOMEM;
 	/*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1251c81e55f9..4a27ecdbb546 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2057,7 +2057,8 @@ xlog_recover_add_item(
 {
 	struct xlog_recover_item *item;
 
-	item = kmem_zalloc(sizeof(struct xlog_recover_item), 0);
+	item = kzalloc(sizeof(struct xlog_recover_item),
+			GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&item->ri_list);
 	list_add_tail(&item->ri_list, head);
 }
@@ -2187,9 +2188,8 @@ xlog_recover_add_to_trans(
 		}
 
 		item->ri_total = in_f->ilf_size;
-		item->ri_buf =
-			kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
-				    0);
+		item->ri_buf = kzalloc(item->ri_total * sizeof(xfs_log_iovec_t),
+				GFP_KERNEL | __GFP_NOFAIL);
 	}
 
 	if (item->ri_total <= item->ri_cnt) {
@@ -2332,7 +2332,7 @@ xlog_recover_ophdr_to_trans(
 	 * This is a new transaction so allocate a new recovery container to
 	 * hold the recovery ops that will follow.
 	 */
-	trans = kmem_zalloc(sizeof(struct xlog_recover), 0);
+	trans = kzalloc(sizeof(struct xlog_recover), GFP_KERNEL | __GFP_NOFAIL);
 	trans->r_log_tid = tid;
 	trans->r_lsn = be64_to_cpu(rhead->h_lsn);
 	INIT_LIST_HEAD(&trans->r_itemq);
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index f85e3b07ab44..feae3115617b 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -333,13 +333,14 @@ xfs_mru_cache_create(
 	if (!(grp_time = msecs_to_jiffies(lifetime_ms) / grp_count))
 		return -EINVAL;
 
-	if (!(mru = kmem_zalloc(sizeof(*mru), 0)))
+	mru = kzalloc(sizeof(*mru), GFP_KERNEL | __GFP_NOFAIL);
+	if (!mru)
 		return -ENOMEM;
 
 	/* An extra list is needed to avoid reaping up to a grp_time early. */
 	mru->grp_count = grp_count + 1;
-	mru->lists = kmem_zalloc(mru->grp_count * sizeof(*mru->lists), 0);
-
+	mru->lists = kzalloc(mru->grp_count * sizeof(*mru->lists),
+				GFP_KERNEL | __GFP_NOFAIL);
 	if (!mru->lists) {
 		err = -ENOMEM;
 		goto exit;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 94a7932ac570..b9d11376c88a 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -628,7 +628,8 @@ xfs_qm_init_quotainfo(
 
 	ASSERT(XFS_IS_QUOTA_ON(mp));
 
-	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(struct xfs_quotainfo), 0);
+	qinf = mp->m_quotainfo = kzalloc(sizeof(struct xfs_quotainfo),
+					GFP_KERNEL | __GFP_NOFAIL);
 
 	error = list_lru_init(&qinf->qi_lru);
 	if (error)
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 20ad8086da60..78d0cda60abf 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -143,8 +143,8 @@ xfs_cui_init(
 
 	ASSERT(nextents > 0);
 	if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
-		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
-				0);
+		cuip = kzalloc(xfs_cui_log_item_sizeof(nextents),
+				GFP_KERNEL | __GFP_NOFAIL);
 	else
 		cuip = kmem_cache_zalloc(xfs_cui_cache,
 					 GFP_KERNEL | __GFP_NOFAIL);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 79ad0087aeca..31a921fc34b2 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -142,7 +142,8 @@ xfs_rui_init(
 
 	ASSERT(nextents > 0);
 	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
-		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
+		ruip = kzalloc(xfs_rui_log_item_sizeof(nextents),
+				GFP_KERNEL | __GFP_NOFAIL);
 	else
 		ruip = kmem_cache_zalloc(xfs_rui_cache,
 					 GFP_KERNEL | __GFP_NOFAIL);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 1098452e7f95..5f206cdb40ff 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -901,7 +901,8 @@ xfs_trans_ail_init(
 {
 	struct xfs_ail	*ailp;
 
-	ailp = kmem_zalloc(sizeof(struct xfs_ail), KM_MAYFAIL);
+	ailp = kzalloc(sizeof(struct xfs_ail),
+			GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!ailp)
 		return -ENOMEM;
 
-- 
2.43.0

