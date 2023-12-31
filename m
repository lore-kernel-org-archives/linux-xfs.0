Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD194C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fUQ23TRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBE6C433C7;
	Sun, 31 Dec 2023 23:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064954;
	bh=Fdm14lURj8F77SdEPNq96FTcAN/rZ2XWGmtKsDWni4E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fUQ23TRwynybw1OKFGLNBQsW0Wv8GLR75m79u52zgVv3YH70TS9NXrIcX6OaJQsO7
	 YFoMXNB/zLYqFYX18VSx6s3ERGEnZXaBo3Yf1hYE2w6k0ACo1hT4FM+TScOI1C8CHS
	 y6LKbn4/mE/3etc8yCKpdRlZxF7LhkBoVZLq+1kmE9lslwlLRpKnWxHEAIoSO8oExK
	 UyrRY9D2hJ7fzHWBkoHoK/Y7V3qKX/P2o9crwR9hqWHnzPYZt4x/KNEWIcsAktMpS+
	 41ye+FROeJEDJIYjn7TcKD7vKASnsihoaYWYZ9VmWjnjbpON+XaZZbW71gAHpnjNyR
	 63N91MGj4c8zA==
Date: Sun, 31 Dec 2023 15:22:33 -0800
Subject: [PATCH 01/28] xfs: hoist extent size helpers to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009192.1808635.8579807747896420924.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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
 include/xfs_inode.h  |    7 +++++++
 libxfs/libxfs_priv.h |    2 --
 libxfs/xfs_bmap.c    |   41 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_bmap.h    |    3 +++
 4 files changed, 51 insertions(+), 2 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 496d504747c..42db70f8144 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -340,6 +340,11 @@ static inline bool xfs_inode_has_bigallocunit(struct xfs_inode *ip)
 	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
 }
 
+static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
+{
+	return false;
+}
+
 /* Always set the child's GID to this value, even if the parent is setgid. */
 #define CRED_FORCE_GID	(1U << 0)
 struct cred {
@@ -365,4 +370,6 @@ extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 				uint, struct xfs_inode **);
 extern void	libxfs_irele(struct xfs_inode *ip);
 
+#define XFS_DEFAULT_COWEXTSZ_HINT 32
+
 #endif /* __XFS_INODE_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 123e25d2f5e..90149b60c57 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -459,8 +459,6 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 
 #define xfs_rotorstep				1
 #define xfs_bmap_rtalloc(a)			(-ENOSYS)
-#define xfs_get_extsz_hint(ip)			(0)
-#define xfs_get_cowextsz_hint(ip)		(0)
 #define xfs_inode_is_filestream(ip)		(0)
 #define xfs_filestream_lookup_ag(ip)		(0)
 #define xfs_filestream_new_ag(ip,ag)		(0)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5c69720e19e..15553659612 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6357,3 +6357,44 @@ xfs_bmap_query_all(
 
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
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index c9e297dba88..bd7f936262c 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -294,4 +294,7 @@ typedef int (*xfs_bmap_query_range_fn)(
 int xfs_bmap_query_all(struct xfs_btree_cur *cur, xfs_bmap_query_range_fn fn,
 		void *priv);
 
+xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
+xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
+
 #endif	/* __XFS_BMAP_H__ */

