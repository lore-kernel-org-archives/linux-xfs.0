Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D951A071C
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636939; cv=none; b=IXiNnC0AYtmJKltsq8MtbF7cjdB1MIkDg25A7hw+muqnOI+9tJikZq+kohTvmvLhmKZnNNWpKXOc0yZG8c1qvzoqlOFDAN+cnq4ZWd/YycyOdYF7H/x/1SrAr6nlDmwDlvBN4B5hhO8dg/4ZNLF0QAiIrYpR5FJODMBeRofRQ/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636939; c=relaxed/simple;
	bh=KUve35+d8Cyk0E4Mq8P15qOer39UE5rSBUt52ChzK0I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ue/l7Moc6pVHOAwSQslc3ZjnU2gBXHoUjhY3N9lQ1Yyurj/1dDFj64ACq/nrl6RcZzMXE36d62zAzB/MGB5M0knZf5BV3FxR1Khk6HnAEvejHUI6IDJLy23WepE8JN6Z/M5rJdL5aBk5MfEmKdSlMMLfE5YGzmWJmD074TEmMDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4XpSoh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4XpSoh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AFAC4CED0;
	Thu, 19 Dec 2024 19:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636939;
	bh=KUve35+d8Cyk0E4Mq8P15qOer39UE5rSBUt52ChzK0I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U4XpSoh0YKtMO01Ld5eezIWBJKomfScuuuh28Lqoa/1nEr1CbAUkXGec2auRdKEui
	 /XBEh3xnh3OPrQPXRVHv0GOZYoUV09oQ/q+TDN/CgtNv9jLgZrOiiX1bBeCJcNsURh
	 mTFCIqylF8y/l2/Yssp0qV1WQTW/hadtJk4WB0R2oB0MUyg6yas06cgF6vFS+8pgAo
	 tth14kLtmTMH/TN7oVbYZQcOY8YyeT/Qo83ksAwbY6JansQu2vvxvA6DcP2PLrjB5B
	 PWo746uqm3jvHQmOxL7KgVNhc9ezWSuNIC1l0sTmav2sXF1m8iP6hoiwmCxF0gYvMx
	 zHRgpXHTX4/yw==
Date: Thu, 19 Dec 2024 11:35:38 -0800
Subject: [PATCH 10/43] xfs: add realtime refcount btree inode to metadata
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581149.1572761.10672546631951013453.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
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

