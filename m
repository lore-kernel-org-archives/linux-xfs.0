Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EA41CEAD6
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881432; cv=none; b=foA6qhN17zYwur4hcjhMCE1K0SzQK5zLMFWlJoO9HyL8EeFx3MJ1uhZVgsKu7BjJTi3G8IYEIc7Kj/EpKhXpbIAkN3CxzdIWB1awH67arP6n8ToXreMCY9vUq0LlfcWzguaHSkVtp+pLEhtRd+9kfbSWyYqCTKz042xPFyklLtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881432; c=relaxed/simple;
	bh=LLCiPFRGht8BHKqENXW3TpY3LW54bG+ni0PsbECy3SY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s1CZaDMMEw/+1ijQFSBaYo3H76azgG8UZKe4QVpdWICUAu5rUeYUbzgYsIj/b+73aCPUjwNa9N2CBvXdNDkAqtSH4Y+BtiRS9S2VmElY3cfy8KJTc/kEZED7idfDFSBYrBr2rvANVUSJ4UJurih+zIApedB2STc2i99ZcK1Wb/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KySIyD0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KySIyD0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AE7C4CEDD;
	Thu,  6 Feb 2025 22:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881432;
	bh=LLCiPFRGht8BHKqENXW3TpY3LW54bG+ni0PsbECy3SY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KySIyD0b/KAuA2OIX6gVonFRyg2NLfIQPiFm0WWtl+toH1D2IPfBbrNGc3lcTwhZR
	 CwNvMxbhKP/Whd4STbkJtuHg5pXnOkWbaNOYMSisT1ftm7+oCVljXzxI9+aCB3j8b5
	 9HJQvkGHPU0IhkPxLqcwlv78bCb9GF4FHIobkdebq3RHv0x21o7wSRfiuyaQhppseX
	 sbTYoeHxqOckH8MOGAuVOA72QwDBhekk6lK+BoTzyEu1iVjkqaIOhgwnsLUBf3kEvr
	 SJFLTel/SAiyshahhQrbcFX1UJlLCCn3R1rlXve+yxPcXrHGhcakqrNNz09a9hML7P
	 ZR605DVbwWSfw==
Date: Thu, 06 Feb 2025 14:37:11 -0800
Subject: [PATCH 08/56] xfs: add some rtgroup inode helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086913.2739176.3890025606862047722.stgit@frogsfrogsfrogs>
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

Source kernel commit: af32541081ed6b6ad49b1ea38b5128cb319841b0

Create some simple helpers to reduce the amount of typing whenever we
access rtgroup inodes.  Conversion was done with this spatch and some
minor reformatting:

@@
expression rtg;
@@

- rtg->rtg_inodes[XFS_RTGI_BITMAP]
+ rtg_bitmap(rtg)

@@
expression rtg;
@@

- rtg->rtg_inodes[XFS_RTGI_SUMMARY]
+ rtg_summary(rtg)

and the CLI command:

$ spatch --sp-file /tmp/moo.cocci --dir fs/xfs/ --use-gitgrep --in-place

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtbitmap.c |    2 +-
 libxfs/xfs_rtgroup.c  |   18 ++++++++----------
 libxfs/xfs_rtgroup.h  |   10 ++++++++++
 3 files changed, 19 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index b439fb3c20709f..689d5844b8bd09 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1050,7 +1050,7 @@ xfs_rtfree_extent(
 	xfs_rtxlen_t		len)	/* length of extent freed */
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
+	struct xfs_inode	*rbmip = rtg_bitmap(rtg);
 	struct xfs_rtalloc_args	args = {
 		.mp		= mp,
 		.tp		= tp,
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index aaaec2a1cef9e5..e422a7bc41a55e 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -194,10 +194,10 @@ xfs_rtgroup_lock(
 		 * Lock both realtime free space metadata inodes for a freespace
 		 * update.
 		 */
-		xfs_ilock(rtg->rtg_inodes[XFS_RTGI_BITMAP], XFS_ILOCK_EXCL);
-		xfs_ilock(rtg->rtg_inodes[XFS_RTGI_SUMMARY], XFS_ILOCK_EXCL);
+		xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
+		xfs_ilock(rtg_summary(rtg), XFS_ILOCK_EXCL);
 	} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
-		xfs_ilock(rtg->rtg_inodes[XFS_RTGI_BITMAP], XFS_ILOCK_SHARED);
+		xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
 	}
 }
 
@@ -212,10 +212,10 @@ xfs_rtgroup_unlock(
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
 	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
-		xfs_iunlock(rtg->rtg_inodes[XFS_RTGI_SUMMARY], XFS_ILOCK_EXCL);
-		xfs_iunlock(rtg->rtg_inodes[XFS_RTGI_BITMAP], XFS_ILOCK_EXCL);
+		xfs_iunlock(rtg_summary(rtg), XFS_ILOCK_EXCL);
+		xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
 	} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
-		xfs_iunlock(rtg->rtg_inodes[XFS_RTGI_BITMAP], XFS_ILOCK_SHARED);
+		xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
 	}
 }
 
@@ -233,10 +233,8 @@ xfs_rtgroup_trans_join(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED));
 
 	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
-		xfs_trans_ijoin(tp, rtg->rtg_inodes[XFS_RTGI_BITMAP],
-				XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, rtg->rtg_inodes[XFS_RTGI_SUMMARY],
-				XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, rtg_bitmap(rtg), XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, rtg_summary(rtg), XFS_ILOCK_EXCL);
 	}
 }
 
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 2d7822644efff0..2e145ea2de8007 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -64,6 +64,16 @@ static inline xfs_rgnumber_t rtg_rgno(const struct xfs_rtgroup *rtg)
 	return rtg->rtg_group.xg_gno;
 }
 
+static inline struct xfs_inode *rtg_bitmap(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_inodes[XFS_RTGI_BITMAP];
+}
+
+static inline struct xfs_inode *rtg_summary(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_inodes[XFS_RTGI_SUMMARY];
+}
+
 /* Passive rtgroup references */
 static inline struct xfs_rtgroup *
 xfs_rtgroup_get(

