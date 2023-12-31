Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE5CDF55
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7Iij1HQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0808BC433C9;
	Sun, 31 Dec 2023 21:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059669;
	bh=gAL6YZhhGcnrZFs+LduFyWW5xTPuE+KaZqVjk9XpD7o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q7Iij1HQcIqj1MTU1F2rBQS3wVV+bkL1gh2Vw0uFqhP56EjUq5UI8qpRhBrtNrN83
	 BP8AlgARvZXvJtqIep3KjcxfhbOqCiso6M2MFOVkA1J2Y6pDzIrEFwj/XPLqvNunxi
	 SorNfPcxn8KYYc+tfwfUdAXcOe5R9/nTxFY4io8jzLOM4rmu4DhTpIW+u1mS5gsH6c
	 MZTCDAMsgARDjDDC6yw/NuIsvR/NCNP9e10UB+wE4xWx84BVxdMas22cn1UgJAzSDr
	 xIwkH+I115acomdw3yWd7LNFN/WImwvP3nt0Gsk5QaCbP3tYFHJW9enOY3OoyB3rcw
	 iP/Q5mC73pJlQ==
Date: Sun, 31 Dec 2023 13:54:28 -0800
Subject: [PATCH 38/44] xfs: walk the rt reference count tree when rebuilding
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852191.1766284.17012719067221063791.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

When we're rebuilding the data device rmap, if we encounter a "refcount"
format fork, we have to walk the (realtime) refcount btree inode to
build the appropriate mappings.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rmap_repair.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 7733334a1faa9..0f3783aaaa997 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -32,6 +32,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -547,6 +548,39 @@ xrep_rmap_scan_rtrmapbt(
 	return -EFSCORRUPTED;
 }
 
+static int
+xrep_rmap_scan_rtrefcountbt(
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
+		if (ip == rtg->rtg_refcountip) {
+			cur = xfs_rtrefcountbt_init_cursor(sc->mp, sc->tp, rtg,
+					ip);
+			error = xrep_rmap_scan_iroot_btree(rf, cur);
+			xfs_btree_del_cursor(cur, error);
+			xfs_rtgroup_rele(rtg);
+			return error;
+		}
+	}
+
+	/*
+	 * We shouldn't find a refcount format inode that isn't associated with
+	 * an rtgroup!
+	 */
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
 /* Find all the extents from a given AG in an inode fork. */
 STATIC int
 xrep_rmap_scan_ifork(
@@ -578,6 +612,8 @@ xrep_rmap_scan_ifork(
 			return error;
 	} else if (ifp->if_format == XFS_DINODE_FMT_RMAP) {
 		return xrep_rmap_scan_rtrmapbt(&rf, ip);
+	} else if (ifp->if_format == XFS_DINODE_FMT_REFCOUNT) {
+		return xrep_rmap_scan_rtrefcountbt(&rf, ip);
 	} else if (ifp->if_format != XFS_DINODE_FMT_EXTENTS) {
 		return 0;
 	}

