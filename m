Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F882194A9
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191140; cv=none; b=IB1g9Lw7vUO7/UA5wpgguDWn0RZ/iND/Gfefzw8vHgqLkfSbtyvG+QpGe7qBK7+d8Uchz7jKLBcdnBMEuKCGF02xroZkxfeZCp/KdWxiTwyOhkeew3sEVBDoxdgPzNlJVgJzeyiPZyBYFLvCPQCGWOhY2RBtPz87yRc92Ib9X2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191140; c=relaxed/simple;
	bh=c6SpfCov8L841eto8mrDZDR6uimoB6fGKncbmclUGo8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mEFEDoTf/6XmynVPOsGhhvN3AE6vf5vXQBi3zQkzfVRuas74VZFmz0RtbIymvn31raeR9MB+MPkHVFmeesy/PcjTcT/ZBGWDFnsnYn/rNWKFYebLlNV9Wt2F0t+rzpbQvq6fuLDQQ7ehIyk/QEkJupllsAasbLt1aPCCg2vMRgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pQtlODSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pQtlODSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891E4C4CEC3;
	Thu, 17 Oct 2024 18:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191140;
	bh=c6SpfCov8L841eto8mrDZDR6uimoB6fGKncbmclUGo8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pQtlODSxpNUvW0BpiW8ySmW4cBO6p+TvG/CxQ1+bx17eMkkdTTk6p9kDoraVSi9I9
	 8ILjkplfUYwGSwMio2JhfWJqMNE+4omNdKTC6mLoSb3GASz5FDJQ3nVhF1XK5OuPpd
	 e9nrwtKLaFS9e5mkKocTAvKcIDFJfgeSydcM8zLwx6XMS8YSknrzcn15eA3TvvchMv
	 82WxWuIgJDX5hzV+HoKMmSKmaPyoBUVj1fmRKXV8nYyqDvrmVcnjGp4FV8Hbqok851
	 zdRCvo5GYubOX7hUVOjAF2bUGP6PRBPEL28/m06BQ9Q3M9Ntq8osJ5ARr6ZrpCXvoq
	 ylxDZOTtZZqyw==
Date: Thu, 17 Oct 2024 11:52:20 -0700
Subject: [PATCH 03/16] xfs: add a xfs_group_next_range helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068724.3450737.17839132713666037909.stgit@frogsfrogsfrogs>
In-Reply-To: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
References: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
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

