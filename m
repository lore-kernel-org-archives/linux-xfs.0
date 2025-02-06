Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD4B23C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881620; cv=none; b=VItTr+ipv1m3R1Njfh9q16zsMRn+6dCj8i8G7SIr3uPpRI9hnUiWJkJJGifzchpTHAKA0sDYCyGg2Ajcr4prEoAWowFRSobFhOI/fqF/gV1ZZRD6EWLLUAyOiaOBKaFi+HeX4V6E3KB/im4pqFccaeLp3fwdAzOLanie/ShzpKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881620; c=relaxed/simple;
	bh=PhEwxvkQ/c2uxsd5s+0livUfbIrU+43TMiPITok/Tjs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ofzg0uVOjXxdLSHTV3nAeeoeLRxeQ3r/sD6yAcMn+kH33H4RcEyDlh8UoGiV5U4LVHGgPQUYaRAO9DHZrQiaGp1pkD8fhuFObWODGlh3hfaU8ttefDIjUXFrIgUNXSnBQsET1VuQV5cmh/p+9Qkp1HSgouyWLCr9wvs+hMjktv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqTKJhr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqTKJhr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C922EC4CEDD;
	Thu,  6 Feb 2025 22:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881619;
	bh=PhEwxvkQ/c2uxsd5s+0livUfbIrU+43TMiPITok/Tjs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eqTKJhr1ZXX5VVlk7lv8tix93Ok0xqdR0WXGBt04Z7sigHvXU9WYKonFGt4LnGyTI
	 z3xCNCXD4E9RZdZVD1b3YYXccb7T47/9isB9Ni5ERRNpedkPWxbe5NUhxfD831PYwZ
	 PT0I8rYsoPZWwfIagRbNGq6ocvq+LDEGPXSixVn1YQB51BbszWajQrWBoEcC7+bhTO
	 aGO1VPPAG0ybghZT4MzeWbwi7kcGi8f3hRgG0InmpU+cGLx+NCh4KMV8BH4JkYeAW1
	 ll6HBuLBuwefigS72EHHEIbuFx5EjC+E5MPts21kRpMsMJ1OO+q4ZIo78yFUuxKomC
	 LevBWB/rt5GTA==
Date: Thu, 06 Feb 2025 14:40:19 -0800
Subject: [PATCH 20/56] xfs: add realtime reverse map inode to metadata
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087098.2739176.11165433522164906747.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 6b08901a6e8fcda555f3ad39abd73bb0dd37f231

Add a metadir path to select the realtime rmap btree inode and load
it at mount time.  The rtrmapbt inode will have a unique extent format
code, which means that we also have to update the inode validation and
flush routines to look for it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h       |    4 +++-
 libxfs/xfs_inode_buf.c    |    9 +++++++++
 libxfs/xfs_inode_fork.c   |    6 ++++++
 libxfs/xfs_rtgroup.c      |   20 ++++++++++++++++++--
 libxfs/xfs_rtgroup.h      |    8 ++++++++
 libxfs/xfs_rtrmap_btree.c |    6 +++---
 6 files changed, 47 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 41ea4283c43cb4..f32c9fda5a195f 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -857,6 +857,7 @@ enum xfs_metafile_type {
 	XFS_METAFILE_PRJQUOTA,		/* project quota */
 	XFS_METAFILE_RTBITMAP,		/* rt bitmap */
 	XFS_METAFILE_RTSUMMARY,		/* rt summary */
+	XFS_METAFILE_RTRMAP,		/* rt rmap */
 
 	XFS_METAFILE_MAX
 } __packed;
