Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96B8C8CB
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPTQwKbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86013C433C8;
	Sun, 31 Dec 2023 20:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056367;
	bh=/n5OMmi6BiUBeThTKt6N4AWXAKbGmNlOApF8lzqHcUo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IPTQwKbLg1qBiyKYFvJtKU+KRS9ENWgyi+NiSZgerFs2rKBhP+qv5wwZhPqKAUkY3
	 jiX8k3R8WjA5nlROJ99Hnn33JC7b0FWag8n+mJlkpBDdKUu7ao7BSlVq2LKiTksbG0
	 VwGp2R1/UucJpBARGRf9Ox36SL40yntiyeik4/HTW/BJ/RRyWPXeqyeTvrGp2rHIZe
	 7myYAfqFnMjwbu/WOEtO7jR2l7sKcjFTXcjFkQ1LUBqOY8ZUqo0CVcTnsfZTFd8JN9
	 2/UbpqYgalmFPJW8Kk3Hl0eb2o4gg1JCg3PHh7+fXKmwvVwPy/eEPpuwNwUxHlBerJ
	 yLW9xZdLJN4iw==
Date: Sun, 31 Dec 2023 12:59:27 -0800
Subject: [PATCH 2/4] xfs: invalidate dirloop scrub path data when concurrent
 updates happen
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404842488.1757975.10685860663281824426.stgit@frogsfrogsfrogs>
In-Reply-To: <170404842446.1757975.532228960833173146.stgit@frogsfrogsfrogs>
References: <170404842446.1757975.532228960833173146.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/dirtree.c |  159 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/dirtree.h |   19 ++++++
 fs/xfs/scrub/trace.h   |   65 ++++++++++++++++++++
 3 files changed, 242 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 9edaf89f46fdf..18005908434ed 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -69,6 +69,9 @@ xchk_dirtree_buf_cleanup(
 	struct xchk_dirtree	*dl = buf;
 	struct xchk_dirpath	*path, *n;
 
+	if (dl->scan_ino != NULLFSINO)
+		xfs_dir_hook_del(dl->sc->mp, &dl->hooks);
+
 	xchk_dirtree_for_each_path_safe(dl, path, n) {
 		list_del_init(&path->list);
 		xino_bitmap_destroy(&path->seen_inodes);
@@ -89,12 +92,15 @@ xchk_setup_dirtree(
 	char			*descr;
 	int			error;
 
+	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
+
 	dl = kvzalloc(sizeof(struct xchk_dirtree), XCHK_GFP_FLAGS);
 	if (!dl)
 		return -ENOMEM;
 	dl->sc = sc;
 	INIT_LIST_HEAD(&dl->path_list);
 	dl->root_ino = NULLFSINO;
+	dl->scan_ino = NULLFSINO;
 
 	mutex_init(&dl->lock);
 
@@ -542,6 +548,133 @@ xchk_dirpath_walk_upwards(
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
+	struct xchk_dirpath_step	*step)
+{
+	xfs_ino_t			child_ino = step->parent_ino;
+	int				error;
+
+	error = xfarray_load(dl->path_steps, step_idx, step);
+	if (error)
+		return error;
+
+	/*
+	 * If the parent and child being updated are not the ones mentioned in
+	 * this path step, the scan data is still ok.
+	 */
+	if (p->ip->i_ino != child_ino || p->dp->i_ino != step->parent_ino)
+		return 0;
+
+	/*
+	 * If the dirent name lengths or byte sequences are different, the scan
+	 * data is still ok.
+	 */
+	if (p->name->len != step->name_len)
+		return 0;
+
+	error = xfblob_load(dl->path_names, step->name_cookie,
+			dl->hook_namebuf, step->name_len);
+	if (error)
+		return error;
+
+	if (memcmp(dl->hook_namebuf, p->name->name, p->name->len) != 0)
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
+	struct xchk_dirpath_step	step = {
+		.parent_ino		= dl->scan_ino,
+	};
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
+	ret = xchk_dirpath_step_is_stale(dl, path, 0, idx, p, &step);
+	if (ret != 0)
+		return ret;
+
+	for (i = 1, idx = path->second_step; i < path->nr_steps; i++, idx++) {
+		ret = xchk_dirpath_step_is_stale(dl, path, i, idx, p, &step);
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
+	dl = container_of(nb, struct xchk_dirtree, hooks.dirent_hook.nb);
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
@@ -627,6 +760,8 @@ xchk_dirtree_find_paths_to_root(
 			}
 			if (error)
 				return error;
+			if (dl->aborted)
+				return 0;
 		}
 	} while (dl->stale);
 
@@ -698,11 +833,28 @@ xchk_dirtree(
 
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
+	xfs_hook_setup(&dl->hooks.dirent_hook, xchk_dirtree_live_update);
+	error = xfs_dir_hook_add(sc->mp, &dl->hooks);
+	if (error)
+		goto out;
+
 	mutex_lock(&dl->lock);
 
 	/* Trace each parent pointer's path to the root. */
@@ -729,6 +881,10 @@ xchk_dirtree(
 	}
 	if (error)
 		goto out_scanlock;
+	if (dl->aborted) {
+		xchk_set_incomplete(sc);
+		goto out_scanlock;
+	}
 
 	/* Assess what we found in our path evaluation. */
 	xchk_dirtree_evaluate(dl, &oc);
@@ -744,6 +900,7 @@ xchk_dirtree(
 
 out_scanlock:
 	mutex_unlock(&dl->lock);
+out:
 	trace_xchk_dirtree_done(sc->ip, sc->sm, error);
 	return error;
 }
diff --git a/fs/xfs/scrub/dirtree.h b/fs/xfs/scrub/dirtree.h
index a7797b618ec3f..ea374cf5f8362 100644
--- a/fs/xfs/scrub/dirtree.h
+++ b/fs/xfs/scrub/dirtree.h
@@ -73,13 +73,29 @@ struct xchk_dirtree {
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
 	struct xfs_parent_scratch scratch;
 	struct xfs_parent_name_irec pptr;
 
+	/*
+	 * Hook into directory updates so that we can receive live updates
+	 * from other writer threads.
+	 */
+	struct xfs_dir_hook	hooks;
+
 	/* lock for everything below here */
 	struct mutex		lock;
 
+	/* buffer for the live update functions to use for dirent names */
+	unsigned char		hook_namebuf[MAXNAMELEN];
+
 	/*
 	 * All path steps observed during this scan.  Each of the path
 	 * steps for a particular pathwalk are recorded in sequential
@@ -100,6 +116,9 @@ struct xchk_dirtree {
 
 	/* Have the path data been invalidated by a concurrent update? */
 	bool			stale:1;
+
+	/* Has the scan been aborted? */
+	bool			aborted:1;
 };
 
 #define xchk_dirtree_for_each_path_safe(dl, path, n) \
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index f5dddbc4d8594..0d4c1580f61b7 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1773,6 +1773,71 @@ DEFINE_EVENT(xchk_dirtree_evaluate_class, name, \
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
 

