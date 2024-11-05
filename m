Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A051F667B
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844795; cv=none; b=HtkkKeiol0Z0QPIf9AiVmgZQv5LffjeuZY7kxIl19PfJnBxJu7+pobH8Y9hZruYe4XaxJs+wC325UsZRRwV1jDKCtvbUEsNYf72a96FuhDDYOKZuolWJe0SFgvSkemhQqztV6bQ1KiBpuC1xdCSHHzG4bXYnf7/cVHFAR7MLaZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844795; c=relaxed/simple;
	bh=c6SpfCov8L841eto8mrDZDR6uimoB6fGKncbmclUGo8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JxJVurMTvm1veA80B6N1o5hnOckuMVqb+soGFqnzgfazRtiBxc1jVGW1jfA9UCSqRWzTi335QxIo3dWxamHTM7Y9Qqb4j3RpdvnfN6DFjC3R47RoNHsaXqinfr66OyR/43gv/fJtG8Ic24yonnxKkT9jp2Ly83Yb4oCBEo8pNy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pO6nozOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pO6nozOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E30C4CECF;
	Tue,  5 Nov 2024 22:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844795;
	bh=c6SpfCov8L841eto8mrDZDR6uimoB6fGKncbmclUGo8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pO6nozOy+S1Zs9MoX/FvQyCofn5TCRjZEU6YnQ/qig49C5HSc/38boYOg/EbKK1UC
	 5luhHOwFOUo4VY/tbb/vt48wDj+HpxOu6AKJBAV2q1cLAr80md004ZDPkmJiypNKT6
	 jxzpklHdp3psWxhF/EV1w2mOE+Vq13o+iAWS/+wzx1fnEECSiWd3egTKkI9pyn5HFA
	 40Mblzxl1FqbGFQ2Eo3mak9yZU3Dc6eljlSW+gg8k3kmJVruRpYHZLvBpiufNi4L1g
	 Y0Pc7VvIEo/UxbrhHUdjMKjRKYAZK/gmWUmENS2IRlWJKp7cTSbZNjjdz5x8foQV/0
	 Wgwarjc+J+O+w==
Date: Tue, 05 Nov 2024 14:13:15 -0800
Subject: [PATCH 03/16] xfs: add a xfs_group_next_range helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084395320.1869491.1072338675356159578.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395220.1869491.11426383276644234025.stgit@frogsfrogsfrogs>
References: <173084395220.1869491.11426383276644234025.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Add a helper to iterate over iterate over all groups, which can be used
as a simple while loop:

	struct xfs_group		*xg = NULL;

	while ((xg = xfs_group_next_range(mp, xg, 0, MAX_GROUP))) {
		...
	}

This will be wrapped by the realtime group code first, and eventually
replace the for_each_rtgroup_from and for_each_rtgroup_range helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_group.c |   26 ++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_group.h |    3 +++
 2 files changed, 29 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index edf5907845f003..59e08cfaf9bffd 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -87,6 +87,32 @@ xfs_group_grab(
 	return xg;
 }
 
+/*
+ * Iterate to the next group.  To start the iteration at @start_index, a %NULL
+ * @xg is passed, else the previous group returned from this function.  The
+ * caller should break out of the loop when this returns %NULL.  If the caller
+ * wants to break out of a loop that did not finish it needs to release the
+ * active reference to @xg using xfs_group_rele() itself.
+ */
+struct xfs_group *
+xfs_group_next_range(
+	struct xfs_mount	*mp,
+	struct xfs_group	*xg,
+	uint32_t		start_index,
+	uint32_t		end_index,
+	enum xfs_group_type	type)
+{
+	uint32_t		index = start_index;
+
+	if (xg) {
+		index = xg->xg_gno + 1;
+		xfs_group_rele(xg);
+	}
+	if (index > end_index)
+		return NULL;
+	return xfs_group_grab(mp, index, type);
+}
+
 /*
  * Find the next group after @xg, or the first group if @xg is NULL.
  */
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index e3b6be7ff9e802..dd7da90443054b 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -20,6 +20,9 @@ void xfs_group_put(struct xfs_group *xg);
 
 struct xfs_group *xfs_group_grab(struct xfs_mount *mp, uint32_t index,
 		enum xfs_group_type type);
+struct xfs_group *xfs_group_next_range(struct xfs_mount *mp,
+		struct xfs_group *xg, uint32_t start_index, uint32_t end_index,
+		enum xfs_group_type type);
 struct xfs_group *xfs_group_grab_next_mark(struct xfs_mount *mp,
 		struct xfs_group *xg, xa_mark_t mark, enum xfs_group_type type);
 void xfs_group_rele(struct xfs_group *xg);

