Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDADA1E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192042; cv=none; b=D4CC9ZZJo2hH0h1PvOkj1f55ktXss2mqSZW3X1z2dBOCaylfKpHjx5ak7dcN0Xh5Vzr+kRVUMkYwi2DtZvGCneUnOAk4FqPl3aTh/6ITXBBgyIAaTLieWjN/gciD3DSvRLnAW//GYUd/G377znoNaozf+U3evV7WZVe8XDKyGLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192042; c=relaxed/simple;
	bh=s0uVKmkK5i0apJDWcFNlK01rnDOr92qJw2XELO42MlU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lzEwUEulQmbYrPjR7R/dwMoRBO0Y17bv1t6UDOMA4o34qV3BOjOY9kt6H7KPfh63mpbqpLfNBYJJ0B8P1dglToY5Zu/AjUSRcF8nq5gQSe0bCNhqoPsTBTo2509AYzLk5BHmyNrDfWMWG9s8Gr1YVEhk32IGFqGF7x4fxZ4HFj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OAb8kqXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OAb8kqXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFE5C4CECD;
	Thu, 17 Oct 2024 19:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192042;
	bh=s0uVKmkK5i0apJDWcFNlK01rnDOr92qJw2XELO42MlU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OAb8kqXwGOh9FqrbN40uuqYVuAT68LkfWQhlivPosGOjteWkSR6PXbWcb0wgRs1bI
	 uzf/tO5T3FvhkRVl3iX42KW2r86LsfZYj2IuZDzCgf5HUxmZFwVeQhAdG2VrI6cc4o
	 PCM5eQVCW9rTowH+72OtglXaSqgxmxdJEJQz4oJZbQ31+IAgNNagUm/e9m9G0Zy0s2
	 CNyN+Q5KA88NleHorsCR7rr/rnz0j+NGA+3xDPtrAq51V8nSLcc5YyuMA+VvXTyVwJ
	 ijvlm/mP13y2K65qYtmbnkum0IPT2nEfoubrCVb3LiBfajF6vOzvnX+9OdmAXZBMwX
	 MhKLgiCEJmmng==
Date: Thu, 17 Oct 2024 12:07:22 -0700
Subject: [PATCH 20/34] xfs: don't merge ioends across RTGs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072014.3453179.3130117313373851670.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Unlike AGs, RTGs don't always have metadata in their first blocks, and
thus we don't get automatic protection from merging I/O completions
across RTG boundaries.  Add code to set the IOMAP_F_BOUNDARY flag for
ioends that start at the first block of a RTG so that they never get
merged into the previous ioend.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.h |    9 +++++++++
 fs/xfs/xfs_iomap.c          |   13 ++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 026f34f984b32f..2ddfac9a0182f9 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -188,6 +188,15 @@ xfs_rtb_to_rgbno(
 	return __xfs_rtb_to_rgbno(mp, rtbno);
 }
 
+/* Is rtbno the start of a RT group? */
+static inline bool
+xfs_rtbno_is_group_start(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return (rtbno & mp->m_rgblkmask) == 0;
+}
+
 static inline xfs_daddr_t
 xfs_rtb_to_daddr(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c636481d651e07..fc952fe6269385 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -24,6 +24,7 @@
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
 #include "xfs_quota.h"
+#include "xfs_rtgroup.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
@@ -115,7 +116,9 @@ xfs_bmbt_to_iomap(
 		iomap->addr = IOMAP_NULL_ADDR;
 		iomap->type = IOMAP_DELALLOC;
 	} else {
-		iomap->addr = BBTOB(xfs_fsb_to_db(ip, imap->br_startblock));
+		xfs_daddr_t	daddr = xfs_fsb_to_db(ip, imap->br_startblock);
+
+		iomap->addr = BBTOB(daddr);
 		if (mapping_flags & IOMAP_DAX)
 			iomap->addr += target->bt_dax_part_off;
 
@@ -124,6 +127,14 @@ xfs_bmbt_to_iomap(
 		else
 			iomap->type = IOMAP_MAPPED;
 
+		/*
+		 * Mark iomaps starting at the first sector of a RTG as merge
+		 * boundary so that each I/O completions is contained to a
+		 * single RTG.
+		 */
+		if (XFS_IS_REALTIME_INODE(ip) && xfs_has_rtgroups(mp) &&
+		    xfs_rtbno_is_group_start(mp, imap->br_startblock))
+			iomap->flags |= IOMAP_F_BOUNDARY;
 	}
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);

