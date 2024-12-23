Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE49338385
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991235; cv=none; b=EGv9lDTPeJdlrmY/ageBguqDGbmX/078p13sB3Feck/nbh2mm51FsdhcFgVHn0InuCUzfl4zFVxH8+WUxzLseAsoPkYjFZVJorsY7RIeS1J97huSvDy9lTpmLviYB6aQQgXUWNOPEU8Fbg8ZAIZ7Ix0DSo/qzycX3wnP9FZ2ZqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991235; c=relaxed/simple;
	bh=UMTYPB7njngblzsbvVNV9NNSzx678qXGN+tZaaj8SEk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SW+66cksiWdIofFFXatd2ysplEGDh5tv/cAYcDWkteo84qAdqAEwCCqkLGj2vKJYysbX/H7cOBVVbpTzWHen3o42XkWzlHbbyXjmlRdYf0zU+bqDuna8ljlDwmLa6xGJ4Wcla3mcrpf//oXNeBE5O6vVCqcushB7W9vp8WzoJz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RmPvL3rQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmPvL3rQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62474C4CED3;
	Mon, 23 Dec 2024 22:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991234;
	bh=UMTYPB7njngblzsbvVNV9NNSzx678qXGN+tZaaj8SEk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RmPvL3rQG5ANFjr3+mMe9o0FFmEZrC2unW2TxGsKHw6Cuyxdy+Zs2q/RDo8YlQVt8
	 CcgvZma/ULCMy4UXUKgBQwt0XONN8dJHGHfKVbwZO0UXctuMBPf5isdeAM/+zyOp75
	 83aq5rdajeO17v3q6epBWKRn2kylrgnC9Nic82Cm32dq/9KPwnc3JOOpcVS817GODY
	 hkk55jt7E46hComm35GbTvIyWaNOJQc8huxPrnkjq51SURq+0g45Oo1/mcNUmvlqXn
	 WSKGemdKt8WjrI/6C2+H9N9wKczBZ4d3Df6JfP/xINxPYIoumv2IGkvtwJO7R7Bd94
	 Nr2x3VubwYpJw==
Date: Mon, 23 Dec 2024 14:00:33 -0800
Subject: [PATCH 09/52] xfs: refactor xfs_rtsummary_blockcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942632.2295836.6022715242317451759.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f8c5a8415f6e23fa5b6301635d8b451627efae1c

Make xfs_rtsummary_blockcount take all the required information from
the mount structure and return the number of summary levels from it
as well.  This cleans up many of the callers and prepares for making the
rtsummary files per-rtgroup where they need to look at different value.

This means we recalculate some values in some callers, but as all these
calculations are outside the fast path and cheap, which seems like a
price worth paying.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c         |    4 +---
 libxfs/xfs_rtbitmap.c |   13 +++++++++----
 libxfs/xfs_rtbitmap.h |    3 +--
 3 files changed, 11 insertions(+), 9 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 5ec01537faac6b..a037012b77e5f6 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -323,9 +323,7 @@ rtmount_init(
 			progname);
 		return -1;
 	}
-	mp->m_rsumlevels = mp->m_sb.sb_rextslog + 1;
-	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, mp->m_rsumlevels,
-			mp->m_sb.sb_rbmblocks);
+	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, &mp->m_rsumlevels);
 
 	/*
 	 * Allow debugger to be run without the realtime device present.
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index cebeef5134e666..edcfb09e29fa18 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
+#include "xfs_sb.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -1164,16 +1165,20 @@ xfs_rtbitmap_blockcount(
 	return xfs_rtbitmap_blockcount_len(mp, mp->m_sb.sb_rextents);
 }
 
-/* Compute the number of rtsummary blocks needed to track the given rt space. */
+/*
+ * Compute the geometry of the rtsummary file needed to track the given rt
+ * space.
+ */
 xfs_filblks_t
 xfs_rtsummary_blockcount(
 	struct xfs_mount	*mp,
-	unsigned int		rsumlevels,
-	xfs_extlen_t		rbmblocks)
+	unsigned int		*rsumlevels)
 {
 	unsigned long long	rsumwords;
 
-	rsumwords = (unsigned long long)rsumlevels * rbmblocks;
+	*rsumlevels = xfs_compute_rextslog(mp->m_sb.sb_rextents) + 1;
+
+	rsumwords = xfs_rtbitmap_blockcount(mp) * (*rsumlevels);
 	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
 }
 
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 58672863053a94..776cca9e41bf05 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -311,7 +311,7 @@ xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp);
 xfs_filblks_t xfs_rtbitmap_blockcount_len(struct xfs_mount *mp,
 		xfs_rtbxlen_t rtextents);
 xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
-		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
+		unsigned int *rsumlevels);
 
 int xfs_rtfile_initialize_blocks(struct xfs_rtgroup *rtg,
 		enum xfs_rtg_inodes type, xfs_fileoff_t offset_fsb,
@@ -342,7 +342,6 @@ xfs_rtbitmap_blockcount_len(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 	/* shut up gcc */
 	return 0;
 }
-# define xfs_rtsummary_blockcount(mp, l, b)		(0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */

