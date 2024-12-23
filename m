Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD6D2837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995584; cv=none; b=nf+2R/DFa1kZ9u0f6Lppy2h0mY6pEtEpYxmxxd7ZgNnxg81F7thi9Ra3kfWs54Kg9zfKVN+6lGza2O6L27pavLqJURXai+p7UyrzHVKauUkWy37bC2jo6NVdaix25ct0wlES/YJjXZNOZo95Pm+4fXVCXA2wabitHdK7rmrcMmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995584; c=relaxed/simple;
	bh=l1We+YfAluaG5JJJbMdvAWFqQwoR7txgSEEFh3clbgI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h5HvbZVkDli9TqyetwjW4pruMv7NfsVhQbkCOILzBXtxP3qz3LZz5jX/Umvu2KiGvmBci5wMziLXTPHW2vFbi0qEbiNEuyPmSg1pAsaYB7gS1nWk6QimKyihsv+f3Ow9AYo3WvfIIsa6wbNMczjJHYownL2tSQLvmJpYIz1rl+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rVlMdJ3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rVlMdJ3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3629FC4CED3;
	Mon, 23 Dec 2024 23:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995584;
	bh=l1We+YfAluaG5JJJbMdvAWFqQwoR7txgSEEFh3clbgI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rVlMdJ3Cm2te5DyHn43AMtrGUvRpDK5X3vSJLRaIgyQ1ixzCHLcjDfWfPuSQrVBoL
	 e/4NWsp6k2JrL8ouIh8minrFLgPTu9UpNpF8yuid5sKkgK76oUBrJQ3EZplYT0H4w5
	 OHud/4bukPtaz8dsFgHWD+uOdI7l8EsUZZoh5fYPqqhqgGrkpwenQXLWFgAS3mJXp8
	 5ej7hRlUsis8kEbdOv1W8lb+9QTXRuvr9pARbwh++o8H7+6Fb34iRHzvAK0AAfHze6
	 lU2EdIi2NERwaAC8ZTSj31cXTEWjdmRGwZH6kAd4ZHBp0go3+ZrK9DIUdWkQuuZ9Bx
	 DQGc1oxLI88ZQ==
Date: Mon, 23 Dec 2024 15:13:03 -0800
Subject: [PATCH 26/43] xfs: check that the rtrefcount maxlevels doesn't
 increase when growing fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420384.2381378.9523839720543279899.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The size of filesystem transaction reservations depends on the maximum
height (maxlevels) of the realtime btrees.  Since we don't want a grow
operation to increase the reservation size enough that we'll fail the
minimum log size checks on the next mount, constrain growfs operations
if they would cause an increase in the rt refcount btree maxlevels.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsops.c   |    2 ++
 fs/xfs/xfs_rtalloc.c |    2 ++
 2 files changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 9df5a09c0acd3b..455298503d0102 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -23,6 +23,7 @@
 #include "xfs_trace.h"
 #include "xfs_rtalloc.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -231,6 +232,7 @@ xfs_growfs_data_private(
 
 		/* Compute new maxlevels for rt btrees. */
 		xfs_rtrmapbt_compute_maxlevels(mp);
+		xfs_rtrefcountbt_compute_maxlevels(mp);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f5a3d5f8c948d8..a5de5405800a22 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -995,6 +995,7 @@ xfs_growfs_rt_bmblock(
 	 */
 	mp->m_features |= XFS_FEAT_REALTIME;
 	xfs_rtrmapbt_compute_maxlevels(mp);
+	xfs_rtrefcountbt_compute_maxlevels(mp);
 
 	kfree(nmp);
 	return 0;
@@ -1178,6 +1179,7 @@ xfs_growfs_check_rtgeom(
 	nmp->m_sb.sb_dblocks = dblocks;
 
 	xfs_rtrmapbt_compute_maxlevels(nmp);
+	xfs_rtrefcountbt_compute_maxlevels(nmp);
 	xfs_trans_resv_calc(nmp, M_RES(nmp));
 
 	/*

