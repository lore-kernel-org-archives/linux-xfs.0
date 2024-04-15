Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411DE157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225199; cv=none; b=GDKJ9u9VCgdiEniVlO7Yjv7XjDYybAST7Fl5NT1/2Ki9f7DdcRZzxwSgnQ8y6C2ZASfu2+ZkefhwZQNxO1LumIz78Tyj3rKJyqEHVkJ2yjQ5KxOqP4QZKKqzUCyZQ1LznUeFwKh8pJZSop46Vc+q+anIVRT3TNAxRAGQburmdhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225199; c=relaxed/simple;
	bh=CN4hh4aIbVlZkH5hU1xm9FuoWarpGbujDozHDVAOYS0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GbsAWgSQb8NxQAXU1fOXrSN3Osjngpiv3Yc6irqRsFCtAr5quR8Ln8rr8GMvi6pE0/x8JH+71PJJG3R3ZV9ELkz7m/S53a4xuTBjb1dJVItJ74W3QTeO/5Ckwtg1Tj3UueaPsHbZqATUd74Y88YeRUUECKxLruzTckR09wFam0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qJJsxrO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qJJsxrO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183C4C113CC;
	Mon, 15 Apr 2024 23:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225199;
	bh=CN4hh4aIbVlZkH5hU1xm9FuoWarpGbujDozHDVAOYS0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qJJsxrO24HLVuK1HGq0mI4y3YG4dteJXjHCcisQGEpM4w4PjmxwxghB3u6Owx288L
	 SEH0fmTX4YnEgn99+mj99dIeZID5rEIYzytYySo02mBwL9oMEE2BrY8KkwZafV/uSF
	 wL5YCuXeg4kL1gN0kbteY4oYXSEV71a92HR7tz3LQDlfveLCa7+3A8q3cTqXo95U8s
	 pRypYM0i9eQkI9HRotk0hx2keN8rn4enB33Nw/QhYs7AxFiTtio/KG3hwsiY88RXtA
	 LPwYC/2cI/rzpKaaU7QVm2MkCWwjy4qRzxkxFcCW1CdoVobI0+rQ6Kwy/JS+f8ug5U
	 lz28+vy7xaw0g==
Date: Mon, 15 Apr 2024 16:53:18 -0700
Subject: [PATCH 2/3] xfs: move files to orphanage instead of letting nlinks
 drop to zero
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322384308.89422.174232954103694087.stgit@frogsfrogsfrogs>
In-Reply-To: <171322384265.89422.12835876074903686240.stgit@frogsfrogsfrogs>
References: <171322384265.89422.12835876074903686240.stgit@frogsfrogsfrogs>
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

If we encounter an inode with a nonzero link count but zero observed
links, move it to the orphanage.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |    3 
 fs/xfs/scrub/nlinks.c                              |   20 ++-
 fs/xfs/scrub/nlinks.h                              |    7 +
 fs/xfs/scrub/nlinks_repair.c                       |  123 ++++++++++++++++++--
 fs/xfs/scrub/repair.h                              |    2 
 fs/xfs/scrub/trace.c                               |    1 
 fs/xfs/scrub/trace.h                               |   26 ++++
 7 files changed, 163 insertions(+), 19 deletions(-)


diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 37dddaaeda50..74a8e42c74bd 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -4789,7 +4789,8 @@ Orphaned files are adopted by the orphanage as follows:
    cache.
 
 6. Call ``xrep_adoption_finish`` to commit any filesystem updates, release the
-   orphanage ILOCK, and clean the scrub transaction.
+   orphanage ILOCK, and clean the scrub transaction.  Call
+   ``xrep_adoption_commit`` to commit the updates and the scrub transaction.
 
 7. If a runtime error happens, call ``xrep_adoption_cancel`` to release all
    resources.
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 8b9aa73093d6..c456523fac9c 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -24,6 +24,7 @@
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/iscan.h"
+#include "scrub/orphanage.h"
 #include "scrub/nlinks.h"
 #include "scrub/trace.h"
 #include "scrub/readdir.h"
@@ -44,11 +45,23 @@ int
 xchk_setup_nlinks(
 	struct xfs_scrub	*sc)
 {
+	struct xchk_nlink_ctrs	*xnc;
+	int			error;
+
 	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
 
-	sc->buf = kzalloc(sizeof(struct xchk_nlink_ctrs), XCHK_GFP_FLAGS);
-	if (!sc->buf)
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_nlinks(sc);
+		if (error)
+			return error;
+	}
+
+	xnc = kvzalloc(sizeof(struct xchk_nlink_ctrs), XCHK_GFP_FLAGS);
+	if (!xnc)
 		return -ENOMEM;
