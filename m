Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BC07464
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231341; cv=none; b=Zgc7gYUxcsugN+kKU9npywR/blazDyDkeju6t78e7GdsysQe83Xmg5294CG/S0Mawc/PuJYBt4oX5dowlOs0jJLxyOd3CVskS5UmHY3xKR6H9JfEyCHRapUDF2ibaJnMzWwFilcAM1p+xwONIsyDCC7NEkzHISl5+EHn/Gd+rlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231341; c=relaxed/simple;
	bh=/xtN2bBU9QZk0QD7q6GMatGpyWaUop7znljfaFOwGTA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M9gUxubidqy8ubUAZ89rCnquyKZR5zVQgP0jmCKkTbMH2Uy/4NZbJArrSIL3elVie13sE4HAm2B2GQ8ZbFs7KTUrkzRAXIE+5SLe0Jt24RnkGCIrCCFc2f5p0GP/Tt1ucveQAAvJeq+DWp7rzBhLz1z/6+YlntVpoiSrEab96Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBnq/X45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBnq/X45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947B3C113CC;
	Tue, 16 Apr 2024 01:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231341;
	bh=/xtN2bBU9QZk0QD7q6GMatGpyWaUop7znljfaFOwGTA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jBnq/X45dBVP9RD626DifcIEpwOW0O7EblAjlMWrMrCODuCKVpadNH+WwKcCgZ4el
	 SjNt4+J7SdU3n1Hyca93PtvN3Zqb/GUzSu/Sbv6356gQYxs21MZKUOp2JD0tiWDRFl
	 5OBqT01DGsfPZbLVW3iVWc1cOUqze8WDTzfZO2h0rWbv/n3jm3GM0RqMDccpagNElN
	 280ODAsc3zvrm7APJEe8C+wY9SCyH/G4xkRapUoCvzZORIQi6N9PWQ6isVDgvsG3wF
	 H+Sqe/RvcrIap1Re97imDftR6bVQ19LGcjpKQ5w0yb1RMpkgpbXmdr/dANDebuUZUn
	 a+m8+KZFhQHSg==
Date: Mon, 15 Apr 2024 18:35:41 -0700
Subject: [PATCH 6/7] xfs: walk directory parent pointers to determine backref
 count
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323028765.252774.2953961279320098637.stgit@frogsfrogsfrogs>
In-Reply-To: <171323028648.252774.8320615230798893063.stgit@frogsfrogsfrogs>
References: <171323028648.252774.8320615230798893063.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.h        |    1 
 fs/xfs/scrub/nlinks.c        |   85 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks_repair.c |    2 +
 fs/xfs/scrub/parent.c        |   61 ++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.c         |    1 
 fs/xfs/scrub/trace.h         |   28 ++++++++++++++
 6 files changed, 177 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 89f7bbec887ed..e00466f404829 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -212,6 +212,7 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 }
 
 bool xchk_dir_looks_zapped(struct xfs_inode *dp);
+bool xchk_pptr_looks_zapped(struct xfs_inode *ip);
 
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 /* Decide if a repair is required. */
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index fcb9c473f372e..d27b32e6f33db 100644
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
@@ -272,12 +274,17 @@ xchk_nlinks_collect_dirent(
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
@@ -314,6 +321,61 @@ xchk_nlinks_collect_dirent(
 	return error;
 }
 
+/* Bump the backref count for the inode referenced by this parent pointer. */
+STATIC int
+xchk_nlinks_collect_pptr(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	unsigned int			attr_flags,
+	const unsigned char		*name,
+	unsigned int			namelen,
+	const void			*value,
+	unsigned int			valuelen,
+	void				*priv)
+{
+	struct xfs_name			xname = {
+		.name			= name,
+		.len			= namelen,
+	};
+	struct xchk_nlink_ctrs		*xnc = priv;
+	const struct xfs_parent_rec	*pptr_rec = value;
+	xfs_ino_t			parent_ino;
+	int				error;
+
+	/* Update the shadow link counts if we haven't already failed. */
+
+	if (xchk_iscan_aborted(&xnc->collect_iscan)) {
+		error = -ECANCELED;
+		goto out_incomplete;
+	}
+
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	error = xfs_parent_from_attr(sc->mp, attr_flags, name, namelen, value,
+			valuelen, &parent_ino, NULL);
+	if (error)
+		return error;
+
+	trace_xchk_nlinks_collect_pptr(sc->mp, ip, &xname, pptr_rec);
+
+	mutex_lock(&xnc->lock);
+
+	error = xchk_nlinks_update_incore(xnc, parent_ino, 0, 1, 0);
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
@@ -360,6 +422,27 @@ xchk_nlinks_collect_dir(
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
+		error = xchk_xattr_walk(sc, dp, xchk_nlinks_collect_pptr, xnc);
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
 
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 83f8637bb08fd..78d0f650fe897 100644
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
index f14e6f643fb60..068691434be17 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -873,3 +873,64 @@ xchk_parent(
 
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
index b2ce7b22cad34..4a8cc2c98d997 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -19,6 +19,7 @@
 #include "xfs_da_format.h"
 #include "xfs_dir2.h"
 #include "xfs_rmap.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 97a106519b531..3e726610b9e32 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -26,6 +26,7 @@ struct xchk_iscan;
 struct xchk_nlink;
 struct xchk_fscounters;
 struct xfs_rmap_update_params;
+struct xfs_parent_rec;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -1363,6 +1364,33 @@ TRACE_EVENT(xchk_nlinks_collect_dirent,
 		  __get_str(name))
 );
 
+TRACE_EVENT(xchk_nlinks_collect_pptr,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_inode *dp,
+		 const struct xfs_name *name,
+		 const struct xfs_parent_rec *pptr),
+	TP_ARGS(mp, dp, name, pptr),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, name->len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->dir = dp->i_ino;
+		__entry->ino = be64_to_cpu(pptr->p_ino);
+		__entry->namelen = name->len;
+		memcpy(__get_str(name), name->name, name->len);
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

