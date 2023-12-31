Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD91C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMr3JmpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C89C433C7;
	Sun, 31 Dec 2023 23:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066611;
	bh=JxV+ao1L1hZOxGOScucV5k4eWwh5PG/YQYOChbmOnPU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YMr3JmpErktgWQD6O1Bu5Zi7D5eT/GPl6V5eUXLZkNfD/FY7JlSfPbVyaY/M5G1RF
	 a2d4kYqd2NkOc0OoDrrp0PQfUwiDmsMpQK1yQsCLqZZ2Y1Ezv43b0nLV9EXGkT/oHq
	 ZuP5Xo8qomXcw2ndrYIsK0H2vhJEfk5bFoz/+5dTfZeHoKLjdRDALyX7aC/51JcdF9
	 afrMDTx9oliCHGdO8lnsgASd1oKAaw1LQwv0DGCjuRcu/+17OEyGF/y451lhhKakHY
	 7pkUXsim7AxE7iz+uul6ut2SjT4389YQqHLezbiD+Qp53QdzqEVus9nJtXFwKRDpp3
	 pOt4AXwJimpXw==
Date: Sun, 31 Dec 2023 15:50:10 -0800
Subject: [PATCH 10/52] xfs: record rt group superblock errors in the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012303.1811243.18088177921751798432.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Record the state of per-rtgroup metadata sickness in the rtgroup
structure for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_health.h  |   28 +++++++++++++++++++++++++++-
 libxfs/xfs_rtgroup.h |    8 ++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 1816c67351a..f5449a804c6 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -52,6 +52,7 @@ struct xfs_inode;
 struct xfs_fsop_geom;
 struct xfs_btree_cur;
 struct xfs_da_args;
+struct xfs_rtgroup;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -66,6 +67,7 @@ struct xfs_da_args;
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
 #define XFS_SICK_RT_SUMMARY	(1 << 1)  /* realtime summary */
+#define XFS_SICK_RT_SUPER	(1 << 2)  /* rt group superblock */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -110,7 +112,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_METAPATH)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
-				 XFS_SICK_RT_SUMMARY)
+				 XFS_SICK_RT_SUMMARY | \
+				 XFS_SICK_RT_SUPER)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
@@ -192,6 +195,14 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
+void xfs_rgno_mark_sick(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		unsigned int mask);
+void xfs_rtgroup_mark_sick(struct xfs_rtgroup *rtg, unsigned int mask);
+void xfs_rtgroup_mark_checked(struct xfs_rtgroup *rtg, unsigned int mask);
+void xfs_rtgroup_mark_healthy(struct xfs_rtgroup *rtg, unsigned int mask);
+void xfs_rtgroup_measure_sickness(struct xfs_rtgroup *rtg, unsigned int *sick,
+		unsigned int *checked);
+
 void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask);
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
@@ -241,6 +252,15 @@ xfs_ag_has_sickness(struct xfs_perag *pag, unsigned int mask)
 	return sick & mask;
 }
 
+static inline bool
+xfs_rtgroup_has_sickness(struct xfs_rtgroup *rtg, unsigned int mask)
+{
+	unsigned int	sick, checked;
+
+	xfs_rtgroup_measure_sickness(rtg, &sick, &checked);
+	return sick & mask;
+}
+
 static inline bool
 xfs_inode_has_sickness(struct xfs_inode *ip, unsigned int mask)
 {
@@ -262,6 +282,12 @@ xfs_rt_is_healthy(struct xfs_mount *mp)
 	return !xfs_rt_has_sickness(mp, -1U);
 }
 
+static inline bool
+xfs_rtgroup_is_healthy(struct xfs_rtgroup *rtg)
+{
+	return !xfs_rtgroup_has_sickness(rtg, -1U);
+}
+
 static inline bool
 xfs_ag_is_healthy(struct xfs_perag *pag)
 {
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 2d0422c6712..c3f4f644ea5 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -25,6 +25,14 @@ struct xfs_rtgroup {
 	/* Number of blocks in this group */
 	xfs_rgblock_t		rtg_blockcount;
 
+	/*
+	 * Bitsets of per-rtgroup metadata that have been checked and/or are
+	 * sick.  Callers should hold rtg_state_lock before accessing this
+	 * field.
+	 */
+	uint16_t		rtg_checked;
+	uint16_t		rtg_sick;
+
 #ifdef __KERNEL__
 	/* -- kernel only structures below this line -- */
 	spinlock_t		rtg_state_lock;

