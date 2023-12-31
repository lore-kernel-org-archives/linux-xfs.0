Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1E6BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ThcUv7LY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E987AC433C8;
	Sun, 31 Dec 2023 20:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056086;
	bh=cfNXhmZjp5OESzVf6tcSygolCmlhAQzhDjiA4pQu1oE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ThcUv7LYYqZaSmCXxivf52CjTSZx7TP6Y8rnYAGDGUS6kdh1ulR9UbtuzRmL39Dbg
	 kenik8qYS/duUApiGX0dT33Z/LriVv3erb/YdsoSzvPdbryXlfwU6+CUuY/7hx232y
	 vI3n7IYKmuj+otVCnyOT+3QOIlmLPyCFnlpqm5cFXrEWvLb3tof0kL1ih8NNBdbwwd
	 TazbRArPycgm+/b3dx6y3Qm7hvpqcp09rwOHlFrue21IbasfWk8xS0Ll8HbvSOh7Ko
	 JcOFY+RyyglexN0P+tYrDCsgVLdHKW+tshuDOiZa91Iw9+yt6/usJhuZEHhKMeP0Ql
	 3gWnMi7TdFmVw==
Date: Sun, 31 Dec 2023 12:54:45 -0800
Subject: [PATCH 06/22] xfs: walk directory parent pointers to determine
 backref count
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841843.1757392.17064146414014228788.stgit@frogsfrogsfrogs>
In-Reply-To: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
References: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
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

If the filesystem has parent pointers enabled, walk the parent pointers
of subdirectories to determine the true backref count.  In theory each
subdir should have a single parent reachable via dotdot, but in the case
of (corrupt) subdirs with multiple parents, we need to keep the link
counts high enough that the directory loop detector will be able to
correct the multiple parents problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.h        |    1 +
 fs/xfs/scrub/nlinks.c        |   71 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/nlinks.h        |    3 ++
 fs/xfs/scrub/nlinks_repair.c |    2 +
 fs/xfs/scrub/parent.c        |   61 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.c         |    1 +
 fs/xfs/scrub/trace.h         |   27 ++++++++++++++++
 7 files changed, 165 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 2e6af46519b58..298669ca2eb92 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -212,6 +212,7 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 }
 
 bool xchk_dir_looks_zapped(struct xfs_inode *dp);
+bool xchk_pptr_looks_zapped(struct xfs_inode *ip);
 
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 /* Decide if a repair is required. */
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 6f0b77da14dbb..4e62e287e1590 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -18,6 +18,7 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_ag.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
@@ -29,6 +30,7 @@
 #include "scrub/trace.h"
 #include "scrub/readdir.h"
 #include "scrub/tempfile.h"
+#include "scrub/listxattr.h"
 
 /*
  * Live Inode Link Count Checking
@@ -268,12 +270,17 @@ xchk_nlinks_collect_dirent(
 	 * number of parents of the root directory.
 	 *
 	 * Otherwise, increment the number of backrefs pointing back to ino.
+	 *
+	 * If the filesystem has parent pointers, we walk the pptrs to
+	 * determine the backref count.
 	 */
 	if (dotdot) {
 		if (dp == sc->mp->m_rootip)
 			error = xchk_nlinks_update_incore(xnc, ino, 1, 0, 0);
-		else
+		else if (!xfs_has_parent(sc->mp))
 			error = xchk_nlinks_update_incore(xnc, ino, 0, 1, 0);
+		else
+			error = 0;
 		if (error)
 			goto out_unlock;
 	}
@@ -310,6 +317,46 @@ xchk_nlinks_collect_dirent(
 	return error;
 }
 
