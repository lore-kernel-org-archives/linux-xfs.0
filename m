Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4805B7F5E
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 03:00:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 030D3304062
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 01:00:02 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id akY1OEOXRm58Oru6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 00:59:57 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WYsqy-0006GK-1H
	for xfs@oss.sgi.com; Sat, 12 Apr 2014 07:59:56 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/9] xfs: embedd mru_elem into parent structure
Date: Sat, 12 Apr 2014 10:01:58 +0200
Message-Id: <1397289723-26243-5-git-send-email-hch@lst.de>
In-Reply-To: <1397289723-26243-1-git-send-email-hch@lst.de>
References: <1397289723-26243-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There is no need to do a separate allocation for each mru element, just
embedd the structure into the parent one in the user.  Besides saving
a memory allocation and the infrastructure required for it this also
simplifies the API.

While we do major surgery on xfs_mru_cache.c also de-typedef it and
make struct mru_cache private to the implementation file.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_filestream.c |   67 ++++++++++----------
 fs/xfs/xfs_mru_cache.c  |  155 +++++++++++++++++++----------------------------
 fs/xfs/xfs_mru_cache.h  |   31 ++++------
 3 files changed, 107 insertions(+), 146 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 12b6e77..dde529f 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -118,6 +118,7 @@ static kmem_zone_t *item_zone;
  */
 typedef struct fstrm_item
 {
+	struct xfs_mru_cache_elem mru;
 	xfs_agnumber_t	ag;	/* AG currently in use for the file/directory. */
 	xfs_inode_t	*ip;	/* inode self-pointer. */
 	xfs_inode_t	*pip;	/* Parent directory inode pointer. */
@@ -335,10 +336,10 @@ _xfs_filestream_update_ag(
 {
 	int		err = 0;
 	xfs_mount_t	*mp;
-	xfs_mru_cache_t	*cache;
 	fstrm_item_t	*item;
 	xfs_agnumber_t	old_ag;
 	xfs_inode_t	*old_pip;
+	struct xfs_mru_cache_elem *mru;
 
 	/*
 	 * Either ip is a regular file and pip is a directory, or ip is a
@@ -349,16 +350,17 @@ _xfs_filestream_update_ag(
 	              (S_ISDIR(ip->i_d.di_mode) && !pip)));
 
 	mp = ip->i_mount;
-	cache = mp->m_filestream;
 
-	item = xfs_mru_cache_lookup(cache, ip->i_ino);
-	if (item) {
+	mru = xfs_mru_cache_lookup(mp->m_filestream, ip->i_ino);
+	if (mru) {
+		item = container_of(mru, fstrm_item_t, mru);
+
 		ASSERT(item->ip == ip);
 		old_ag = item->ag;
 		item->ag = ag;
 		old_pip = item->pip;
 		item->pip = pip;
-		xfs_mru_cache_done(cache);
+		xfs_mru_cache_done(mp->m_filestream);
 
 		/*
 		 * If the AG has changed, drop the old ref and take a new one,
@@ -391,7 +393,7 @@ _xfs_filestream_update_ag(
 	item->ip = ip;
 	item->pip = pip;
 
-	err = xfs_mru_cache_insert(cache, ip->i_ino, item);
+	err = xfs_mru_cache_insert(mp->m_filestream, ip->i_ino, &item->mru);
 	if (err) {
 		kmem_zone_free(item_zone, item);
 		return err;
@@ -422,14 +424,12 @@ _xfs_filestream_update_ag(
 /* xfs_fstrm_free_func(): callback for freeing cached stream items. */
 STATIC void
 xfs_fstrm_free_func(
-	unsigned long	ino,
-	void		*data)
+	struct xfs_mru_cache_elem *mru)
 {
-	fstrm_item_t	*item  = (fstrm_item_t *)data;
+	fstrm_item_t	*item =
+		container_of(mru, fstrm_item_t, mru);
 	xfs_inode_t	*ip = item->ip;
 
-	ASSERT(ip->i_ino == ino);
-
 	xfs_iflags_clear(ip, XFS_IFILESTREAM);
 
 	/* Drop the reference taken on the AG when the item was added. */
@@ -532,7 +532,8 @@ xfs_agnumber_t
 xfs_filestream_lookup_ag(
 	xfs_inode_t	*ip)
 {
-	xfs_mru_cache_t	*cache;
+	struct xfs_mount *mp = ip->i_mount;
+	struct xfs_mru_cache_elem *mru;
 	fstrm_item_t	*item;
 	xfs_agnumber_t	ag;
 	int		ref;
@@ -542,17 +543,17 @@ xfs_filestream_lookup_ag(
 		return NULLAGNUMBER;
 	}
 
-	cache = ip->i_mount->m_filestream;
-	item = xfs_mru_cache_lookup(cache, ip->i_ino);
-	if (!item) {
+	mru = xfs_mru_cache_lookup(mp->m_filestream, ip->i_ino);
+	if (!mru) {
 		TRACE_LOOKUP(ip->i_mount, ip, NULL, NULLAGNUMBER, 0);
 		return NULLAGNUMBER;
 	}
 
+	item = container_of(mru, fstrm_item_t, mru);
 	ASSERT(ip == item->ip);
 	ag = item->ag;
 	ref = xfs_filestream_peek_ag(ip->i_mount, ag);
-	xfs_mru_cache_done(cache);
+	xfs_mru_cache_done(mp->m_filestream);
 
 	TRACE_LOOKUP(ip->i_mount, ip, item->pip, ag, ref);
 	return ag;
@@ -573,8 +574,8 @@ xfs_filestream_associate(
 	xfs_inode_t	*pip,
 	xfs_inode_t	*ip)
 {
+	struct xfs_mru_cache_elem *mru;
 	xfs_mount_t	*mp;
-	xfs_mru_cache_t	*cache;
 	fstrm_item_t	*item;
 	xfs_agnumber_t	ag, rotorstep, startag;
 	int		err = 0;
@@ -585,7 +586,6 @@ xfs_filestream_associate(
 		return -EINVAL;
 
 	mp = pip->i_mount;
-	cache = mp->m_filestream;
 
 	/*
 	 * We have a problem, Houston.
@@ -606,11 +606,13 @@ xfs_filestream_associate(
 		return 1;
 
 	/* If the parent directory is already in the cache, use its AG. */
-	item = xfs_mru_cache_lookup(cache, pip->i_ino);
-	if (item) {
+	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
+	if (mru) {
+		item = container_of(mru, fstrm_item_t, mru);
+
 		ASSERT(item->ip == pip);
 		ag = item->ag;
-		xfs_mru_cache_done(cache);
+		xfs_mru_cache_done(mp->m_filestream);
 
 		TRACE_LOOKUP(mp, pip, pip, ag, xfs_filestream_peek_ag(mp, ag));
 		err = _xfs_filestream_update_ag(ip, pip, ag);
@@ -671,17 +673,16 @@ xfs_filestream_new_ag(
 	struct xfs_bmalloca	*ap,
 	xfs_agnumber_t		*agp)
 {
+	struct xfs_mru_cache_elem *mru, *mru2;
 	int		flags, err;
 	xfs_inode_t	*ip, *pip = NULL;
 	xfs_mount_t	*mp;
-	xfs_mru_cache_t	*cache;
 	xfs_extlen_t	minlen;
 	fstrm_item_t	*dir, *file;
 	xfs_agnumber_t	ag = NULLAGNUMBER;
 
 	ip = ap->ip;
 	mp = ip->i_mount;
-	cache = mp->m_filestream;
 	minlen = ap->length;
 	*agp = NULLAGNUMBER;
 
@@ -689,8 +690,9 @@ xfs_filestream_new_ag(
 	 * Look for the file in the cache, removing it if it's found.  Doing
 	 * this allows it to be held across the dir lookup that follows.
 	 */
-	file = xfs_mru_cache_remove(cache, ip->i_ino);
-	if (file) {
+	mru = xfs_mru_cache_remove(mp->m_filestream, ip->i_ino);
+	if (mru) {
+		file = container_of(mru, fstrm_item_t, mru);
 		ASSERT(ip == file->ip);
 
 		/* Save the file's parent inode and old AG number for later. */
@@ -698,8 +700,9 @@ xfs_filestream_new_ag(
 		ag = file->ag;
 
 		/* Look for the file's directory in the cache. */
-		dir = xfs_mru_cache_lookup(cache, pip->i_ino);
-		if (dir) {
+		mru2 = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
+		if (mru2) {
+			dir = container_of(mru2, fstrm_item_t, mru);
 			ASSERT(pip == dir->ip);
 
 			/*
@@ -714,7 +717,7 @@ xfs_filestream_new_ag(
 				*agp = file->ag = dir->ag;
 			}
 
-			xfs_mru_cache_done(cache);
+			xfs_mru_cache_done(mp->m_filestream);
 		}
 
 		/*
@@ -722,9 +725,9 @@ xfs_filestream_new_ag(
 		 * function needs to be called to tidy up in the same way as if
 		 * the item had simply expired from the cache.
 		 */
-		err = xfs_mru_cache_insert(cache, ip->i_ino, file);
+		err = xfs_mru_cache_insert(mp->m_filestream, ip->i_ino, mru);
 		if (err) {
-			xfs_fstrm_free_func(ip->i_ino, file);
+			xfs_fstrm_free_func(mru);
 			return err;
 		}
 
@@ -818,7 +821,5 @@ void
 xfs_filestream_deassociate(
 	xfs_inode_t	*ip)
 {
-	xfs_mru_cache_t	*cache = ip->i_mount->m_filestream;
-
-	xfs_mru_cache_delete(cache, ip->i_ino);
+	xfs_mru_cache_delete(ip->i_mount->m_filestream, ip->i_ino);
 }
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 4aa3166..f99b493 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -100,14 +100,20 @@
  * likely result in a loop in one of the lists.  That's a sure-fire recipe for
  * an infinite loop in the code.
  */
-typedef struct xfs_mru_cache_elem
-{
-	struct list_head list_node;
-	unsigned long	key;
-	void		*value;
-} xfs_mru_cache_elem_t;
+struct xfs_mru_cache {
+	struct radix_tree_root	store;     /* Core storage data structure.  */
+	struct list_head	*lists;    /* Array of lists, one per grp.  */
+	struct list_head	reap_list; /* Elements overdue for reaping. */
+	spinlock_t		lock;      /* Lock to protect this struct.  */
+	unsigned int		grp_count; /* Number of discrete groups.    */
+	unsigned int		grp_time;  /* Time period spanned by grps.  */
+	unsigned int		lru_grp;   /* Group containing time zero.   */
+	unsigned long		time_zero; /* Time first element was added. */
+	xfs_mru_cache_free_func_t free_func; /* Function pointer for freeing. */
+	struct delayed_work	work;      /* Workqueue data for reaping.   */
+	unsigned int		queued;	   /* work has been queued */
+};
 
-static kmem_zone_t		*xfs_mru_elem_zone;
 static struct workqueue_struct	*xfs_mru_reap_wq;
 
 /*
@@ -129,12 +135,12 @@ static struct workqueue_struct	*xfs_mru_reap_wq;
  */
 STATIC unsigned long
 _xfs_mru_cache_migrate(
-	xfs_mru_cache_t	*mru,
-	unsigned long	now)
+	struct xfs_mru_cache	*mru,
+	unsigned long		now)
 {
-	unsigned int	grp;
-	unsigned int	migrated = 0;
-	struct list_head *lru_list;
+	unsigned int		grp;
+	unsigned int		migrated = 0;
+	struct list_head	*lru_list;
 
 	/* Nothing to do if the data store is empty. */
 	if (!mru->time_zero)
@@ -193,11 +199,11 @@ _xfs_mru_cache_migrate(
  */
 STATIC void
 _xfs_mru_cache_list_insert(
-	xfs_mru_cache_t		*mru,
-	xfs_mru_cache_elem_t	*elem)
+	struct xfs_mru_cache	*mru,
+	struct xfs_mru_cache_elem *elem)
 {
-	unsigned int	grp = 0;
-	unsigned long	now = jiffies;
+	unsigned int		grp = 0;
+	unsigned long		now = jiffies;
 
 	/*
 	 * If the data store is empty, initialise time zero, leave grp set to
@@ -231,10 +237,10 @@ _xfs_mru_cache_list_insert(
  */
 STATIC void
 _xfs_mru_cache_clear_reap_list(
-	xfs_mru_cache_t		*mru) __releases(mru->lock) __acquires(mru->lock)
-
+	struct xfs_mru_cache	*mru)
+		__releases(mru->lock) __acquires(mru->lock)
 {
-	xfs_mru_cache_elem_t	*elem, *next;
+	struct xfs_mru_cache_elem *elem, *next;
 	struct list_head	tmp;
 
 	INIT_LIST_HEAD(&tmp);
@@ -252,15 +258,8 @@ _xfs_mru_cache_clear_reap_list(
 	spin_unlock(&mru->lock);
 
 	list_for_each_entry_safe(elem, next, &tmp, list_node) {
-
-		/* Remove the element from the reap list. */
 		list_del_init(&elem->list_node);
-
-		/* Call the client's free function with the key and value pointer. */
-		mru->free_func(elem->key, elem->value);
-
-		/* Free the element structure. */
-		kmem_zone_free(xfs_mru_elem_zone, elem);
+		mru->free_func(elem);
 	}
 
 	spin_lock(&mru->lock);
@@ -277,7 +276,8 @@ STATIC void
 _xfs_mru_cache_reap(
 	struct work_struct	*work)
 {
-	xfs_mru_cache_t		*mru = container_of(work, xfs_mru_cache_t, work.work);
+	struct xfs_mru_cache	*mru =
+		container_of(work, struct xfs_mru_cache, work.work);
 	unsigned long		now, next;
 
 	ASSERT(mru && mru->lists);
@@ -304,28 +304,16 @@ _xfs_mru_cache_reap(
 int
 xfs_mru_cache_init(void)
 {
-	xfs_mru_elem_zone = kmem_zone_init(sizeof(xfs_mru_cache_elem_t),
-	                                 "xfs_mru_cache_elem");
-	if (!xfs_mru_elem_zone)
-		goto out;
-
 	xfs_mru_reap_wq = alloc_workqueue("xfs_mru_cache", WQ_MEM_RECLAIM, 1);
 	if (!xfs_mru_reap_wq)
-		goto out_destroy_mru_elem_zone;
-
+		return -ENOMEM;
 	return 0;
-
- out_destroy_mru_elem_zone:
-	kmem_zone_destroy(xfs_mru_elem_zone);
- out:
-	return -ENOMEM;
 }
 
 void
 xfs_mru_cache_uninit(void)
 {
 	destroy_workqueue(xfs_mru_reap_wq);
-	kmem_zone_destroy(xfs_mru_elem_zone);
 }
 
 /*
@@ -336,14 +324,14 @@ xfs_mru_cache_uninit(void)
  */
 int
 xfs_mru_cache_create(
-	xfs_mru_cache_t		**mrup,
+	struct xfs_mru_cache	**mrup,
 	unsigned int		lifetime_ms,
 	unsigned int		grp_count,
 	xfs_mru_cache_free_func_t free_func)
 {
-	xfs_mru_cache_t	*mru = NULL;
-	int		err = 0, grp;
-	unsigned int	grp_time;
+	struct xfs_mru_cache	*mru = NULL;
+	int			err = 0, grp;
+	unsigned int		grp_time;
 
 	if (mrup)
 		*mrup = NULL;
@@ -400,7 +388,7 @@ exit:
  */
 static void
 xfs_mru_cache_flush(
-	xfs_mru_cache_t		*mru)
+	struct xfs_mru_cache	*mru)
 {
 	if (!mru || !mru->lists)
 		return;
@@ -420,7 +408,7 @@ xfs_mru_cache_flush(
 
 void
 xfs_mru_cache_destroy(
-	xfs_mru_cache_t		*mru)
+	struct xfs_mru_cache	*mru)
 {
 	if (!mru || !mru->lists)
 		return;
@@ -438,45 +426,29 @@ xfs_mru_cache_destroy(
  */
 int
 xfs_mru_cache_insert(
-	xfs_mru_cache_t	*mru,
-	unsigned long	key,
-	void		*value)
+	struct xfs_mru_cache	*mru,
+	unsigned long		key,
+	struct xfs_mru_cache_elem *elem)
 {
-	xfs_mru_cache_elem_t *elem;
-	int error;
+	int			error;
 
 	ASSERT(mru && mru->lists);
 	if (!mru || !mru->lists)
 		return EINVAL;
 
-	elem = kmem_zone_zalloc(xfs_mru_elem_zone, KM_SLEEP);
-	if (!elem)
+	if (radix_tree_preload(GFP_KERNEL))
 		return ENOMEM;
 
-	if (radix_tree_preload(GFP_KERNEL)) {
-		error = ENOMEM;
-		goto out_free_item;
-	}
-
 	INIT_LIST_HEAD(&elem->list_node);
 	elem->key = key;
-	elem->value = value;
 
 	spin_lock(&mru->lock);
-
 	error = -radix_tree_insert(&mru->store, key, elem);
 	radix_tree_preload_end();
-	if (error) {
-		spin_unlock(&mru->lock);
-		goto out_free_item;
-	}
-	_xfs_mru_cache_list_insert(mru, elem);
-
+	if (!error)
+		_xfs_mru_cache_list_insert(mru, elem);
 	spin_unlock(&mru->lock);
 
-	return 0;
-out_free_item:
-	kmem_zone_free(xfs_mru_elem_zone, elem);
 	return error;
 }
 
@@ -486,13 +458,12 @@ out_free_item:
  * the client data pointer for the removed element is returned, otherwise this
  * function will return a NULL pointer.
  */
-void *
+struct xfs_mru_cache_elem *
 xfs_mru_cache_remove(
-	xfs_mru_cache_t	*mru,
-	unsigned long	key)
+	struct xfs_mru_cache	*mru,
+	unsigned long		key)
 {
-	xfs_mru_cache_elem_t *elem;
-	void		*value = NULL;
+	struct xfs_mru_cache_elem *elem;
 
 	ASSERT(mru && mru->lists);
 	if (!mru || !mru->lists)
@@ -500,17 +471,11 @@ xfs_mru_cache_remove(
 
 	spin_lock(&mru->lock);
 	elem = radix_tree_delete(&mru->store, key);
-	if (elem) {
-		value = elem->value;
+	if (elem)
 		list_del(&elem->list_node);
-	}
-
 	spin_unlock(&mru->lock);
 
-	if (elem)
-		kmem_zone_free(xfs_mru_elem_zone, elem);
-
-	return value;
+	return elem;
 }
 
 /*
@@ -519,13 +484,14 @@ xfs_mru_cache_remove(
  */
 void
 xfs_mru_cache_delete(
-	xfs_mru_cache_t	*mru,
-	unsigned long	key)
+	struct xfs_mru_cache	*mru,
+	unsigned long		key)
 {
-	void		*value = xfs_mru_cache_remove(mru, key);
+	struct xfs_mru_cache_elem *elem;
 
-	if (value)
-		mru->free_func(key, value);
+	elem = xfs_mru_cache_remove(mru, key);
+	if (elem)
+		mru->free_func(elem);
 }
 
 /*
@@ -548,12 +514,12 @@ xfs_mru_cache_delete(
  * status, we need to help it get it right by annotating the path that does
  * not release the lock.
  */
-void *
+struct xfs_mru_cache_elem *
 xfs_mru_cache_lookup(
-	xfs_mru_cache_t	*mru,
-	unsigned long	key)
+	struct xfs_mru_cache	*mru,
+	unsigned long		key)
 {
-	xfs_mru_cache_elem_t *elem;
+	struct xfs_mru_cache_elem *elem;
 
 	ASSERT(mru && mru->lists);
 	if (!mru || !mru->lists)
@@ -568,7 +534,7 @@ xfs_mru_cache_lookup(
 	} else
 		spin_unlock(&mru->lock);
 
-	return elem ? elem->value : NULL;
+	return elem;
 }
 
 /*
@@ -578,7 +544,8 @@ xfs_mru_cache_lookup(
  */
 void
 xfs_mru_cache_done(
-	xfs_mru_cache_t	*mru) __releases(mru->lock)
+	struct xfs_mru_cache	*mru)
+		__releases(mru->lock)
 {
 	spin_unlock(&mru->lock);
 }
diff --git a/fs/xfs/xfs_mru_cache.h b/fs/xfs/xfs_mru_cache.h
index 36dd3ec..fb5245b 100644
--- a/fs/xfs/xfs_mru_cache.h
+++ b/fs/xfs/xfs_mru_cache.h
@@ -18,24 +18,15 @@
 #ifndef __XFS_MRU_CACHE_H__
 #define __XFS_MRU_CACHE_H__
 
+struct xfs_mru_cache;
 
-/* Function pointer type for callback to free a client's data pointer. */
-typedef void (*xfs_mru_cache_free_func_t)(unsigned long, void*);
+struct xfs_mru_cache_elem {
+	struct list_head list_node;
+	unsigned long	key;
+};
 
-typedef struct xfs_mru_cache
-{
-	struct radix_tree_root	store;     /* Core storage data structure.  */
-	struct list_head	*lists;    /* Array of lists, one per grp.  */
-	struct list_head	reap_list; /* Elements overdue for reaping. */
-	spinlock_t		lock;      /* Lock to protect this struct.  */
-	unsigned int		grp_count; /* Number of discrete groups.    */
-	unsigned int		grp_time;  /* Time period spanned by grps.  */
-	unsigned int		lru_grp;   /* Group containing time zero.   */
-	unsigned long		time_zero; /* Time first element was added. */
-	xfs_mru_cache_free_func_t free_func; /* Function pointer for freeing. */
-	struct delayed_work	work;      /* Workqueue data for reaping.   */
-	unsigned int		queued;	   /* work has been queued */
-} xfs_mru_cache_t;
+/* Function pointer type for callback to free a client's data pointer. */
+typedef void (*xfs_mru_cache_free_func_t)(struct xfs_mru_cache_elem *elem);
 
 int xfs_mru_cache_init(void);
 void xfs_mru_cache_uninit(void);
@@ -44,10 +35,12 @@ int xfs_mru_cache_create(struct xfs_mru_cache **mrup, unsigned int lifetime_ms,
 			     xfs_mru_cache_free_func_t free_func);
 void xfs_mru_cache_destroy(struct xfs_mru_cache *mru);
 int xfs_mru_cache_insert(struct xfs_mru_cache *mru, unsigned long key,
-				void *value);
-void * xfs_mru_cache_remove(struct xfs_mru_cache *mru, unsigned long key);
+		struct xfs_mru_cache_elem *elem);
+struct xfs_mru_cache_elem *
+xfs_mru_cache_remove(struct xfs_mru_cache *mru, unsigned long key);
 void xfs_mru_cache_delete(struct xfs_mru_cache *mru, unsigned long key);
-void *xfs_mru_cache_lookup(struct xfs_mru_cache *mru, unsigned long key);
+struct xfs_mru_cache_elem *
+xfs_mru_cache_lookup(struct xfs_mru_cache *mru, unsigned long key);
 void xfs_mru_cache_done(struct xfs_mru_cache *mru);
 
 #endif /* __XFS_MRU_CACHE_H__ */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
