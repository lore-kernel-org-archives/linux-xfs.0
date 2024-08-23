Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0796171A7
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372345; cv=none; b=MTXYDM7/sXccftD30RIbmsm7hC3AyJfkgRaP80Tk28xgPtMMVPU734P9k1JGElqBGBBad8QP1AcJ/tPbIxo0DJQ6jCPaYji6EeJTYg/xoY7D8NaEHVecT+sAqQ4aBt4ggnVo3TrYkfJGfwOCxGxETqN0h4CjOPddLCALPV7/QbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372345; c=relaxed/simple;
	bh=Z3kNLW5brImQGqB2T/5tlM5sRNAxVBQ48Yl8M2k7368=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BvWa9RFm61CpEZDQfz8oo1cEH2ebezDgqv+MJBmAjjhXVFpaj3iK7paBzhqlrI3ICkKutINYpMm0ZNyBMapgH+P5FRm862xfUgGxI0inLp/HYz9ZBOfzjtSAuXov87nysSVEpNXlbCElCZ2vXB8IYBSbz9CvYOD5+uJFGEfskKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCFVYttM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCFVYttM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A807AC32782;
	Fri, 23 Aug 2024 00:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372345;
	bh=Z3kNLW5brImQGqB2T/5tlM5sRNAxVBQ48Yl8M2k7368=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LCFVYttMwsFJe+unHJ/jDPmJwqMwmNYfas/QHk+Qysq8aTRA1myGBqx9s1Zko8WXa
	 CNIyW7eetDTQtkFoUfE5I4WmgdB3HV7EGb9T7m4djjljeAZzjkcuEq2x9bornMluYe
	 LLCl+91vP2v2bGdVFeKjBjYrWabxLINjDoq3RREK08ppIiH+cI7Iq/mRH26LBkxLM9
	 /HC2vGExfRkToJkdJ0p5mvXjVWlsCdShVMDmt25KDAYeC20tBVOUWPnHekTit9cT00
	 legNTXyKoQSuL+yijTsaqsajn/wwUQAisoaAPUEsT9UPkCZygE7FXUjD5fBf/K2RO8
	 KDTARHSzAv7ew==
Date: Thu, 22 Aug 2024 17:19:05 -0700
Subject: [PATCH 17/24] xfs: remove XFS_ILOCK_RT*
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087542.59588.13853236455832390956.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
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

Now that we've centralized the realtime metadata locking routines, get
rid of the ILOCK subclasses since we now use explicit lockdep classes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c   |    3 +--
 fs/xfs/xfs_inode.h   |   13 ++++---------
 fs/xfs/xfs_rtalloc.c |    9 ++++-----
 3 files changed, 9 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fff3037e67574..4ae628fe7d877 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -342,8 +342,7 @@ xfs_lock_inumorder(
 {
 	uint	class = 0;
 
-	ASSERT(!(lock_mode & (XFS_ILOCK_PARENT | XFS_ILOCK_RTBITMAP |
-			      XFS_ILOCK_RTSUM)));
+	ASSERT(!(lock_mode & XFS_ILOCK_PARENT));
 	ASSERT(xfs_lockdep_subclass_ok(subclass));
 
 	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)) {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 54d995740b328..7c35511d0e471 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -443,9 +443,8 @@ static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
  * However, MAX_LOCKDEP_SUBCLASSES == 8, which means we are greatly
  * limited to the subclasses we can represent via nesting. We need at least
  * 5 inodes nest depth for the ILOCK through rename, and we also have to support
- * XFS_ILOCK_PARENT, which gives 6 subclasses. Then we have XFS_ILOCK_RTBITMAP
- * and XFS_ILOCK_RTSUM, which are another 2 unique subclasses, so that's all
- * 8 subclasses supported by lockdep.
+ * XFS_ILOCK_PARENT, which gives 6 subclasses.  That's 6 of the 8 subclasses
+ * supported by lockdep.
  *
  * This also means we have to number the sub-classes in the lowest bits of
  * the mask we keep, and we have to ensure we never exceed 3 bits of lockdep
@@ -471,8 +470,8 @@ static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
  * ILOCK values
  * 0-4		subclass values
  * 5		PARENT subclass (not nestable)
- * 6		RTBITMAP subclass (not nestable)
- * 7		RTSUM subclass (not nestable)
+ * 6		unused
+ * 7		unused
  * 
  */
 #define XFS_IOLOCK_SHIFT		16
@@ -487,12 +486,8 @@ static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
 #define XFS_ILOCK_SHIFT			24
 #define XFS_ILOCK_PARENT_VAL		5u
 #define XFS_ILOCK_MAX_SUBCLASS		(XFS_ILOCK_PARENT_VAL - 1)
-#define XFS_ILOCK_RTBITMAP_VAL		6u
-#define XFS_ILOCK_RTSUM_VAL		7u
 #define XFS_ILOCK_DEP_MASK		0xff000000u
 #define	XFS_ILOCK_PARENT		(XFS_ILOCK_PARENT_VAL << XFS_ILOCK_SHIFT)
-#define	XFS_ILOCK_RTBITMAP		(XFS_ILOCK_RTBITMAP_VAL << XFS_ILOCK_SHIFT)
-#define	XFS_ILOCK_RTSUM			(XFS_ILOCK_RTSUM_VAL << XFS_ILOCK_SHIFT)
 
 #define XFS_LOCK_SUBCLASS_MASK	(XFS_IOLOCK_DEP_MASK | \
 				 XFS_MMAPLOCK_DEP_MASK | \
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f63228b3dd9a2..2a694ad8ead2c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1188,12 +1188,11 @@ xfs_rtalloc_reinit_frextents(
 static inline int
 xfs_rtmount_iread_extents(
 	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	unsigned int		lock_class)
+	struct xfs_inode	*ip)
 {
 	int			error;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL | lock_class);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
 	if (error)
@@ -1206,7 +1205,7 @@ xfs_rtmount_iread_extents(
 	}
 
 out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL | lock_class);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
@@ -1227,7 +1226,7 @@ xfs_rtmount_rtg(
 
 		if (rtg->rtg_inodes[i]) {
 			error = xfs_rtmount_iread_extents(tp,
-					rtg->rtg_inodes[i], 0);
+					rtg->rtg_inodes[i]);
 			if (error)
 				return error;
 		}

