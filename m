Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936D7391
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711272; cv=none; b=JsfBazYGjACByam0gvs1fVOW7JuntKRsK6FGwlHW+d4dY6wgIABWuyqkvJu6y12O5vrO5Upamx+bPGO6gi9zpUHTV54Kxp1gj0Qm17+uTqT2HXTD0vKYdl0ZNfHNQVhI9nq7PuXe6MMbxkYuD6wp9k9YOqoOqjgvq6MtkQYqNUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711272; c=relaxed/simple;
	bh=aqBc0o8E5Zv3flD2QSTdm2RCAKCGhnTrCZR1CLTFRo8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HgGoBdcr4DtDYhoOm+6jB0qKWfT+a5+khliN1yZEBkue8uLXXva+IX3rVsl1DYs/cDb0qyoKdwCNGvY32KOGrsg1LKDKB0T8Fr/aAMo+/f+kQJIUj8jqFoXJo/z8DK+qZFzGkqqYbH99OBScvo8cCaPPxHynaREPRcrdYmYhdUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ftScus0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ftScus0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCDEC433F1;
	Wed, 10 Apr 2024 01:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711272;
	bh=aqBc0o8E5Zv3flD2QSTdm2RCAKCGhnTrCZR1CLTFRo8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ftScus0XhzGHTBPAk5zFZO9nWhAlS+160X2wix4ZI3idyg8SQhx+I54Q3kwFuWr/i
	 vKQwVKro0CJKfkSmeGcb9fOC9VSrUIt2Cn6XeFYONuLoHhL4pYlLXzSaZtWUC+q+ed
	 CboBLGVD3piNzRRfWqpeqYQX1fo2uUOLOQUiX8TPgglqZSssHgQF5UU3gk24obtA++
	 A/jUTItLtRIyIjNYVeM+dGv5cixADTbB+hqFB3U7x+7efc3j+IAys5uq+RGfwfO0wb
	 ikih98fbkf3/7KkQUMnfLmLlETzPKZlaPpMkP70lTel+OWeepm/mO277K1eoaa4TvL
	 Us8b2GUWvT1Sg==
