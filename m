Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1ACC4A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608313; cv=none; b=lFFYdwhkZYqUCLjffiSMSq2mU8etFf+vLQP9FGbSTjDKfsYgXjsJ7HBhLWiReSM8PqrgvFdN2AxI3qiGcwkj8Tid1YU05X2QpTDI7A7Y4kWaLV1aq+TyxFhRcbzjpXVJsILusDqykyaVG3gMjaEw0xyGv09Q0+yHACqhzY5tjtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608313; c=relaxed/simple;
	bh=kRMM/EcvdKsBrJ02b0GR1cA3waeclGJ45kB2W9RpQJw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SMNlq6tx6Vk5x1Ko6055/KT1fB9vYT4imgY1uaPRXsTCJ51djVJnalURpxDcPPfGJJ8SWM3287s0AieEl+hfku9DdlcmPsjXSsrtPlBXcCNJxZs+S4vvLrTvJz6LqT5SyJw9nRqPUJc1kXqmY109vIzWvlkEc5wynQY5M8pTecY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C01cjcWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C01cjcWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F90EC4CEC5;
	Fri, 11 Oct 2024 00:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608313;
	bh=kRMM/EcvdKsBrJ02b0GR1cA3waeclGJ45kB2W9RpQJw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C01cjcWV9N6PadBjWIplcM/Lxwfd2beYyIc5gLShmoHIlZWzedcBgMxlxgr0yZcvh
	 qCWqPEU7DC7C66WUFgoxb/YFbPl3Ra857WGMOMsDGF1VZDdaoueRq2nlWM3Vah8tid
	 ivnYwK4YccQveyee0A9r+thDsqZW4lv51DnXM+inX561dGUawZq4JUGGwcSb/TMZGO
	 8gEtB85QcRZgAekaKVTuymZvccmOwyaGh9CmrKWChddYjO8fIV4TxpxBFkqGpkfZ2v
	 NSYYpnIujUl8vCyGptPMjTq7azFDTjFtqZPquv59MgvxOGYl0WmU5nIsZSaxG/dIz7
	 59sdjNbFb5j7Q==
Date: Thu, 10 Oct 2024 17:58:33 -0700
Subject: [PATCH 11/21] xfs: split xfs_trim_rtdev_extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860643136.4177836.14472609373292333564.stgit@frogsfrogsfrogs>
In-Reply-To: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
References: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Split xfs_trim_rtdev_extents into two parts to prepare for reusing the
main validation also for RT group aware file systems.

Use the fully features xfs_daddr_to_rtb helper to convert from a daddr
to a xfs_rtblock_t to prepare for segmented addressing in RT groups.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_discard.c |   57 ++++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 9c6d3b136826cc..ca19d57b78e693 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -21,6 +21,7 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Notes on an efficient, low latency fstrim algorithm
@@ -548,44 +549,23 @@ xfs_trim_gather_rtextent(
 }
 
 static int
-xfs_trim_rtdev_extents(
+xfs_trim_rtextents(
 	struct xfs_mount	*mp,
-	xfs_daddr_t		start,
-	xfs_daddr_t		end,
+	xfs_rtxnum_t		low,
+	xfs_rtxnum_t		high,
 	xfs_daddr_t		minlen)
 {
 	struct xfs_trim_rtdev	tr = {
 		.minlen_fsb	= XFS_BB_TO_FSB(mp, minlen),
+		.extent_list	= LIST_HEAD_INIT(tr.extent_list),
 	};
-	xfs_rtxnum_t		low, high;
 	struct xfs_trans	*tp;
-	xfs_daddr_t		rtdev_daddr;
 	int			error;
 
-	INIT_LIST_HEAD(&tr.extent_list);
-
-	/* Shift the start and end downwards to match the rt device. */
-	rtdev_daddr = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
-	if (start > rtdev_daddr)
-		start -= rtdev_daddr;
-	else
-		start = 0;
-
-	if (end <= rtdev_daddr)
-		return 0;
-	end -= rtdev_daddr;
-
 	error = xfs_trans_alloc_empty(mp, &tp);
 	if (error)
 		return error;
 
-	end = min_t(xfs_daddr_t, end,
-			XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks) - 1);
-
-	/* Convert the rt blocks to rt extents */
-	low = xfs_rtb_to_rtxup(mp, XFS_BB_TO_FSB(mp, start));
-	high = xfs_rtb_to_rtx(mp, XFS_BB_TO_FSBT(mp, end));
-
 	/*
 	 * Walk the free ranges between low and high.  The query_range function
 	 * trims the extents returned.
@@ -620,6 +600,33 @@ xfs_trim_rtdev_extents(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+static int
+xfs_trim_rtdev_extents(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		start,
+	xfs_daddr_t		end,
+	xfs_daddr_t		minlen)
+{
+	xfs_rtblock_t		start_rtbno, end_rtbno;
+	xfs_rtxnum_t		start_rtx, end_rtx;
+
+	/* Shift the start and end downwards to match the rt device. */
+	start_rtbno = xfs_daddr_to_rtb(mp, start);
+	if (start_rtbno > mp->m_sb.sb_dblocks)
+		start_rtbno -= mp->m_sb.sb_dblocks;
+	else
+		start_rtbno = 0;
+	start_rtx = xfs_rtb_to_rtx(mp, start_rtbno);
+
+	end_rtbno = xfs_daddr_to_rtb(mp, end);
+	if (end_rtbno <= mp->m_sb.sb_dblocks)
+		return 0;
+	end_rtbno -= mp->m_sb.sb_dblocks;
+	end_rtx = xfs_rtb_to_rtx(mp, end_rtbno + mp->m_sb.sb_rextsize - 1);
+
+	return xfs_trim_rtextents(mp, start_rtx, end_rtx, minlen);
+}
 #else
 # define xfs_trim_rtdev_extents(...)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */

