Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE19463D0
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505012; cv=none; b=sKOI4J09me/GsoP4JY+RD4uNMNSD6nLnSWMBboIUQNwg/UmARm9ix59OtAEUMz+n9xCGmK5JK9Jx/AznL+19I9skhibqVOIvxUH0tg7xHz7EzPrETcydycGx7Ls3fSS5HydCFRedTI5UJDZRUTxlmQp0toZ4TiYw+3P7zQLfnjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505012; c=relaxed/simple;
	bh=Aqf3yleidtUOcxj1+m8rsJ2eH/DrLvgaOkVPatPMRjA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qNOKAxhaSvuuMQOaX+EmcX9+/RkOnAAZwVr/75fYLu8/UEUvHGG+Z1pbv3DlF/6or0+aBmg23CsSs2xSm6GqI9H8g7+Dh/LFkcR0clHH8euvYLO7Nx/2KdVF11CRXrYrEokykErP/+9Vm6u/34ohNnvGHr6QuhgiRhVrAWZB6o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tlkNF0NQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tlkNF0NQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C22FC433F1;
	Wed, 27 Mar 2024 02:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711505012;
	bh=Aqf3yleidtUOcxj1+m8rsJ2eH/DrLvgaOkVPatPMRjA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tlkNF0NQhLpp8s9mF4MyYdjqf2eemtCKtLdSMd6QlFM8A5tpTLtoR4Lboa04vwyxX
	 fXqfsL9E6/DtCw6p0oI56zUj+TC31XdG1+01fAGf/oaqY2/ur5VfmeGwOQZp6B0R7e
	 nLNSd1QsqwcJpNFGNPOHR/AMtIbq2aBi6Z4EzIm1lOtoTSpAOXphCFfvwaEewLBWTi
	 4vg8ImpRvn1F9hAyrqSwfhnNxsnC6uSglDRoz/UmvRp/LBQi2YzSyOyVxTc7/cRO18
	 X1pRq7bd6/RjYmj82N8uExQZvoCN7Onj8IcXzGftPLsoPFNOr/Ag9d0vpUWVkvNZjj
	 bJPJdsqYLP5Dg==
Date: Tue, 26 Mar 2024 19:03:31 -0700
Subject: [PATCH 2/2] xfs: update the unlinked list when repairing link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150383149.3217890.13491142406378584487.stgit@frogsfrogsfrogs>
In-Reply-To: <171150383111.3217890.14975563638879707412.stgit@frogsfrogsfrogs>
References: <171150383111.3217890.14975563638879707412.stgit@frogsfrogsfrogs>
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

When we're repairing the link counts of a file, we must ensure either
that the file has zero link count and is on the unlinked list; or that
it has nonzero link count and is not on the unlinked list.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/nlinks_repair.c |   42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index b87618322f55b..58cacb8e94c1b 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -17,6 +17,7 @@
 #include "xfs_iwalk.h"
 #include "xfs_ialloc.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
@@ -36,6 +37,20 @@
  * inode is locked.
  */
 
+/* Remove an inode from the unlinked list. */
+STATIC int
+xrep_nlinks_iunlink_remove(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_perag	*pag;
+	int			error;
+
+	pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, sc->ip->i_ino));
+	error = xfs_iunlink_remove(sc->tp, pag, sc->ip);
+	xfs_perag_put(pag);
+	return error;
+}
+
 /*
  * Correct the link count of the given inode.  Because we have to grab locks
  * and resources in a certain order, it's possible that this will be a no-op.
@@ -99,16 +114,25 @@ xrep_nlinks_repair_inode(
 	}
 
 	/*
-	 * We did not find any links to this inode.  If the inode agrees, we
-	 * have nothing further to do.  If not, the inode has a nonzero link
-	 * count and we don't have anywhere to graft the child onto.  Dropping
-	 * a live inode's link count to zero can cause unexpected shutdowns in
-	 * inactivation, so leave it alone.
+	 * If this inode is linked from the directory tree and on the unlinked
+	 * list, remove it from the unlinked list.
 	 */
-	if (total_links == 0) {
-		if (actual_nlink != 0)
-			trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
-		goto out_trans;
+	if (total_links > 0 && xfs_inode_on_unlinked_list(ip)) {
+		error = xrep_nlinks_iunlink_remove(sc);
+		if (error)
+			goto out_trans;
+		dirty = true;
+	}
+
+	/*
+	 * If this inode is not linked from the directory tree yet not on the
+	 * unlinked list, put it on the unlinked list.
+	 */
+	if (total_links == 0 && !xfs_inode_on_unlinked_list(ip)) {
+		error = xfs_iunlink(sc->tp, ip);
+		if (error)
+			goto out_trans;
+		dirty = true;
 	}
 
 	/* Commit the new link count if it changed. */