Date: Tue, 09 Apr 2024 18:07:51 -0700
Subject: [PATCH 2/4] xfs: invalidate dirloop scrub path data when concurrent
 updates happen
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270971623.3633329.11977689827599930758.stgit@frogsfrogsfrogs>
In-Reply-To: <171270971578.3633329.3916047777798574829.stgit@frogsfrogsfrogs>
References: <171270971578.3633329.3916047777798574829.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a dirent update hook so that we can detect directory tree updates
that affect any of the paths found by this scrubber and force it to
rescan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dirtree.c |  160 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/dirtree.h |   20 ++++++
 fs/xfs/scrub/trace.h   |   65 ++++++++++++++++++++
 3 files changed, 244 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 2461e525b3d70..1d41dc9a4d00f 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -70,6 +70,9 @@ xchk_dirtree_buf_cleanup(
 	struct xchk_dirtree	*dl = buf;
 	struct xchk_dirpath	*path, *n;
 
+	if (dl->scan_ino != NULLFSINO)
+		xfs_dir_hook_del(dl->sc->mp, &dl->dhook);
+
 	xchk_dirtree_for_each_path_safe(dl, path, n) {
 		list_del_init(&path->list);
 		xino_bitmap_destroy(&path->seen_inodes);
@@ -90,13 +93,17 @@ xchk_setup_dirtree(
 	char			*descr;
 	int			error;
 
+	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
+
 	dl = kvzalloc(sizeof(struct xchk_dirtree), XCHK_GFP_FLAGS);
 	if (!dl)
 		return -ENOMEM;
 	dl->sc = sc;
 	dl->xname.name = dl->namebuf;
+	dl->hook_xname.name = dl->hook_namebuf;
 	INIT_LIST_HEAD(&dl->path_list);
 	dl->root_ino = NULLFSINO;
+	dl->scan_ino = NULLFSINO;
 
 	mutex_init(&dl->lock);
 
@@ -552,6 +559,133 @@ xchk_dirpath_walk_upwards(
 	return error;
 }
 
+/*
+ * Decide if this path step has been touched by this live update.  Returns
+ * 1 for yes, 0 for no, or a negative errno.
+ */
+STATIC int
+xchk_dirpath_step_is_stale(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirpath		*path,
+	unsigned int			step_nr,
+	xfarray_idx_t			step_idx,
+	struct xfs_dir_update_params	*p,
+	xfs_ino_t			*cursor)
+{
+	struct xchk_dirpath_step	step;
+	xfs_ino_t			child_ino = *cursor;
+	int				error;
+
+	error = xfarray_load(dl->path_steps, step_idx, &step);
+	if (error)
+		return error;
+	*cursor = be64_to_cpu(step.pptr_rec.p_ino);
+
+	/*
+	 * If the parent and child being updated are not the ones mentioned in
+	 * this path step, the scan data is still ok.
+	 */
+	if (p->ip->i_ino != child_ino || p->dp->i_ino != *cursor)
+		return 0;
+
+	/*
+	 * If the dirent name lengths or byte sequences are different, the scan
+	 * data is still ok.
+	 */
+	if (p->name->len != step.name_len)
+		return 0;
+
+	error = xfblob_loadname(dl->path_names, step.name_cookie,
+			&dl->hook_xname, step.name_len);
+	if (error)
+		return error;
+
+	if (memcmp(dl->hook_xname.name, p->name->name, p->name->len) != 0)
+		return 0;
+
+	/* Exact match, scan data is out of date. */
+	trace_xchk_dirpath_changed(dl->sc, path->path_nr, step_nr, p->dp,
+			p->ip, p->name);
+	return 1;
+}
+
+/*
+ * Decide if this path has been touched by this live update.  Returns 1 for
+ * yes, 0 for no, or a negative errno.
+ */
+STATIC int
+xchk_dirpath_is_stale(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirpath		*path,
+	struct xfs_dir_update_params	*p)
+{
+	xfs_ino_t			cursor = dl->scan_ino;
+	xfarray_idx_t			idx = path->first_step;
+	unsigned int			i;
+	int				ret;
+
+	/*
+	 * The child being updated has not been seen by this path at all; this
+	 * path cannot be stale.
+	 */
+	if (!xino_bitmap_test(&path->seen_inodes, p->ip->i_ino))
+		return 0;
+
+	ret = xchk_dirpath_step_is_stale(dl, path, 0, idx, p, &cursor);
+	if (ret != 0)
+		return ret;
+
+	for (i = 1, idx = path->second_step; i < path->nr_steps; i++, idx++) {
+		ret = xchk_dirpath_step_is_stale(dl, path, i, idx, p, &cursor);
+		if (ret != 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Decide if a directory update from the regular filesystem touches any of the
+ * paths we've scanned, and invalidate the scan data if true.
+ */
+STATIC int
+xchk_dirtree_live_update(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_dir_update_params	*p = data;
+	struct xchk_dirtree		*dl;
+	struct xchk_dirpath		*path;
+	int				ret;
+
+	dl = container_of(nb, struct xchk_dirtree, dhook.dirent_hook.nb);
+
+	trace_xchk_dirtree_live_update(dl->sc, p->dp, action, p->ip, p->delta,
+			p->name);
+
+	mutex_lock(&dl->lock);
+
+	if (dl->stale || dl->aborted)
+		goto out_unlock;
+
+	xchk_dirtree_for_each_path(dl, path) {
+		ret = xchk_dirpath_is_stale(dl, path, p);
+		if (ret < 0) {
+			dl->aborted = true;
+			break;
+		}
+		if (ret == 1) {
+			dl->stale = true;
+			break;
+		}
+	}
+
+out_unlock:
+	mutex_unlock(&dl->lock);
+	return NOTIFY_DONE;
+}
+
 /* Delete all the collected path information. */
 STATIC void
 xchk_dirtree_reset(
@@ -667,6 +801,8 @@ xchk_dirtree_find_paths_to_root(
 			}
 			if (error)
 				return error;
+			if (dl->aborted)
+				return 0;
 		}
 	} while (dl->stale);
 
@@ -738,11 +874,28 @@ xchk_dirtree(
 
 	ASSERT(xfs_has_parent(sc->mp));
 
-	/* Find the root of the directory tree. */
+	/*
+	 * Find the root of the directory tree.  Remember which directory to
+	 * scan, because the hook doesn't detach until after sc->ip gets
+	 * released during teardown.
+	 */
 	dl->root_ino = sc->mp->m_rootip->i_ino;
+	dl->scan_ino = sc->ip->i_ino;
 
 	trace_xchk_dirtree_start(sc->ip, sc->sm, 0);
 
+	/*
+	 * Hook into the directory entry code so that we can capture updates to
+	 * paths that we have already scanned.  The scanner thread takes each
+	 * directory's ILOCK, which means that any in-progress directory update
+	 * will finish before we can scan the directory.
+	 */
+	ASSERT(sc->flags & XCHK_FSGATES_DIRENTS);
+	xfs_dir_hook_setup(&dl->dhook, xchk_dirtree_live_update);
+	error = xfs_dir_hook_add(sc->mp, &dl->dhook);
+	if (error)
+		goto out;
+
 	mutex_lock(&dl->lock);
 
 	/* Trace each parent pointer's path to the root. */
@@ -769,6 +922,10 @@ xchk_dirtree(
 	}
 	if (error)
 		goto out_scanlock;
+	if (dl->aborted) {
+		xchk_set_incomplete(sc);
+		goto out_scanlock;
+	}
 
 	/* Assess what we found in our path evaluation. */
 	xchk_dirtree_evaluate(dl, &oc);
@@ -784,6 +941,7 @@ xchk_dirtree(
 
 out_scanlock:
 	mutex_unlock(&dl->lock);
+out:
 	trace_xchk_dirtree_done(sc->ip, sc->sm, error);
 	return error;
 }
diff --git a/fs/xfs/scrub/dirtree.h b/fs/xfs/scrub/dirtree.h
index 50fefd64ae508..2ddbcf43c2915 100644
--- a/fs/xfs/scrub/dirtree.h
+++ b/fs/xfs/scrub/dirtree.h
@@ -72,6 +72,13 @@ struct xchk_dirtree {
 	/* Root inode that we're looking for. */
 	xfs_ino_t		root_ino;
 
+	/*
+	 * This is the inode that we're scanning.  The live update hook can
+	 * continue to be called after xchk_teardown drops sc->ip but before
+	 * it calls buf_cleanup, so we keep a copy.
+	 */
+	xfs_ino_t		scan_ino;
+
 	/* Scratch buffer for scanning pptr xattrs */
 	struct xfs_parent_rec	pptr_rec;
 	struct xfs_da_args	pptr_args;
@@ -80,9 +87,19 @@ struct xchk_dirtree {
 	struct xfs_name		xname;
 	char			namebuf[MAXNAMELEN];
 
+	/*
+	 * Hook into directory updates so that we can receive live updates
+	 * from other writer threads.
+	 */
+	struct xfs_dir_hook	dhook;
+
 	/* lock for everything below here */
 	struct mutex		lock;
 
+	/* buffer for the live update functions to use for dirent names */
+	struct xfs_name		hook_xname;
+	unsigned char		hook_namebuf[MAXNAMELEN];
+
 	/*
 	 * All path steps observed during this scan.  Each of the path
 	 * steps for a particular pathwalk are recorded in sequential
@@ -106,6 +123,9 @@ struct xchk_dirtree {
 
 	/* Have the path data been invalidated by a concurrent update? */
 	bool			stale:1;
+
+	/* Has the scan been aborted? */
+	bool			aborted:1;
 };
 
 #define xchk_dirtree_for_each_path_safe(dl, path, n) \
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index c474bcd7d54b7..509b6f4fd0cd3 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1764,6 +1764,71 @@ DEFINE_EVENT(xchk_dirtree_evaluate_class, name, \
 	TP_ARGS(dl, oc))
 DEFINE_XCHK_DIRTREE_EVALUATE_EVENT(xchk_dirtree_evaluate);
 
+TRACE_EVENT(xchk_dirpath_changed,
+	TP_PROTO(struct xfs_scrub *sc, unsigned int path_nr,
+		 unsigned int step_nr, const struct xfs_inode *dp,
+		 const struct xfs_inode *ip, const struct xfs_name *xname),
+	TP_ARGS(sc, path_nr, step_nr, dp, ip, xname),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, path_nr)
+		__field(unsigned int, step_nr)
+		__field(xfs_ino_t, child_ino)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, xname->len)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->path_nr = path_nr;
+		__entry->step_nr = step_nr;
+		__entry->child_ino = ip->i_ino;
+		__entry->parent_ino = dp->i_ino;
+		__entry->namelen = xname->len;
+		memcpy(__get_str(name), xname->name, xname->len);
+	),
+	TP_printk("dev %d:%d path %u step %u child_ino 0x%llx parent_ino 0x%llx name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->path_nr,
+		  __entry->step_nr,
+		  __entry->child_ino,
+		  __entry->parent_ino,
+		  __entry->namelen,
+		  __get_str(name))
+);
+
+TRACE_EVENT(xchk_dirtree_live_update,
+	TP_PROTO(struct xfs_scrub *sc, const struct xfs_inode *dp,
+		 int action, const struct xfs_inode *ip, int delta,
+		 const struct xfs_name *xname),
+	TP_ARGS(sc, dp, action, ip, delta, xname),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, parent_ino)
+		__field(int, action)
+		__field(xfs_ino_t, child_ino)
+		__field(int, delta)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, xname->len)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->parent_ino = dp->i_ino;
+		__entry->action = action;
+		__entry->child_ino = ip->i_ino;
+		__entry->delta = delta;
+		__entry->namelen = xname->len;
+		memcpy(__get_str(name), xname->name, xname->len);
+	),
+	TP_printk("dev %d:%d parent_ino 0x%llx child_ino 0x%llx nlink_delta %d name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->parent_ino,
+		  __entry->child_ino,
+		  __entry->delta,
+		  __entry->namelen,
+		  __get_str(name))
+);
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 

