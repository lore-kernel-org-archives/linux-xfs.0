Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23858376F4
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591026; cv=none; b=SbD1u2bG84sbPedbg5Fz//P/RfwSMTjg4KZ69wRfc8ufaWwLAVWgRYoGPyi8LpylgLACXd58RCiUVpIQcnCkWqkiQ/FfC3+0tmoHQgc2xPX9KZictOf7Xnf5RLYpeP8rzmLF188S5/j9rGmgIaXiMGzUtOmZe+J/LzCzxz0e4zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591026; c=relaxed/simple;
	bh=C2tvsrFuEfKiNqjY257KOG3uFFUTCXFTtGHrBLF9qlY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U92P1guGMFqeQJTtQBuJsWEt9C1MSzbqwloLw3FE/BzO+PIN1K7E0G4MJ0lJD1B4oxzf5k+sVGAJ+W2hc7cnmsvyHsmu4b3m24lgR7VsUPlkz1nwB/mEA9GJ4UAOODMi9LJdQOP3jcgLI/MEE8oBduVNjDOnSO1I9ZI1ROZsnZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vARLZFli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vARLZFli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E51C433F1;
	Tue, 30 Jan 2024 05:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591025;
	bh=C2tvsrFuEfKiNqjY257KOG3uFFUTCXFTtGHrBLF9qlY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vARLZFliQL3FLpPBjCQiW8ozE0hnDBFezXCWAyhkOws7iUEeZjR1OFFIe9QzKOt9/
	 OhSbsGsqeaB7oROJz+BgsgApLrufCmi548LsrT6HNM0oxqlqfphMX6TKX4MLBaTQKn
	 al38v6GoHkgmuFuA9xPDLlLQ3f/3k6YMWV+wu8UPAPUvQJ5uCRYOt3W5D4WWKy0gSU
	 6PpPkKlC1Q7ujTpWPewW+UwgK80ouqCWpBRGds12IFHQgJm0B7gqwqCgTFaGlYHKyf
	 JgdvmNwTTjeAE1UwhFN0/02q5ZJckHi+FdADyLOrzojCb1m+MF2m9Y2YiPcioYuP4v
	 BnBcFAyhVLhxw==
Date: Mon, 29 Jan 2024 21:03:45 -0800
Subject: [PATCH 1/6] xfs: speed up xfs_iwalk_adjust_start a little bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659061854.3353019.8514932032106677042.stgit@frogsfrogsfrogs>
In-Reply-To: <170659061824.3353019.15854398821862048839.stgit@frogsfrogsfrogs>
References: <170659061824.3353019.15854398821862048839.stgit@frogsfrogsfrogs>
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

Replace the open-coded loop that recomputes freecount with a single call
to a bit weight function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iwalk.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index b3275e8d47b60..4ce85423ef3e0 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -22,6 +22,7 @@
 #include "xfs_trans.h"
 #include "xfs_pwork.h"
 #include "xfs_ag.h"
+#include "xfs_bit.h"
 
 /*
  * Walking Inodes in the Filesystem
@@ -131,21 +132,11 @@ xfs_iwalk_adjust_start(
 	struct xfs_inobt_rec_incore	*irec)	/* btree record */
 {
 	int				idx;	/* index into inode chunk */
-	int				i;
 
 	idx = agino - irec->ir_startino;
 
-	/*
-	 * We got a right chunk with some left inodes allocated at it.  Grab
-	 * the chunk record.  Mark all the uninteresting inodes free because
-	 * they're before our start point.
-	 */
-	for (i = 0; i < idx; i++) {
-		if (XFS_INOBT_MASK(i) & ~irec->ir_free)
-			irec->ir_freecount++;
-	}
-
 	irec->ir_free |= xfs_inobt_maskn(0, idx);
+	irec->ir_freecount = hweight64(irec->ir_free);
 }
 
 /* Allocate memory for a walk. */

