Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2B117727
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709001047; cv=none; b=oZ/6ghOV3X+S2d0YyfcGwO7H2pTLOw8Emrld7tsRkftbkdhdqLS5uO2IYRIEc74tBt1ZKNgNyfiIHcUUltfj39CSUu4JKeMMa3qljJyI8n8BRR8cwDr3G+jG6bN1r8xU3Zkb4dz3U0heVgPlE9RTP3w0VaBjFdCE/tXSOIj1hEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709001047; c=relaxed/simple;
	bh=6l21+z4oedzftV9fHn1VyvBemGHR36cgIkBvDUt5nJQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PPOYYl0Qnq/55IwlcroYgkUzTr7pcp+OshpLTh3hLE7nksz22Am70HwYlBIX4/toh1bZF2SoCvvm7vXlitIIr709rTCVby44TtnArIpmVlP7TChu0o4z+X+Jg8lMzDhA3fYUUVPcMm7NjneTuUAgQ51C2gAKQEqgruAEjzun+ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X4ZMbNbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X4ZMbNbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8895AC433F1;
	Tue, 27 Feb 2024 02:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709001046;
	bh=6l21+z4oedzftV9fHn1VyvBemGHR36cgIkBvDUt5nJQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X4ZMbNbS4knOx8/0lUK1loF12vMD3HDXLjQh/k7gyy/j0FKfXdcpUsZLtTOeC0hp6
	 UukpTtFN6i7GUKevi19tT1ZKa1g4ipux/9vVW2wacP2jh8fEKzZFrafbd3GjCz5jm5
	 qZeLce8iBxoM2PAaYU8MNMbVUQcQ9dlBm4a51JrlqAhkovhEsT06QKt4LvUkGgGaJ9
	 +iydlp9wfp6qtwLUYhQqg7Wk5Wv/EsSAHnDq6rd0kfU6WsVAhDzV82w0SifFknuXAg
	 Bb54Nvb6ZGz8XN0aDkNs7PtU0332oNRNdx7hQVNWZXf1bLB4P6ynteXNsEuLiP2OKc
	 or75wuOiOS0tw==
Date: Mon, 26 Feb 2024 18:30:46 -0800
Subject: [PATCH 2/2] xfs: update the unlinked list when repairing link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900014093.939412.14688993267476099238.stgit@frogsfrogsfrogs>
In-Reply-To: <170900014056.939412.3163260522615205535.stgit@frogsfrogsfrogs>
References: <170900014056.939412.3163260522615205535.stgit@frogsfrogsfrogs>
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

