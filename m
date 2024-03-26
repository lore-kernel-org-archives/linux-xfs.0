Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDDE1D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424065; cv=none; b=odV56bR7MCPdMDmNpWm2OljL+lD/cJitsrwcbLLghGv0yaq9oTMgxspuNMlYVqCB4im2l0in8AlrmKm0ii52MmildSEruW2LBTq2Ocs4b95aEsvi76QG8BgzJ57ElR6TBad0zEAlqgbao9KhNeNu/JRa4bI/uAr1Xb3sNj6Dt04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424065; c=relaxed/simple;
	bh=6ELAFsQ4p7ytpafEOJuIoOB2AqKf/ue8Sb9oSsArLF4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mlPLHASwkLLIOOKBPkzUxenv2on14W8BzylH3U3pSzP8mBYQqgthjoqxAe64D11d/2NGxRDHyC0HJb2iaFCsu2bByCX8q84bNaeBlYP3tJvLcAgpgHAqEy9lrggmAFmTXmYbKnP5J6Z4Itk5FMM07Lm4d3gr3eQlVXK3ToFiknY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KPdgZ3gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KPdgZ3gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6118C433F1;
	Tue, 26 Mar 2024 03:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424065;
	bh=6ELAFsQ4p7ytpafEOJuIoOB2AqKf/ue8Sb9oSsArLF4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KPdgZ3ggPmXI82MogsgUGeKIvZiHQRh5yyRfUuRFBrPI0eUSYW/dKT6FKnnZ4zehH
	 32mcaqo9OtFz3f7PiBSDBxjhLFcF0IyCXl3B8JUVRpT27a+KhqFq6z3MlNqKHr7M+1
	 /zhmAaOSPLriQMI7eNPCEGWbmHOtVwW1BXDcgCubMB7HfOXc9sTRiigsznf1VKetrw
	 pw5RpeJR3ouNHWZ3+V0YmX9e/6FJPWeuFhK7dCc2DyxxznPsJYNz4rkefvDMbu58F9
	 LQI2QRToqZraNfWAUoqYWBuosYye1kkCQlG4enfGHWFe+zHRw6bG3BRyS4TZhq9gFf
	 bm8g7Vch6itTg==
Date: Mon, 25 Mar 2024 20:34:24 -0700
Subject: [PATCH 023/110] xfs: report realtime metadata corruption errors to
 the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131716.2215168.1476532365524284298.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 8368ad49aaf771a6283840140149440b958b20fb

Whenever we encounter corrupt realtime metadat blocks, we should report
that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/util.c         |    1 +
 libxfs/xfs_rtbitmap.c |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 6d8847363433..841f4b963f18 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -737,3 +737,4 @@ void xfs_btree_mark_sick(struct xfs_btree_cur *cur) { }
 void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_da_mark_sick(struct xfs_da_args *args) { }
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
+void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 146e06bd880a..543cfd2fb9c5 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -15,6 +15,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_health.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -113,13 +114,19 @@ xfs_rtbuf_get(
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
 

