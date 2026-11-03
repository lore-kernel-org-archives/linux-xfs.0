Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.64
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793681496;
	b=yo7W4e198vNhFZ3iVcpUJ7RKYnw4CZ2jzAEXxQuMUXkfbogtooI/RAMbQyGlp0RnVYyL
	 3XGux2uech7wpKc40YGsVVO71JZCgl0S7M/nE7RsrTyjvse3oflNyHBBnycBcdgjzs5uF
	 wn+KxrMeVcY3lI6ejvD8oYqIKBkjh/M5Zi5i5Q2QUKVmo9Q7pdsM38bJWEqHC+GMCVeZ0
	 r55Tyd5efONQrsEiXlOzfniTyyaaLdzThBTpM8pk4T7siymp7T3Iq3gBrvTUmV0ZUht0P
	 3xzz2zgCorJmzQfDknSeroN9e/QAS3/5BzA9EDS01yQHZeBYETrhU0JfjLFn8thCmog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793681496;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=fd+wMcCOKOdTaezQs0U03el5N54RhGPDas6JR+Ra5Z0=;
	b=C9xeOJlzulrMYwKBx2yd5B07O4xqRu/JQtb1HiUjEWM1TkGTmHD8J087YYsUxhIZ4WRe
	 BDT7mez6f3Kf+LNpvc1SH1vxoFos96U9KJdtGmGxVIP+Nsnu8RNBxaGS29xsqh8640rNV
	 q/842icNsARO+xm5emuf6cvie58KBTNfg/+WCMTz7yl8P6l3ZbqEiy6vGSk68QsxMnTOS
	 ST4on9z3z9WuPfk4MWDBhMihIHnFmVV7igDEaLlymUvhGNQnXSWPhIxeIIijf2ouKT1ff
	 uKQBlAuM85PNTWS0qtRmeexZTraF6uLIktHH64Zg8jAZWlUfMkHiccqhMYud5JYBs8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lSglxeAl;
	arc=none smtp.remote-ip=95.215.58.64
Received: from mta1.migadu.com (out-64.mta1.migadu.com [95.215.58.64])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238C5606A32D
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 04:51:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 238C5606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lSglxeAl
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oS3G7YTuGm7Wj/oTYe68peuLJlvFaQ35fQbGEbUos/c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793681492; v=1; x=1794286292;
 b=lSglxeAlLUXLy5G5vVBEy4kfOtR1/0okj4vHO1hfBR3g0n5+GcQoeho6QrsfdWCkzyMH6tJA
 RkCQm+PH6bpPpjZmFnVtntUMWQ70fiifeJCeavosgSfbfjRScLEaBi2hdb5d7VDFYB2+z76M868
 tw23cHgtw/9zGfHaWrvLPOvU=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bd5412f0d877ae2f;
	Tue, 03 Nov 2026 04:51:31 +0000
X-Mizu-Trace-ID: bd5412f0d877ae2f
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: gregkh@linuxfoundation.org,
	arve@android.com,
	tkjos@android.com,
	brauner@kernel.org,
	cmllamas@google.com,
	aliceryhl@google.com,
	nat@pixelcluster.dev,
	arunpravin.paneerselvam@amd.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	viro@zeniv.linux.org.uk,
	agruenba@redhat.com,
	trondmy@kernel.org,
	anna@kernel.org,
	cel@kernel.org,
	jlayton@kernel.org,
	cem@kernel.org,
	akpm@linux-foundation.org,
	david@fromorbit.com,
	david@kernel.org,
	hughd@google.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com
Cc: matthew.auld@intel.com,
	matthew.brost@intel.com,
	thomas.hellstrom@linux.intel.com,
	jack@suse.cz,
	neil@brown.name,
	okorniev@redhat.com,
	Dai.Ngo@oracle.com,
	tom@talpey.com,
	qi.zheng@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	mhocko@kernel.org,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH] mm/list_lru: Account node removals in isolation helpers
Date: Tue,  3 Nov 2026 12:50:53 +0800
Message-ID: <20261103045053.59548-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kaitao Cheng <chengkaitao@kylinos.cn>

Successful writeback calls zswap_entry_free(), which removes the entry
from the LRU and decrements both the sublist and node item counts.
shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
to decrement the node count again.

