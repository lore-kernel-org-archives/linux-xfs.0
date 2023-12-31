Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A349C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iO9A1IpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF823C433C7;
	Sun, 31 Dec 2023 23:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066454;
	bh=hkkMBXT+fPHtIOXCNzonvZx1JrZ6Ke6ToNUbLRbpgyA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iO9A1IpZUYgKZiPMv5GLIMPN069xI5TVa+IibcmqAIDQFM9kLqQu1NnaOsBPmS7CA
	 1WmY2MCB1dZ7XzSd3C63N63glnmTrsFB2fsTedl9KoE2o+zqBlirzxmPZaMN77QeUb
	 egQprjbkbnBr22fR0eaY/Spnqj3G4AeqQAgkvPaZTJNIWK1opBs9Yeqp+QkvfxbJQn
	 N0QZaNJ9y45rCMWE1KqpFkMR58nrDcwVZw+eK9BP9cE0IkYV66kS6yvwC9N4t8XQC5
	 MH9SvH07qkDYq2YtDOZweS81vuXBPqlhTgMNpKxKK6nCTLruVZfx/5JtaCulRLv/3N
	 sz8SvroezT8mQ==
Date: Sun, 31 Dec 2023 15:47:34 -0800
Subject: [PATCH 2/2] xfs: remove XFS_ILOCK_RT*
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405011776.1811141.16178647549003347292.stgit@frogsfrogsfrogs>
In-Reply-To: <170405011748.1811141.16068744852666586384.stgit@frogsfrogsfrogs>
References: <170405011748.1811141.16068744852666586384.stgit@frogsfrogsfrogs>
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
 libxfs/libxfs_priv.h  |    2 --
 libxfs/xfs_rtbitmap.c |   16 ++++++++--------
 2 files changed, 8 insertions(+), 10 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 178330aafa1..57b8edc54a5 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -178,8 +178,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define XFS_ILOCK_EXCL			0
 #define XFS_IOLOCK_SHARED		0
 #define XFS_IOLOCK_EXCL			0
-#define XFS_ILOCK_RTSUM			0
-#define XFS_ILOCK_RTBITMAP		0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_ADD(mp, count, x)	do { (mp) = (mp); } while (0)
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 72d9d0f0ec9..69c70c89c96 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1203,11 +1203,11 @@ xfs_rtbitmap_lock(
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
@@ -1217,8 +1217,8 @@ void
 xfs_rtbitmap_unlock(
 	struct xfs_mount	*mp)
 {
-	xfs_iunlock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
-	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+	xfs_iunlock(mp->m_rsumip, XFS_ILOCK_EXCL);
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL);
 }
 
 /*
@@ -1231,10 +1231,10 @@ xfs_rtbitmap_lock_shared(
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
@@ -1244,8 +1244,8 @@ xfs_rtbitmap_unlock_shared(
 	unsigned int		rbmlock_flags)
 {
 	if (rbmlock_flags & XFS_RBMLOCK_SUMMARY)
-		xfs_iunlock(mp->m_rsumip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
+		xfs_iunlock(mp->m_rsumip, XFS_ILOCK_SHARED);
 
 	if (rbmlock_flags & XFS_RBMLOCK_BITMAP)
-		xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+		xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED);
 }

