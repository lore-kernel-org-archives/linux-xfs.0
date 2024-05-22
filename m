Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F7A1DFD0
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346486; cv=none; b=dYx8b9jgWn/44VI6+JcTbvG5Q6+IHoHVshXN+iAe+LyIaiBk5RMDAuS5ecM29vAt1lRflAzUbGrbYPboRAZnROGp04eutGZ0hCiI4Z5hhrfTnSnZPk9rNnZKcy1mapdQLq/WkFg6t1g+qbMo147wPn11zMIiNR94bx5TAyBkxwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346486; c=relaxed/simple;
	bh=JPjjne+x9SDKcX63038xSq5M4CeK3QyPxXRmCF0T1kk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mQBtBVygRt8QqrLjEkmmTDoaOBputpkdbooVCmky8vOO/LNTCuhYPL9VsvSg3UeFZEPUPuhiXSxf6XXRR7c+fMjl2GJ6P+S3fx9OGAswCXy/qr8Q9i1fzii6pI34e6cyPL1+6sTfbBJQ7tb6wCtQvTd8j/tYc2e3SOsPErr0lrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ka2/4fBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ka2/4fBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5A1C2BD11;
	Wed, 22 May 2024 02:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346486;
	bh=JPjjne+x9SDKcX63038xSq5M4CeK3QyPxXRmCF0T1kk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ka2/4fBarbbt85oUZEZ17SEs1Ld0He7rqTYjHRewi3uKRddcog0krvOOibDT/qdTJ
	 hNUi61YXBOebO/8VIQrSJ4r6J67GGge0ksvzcDbZ4oAj3N7Qs4vGyTi61IzRmPhknl
	 +Q+mPe5gn34p51YNB6x85KI5FbZxLknY2OMdlDm1GJS988jqBteNL5sde1CgzuQ0x5
	 1svNQch+LuxyL2n9j1dkubSTWlsLe0flij74rR/RcPGC222uPV2nAan+fTBLqWWLMZ
	 qj3mcgD+qBjTO4XAkU8ygI62ovJ6Fl13QUaUua7vMXfOBXCUsQxboxtyJMs3X+Q5hS
	 1ZV5CYtCrxlcw==
Date: Tue, 21 May 2024 19:54:45 -0700
Subject: [PATCH 023/111] xfs: report realtime metadata corruption errors to
 the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532056.2478931.2673364905465317697.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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
index 6d8847363..841f4b963 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -737,3 +737,4 @@ void xfs_btree_mark_sick(struct xfs_btree_cur *cur) { }
 void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_da_mark_sick(struct xfs_da_args *args) { }
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
+void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 146e06bd8..543cfd2fb 100644
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
 

