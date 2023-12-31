Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD9FC2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPEldZTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D08C433C8;
	Sun, 31 Dec 2023 23:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064782;
	bh=r1KXLIu2NvI+H91zK0uHKgyI1/Uz95foIKhiyepYGz8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JPEldZTN+60u2qvVnvNZErnVH9pwToehfYouW9M7+ikCtblZnjYMPHuH97Qy4c6e+
	 MpiZqCJUrnXWuC3reV7Mg+3I9LSO5jc6YyzTWoUEoBtBxxFIGQL9Yx+oQwd8IdB+iI
	 jr+D3jErN6jcxxw7nm1uqmbLwhKJUrc9isqw/1nrvxTpRePr55c8Z9SlQ71M85FmeS
	 8qWslRREt1q0Osp6guIujc3Rk/v3+/o51+N21OPPlQlmlCPaGm8OS9VJjhw4aaZw1c
	 9NE/fkDJz5GJbP66KW4GQrHOIyTZGXlh9qFyL+LE4ubxMhuF8IgVhK+4rOYXDCKyOf
	 jki5kCr0LNI/A==
Date: Sun, 31 Dec 2023 15:19:41 -0800
Subject: [PATCH 6/6] xfs_scrub: defer phase5 file scans if dirloop fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007512.1805996.11814780916064262740.stgit@frogsfrogsfrogs>
In-Reply-To: <170405007429.1805996.15935827855068032438.stgit@frogsfrogsfrogs>
References: <170405007429.1805996.15935827855068032438.stgit@frogsfrogsfrogs>
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

If we cannot fix dirloop problems during the initial phase 5 inode scan,
defer them until later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase5.c |  215 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 scrub/repair.c |   13 +++
 scrub/repair.h |    2 +
 3 files changed, 216 insertions(+), 14 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 6c8dee66e6e..f6c295c64ad 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -18,6 +18,8 @@
 #include "libfrog/workqueue.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/scrub.h"
+#include "libfrog/bitmap.h"
+#include "libfrog/bulkstat.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
@@ -29,6 +31,36 @@
 
 /* Phase 5: Full inode scans and check directory connectivity. */
 
+struct ncheck_state {
+	struct scrub_ctx	*ctx;
+
+	/* Have we aborted this scan? */
+	bool			aborted;
+
+	/* Is this the last time we're going to process deferred inodes? */
+	bool			last_call;
+
+	/* Did we fix at least one thing while walking @cur->deferred? */
+	bool			fixed_something;
+
+	/* Lock for this structure */
+	pthread_mutex_t		lock;
+
+	/*
+	 * Inodes that are involved with directory tree structure corruptions
+	 * are marked here.  This will be NULL until the first corruption is
+	 * noted.
+	 */
+	struct bitmap		*new_deferred;
+
+	/*
+	 * Inodes that we're reprocessing due to earlier directory tree
+	 * structure corruption problems are marked here.  This will be NULL
+	 * during the first (parallel) inode scan.
+	 */
+	struct bitmap		*cur_deferred;
+};
+
 /*
  * Warn about problematic bytes in a directory/attribute name.  That means
  * terminal control characters and escape sequences, since that could be used
@@ -252,6 +284,26 @@ render_ino_from_handle(
 			bstat->bs_gen, NULL);
 }
 
+/* Defer this inode until later. */
+static inline int
+defer_inode(
+	struct ncheck_state	*ncs,
+	uint64_t		ino)
+{
+	int			error;
+
+	pthread_mutex_lock(&ncs->lock);
+	if (!ncs->new_deferred) {
+		error = -bitmap_alloc(&ncs->new_deferred);
+		if (error)
+			goto unlock;
+	}
+	error = -bitmap_set(ncs->new_deferred, ino, 1);
+unlock:
+	pthread_mutex_unlock(&ncs->lock);
+	return error;
+}
+
 /*
  * Check the directory structure for problems that could cause open_by_handle
  * not to work.  Returns 0 for no problems; EADDRNOTAVAIL if the there are
@@ -260,7 +312,7 @@ render_ino_from_handle(
 static int
 check_dir_connection(
 	struct scrub_ctx		*ctx,
-	struct descr			*dsc,
+	struct ncheck_state		*ncs,
 	const struct xfs_bulkstat	*bstat)
 {
 	struct scrub_item		sri = { };
@@ -279,17 +331,31 @@ check_dir_connection(
 		return error;
 	}
 
-	error = repair_file_corruption(ctx, &sri, -1);
+	if (ncs->last_call)
+		error = repair_file_corruption_now(ctx, &sri, -1);
+	else
+		error = repair_file_corruption(ctx, &sri, -1);
 	if (error) {
 		str_liberror(ctx, error, _("repairing directory loops"));
 		return error;
 	}
 
 	/* No directory tree problems?  Clear this inode if it was deferred. */
