Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C521CBE47
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372783; cv=none; b=cp7m2pxTw9ZnvqYKV5u/Bo9yHZFIftO4L+pQ5HFgdy2IM2iIXhy3jEq8zBDf+qTFKo8Jz99JaH9H2MbtXveCAJwAwsEPzaM9qWyQeWFMOBzKwLHeG4EA9BH6+xjABWqjsY+Y8/0gVVQq/9DXzkGSfEsrvQxlbIa/U1VXWOxuOKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372783; c=relaxed/simple;
	bh=/d1y6f4n3bdknVSJSlblm6U8yHUgQcoY4nAeTo8MENU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XHTfOS58ikRyxmr/pmlMr7+DkVZH0u0P8xP8xvkZAYm5PyMZAzf7jHDcTlBaj87dKP5tKPHbpp9P8awPHIC0VGkc3vAnlMJ58i3rOZfGRH/FQGl9ckeFx3WmOEEc3FS1tD4Um2GHsm2xITo0Ucl/iEVZEQEcERN0WASOM904T8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e3drdkas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e3drdkas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93318C32782;
	Fri, 23 Aug 2024 00:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372783;
	bh=/d1y6f4n3bdknVSJSlblm6U8yHUgQcoY4nAeTo8MENU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e3drdkasMxDKoxa0SbyYPKjKE4Nlyz9tFuGIsrdW2UNLnZJAQn+WI5/ayPbDFY1/3
	 yS+wJ+fITxvS1uePXr4nugvZRV4rBBXohon7pZOxmsTyrBKB68JiH7BFLIZ3p/TT1m
	 jHY+S6QiE1riNJ+/oOxWdJz1TrGKFDIcWpr0NcJC4ULv59XB9eagO0uKD3P8EntRMA
	 IrcsbPgwF+jXrms07TLgRS7D4zIWvNLn13S3B4PzP6z5ZXSWlx9fHtFd4noIVt3rrH
	 Ap8fi2ae+NsnqBTbHt/mdsFJETcc6ODt7vQCpnAiWX6l7oy4Ty03KqEB9K65eqS3YD
	 /uDHVYoqtEBZw==
Date: Thu, 22 Aug 2024 17:26:23 -0700
Subject: [PATCH 20/26] xfs: don't merge ioends across RTGs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088869.60592.1406516687324740088.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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

Unlike AGs, RTGs don't always have metadata in their first blocks, and
thus we don't get automatic protection from merging I/O completions
across RTG boundaries.  Add code to set the IOMAP_F_BOUNDARY flag for
ioends that start at the first block of a RTG so that they never get
merged into the previous ioend.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 13cabd345e227..607d360c4a911 100644
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
+		xfs_daddr_t	bno = xfs_fsb_to_db(ip, imap->br_startblock);
+
+		iomap->addr = BBTOB(bno);
 		if (mapping_flags & IOMAP_DAX)
 			iomap->addr += target->bt_dax_part_off;
 
@@ -124,6 +127,15 @@ xfs_bmbt_to_iomap(
 		else
 			iomap->type = IOMAP_MAPPED;
 
+		/*
+		 * Mark iomaps starting at the first sector of a RTG as merge
+		 * boundary so that each I/O completions is contained to a
+		 * single RTG.
+		 */
+		if (XFS_IS_REALTIME_INODE(ip) && xfs_has_rtgroups(mp) &&
+		    xfs_rtb_to_rtx(mp, bno) == 0 &&
+		    xfs_rtb_to_rtxoff(mp, bno) == 0)
+			iomap->flags |= IOMAP_F_BOUNDARY;
 	}
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);

