Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E398BA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oc5wGAtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2263C433C8;
	Sun, 31 Dec 2023 20:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053598;
	bh=irjApS69uq+zao5zflw2ywJPjCG1RTdkrLgq4fNkyQA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oc5wGAtBj4AYX/4tAyhW83YHtmngdOftAv+yRpBDSuImI7lIrZ2GosaZqtdU2OcrZ
	 hP7bf4Vh+L9O3I+NQITnldFI/9SES+31TFqjIMbMJRHEZA5/1KKCUX1wGTKHvCY0O2
	 LlWDSZt9jy6qorZiD2/X2XMSREgDoeikrPEubF/t48Tosrop5YR4cVwcbe1hhRcb2P
	 p2a7YdvzvlYu+1+9jw5c2LnhH6aGHwT7kf50MbyRKd/ezyZsb5wCOgPQmg5NBq8mLg
	 5uY/TxhjnKhOpwAnbFoEnGEApIaD9PEHWqqHiuhmazW1v/UICvHBymN03XNMDtCMIj
	 ZZ8ntZXO7MgaQ==
Date: Sun, 31 Dec 2023 12:13:18 -0800
Subject: [PATCH 3/3] xfs: update health status if we get a clean bill of
 health
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404828862.1748648.8875885962116664930.stgit@frogsfrogsfrogs>
In-Reply-To: <170404828806.1748648.14558047021297001140.stgit@frogsfrogsfrogs>
References: <170404828806.1748648.14558047021297001140.stgit@frogsfrogsfrogs>
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

If scrub finds that everything is ok with the filesystem, we need a way
to tell the health tracking that it can let go of indirect health flags,
since indirect flags only mean that at some point in the past we lost
some context.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |    3 ++
 fs/xfs/scrub/health.c  |   64 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.h  |    1 +
 fs/xfs/scrub/repair.c  |    1 +
 fs/xfs/scrub/scrub.c   |    6 +++++
 fs/xfs/scrub/trace.h   |    4 ++-
 6 files changed, 77 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b5c8da7e6aa99..ca1b17d014377 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -714,9 +714,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
+#define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	27
+#define XFS_SCRUB_TYPE_NR	28
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index e26d71716c922..664d57247ddf5 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -16,6 +16,7 @@
 #include "xfs_health.h"
 #include "scrub/scrub.h"
 #include "scrub/health.h"
+#include "scrub/common.h"
 
 /*
  * Scrub and In-Core Filesystem Health Assessments
@@ -151,6 +152,24 @@ xchk_file_looks_zapped(
 	return xfs_inode_has_sickness(sc->ip, mask);
 }
 
+/*
+ * Scrub gave the filesystem a clean bill of health, so clear all the indirect
+ * markers of past problems (at least for the fs and ags) so that we can be
+ * healthy again.
+ */
+STATIC void
+xchk_mark_all_healthy(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	xfs_fs_mark_healthy(mp, XFS_SICK_FS_INDIRECT);
+	xfs_rt_mark_healthy(mp, XFS_SICK_RT_INDIRECT);
+	for_each_perag(mp, agno, pag)
+		xfs_ag_mark_healthy(pag, XFS_SICK_AG_INDIRECT);
+}
+
 /*
  * Update filesystem health assessments based on what we found and did.
  *
@@ -168,6 +187,18 @@ xchk_update_health(
 	struct xfs_perag	*pag;
 	bool			bad;
 
+	/*
+	 * The HEALTHY scrub type is a request from userspace to clear all the
+	 * indirect flags after a clean scan of the entire filesystem.  As such
+	 * there's no sick flag defined for it, so we branch here ahead of the
+	 * mask check.
+	 */
+	if (sc->sm->sm_type == XFS_SCRUB_TYPE_HEALTHY &&
+	    !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
+		xchk_mark_all_healthy(sc->mp);
+		return;
+	}
+
 	if (!sc->sick_mask)
 		return;
 
@@ -291,3 +322,36 @@ xchk_ag_btree_healthy_enough(
 
 	return true;
 }
+
+/*
+ * Quick scan to double-check that there isn't any evidence of lingering
+ * primary health problems.  If we're still clear, then the health update will
+ * take care of clearing the indirect evidence.
+ */
+int
+xchk_health_record(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	unsigned int		sick;
+	unsigned int		checked;
+
+	xfs_fs_measure_sickness(mp, &sick, &checked);
+	if (sick & XFS_SICK_FS_PRIMARY)
+		xchk_set_corrupt(sc);
+
+	xfs_rt_measure_sickness(mp, &sick, &checked);
+	if (sick & XFS_SICK_RT_PRIMARY)
+		xchk_set_corrupt(sc);
+
+	for_each_perag(mp, agno, pag) {
+		xfs_ag_measure_sickness(pag, &sick, &checked);
+		if (sick & XFS_SICK_AG_PRIMARY)
+			xchk_set_corrupt(sc);
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/health.h b/fs/xfs/scrub/health.h
index a731b2467399f..06d17941776cc 100644
--- a/fs/xfs/scrub/health.h
+++ b/fs/xfs/scrub/health.h
@@ -12,5 +12,6 @@ bool xchk_ag_btree_healthy_enough(struct xfs_scrub *sc, struct xfs_perag *pag,
 		xfs_btnum_t btnum);
 void xchk_mark_healthy_if_clean(struct xfs_scrub *sc, unsigned int mask);
 bool xchk_file_looks_zapped(struct xfs_scrub *sc, unsigned int mask);
+int xchk_health_record(struct xfs_scrub *sc);
 
 #endif /* __XFS_SCRUB_HEALTH_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 7141b17789028..ab510cea96d86 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -30,6 +30,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_reflink.h"
+#include "xfs_health.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index c0b99184bb3ef..0f23b7f36d4a5 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -378,6 +378,12 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.scrub	= xchk_nlinks,
 		.repair	= xrep_nlinks,
 	},
+	[XFS_SCRUB_TYPE_HEALTHY] = {	/* fs healthy; clean all reminders */
+		.type	= ST_FS,
+		.setup	= xchk_setup_fs,
+		.scrub	= xchk_health_record,
+		.repair = xrep_notsupported,
+	},
 };
 
 static int
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index fbadec84f45a2..86af0efa15d7c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -69,6 +69,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_QUOTACHECK);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -97,7 +98,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
 	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }, \
 	{ XFS_SCRUB_TYPE_QUOTACHECK,	"quotacheck" }, \
-	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }
+	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }, \
+	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \

