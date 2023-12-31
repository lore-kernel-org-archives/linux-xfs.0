Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99527BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNy4rA6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C82AC433C8;
	Sun, 31 Dec 2023 21:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057337;
	bh=FVU7BtoRpsGu17uMvNXyw0g/LmAPw9lPPt4BLpTeYcQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZNy4rA6MYxhGRt5QrB8S8xDul2RMXzfuYNLQpKX8aT+w60+X67GrXMs/+Fk1INS5t
	 p3SoGCuLNeMe4fQ1YEOtl530U1ifB8E3mZR7ZDZWNUnMMbFbXqwL9TUVqfoGf7qYi2
	 F5SQ5CN420tXXElK7qnWxA7KoCeFdbMCR7BJ8ALuGEWOdSOrUaJF7IKy5NvA4PuAy3
	 jDMyLZVu7QmbfgRhSiSZcbRt8pWvqGSq6MQACxmtGZb2Pg6MFenNPyEzdHguX86UBr
	 wvEPwwbM4PueR9fSo00qR9VqiBrJTHeC66odswikZ13YnN+SgJzw6hnllusdeTqvYc
	 z/G8Cq5vzpkng==
Date: Sun, 31 Dec 2023 13:15:36 -0800
Subject: [PATCH 4/4] xfs: remove XFS_ILOCK_RT*
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845797.1761787.13125055742440007020.stgit@frogsfrogsfrogs>
In-Reply-To: <170404845722.1761787.5477037333223536717.stgit@frogsfrogsfrogs>
References: <170404845722.1761787.5477037333223536717.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_rtbitmap.c |   16 ++++++++--------
 fs/xfs/scrub/common.c        |   10 +++++-----
 fs/xfs/xfs_inode.c           |    3 +--
 fs/xfs/xfs_inode.h           |   13 ++++---------
 fs/xfs/xfs_rtalloc.c         |   11 +++++------
 5 files changed, 23 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index eafdda22edcdf..795035556c4b4 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1205,11 +1205,11 @@ xfs_rtbitmap_lock(
 	struct xfs_trans	*tp,
 	struct xfs_mount	*mp)
 {
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
 	if (tp)
 		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
 
-	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
 	if (tp)
 		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
 }
@@ -1219,8 +1219,8 @@ void
 xfs_rtbitmap_unlock(
 	struct xfs_mount	*mp)
 {
-	xfs_iunlock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
-	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+	xfs_iunlock(mp->m_rsumip, XFS_ILOCK_EXCL);
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL);
 }
 
 /*
@@ -1233,10 +1233,10 @@ xfs_rtbitmap_lock_shared(
 	unsigned int		rbmlock_flags)
 {
 	if (rbmlock_flags & XFS_RBMLOCK_BITMAP)
-		xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+		xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED);
 
 	if (rbmlock_flags & XFS_RBMLOCK_SUMMARY)
-		xfs_ilock(mp->m_rsumip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
+		xfs_ilock(mp->m_rsumip, XFS_ILOCK_SHARED);
 }
 
 /* Unlock the realtime free space metadata inodes after a freespace scan. */
@@ -1246,8 +1246,8 @@ xfs_rtbitmap_unlock_shared(
 	unsigned int		rbmlock_flags)
 {
 	if (rbmlock_flags & XFS_RBMLOCK_SUMMARY)
-		xfs_iunlock(mp->m_rsumip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
+		xfs_iunlock(mp->m_rsumip, XFS_ILOCK_SHARED);
 
 	if (rbmlock_flags & XFS_RBMLOCK_BITMAP)
-		xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+		xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED);
 }
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 53eec92df180a..e9294a933c3ab 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -701,14 +701,14 @@ xchk_rt_init(
 					 XCHK_RTLOCK_SUMMARY_SHARED)) < 2);
 
 	if (rtlock_flags & XCHK_RTLOCK_BITMAP)
-		xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+		xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_EXCL);
 	else if (rtlock_flags & XCHK_RTLOCK_BITMAP_SHARED)
-		xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+		xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED);
 
 	if (rtlock_flags & XCHK_RTLOCK_SUMMARY)
-		xfs_ilock(sc->mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+		xfs_ilock(sc->mp->m_rsumip, XFS_ILOCK_EXCL);
 	else if (rtlock_flags & XCHK_RTLOCK_SUMMARY_SHARED)
-		xfs_ilock(sc->mp->m_rsumip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
+		xfs_ilock(sc->mp->m_rsumip, XFS_ILOCK_SHARED);
 
 	sr->rtlock_flags = rtlock_flags;
 }
@@ -745,7 +745,7 @@ xchk_rt_unlock_rtbitmap(
 {
 	ASSERT(sc->sr.rtlock_flags & XCHK_RTLOCK_BITMAP_SHARED);
 
-	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED);
 	sc->sr.rtlock_flags &= ~XCHK_RTLOCK_BITMAP_SHARED;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 322fa538aec4b..78afc5b8e11c6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -364,8 +364,7 @@ xfs_lock_inumorder(
 {
 	uint	class = 0;
 
-	ASSERT(!(lock_mode & (XFS_ILOCK_PARENT | XFS_ILOCK_RTBITMAP |
-			      XFS_ILOCK_RTSUM)));
+	ASSERT(!(lock_mode & XFS_ILOCK_PARENT));
 	ASSERT(xfs_lockdep_subclass_ok(subclass));
 
 	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)) {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e967fa10721f9..e33b270c6b508 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -437,9 +437,8 @@ static inline bool xfs_inode_has_bigallocunit(struct xfs_inode *ip)
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
@@ -465,8 +464,8 @@ static inline bool xfs_inode_has_bigallocunit(struct xfs_inode *ip)
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
@@ -481,12 +480,8 @@ static inline bool xfs_inode_has_bigallocunit(struct xfs_inode *ip)
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
index 8852d4f95b1ad..f76ecb9a19b51 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1365,12 +1365,11 @@ __xfs_rt_iget(
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
@@ -1383,7 +1382,7 @@ xfs_rtmount_iread_extents(
 	}
 
 out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL | lock_class);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
@@ -1411,7 +1410,7 @@ xfs_rtmount_inodes(
 		goto out_trans;
 	ASSERT(mp->m_rbmip != NULL);
 
-	error = xfs_rtmount_iread_extents(tp, mp->m_rbmip, XFS_ILOCK_RTBITMAP);
+	error = xfs_rtmount_iread_extents(tp, mp->m_rbmip);
 	if (error)
 		goto out_rele_bitmap;
 
@@ -1423,7 +1422,7 @@ xfs_rtmount_inodes(
 		goto out_rele_bitmap;
 	ASSERT(mp->m_rsumip != NULL);
 
-	error = xfs_rtmount_iread_extents(tp, mp->m_rsumip, XFS_ILOCK_RTSUM);
+	error = xfs_rtmount_iread_extents(tp, mp->m_rsumip);
 	if (error)
 		goto out_rele_summary;
 

