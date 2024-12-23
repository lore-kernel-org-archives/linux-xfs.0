Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91682837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995334; cv=none; b=YzNvKomOvXiljxXWnJzIOib8+7C6jJdk2o3/HirsgSODE8ML9iX5gifHbEHPU/tchORVftRZI7ruXaVL/uheThnKbTn1VYoez7cIDQkdHihAkNeD4M4PVkLXExQZowSynVgiYT3XNSrSFRlhu1TRK8oj8/C2kVVO/93LyyNnXcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995334; c=relaxed/simple;
	bh=KUve35+d8Cyk0E4Mq8P15qOer39UE5rSBUt52ChzK0I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HPWt5b9sjbs6a0EBDR4zM5U/ZGGDXdICsqt7GcpaHeVcnZtRe62VRwPYwwfONvld4cKJhsv2pKRsWBlbwmznBi/sXhsv7RCX30IgzAvL3LVzmGoxewKJY8+2Kc8aj5CW9qoMOnSEViyQdZSUyNESgPiNC3KvT+C9dGHEYeP8XWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LeLCtduV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LeLCtduV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCB4C4CED3;
	Mon, 23 Dec 2024 23:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995334;
	bh=KUve35+d8Cyk0E4Mq8P15qOer39UE5rSBUt52ChzK0I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LeLCtduVYftFAuggcZdAgDvT4ho3rqDUwwUkrEiC0tONVg7kWRdCE0BVR+yebRTf6
	 aOZD7nWKH+zXaAsZeg+rmk4hUVl6vW19Q6UwwXZMiRw/FbXrV5YbTfMvqW0Nydd8PZ
	 kQh7V49SWpFuYqfcmnf90mVPJGQhK+111XFGawUgJgmjaHYW9s9Lp3O6HJCC+zkg6S
	 CptFFLNN6QhYWrDehdUsC9LiOZztWEdEBXSXoD+XzQLjqSxwmDdJsdJZDs9cNtxlR2
	 vzYW44WrkFXvxnUAmlDRO9kdWkMaQu9efnCZ3spEYwualx8YFGHX5KuhL54n3kEEzg
	 6u4KSiMcPTOoQ==
Date: Mon, 23 Dec 2024 15:08:53 -0800
Subject: [PATCH 10/43] xfs: add realtime refcount btree inode to metadata
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420109.2381378.10521661467070075020.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a metadir path to select the realtime refcount btree inode and load
it at mount time.  The rtrefcountbt inode will have a unique extent format
code, which means that we also have to update the inode validation and
flush routines to look for it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h           |    4 +++-
 fs/xfs/libxfs/xfs_inode_buf.c        |    5 +++++
 fs/xfs/libxfs/xfs_inode_fork.c       |    6 ++++++
 fs/xfs/libxfs/xfs_rtgroup.c          |    7 +++++++
 fs/xfs/libxfs/xfs_rtgroup.h          |    6 ++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |    6 +++---
 6 files changed, 30 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 17f7c0d1aaa452..b6828f92c131fb 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -858,6 +858,7 @@ enum xfs_metafile_type {
 	XFS_METAFILE_RTBITMAP,		/* rt bitmap */
 	XFS_METAFILE_RTSUMMARY,		/* rt summary */
 	XFS_METAFILE_RTRMAP,		/* rt rmap */
+	XFS_METAFILE_RTREFCOUNT,	/* rt refcount */
 
 	XFS_METAFILE_MAX
 } __packed;
