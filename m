Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB323D092A
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146011; cv=none; b=K3vtLs/IQLNynJWRfaayKlUM4KMuy5DxzwZuTLEsX98ovakjzFqLn4IedYOdBx6crCdLZjq68Piuia4RNwftEGL1ekt5Q3IO2HJ4oilCYLOxJAd9lrxI7AXEiNqXd1axz88+YtqJ8N3j777PJtUwVmy/mL60QLF9OUthHa8UZD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146011; c=relaxed/simple;
	bh=O2A1ARd9rS9e5C9B8ti2ogqa5nDpg9ibtZ0Ao+5Fgeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlB8lFvFCigesYp2o9LAMLUDXI/U9gnRYhb5Mh/oNl0suDDhYvZI950Hw5Emh6hFk6cQ+N23s3D0tPLwTz8ZXxbLui6sMh+4MAqtJ5c3wk7LaODq4RBiolp9QPJlqboYkN063CjUNjkGvBMigWmulbOHHA1PiYp60wP6rS4tf5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xr7K6xOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xr7K6xOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC08C19425;
	Tue, 10 Mar 2026 12:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773146011;
	bh=O2A1ARd9rS9e5C9B8ti2ogqa5nDpg9ibtZ0Ao+5Fgeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xr7K6xOgivLO7VrtKmz0bSC1dImHM3qu61sSRfaFhsi7KF4dBAYMqmjl2ORyvny8M
	 8wVJBAIieV+CE1b5T9nMSq98wKxf7L4HiZocqkVhw1hU9uNjtCq9UnI+a2e9UsWpJu
	 esnzIezkhoO1reldX3a37qySkXbmhf/InX/MnYIeyQGNGGnTgPJKrlijQN4p/wTiO2
	 qstH5M9C+T71FOPoDT7QfyQZYJsq6xzD5WqqMaf2WMDfusB6RoE1HyUxI/AMBMZF7Y
	 t5FYCyR/REXCmtcS+nc5pv/AhRmJRdjcbbOPgGJMfW/sGa4lzTu/7eyRK+nbNmBmUD
	 M+uZWQFypOxMA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH 1/3] xfs: add a couple helpers to alloc/free xfs_busy_extents
Date: Tue, 10 Mar 2026 13:33:14 +0100
Message-ID: <20260310123324.339310-2-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310123324.339310-1-cem@kernel.org>
References: <20260310123324.339310-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

There are a couple locations which repeats the same code pattern
to alloc/free the xfs_busy_extents list

These helpers will come in handy when decoupling busy_extents
list from the cil context.

Notice though commit bf4afc53b77a removed GFP_KERNEL from the kzalloc_obj()
calls due to the new default argument.
On future usage we'll also need to pass NOFAIL here, so we need to be able
to pass some flags as argument.

The avoid calls like xfs_busy_extents_alloc(0) explicitly pass GFP_KERNEL
as argument. It looks better to me.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_discard.c     | 12 +++++-------
 fs/xfs/xfs_extent_busy.h | 17 +++++++++++++++++
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 906221ffe9ba..f393be78dc46 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -349,18 +349,17 @@ xfs_trim_perag_extents(
 	do {
 		struct xfs_busy_extents	*extents;
 
-		extents = kzalloc_obj(*extents);
+		extents = xfs_busy_extents_alloc(GFP_KERNEL);
 		if (!extents) {
 			error = -ENOMEM;
 			break;
 		}
 
 		extents->owner = extents;
-		INIT_LIST_HEAD(&extents->extent_list);
 
 		error = xfs_trim_gather_extents(pag, &tcur, extents);
 		if (error) {
-			kfree(extents);
+			xfs_busy_extents_free(extents);
 			break;
 		}
 
@@ -689,7 +688,7 @@ xfs_trim_rtgroup_extents(
 	 * trims the extents returned.
 	 */
 	do {
-		tr.extents = kzalloc_obj(*tr.extents);
+		tr.extents = xfs_busy_extents_alloc(GFP_KERNEL);
 		if (!tr.extents) {
 			error = -ENOMEM;
 			break;
@@ -698,7 +697,6 @@ xfs_trim_rtgroup_extents(
 		tr.queued = 0;
 		tr.batch = XFS_DISCARD_MAX_EXAMINE;
 		tr.extents->owner = tr.extents;
-		INIT_LIST_HEAD(&tr.extents->extent_list);
 
 		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
 		error = xfs_rtalloc_query_range(rtg, tp, low, high,
@@ -707,12 +705,12 @@ xfs_trim_rtgroup_extents(
 		if (error == -ECANCELED)
 			error = 0;
 		if (error) {
-			kfree(tr.extents);
+			xfs_busy_extents_free(tr.extents);
 			break;
 		}
 
 		if (!tr.queued) {
-			kfree(tr.extents);
+			xfs_busy_extents_free(tr.extents);
 			break;
 		}
 
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 3e6e019b6146..699f97a53530 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -43,6 +43,23 @@ struct xfs_busy_extents {
 	void			*owner;
 };
 
+static inline struct xfs_busy_extents *
+xfs_busy_extents_alloc(gfp_t flags)
+{
+	struct xfs_busy_extents *e;
+	e = kzalloc_obj(*e, flags);
+
+	if (e)
+		INIT_LIST_HEAD(&e->extent_list);
+	return e;
+}
+
+static inline void xfs_busy_extents_free(
+	struct xfs_busy_extents *e)
+{
+	kfree(e);
+}
+
 void xfs_extent_busy_insert(struct xfs_trans *tp, struct xfs_group *xg,
 		xfs_agblock_t bno, xfs_extlen_t len, unsigned int flags);
 void xfs_extent_busy_insert_discard(struct xfs_group *xg, xfs_agblock_t bno,
-- 
2.53.0

