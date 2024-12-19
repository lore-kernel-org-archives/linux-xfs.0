Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48A0155342
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636610; cv=none; b=IW7itZB75yZQhN9z8VcMMsECfTEvtdCpz3cxM7icDPyPCJek7vL7F6LxTpe84c5pWaUNX2kXJxEtpQaQQczoagt6aT/y3dVRGx27EDOoQVCbGvnOii2w6gI3x9yq6QBbKp4fDxg1eOoJPruD0SY8BRiuwe1BNUnoMrd8iqujR4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636610; c=relaxed/simple;
	bh=U3TBYDb7zmIH7detoXHkxxvmFmSEFG4g0tZQbleAiko=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WJia7yBJzrl9o4HhHATRITTFf5eX0BqB9uKKrnIp6x1mRGgLZDnP860TxUAR1KsZylxC9UqKF7dYgtGylI4X3jet6LG+AvUGCJRgx8VWZYfvvva+tnijpJMCNlMFt6+Vta0A2v34JizACIBJ0Y1MvULQQeadR/YDUlDuhawaviw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U3z3mH2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3z3mH2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DFCC4CED0;
	Thu, 19 Dec 2024 19:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636610;
	bh=U3TBYDb7zmIH7detoXHkxxvmFmSEFG4g0tZQbleAiko=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U3z3mH2NOGejEZfoGMJlT2Tjbywypb2q1DYk5d8xIZ6EixkMSHg4S9j1bguAMH8xT
	 rGyEJYwJUMsT1g7VgISnM+SusF2UDRRpf88U2tPggfF70j2YTFVUAqRqJTbs0mk5Ma
	 Mb2B+/8n8QRoHTgupv+6PWeRSir6lJhbJXeLpzy5zNkshZs7LH4ZfV27f+tCdcSozL
	 dJ9bvUgkCP+vcqrUS0y/9Mnl25/tEpH+TYdKmg5zO25lUfztLfqgXaFaZaNvD9xgWM
	 YPhpBMHgvWFxD2CvxCNBTflFqwrGffaogvPZizguQrqFDkx9MzFFSDy0ccL3jWnbIl
	 AschcZnGMg6qQ==
Date: Thu, 19 Dec 2024 11:30:10 -0800
Subject: [PATCH 26/37] xfs: walk the rt reverse mapping tree when rebuilding
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580203.1571512.5680797684749132629.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're rebuilding the data device rmap, if we encounter an "rmap"
format fork, we have to walk the (realtime) rmap btree inode to build
the appropriate mappings.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rmap_repair.c |   53 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 2a0b9e3d0fbaee..91c17feb49768b 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -31,6 +31,8 @@
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_ag.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtgroup.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -504,7 +506,56 @@ xrep_rmap_scan_meta_btree(
 	struct xrep_rmap_ifork	*rf,
 	struct xfs_inode	*ip)
 {
-	return -EFSCORRUPTED; /* XXX placeholder */
+	struct xfs_scrub	*sc = rf->rr->sc;
+	struct xfs_rtgroup	*rtg = NULL;
+	struct xfs_btree_cur	*cur = NULL;
+	enum xfs_rtg_inodes	type;
+	int			error;
+
+	if (rf->whichfork != XFS_DATA_FORK)
+		return -EFSCORRUPTED;
+
+	switch (ip->i_metatype) {
+	case XFS_METAFILE_RTRMAP:
+		type = XFS_RTGI_RMAP;
+		break;
+	default:
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	while ((rtg = xfs_rtgroup_next(sc->mp, rtg))) {
+		if (ip == rtg->rtg_inodes[type])
+			goto found;
+	}
+
+	/*
+	 * We should never find an rt metadata btree inode that isn't
+	 * associated with an rtgroup yet has ondisk blocks allocated to it.
+	 */
+	if (ip->i_nblocks) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+
+found:
+	switch (ip->i_metatype) {
+	case XFS_METAFILE_RTRMAP:
+		cur = xfs_rtrmapbt_init_cursor(sc->tp, rtg);
+		break;
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+		goto out_rtg;
+	}
+
+	error = xrep_rmap_scan_iroot_btree(rf, cur);
+	xfs_btree_del_cursor(cur, error);
+out_rtg:
+	xfs_rtgroup_rele(rtg);
+	return error;
 }
 
 /* Find all the extents from a given AG in an inode fork. */

