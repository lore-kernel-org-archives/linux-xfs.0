Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB531E47B6
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845654; cv=none; b=doHnlTbrtpYp36SjT3KexktmPD/I9XzhmD/XQv7DQbHfVB0KcaScgW399i8nL8vn71boW/wzXEL38Y8jXIFXNUNs83ksrj5hqouamIRdWO60XvzFofq/5H5b2Oo2wwNk3Cs3UdGr2n8G4bi57ynuF9j9sC9iF7GphD8QeSzDX6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845654; c=relaxed/simple;
	bh=vFlLFhu15VCuXUottgFz5pEpNMhz/iSUJlSU9aYwJZI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nW4Vxv8EfS4inaElclyysG5WNPAIaoZJVVBuNXpY91ZKi6xZmcEBzSGEVdY+9W6LGH7DVlWi2w/kAPhxOA0R8pZc06zjdsvTwGPNjuZ+LBZN8GgXkVoBAXtIHZONoIRGOwrK+9AQg/HdKQW3lSVw1g47gw9NRB+KhRZh9eHfu18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XObcoGiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XObcoGiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494D4C4CECF;
	Tue,  5 Nov 2024 22:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845654;
	bh=vFlLFhu15VCuXUottgFz5pEpNMhz/iSUJlSU9aYwJZI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XObcoGiEOL3G0EoWj0em1jmEC4ZSEw9mcOsUgsON4uTKHgrAUApf1jFIFNESjCPCn
	 VXxHfR+LI4Z252NlK+GCDNozEFXJCebUJNCEfs315/i3irrNTkt42z/83yq/7dbcXY
	 1Kq6L4KY1SdO1/0v0qvMpiWjYvUQs+mXsqDgauJsjJXHxzkizUNHHAuwXndtPAR3/N
	 TgZHbKE+eATd+SvZF8pUQBt9N4EVEhMfeSUgDrfmxyb3BpMktNZ5AzQRseN+iYB0aN
	 I5oYnBUa/0hEUVRQEDt071bfrlhgNBvbs8H4NH1tKg6lhwmAITKF1J10RFU1M0n9ux
	 3JgwxKiP9shqA==
Date: Tue, 05 Nov 2024 14:27:33 -0800
Subject: [PATCH 14/21] xfs: remove XFS_ILOCK_RT*
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084397179.1871025.1113797498039642594.stgit@frogsfrogsfrogs>
In-Reply-To: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
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
index 103cf8b2af24d0..c8ad2606f928b2 100644
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
index b6e959563547fd..2a4485fb990846 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -448,9 +448,8 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
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
@@ -476,8 +475,8 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
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
@@ -492,12 +491,8 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
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
index 5c1df67b63d6d1..7f3b5e24458bf3 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1189,12 +1189,11 @@ xfs_rtalloc_reinit_frextents(
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
@@ -1207,7 +1206,7 @@ xfs_rtmount_iread_extents(
 	}
 
 out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL | lock_class);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
@@ -1228,7 +1227,7 @@ xfs_rtmount_rtg(
 
 		if (rtg->rtg_inodes[i]) {
 			error = xfs_rtmount_iread_extents(tp,
-					rtg->rtg_inodes[i], 0);
+					rtg->rtg_inodes[i]);
 			if (error)
 				return error;
 		}

