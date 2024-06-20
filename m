Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2FD142E62
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 22:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924352; cv=none; b=D97OTICXBwOdMDv8C49rblllA0RW2LgYfBin1yEISNx9hY9e6hqBVu68LhSSZVxBvZpzwzUpchzzOA08aiukaJeTOov0j+hjln+ux5KGGFn0ru9RqQxP5wpj+fyFncO4KB/WMKbfKtTJx0vTRBsAJhPeGeYEM7DfWxeb9M12C9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924352; c=relaxed/simple;
	bh=1VYzQgM+bAk03Z9B/rZ4F48B06vpVKi5RCLm3i4vfXg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VHBccWHWCLsyrIyGzYZmhGt+FuN3gkSji7yxuGNAnrJAV6Yk+77qPnWMJUrPku7HOBwQcroCdMVWXeJ53jKTydr83kqlsiBAZMN4GF/lgwXl8jRBGW5oG5TwpilrFDo+76pT4QFbw+gLIlMHu+xvh2vLCRUMbBzRrRlPiyS7fTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHYBcYc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHYBcYc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C871C2BD10;
	Thu, 20 Jun 2024 22:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924351;
	bh=1VYzQgM+bAk03Z9B/rZ4F48B06vpVKi5RCLm3i4vfXg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aHYBcYc5UA+FLgBaFyE+/XZ+mz/Ph1b3u32kdFBXRqf5yyhNUWvBJX3HkKoBIB/9W
	 tHbRjIBh0h3LRkizx1HyySv+BKm3QI8dZ27E+YIdT6MXZXjDlCH4F8KyK8epfguvjl
	 43sf8He25NQ5zDiqTRlyCv8uDBKWAEhf/0ukerxrXs1KMB/YddyYap6Ddg+lgFP52/
	 DR+5Bf4oOq0ootFrpJkZtQGBbmx98AuHGgT8xgu7bqBK3C3mzcomXR3CF3COSRsQdb
	 TWKUKmqv2IJpwgM4P9Oq6JUn3F6GliDJUUwDFCA9v37uHiVfbHA9c3JOGn1USCMrWC
	 JvQlK6SYlMNeg==
Date: Thu, 20 Jun 2024 15:59:11 -0700
Subject: [PATCH 03/24] xfs: hoist extent size helpers to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892417945.3183075.16613633853216031887.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
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

Move the extent size helpers to xfs_bmap.c in libxfs since they're used
there already.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |    3 +++
 fs/xfs/xfs_inode.c       |   44 --------------------------------------------
 fs/xfs/xfs_inode.h       |    3 ---
 fs/xfs/xfs_iops.c        |    1 +
 5 files changed, 46 insertions(+), 47 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6af6f744fdd6a..f889123126d22 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6454,3 +6454,45 @@ xfs_bmap_query_all(
 
 	return xfs_btree_query_all(cur, xfs_bmap_query_range_helper, &query);
 }
+
+/* Helper function to extract extent size hint from inode */
+xfs_extlen_t
+xfs_get_extsz_hint(
+	struct xfs_inode	*ip)
+{
+	/*
+	 * No point in aligning allocations if we need to COW to actually
+	 * write to them.
+	 */
+	if (xfs_is_always_cow_inode(ip))
+		return 0;
+	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
+		return ip->i_extsize;
+	if (XFS_IS_REALTIME_INODE(ip) &&
+	    ip->i_mount->m_sb.sb_rextsize > 1)
+		return ip->i_mount->m_sb.sb_rextsize;
+	return 0;
+}
+
+/*
+ * Helper function to extract CoW extent size hint from inode.
+ * Between the extent size hint and the CoW extent size hint, we
+ * return the greater of the two.  If the value is zero (automatic),
+ * use the default size.
+ */
+xfs_extlen_t
+xfs_get_cowextsz_hint(
+	struct xfs_inode	*ip)
+{
+	xfs_extlen_t		a, b;
+
+	a = 0;
+	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
+		a = ip->i_cowextsize;
+	b = xfs_get_extsz_hint(ip);
+
+	a = max(a, b);
+	if (a == 0)
+		return XFS_DEFAULT_COWEXTSZ_HINT;
+	return a;
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 667b0c2b33d1d..7592d46e97c66 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -296,4 +296,7 @@ typedef int (*xfs_bmap_query_range_fn)(
 int xfs_bmap_query_all(struct xfs_btree_cur *cur, xfs_bmap_query_range_fn fn,
 		void *priv);
 
+xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
+xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 03f685c3b6ada..a00072adcb679 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -46,50 +46,6 @@
 
 struct kmem_cache *xfs_inode_cache;
 
-/*
- * helper function to extract extent size hint from inode
- */
-xfs_extlen_t
-xfs_get_extsz_hint(
-	struct xfs_inode	*ip)
-{
-	/*
-	 * No point in aligning allocations if we need to COW to actually
-	 * write to them.
-	 */
-	if (xfs_is_always_cow_inode(ip))
-		return 0;
-	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
-		return ip->i_extsize;
-	if (XFS_IS_REALTIME_INODE(ip) &&
-	    ip->i_mount->m_sb.sb_rextsize > 1)
-		return ip->i_mount->m_sb.sb_rextsize;
-	return 0;
-}
-
-/*
- * Helper function to extract CoW extent size hint from inode.
- * Between the extent size hint and the CoW extent size hint, we
- * return the greater of the two.  If the value is zero (automatic),
- * use the default size.
- */
-xfs_extlen_t
-xfs_get_cowextsz_hint(
-	struct xfs_inode	*ip)
-{
-	xfs_extlen_t		a, b;
-
-	a = 0;
-	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
-		a = ip->i_cowextsize;
-	b = xfs_get_extsz_hint(ip);
-
-	a = max(a, b);
-	if (a == 0)
-		return XFS_DEFAULT_COWEXTSZ_HINT;
-	return a;
-}
-
 /*
  * These two are wrapper routines around the xfs_ilock() routine used to
  * centralize some grungy code.  They are used in places that wish to lock the
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e97b2b838c69b..0e642afa77a7c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -563,9 +563,6 @@ int		xfs_iflush_cluster(struct xfs_buf *);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
-xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
-xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
-
 int xfs_init_new_inode(struct mnt_idmap *idmap, struct xfs_trans *tp,
 		struct xfs_inode *pip, xfs_ino_t ino, umode_t mode,
 		xfs_nlink_t nlink, dev_t rdev, prid_t prid, bool init_xattrs,
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ff222827e5508..35a84790d26e6 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -26,6 +26,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
 #include "xfs_file.h"
+#include "xfs_bmap.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>