+	xnc->xname.name = xnc->namebuf;
+	xnc->sc = sc;
+	sc->buf = xnc;
 
 	return xchk_setup_fs(sc);
 }
@@ -873,9 +886,6 @@ xchk_nlinks_setup_scan(
 	xfs_agino_t		first_agino, last_agino;
 	int			error;
 
-	ASSERT(xnc->sc == NULL);
-	xnc->sc = sc;
-
 	mutex_init(&xnc->lock);
 
 	/* Retry iget every tenth of a second for up to 30 seconds. */
diff --git a/fs/xfs/scrub/nlinks.h b/fs/xfs/scrub/nlinks.h
index a950f3daf204..b820712bfd87 100644
--- a/fs/xfs/scrub/nlinks.h
+++ b/fs/xfs/scrub/nlinks.h
@@ -28,6 +28,13 @@ struct xchk_nlink_ctrs {
 	 * from other writer threads.
 	 */
 	struct xfs_dir_hook	dhook;
+
+	/* Orphanage reparenting request. */
+	struct xrep_adoption	adoption;
+
+	/* Directory entry name, plus the trailing null. */
+	struct xfs_name		xname;
+	char			namebuf[MAXNAMELEN];
 };
 
 /*
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 23eb08c4b5ad..0cb67339eac8 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -24,6 +24,7 @@
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/iscan.h"
+#include "scrub/orphanage.h"
 #include "scrub/nlinks.h"
 #include "scrub/trace.h"
 #include "scrub/tempfile.h"
@@ -38,6 +39,34 @@
  * inode is locked.
  */
 
+/* Set up to repair inode link counts. */
+int
+xrep_setup_nlinks(
+	struct xfs_scrub	*sc)
+{
+	return xrep_orphanage_try_create(sc);
+}
+
+/*
+ * Inodes that aren't the root directory or the orphanage, have a nonzero link
+ * count, and no observed parents should be moved to the orphanage.
+ */
+static inline bool
+xrep_nlinks_is_orphaned(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		actual_nlink,
+	const struct xchk_nlink	*obs)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (obs->parents != 0)
+		return false;
+	if (ip == mp->m_rootip || ip == sc->orphanage)
+		return false;
+	return actual_nlink != 0;
+}
+
 /* Remove an inode from the unlinked list. */
 STATIC int
 xrep_nlinks_iunlink_remove(
@@ -66,6 +95,7 @@ xrep_nlinks_repair_inode(
 	struct xfs_inode	*ip = sc->ip;
 	uint64_t		total_links;
 	uint64_t		actual_nlink;
+	bool			orphanage_available = false;
 	bool			dirty = false;
 	int			error;
 
@@ -77,14 +107,41 @@ xrep_nlinks_repair_inode(
 	if (xrep_is_tempfile(ip))
 		return 0;
 
-	xchk_ilock(sc, XFS_IOLOCK_EXCL);
+	/*
+	 * If the filesystem has an orphanage attached to the scrub context,
+	 * prepare for a link count repair that could involve @ip being adopted
+	 * by the lost+found.
+	 */
+	if (xrep_orphanage_can_adopt(sc)) {
+		error = xrep_orphanage_iolock_two(sc);
+		if (error)
+			return error;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &sc->tp);
-	if (error)
-		return error;
+		error = xrep_adoption_trans_alloc(sc, &xnc->adoption);
+		if (error) {
+			xchk_iunlock(sc, XFS_IOLOCK_EXCL);
+			xrep_orphanage_iunlock(sc, XFS_IOLOCK_EXCL);
+		} else {
+			orphanage_available = true;
+		}
+	}
 
-	xchk_ilock(sc, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(sc->tp, ip, 0);
+	/*
+	 * Either there is no orphanage or we couldn't allocate resources for
+	 * that kind of update.  Let's try again with only the resources we
+	 * need for a simple link count update, since that's much more common.
+	 */
+	if (!orphanage_available) {
+		xchk_ilock(sc, XFS_IOLOCK_EXCL);
+
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0,
+				&sc->tp);
+		if (error)
+			return error;
+
+		xchk_ilock(sc, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(sc->tp, ip, 0);
+	}
 
 	mutex_lock(&xnc->lock);
 
@@ -122,6 +179,41 @@ xrep_nlinks_repair_inode(
 		goto out_trans;
 	}
 
+	/*
+	 * Decide if we're going to move this file to the orphanage, and fix
+	 * up the incore link counts if we are.
+	 */
+	if (orphanage_available &&
+	    xrep_nlinks_is_orphaned(sc, ip, actual_nlink, &obs)) {
+		/* Figure out what name we're going to use here. */
+		error = xrep_adoption_compute_name(&xnc->adoption, &xnc->xname);
+		if (error)
+			goto out_trans;
+
+		/*
+		 * Reattach this file to the directory tree by moving it to
+		 * the orphanage per the adoption parameters that we already
+		 * computed.
+		 */
+		error = xrep_adoption_move(&xnc->adoption);
+		if (error)
+			goto out_trans;
+
+		/*
+		 * Re-read the link counts since the reparenting will have
+		 * updated our scan info.
+		 */
+		mutex_lock(&xnc->lock);
+		error = xfarray_load_sparse(xnc->nlinks, ip->i_ino, &obs);
+		mutex_unlock(&xnc->lock);
+		if (error)
+			goto out_trans;
+
+		total_links = xchk_nlink_total(ip, &obs);
+		actual_nlink = VFS_I(ip)->i_nlink;
+		dirty = true;
+	}
+
 	/*
 	 * If this inode is linked from the directory tree and on the unlinked
 	 * list, remove it from the unlinked list.
@@ -165,14 +257,19 @@ xrep_nlinks_repair_inode(
 	xfs_trans_log_inode(sc->tp, ip, XFS_ILOG_CORE);
 
 	error = xrep_trans_commit(sc);
-	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	return error;
+	goto out_unlock;
 
 out_scanlock:
 	mutex_unlock(&xnc->lock);
 out_trans:
 	xchk_trans_cancel(sc);
-	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+out_unlock:
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+	if (orphanage_available) {
+		xrep_orphanage_iunlock(sc, XFS_ILOCK_EXCL);
+		xrep_orphanage_iunlock(sc, XFS_IOLOCK_EXCL);
+	}
+	xchk_iunlock(sc, XFS_IOLOCK_EXCL);
 	return error;
 }
 
@@ -205,10 +302,10 @@ xrep_nlinks(
 	/*
 	 * We need ftype for an accurate count of the number of child
 	 * subdirectory links.  Child subdirectories with a back link (dotdot
-	 * entry) but no forward link are unfixable, so we cannot repair the
-	 * link count of the parent directory based on the back link count
-	 * alone.  Filesystems without ftype support are rare (old V4) so we
-	 * just skip out here.
+	 * entry) but no forward link are moved to the orphanage, so we cannot
+	 * repair the link count of the parent directory based on the back link
+	 * count alone.  Filesystems without ftype support are rare (old V4) so
+	 * we just skip out here.
 	 */
 	if (!xfs_has_ftype(sc->mp))
 		return -EOPNOTSUPP;
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index e53374fa5430..7e6aba7fe558 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -93,6 +93,7 @@ int xrep_setup_ag_refcountbt(struct xfs_scrub *sc);
 int xrep_setup_xattr(struct xfs_scrub *sc);
 int xrep_setup_directory(struct xfs_scrub *sc);
 int xrep_setup_parent(struct xfs_scrub *sc);
+int xrep_setup_nlinks(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -201,6 +202,7 @@ xrep_setup_nothing(
 #define xrep_setup_xattr		xrep_setup_nothing
 #define xrep_setup_directory		xrep_setup_nothing
 #define xrep_setup_parent		xrep_setup_nothing
+#define xrep_setup_nlinks		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 3dd281d6d185..b2ce7b22cad3 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -24,6 +24,7 @@
 #include "scrub/xfarray.h"
 #include "scrub/quota.h"
 #include "scrub/iscan.h"
+#include "scrub/orphanage.h"
 #include "scrub/nlinks.h"
 #include "scrub/fscounters.h"
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 7c49aa6f6b8d..2a4c54f7992a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2643,6 +2643,32 @@ DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_dir_salvaged_parent);
 DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_findparent_dirent);
 DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_findparent_from_dcache);
 
+TRACE_EVENT(xrep_nlinks_set_record,
+	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino,
+		 const struct xchk_nlink *obs),
+	TP_ARGS(mp, ino, obs),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_nlink_t, parents)
+		__field(xfs_nlink_t, backrefs)
+		__field(xfs_nlink_t, children)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->ino = ino;
+		__entry->parents = obs->parents;
+		__entry->backrefs = obs->backrefs;
+		__entry->children = obs->children;
+	),
+	TP_printk("dev %d:%d ino 0x%llx parents %u backrefs %u children %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->parents,
+		  __entry->backrefs,
+		  __entry->children)
+);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

