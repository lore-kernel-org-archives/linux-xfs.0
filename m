Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B618B3DB80
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="reXHfTS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850A6C433C8;
	Fri, 24 Nov 2023 23:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700870021;
	bh=CY4X49uAIoZlHTrSincTem/bImRy3vhsGxvv+SHNGAU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=reXHfTS5UuDCVCGAXD7BfEtZJ186Bke+CBwHr4NGGi1fHqeJvoTxSPKJ4u4okhcF1
	 EeNvFOKX9GTfyZ63FC3I6Ir4kPCU9yH57dHrEPJkzzwKSpv16rQzWbVFpA1K9C5Sq7
	 7S+sIy9obrPOep/Do61BUHkTw65p3LUYbfL+OLdIsxf49qMhZxI5HrnCpWzeHl8aGd
	 kh2PFoBjqbu4V1u1XyzFya92EnC1CfF3v3Dee7CNYQ0M38AXMFZrldoyd61lG0bnfu
	 L4rgSOG+MmJ71n4+Wu/yYZH8oIcYxnJZqaafycte9ZGlPeBcaJhWNrXkhYEfilwRMt
	 P+QrT30vEGeVw==
Date: Fri, 24 Nov 2023 15:53:41 -0800
Subject: [PATCH 3/5] xfs: refactor repair forcing tests into a repair.c helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086927959.2771366.6049466877788933461.stgit@frogsfrogsfrogs>
In-Reply-To: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
References: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
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

There are a couple of conditions that userspace can set to force repairs
of metadata.  These really belong in the repair code and not open-coded
into the check code, so refactor them into a helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |   22 ++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    2 ++
 fs/xfs/scrub/scrub.c  |   14 +-------------
 3 files changed, 25 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 4d5bfb2e4cf08..0f8dc25ef998b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -27,6 +27,8 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_defer.h"
+#include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -937,3 +939,23 @@ xrep_reset_perag_resv(
 out:
 	return error;
 }
+
+/* Decide if we are going to call the repair function for a scrub type. */
+bool
+xrep_will_attempt(
+	struct xfs_scrub	*sc)
+{
+	/* Userspace asked us to rebuild the structure regardless. */
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD)
+		return true;
+
+	/* Let debug users force us into the repair routines. */
+	if (XFS_TEST_ERROR(false, sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
+		return true;
+
+	/* Metadata is corrupt or failed cross-referencing. */
+	if (xchk_needs_repair(sc->sm))
+		return true;
+
+	return false;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 9f0c77b38ae28..73ac3eca1a781 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -28,6 +28,7 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
 /* Repair helpers */
 
 int xrep_attempt(struct xfs_scrub *sc, struct xchk_stats_run *run);
+bool xrep_will_attempt(struct xfs_scrub *sc);
 void xrep_failure(struct xfs_mount *mp);
 int xrep_roll_ag_trans(struct xfs_scrub *sc);
 int xrep_roll_trans(struct xfs_scrub *sc);
@@ -117,6 +118,7 @@ int xrep_reinit_pagi(struct xfs_scrub *sc);
 #else
 
 #define xrep_ino_dqattach(sc)	(0)
+#define xrep_will_attempt(sc)	(false)
 
 static inline int
 xrep_attempt(
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 52a09e0652693..8397d1dce25fa 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -14,8 +14,6 @@
 #include "xfs_inode.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
-#include "xfs_errortag.h"
-#include "xfs_error.h"
 #include "xfs_scrub.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
@@ -552,21 +550,11 @@ xfs_scrub_metadata(
 	xchk_update_health(sc);
 
 	if (xchk_could_repair(sc)) {
-		bool needs_fix = xchk_needs_repair(sc->sm);
-
-		/* Userspace asked us to rebuild the structure regardless. */
-		if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD)
-			needs_fix = true;
-
-		/* Let debug users force us into the repair routines. */
-		if (XFS_TEST_ERROR(needs_fix, mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
-			needs_fix = true;
-
 		/*
 		 * If userspace asked for a repair but it wasn't necessary,
 		 * report that back to userspace.
 		 */
-		if (!needs_fix) {
+		if (!xrep_will_attempt(sc)) {
 			sc->sm->sm_flags |= XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED;
 			goto out_nofix;
 		}