@@ -870,7 +871,8 @@ enum xfs_metafile_type {
 	{ XFS_METAFILE_PRJQUOTA,	"prjquota" }, \
 	{ XFS_METAFILE_RTBITMAP,	"rtbitmap" }, \
 	{ XFS_METAFILE_RTSUMMARY,	"rtsummary" }, \
-	{ XFS_METAFILE_RTRMAP,		"rtrmap" }
+	{ XFS_METAFILE_RTRMAP,		"rtrmap" }, \
+	{ XFS_METAFILE_RTREFCOUNT,	"rtrefcount" }
 
 /*
  * On-disk inode structure.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 17cb91b89fcaa1..65eec8f60376d3 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -456,6 +456,11 @@ xfs_dinode_verify_fork(
 			if (!xfs_has_rmapbt(mp))
 				return __this_address;
 			break;
+		case XFS_METAFILE_RTREFCOUNT:
+			/* same comment about growfs and rmap inodes applies */
+			if (!xfs_has_reflink(mp))
+				return __this_address;
+			break;
 		default:
 			return __this_address;
 		}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index d9b3c182cb400b..0c4bc12401a151 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -272,6 +272,9 @@ xfs_iformat_data_fork(
 			switch (ip->i_metatype) {
 			case XFS_METAFILE_RTRMAP:
 				return xfs_iformat_rtrmap(ip, dip);
+			case XFS_METAFILE_RTREFCOUNT:
+				ASSERT(0); /* to be implemented later */
+				return -EFSCORRUPTED;
 			default:
 				break;
 			}
@@ -620,6 +623,9 @@ xfs_iflush_fork(
 		case XFS_METAFILE_RTRMAP:
 			xfs_iflush_rtrmap(ip, dip);
 			break;
+		case XFS_METAFILE_RTREFCOUNT:
+			ASSERT(0); /* to be implemented later */
+			break;
 		default:
 			ASSERT(0);
 			break;
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index b7ed2d27d54553..6aebe9f484901f 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -367,6 +367,13 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 		.enabled	= xfs_has_rmapbt,
 		.create		= xfs_rtrmapbt_create,
 	},
+	[XFS_RTGI_REFCOUNT] = {
+		.name		= "refcount",
+		.metafile_type	= XFS_METAFILE_RTREFCOUNT,
+		.fmt_mask	= 1U << XFS_DINODE_FMT_META_BTREE,
+		/* same comment about growfs and rmap inodes applies here */
+		.enabled	= xfs_has_reflink,
+	},
 };
 
 /* Return the shortname of this rtgroup inode. */
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 733da7417c9cd7..385ea8e2f28b67 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -15,6 +15,7 @@ enum xfs_rtg_inodes {
 	XFS_RTGI_BITMAP,	/* allocation bitmap */
 	XFS_RTGI_SUMMARY,	/* allocation summary */
 	XFS_RTGI_RMAP,		/* rmap btree inode */
+	XFS_RTGI_REFCOUNT,	/* refcount btree inode */
 
 	XFS_RTGI_MAX,
 };
@@ -80,6 +81,11 @@ static inline struct xfs_inode *rtg_rmap(const struct xfs_rtgroup *rtg)
 	return rtg->rtg_inodes[XFS_RTGI_RMAP];
 }
 
+static inline struct xfs_inode *rtg_refcount(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_inodes[XFS_RTGI_REFCOUNT];
+}
+
 /* Passive rtgroup references */
 static inline struct xfs_rtgroup *
 xfs_rtgroup_get(
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index e30af941581651..ebbeab112d1412 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -26,6 +26,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_metafile.h"
 
 static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
 
@@ -281,12 +282,10 @@ xfs_rtrefcountbt_init_cursor(
 	struct xfs_trans	*tp,
 	struct xfs_rtgroup	*rtg)
 {
-	struct xfs_inode	*ip = NULL;
+	struct xfs_inode	*ip = rtg_refcount(rtg);
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_btree_cur	*cur;
 
-	return NULL; /* XXX */
-
 	xfs_assert_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rtrefcountbt_ops,
@@ -316,6 +315,7 @@ xfs_rtrefcountbt_commit_staged_btree(
 	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(ifake->if_fork->if_format == XFS_DINODE_FMT_META_BTREE);
 
 	/*
 	 * Free any resources hanging off the real fork, then shallow-copy the

