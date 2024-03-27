Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA241B94D
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505248; cv=none; b=oYToNfgzEzOR1i2k41QsGGEIhHp+lOCTT6Eieu02wILsy7pp3TlW9Yr/ixdrHplVFNokleN0qV00wJzbU5/6+cMSNXw2oXSjOv7QaEXJ9/wUT5UwGSCGBe3+mGJT1slc6P2d4PUxBeZQ6t+EZ96j7D1fKdQaiOpJm/Wtm+bZ4zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505248; c=relaxed/simple;
	bh=So2hkx5SgLQD2Zy7UIKG9krVAT1klrsrzRok6yX4uY8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZI5+Z8stioGL/y9+31ZvQUxheC5fNAWyBpJpH21x/Ezd6hExhslajRnqajw9tPkY9VDK9dUv3keDl3pzx6ihCy2oEbHmbtrUkbPrq8KRDGwrs7MCu4OTk9diDnRzm9Cq2Xfi/S8F5eXUn6CvJyob9wdt4m+ypNK3oFtC0GV7B4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MO+LaIJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MO+LaIJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26C0C433F1;
	Wed, 27 Mar 2024 02:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711505247;
	bh=So2hkx5SgLQD2Zy7UIKG9krVAT1klrsrzRok6yX4uY8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MO+LaIJLjnA5wxetdXYm5Qiz4hb9ZHUuRSUcLpUeXnn1i39iinLOJmnQl9B89YMPt
	 zCbIX2MV6nEnnnPyjwtCQ32wMMmJ2RUnJiA24XMXI1P5LfSci3M2T1DKZLsWj5aD12
	 FFa0LHP56UbpEpH+f17nRM2t0M5XipDUj3rjtqcikQqbE0FTIL9lGLvIRBZs0TsSfr
	 Bp3StzCQxjU7i4DvUzuRcR7UGVUMineZ/prBdZyUnOtF5uiOvH0cnYgmySpfCdciRG
	 ISuSgnlTfxolWiaP1dCgUrLsl4YM7tXfXfvzNooL08avWAVoQFRTPJ7WrOOGsMVLY8
	 8NsG899Lp5bqQ==
Date: Tue, 26 Mar 2024 19:07:27 -0700
Subject: [PATCH 3/4] xfs: pin inodes that would otherwise overflow link count
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150385168.3220296.14541219555606649161.stgit@frogsfrogsfrogs>
In-Reply-To: <171150385109.3220296.4235209828218476119.stgit@frogsfrogsfrogs>
References: <171150385109.3220296.4235209828218476119.stgit@frogsfrogsfrogs>
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

The VFS inc_nlink function does not explicitly check for integer
overflows in the i_nlink field.  Instead, it checks the link count
against s_max_links in the vfs_{link,create,rename} functions.  XFS
sets the maximum link count to 2.1 billion, so integer overflows should
not be a problem.

However.  It's possible that online repair could find that a file has
more than four billion links, particularly if the link count got
corrupted while creating hardlinks to the file.  The di_nlinkv2 field is
not large enough to store a value larger than 2^32, so we ought to
define a magic pin value of ~0U which means that the inode never gets
deleted.  This will prevent a UAF error if the repair finds this
situation and users begin deleting links to the file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h   |    6 ++++++
 fs/xfs/scrub/dir_repair.c    |   11 +++--------
 fs/xfs/scrub/nlinks.c        |    4 +++-
 fs/xfs/scrub/nlinks_repair.c |    8 ++------
 fs/xfs/xfs_inode.c           |   33 ++++++++++++++++++++++-----------
 5 files changed, 36 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index aa2ad7e04202b..de90dae8b1a63 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -911,6 +911,12 @@ static inline uint xfs_dinode_size(int version)
  */
 #define	XFS_MAXLINK		((1U << 31) - 1U)
 
