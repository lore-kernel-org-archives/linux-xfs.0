Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871046;
	b=aWU0gHgUZZY8pXGsgeu2lkHBghBbO2ajrZCFUPoms4Qy6HH8v4GUOff8tAD+GMnTcVGJ
	 k9l4uFj8x7d8tTkg0q8z11ARs24P8QPudbCzcOkcAreTuGtZRugrAM87cWbaiJuxikh4V
	 MPZwbb+qYynrXyZFsh1T0mUz9tn7Yoa5ssPZgTt1+syobM4HVyxVC6SEbgYvCpkhZyVWh
	 DrARwnzQwtRYS77LVFQEDCMBvjAP2nA02eIeP1vKJHILV86aJad9l3FtDvjfAUqITq7j5
	 TismeCX5LSlPXJX/VqexRGF3wm3kvuL9FGcFhfF8Vlbh533OeZDvK97oO9jTiZFO3Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=vDiRqFLyFCwBF7tx6TV1xOqNmmzRsRFVcmcZ9zFW6ZI=;
	b=4VoBv+N5CLZczedn8DdF6jzSEMKyxnUpV+bz3rzY8UGIqokcLtmJY3v1bUSvMydrHyKf
	 PEJ7fN9I2swJ63KhEH100cW44F2B5v5aRFx1Ov6CLN1LUJOQ/DOMciOljcBCagvVjwdoK
	 aaynhH9H5yNcXqP35Y/0sav8q8xYW9CqZGMZmAVaJEvK/BqGPJLwwGt374oCI62KP9N87
	 4rT1dhm/01bfdGhz7TBZxQYu/2XcW0mUQdojcaHrqBNTZB1l/2Ih4RFYFi2jDCvLtRV8v
	 eOgWs2XqEtPALzHDIgcbq7f0uzCD39rZNOordVw60opAvejPw2ZyLMtSaF1PTdPfy/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VLKHZl0T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E443606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VLKHZl0T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D8E1F000C8;
	Mon, 16 Nov 2026 23:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871046;
	bh=vDiRqFLyFCwBF7tx6TV1xOqNmmzRsRFVcmcZ9zFW6ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLKHZl0TqqMGtPdHS8BJRyZOh1IbrtmgZZzBG4Lu3Pgv2GpWZRmPvPrl+JmIcsYBg
	 eLFrozBenniWL5Y8Px3ArftX1LFY3hCbVTR4dzjJxm4xXH74Rjsv5Pv/ikYxuwJVwm
	 YGqZq4hsHgQxKEuJruKVd17Dgl781Uak3n/mhyZh3SyzW57QTkAUSEeLn5GwhUIz64
	 VU5uvqTXIDtglqTbdL3SMowlqWk2cjNLfZvTw/v8RgtL+JWoQYK49nHKwICY/sCu5P
	 KF8eFMBmK1PE5VORH8OfdT+xPgxHM3VmQn0YegOh0e1dwqzH8Cpyi2q/DnKX/DBMCg
	 a5FHuxtXnz+xQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 09/59] xfs: apply mount superblock updates after log recovery
Date: Tue, 17 Nov 2026 10:14:26 +1100
Message-ID: <20261116231707.3625263-10-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mount makes several updates to the in-core superblock that are written back
later in the mount. These updates are applied before log recovery runs. The
superblock is re-read from disk when the log is dirty, and the re-read discards
them. The later superblock write then writes the old values back, so the
updates are lost on any mount that recovers the log. Stripe geometry given as
mount options is used by that mount, but it never reaches the on-disk
superblock.

Apply these updates after the superblock has been re-read, on every mount.
Nothing between their old and new positions in the mount depends on them. The
superblock verifier also sees the same stripe alignment state when the
superblock is re-read as when it was first read.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_mount.c | 79 +++++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 11040773fca0..cfc16023231c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -882,28 +882,15 @@ xfs_mount_reinit_fs_geometry(
 }
 
 /*
- * This function does the following on an initial mount of a file system:
- *	- reads the superblock from disk and init the mount struct
- *	- if we're a 32-bit kernel, do a size check on the superblock
- *		so we don't mount terabyte filesystems
- *	- init mount struct realtime fields
- *	- allocate inode hash table for fs
- *	- init directory manager
- *	- perform recovery and init the log manager
+ * Apply the updates this mount makes to the in-core superblock. These are
+ * written back later in the mount, so they must be applied after any re-read of
+ * the superblock following log recovery.
  */
-int
-xfs_mountfs(
+static int
+xfs_mount_apply_sb_updates(
 	struct xfs_mount	*mp)
 {
-	struct xfs_sb		*sbp = &(mp->m_sb);
-	struct xfs_inode	*rip;
-	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
-	uint			quotamount = 0;
-	uint			quotaflags = 0;
-	int			error = 0;
-	int			i;
-
-	xfs_sb_mount_common(mp, sbp);
+	struct xfs_sb		*sbp = &mp->m_sb;
 
 	/*
 	 * Check for a mismatched features2 values.  Older kernels read & wrote
@@ -927,14 +914,47 @@ xfs_mountfs(
 		mp->m_update_sb = true;
 	}
 
-
 	/* always use v2 inodes by default now */
-	if (!(mp->m_sb.sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
-		mp->m_sb.sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
+	if (!(sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
+		sbp->sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
 		mp->m_features |= XFS_FEAT_NLINK;
 		mp->m_update_sb = true;
 	}
 
+	/*
+	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
+	 * is NOT aligned turn off m_dalign since allocator alignment is within
+	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
+	 * we must compute the free space and rmap btree geometry before doing
+	 * this.
+	 */
+	return xfs_update_alignment(mp);
+}
+
+/*
+ * This function does the following on an initial mount of a file system:
+ *	- reads the superblock from disk and init the mount struct
+ *	- if we're a 32-bit kernel, do a size check on the superblock
+ *		so we don't mount terabyte filesystems
+ *	- init mount struct realtime fields
+ *	- allocate inode hash table for fs
+ *	- init directory manager
+ *	- perform recovery and init the log manager
+ */
+int
+xfs_mountfs(
+	struct xfs_mount	*mp)
+{
+	struct xfs_sb		*sbp = &(mp->m_sb);
+	struct xfs_inode	*rip;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	uint			quotamount = 0;
+	uint			quotaflags = 0;
+	int			error = 0;
+	int			i;
+
+	xfs_sb_mount_common(mp, sbp);
+
 	/*
 	 * If we were given new sunit/swidth options, do some basic validation
 	 * checks and convert the incore dalign and swidth values to the
@@ -957,17 +977,6 @@ xfs_mountfs(
 	xfs_agbtree_compute_maxlevels(mp);
 	xfs_rtbtree_compute_maxlevels(mp);
 
-	/*
-	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
-	 * is NOT aligned turn off m_dalign since allocator alignment is within
-	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
-	 * we must compute the free space and rmap btree geometry before doing
-	 * this.
-	 */
-	error = xfs_update_alignment(mp);
-	if (error)
-		goto out;
-
 	/* enable fail_at_unmount as default */
 	mp->m_fail_unmount = true;
 
@@ -1106,6 +1115,10 @@ xfs_mountfs(
 			goto out_free_metadir;
 	}
 
+	error = xfs_mount_apply_sb_updates(mp);
+	if (error)
+		goto out_free_metadir;
+
 	/*
 	 * If we're resuming quota status and recovered the log, re-sample the
 	 * qflags from the ondisk superblock now that we've recovered it, just
-- 
2.55.0

