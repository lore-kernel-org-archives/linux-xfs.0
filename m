Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12B033981
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591511; cv=none; b=qJsd3kmcpYlTIrZMKKG6x33HNZRznS0HfmshU+Mr1Zoyqte+aeM+QVOuqVc+NBezh+6GQ+NhH6AxwkZ6nTAmEtqGq0OHVE1LLoxg20CnpvP6NhI5+9v9h1Ev1TxujFaPXyLJBoRxoLFhd5YcYS+ZD1llxT/6xjIIljVTQZhcdiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591511; c=relaxed/simple;
	bh=KqRXwvzVcR8uJP7GS5OEJT/y2RMSKmA8NSriMKGKRg8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=USm2SSOBpqiusQmn/iBjphEUTyuPlG0Bq7kNsJNsmWG8q3EeH/BUKu4FpeALExaLc2G5TUMskfCBYnIfyDzm3g5/8GNrbd+2JKGXCn6sEPX4woPCl8GfU+VgkqlWm7XDlFbKv2t2oAdgGN2fCZhbgmvKEP/g1pjSkVNaewIVT9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ufy1jIUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ufy1jIUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657EAC433C7;
	Tue, 30 Jan 2024 05:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591510;
	bh=KqRXwvzVcR8uJP7GS5OEJT/y2RMSKmA8NSriMKGKRg8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ufy1jIUL/+Vp7/WNEJshwTxv4+l9gvNwxWYMas5y7pqeRJo3yfkIzdHExuBrqwd42
	 A22WpmZtmP5s4mcjUFGMI6GDq3WPeadlFQxf2+BU3lgcyjJyKsM4iCSX+p1CUM+owR
	 aikXuE43HjFX605JlG+yjkDxv9cOARQGq29JIoFHUuwqkwjxmVtdxTpO7UAmJDSDCt
	 gffM3fwuaLL7tVNEO0kLVpjdGBBrc2nyGgtmqGnlNc5jBjvDk/iRZtnnkaSF6wIbH3
	 HJT3H7EEwNPQXup0HcoxGIZ+E/H8nJRRUVpZRWQKd2A+s6je571pio3rkPGu7i0Qxm
	 bDPV7ei7jJdZw==
Date: Mon, 29 Jan 2024 21:11:50 -0800
Subject: [PATCH 10/11] xfs: report realtime metadata corruption errors to the
 health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063891.3353909.1994685754773833374.stgit@frogsfrogsfrogs>
In-Reply-To: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
References: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    9 ++++++++-
 fs/xfs/xfs_rtalloc.c         |    6 ++++++
 2 files changed, 14 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index e31663cb7b434..8af3fce505f04 100644
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
index 8649d981a097d..c3b7e6fb0356a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -22,6 +22,8 @@
 #include "xfs_sb.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_quota.h"
+#include "xfs_log_priv.h"
+#include "xfs_health.h"
 
 /*
  * Return whether there are any free extents in the size range given
@@ -1202,6 +1204,8 @@ xfs_rtmount_inodes(
 
 	sbp = &mp->m_sb;
 	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
+	if (xfs_metadata_is_sick(error))
+		xfs_rt_mark_sick(mp, XFS_SICK_RT_BITMAP);
 	if (error)
 		return error;
 	ASSERT(mp->m_rbmip != NULL);
@@ -1211,6 +1215,8 @@ xfs_rtmount_inodes(
 		goto out_rele_bitmap;
 
 	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
+	if (xfs_metadata_is_sick(error))
+		xfs_rt_mark_sick(mp, XFS_SICK_RT_SUMMARY);
 	if (error)
 		goto out_rele_bitmap;
 	ASSERT(mp->m_rsumip != NULL);