+/* Bump the backref count for the inode referenced by this parent pointer. */
+STATIC int
+xchk_nlinks_collect_pptr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	const struct xfs_parent_name_irec *pptr,
+	void			*priv)
+{
+	struct xchk_nlink_ctrs	*xnc = priv;
+	int			error;
+
+	if (!xfs_parent_verify_irec(sc->mp, pptr))
+		return -EFSCORRUPTED;
+
+	/* Update the shadow link counts if we haven't already failed. */
+
+	if (xchk_iscan_aborted(&xnc->collect_iscan)) {
+		error = -ECANCELED;
+		goto out_incomplete;
+	}
+
+	trace_xchk_nlinks_collect_pptr(sc->mp, ip, pptr);
+
+	mutex_lock(&xnc->lock);
+
+	error = xchk_nlinks_update_incore(xnc, pptr->p_ino, 0, 1, 0);
+	if (error)
+		goto out_unlock;
+
+	mutex_unlock(&xnc->lock);
+	return 0;
+
+out_unlock:
+	mutex_unlock(&xnc->lock);
+	xchk_iscan_abort(&xnc->collect_iscan);
+out_incomplete:
+	xchk_set_incomplete(sc);
+	return error;
+}
+
 /* Walk a directory to bump the observed link counts of the children. */
 STATIC int
 xchk_nlinks_collect_dir(
@@ -356,6 +403,28 @@ xchk_nlinks_collect_dir(
 	if (error)
 		goto out_abort;
 
+	/* Walk the parent pointers to get real backref counts. */
+	if (xfs_has_parent(sc->mp)) {
+		/*
+		 * If the extended attributes look as though they has been
+		 * zapped by the inode record repair code, we cannot scan for
+		 * parent pointers.
+		 */
+		if (xchk_pptr_looks_zapped(dp)) {
+			error = -EBUSY;
+			goto out_unlock;
+		}
+
+		error = xchk_pptr_walk(sc, dp, xchk_nlinks_collect_pptr,
+				&xnc->pptr, xnc);
+		if (error == -ECANCELED) {
+			error = 0;
+			goto out_unlock;
+		}
+		if (error)
+			goto out_abort;
+	}
+
 	xchk_iscan_mark_visited(&xnc->collect_iscan, dp);
 	goto out_unlock;
 
diff --git a/fs/xfs/scrub/nlinks.h b/fs/xfs/scrub/nlinks.h
index f4766e01b6469..2d63cb56b6a3c 100644
--- a/fs/xfs/scrub/nlinks.h
+++ b/fs/xfs/scrub/nlinks.h
@@ -23,6 +23,9 @@ struct xchk_nlink_ctrs {
 	struct xchk_iscan	collect_iscan;
 	struct xchk_iscan	compare_iscan;
 
+	/* Parent pointer for finding backrefs. */
+	struct xfs_parent_name_irec pptr;
+
 	/*
 	 * Hook into directory updates so that we can receive live updates
 	 * from other writer threads.
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 87cb3400ff948..fb299b23d5f1d 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -18,6 +18,8 @@
 #include "xfs_ialloc.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 3bacd3e14f5d3..555aee4b73b37 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -883,3 +883,64 @@ xchk_parent(
 
 	return error;
 }
+
+/*
+ * Decide if this file's extended attributes (and therefore its parent
+ * pointers) have been zapped to satisfy the inode and ifork verifiers.
+ * Checking and repairing should be postponed until the extended attribute
+ * structure is fixed.
+ */
+bool
+xchk_pptr_looks_zapped(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
+
+	ASSERT(xfs_has_parent(mp));
+
+	/*
+	 * Temporary files that cannot be linked into the directory tree do not
+	 * have attr forks because they cannot ever have parents.
+	 */
+	if (inode->i_nlink == 0 && !(inode->i_state & I_LINKABLE))
+		return false;
+
+	/*
+	 * Directory tree roots do not have parents, so the expected outcome
+	 * of a parent pointer scan is always the empty set.  It's safe to scan
+	 * them even if the attr fork was zapped.
+	 */
+	if (ip == mp->m_rootip)
+		return false;
+
+	/*
+	 * Metadata inodes are all rooted in the superblock and do not have
+	 * any parents.  Hence the attr fork will not be initialized, but
+	 * there are no parent pointers that might have been zapped.
+	 */
+	if (xfs_is_metadata_inode(ip))
+		return false;
+
+	/*
+	 * Linked and linkable non-rootdir files should always have an
+	 * attribute fork because that is where parent pointers are
+	 * stored.  If the fork is absent, something is amiss.
+	 */
+	if (!xfs_inode_has_attr_fork(ip))
+		return true;
+
+	/* Repair zapped this file's attr fork a short time ago */
+	if (xfs_ifork_zapped(ip, XFS_ATTR_FORK))
+		return true;
+
+	/*
+	 * If the dinode repair found a bad attr fork, it will reset the fork
+	 * to extents format with zero records and wait for the bmapbta
+	 * scrubber to reconstruct the block mappings.  The extended attribute
+	 * structure always contain some content when parent pointers are
+	 * enabled, so this is a clear sign of a zapped attr fork.
+	 */
+	return ip->i_af.if_format == XFS_DINODE_FMT_EXTENTS &&
+	       ip->i_af.if_nextents == 0;
+}
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index e127f6d492c35..9fe1491adbb51 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -20,6 +20,7 @@
 #include "xfs_da_format.h"
 #include "xfs_dir2.h"
 #include "xfs_rmap.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index f90743453cd22..d3a0cefea3684 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -28,6 +28,7 @@ struct xchk_fscounters;
 struct xfbtree;
 struct xfbtree_config;
 struct xfs_rmap_update_params;
+struct xfs_parent_name_irec;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -1375,6 +1376,32 @@ TRACE_EVENT(xchk_nlinks_collect_dirent,
 		  __get_str(name))
 );
 
+TRACE_EVENT(xchk_nlinks_collect_pptr,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_inode *dp,
+		 const struct xfs_parent_name_irec *pptr),
+	TP_ARGS(mp, dp, pptr),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, pptr->p_namelen)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->dir = dp->i_ino;
+		__entry->ino = pptr->p_ino;
+		__entry->namelen = pptr->p_namelen;
+		memcpy(__get_str(name), pptr->p_name, pptr->p_namelen);
+	),
+	TP_printk("dev %d:%d dir 0x%llx -> ino 0x%llx name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir,
+		  __entry->ino,
+		  __entry->namelen,
+		  __get_str(name))
+);
+
 TRACE_EVENT(xchk_nlinks_collect_metafile,
 	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino),
 	TP_ARGS(mp, ino),