+/*
+ * Any file that hits the maximum ondisk link count should be pinned to avoid
+ * a use-after-free situation.
+ */
+#define	XFS_NLINK_PINNED	(~0U)
+
 /*
  * Values for di_format
  *
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 983d6519dc3f6..01893f25454b2 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1147,7 +1147,9 @@ xrep_dir_set_nlink(
 	struct xfs_scrub	*sc = rd->sc;
 	struct xfs_inode	*dp = sc->ip;
 	struct xfs_perag	*pag;
-	unsigned int		new_nlink = rd->subdirs + 2;
+	unsigned int		new_nlink = min_t(unsigned long long,
+						  rd->subdirs + 2,
+						  XFS_NLINK_PINNED);
 	int			error;
 
 	/*
@@ -1203,13 +1205,6 @@ xrep_dir_swap(
 	bool			ip_local, temp_local;
 	int			error = 0;
 
-	/*
-	 * If we found enough subdirs to overflow this directory's link count,
-	 * bail out to userspace before we modify anything.
-	 */
-	if (rd->subdirs + 2 > XFS_MAXLINK)
-		return -EFSCORRUPTED;
-
 	/*
 	 * If we never found the parent for this directory, temporarily assign
 	 * the root dir as the parent; we'll move this to the orphanage after
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index b13bbbdf2ad32..15ea06db31545 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -603,9 +603,11 @@ xchk_nlinks_compare_inode(
 	 * this as a corruption.  The VFS won't let users increase the link
 	 * count, but it will let them decrease it.
 	 */
-	if (total_links > XFS_MAXLINK) {
+	if (total_links > XFS_NLINK_PINNED) {
 		xchk_ino_set_corrupt(sc, ip->i_ino);
 		goto out_corrupt;
+	} else if (total_links > XFS_MAXLINK) {
+		xchk_ino_set_warning(sc, ip->i_ino);
 	}
 
 	/* Link counts should match. */
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 1345c07a95c62..87cb3400ff948 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -239,14 +239,10 @@ xrep_nlinks_repair_inode(
 
 	/* Commit the new link count if it changed. */
 	if (total_links != actual_nlink) {
-		if (total_links > XFS_MAXLINK) {
-			trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
-			goto out_trans;
-		}
-
 		trace_xrep_nlinks_update_inode(mp, ip, &obs);
 
-		set_nlink(VFS_I(ip), total_links);
+		set_nlink(VFS_I(ip), min_t(unsigned long long, total_links,
+					   XFS_NLINK_PINNED));
 		dirty = true;
 	}
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 666bd03cf05c3..90865af01cd35 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -890,22 +890,25 @@ xfs_init_new_inode(
  */
 static int			/* error */
 xfs_droplink(
-	xfs_trans_t *tp,
-	xfs_inode_t *ip)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
 {
-	if (VFS_I(ip)->i_nlink == 0) {
-		xfs_alert(ip->i_mount,
-			  "%s: Attempt to drop inode (%llu) with nlink zero.",
-			  __func__, ip->i_ino);
-		return -EFSCORRUPTED;
-	}
+	struct inode		*inode = VFS_I(ip);
 
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	drop_nlink(VFS_I(ip));
+	if (inode->i_nlink == 0) {
+		xfs_info_ratelimited(tp->t_mountp,
+ "Inode 0x%llx link count dropped below zero.  Pinning link count.",
+				ip->i_ino);
+		set_nlink(inode, XFS_NLINK_PINNED);
+	}
+	if (inode->i_nlink != XFS_NLINK_PINNED)
+		drop_nlink(inode);
+
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	if (VFS_I(ip)->i_nlink)
+	if (inode->i_nlink)
 		return 0;
 
 	return xfs_iunlink(tp, ip);
@@ -919,9 +922,17 @@ xfs_bumplink(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip)
 {
+	struct inode		*inode = VFS_I(ip);
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	inc_nlink(VFS_I(ip));
+	if (inode->i_nlink == XFS_NLINK_PINNED - 1)
+		xfs_info_ratelimited(tp->t_mountp,
+ "Inode 0x%llx link count exceeded maximum.  Pinning link count.",
+				ip->i_ino);
+	if (inode->i_nlink != XFS_NLINK_PINNED)
+		inc_nlink(inode);
+
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 