-	if (repair_item_count_needsrepair(&sri) == 0)
+	if (repair_item_count_needsrepair(&sri) == 0) {
+		if (ncs->cur_deferred)
+			ncs->fixed_something = true;
 		return 0;
+	}
+
+	/* Don't defer anything during last call. */
+	if (ncs->last_call)
+		return 0;
+
+	/* Directory tree structure problems exist; do not check names yet. */
+	error = defer_inode(ncs, bstat->bs_ino);
+	if (error)
+		return error;
 
-	str_corrupt(ctx, descr_render(dsc), _("directory loop uncorrected!"));
 	return EADDRNOTAVAIL;
 }
 
@@ -308,7 +374,7 @@ check_inode_names(
 	void			*arg)
 {
 	DEFINE_DESCR(dsc, ctx, render_ino_from_handle);
-	bool			*aborted = arg;
+	struct ncheck_state	*ncs = arg;
 	int			fd = -1;
 	int			error = 0;
 	int			err2;
@@ -321,7 +387,7 @@ check_inode_names(
 	 * handle.
 	 */
 	if (S_ISDIR(bstat->bs_mode)) {
-		error = check_dir_connection(ctx, &dsc, bstat);
+		error = check_dir_connection(ctx, ncs, bstat);
 		if (error == EADDRNOTAVAIL) {
 			error = 0;
 			goto out;
@@ -369,14 +435,120 @@ check_inode_names(
 	}
 err:
 	if (error)
-		*aborted = true;
+		ncs->aborted = true;
 out:
-	if (!error && *aborted)
+	if (!error && ncs->aborted)
 		error = ECANCELED;
 
 	return error;
 }
 
+/* Try to check_inode_names on a specific inode. */
+static int
+retry_deferred_inode(
+	struct ncheck_state	*ncs,
+	struct xfs_handle	*handle,
+	uint64_t		ino)
+{
+	struct xfs_bulkstat	bstat;
+	struct scrub_ctx	*ctx = ncs->ctx;
+	unsigned int		flags = 0;
+	int			error;
+
+	error = -xfrog_bulkstat_single(&ctx->mnt, ino, flags, &bstat);
+	if (error == ENOENT) {
+		/* Directory is gone, mark it clear. */
+		ncs->fixed_something = true;
+		return 0;
+	}
+	if (error)
+		return error;
+
+	handle->ha_fid.fid_ino = bstat.bs_ino;
+	handle->ha_fid.fid_gen = bstat.bs_gen;
+
+	return check_inode_names(ncs->ctx, handle, &bstat, ncs);
+}
+
+/* Try to check_inode_names on a range of inodes from the bitmap. */
+static int
+retry_deferred_inode_range(
+	uint64_t		ino,
+	uint64_t		len,
+	void			*arg)
+{
+	struct xfs_handle	handle = { };
+	struct ncheck_state	*ncs = arg;
+	struct scrub_ctx	*ctx = ncs->ctx;
+	uint64_t		i;
+	int			error;
+
+	memcpy(&handle.ha_fsid, ctx->fshandle, sizeof(handle.ha_fsid));
+	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
+			sizeof(handle.ha_fid.fid_len);
+	handle.ha_fid.fid_pad = 0;
+
+	for (i = 0; i < len; i++) {
+		error = retry_deferred_inode(ncs, &handle, ino + i);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Try to check_inode_names on inodes that were deferred due to directory tree
+ * problems until we stop making progress.
+ */
+static int
+retry_deferred_inodes(
+	struct scrub_ctx	*ctx,
+	struct ncheck_state	*ncs)
+{
+	int			error;
+
+	if  (!ncs->new_deferred)
+		return 0;
+
+	/*
+	 * Try to repair things until we stop making forward progress or we
+	 * don't observe any new corruptions.  During the loop, we do not
+	 * complain about the corruptions that do not get fixed.
+	 */
+	do {
+		ncs->cur_deferred = ncs->new_deferred;
+		ncs->new_deferred = NULL;
+		ncs->fixed_something = false;
+
+		error = -bitmap_iterate(ncs->cur_deferred,
+				retry_deferred_inode_range, ncs);
+		if (error)
+			return error;
+
+		bitmap_free(&ncs->cur_deferred);
+	} while (ncs->fixed_something && ncs->new_deferred);
+
+	/*
+	 * Try one last time to fix things, and complain about any problems
+	 * that remain.
+	 */
+	if (!ncs->new_deferred)
+		return 0;
+
+	ncs->cur_deferred = ncs->new_deferred;
+	ncs->new_deferred = NULL;
+	ncs->last_call = true;
+
+	error = -bitmap_iterate(ncs->cur_deferred,
+			retry_deferred_inode_range, ncs);
+	if (error)
+		return error;
+
+	bitmap_free(&ncs->cur_deferred);
+	return 0;
+}
+
 #ifndef FS_IOC_GETFSLABEL
 # define FSLABEL_MAX		256
 # define FS_IOC_GETFSLABEL	_IOR(0x94, 49, char[FSLABEL_MAX])
@@ -568,9 +740,10 @@ int
 phase5_func(
 	struct scrub_ctx	*ctx)
 {
-	bool			aborted = false;
+	struct ncheck_state	ncs = { .ctx = ctx };
 	int			ret;
 
+
 	/*
 	 * Check and fix anything that requires a full filesystem scan.  We do
 	 * this after we've checked all inodes and repaired anything that could
@@ -590,14 +763,28 @@ _("Filesystem has errors, skipping connectivity checks."));
 	if (ret)
 		return ret;
 
-	ret = scrub_scan_all_inodes(ctx, check_inode_names, &aborted);
+	pthread_mutex_init(&ncs.lock, NULL);
+
+	ret = scrub_scan_all_inodes(ctx, check_inode_names, &ncs);
 	if (ret)
-		return ret;
-	if (aborted)
-		return ECANCELED;
+		goto out_lock;
+	if (ncs.aborted) {
+		ret = ECANCELED;
+		goto out_lock;
+	}
+
+	ret = retry_deferred_inodes(ctx, &ncs);
+	if (ret)
+		goto out_lock;
 
 	scrub_report_preen_triggers(ctx);
-	return 0;
+out_lock:
+	pthread_mutex_destroy(&ncs.lock);
+	if (ncs.new_deferred)
+		bitmap_free(&ncs.new_deferred);
+	if (ncs.cur_deferred)
+		bitmap_free(&ncs.cur_deferred);
+	return ret;
 }
 
 /* Estimate how much work we're going to do. */
diff --git a/scrub/repair.c b/scrub/repair.c
index 0258210722b..4fed86134ed 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -732,6 +732,19 @@ repair_file_corruption(
 			XRM_REPAIR_ONLY | XRM_NOPROGRESS);
 }
 
+/* Repair all parts of this file or complain if we cannot. */
+int
+repair_file_corruption_now(
+	struct scrub_ctx	*ctx,
+	struct scrub_item	*sri,
+	int			override_fd)
+{
+	repair_item_boost_priorities(sri);
+
+	return repair_item_class(ctx, sri, override_fd, SCRUB_ITEM_CORRUPT,
+			XRM_REPAIR_ONLY | XRM_NOPROGRESS | XRM_FINAL_WARNING);
+}
+
 /*
  * Repair everything in this filesystem object that needs it.  This includes
  * cross-referencing and preening.
diff --git a/scrub/repair.h b/scrub/repair.h
index 411a379f6fa..ec4aa381a82 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -76,6 +76,8 @@ int action_list_process(struct scrub_ctx *ctx, struct action_list *alist,
 int repair_item_corruption(struct scrub_ctx *ctx, struct scrub_item *sri);
 int repair_file_corruption(struct scrub_ctx *ctx, struct scrub_item *sri,
 		int override_fd);
+int repair_file_corruption_now(struct scrub_ctx *ctx, struct scrub_item *sri,
+		int override_fd);
 int repair_item(struct scrub_ctx *ctx, struct scrub_item *sri,
 		unsigned int repair_flags);
 int repair_item_to_action_item(struct scrub_ctx *ctx,