The affected call path before this change is:

  __list_lru_walk_one()
    shrink_memcg_cb()
      zswap_writeback_entry()
        zswap_entry_free()
          zswap_lru_del()
            list_lru_del()
              __list_lru_del()
                atomic_long_dec()  /* first node count decrement */
      return LRU_REMOVED_RETRY
    atomic_long_dec()              /* second node count decrement */

During the mailing list discussion, Johannes Weiner suggested making
users of the isolation interface responsible for maintaining the item
counts, rather than having the walker decrement the node count based
on the callback's return value.

Pass the list_lru_node to walk callbacks and isolation helpers, and move
the node count decrement into list_lru_isolate() and
list_lru_isolate_move(). Reuse list_lru_isolate() in __list_lru_del() and
remove the decrement from the walker. Update all callers accordingly.

Fixes: 5878303c5353 ("mm/zswap: fix race between lru writeback and swapoff")
Closes: https://sashiko.dev/#/bug/linux-68d2ca49-23be-4504-9a75-b8526ec92388
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
Changes since v1:
- Move node accounting into list_lru isolation helpers and update all
  callers

v1: https://lore.kernel.org/all/20261028113619.38752-1-kaitao.cheng@linux.dev/
---
 drivers/android/binder/page_range.rs |  7 ++++---
 drivers/gpu/drm/ttm/ttm_pool.c       |  6 ++++--
 fs/dcache.c                          | 21 +++++++++++----------
 fs/gfs2/quota.c                      |  4 ++--
 fs/inode.c                           |  8 ++++----
 fs/nfs/nfs42xattr.c                  | 14 +++++++-------
 fs/nfsd/filecache.c                  | 15 ++++++++-------
 fs/xfs/xfs_buf.c                     | 12 +++++++-----
 fs/xfs/xfs_qm.c                      |  9 +++++----
 include/linux/list_lru.h             |  9 +++++----
 mm/huge_memory.c                     |  5 +++--
 mm/list_lru.c                        | 16 ++++++++--------
 mm/shmem.c                           |  7 ++++---
 mm/workingset.c                      |  3 ++-
 mm/zswap.c                           |  5 +++--
 15 files changed, 77 insertions(+), 64 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index b0c797523bc2..046b12aae5e5 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -685,7 +685,8 @@ fn drop(self: Pin<&mut Self>) {
 #[no_mangle]
 unsafe extern "C" fn rust_shrink_free_page(
     item: *mut bindings::list_head,
-    lru: *mut bindings::list_lru_one,
+    node: *mut bindings::list_lru_node,
+    list: *mut bindings::list_lru_one,
     _cb_arg: *mut c_void,
 ) -> bindings::lru_status {
     // Fields that should survive after unlocking the lru lock.
@@ -728,7 +729,7 @@ fn drop(self: Pin<&mut Self>) {
         };
 
         // SAFETY: The item is in this lru list, so it's okay to remove it.
-        unsafe { bindings::list_lru_isolate(lru, item) };
+        unsafe { bindings::list_lru_isolate(node, list, item) };
 
         // SAFETY: Both pointers are in bounds of the same allocation.
         page_index = unsafe { info.offset_from(inner.pages) } as usize;
@@ -746,7 +747,7 @@ fn drop(self: Pin<&mut Self>) {
     }
 
     // SAFETY: The lru lock is locked when this method is called.
-    unsafe { bindings::spin_unlock(&raw mut (*lru).lock) };
+    unsafe { bindings::spin_unlock(&raw mut (*list).lock) };
 
     if let Some(vma) = check_vma(&vma_read, range_ptr) {
         let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
index 1bf37023fed6..5b6667744d46 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -346,12 +346,13 @@ static void ttm_pool_type_give(struct ttm_pool_type *pt, struct page *p)
 }
 
 static enum lru_status take_one_from_lru(struct list_head *item,
+					 struct list_lru_node *node,
 					 struct list_lru_one *list,
 					 void *cb_arg)
 {
 	struct page **out_page = cb_arg;
 	struct page *p = container_of(item, struct page, lru);
-	list_lru_isolate(list, item);
+	list_lru_isolate(node, list, item);
 
 	*out_page = p;
 	return LRU_REMOVED;
@@ -388,12 +389,13 @@ static void ttm_pool_type_init(struct ttm_pool_type *pt, struct ttm_pool *pool,
 }
 
 static enum lru_status pool_move_to_dispose_list(struct list_head *item,
+						 struct list_lru_node *node,
 						 struct list_lru_one *list,
 						 void *cb_arg)
 {
 	struct list_head *dispose = cb_arg;
 
-	list_lru_isolate_move(list, item, dispose);
+	list_lru_isolate_move(node, list, item, dispose);
 
 	return LRU_REMOVED;
 }
diff --git a/fs/dcache.c b/fs/dcache.c
index 37d021d22a7d..d237a0b5727e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -556,24 +556,25 @@ static void d_shrink_add(struct dentry *dentry, struct list_head *list)
  * LRU lists entirely, while shrink_move moves it to the indicated
  * private list.
  */
-static void d_lru_isolate(struct list_lru_one *lru, struct dentry *dentry)
+static void d_lru_isolate(struct list_lru_node *node, struct list_lru_one *list,
+			  struct dentry *dentry)
 {
 	D_FLAG_VERIFY(dentry, DCACHE_LRU_LIST);
 	dentry->d_flags &= ~DCACHE_LRU_LIST;
 	this_cpu_dec(nr_dentry_unused);
 	if (d_is_negative(dentry))
 		this_cpu_dec(nr_dentry_negative);
-	list_lru_isolate(lru, &dentry->d_lru);
+	list_lru_isolate(node, list, &dentry->d_lru);
 }
 
-static void d_lru_shrink_move(struct list_lru_one *lru, struct dentry *dentry,
-			      struct list_head *list)
+static void d_lru_shrink_move(struct list_lru_node *node, struct list_lru_one *list,
+			      struct dentry *dentry, struct list_head *head)
 {
 	D_FLAG_VERIFY(dentry, DCACHE_LRU_LIST);
 	dentry->d_flags |= DCACHE_SHRINK_LIST;
 	if (d_is_negative(dentry))
 		this_cpu_dec(nr_dentry_negative);
-	list_lru_isolate_move(lru, &dentry->d_lru, list);
+	list_lru_isolate_move(node, list, &dentry->d_lru, head);
 }
 
 static void ___d_drop(struct dentry *dentry)
@@ -1309,7 +1310,7 @@ void shrink_dentry_list(struct list_head *list)
 EXPORT_SYMBOL(shrink_dentry_list);
 
 static enum lru_status dentry_lru_isolate(struct list_head *item,
-		struct list_lru_one *lru, void *arg)
+		struct list_lru_node *node, struct list_lru_one *list, void *arg)
 {
 	struct list_head *freeable = arg;
 	struct dentry	*dentry = container_of(item, struct dentry, d_lru);
@@ -1329,7 +1330,7 @@ static enum lru_status dentry_lru_isolate(struct list_head *item,
 	 * another pass through the LRU.
 	 */
 	if (dentry->d_lockref.count) {
-		d_lru_isolate(lru, dentry);
+		d_lru_isolate(node, list, dentry);
 		spin_unlock(&dentry->d_lock);
 		return LRU_REMOVED;
 	}
@@ -1360,7 +1361,7 @@ static enum lru_status dentry_lru_isolate(struct list_head *item,
 		return LRU_ROTATE;
 	}
 
-	d_lru_shrink_move(lru, dentry, freeable);
+	d_lru_shrink_move(node, list, dentry, freeable);
 	spin_unlock(&dentry->d_lock);
 
 	return LRU_REMOVED;
@@ -1390,7 +1391,7 @@ long prune_dcache_sb(struct super_block *sb, struct shrink_control *sc)
 }
 
 static enum lru_status dentry_lru_isolate_shrink(struct list_head *item,
-		struct list_lru_one *lru, void *arg)
+		struct list_lru_node *node, struct list_lru_one *list, void *arg)
 {
 	struct list_head *freeable = arg;
 	struct dentry	*dentry = container_of(item, struct dentry, d_lru);
@@ -1403,7 +1404,7 @@ static enum lru_status dentry_lru_isolate_shrink(struct list_head *item,
 	if (!spin_trylock(&dentry->d_lock))
 		return LRU_SKIP;
 
-	d_lru_shrink_move(lru, dentry, freeable);
+	d_lru_shrink_move(node, list, dentry, freeable);
 	spin_unlock(&dentry->d_lock);
 
 	return LRU_REMOVED;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index b2984fb7b35c..98e7b8b70459 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -149,7 +149,7 @@ static void gfs2_qd_list_dispose(struct list_head *list)
 
 
 static enum lru_status gfs2_qd_isolate(struct list_head *item,
-		struct list_lru_one *lru, void *arg)
+		struct list_lru_node *node, struct list_lru_one *list, void *arg)
 {
 	struct list_head *dispose = arg;
 	struct gfs2_quota_data *qd =
@@ -162,7 +162,7 @@ static enum lru_status gfs2_qd_isolate(struct list_head *item,
 	status = LRU_SKIP;
 	if (qd->qd_lockref.count == 0) {
 		lockref_mark_dead(&qd->qd_lockref);
-		list_lru_isolate_move(lru, &qd->qd_lru, dispose);
+		list_lru_isolate_move(node, list, &qd->qd_lru, dispose);
 		status = LRU_REMOVED;
 	}
 
diff --git a/fs/inode.c b/fs/inode.c
index 702f2d5ef459..f401cb012ae9 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -931,7 +931,7 @@ EXPORT_SYMBOL_GPL(evict_inodes);
  * with this flag set because they are the inodes that are out of order.
  */
 static enum lru_status inode_lru_isolate(struct list_head *item,
-		struct list_lru_one *lru, void *arg)
+		struct list_lru_node *node, struct list_lru_one *list, void *arg)
 {
 	struct list_head *freeable = arg;
 	struct inode	*inode = container_of(item, struct inode, i_lru);
@@ -952,7 +952,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	if (icount_read(inode) ||
 	    (inode_state_read(inode) & ~I_REFERENCED) ||
 	    !mapping_shrinkable(&inode->i_data)) {
-		list_lru_isolate(lru, &inode->i_lru);
+		list_lru_isolate(node, list, &inode->i_lru);
 		spin_unlock(&inode->i_lock);
 		this_cpu_dec(nr_unused);
 		return LRU_REMOVED;
@@ -975,7 +975,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 
 		inode_pin_lru_isolating(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&lru->lock);
+		spin_unlock(&list->lock);
 		reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
 		if (current_is_kswapd())
 			__count_vm_events(KSWAPD_INODESTEAL, reap);
@@ -988,7 +988,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 
 	WARN_ON(inode_state_read(inode) & I_NEW);
 	inode_state_set(inode, I_FREEING);
-	list_lru_isolate_move(lru, &inode->i_lru, freeable);
+	list_lru_isolate_move(node, list, &inode->i_lru, freeable);
 	spin_unlock(&inode->i_lock);
 
 	this_cpu_dec(nr_unused);
diff --git a/fs/nfs/nfs42xattr.c b/fs/nfs/nfs42xattr.c
index 37d79400e5f4..c7d306dc3381 100644
--- a/fs/nfs/nfs42xattr.c
+++ b/fs/nfs/nfs42xattr.c
@@ -801,8 +801,8 @@ static struct shrinker *nfs4_xattr_entry_shrinker;
 static struct shrinker *nfs4_xattr_large_entry_shrinker;
 
 static enum lru_status
-cache_lru_isolate(struct list_head *item,
-	struct list_lru_one *lru, void *arg)
+cache_lru_isolate(struct list_head *item, struct list_lru_node *node,
+		  struct list_lru_one *list, void *arg)
 {
 	struct list_head *dispose = arg;
 	struct inode *inode;
@@ -827,7 +827,7 @@ cache_lru_isolate(struct list_head *item,
 	cache->inode = NULL;
 	NFS_I(inode)->xattr_cache = NULL;
 	NFS_I(inode)->cache_validity &= ~NFS_INO_INVALID_XATTR;
-	list_lru_isolate(lru, &cache->lru);
+	list_lru_isolate(node, list, &cache->lru);
 
 	spin_unlock(&inode->i_lock);
 
@@ -866,8 +866,8 @@ nfs4_xattr_cache_count(struct shrinker *shrink, struct shrink_control *sc)
 }
 
 static enum lru_status
-entry_lru_isolate(struct list_head *item,
-	struct list_lru_one *lru, void *arg)
+entry_lru_isolate(struct list_head *item, struct list_lru_node *node,
+		  struct list_lru_one *list, void *arg)
 {
 	struct list_head *dispose = arg;
 	struct nfs4_xattr_bucket *bucket;
@@ -896,7 +896,7 @@ entry_lru_isolate(struct list_head *item,
 
 		hlist_del_init(&entry->hnode);
 		atomic_long_dec(&cache->nent);
-		list_lru_isolate(lru, &entry->lru);
+		list_lru_isolate(node, list, &entry->lru);
 
 		spin_unlock(&bucket->lock);
 	} else {
@@ -907,7 +907,7 @@ entry_lru_isolate(struct list_head *item,
 		kref_get(&entry->ref);
 
 		cache->listxattr = NULL;
-		list_lru_isolate(lru, &entry->lru);
+		list_lru_isolate(node, list, &entry->lru);
 
 		spin_unlock(&cache->listxattr_lock);
 	}
diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 17a94e6fcb15..e3c58f6228de 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -510,7 +510,8 @@ void nfsd_file_net_dispose(struct nfsd_net *nn)
 /**
  * nfsd_file_lru_cb - Examine an entry on the LRU list
  * @item: LRU entry to examine
- * @lru: controlling LRU
+ * @node: LRU node that accounts for @item
+ * @list: locked sublist that holds @item
  * @arg: dispose list
  *
  * Return values:
@@ -519,8 +520,8 @@ void nfsd_file_net_dispose(struct nfsd_net *nn)
  *   %LRU_SKIP: @item cannot be evicted
  */
 static enum lru_status
-nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
-		 void *arg)
+nfsd_file_lru_cb(struct list_head *item, struct list_lru_node *node,
+		 struct list_lru_one *list, void *arg)
 {
 	struct list_head *head = arg;
 	struct nfsd_file *nf = list_entry(item, struct nfsd_file, nf_lru);
@@ -554,7 +555,7 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 
 	/* Refcount went to zero. Unhash it and queue it to the dispose list */
 	nfsd_file_unhash(nf);
-	list_lru_isolate(lru, &nf->nf_lru);
+	list_lru_isolate(node, list, &nf->nf_lru);
 	list_add(&nf->nf_gc, head);
 	this_cpu_inc(nfsd_file_evictions);
 	trace_nfsd_file_gc_disposed(nf);
@@ -562,8 +563,8 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 }
 
 static enum lru_status
-nfsd_file_gc_cb(struct list_head *item, struct list_lru_one *lru,
-		 void *arg)
+nfsd_file_gc_cb(struct list_head *item, struct list_lru_node *node,
+		struct list_lru_one *list, void *arg)
 {
 	struct nfsd_file *nf = list_entry(item, struct nfsd_file, nf_lru);
 
@@ -576,7 +577,7 @@ nfsd_file_gc_cb(struct list_head *item, struct list_lru_one *lru,
 		trace_nfsd_file_gc_aged(nf);
 		return LRU_ROTATE;
 	}
-	return nfsd_file_lru_cb(item, lru, arg);
+	return nfsd_file_lru_cb(item, node, list, arg);
 }
 
 static void
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6c93b4f5629c..ce3217379c8d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1468,7 +1468,8 @@ __xfs_buf_mark_corrupt(
 static enum lru_status
 xfs_buftarg_drain_rele(
 	struct list_head	*item,
-	struct list_lru_one	*lru,
+	struct list_lru_node	*node,
+	struct list_lru_one	*list,
 	void			*arg)
 
 {
@@ -1485,7 +1486,7 @@ xfs_buftarg_drain_rele(
 	}
 
 	xfs_buf_kill(bp);
-	list_lru_isolate_move(lru, item, dispose);
+	list_lru_isolate_move(node, list, item, dispose);
 	spin_unlock(&bp->b_lockref.lock);
 	return LRU_REMOVED;
 }
@@ -1561,7 +1562,8 @@ xfs_buftarg_drain(
 static enum lru_status
 xfs_buftarg_isolate(
 	struct list_head	*item,
-	struct list_lru_one	*lru,
+	struct list_lru_node	*node,
+	struct list_lru_one	*list,
 	void			*arg)
 {
 	struct xfs_buf		*bp = container_of(item, struct xfs_buf, b_lru);
@@ -1581,7 +1583,7 @@ xfs_buftarg_isolate(
 	 * yet.
 	 */
 	if (bp->b_lockref.count > 0) {
-		list_lru_isolate(lru, &bp->b_lru);
+		list_lru_isolate(node, list, &bp->b_lru);
 		spin_unlock(&bp->b_lockref.lock);
 		return LRU_REMOVED;
 	}
@@ -1597,7 +1599,7 @@ xfs_buftarg_isolate(
 	}
 
 	xfs_buf_kill(bp);
-	list_lru_isolate_move(lru, item, dispose);
+	list_lru_isolate_move(node, list, item, dispose);
 	spin_unlock(&bp->b_lockref.lock);
 	return LRU_REMOVED;
 }
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index dd5011f578a6..11670128f68e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -412,9 +412,10 @@ struct xfs_qm_isolate {
 static enum lru_status
 xfs_qm_dquot_isolate(
 	struct list_head	*item,
-	struct list_lru_one	*lru,
+	struct list_lru_node	*node,
+	struct list_lru_one	*list,
 	void			*arg)
-		__releases(&lru->lock) __acquires(&lru->lock)
+		__releases(&list->lock) __acquires(&list->lock)
 {
 	struct xfs_dquot	*dqp = container_of(item,
 						struct xfs_dquot, q_lru);
@@ -450,7 +451,7 @@ xfs_qm_dquot_isolate(
 		XFS_STATS_INC(dqp->q_mount, xs_qm_dqwants);
 
 		trace_xfs_dqreclaim_want(dqp);
-		list_lru_isolate(lru, &dqp->q_lru);
+		list_lru_isolate(node, list, &dqp->q_lru);
 		XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot_unused);
 		return LRU_REMOVED;
 	}
@@ -473,7 +474,7 @@ xfs_qm_dquot_isolate(
 	lockref_mark_dead(&dqp->q_lockref);
 	spin_unlock(&dqp->q_lockref.lock);
 
-	list_lru_isolate_move(lru, &dqp->q_lru, &isol->dispose);
+	list_lru_isolate_move(node, list, &dqp->q_lru, &isol->dispose);
 	XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot_unused);
 	trace_xfs_dqreclaim_done(dqp);
 	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaims);
diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index a450fffe1550..c05ea3df6f42 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -271,12 +271,13 @@ static inline unsigned long list_lru_count(struct list_lru *lru)
 	return count;
 }
 
-void list_lru_isolate(struct list_lru_one *list, struct list_head *item);
-void list_lru_isolate_move(struct list_lru_one *list, struct list_head *item,
-			   struct list_head *head);
+void list_lru_isolate(struct list_lru_node *node, struct list_lru_one *list,
+		      struct list_head *item);
+void list_lru_isolate_move(struct list_lru_node *node, struct list_lru_one *list,
+			   struct list_head *item, struct list_head *head);
 
 typedef enum lru_status (*list_lru_walk_cb)(struct list_head *item,
-		struct list_lru_one *list, void *cb_arg);
+		struct list_lru_node *node, struct list_lru_one *list, void *cb_arg);
 
 /**
  * list_lru_walk_one: walk a @lru, isolating and disposing freeable items.
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e8684..92594197dd8b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4639,7 +4639,8 @@ static bool thp_underused(struct folio *folio)
 }
 
 static enum lru_status deferred_split_isolate(struct list_head *item,
-					      struct list_lru_one *lru,
+					      struct list_lru_node *node,
+					      struct list_lru_one *list,
 					      void *cb_arg)
 {
 	struct folio *folio = container_of(item, struct folio, _deferred_list);
@@ -4649,7 +4650,7 @@ static enum lru_status deferred_split_isolate(struct list_head *item,
 	if (!folio_try_get(folio))
 		return LRU_SKIP;
 
-	list_lru_isolate_move(lru, item, freeable);
+	list_lru_isolate_move(node, list, item, freeable);
 	return LRU_REMOVED;
 }
 
diff --git a/mm/list_lru.c b/mm/list_lru.c
index d1d256822ccc..50dfb292e23c 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -211,9 +211,7 @@ bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
 		    struct list_head *item, int nid)
 {
 	if (!list_empty(item)) {
-		list_del_init(item);
-		l->nr_items--;
-		atomic_long_dec(&lru->node[nid].nr_items);
+		list_lru_isolate(&lru->node[nid], l, item);
 		return true;
 	}
 	return false;
@@ -291,18 +289,21 @@ bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
 }
 EXPORT_SYMBOL_GPL(list_lru_del_obj);
 
-void list_lru_isolate(struct list_lru_one *list, struct list_head *item)
+void list_lru_isolate(struct list_lru_node *node, struct list_lru_one *list,
+		      struct list_head *item)
 {
 	list_del_init(item);
 	list->nr_items--;
+	atomic_long_dec(&node->nr_items);
 }
 EXPORT_SYMBOL_GPL(list_lru_isolate);
 
-void list_lru_isolate_move(struct list_lru_one *list, struct list_head *item,
-			   struct list_head *head)
+void list_lru_isolate_move(struct list_lru_node *node, struct list_lru_one *list,
+			   struct list_head *item, struct list_head *head)
 {
 	list_move(item, head);
 	list->nr_items--;
+	atomic_long_dec(&node->nr_items);
 }
 EXPORT_SYMBOL_GPL(list_lru_isolate_move);
 
@@ -359,7 +360,7 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 			break;
 		--*nr_to_walk;
 
-		ret = isolate(item, l, cb_arg);
+		ret = isolate(item, nlru, l, cb_arg);
 		switch (ret) {
 		/*
 		 * LRU_RETRY, LRU_REMOVED_RETRY and LRU_STOP will drop the lru
@@ -371,7 +372,6 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 			fallthrough;
 		case LRU_REMOVED:
 			isolated++;
-			atomic_long_dec(&nlru->nr_items);
 			if (ret == LRU_REMOVED_RETRY)
 				goto restart;
 			break;
diff --git a/mm/shmem.c b/mm/shmem.c
index a6e3c9c7f72d..1350d725ebb2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -853,7 +853,8 @@ struct shmem_unused_huge_scan {
 };
 
 static enum lru_status shmem_unused_huge_isolate(struct list_head *item,
-						 struct list_lru_one *lru,
+						 struct list_lru_node *node,
+						 struct list_lru_one *list,
 						 void *arg)
 {
 	struct shmem_unused_huge_scan *scan = arg;
@@ -874,14 +875,14 @@ static enum lru_status shmem_unused_huge_isolate(struct list_head *item,
 	inode = igrab(&info->vfs_inode);
 	/* inode is about to be evicted */
 	if (!inode) {
-		list_lru_isolate(lru, item);
+		list_lru_isolate(node, list, item);
 		objcg = shmem_get_and_clear_objcg(info);
 		spin_unlock(&info->lock);
 		obj_cgroup_put(objcg);
 		return LRU_REMOVED;
 	}
 
-	list_lru_isolate(lru, item);
+	list_lru_isolate(node, list, item);
 	objcg = shmem_get_and_clear_objcg(info);
 	set_shmem_unused_huge_isolated(info);
 	list_add_tail(&info->shrinklist, &scan->list);
diff --git a/mm/workingset.c b/mm/workingset.c
index 1504f91cdca5..df21529b7988 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -707,6 +707,7 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 }
 
 static enum lru_status shadow_lru_isolate(struct list_head *item,
+					  struct list_lru_node *nlru,
 					  struct list_lru_one *lru,
 					  void *arg) __must_hold(lru->lock)
 {
@@ -745,7 +746,7 @@ static enum lru_status shadow_lru_isolate(struct list_head *item,
 		}
 	}
 
-	list_lru_isolate(lru, item);
+	list_lru_isolate(nlru, lru, item);
 	__dec_node_page_state(virt_to_page(node), WORKINGSET_NODES);
 
 	spin_unlock(&lru->lock);
diff --git a/mm/zswap.c b/mm/zswap.c
index ad01c691a263..4834d2002083 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1177,8 +1177,9 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
  *    can expect from writeback. We scale down the number of objects available
  *    for reclaim by this ratio.
  */
-static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
-				       void *arg)
+static enum lru_status shrink_memcg_cb(struct list_head *item,
+				       struct list_lru_node *node,
+				       struct list_lru_one *l, void *arg)
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
 	bool *encountered_page_in_swapcache = (bool *)arg;
-- 
2.53.0

