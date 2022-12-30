Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB26C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbiLaB1b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbiLaB1a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:27:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947ED1C93A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:27:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E50661CB4
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAEAC433D2;
        Sat, 31 Dec 2022 01:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450048;
        bh=ooSBP2yQiZ0xHmVBuWJPdPJ+e/QJHgAfyIEtOLaYTKc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AclQqe0ZKjcf+KN4lhQBTYeXjurrwXroeQJdD+lfLK1t+6iorkQSTKxPi6wimW80A
         sfXPGxr1DppJxu+NOUUbUls221kU9M367eD+kYKdWyHmd94I+FCqjAaZDOM6tbhAZU
         2u2q9dv8wjiNkI8qgsL4RA3ryh2LKZPjVNpPhYOBe3+TSCfSwbC6USJ1i0qxWUqUaB
         /2hNGVtLlDNbmfGWwDiXMMkpH0d9AkYE4zMxWI6Wj4NsamjbSGJx7L1F+qY/O5QSMK
         QDU3jHnm9bhVMjlf9i7ZDJSuSOG3QmrI6FpEvRzXLByASaC76mP5EjIYtT/iUOiRXs
         ey8Wmw1iO5O2Q==
Subject: [PATCH 3/3] xfs: remove XFS_ILOCK_RT*
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:49 -0800
Message-ID: <167243866927.712531.15153228541429297552.stgit@magnolia>
In-Reply-To: <167243866880.712531.9794913817759933297.stgit@magnolia>
References: <167243866880.712531.9794913817759933297.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've centralized the realtime metadata locking routines, get
rid of the ILOCK subclasses since we now use explicit lockdep classes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   16 ++++++++--------
 fs/xfs/scrub/common.c        |    8 ++++----
 fs/xfs/xfs_inode.c           |    3 +--
 fs/xfs/xfs_inode.h           |   13 ++++---------
 fs/xfs/xfs_rtalloc.c         |   11 +++++------
 5 files changed, 22 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 46095acec709..4237b5703a64 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1262,11 +1262,11 @@ xfs_rtbitmap_lock(
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
@@ -1276,8 +1276,8 @@ void
 xfs_rtbitmap_unlock(
 	struct xfs_mount	*mp)
 {
-	xfs_iunlock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
-	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+	xfs_iunlock(mp->m_rsumip, XFS_ILOCK_EXCL);
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL);
 }
 
 /*
@@ -1290,10 +1290,10 @@ xfs_rtbitmap_lock_shared(
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
@@ -1303,8 +1303,8 @@ xfs_rtbitmap_unlock_shared(
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
index dadbe32916de..1b48726fcc65 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -693,14 +693,14 @@ xchk_rt_init(
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 51bceccd8c9a..ab805df9db16 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -361,8 +361,7 @@ xfs_lock_inumorder(
 {
 	uint	class = 0;
 
-	ASSERT(!(lock_mode & (XFS_ILOCK_PARENT | XFS_ILOCK_RTBITMAP |
-			      XFS_ILOCK_RTSUM)));
+	ASSERT(!(lock_mode & XFS_ILOCK_PARENT));
 	ASSERT(xfs_lockdep_subclass_ok(subclass));
 
 	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)) {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7cf45dd9d86b..06601c409010 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -404,9 +404,8 @@ static inline bool xfs_inode_has_bigrtextents(struct xfs_inode *ip)
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
@@ -432,8 +431,8 @@ static inline bool xfs_inode_has_bigrtextents(struct xfs_inode *ip)
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
@@ -449,12 +448,8 @@ static inline bool xfs_inode_has_bigrtextents(struct xfs_inode *ip)
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
index 11bea1c60eda..c131738efd0f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1376,8 +1376,7 @@ __xfs_rt_iget(
  */
 static inline int
 xfs_rtmount_iread_extents(
-	struct xfs_inode	*ip,
-	unsigned int		lock_class)
+	struct xfs_inode	*ip)
 {
 	struct xfs_trans	*tp;
 	int			error;
@@ -1386,7 +1385,7 @@ xfs_rtmount_iread_extents(
 	if (error)
 		return error;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL | lock_class);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
 	if (error)
@@ -1399,7 +1398,7 @@ xfs_rtmount_iread_extents(
 	}
 
 out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL | lock_class);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_cancel(tp);
 	return error;
 }
@@ -1424,7 +1423,7 @@ xfs_rtmount_inodes(
 		return error;
 	ASSERT(mp->m_rbmip != NULL);
 
-	error = xfs_rtmount_iread_extents(mp->m_rbmip, XFS_ILOCK_RTBITMAP);
+	error = xfs_rtmount_iread_extents(mp->m_rbmip);
 	if (error)
 		goto out_rele_bitmap;
 
@@ -1436,7 +1435,7 @@ xfs_rtmount_inodes(
 		goto out_rele_bitmap;
 	ASSERT(mp->m_rsumip != NULL);
 
-	error = xfs_rtmount_iread_extents(mp->m_rsumip, XFS_ILOCK_RTSUM);
+	error = xfs_rtmount_iread_extents(mp->m_rsumip);
 	if (error)
 		goto out_rele_summary;
 

