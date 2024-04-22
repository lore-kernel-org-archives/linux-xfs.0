Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3141552EC
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804006; cv=none; b=i3o+/PBbHjR6zXTnp8xT8pdsHfnTnlG86cpzEqdfDLfOXZ9abfsuIGgEjoXlUd0PMvqWfUHZjDepOLBP7kjdxsoCIBne8D4eYEcHGAGKoalE5KHaUHW0kT/bxPe2vV3sG9t4wvPgXzL3EGS77WyF2jKF/f24VNvyqXN868Y9KXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804006; c=relaxed/simple;
	bh=I8epqSaStVeOoiCRWesthf3j4xojYvRvgKU59y/h+M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuCfOwzY3lWZKV39pCshrM75XzbnqTq13ZGGWdfb0UR2sQ0hPXjF+obtiJ8ZQgZHm+ZU2MyQ8cH6oFCgN6y1Di/wpVr8BDlKfDRxDi1D0p7dvq1J7ZLoRZ4DFE4rXJ8X38nUjcDOhAq9o9Qm2NMhJTCNo6Lm1zqEr/obN4xf9fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YreS4++v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YreS4++v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F07C113CC;
	Mon, 22 Apr 2024 16:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804005;
	bh=I8epqSaStVeOoiCRWesthf3j4xojYvRvgKU59y/h+M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YreS4++vxYA6nifIJR1vobIdlggDzq42GxBOomKAsBdMItQOthGx7QsB/UaT89To8
	 o+bIQYSunOgP6Hi+JUo9wH7GQYLA1YGH/nTdkQmhpe1VaXJd0ZLviO65Pr/PbR8RTm
	 LEUwgx2wGoxqWdbL/ZEHXf80zQxSobshgDmEckqVyAk535//tTeCAcEBbPjq+ztA2N
	 rvE/f8KARTIE4MZme09t3hlOwkZn5WqF7AYLvNGL6/C5eh8VTAI2F2sKYVu4UUjUjU
	 W44fenfVDwlj1djZP6VQn8AXokzj++BJoeM2m4vt4RA4SpuYkpDXU4yNGYu6A35IT5
	 P3LKSxcDW5CJg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 38/67] xfs: set inode sick state flags when we zap either ondisk fork
Date: Mon, 22 Apr 2024 18:26:00 +0200
Message-ID: <20240422163832.858420-40-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: d9041681dd2f5334529a68868c9266631c384de4

In a few patches, we'll add some online repair code that tries to
massage the ondisk inode record just enough to get it to pass the inode
verifiers so that we can continue with more file repairs.  Part of that
massaging can include zapping the ondisk forks to clear errors.  After
that point, the bmap fork repair functions will rebuild the zapped
forks.

Christoph asked for stronger protections against online repair zapping a
fork to get the inode to load vs. other threads trying to access the
partially repaired file.  Do this by adding a special "[DA]FORK_ZAPPED"
inode health flag whenever repair zaps a fork, and sprinkling checks for
that flag into the various file operations for things that don't like
handling an unexpected zero-extents fork.

In practice xfs_scrub will scrub and fix the forks almost immediately
after zapping them, so the window is very small.  However, if a crash or
unmount should occur, we can still detect these zapped inode forks by
looking for a zero-extents fork when data was expected.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_health.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 99e796256..6296993ff 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -68,6 +68,11 @@ struct xfs_fsop_geom;
 #define XFS_SICK_INO_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_SICK_INO_PARENT	(1 << 7)  /* parent pointers */
 
+#define XFS_SICK_INO_BMBTD_ZAPPED	(1 << 8)  /* data fork erased */
+#define XFS_SICK_INO_BMBTA_ZAPPED	(1 << 9)  /* attr fork erased */
+#define XFS_SICK_INO_DIR_ZAPPED		(1 << 10) /* directory erased */
+#define XFS_SICK_INO_SYMLINK_ZAPPED	(1 << 11) /* symlink erased */
+
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
 				 XFS_SICK_FS_UQUOTA | \
@@ -97,6 +102,11 @@ struct xfs_fsop_geom;
 				 XFS_SICK_INO_SYMLINK | \
 				 XFS_SICK_INO_PARENT)
 
+#define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
+				 XFS_SICK_INO_BMBTA_ZAPPED | \
+				 XFS_SICK_INO_DIR_ZAPPED | \
+				 XFS_SICK_INO_SYMLINK_ZAPPED)
+
 /* These functions must be provided by the xfs implementation. */
 
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask);
-- 
2.44.0

