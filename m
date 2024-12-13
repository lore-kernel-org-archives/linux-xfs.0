Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C619917C60
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052371; cv=none; b=pgYSQio24dUmRH9Xuirs4VrZfxmYI6bIAafaN2oieGsfT7S81432DIpjz4G1G/jnqoYtArpOv66iI8ZbQYH3nLd0u+azDSHkbaWogaswHZO88v62jp4ieRLkSJxsUCAoFH25c2C4ymIWDsv1HKShEMa7+vhluHbq2tliFsfQScg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052371; c=relaxed/simple;
	bh=GsVkTikSfVvq6Y2fDIYZdPuGMLnaHTwkBGPgePrSMZ8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ad7rjNYo5Jpb0earz39QEacLPIEpqpeYZZC/6V/8WCZesGeB9+dzx/jnuZ15PGyVSAYhp7UTuJiciTfLvoiKGx85riJ1GqpDt+Ae5ZEw0DvJ4rJUVZjwMP663X7I+u2+QFOwJyf+8cCmZABzOGlvG+RN74x8PeajRgKMmtcEVzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A82zAXnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A82zAXnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BB0C4CECE;
	Fri, 13 Dec 2024 01:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052371;
	bh=GsVkTikSfVvq6Y2fDIYZdPuGMLnaHTwkBGPgePrSMZ8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A82zAXnNjICbGHugRWDG20yus9z+tJ7WdGtvrX4w57p3Ly1mCYY6SyP7dWFm5mFD/
	 fNFSIYDqGhlHeIELTnC89unzMWiHKdrWy7IzLMhxQ2cy32FnIG9jLv2Laxq0SyHn9P
	 nyC09CbLZQ9QP0v6Y+arYZMedJ/FT+4EesRQv7wkCxUB3uc2AWcXIrre4Dy7GruIfK
	 437+QR3lXJhAZkMC0Vp4DNauCpAOmI73q2fCURJbMq71s3xFhutoxOursVVPJVdqjq
	 KNdS3PkY3jgONtMzOe4LUkAaprAtgUkTVmyLPeeOau/5ULvJMOXox4CHcmtgL2Foj0
	 79QYscTVX+Bkg==
Date: Thu, 12 Dec 2024 17:12:51 -0800
Subject: [PATCH 10/43] xfs: add realtime refcount btree inode to metadata
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124739.1182620.2706215775665123492.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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
index d1a04b45ac5492..8d33751a3a83b3 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -273,6 +273,9 @@ xfs_iformat_data_fork(
 			switch (ip->i_metatype) {
 			case XFS_METAFILE_RTRMAP:
 				return xfs_iformat_rtrmap(ip, dip);
+			case XFS_METAFILE_RTREFCOUNT:
+				ASSERT(0); /* to be implemented later */
+				return -EFSCORRUPTED;
 			default:
 				break;
 			}
@@ -621,6 +624,9 @@ xfs_iflush_fork(
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

