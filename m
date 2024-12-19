Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230261AAA3F
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636393; cv=none; b=ux+8T9wI15+EjdGManK3XD3tjERz+TVi+TXfiB23OdOWtX/KMKVEnKojnXVjOVVAQ1epfOic8fymDE3IyMZFYgyB/9RWjQG+BqWYBn3eOoGrrGV9LFmplP9y2yIiofA9/BnaxzzeDtKvzaMBHhIA1XoZHTpEAY1dvIs5AoD/szg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636393; c=relaxed/simple;
	bh=WFCYCihtat7tCcwwY9qEi2JiM8+ywkRNm9pJxU5iMQ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gnQtCErROsgJl5j2gOS+NgYY3MO2moUlql9RczS6mpclAGyxwPyiBPqyI+vAW0hY4YWESuhAhoYznbAJadyJ8oO8HHPCYDlc3kgQJiP+l6id8cjeX7+D7kgRjJZZZYtNgkeGda7TZmHFwM4MtCiRyXoticOv2CgRggeO5O81LN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7Xl1G4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7Xl1G4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050B7C4CED0;
	Thu, 19 Dec 2024 19:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636392;
	bh=WFCYCihtat7tCcwwY9qEi2JiM8+ywkRNm9pJxU5iMQ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d7Xl1G4JBkfoRwiibaL26yVTyadSbDtKn3OX7YYK8DI7s+6veLt/WtH1xl80lCcc/
	 yu+/wh1TYaHpRQN9lf+0ptqxZ6ieFphV5rbeJg6lgNz3VvfutzYs9z5KPrnsvH893D
	 Cx/8K18YuWpS3c+dN3BGjwtvLsX/3h67BqpDUgekTW4J5qOgeKR9C/mW2BXNsKcHAb
	 Iawwa2ngXHn0IqVfZ+tjNsWALyr+NLHhyyLPoA4kj92I2UyhKel9mt3QqDsKbjCPTI
	 eOQ/i2zAv/esPzYgfQ5tshMTsHiSK/WA6BBxsrpFqbyDe60RVJer6JMWJfJ4A4JQKy
	 jAhsZRqoMi5GA==
Date: Thu, 19 Dec 2024 11:26:31 -0800
Subject: [PATCH 12/37] xfs: add realtime reverse map inode to metadata
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463579962.1571512.6146265066790833044.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a metadir path to select the realtime rmap btree inode and load
it at mount time.  The rtrmapbt inode will have a unique extent format
code, which means that we also have to update the inode validation and
flush routines to look for it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h       |    4 +++-
 fs/xfs/libxfs/xfs_inode_buf.c    |    9 +++++++++
 fs/xfs/libxfs/xfs_inode_fork.c   |    6 ++++++
 fs/xfs/libxfs/xfs_rtgroup.c      |   20 ++++++++++++++++++--
 fs/xfs/libxfs/xfs_rtgroup.h      |    8 ++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.c |    6 +++---
 6 files changed, 47 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 41ea4283c43cb4..f32c9fda5a195f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 1648d72d6ed95a..17cb91b89fcaa1 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -447,6 +447,15 @@ xfs_dinode_verify_fork(
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1a782339396dc3..7c2b071a58384d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -269,6 +269,9 @@ xfs_iformat_data_fork(
 			return xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
 		case XFS_DINODE_FMT_META_BTREE:
 			switch (ip->i_metatype) {
+			case XFS_METAFILE_RTRMAP:
+				ASSERT(0); /* to be implemented later */
+				return -EFSCORRUPTED;
 			default:
 				break;
 			}
@@ -614,6 +617,9 @@ xfs_iflush_fork(
 			break;
 
 		switch (ip->i_metatype) {
+		case XFS_METAFILE_RTRMAP:
+			ASSERT(0); /* to be implemented later */
+			break;
 		default:
 			ASSERT(0);
 			break;
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 9e5fdc0dc55cef..1b56c13b282788 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -315,6 +315,8 @@ struct xfs_rtginode_ops {
 
 	unsigned int		sick;	/* rtgroup sickness flag */
 
+	unsigned int		fmt_mask; /* all valid data fork formats */
+
 	/* Does the fs have this feature? */
 	bool			(*enabled)(struct xfs_mount *mp);
 
@@ -330,14 +332,29 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
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
@@ -434,8 +451,7 @@ xfs_rtginode_load(
 		return error;
 	}
 
-	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
-			       ip->i_df.if_format != XFS_DINODE_FMT_BTREE)) {
+	if (XFS_IS_CORRUPT(mp, !((1U << ip->i_df.if_format) & ops->fmt_mask))) {
 		xfs_irele(ip);
 		xfs_rtginode_mark_sick(rtg, type);
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index dc3ce660a01307..5b61291d26691f 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
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
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 99d828bb5fe7c3..22aabf326b2ccd 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -18,6 +18,7 @@
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
+#include "xfs_metafile.h"
 #include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_trace.h"
@@ -405,12 +406,10 @@ xfs_rtrmapbt_init_cursor(
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
@@ -439,6 +438,7 @@ xfs_rtrmapbt_commit_staged_btree(
 	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(ifake->if_fork->if_format == XFS_DINODE_FMT_META_BTREE);
 
 	/*
 	 * Free any resources hanging off the real fork, then shallow-copy the

