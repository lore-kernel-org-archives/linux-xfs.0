Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297B1BE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsaKbaQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D77C433C7;
	Sun, 31 Dec 2023 22:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060420;
	bh=jhJx2YsPRXJECAv73Ib0Dhb62eQlcSfFOCrudx84NT0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WsaKbaQpUoV6uEA0+haujsi9xUdIVSblZg7V/cNqc34EPRU/mYggmBqFzZahkUN5t
	 W9EhZ+f/WHJLsw1ww+ik29UKPvNA5dAvEOwlkrObJ8sWj72YqaPkrlw73t7QfjgmUi
	 zt84WRCns0jWAzzJy3vTt5H+Vkv8mDrHJdo+w1kyZMxYaQAjTfIH7ykhLNGMWnZ6pP
	 5ow92noXOykevXC0+Q+K1QblfvW7repBMRfShoAmJQoZxbmUI7ViJmnMo6+3dDDRhY
	 lIFYVbTm4olnRqmzbAjlXWzB+ff0v1TfQFNAxx4fkLjHUAtxDiAEcEBAlPPB14EUV/
	 0u/qEukcoRuDw==
Date: Sun, 31 Dec 2023 14:06:59 -0800
Subject: [PATCH 1/3] xfs: report the health of quota counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404990482.1793446.8093355289906110063.stgit@frogsfrogsfrogs>
In-Reply-To: <170404990467.1793446.3205173493024934532.stgit@frogsfrogsfrogs>
References: <170404990467.1793446.3205173493024934532.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_fs.h                 |    1 +
 libxfs/xfs_health.h             |    4 +++-
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 spaceman/health.c               |    4 ++++
 4 files changed, 11 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 6360073865d..711e0fc7efa 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -195,6 +195,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
+#define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 6296993ff8f..5626e53b3f0 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
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
diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index 6b7c83da758..f59a6e8a6a2 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -256,6 +256,9 @@ Free space bitmap for the realtime device.
 .TP
 .B XFS_FSOP_GEOM_SICK_RT_SUMMARY
 Free space summary for the realtime device.
+.TP
+.B XFS_FSOP_GEOM_SICK_QUOTACHECK
+Quota resource usage counters.
 .RE
 
 .SH RETURN VALUE
diff --git a/spaceman/health.c b/spaceman/health.c
index d83c5ccd90d..3318f9d1a7f 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -72,6 +72,10 @@ static const struct flag_map fs_flags[] = {
 		.descr = "realtime summary",
 		.has_fn = has_realtime,
 	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_QUOTACHECK,
+		.descr = "quota counts",
+	},
 	{0},
 };
 

