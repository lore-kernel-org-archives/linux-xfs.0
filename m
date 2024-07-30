Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91B94683
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300028; cv=none; b=TIb6OAhbIVm6lXuM58RaPsXgZb60e9b/oCoYvMq/xZmSsiYGSuHjuyc2VYC+7DGJz5D5ArBPbkT42UVHq7AQAv8+fntqxjrYHkwXrNgExsbTHICbel37BypFURYTBR6J3nNEBSOTD2DNEdraET/sApbCU6711UuRTnki+fMdzk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300028; c=relaxed/simple;
	bh=Tf4rB540x6TYB9Xi+exGBcdC/FoLBJEmvZhYthE+NV0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/HMo5AhJ8ufawQER+EEUimmjHDTOYV514c4WZbXXLItK+jtvuIdP+D4M9Spz2c7yxJqXBGuHbKdD7kd6XmOfHBBZqBAqDaf1VFMzikcGyJMtwbHASv9FzdbcdCtSGBaFjpTYl2WalX6zOxXMENRwRw9d/s/pleaqWwDjO/YW8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igSk6pR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igSk6pR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1A6C32786;
	Tue, 30 Jul 2024 00:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300028;
	bh=Tf4rB540x6TYB9Xi+exGBcdC/FoLBJEmvZhYthE+NV0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=igSk6pR7U7ScHhvdY9aATjn09IdQHmLevPwNi2HNzo/2TMX9+vFAs0dlqP7oPfPOx
	 ncRUwosIe+hQW+qwdtHRBAnAYD5Gq+o3NdBXRjOySmLi/1a/Z+LhXcqxKOgEegWzOS
	 sxO7UAW/JJVzDnC7O0qPP7QcKA3647WA8QK6ykPJ1krixJpwTvGymeW9fC5eVOIn6W
	 JJcex/ONBr7GcPknugjLOilArKp1+7rr2abfd+ZaaimSQRPp0AIJQ4PLLYGHjV8a3H
	 itQuO/+mVcbrDTNYEIdYgr9xc73KKpyEOFqtvzXKHLRiPxp2y2yAk+7p9i1D8L+9Tf
	 HB9b1Bcklr55A==
Date: Mon, 29 Jul 2024 17:40:28 -0700
Subject: [PATCH 064/115] xfs: add parent attributes to link
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843345.1338752.534634287541735225.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: f1097be220fa938de5114db57a1ddb5de2bf6046

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor rebase fixes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_trans_space.c |   14 ++++++++++++++
 libxfs/xfs_trans_space.h |    3 +--
 2 files changed, 15 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_trans_space.c b/libxfs/xfs_trans_space.c
index 3408e700f..039bbd91e 100644
--- a/libxfs/xfs_trans_space.c
+++ b/libxfs/xfs_trans_space.c
@@ -50,3 +50,17 @@ xfs_mkdir_space_res(
 {
 	return xfs_create_space_res(mp, namelen);
 }
+
+unsigned int
+xfs_link_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_parent_calc_space_res(mp, namelen);
+
+	return ret;
+}
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 6cda87153..553963400 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -86,8 +86,6 @@
 	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
-#define	XFS_LINK_SPACE_RES(mp,nl)	\
-	XFS_DIRENTER_SPACE_RES(mp,nl)
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
 	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + \
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
@@ -107,5 +105,6 @@ unsigned int xfs_parent_calc_space_res(struct xfs_mount *mp,
 
 unsigned int xfs_create_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_mkdir_space_res(struct xfs_mount *mp, unsigned int namelen);
+unsigned int xfs_link_space_res(struct xfs_mount *mp, unsigned int namelen);
 
 #endif	/* __XFS_TRANS_SPACE_H__ */

