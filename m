Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF783A1B5
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052622; cv=none; b=bGc5totqek6wBVZGhtITVeB7kDHo2RHQPmS/LRPqWmJpEnRsszVQuM6EC9riy1iMFrOUDVH78ozFcj1ngYMlIqS7i3vJW1japrhCMoFhX8rCiFIj1AEM26uu+PnQKuKXQi+R4AaWilC0YHLwtR2q0oQYTzgYqeltsbsy+OFs7Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052622; c=relaxed/simple;
	bh=3ZTAo1ki6o5RKnLe1vGXDJRSvABMH5HcmRQIQ2yh27w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QWoABQTdyXCgvTP8mHKcLL8tgnwBEdwS6C18HnUMrJyr6xWmlcPDn9gT081J3SndB6V9psgpppIN/gZVmMgYQ7eaHZKNWKX4EOB+92BnLN7bcHOwh8oZMe+1zgPVhLlPO2O3FQ09DASHDo/pckGzfBHRblaGViWcmIhIAgDFljw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=up+qO6w7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="up+qO6w7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8CEC4CECE;
	Fri, 13 Dec 2024 01:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052621;
	bh=3ZTAo1ki6o5RKnLe1vGXDJRSvABMH5HcmRQIQ2yh27w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=up+qO6w76PjSR+ZdymqVbZx29KPm77oIP5hC0L751Pf4ocg8CYUVAWu61QVuHIrM+
	 hnNiWHX5q7Pf/yaxAbfaGsZkpLtDOIpLb2iGRKT0d6IcXTH+UfvdHpYP6LJJQ86AFy
	 9jMKmkjO6Ajvg3M4xHmHWXn0w5UlKOej+FVt1eIKuKWa3x+RJi45LsllmkqSUwnqly
	 fb6U4r13SOFk3mcfrYOQeqKSFZjW+UI3jdJMttmUnnfxS6INCwsn7zZCepeJCNdkdL
	 /y+YbBOxpnFw1wJdVlLYFj2GkShhsZkXZeiWdWirQ/YCfR3uy3+0F/JheYn/VxA3UJ
	 +1IHydQpKu21g==
Date: Thu, 12 Dec 2024 17:17:01 -0800
Subject: [PATCH 26/43] xfs: check that the rtrefcount maxlevels doesn't
 increase when growing fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125012.1182620.2980242584015172989.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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

