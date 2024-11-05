Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5B418E023
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846107; cv=none; b=uKRBrw8ANZyZjxFLFeV+JfF1eSeoA82+qbZwPRKY0Ihj77b4MyEHYzJ9+WHY/gvFWpy+mok09w3DgzWOcsAF9wDRUlOS53L4YsGDG23IlMvkggO54MS3qQexHSyfydN/t0P+sTi4zb1fmLdfimFnWKfkaihKuqcnuMBYAQHSvfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846107; c=relaxed/simple;
	bh=mAcWkr9F+5ZjQr2iMBCu2VK7c5ehyPXNsk65q9o0HL0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QWjpsuleQqH1VraA/iqqi5WX9c3t+plpm/NBQm1TMnPjtKZFpw58Q2I+JTbU3eZr99ZIn7DVc0zRYcesnjVFu8fn8vF4JOsQXZrtCmshMJb0tkjmCEl5+Q68B0JZdBH8ZYjfFyGyFbolVyXCQDqiXHZ4ytPUHUbhhHmR+V86Fh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rUvSMpRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rUvSMpRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2335BC4CECF;
	Tue,  5 Nov 2024 22:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846107;
	bh=mAcWkr9F+5ZjQr2iMBCu2VK7c5ehyPXNsk65q9o0HL0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rUvSMpRCm3cXAjYmnXbieWkBmsENrB/3iXv+AF9SoV8WFt9EbYBzhiDXaWRRcX/js
	 R6G6aRKHxsVV1KeP4wpa/S9zSLobDd6Ob64wTRjgBqMQhnIf0bLwuovuvBznw5BF8k
	 FnSOeVVyElXO1EaFr4dscU3ca0ooOSe9yi2Nceuc0G5RE7u/YE5ROQzY0YB2ue6NSg
	 KrxydQyE92+MN9w9W9ZPI8Uvcl5uRnHYZt6u7XxI7sI+HKWvJU7CABHINxvKqqN0MF
	 MwnjLTWRFGwhRkKYrsE9f/TYv9c0EFhzY4pCVTHveCjv4poxREqAbRSrYOGTsfBIk1
	 wU3/usD8fKItA==
Date: Tue, 05 Nov 2024 14:35:06 -0800
Subject: [PATCH 20/34] xfs: don't merge ioends across RTGs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398526.1871887.9291302908796048091.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
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
index e810e901cd3576..17e5c273e28c45 100644
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

