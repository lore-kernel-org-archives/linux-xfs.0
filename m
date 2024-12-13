Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE201DDBE
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052200; cv=none; b=TRMY3LpYnKXHnDwm2/6UAl74LD5DtLLthY4+JxbfI/X3b09zOaM7tUJVkYBcnyhLK4EYRjcGNVcmEXVPcWu5PxmTYWBfVwjXnp3fgB3hDDoNDdl7cqsDN3naciDWRp5+g8nBsmGVAhC42Ovrw+f3wmSa3tmYKMmT5MwjvRT4PYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052200; c=relaxed/simple;
	bh=hdPatOOx+QN4Bn3MzKM+luLCc3AZdNPZ9NZOLueRpf0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f3s8uwdREpAOWPiUfbB/94HI1KMmi+Xb6Q/LyIKmWU6bVXFle7EwsL+onoAMs4EF0pO9LHJxwM7FOLBorojJjuDRTxEOOliMURjl3j/BtcK+XWSg0FREVLujmF96OPL50iG+k6255f2nsFo4W54giAX5VLjvYEE+TrO0cWp43OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EcC6JGJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EcC6JGJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3547C4CECE;
	Fri, 13 Dec 2024 01:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052199;
	bh=hdPatOOx+QN4Bn3MzKM+luLCc3AZdNPZ9NZOLueRpf0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EcC6JGJDi3Hq7s7o3EWV5aevqZXClZloZvtGXVQZBAn3S5M7O8CAl08OrrljtzQm3
	 6QL0s8rcINrY4wJdmtZndzLz8JrCNw+ftBJTzCT0v1ke9VbobnNrQ7lNMrNM/XW9TK
	 omuTN2QAe31BPu7mFwFpNv2Xt7tdAIX/3IRLluX0pr2KWpFstgDC8FI6up2u9d794a
	 JcatDBFjc3ZtDpGRM7XuhklmGbOrTYLqzRumTJKj3zmSZ6ZYCX6DlXinf5JvUe6DRh
	 xdB6mZPvWqCrYgwZC7lOZj/qwtQSrrpJmAiGIKJWETEUTDL56yLUmEAKgZJH64YWDt
	 3GRALlbPVbjTQ==
Date: Thu, 12 Dec 2024 17:09:59 -0800
Subject: [PATCH 36/37] xfs: react to fsdax failure notifications on the rt
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123935.1181370.7404101961471776856.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we have reverse mapping for the realtime device, use the
information to kill processes that have mappings to bad pmem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_notify_failure.c |  114 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 108 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index da07d0efc5a2a0..96d39e475d5a86 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -20,6 +20,8 @@
 #include "xfs_trans.h"
 #include "xfs_ag.h"
 #include "xfs_notify_failure.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 #include <linux/mm.h>
 #include <linux/dax.h>
@@ -262,6 +264,109 @@ xfs_dax_notify_ddev_failure(
 	return error;
 }
 
+#ifdef CONFIG_XFS_RT
+static int
+xfs_dax_notify_rtdev_failure(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		daddr,
+	xfs_daddr_t		bblen,
+	int			mf_flags)
+{
+	struct xfs_failure_info	notify = { .mf_flags = mf_flags };
+	struct xfs_trans	*tp = NULL;
+	struct xfs_btree_cur	*cur = NULL;
+	int			error = 0;
+	bool			kernel_frozen = false;
+	xfs_rtblock_t		rtbno = xfs_daddr_to_rtb(mp, daddr);
+	xfs_rtblock_t		end_rtbno = xfs_daddr_to_rtb(mp,
+							     daddr + bblen - 1);
+	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
+	xfs_rgnumber_t		end_rgno = xfs_rtb_to_rgno(mp, end_rtbno);
+	xfs_rgblock_t		start_rgbno = xfs_rtb_to_rgbno(mp, rtbno);
+
+	if (mf_flags & MF_MEM_PRE_REMOVE) {
+		xfs_info(mp, "Device is about to be removed!");
+		/*
+		 * Freeze fs to prevent new mappings from being created.
+		 * - Keep going on if others already hold the kernel forzen.
+		 * - Keep going on if other errors too because this device is
+		 *   starting to fail.
+		 * - If kernel frozen state is hold successfully here, thaw it
+		 *   here as well at the end.
+		 */
+		kernel_frozen = xfs_dax_notify_failure_freeze(mp) == 0;
+	}
+
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		goto out;
+
+	for (; rgno <= end_rgno; rgno++) {
+		struct xfs_rmap_irec	ri_low = {
+			.rm_startblock	= start_rgbno,
+		};
+		struct xfs_rmap_irec	ri_high;
+		struct xfs_rtgroup	*rtg;
+		xfs_rgblock_t		range_rgend;
+
+		rtg = xfs_rtgroup_get(mp, rgno);
+		if (!rtg)
+			break;
+
+		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+		cur = xfs_rtrmapbt_init_cursor(tp, rtg);
+
+		/*
+		 * Set the rmap range from ri_low to ri_high, which represents
+		 * a [start, end] where we looking for the files or metadata.
+		 */
+		memset(&ri_high, 0xFF, sizeof(ri_high));
+		if (rgno == end_rgno)
+			ri_high.rm_startblock = xfs_rtb_to_rgbno(mp, end_rtbno);
+
+		range_rgend = min(rtg->rtg_group.xg_block_count - 1,
+				ri_high.rm_startblock);
+		notify.startblock = ri_low.rm_startblock;
+		notify.blockcount = range_rgend + 1 - ri_low.rm_startblock;
+
+		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
+				xfs_dax_failure_fn, &notify);
+		xfs_btree_del_cursor(cur, error);
+		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
+		xfs_rtgroup_put(rtg);
+		if (error)
+			break;
+
+		start_rgbno = 0;
+	}
+
+	xfs_trans_cancel(tp);
+
+	/*
+	 * Shutdown fs from a force umount in pre-remove case which won't fail,
+	 * so errors can be ignored.  Otherwise, shutdown the filesystem with
+	 * CORRUPT flag if error occured or notify.want_shutdown was set during
+	 * RMAP querying.
+	 */
+	if (mf_flags & MF_MEM_PRE_REMOVE)
+		xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
+	else if (error || notify.want_shutdown) {
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_ONDISK);
+		if (!error)
+			error = -EFSCORRUPTED;
+	}
+
+out:
+	/* Thaw the fs if it has been frozen before. */
+	if (mf_flags & MF_MEM_PRE_REMOVE)
+		xfs_dax_notify_failure_thaw(mp, kernel_frozen);
+
+	return error;
+}
+#else
+# define xfs_dax_notify_rtdev_failure(...)	(-ENOSYS)
+#endif
+
 static int
 xfs_dax_translate_range(
 	struct xfs_mount	*mp,
@@ -341,12 +446,6 @@ xfs_dax_notify_failure(
 	if (error)
 		return error;
 
-	if (fdev == XFS_FAILED_RTDEV) {
-		xfs_debug(mp,
-			 "notify_failure() not supported on realtime device!");
-		return -EOPNOTSUPP;
-	}
-
 	if (fdev == XFS_FAILED_LOGDEV) {
 		/*
 		 * In the pre-remove case the failure notification is attempting
@@ -366,6 +465,9 @@ xfs_dax_notify_failure(
 		return -EOPNOTSUPP;
 	}
 
+	if (fdev == XFS_FAILED_RTDEV)
+		return xfs_dax_notify_rtdev_failure(mp, daddr, bbcount,
+				mf_flags);
 	return xfs_dax_notify_ddev_failure(mp, daddr, bbcount, mf_flags);
 }
 

