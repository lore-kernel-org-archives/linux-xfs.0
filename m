Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E17ABA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hyMOzjJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F6EC433C7;
	Sun, 31 Dec 2023 20:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053536;
	bh=7e9SWnC3+VGuEkyLLPgxGE34YU/y0TNEqFg0VTUzMfI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hyMOzjJaXBt8Gi28U9kRoMKZ9CPv7zO5uyDxyI0Zq4CCkAXN8cD7RCDrZDFk7eCJP
	 RDPOmH6QvDiamKZAFideVnFUJLfXn4qiErbgx0/VA1l3QCA52oQUZoVLCjrvQTRLqA
	 JwMLBrmsNcLmaKCIdJUtBYUvS5bjJZEcHgx3XnzEFpRuYOowN6qaGozR5f0sT7xstK
	 cHmWWdeLlBdgM6FxGbV/p9foq+tqVg5hFjWibkxPbBmTalcWAHJgo7PyIoPnfSeeTJ
	 b72Nc8l3/Nb8h7fg1yR5gIAmGZH+P3biYwYQFoF8h2MnWk0Wy6ehYrX6rxa99ZYwg7
	 wEc5iVBQi1LHA==
Date: Sun, 31 Dec 2023 12:12:15 -0800
Subject: [PATCH 10/11] xfs: report realtime metadata corruption errors to the
 health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404828442.1748329.6555825768145156253.stgit@frogsfrogsfrogs>
In-Reply-To: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
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

Whenever we encounter corrupt realtime metadat blocks, we should report
that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    9 ++++++++-
 fs/xfs/xfs_rtalloc.c         |    6 ++++++
 2 files changed, 14 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 30a2844f62e30..f43f31dca69d7 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -17,6 +17,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_health.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -115,13 +116,19 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_written_extent(&map)))
+	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_written_extent(&map))) {
+		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
+					     XFS_SICK_RT_BITMAP);
 		return -EFSCORRUPTED;
+	}
 
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, args->tp, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
 				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
+					     XFS_SICK_RT_BITMAP);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 0c9893b9f2a99..379462ea9a14f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -20,6 +20,8 @@
 #include "xfs_rtalloc.h"
 #include "xfs_sb.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_log_priv.h"
+#include "xfs_health.h"
 
 /*
  * Read and return the summary information for a given extent size,
@@ -1374,6 +1376,8 @@ xfs_rtmount_inodes(
 
 	sbp = &mp->m_sb;
 	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
+	if (xfs_metadata_is_sick(error))
+		xfs_rt_mark_sick(mp, XFS_SICK_RT_BITMAP);
 	if (error)
 		return error;
 	ASSERT(mp->m_rbmip != NULL);
@@ -1383,6 +1387,8 @@ xfs_rtmount_inodes(
 		goto out_rele_bitmap;
 
 	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
+	if (xfs_metadata_is_sick(error))
+		xfs_rt_mark_sick(mp, XFS_SICK_RT_SUMMARY);
 	if (error)
 		goto out_rele_bitmap;
 	ASSERT(mp->m_rsumip != NULL);

