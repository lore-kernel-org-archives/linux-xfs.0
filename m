Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B9ABE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edy8AwB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D534C433C8;
	Sun, 31 Dec 2023 21:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058777;
	bh=2lePDWR8rW4wzB5O3WHR+t/Tdojrh+K+hBtB1OecntQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=edy8AwB077hb31Nuzci9cF6uArSfoC/kvax95hdnPU4cjLIazttroqcthAX/34sjD
	 /m0nFhehfpg4Wab0DvIg28mV5oH75pHhcpVDHKn96FYfeNN5kolLXlY+qYWhZItueD
	 a4h11HlrYThB4UJKAsj+ebS5Pa8yAkSRelBB6W3ngYtBvmUHdbCJvSDcHiaHPTcEt3
	 5BLjVPEJsuSSNUyu0K0ctxb7qSTNTNyaalphjVYPxyqy4nj4TWFoqbtEOj9+Q1fTuF
	 YyWS8zDzYQbKvG27MikzqhXX08zK5ak3hzP01uoks6qL2R4XdvfrX/pBH9Mq3TFaaq
	 rEh3rWb2H6Xbg==
Date: Sun, 31 Dec 2023 13:39:36 -0800
Subject: [PATCH 30/39] xfs: walk the rt reverse mapping tree when rebuilding
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850383.1764998.7674261539966586592.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

When we're rebuilding the data device rmap, if we encounter an "rmap"
format fork, we have to walk the (realtime) rmap btree inode to build
the appropriate mappings.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rmap_repair.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index c6bb90fa43cca..7733334a1faa9 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -30,6 +30,8 @@
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_ag.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtgroup.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -513,6 +515,38 @@ xrep_rmap_scan_iext(
 	return xrep_rmap_stash_accumulated(rf);
 }
 
+static int
+xrep_rmap_scan_rtrmapbt(
+	struct xrep_rmap_ifork	*rf,
+	struct xfs_inode	*ip)
+{
+	struct xfs_scrub	*sc = rf->rr->sc;
+	struct xfs_btree_cur	*cur;
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+	int			error;
+
+	if (rf->whichfork != XFS_DATA_FORK)
+		return -EFSCORRUPTED;
+
+	for_each_rtgroup(sc->mp, rgno, rtg) {
+		if (ip == rtg->rtg_rmapip) {
+			cur = xfs_rtrmapbt_init_cursor(sc->mp, sc->tp, rtg, ip);
+			error = xrep_rmap_scan_iroot_btree(rf, cur);
+			xfs_btree_del_cursor(cur, error);
+			xfs_rtgroup_rele(rtg);
+			return error;
+		}
+	}
+
+	/*
+	 * We shouldn't find an rmap format inode that isn't associated with
+	 * an rtgroup!
+	 */
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
 /* Find all the extents from a given AG in an inode fork. */
 STATIC int
 xrep_rmap_scan_ifork(
@@ -542,6 +576,8 @@ xrep_rmap_scan_ifork(
 		error = xrep_rmap_scan_bmbt(&rf, ip, &mappings_done);
 		if (error || mappings_done)
 			return error;
+	} else if (ifp->if_format == XFS_DINODE_FMT_RMAP) {
+		return xrep_rmap_scan_rtrmapbt(&rf, ip);
 	} else if (ifp->if_format != XFS_DINODE_FMT_EXTENTS) {
 		return 0;
 	}

