Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8757A1B7EF
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 23:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Km9VHCQn"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5ce10b5ee01so6612262a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 15:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705359682; x=1705964482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvVUbq4f8t6Cv63H6GruWlEMt6Dq66cPsSdsWLn42bk=;
        b=Km9VHCQnmdrgAacywys6Vt5H0WxGnyLsBNMpK7DfQJESCoRbVVjSwzo8iXvgkV9h7Q
         bvaU7pvQteo96EvZRgvhgs93xVjyM3NcWmLwIPVKBg1h6uNisPmaWUcoDZDvZEAOMFM7
         VvWmD+q+e9riuJnAC0xrmXF2ZOsi5OX5DgTkdxfLmWB1Y6ijFRZd0z5haIA8/FmYJOTK
         pM/BhlrnHVDrnS4oywvezpNoZfRYRxTgNZY3lhdKAX+mXtF9SxmrJ2zvfBP64e0KWgX2
         6VXeWxTeCxUrxc2y1re0a8fzrb7pux6ExU1T3Dz8S+SVOYun/LE4XE7T9Defm7HqL+BR
         w2gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705359682; x=1705964482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DvVUbq4f8t6Cv63H6GruWlEMt6Dq66cPsSdsWLn42bk=;
        b=AKUYV/HHpWdrrentweiqLOsDBkZp9228w+l2K6Fm7ftYtdRXw+7n0pZPYnRdjT9tdl
         1p9Tn+L1jzGr64/BaHv3g4gzDOLC7/g/Svrqg4ekPQavJ+h4A7Wjsuh2vFr8aw6WMaRS
         48SzvBFkwtFVgVzpoudw5H4j+FP+HgHuIBWHs5W6TRFxKLClsIaU9c35TCV70dkD/ar2
         djXUWlEzi5kF67WjmmkgtGZwL8U1RC0ZXGYXW46ouGqggSJlHuJzgsTPSAKiGZGUMQXh
         mTw9WGuT7Yg7bfIlnW7a/hp6CSt7/UuNQpfJPh/inwP0ElOvMFNw9FCUdejbpRgpRzbp
         qxyA==
X-Gm-Message-State: AOJu0Yy81hcGBAM1J+Z2VbJ8Eod4qfLmuOjmCGh+EiOvac5sZwqJJEap
	lOB5CAM2Ga9wjAbTHp15bN+pX7jIKVSQXFcK1XrsOtl+mqQ=
X-Google-Smtp-Source: AGHT+IFaFLF0wQYlQlLLCZ8wr4ZkEhNZnxbAO8R0dD2lI0Z+w6FchnIrD8zwblq5AgkNyfZu4lZQBA==
X-Received: by 2002:a05:6a20:8407:b0:199:fe49:6bb3 with SMTP id c7-20020a056a20840700b00199fe496bb3mr9488275pzd.5.1705359681921;
        Mon, 15 Jan 2024 15:01:21 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id ff23-20020a056a002f5700b006d9361fcfc8sm8397979pfb.177.2024.01.15.15.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 15:01:19 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rPVxE-00AtKF-0f;
	Tue, 16 Jan 2024 10:01:15 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rPVxD-0000000H8fs-2pfv;
	Tue, 16 Jan 2024 10:01:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 07/12] xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS
Date: Tue, 16 Jan 2024 09:59:45 +1100
Message-ID: <20240115230113.4080105-8-david@fromorbit.com>
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

In the past we've had problems with lockdep false positives stemming
from inode locking occurring in memory reclaim contexts (e.g. from
superblock shrinkers). Lockdep doesn't know that inodes access from
above memory reclaim cannot be accessed from below memory reclaim
(and vice versa) but there has never been a good solution to solving
this problem with lockdep annotations.

This situation isn't unique to inode locks - buffers are also locked
above and below memory reclaim, and we have to maintain lock
ordering for them - and against inodes - appropriately. IOWs, the
same code paths and locks are taken both above and below memory
reclaim and so we always need to make sure the lock orders are
consistent. We are spared the lockdep problems this might cause
by the fact that semaphores and bit locks aren't covered by lockdep.

In general, this sort of lockdep false positive detection is cause
by code that runs GFP_KERNEL memory allocation with an actively
referenced inode locked. When it is run from a transaction, memory
allocation is automatically GFP_NOFS, so we don't have reclaim
recursion issues. So in the places where we do memory allocation
with inodes locked outside of a transaction, we have explicitly set
them to use GFP_NOFS allocations to prevent lockdep false positives
from being reported if the allocation dips into direct memory
reclaim.

More recently, __GFP_NOLOCKDEP was added to the memory allocation
flags to tell lockdep not to track that particular allocation for
the purposes of reclaim recursion detection. This is a much better
way of preventing false positives - it allows us to use GFP_KERNEL
context outside of transactions, and allows direct memory reclaim to
proceed normally without throwing out false positive deadlock
warnings.

