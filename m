Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2D2BA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AFly8v25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90963C433C8;
	Sun, 31 Dec 2023 20:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055115;
	bh=/lhUi5N11W6PWeRIcLWUiw3ji4zUjXrdqiCAZFBJdY0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AFly8v25h7hnNvnPxn8bm5yo9aYgqoGA1yNxu4s5f+NKKDJHfKNQsADnlUY75QfHw
	 Cr9TBYIEv/6WWrq13ve+JmytLU1b3xFiPZ3XDRngOoTC04EwkOi9rku7GnTKtCyUjZ
	 LeSRvsA5h/bq8mBd0WZaLZGz9e9kWv4Ou3NFdO5CvDxl6ivu5pMmdnVQXOgy7XsPq5
	 wdSFM88Z1br3IsAh1K0sCJ+CZ1OwfAUTj2MZw/oTTUm/71tDtsO9jWaYK9V7GkpSCd
	 pBSIImWw5jjKD6nrJaQEMdlDx5roUVqEk4dRETEnTKwYuIdz4kfvDISxhuOKju8utk
	 QHimtSo6k6bNw==
Date: Sun, 31 Dec 2023 12:38:35 -0800
Subject: [PATCH 2/3] xfs: move files to orphanage instead of letting nlinks
 drop to zero
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404836474.1753770.15382915947326730221.stgit@frogsfrogsfrogs>
In-Reply-To: <170404836433.1753770.18094386562668840224.stgit@frogsfrogsfrogs>
References: <170404836433.1753770.18094386562668840224.stgit@frogsfrogsfrogs>
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
---
 .../filesystems/xfs-online-fsck-design.rst         |    3 
 fs/xfs/scrub/nlinks.c                              |   11 ++
 fs/xfs/scrub/nlinks.h                              |    6 +
 fs/xfs/scrub/nlinks_repair.c                       |  124 ++++++++++++++++++--
 fs/xfs/scrub/repair.h                              |    2 
 fs/xfs/scrub/trace.c                               |    1 
 fs/xfs/scrub/trace.h                               |   26 ++++
 7 files changed, 158 insertions(+), 15 deletions(-)


diff --git a/Documentation/filesystems/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs-online-fsck-design.rst
index 63c78e1e85e52..827fcd49fe6d5 100644
--- a/Documentation/filesystems/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs-online-fsck-design.rst
@@ -4788,7 +4788,8 @@ Orphaned files are adopted by the orphanage as follows:
    cache.
 
 6. Call ``xrep_adoption_finish`` to commit any filesystem updates, release the
-   orphanage ILOCK, and clean the scrub transaction.
+   orphanage ILOCK, and clean the scrub transaction.  Call
+   ``xrep_adoption_commit`` to commit the updates and the scrub transaction.
 
 7. If a runtime error happens, call ``xrep_adoption_cancel`` to release all
    resources.
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index a6d68d9eb3d7e..7be2119ce283a 100644
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
@@ -44,9 +45,17 @@ int
 xchk_setup_nlinks(
 	struct xfs_scrub	*sc)
 {
+	int			error;
+
 	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
 
-	sc->buf = kzalloc(sizeof(struct xchk_nlink_ctrs), XCHK_GFP_FLAGS);
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_nlinks(sc);
+		if (error)
+			return error;
+	}
+
+	sc->buf = kvzalloc(sizeof(struct xchk_nlink_ctrs), XCHK_GFP_FLAGS);
 	if (!sc->buf)
 		return -ENOMEM;
 
diff --git a/fs/xfs/scrub/nlinks.h b/fs/xfs/scrub/nlinks.h
index 6b651ac0822e2..f4766e01b6469 100644
--- a/fs/xfs/scrub/nlinks.h
+++ b/fs/xfs/scrub/nlinks.h
@@ -28,6 +28,12 @@ struct xchk_nlink_ctrs {
 	 * from other writer threads.
 	 */
 	struct xfs_dir_hook	hooks;
+
+	/* Orphanage reparenting request. */
+	struct xrep_adoption	adoption;
+
+	/* Directory entry name, plus the trailing null. */
+	char			namebuf[MAXNAMELEN];
 };
 
 /*
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 23eb08c4b5ad5..1345c07a95c62 100644
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
 
@@ -122,6 +179,42 @@ xrep_nlinks_repair_inode(
 		goto out_trans;
 	}
 
+	/*
+	 * Decide if we're going to move this file to the orphanage, and fix
+	 * up the incore link counts if we are.
+	 */
+	if (orphanage_available &&
+	    xrep_nlinks_is_orphaned(sc, ip, actual_nlink, &obs)) {
+		/* Figure out what name we're going to use here. */
+		error = xrep_adoption_compute_name(&xnc->adoption,
+				xnc->namebuf);
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
@@ -165,14 +258,19 @@ xrep_nlinks_repair_inode(
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
 
@@ -205,10 +303,10 @@ xrep_nlinks(
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
index bcb2e28cf1bbb..615137a2039ab 100644
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
index ea41b5d9b3c6a..e127f6d492c35 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -25,6 +25,7 @@
 #include "scrub/xfarray.h"
 #include "scrub/quota.h"
 #include "scrub/iscan.h"
+#include "scrub/orphanage.h"
 #include "scrub/nlinks.h"
 #include "scrub/fscounters.h"
 #include "scrub/xfbtree.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 10b8aa82c2fc8..9c90b078d021a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2724,6 +2724,32 @@ DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_dir_salvaged_parent);
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
 
 