@@ -868,7 +869,8 @@ enum xfs_metafile_type {
 	{ XFS_METAFILE_GRPQUOTA,	"grpquota" }, \
 	{ XFS_METAFILE_PRJQUOTA,	"prjquota" }, \
 	{ XFS_METAFILE_RTBITMAP,	"rtbitmap" }, \
-	{ XFS_METAFILE_RTSUMMARY,	"rtsummary" }
+	{ XFS_METAFILE_RTSUMMARY,	"rtsummary" }, \
+	{ XFS_METAFILE_RTRMAP,		"rtrmap" }
 
 /*
  * On-disk inode structure.
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 10ce2e34969d99..0278fbb6379701 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -444,6 +444,15 @@ xfs_dinode_verify_fork(
 		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
 			return __this_address;
 		switch (be16_to_cpu(dip->di_metatype)) {
+		case XFS_METAFILE_RTRMAP:
+			/*
+			 * growfs must create the rtrmap inodes before adding a
+			 * realtime volume to the filesystem, so we cannot use
+			 * the rtrmapbt predicate here.
+			 */
+			if (!xfs_has_rmapbt(mp))
+				return __this_address;
+			break;
 		default:
 			return __this_address;
 		}
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index b66dc4ad0f52ef..7c481d159cce15 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -267,6 +267,9 @@ xfs_iformat_data_fork(
 			return xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
 		case XFS_DINODE_FMT_META_BTREE:
 			switch (ip->i_metatype) {
+			case XFS_METAFILE_RTRMAP:
+				ASSERT(0); /* to be implemented later */
+				return -EFSCORRUPTED;
 			default:
 				break;
 			}
@@ -612,6 +615,9 @@ xfs_iflush_fork(
 			break;
 
 		switch (ip->i_metatype) {
+		case XFS_METAFILE_RTRMAP:
+			ASSERT(0); /* to be implemented later */
+			break;
 		default:
 			ASSERT(0);
 			break;
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index b9da90c5062dc1..d46ce8e7fa6e85 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -312,6 +312,8 @@ struct xfs_rtginode_ops {
 
 	unsigned int		sick;	/* rtgroup sickness flag */
 
+	unsigned int		fmt_mask; /* all valid data fork formats */
+
 	/* Does the fs have this feature? */
 	bool			(*enabled)(struct xfs_mount *mp);
 
@@ -327,14 +329,29 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 		.name		= "bitmap",
 		.metafile_type	= XFS_METAFILE_RTBITMAP,
 		.sick		= XFS_SICK_RG_BITMAP,
+		.fmt_mask	= (1U << XFS_DINODE_FMT_EXTENTS) |
+				  (1U << XFS_DINODE_FMT_BTREE),
 		.create		= xfs_rtbitmap_create,
 	},
 	[XFS_RTGI_SUMMARY] = {
 		.name		= "summary",
 		.metafile_type	= XFS_METAFILE_RTSUMMARY,
 		.sick		= XFS_SICK_RG_SUMMARY,
+		.fmt_mask	= (1U << XFS_DINODE_FMT_EXTENTS) |
+				  (1U << XFS_DINODE_FMT_BTREE),
 		.create		= xfs_rtsummary_create,
 	},
+	[XFS_RTGI_RMAP] = {
+		.name		= "rmap",
+		.metafile_type	= XFS_METAFILE_RTRMAP,
+		.fmt_mask	= 1U << XFS_DINODE_FMT_META_BTREE,
+		/*
+		 * growfs must create the rtrmap inodes before adding a
+		 * realtime volume to the filesystem, so we cannot use the
+		 * rtrmapbt predicate here.
+		 */
+		.enabled	= xfs_has_rmapbt,
+	},
 };
 
 /* Return the shortname of this rtgroup inode. */
@@ -431,8 +448,7 @@ xfs_rtginode_load(
 		return error;
 	}
 
-	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
-			       ip->i_df.if_format != XFS_DINODE_FMT_BTREE)) {
+	if (XFS_IS_CORRUPT(mp, !((1U << ip->i_df.if_format) & ops->fmt_mask))) {
 		xfs_irele(ip);
 		xfs_rtginode_mark_sick(rtg, type);
 		return -EFSCORRUPTED;
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index bff319fa5a7173..09ec9f0e660160 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -14,6 +14,7 @@ struct xfs_trans;
 enum xfs_rtg_inodes {
 	XFS_RTGI_BITMAP,	/* allocation bitmap */
 	XFS_RTGI_SUMMARY,	/* allocation summary */
+	XFS_RTGI_RMAP,		/* rmap btree inode */
 
 	XFS_RTGI_MAX,
 };
@@ -74,6 +75,11 @@ static inline struct xfs_inode *rtg_summary(const struct xfs_rtgroup *rtg)
 	return rtg->rtg_inodes[XFS_RTGI_SUMMARY];
 }
 
+static inline struct xfs_inode *rtg_rmap(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_inodes[XFS_RTGI_RMAP];
+}
+
 /* Passive rtgroup references */
 static inline struct xfs_rtgroup *
 xfs_rtgroup_get(
@@ -284,6 +290,8 @@ int xfs_rtginode_create(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
 		bool init);
 void xfs_rtginode_irele(struct xfs_inode **ipp);
 
+void xfs_rtginode_irele(struct xfs_inode **ipp);
+
 static inline const char *xfs_rtginode_path(xfs_rgnumber_t rgno,
 		enum xfs_rtg_inodes type)
 {
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 3c135648dfce4e..4c3b4a302bd778 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -18,6 +18,7 @@
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
+#include "xfs_metafile.h"
 #include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_trace.h"
@@ -403,12 +404,10 @@ xfs_rtrmapbt_init_cursor(
 	struct xfs_trans	*tp,
 	struct xfs_rtgroup	*rtg)
 {
-	struct xfs_inode	*ip = NULL;
+	struct xfs_inode	*ip = rtg_rmap(rtg);
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_btree_cur	*cur;
 
-	return NULL; /* XXX */
-
 	xfs_assert_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rtrmapbt_ops,
@@ -437,6 +436,7 @@ xfs_rtrmapbt_commit_staged_btree(
 	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(ifake->if_fork->if_format == XFS_DINODE_FMT_META_BTREE);
 
 	/*
 	 * Free any resources hanging off the real fork, then shallow-copy the

