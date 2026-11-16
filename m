Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871039;
	b=QqWrtlUlBlL6uTdilN+BtV+1O17OlQbw+sPbu26bPRazYyv2aXQ51L6Wa4fvLokFRCYl
	 4Cwp1q+38tZU6wiUUpXaGsAiHjLXdrzmRY+HuLWMUxK7Sa0Xt3V2LC8L/vnCn4Us1vG4V
	 4/F/4KvEaywDzNwOrM4v2tRQSwjzQyx4GCZNoDYDXsggJa+pYVdTZyOJSacbp1eb6cJGQ
	 joQDxlrVUBwEZNCxwLXsNuKo5feQb39g3hw3eb8hBl3/FyEW4Ktr990+mQ2FphvS6+E2y
	 LwL70dISdsuZxx/3EH0hu9K28L+qKv3l9jGXafp2EFiQ+UgpiqPjNQxZZNa2tnRxguQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=nXsAvi0K5T7xSb5+poAMyDdz32GgmofLuPK5TFgGAYs=;
	b=Oot6EnAGcM8Pmy6RXLRTFx3Ihnw6g2kI36XEGVUlIyFSuE+Zj4rOOwioiBTbP2SVjn7G
	 nmIJxf1KZeZ6gEWYPYwHaSNac9QcSC/h7LCBXTRSMAOu4OK6+IrblAgg+aJIsU1haZeE3
	 nlwznnP2CXWsztJdpUK/KSp+Rwi7aGSeQbLPz+G+mGzHi5RONqlsNsFNnufqiaA9MHAa1
	 HvGFaaTywvuLy39Z0j6mNZ0b1wRCo9++FAegMm5sSo4MgcFR1FE7Zb7867FBn8CiQatR5
	 UjBm33PH83uRNNHiTPCuQ8228IwS2AAdirjRAiPsEuyeUuV+Fet7KKt2qlUX7SRCsPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="W/EaZXNt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90D3606A31C
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W/EaZXNt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEF91F000C7;
	Mon, 16 Nov 2026 23:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871039;
	bh=nXsAvi0K5T7xSb5+poAMyDdz32GgmofLuPK5TFgGAYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/EaZXNtgUNL6XAJ8U2RZZqJJEY+wR6rDUQ9YgyUqW/6FxYxE47I11YPjjxiRm63R
	 wbEacIgwaTJB7QWjRRBuVqE0+0QH4shb07tZHGDB/K6bwegMxVB2ad3cj+uA9T3l+V
	 pACQTGf20Ej2djgD/lozk5prLDtAZYGtvFZoc9tqY3B3dG4rbm5IINoyiPWy9e9Jw5
	 0VGOufO58E7C2/yrHXBsJUc582ZWOf5ZDjao4u7WfO+AoJgTY4nIKeXNrWbsRIR/ws
	 PCA1EOa6oOiglCeoAZWSNKmfoiu9Xtr2AxoD/rjjZkuH/pZhwsjSvBu+rYIlRGx9QE
	 YSRLCQ5lt1d5w==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 04/59] xfs: recompute the rt btree maxlevels when growfs changes them
Date: Tue, 17 Nov 2026 10:14:21 +1100
Message-ID: <20261116231707.3625263-5-dgc@kernel.org>
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

m_rtbtree_maxlevels is the larger of the rt rmap and rt refcount btree maximum
heights, and the metadata btree space reservation code uses it. It is only
computed at mount time.

Growfs recomputes m_rtrmap_maxlevels and m_rtrefc_maxlevels when realtime
growfs adds the first realtime volume, and when data growfs changes the data
device size that bounds their height. m_rtbtree_maxlevels is stale until the
next mount after either of these. It stays zero after growfs adds the first
realtime volume.

Move the helper that computes it into xfs_mount.h, and call it wherever growfs
recomputes the rt btree maximum heights.

Fixes: 05290bd5c623 ("xfs: allow inode-based btrees to reserve space in the data device")
Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_fsops.c   | 1 +
 fs/xfs/xfs_mount.c   | 9 ---------
 fs/xfs/xfs_mount.h   | 9 +++++++++
 fs/xfs/xfs_rtalloc.c | 2 ++
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 21114bb6d4ff..cd399e2a9c7f 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -226,6 +226,7 @@ xfs_growfs_data_private(
 		/* Compute new maxlevels for rt btrees. */
 		xfs_rtrmapbt_compute_maxlevels(mp);
 		xfs_rtrefcountbt_compute_maxlevels(mp);
+		xfs_rtbtree_compute_maxlevels(mp);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 60931cb00817..e4036eec579d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -833,15 +833,6 @@ xfs_set_max_atomic_write_opt(
 	return 0;
 }
 
-/* Compute maximum possible height for realtime btree types for this fs. */
-static inline void
-xfs_rtbtree_compute_maxlevels(
-	struct xfs_mount	*mp)
-{
-	mp->m_rtbtree_maxlevels = max(mp->m_rtrmap_maxlevels,
-				      mp->m_rtrefc_maxlevels);
-}
-
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index cbcfb89c67a4..43afd55a613a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -487,6 +487,15 @@ static inline bool xfs_has_rtreflink(const struct xfs_mount *mp)
 	       xfs_has_reflink(mp);
 }
 
+/* Compute maximum possible height for realtime btree types for this fs. */
+static inline void
+xfs_rtbtree_compute_maxlevels(
+	struct xfs_mount	*mp)
+{
+	mp->m_rtbtree_maxlevels = max(mp->m_rtrmap_maxlevels,
+				      mp->m_rtrefc_maxlevels);
+}
+
 static inline bool xfs_has_nonzoned(const struct xfs_mount *mp)
 {
 	return !xfs_has_zoned(mp);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 31d90828b4e9..760d73e4afa2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -933,6 +933,7 @@ xfs_growfs_rt_zoned(
 	mp->m_features |= XFS_FEAT_REALTIME;
 	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_rtrefcountbt_compute_maxlevels(mp);
+	xfs_rtbtree_compute_maxlevels(mp);
 
 	/*
 	 * Finally add the newly added zone to the freelist and add the space
@@ -1078,6 +1079,7 @@ xfs_growfs_rt_bmblock(
 	mp->m_features |= XFS_FEAT_REALTIME;
 	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_rtrefcountbt_compute_maxlevels(mp);
+	xfs_rtbtree_compute_maxlevels(mp);
 
 	kfree(nmp);
 	return 0;
-- 
2.55.0

