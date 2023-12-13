Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D302BBA49
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGg1EJ/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417D7C433C7;
	Wed, 13 Dec 2023 22:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702508184;
	bh=8VOM/NmSu8+bSvbom54y5PqQaQEdaZc9AFtEyP6Ammk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HGg1EJ/57/NL4lpY9Tu5za1qpF+jSvWk4Pu2JV5RUVqbUNLlV5gp+p2/5/SKA53a5
	 WnZAgIvizQQxIiSHCrSrqNstNeKtAaMarpZ7ckOled/XwNGhJgrKAnR0d9gCsmyuPJ
	 65hdzFhsLqStxZt0WUCrmV7Tly3glTuLTGo6wjeyp4xa/sp/DBkmM49S+BiyQkK2o2
	 /Pj2JQjZhDYqO/3Byq1TbuUJUC1a7cWk72Gl+xa2IXPOhnW6iR8XR4qB8b6ByAaO3y
	 w4a2DvSBkbnittQFpYejbgqv7St7SGeil2is5pgg3X5sIapdluTEF9BqIAQzkmYm+J
	 JuhII9gSRaCoQ==
Date: Wed, 13 Dec 2023 14:56:23 -0800
Subject: [PATCH 3/5] xfs: refactor repair forcing tests into a repair.c helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250783989.1399452.11806807344830362212.stgit@frogsfrogsfrogs>
In-Reply-To: <170250783929.1399452.16224631770180304352.stgit@frogsfrogsfrogs>
References: <170250783929.1399452.16224631770180304352.stgit@frogsfrogsfrogs>
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
index 26d65175ae8b..020d49b0f9b9 100644
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
@@ -940,3 +942,23 @@ xrep_reset_perag_resv(
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
index 8aa8b8889e39..51ba3df5998c 100644
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
index 238ead205c52..c9e37c688089 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -14,8 +14,6 @@
 #include "xfs_inode.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
-#include "xfs_errortag.h"
-#include "xfs_error.h"
 #include "xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -550,21 +548,11 @@ xfs_scrub_metadata(
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

