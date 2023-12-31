Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228DFBA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qzq6XE18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0261C433C8;
	Sun, 31 Dec 2023 20:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053083;
	bh=hwWjCV8lVAsdGjzclH8/mTFSebZDCWglFgHCHbWCvZg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qzq6XE18TMyjcLHRotQt0WMfHNbOSkC39MolIN0vk2sjgMcAJuNJnYQv9g9pifZfo
	 BPkHAK4L5a71KtkStcKMH/TWiysJZChZvFimeY14SMTJncl6PxrXR29VX+hAFXLhMi
	 mAzM40iQfJ/ucO+EuFTjE6y1JtBl9iF/HbToNoDzJopxI1rXuA+3bMQLw20igNmFKq
	 At2tGc5kkMbZdf0ZpvgvUMTUw1OgHx/xWDX6Z7uGY9WFWBPd3v4VVK6ZC5xcEdXnN9
	 syuh260ONs2kU/ewgHiYfEMHBObLT1M6gpEYk2KDJafqAE7savPd3syrALkrro8F+T
	 AFGpe72W/zxbQ==
Date: Sun, 31 Dec 2023 12:04:42 -0800
Subject: [PATCH 1/7] xfs: speed up xfs_iwalk_adjust_start a little bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404826523.1747630.4260188331032209988.stgit@frogsfrogsfrogs>
In-Reply-To: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
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

