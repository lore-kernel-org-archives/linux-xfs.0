Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4698CBA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBCg972L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1864FC433C8;
	Sun, 31 Dec 2023 20:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053333;
	bh=dUxq+Y2flomChZO231lbFgEatW24XXQHvgZ1vwA/l9k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EBCg972LcQZkVFt7KAyjeEVFcGFcYZD2Z7SP+/gYYWBkF+8C22+I7d+9Ag81wVtj+
	 wVXSt+4YaPvGkmA79QI3asTwKO6karayNA656grGXnKdfKiP4Vb4ldgooiZDiB47J5
	 UbE8gqKqYIG85oCCHG4bCo6Dx0rNndQzdYP+qrAqpAXmnr47a6J4PYWa1JkaLAGZCp
	 BRwlk1aeiMMDVaLXqI+YNfcVoYekoNecyKygFijix1XMJEOPulVhyr8r8kHV33D/+L
	 FbedlBQCetopKCPNUGzRArZuGIXQIcyFmwm8Lfo31Qki8ey7lkZ44e1LsyUvdekCaI
	 lUL1ezw4LVlPA==
Date: Sun, 31 Dec 2023 12:08:52 -0800
Subject: [PATCH 1/4] xfs: report health of inode link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404827846.1748178.16856097184237713173.stgit@frogsfrogsfrogs>
In-Reply-To: <170404827820.1748178.11128292961813747066.stgit@frogsfrogsfrogs>
References: <170404827820.1748178.11128292961813747066.stgit@frogsfrogsfrogs>
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

Report on the health of the inode link counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h     |    1 +
 fs/xfs/libxfs/xfs_health.h |    4 +++-
 fs/xfs/xfs_health.c        |    1 +
 3 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 07acbed9235c5..f10d0aa0e337f 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -196,6 +196,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
+#define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 5626e53b3f0fe..2bfe2dc404a19 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -42,6 +42,7 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_GQUOTA	(1 << 2)  /* group quota */
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
+#define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -79,7 +80,8 @@ struct xfs_fsop_geom;
 				 XFS_SICK_FS_UQUOTA | \
 				 XFS_SICK_FS_GQUOTA | \
 				 XFS_SICK_FS_PQUOTA | \
-				 XFS_SICK_FS_QUOTACHECK)
+				 XFS_SICK_FS_QUOTACHECK | \
+				 XFS_SICK_FS_NLINKS)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index ef07af9f753d3..111c27a6b1079 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -281,6 +281,7 @@ static const struct ioctl_sick_map fs_map[] = {
 	{ XFS_SICK_FS_GQUOTA,	XFS_FSOP_GEOM_SICK_GQUOTA },
 	{ XFS_SICK_FS_PQUOTA,	XFS_FSOP_GEOM_SICK_PQUOTA },
 	{ XFS_SICK_FS_QUOTACHECK, XFS_FSOP_GEOM_SICK_QUOTACHECK },
+	{ XFS_SICK_FS_NLINKS,	XFS_FSOP_GEOM_SICK_NLINKS },
 	{ 0, 0 },
 };
 

