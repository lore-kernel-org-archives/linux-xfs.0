Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B5431A9D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591182; cv=none; b=GIz+NajSyWhWoFv5JpAkC7/Ej1I3fNI+MIaCaqZjTXkDja+wkn5+wPZn730HSj9pMEfPZ+n0pvc913VgGA2CWT9v7t5xQrW6i57P+f4tCzc2HOnz4Zee9HxkZ0V7utuvg4BhBE4xEP9T8vclUbayeIIzVuvEX3RqCuuBvcHO9JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591182; c=relaxed/simple;
	bh=fcxGE+Z6G2yHDexuCHkzqCUzzDCN3RGBYswstuxkXG0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e9zhw5npfGUkB1Na/vJllgz9OLC+vxVEm8K7mhmtCQkscWqT/loJLjQwe60hdtajdzAoGK/lp1K2LPaSKJwyxB5CgyZbnkhMDtOHbra6aKv9OMR1KY+3DBtlJrk7WgfGXiK5zVTCJSMUsP7e/4Scw1ndGfDGB6B+Zz1/hK3JyFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NXCoZm0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NXCoZm0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA98C433C7;
	Tue, 30 Jan 2024 05:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591181;
	bh=fcxGE+Z6G2yHDexuCHkzqCUzzDCN3RGBYswstuxkXG0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NXCoZm0tda61mZUDyRskqO9sg8LC4tvBDK04YbayNf4xPx1FL0DdermKRB266EKBG
	 k7dje7CckFVeovuNVZKh0/12hIZks1HU4ATVPCbUM5RMk/Ljxx1qkB80o3mYLkzru9
	 sDI8kgCkCnxmX8j3Y8KtnemRW3a41Ccrp0tZn0X70K6j0wtFP5NrqeE7ewFLsGyH9T
	 RT7zhZh7KJDLhK7f1tuWfV8jCBsiWXcaoENFIbCwxeru0QxNF2Bn5+P9djdHQWj/iQ
	 3vPAK6QohquFqRx3lnbZJm1RIusKLcCR2fuS5gUcfjJa3u2e7GZmRkro1MVstU9vLm
	 7awOwQBHlYB3A==
Date: Mon, 29 Jan 2024 21:06:21 -0800
Subject: [PATCH 1/8] xfs: report the health of quota counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659062769.3353369.131653789121444388.stgit@frogsfrogsfrogs>
In-Reply-To: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
References: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 67d0a8564ff3e..6ee91de1df59a 100644
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
 

