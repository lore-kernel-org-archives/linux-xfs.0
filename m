Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C699221BB0C
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191734; cv=none; b=MgSC9Px8CxAj0jGkX7BlH4gNrXB0INbS69mgTQwXbN7GoN8sZXQx33OadWyuRiv96IqzAlgl3wf5nI4VkBYpxVIRauBBgrxsaT4ORV+aM7MdY5ZSYBtNil81VGifAlcdqDROAjpuofzO3l6Au1izRKi3wnG4ZypgzaFU3qt3IHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191734; c=relaxed/simple;
	bh=6XOM5me70GBQKNenq7UWMhu4cMICZHxhJHwzw/J6Kgc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D5PHEFOntbBIbgwy1VTxNFQiub372HWMR0U+/Pd9CNsuj8fSeOIDk3eSusoLdaytrpv0WM+BeQIIPQhS5mnffEICe6RVyjV3tZ3iguEbjw2FYZAmlzTNkxnpmjcqG/k2HHpYp5B2EyZN5QSCpIXROhY2MNIChUoYFn79yZ7WmVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vBOOt5o5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vBOOt5o5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644FEC4CEC3;
	Thu, 17 Oct 2024 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191734;
	bh=6XOM5me70GBQKNenq7UWMhu4cMICZHxhJHwzw/J6Kgc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vBOOt5o5QN5e5f7yKL1ftzi6LwAW6eu9Rbzdlo0p5b/2z5BDbPfuExAHy0k/1t0Dr
	 FTSm8D4Q1Q8IXQJWFMIPa+WtCGwAicpIjMhmJ7rKsLZ/2ZfKws04HiMJE/EtCHg4x6
	 bQeqvL0tbOjiOaPzKAlfbItmNt1SLQOhkoojEvRfoz+vIfhlL1lZlufcKwfdn+gaSY
	 Jpx3A/h4RuNf8WmF/ETcn2/d22eO6r00xpckx8prX58fpg4Hw9hZXoROxIA76h5fOc
	 EXakZRIk0dKvLWyvYtixUn/X32A1cxeAaijKlX2shnBpn9iCTV0ErJghcvNg/GdqzJ
	 vkGWZ+n0fMKjw==
Date: Thu, 17 Oct 2024 12:02:14 -0700
Subject: [PATCH 14/21] xfs: remove XFS_ILOCK_RT*
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070639.3452315.6081040238692266259.stgit@frogsfrogsfrogs>
In-Reply-To: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
References: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c   |    3 +--
 fs/xfs/xfs_inode.h   |   13 ++++---------
 fs/xfs/xfs_rtalloc.c |    9 ++++-----
 3 files changed, 9 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cdb910fcf0d534..3cc74c3b9d80f1 100644
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
index ace52d7eceb524..22e942dd91420e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -443,9 +443,8 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
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
@@ -471,8 +470,8 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
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
@@ -487,12 +486,8 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
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
index 42c9d3bb71b06b..66e8a5973230e8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1187,12 +1187,11 @@ xfs_rtalloc_reinit_frextents(
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
@@ -1205,7 +1204,7 @@ xfs_rtmount_iread_extents(
 	}
 
 out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL | lock_class);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
@@ -1226,7 +1225,7 @@ xfs_rtmount_rtg(
 
 		if (rtg->rtg_inodes[i]) {
 			error = xfs_rtmount_iread_extents(tp,
-					rtg->rtg_inodes[i], 0);
+					rtg->rtg_inodes[i]);
 			if (error)
 				return error;
 		}

