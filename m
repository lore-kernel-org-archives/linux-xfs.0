Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB439BA31
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qvr6NC4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219A0C433C8;
	Sun, 31 Dec 2023 20:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056211;
	bh=HO1u+oFo7gp4yE6IMyCLuNbQyRQ5Vc/4yko2rvZ9DHQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qvr6NC4qDD1hQQn7/IxkSPiZY+wOI9Bt1VBPRqIzdd0z1EFBvofB8JREBxfL/N8nv
	 i+EJIEgGNewTgCaI6bfPL+I5CXrT73SL6bKVqgMcDYJW6Pm32/scmvVPsW1S6U4Qw0
	 doW7dEuAHWY60DK7YO4YHD/YQlpOoJV87TtAObrWP169me0aGLLg7r7vQ/quAObHVB
	 6jlfwoJkhi71pFTT6bin7uCC/W99YQq26zTvj8wFVjiXDxNVbRrGsyuqWmB9G4hRRo
	 bA8nJ8RTFiT6OojnB+BXbdKXnGMjMdwvH8tSiKS29ruYdKP+px+zDD0WDmLKyaPMVL
	 r0fe+Qp2NI8Jg==
Date: Sun, 31 Dec 2023 12:56:50 -0800
Subject: [PATCH 14/22] xfs: replace namebuf with parent pointer in parent
 pointer repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841972.1757392.3061229459574731690.stgit@frogsfrogsfrogs>
In-Reply-To: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
References: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
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

Replace the dirent name buffer at the end of struct xrep_parent with a
xfs_parent_name_irec object.  The namebuf and p_name usage do not
overlap, so we can save 256 bytes of memory by allowing them to overlap.
Doing so makes the code a bit more complex, so this is called out
separately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/parent_repair.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 099620fc119e9..68cc3aee1d5c8 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -24,6 +24,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_health.h"
 #include "xfs_swapext.h"
+#include "xfs_parent.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -63,8 +64,12 @@ struct xrep_parent {
 	/* Orphanage reparenting request. */
 	struct xrep_adoption	adoption;
 
-	/* Directory entry name, plus the trailing null. */
-	unsigned char		namebuf[MAXNAMELEN];
+	/*
+	 * Scratch buffer for scanning dirents to create pptr xattrs.  At the
+	 * very end of the repair, it can also be used to compute the
+	 * lost+found filename if we need to reparent the file.
+	 */
+	struct xfs_parent_name_irec pptr;
 };
 
 /* Tear down all the incore stuff we created. */
@@ -236,7 +241,7 @@ xrep_parent_move_to_orphanage(
 	if (error)
 		return error;
 
-	error = xrep_adoption_compute_name(&rp->adoption, rp->namebuf);
+	error = xrep_adoption_compute_name(&rp->adoption, rp->pptr.p_name);
 	if (error)
 		return error;
 

