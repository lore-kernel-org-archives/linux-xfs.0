Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32072D53F
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608814; cv=none; b=VThBsb43k6w6B6JAutbtgVNxU9MPs4u+foOkpk4z+6gH8GlLZma5dVF1CSw8UcpeiF3g9wlHv7LS8qQm0bryb7fc/4sdPhkH9lhtO6EjYqDMm+p0cZoxXlskGluxS1maZ/ePLSl25wXVKH7Oj9DUasxcnrfRSdl6ySakyz5XohE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608814; c=relaxed/simple;
	bh=pai2DbsHGdsnN1+S+vpLWPMcpHkkcuIIGtxbUVUkqeE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m1xD4FIhTrgEK43awkYD5JLIZ9sMtqamveVNIiqwzvgLnTHKrVxMGzlZVp6gwjBn8fdLq1yMl+IdKH9PkPS5hB5KS5uJ/uoG06lN5XH0rlGIwEUTV1DoULNO6eWshkypE1z0C6bIth8hUdvAmEvAJ981NI2QWS2vkptsgqdi6Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cR4hAjCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cR4hAjCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9D9C4CEC5;
	Fri, 11 Oct 2024 01:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608814;
	bh=pai2DbsHGdsnN1+S+vpLWPMcpHkkcuIIGtxbUVUkqeE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cR4hAjCNCOrkeaniof1rJl/d8/qQd1jO9LufhrqAHrr/nlr2Zg8rRucG4gAQ3zQVA
	 7R3zYwgTWdTAKOp7BeymFkRmbETbIejVBqB41RWz6Y1mA/B6dOQjDdvLlpzT9rZpE8
	 Rs2rkB94h+3iODZuVQyl3GztXDfqEjmlgI+YxawSt52+JGy6rfQ+DCI6Rwi3wG8eh9
	 HlFHi6Dzip+gPqYpOAJLB0gv0ihTXQ9KwOnB1DzsUuHso8cxWWhGdDN9v29PG/SQkx
	 pO9kiCbmB2KImsR6iio1PQm9ZJpJeZD6nD24IVnuMDNQKum5ZVvWCtQnWfNJhGLZGf
	 E8/0CC2phldDA==
Date: Thu, 10 Oct 2024 18:06:53 -0700
Subject: [PATCH 20/36] xfs: don't merge ioends across RTGs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644586.4178701.16368079741621297850.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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
index c636481d651e07..ed35191c174f65 100644
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
 
@@ -124,6 +127,15 @@ xfs_bmbt_to_iomap(
 		else
 			iomap->type = IOMAP_MAPPED;
 
+		/*
+		 * Mark iomaps starting at the first sector of a RTG as merge
+		 * boundary so that each I/O completions is contained to a
+		 * single RTG.
+		 */
+		if (XFS_IS_REALTIME_INODE(ip) && xfs_has_rtgroups(mp) &&
+		    xfs_rtb_to_rtx(mp, imap->br_startblock) == 0 &&
+		    xfs_rtb_to_rtxoff(mp, imap->br_startblock) == 0)
+			iomap->flags |= IOMAP_F_BOUNDARY;
 	}
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);