The obvious places that lock inodes and do memory allocation are the
lookup paths and inode extent list initialisation. These occur in
non-transactional GFP_KERNEL contexts, and so can run direct reclaim
and lock inodes.

This patch makes a first path through all the explicit GFP_NOFS
allocations in XFS and converts the obvious ones to GFP_KERNEL |
__GFP_NOLOCKDEP as a first step towards removing explicit GFP_NOFS
allocations from the XFS code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c         |  2 +-
 fs/xfs/libxfs/xfs_btree.h      |  4 +++-
 fs/xfs/libxfs/xfs_da_btree.c   |  8 +++++---
 fs/xfs/libxfs/xfs_dir2.c       | 14 ++++----------
 fs/xfs/libxfs/xfs_iext_tree.c  | 22 +++++++++++++---------
 fs/xfs/libxfs/xfs_inode_fork.c |  8 +++++---
 fs/xfs/xfs_icache.c            |  5 ++---
 fs/xfs/xfs_qm.c                |  6 +++---
 8 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 937ea48d5cc0..036f4ee43fd3 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -389,7 +389,7 @@ xfs_initialize_perag(
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
 
-		error = radix_tree_preload(GFP_NOFS);
+		error = radix_tree_preload(GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (error)
 			goto out_free_pag;
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index d906324e25c8..75a0e2c8e115 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -725,7 +725,9 @@ xfs_btree_alloc_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = kmem_cache_zalloc(cache, GFP_NOFS | __GFP_NOFAIL);
+	/* BMBT allocations can come through from non-transactional context. */
+	cur = kmem_cache_zalloc(cache,
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 3383b4525381..444ec1560f43 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -85,7 +85,8 @@ xfs_da_state_alloc(
 {
 	struct xfs_da_state	*state;
 
-	state = kmem_cache_zalloc(xfs_da_state_cache, GFP_NOFS | __GFP_NOFAIL);
+	state = kmem_cache_zalloc(xfs_da_state_cache,
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	state->args = args;
 	state->mp = args->dp->i_mount;
 	return state;
@@ -2519,7 +2520,8 @@ xfs_dabuf_map(
 	int			error = 0, nirecs, i;
 
 	if (nfsb > 1)
-		irecs = kzalloc(sizeof(irec) * nfsb, GFP_NOFS | __GFP_NOFAIL);
+		irecs = kzalloc(sizeof(irec) * nfsb,
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 
 	nirecs = nfsb;
 	error = xfs_bmapi_read(dp, bno, nfsb, irecs, &nirecs,
@@ -2533,7 +2535,7 @@ xfs_dabuf_map(
 	 */
 	if (nirecs > 1) {
 		map = kzalloc(nirecs * sizeof(struct xfs_buf_map),
-				GFP_NOFS | __GFP_NOFAIL);
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 		if (!map) {
 			error = -ENOMEM;
 			goto out_free_irecs;
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index e60aa8f8d0a7..728f72f0d078 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -333,7 +333,8 @@ xfs_dir_cilookup_result(
 					!(args->op_flags & XFS_DA_OP_CILOOKUP))
 		return -EEXIST;
 
-	args->value = kmalloc(len, GFP_NOFS | __GFP_RETRY_MAYFAIL);
+	args->value = kmalloc(len,
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
 	if (!args->value)
 		return -ENOMEM;
 
@@ -364,15 +365,8 @@ xfs_dir_lookup(
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_lookup);
 
-	/*
-	 * We need to use KM_NOFS here so that lockdep will not throw false
-	 * positive deadlock warnings on a non-transactional lookup path. It is
-	 * safe to recurse into inode recalim in that case, but lockdep can't
-	 * easily be taught about it. Hence KM_NOFS avoids having to add more
-	 * lockdep Doing this avoids having to add a bunch of lockdep class
-	 * annotations into the reclaim path for the ilock.
-	 */
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args),
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	args->geo = dp->i_mount->m_dir_geo;
 	args->name = name->name;
 	args->namelen = name->len;
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 16f18b08fe4c..8796f2b3e534 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -394,12 +394,18 @@ xfs_iext_leaf_key(
 	return leaf->recs[n].lo & XFS_IEXT_STARTOFF_MASK;
 }
 
+static inline void *
+xfs_iext_alloc_node(
+	int	size)
+{
+	return kzalloc(size, GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
+}
+
 static void
 xfs_iext_grow(
 	struct xfs_ifork	*ifp)
 {
-	struct xfs_iext_node	*node = kzalloc(NODE_SIZE,
-						GFP_NOFS | __GFP_NOFAIL);
+	struct xfs_iext_node	*node = xfs_iext_alloc_node(NODE_SIZE);
 	int			i;
 
 	if (ifp->if_height == 1) {
@@ -455,8 +461,7 @@ xfs_iext_split_node(
 	int			*nr_entries)
 {
 	struct xfs_iext_node	*node = *nodep;
-	struct xfs_iext_node	*new = kzalloc(NODE_SIZE,
-						GFP_NOFS | __GFP_NOFAIL);
+	struct xfs_iext_node	*new = xfs_iext_alloc_node(NODE_SIZE);
 	const int		nr_move = KEYS_PER_NODE / 2;
 	int			nr_keep = nr_move + (KEYS_PER_NODE & 1);
 	int			i = 0;
@@ -544,8 +549,7 @@ xfs_iext_split_leaf(
 	int			*nr_entries)
 {
 	struct xfs_iext_leaf	*leaf = cur->leaf;
-	struct xfs_iext_leaf	*new = kzalloc(NODE_SIZE,
-						GFP_NOFS | __GFP_NOFAIL);
+	struct xfs_iext_leaf	*new = xfs_iext_alloc_node(NODE_SIZE);
 	const int		nr_move = RECS_PER_LEAF / 2;
 	int			nr_keep = nr_move + (RECS_PER_LEAF & 1);
 	int			i;
@@ -586,8 +590,7 @@ xfs_iext_alloc_root(
 {
 	ASSERT(ifp->if_bytes == 0);
 
-	ifp->if_data = kzalloc(sizeof(struct xfs_iext_rec),
-					GFP_NOFS | __GFP_NOFAIL);
+	ifp->if_data = xfs_iext_alloc_node(sizeof(struct xfs_iext_rec));
 	ifp->if_height = 1;
 
 	/* now that we have a node step into it */
@@ -607,7 +610,8 @@ xfs_iext_realloc_root(
 	if (new_size / sizeof(struct xfs_iext_rec) == RECS_PER_LEAF)
 		new_size = NODE_SIZE;
 
-	new = krealloc(ifp->if_data, new_size, GFP_NOFS | __GFP_NOFAIL);
+	new = krealloc(ifp->if_data, new_size,
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	memset(new + ifp->if_bytes, 0, new_size - ifp->if_bytes);
 	ifp->if_data = new;
 	cur->leaf = new;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index f6d5b86b608d..709fda3d742f 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -50,7 +50,8 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
-		char *new_data = kmalloc(mem_size, GFP_NOFS | __GFP_NOFAIL);
+		char *new_data = kmalloc(mem_size,
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 
 		memcpy(new_data, data, size);
 		if (zero_terminate)
@@ -205,7 +206,8 @@ xfs_iformat_btree(
 	}
 
 	ifp->if_broot_bytes = size;
-	ifp->if_broot = kmalloc(size, GFP_NOFS | __GFP_NOFAIL);
+	ifp->if_broot = kmalloc(size,
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	ASSERT(ifp->if_broot != NULL);
 	/*
 	 * Copy and convert from the on-disk structure
@@ -690,7 +692,7 @@ xfs_ifork_init_cow(
 		return;
 
 	ip->i_cowfp = kmem_cache_zalloc(xfs_ifork_cache,
-				       GFP_NOFS | __GFP_NOFAIL);
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	ip->i_cowfp->if_format = XFS_DINODE_FMT_EXTENTS;
 }
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index dba514a2c84d..06046827b5fe 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -659,10 +659,9 @@ xfs_iget_cache_miss(
 	/*
 	 * Preload the radix tree so we can insert safely under the
 	 * write spinlock. Note that we cannot sleep inside the preload
-	 * region. Since we can be called from transaction context, don't
-	 * recurse into the file system.
+	 * region.
 	 */
-	if (radix_tree_preload(GFP_NOFS)) {
+	if (radix_tree_preload(GFP_KERNEL | __GFP_NOLOCKDEP)) {
 		error = -EAGAIN;
 		goto out_destroy;
 	}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 46a7fe70e57e..384a5349e696 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -643,9 +643,9 @@ xfs_qm_init_quotainfo(
 	if (error)
 		goto out_free_lru;
 
-	INIT_RADIX_TREE(&qinf->qi_uquota_tree, GFP_NOFS);
-	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
-	INIT_RADIX_TREE(&qinf->qi_pquota_tree, GFP_NOFS);
+	INIT_RADIX_TREE(&qinf->qi_uquota_tree, GFP_KERNEL);
+	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_KERNEL);
+	INIT_RADIX_TREE(&qinf->qi_pquota_tree, GFP_KERNEL);
 	mutex_init(&qinf->qi_tree_lock);
 
 	/* mutex used to serialize quotaoffs */
-- 
2.43.0

