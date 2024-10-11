Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8154A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608360; cv=none; b=oJvNoomZ8Dj0CbDIY76oeadrPgrMQrVA2QgxTQMEN+mXcxDB2FYNXTVuDiJe9KWJzg8NFownIGbPvc0L9uMkybLJ98WUXFXjWrt3qC0imIaTytRzIv6agP3fOHnQo7oLCE1+e7CElPldu8rBK85HldMQxS0AzlSTQhgULa+G9m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608360; c=relaxed/simple;
	bh=u6EXKL1T2ZCVs85+YdI28FY7Dy7QzdJpvWnfPEqcxbE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FmaTkX6VCwX+I6dIanEPY2QFlDKh0PPHgyAf0hKMdN2uG5ve+sGi3Z8CpGERbIbbmgOSfHV3Y6uA42+DpVepPXnbNHIC9Wt1LVhPfa0lgRadN/aGzcO6985oI2KhSVQHD3OKBOoqyJ2e/k3NcJgPGMtu7C2acD+u20pGtOyKO4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQL4a6EY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQL4a6EY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E36C4CEC5;
	Fri, 11 Oct 2024 00:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608360;
	bh=u6EXKL1T2ZCVs85+YdI28FY7Dy7QzdJpvWnfPEqcxbE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XQL4a6EYcpWaz9KoyEy77rvJbq7YuLvDMHCUdrVPajcpC5EEjiuQybvIqkpWLIuz1
	 xGHkF3m40qI2trhGiDhKMR8O62RfoFoYaR989yarYDsVAho/JWuV3CaPqblMRmSH2f
	 Zr5rxjkMIduYIBa+uaodeLAM/EC+tbAPKVt7yPA+0nFWdnol0+QsvzvbNrdoMhHOlA
	 5c8AGAFEle2Oryn0n2N6JY2NYX31UBiarvdxii1fudWN9hkLUpuinigUGzH8ukQJPu
	 fnVNXpLcjWYW7xruWbuaLbeFmwKUMFC+reW9lIxA/tZCLmWxIMxjdecY4koLRuCRPd
	 2TDqy9fUrezyw==
Date: Thu, 10 Oct 2024 17:59:19 -0700
Subject: [PATCH 14/21] xfs: remove XFS_ILOCK_RT*
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860643189.4177836.5930776676812666324.stgit@frogsfrogsfrogs>
In-Reply-To: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
References: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c   |    3 +--
 fs/xfs/xfs_inode.h   |   13 ++++---------
 fs/xfs/xfs_rtalloc.c |    9 ++++-----
 3 files changed, 9 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b8dada5140c877..bcccf09cd92bbc 100644
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
index 4b36dc2c9bf48b..11c866d3c959a7 100644
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

