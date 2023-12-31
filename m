Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0C4BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="baX+sG9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7F6C433C8;
	Sun, 31 Dec 2023 21:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057306;
	bh=nyYrZMHEslDRQ4uMV6qgk7XlG1fPZ0aJPECXgvNmiS4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=baX+sG9QcFiDeN3QiXOy7CFPYqfXbE3kMfL1QtY+2OGXKDXZSfQkoTTKnLyCz2WAQ
	 GCDw2PQiPHUCi9A5+7l4tAKqavbHpDmV1+uGTHasXd/ZsnLlW9P0HS2zOVweSqO10u
	 uB75ROZEjg8Af84wy0KKqdPi9NAnlrzJrsNBNjpgEwrxU5yCq6enMTSkKGq/wTFtUI
	 OytOfTDcrEeKs52NQuHAFRB0PUZ2a6SeA1JatjNipCw7Z22BwRNAni8njwH83Bk2ws
	 bJG83EMUPaCX/U0wCIhTN/LksJIy9pcYJs076/VId4E8b3C5A5w5abbXhMY6qKu+YE
	 z2UfJmbsYfPhA==
Date: Sun, 31 Dec 2023 13:15:05 -0800
Subject: [PATCH 2/4] xfs: use separate lock classes for realtime metadata
 inode ILOCKs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845764.1761787.10388498060894783957.stgit@frogsfrogsfrogs>
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

Realtime metadata files are not quite regular files because userspace
can't access the realtime bitmap directly, and because we take the ILOCK
of the rt bitmap file while holding the ILOCK of a realtime file.  The
double nature of inodes confuses lockdep, so up until now we've created
lockdep subclasses to help lockdep keep things straight.

We've gotten away with using lockdep subclasses because there's only two
rt metadata files, but with the coming addition of realtime rmap and
refcounting, we'd need two more subclasses, which is a lot of class bits
to burn on a side feature.

Therefore, switch to manually setting the lockdep class of the rt
metadata ILOCKs.  In the next patch we'll remove the rt-related ILOCK
subclasses.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7156a5b55cfb6..a033d3361b561 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -25,6 +25,16 @@
 #include "xfs_da_format.h"
 #include "xfs_imeta.h"
 
+/*
+ * Realtime metadata files are not quite regular files because userspace can't
+ * access the realtime bitmap directly, and because we take the ILOCK of the rt
+ * bitmap file while holding the ILOCK of a regular realtime file.  This double
+ * locking confuses lockdep, so create different lockdep classes here to help
+ * it keep things straight.
+ */
+static struct lock_class_key xfs_rbmip_key;
+static struct lock_class_key xfs_rsumip_key;
+
 /*
  * Read and return the summary information for a given extent size,
  * bitmap block combination.
@@ -1330,6 +1340,28 @@ xfs_rtalloc_reinit_frextents(
 	return 0;
 }
 
+static inline int
+__xfs_rt_iget(
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	struct lock_class_key	*lockdep_key,
+	const char		*lockdep_key_name,
+	struct xfs_inode	**ipp)
+{
+	int			error;
+
+	error = xfs_imeta_iget(tp, ino, XFS_DIR3_FT_REG_FILE, ipp);
+	if (error)
+		return error;
+
+	lockdep_set_class_and_name(&(*ipp)->i_lock.mr_lock, lockdep_key,
+			lockdep_key_name);
+	return 0;
+}
+
+#define xfs_rt_iget(tp, ino, lockdep_key, ipp) \
+	__xfs_rt_iget((tp), (ino), (lockdep_key), #lockdep_key, (ipp))
+
 /*
  * Read in the bmbt of an rt metadata inode so that we never have to load them
  * at runtime.  This enables the use of shared ILOCKs for rtbitmap scans.  Use
@@ -1376,7 +1408,7 @@ xfs_rtmount_inodes(
 	if (error)
 		return error;
 
-	error = xfs_imeta_iget(tp, mp->m_sb.sb_rbmino, XFS_DIR3_FT_REG_FILE,
+	error = xfs_rt_iget(tp, mp->m_sb.sb_rbmino, &xfs_rbmip_key,
 			&mp->m_rbmip);
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, XFS_SICK_RT_BITMAP);
@@ -1388,7 +1420,7 @@ xfs_rtmount_inodes(
 	if (error)
 		goto out_rele_bitmap;
 
-	error = xfs_imeta_iget(tp, mp->m_sb.sb_rsumino, XFS_DIR3_FT_REG_FILE,
+	error = xfs_rt_iget(tp, mp->m_sb.sb_rsumino, &xfs_rsumip_key,
 			&mp->m_rsumip);
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, XFS_SICK_RT_SUMMARY);

