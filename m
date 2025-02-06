Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80E623C364
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881888; cv=none; b=Bq7+B16DMMWTqGDXSt2LRVVseRv3w1LhReqDZU3A6xS5NJ7vpGU2bw7yDwgnWkmnVM6P6lUupzM8ohTtVBat6ETgTv05yrzYbmp6zpHmuoEOC+8hVLRUm7HLVgcR7KFiWieucdyDnYa/3XATzS0nFbUO66nJOIMO02t5ZrDy90M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881888; c=relaxed/simple;
	bh=buSvvK44oNPLrpF8oAiYY/QZiM1Pm6ZcCbA8LHfvwfc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BkQYSxt9fFX6wvls7kVPAP5tYc7DbSle9yYu3jlXlMZcGIeG9Ay8nGxzqJ669dPf/3/UxaTF0DUQ3S3MDi4lMk6kVzdAXv3n5NrF10RVWBr6TyjWL8QNRb0oBMSiABcQUb9/mr74ozecP1uZfZXCKvSdFJv2XH9pwHuqeb77zm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4A+NzlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4A+NzlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF1FC4CEDD;
	Thu,  6 Feb 2025 22:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881887;
	bh=buSvvK44oNPLrpF8oAiYY/QZiM1Pm6ZcCbA8LHfvwfc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n4A+NzlYXR7t5s7M6t03jlpdI763yOOYyhfdstN0saR/6DNaeMBKjcVJJczBx/tkz
	 Bir41wJJlYVfZTCh85/vx9UPs3CNUnDYNXY1nvYsUJv3uT+FS3UDjgCm1sGHNZXgHU
	 dvNPfxSeqGhCa/RjRWAGf0NB4MioFR9mn7UNw9tT5tv8Hm/3NCBQfBSWrWA9RKnF8T
	 mBjOqns6EI1BfwZfc9yAV184ovTO9O/AIWlCH9UF/FeDSqWC0arxwbYxfp0TVSQBqx
	 vXMm4rdHeHw9wKjeN2gyYooRhXI9U4eiRq9chyPm+C26oYIqvthzbm6lrvd6reuh+b
	 IU//fTOTvHXSw==
Date: Thu, 06 Feb 2025 14:44:46 -0800
Subject: [PATCH 37/56] xfs: add realtime refcount btree inode to metadata
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087359.2739176.1762351611457103233.stgit@frogsfrogsfrogs>
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

Source kernel commit: eaed472c40527e526217aff3737816b44b08b363

Add a metadir path to select the realtime refcount btree inode and load
it at mount time.  The rtrefcountbt inode will have a unique extent format
code, which means that we also have to update the inode validation and
flush routines to look for it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h           |    4 +++-
 libxfs/xfs_inode_buf.c        |    5 +++++
 libxfs/xfs_inode_fork.c       |    6 ++++++
 libxfs/xfs_rtgroup.c          |    7 +++++++
 libxfs/xfs_rtgroup.h          |    6 ++++++
 libxfs/xfs_rtrefcount_btree.c |    6 +++---
 6 files changed, 30 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 17f7c0d1aaa452..b6828f92c131fb 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 0278fbb6379701..0be0625857002c 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -453,6 +453,11 @@ xfs_dinode_verify_fork(
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
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index e4f866969bf1b6..f690c746805fad 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -270,6 +270,9 @@ xfs_iformat_data_fork(
 			switch (ip->i_metatype) {
 			case XFS_METAFILE_RTRMAP:
 				return xfs_iformat_rtrmap(ip, dip);
+			case XFS_METAFILE_RTREFCOUNT:
+				ASSERT(0); /* to be implemented later */
+				return -EFSCORRUPTED;
 			default:
 				break;
 			}
@@ -618,6 +621,9 @@ xfs_iflush_fork(
 		case XFS_METAFILE_RTRMAP:
 			xfs_iflush_rtrmap(ip, dip);
 			break;
+		case XFS_METAFILE_RTREFCOUNT:
+			ASSERT(0); /* to be implemented later */
+			break;
 		default:
 			ASSERT(0);
 			break;
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 7e69b6bf96f1ac..f7bacce8500c0c 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -364,6 +364,13 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
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
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 6ff222a053674d..2663f2d849e295 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
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
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index ea05b1a48eab62..46c62bd63458f4 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -24,6 +24,7 @@
 #include "xfs_cksum.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_metafile.h"
 
 static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
 
@@ -279,12 +280,10 @@ xfs_rtrefcountbt_init_cursor(
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
@@ -314,6 +313,7 @@ xfs_rtrefcountbt_commit_staged_btree(
 	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(ifake->if_fork->if_format == XFS_DINODE_FMT_META_BTREE);
 
 	/*
 	 * Free any resources hanging off the real fork, then shallow-copy the

