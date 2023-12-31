Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A15BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OwJ2Ltfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00521C433C7;
	Sun, 31 Dec 2023 21:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056477;
	bh=FelCmYeDJgURKhK8ly35uUxZ18lasoBlbtNywSwtD34=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OwJ2LtfiVj8XNg4TYgCD5wk9hRMPu5vXXqTuYTplMSjBOm06xa4B/MM2lS+kXqx0n
	 a1FSbSX3QFTfTMmigyZC55W1aJzHmNtJIkDC3ImY5DGZBweEOKLSFEMCbR1HpFjk2S
	 LqUsh1YWXnOtKWF5Vhenp2++KvScE2n1Cxo72+LsFUHCvhKBToNQCoU9S62ofXTvzY
	 B/bHEKwt6qWr3RlNigwNVEVJkMCSoZEW1dZasRMR1IyyqaBUZumA1VuaE0B4l359Fk
	 tTIW7S70L4opRAReySwk0h5LcmO89z1zjL7oZvcxIEGETk6zF7wUUX9LLw+c9IyxuE
	 qAC5yDZXzJffA==
Date: Sun, 31 Dec 2023 13:01:16 -0800
Subject: [PATCH 02/21] xfs: hoist extent size helpers to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844084.1759932.5356387635505017940.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
References: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_bmap.c |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |    3 +++
 fs/xfs/xfs_inode.c       |   43 -------------------------------------------
 fs/xfs/xfs_inode.h       |    3 ---
 fs/xfs/xfs_iops.c        |    1 +
 5 files changed, 45 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d34354d2cdd49..dc77b1a59faf8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6363,3 +6363,44 @@ xfs_bmap_query_all(
 
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
+	if (XFS_IS_REALTIME_INODE(ip))
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
index c9e297dba88d0..bd7f936262cc6 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -294,4 +294,7 @@ typedef int (*xfs_bmap_query_range_fn)(
 int xfs_bmap_query_all(struct xfs_btree_cur *cur, xfs_bmap_query_range_fn fn,
 		void *priv);
 
+xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
+xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 199def25c0343..0c8fe6437e31b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -45,49 +45,6 @@
 
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
-	if (XFS_IS_REALTIME_INODE(ip))
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
index f6c463ce46424..91a5a77910b3d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -559,9 +559,6 @@ int		xfs_iflush_cluster(struct xfs_buf *);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
-xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
-xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
-
 int xfs_init_new_inode(struct mnt_idmap *idmap, struct xfs_trans *tp,
 		struct xfs_inode *pip, xfs_ino_t ino, umode_t mode,
 		xfs_nlink_t nlink, dev_t rdev, prid_t prid, bool init_xattrs,
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 62b425129d11c..8f5b8f8973a5f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -26,6 +26,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
 #include "xfs_file.h"
+#include "xfs_bmap.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>

