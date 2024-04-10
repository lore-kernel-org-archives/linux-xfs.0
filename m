Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1E81854
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710990; cv=none; b=RrEhkC7NywGFEOZ3nc+BsYcJFPxpHH/IHxWKry78oSOZKOthnoRXNxZEgmfTV42uhDyuHaH8YjVkRSy5yJsyoEDNJuVHZ91AvI9Fw6/eEo6o4JwKcZtaWyjvDke52GyHZI5T+RBH3bQukduSKjp0d7Tevk7Z5rXwwHZ4QLww5nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710990; c=relaxed/simple;
	bh=j5e3khGmG+8B0kzMmItAACsoBcrHYaQZXDLXnWMquhE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M0zxKhr0mkIWo1ldLxedWS9bFJqexPI5HddskGHCB9bIhWChldWa8DKOZQxUG13R3CRgf5hT5/Z3dTbm4iRmo4kAkoLMyXSULd26KQrnEkJj/ola9GEmg6qDs4//58iH8yINP+D1L6LMG9pJ+jUSC5MVQ0KhQJtKgdY/8P1AfWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=moyac4e+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="moyac4e+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF27C433F1;
	Wed, 10 Apr 2024 01:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710990;
	bh=j5e3khGmG+8B0kzMmItAACsoBcrHYaQZXDLXnWMquhE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=moyac4e+YbEYmfYLquWFmowTD2XCzenS1DMdZEMizCSXBakB0Gvj21s1QDGStk9ij
	 6Xl+bZX13MmQVYai0Yra33b5c5P7dcwuHvLq74UBh6b+Sr6JaaRRqbHLVlfNmY9FyF
	 O5/meIC9oonYCwz40ILVlHL6KS2FSJuwR26GIkKIarE25dDyzq9TGDQgwtMuuuUQF3
	 zyqt8gZjBkAg/3Pq9E4Y8Ncju0tCesKIhJGRyZYr34qTgY+P+HhrTt/RIi8/FExgB3
	 RLb34yEtThzVxMTDqDXaJdhmScEIKY1bQvS2RKDfBwhsEmuTyXIBGR5AKdknotWaE2
	 qDzZQIS7NpPKA==
Date: Tue, 09 Apr 2024 18:03:09 -0700
Subject: [PATCH 5/7] xfs: walk directory parent pointers to determine backref
 count
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270970550.3632713.9842307177705801451.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
References: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/nlinks.c        |   82 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/nlinks_repair.c |    2 +
 fs/xfs/scrub/parent.c        |   61 +++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.c         |    1 +
 fs/xfs/scrub/trace.h         |   28 ++++++++++++++
 6 files changed, 174 insertions(+), 1 deletion(-)


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
index fcb9c473f372e..a733e4e178de4 100644
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
@@ -314,6 +321,58 @@ xchk_nlinks_collect_dirent(
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
+	int				ret;
+
+	/* Update the shadow link counts if we haven't already failed. */
+
+	if (xchk_iscan_aborted(&xnc->collect_iscan)) {
+		ret = -ECANCELED;
+		goto out_incomplete;
+	}
+
+	ret = xfs_parent_from_xattr(sc->mp, attr_flags, name, namelen,
+			value, valuelen, &parent_ino, NULL);
+	if (ret != 1)
+		return ret;
+
+	trace_xchk_nlinks_collect_pptr(sc->mp, ip, &xname, pptr_rec);
+
+	mutex_lock(&xnc->lock);
+
+	ret = xchk_nlinks_update_incore(xnc, parent_ino, 0, 1, 0);
+	if (ret)
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
+	return ret;
+}
+
 /* Walk a directory to bump the observed link counts of the children. */
 STATIC int
 xchk_nlinks_collect_dir(
@@ -360,6 +419,27 @@ xchk_nlinks_collect_dir(
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
index cb50e89e7ee64..57b49fbf97a30 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -866,3 +866,64 @@ xchk_parent(
 
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

