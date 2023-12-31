Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F6CBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rcXTfbXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED82AC433C7;
	Sun, 31 Dec 2023 20:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053255;
	bh=dDJjqejb67pFJnwgeuneRI2y7QeoHaBvcbAuDsEu4YA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rcXTfbXCJiRmVgVtJVQtwxHe32WTUddcj7IZGAAUPvXB+mZ1XdccTPjLcdRtzkOQF
	 OM/sowUU9FYHXra+2+lrAi+gxKGBHW52a8N3/GGFVFihWeUlvE7PnL8jId0DGsr0Pc
	 TJIXj/nPklAUh2Jvwpo3VzpHlI5UeTKFi+UEDOrS5uUclaCoO6NdNdkwePpP8E1uV6
	 JHonXVMqJEAYjWEgRpX14156i31FBwC11ZhdaUwRSN3Ct1iVDTThyl4ihAdyIE/+T7
	 rpgBGQsVrAUGN55020oN02soIKLDrNkbGAAfCzbxf+GO3g3fVNRsGQkgqjD1OBMsZU
	 9BbHa2QE8pyzQ==
Date: Sun, 31 Dec 2023 12:07:34 -0800
Subject: [PATCH 1/5] xfs: report the health of quota counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404827409.1748002.15298270435251252315.stgit@frogsfrogsfrogs>
In-Reply-To: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
References: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
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

Report the health of quota counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h     |    1 +
 fs/xfs/libxfs/xfs_health.h |    4 +++-
 fs/xfs/xfs_health.c        |    1 +
 fs/xfs/xfs_qm.c            |    7 ++++++-
 fs/xfs/xfs_trans_dquot.c   |    2 ++
 5 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6360073865dbc..711e0fc7efab6 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -195,6 +195,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
+#define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 6296993ff8f3d..5626e53b3f0fe 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -41,6 +41,7 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_UQUOTA	(1 << 1)  /* user quota */
 #define XFS_SICK_FS_GQUOTA	(1 << 2)  /* group quota */
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
+#define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -77,7 +78,8 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
 				 XFS_SICK_FS_UQUOTA | \
 				 XFS_SICK_FS_GQUOTA | \
-				 XFS_SICK_FS_PQUOTA)
+				 XFS_SICK_FS_PQUOTA | \
+				 XFS_SICK_FS_QUOTACHECK)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 9a57afee93383..ef07af9f753d3 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -280,6 +280,7 @@ static const struct ioctl_sick_map fs_map[] = {
 	{ XFS_SICK_FS_UQUOTA,	XFS_FSOP_GEOM_SICK_UQUOTA },
 	{ XFS_SICK_FS_GQUOTA,	XFS_FSOP_GEOM_SICK_GQUOTA },
 	{ XFS_SICK_FS_PQUOTA,	XFS_FSOP_GEOM_SICK_PQUOTA },
+	{ XFS_SICK_FS_QUOTACHECK, XFS_FSOP_GEOM_SICK_QUOTACHECK },
 	{ 0, 0 },
 };
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 94a7932ac5700..826aa5790cdeb 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_ialloc.h"
 #include "xfs_log_priv.h"
+#include "xfs_health.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -1406,8 +1407,12 @@ xfs_qm_quotacheck(
 			xfs_warn(mp,
 				"Quotacheck: Failed to reset quota flags.");
 		}
-	} else
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_QUOTACHECK);
+	} else {
 		xfs_notice(mp, "Quotacheck: Done.");
+		xfs_fs_mark_healthy(mp, XFS_SICK_FS_QUOTACHECK);
+	}
+
 	return error;
 
 error_purge:
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index aa00cf67ad72a..968dc7af4fc7d 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -17,6 +17,7 @@
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -706,6 +707,7 @@ xfs_trans_dqresv(
 error_corrupt:
 	xfs_dqunlock(dqp);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	xfs_fs_mark_sick(mp, XFS_SICK_FS_QUOTACHECK);
 	return -EFSCORRUPTED;
 }
 

