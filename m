Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB839381A0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591557; cv=none; b=aocGb/mA438/3lZV2Pao6trFeIZRRO7v9E5CynM/LLB8kZW6cdfG5o9V7KF3xibJWzy831kYBZqoRHFo1mRWnYTOWczYaorL/z0PukGNkyjgqdx9A22dqY5kEOgBOTVjHH4xH49/tRwqOR3L4Q8FpvYqj49pZuz3u5HjKZbNy3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591557; c=relaxed/simple;
	bh=YMLCj+p7wP+rpLTw+lg897rYK6udq+E4ne30BX3WO/s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BX3K8Vubb4oDGCke7yqvjQ6icCJdN1igOfyaNP/Ot1IxUDz2CwYyJ6LGgEiEU3UEVOpp+T6lng8mb64FdcuQdlbxDk/40ELbMHaG3DsmHnTwpExiEAS/yhBXM/FmlSVsK+9QnMGU1nontc1GEWx1qUUwzYv6Rli3iqnTKJ3PUVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJziLvhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJziLvhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B104C433C7;
	Tue, 30 Jan 2024 05:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591557;
	bh=YMLCj+p7wP+rpLTw+lg897rYK6udq+E4ne30BX3WO/s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CJziLvhB2vcHp1p2dWh4Il9VIWQVP6FUHvSbAmQFlj/2ieCNgFQcKxVT8MDFtLg41
	 6FRUGRKKX9gcrWezTEkBH6c3TVNsiCy+QnhOTPHJ2xwbpBJVeDlIk0oixT14p8myOl
	 GOSkSi4WZ5R48UKwLSECfDGS/3pbXJO4pU0zOI//l+SwH0E5Y2A9MZejAdIVyk22Q5
	 jQ6gw8EN+DtRSMBu7yAyoyig5y331xziLPnMKngf0nBDq0/Z9di7XUjYRgGd4d2piD
	 oN0MGSo3Mad6dWAv3sHxJ3PEq8l31pRdimCqrf2UGp/a1u3qDWm5y5gcmTeAJ4NsFa
	 GomRpY1nydO9Q==
Date: Mon, 29 Jan 2024 21:12:36 -0800
Subject: [PATCH 2/3] xfs: remember sick inodes that get inactivated
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659064303.3354229.9628194102451109373.stgit@frogsfrogsfrogs>
In-Reply-To: <170659064262.3354229.596649174411799386.stgit@frogsfrogsfrogs>
References: <170659064262.3354229.596649174411799386.stgit@frogsfrogsfrogs>
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

If an unhealthy inode gets inactivated, remember this fact in the
per-fs health summary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h        |    1 +
 fs/xfs/libxfs/xfs_health.h    |    8 ++++++--
 fs/xfs/libxfs/xfs_inode_buf.c |    2 +-
 fs/xfs/scrub/health.c         |   12 +++++++++++-
 fs/xfs/xfs_health.c           |    1 +
 fs/xfs/xfs_inode.c            |   35 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h            |    1 +
 7 files changed, 56 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 515cd27d3b3a8..b5c8da7e6aa99 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -294,6 +294,7 @@ struct xfs_ag_geometry {
 #define XFS_AG_GEOM_SICK_FINOBT	(1 << 7)  /* free inode index */
 #define XFS_AG_GEOM_SICK_RMAPBT	(1 << 8)  /* reverse mappings */
 #define XFS_AG_GEOM_SICK_REFCNTBT (1 << 9)  /* reference counts */
+#define XFS_AG_GEOM_SICK_INODES	(1 << 10) /* bad inodes were seen */
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 26a2661571b1d..df07c5877ba44 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -76,6 +76,7 @@ struct xfs_da_args;
 #define XFS_SICK_AG_FINOBT	(1 << 7)  /* free inode index */
 #define XFS_SICK_AG_RMAPBT	(1 << 8)  /* reverse mappings */
 #define XFS_SICK_AG_REFCNTBT	(1 << 9)  /* reference counts */
+#define XFS_SICK_AG_INODES	(1 << 10) /* inactivated bad inodes */
 
 /* Observable health issues for inode metadata. */
 #define XFS_SICK_INO_CORE	(1 << 0)  /* inode core */
@@ -92,6 +93,9 @@ struct xfs_da_args;
 #define XFS_SICK_INO_DIR_ZAPPED		(1 << 10) /* directory erased */
 #define XFS_SICK_INO_SYMLINK_ZAPPED	(1 << 11) /* symlink erased */
 
+/* Don't propagate sick status to ag health summary during inactivation */
+#define XFS_SICK_INO_FORGET	(1 << 12)
+
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
 				 XFS_SICK_FS_UQUOTA | \
@@ -132,12 +136,12 @@ struct xfs_da_args;
 #define XFS_SICK_FS_SECONDARY	(0)
 #define XFS_SICK_RT_SECONDARY	(0)
 #define XFS_SICK_AG_SECONDARY	(0)
-#define XFS_SICK_INO_SECONDARY	(0)
+#define XFS_SICK_INO_SECONDARY	(XFS_SICK_INO_FORGET)
 
 /* Evidence of health problems elsewhere. */
 #define XFS_SICK_FS_INDIRECT	(0)
 #define XFS_SICK_RT_INDIRECT	(0)
-#define XFS_SICK_AG_INDIRECT	(0)
+#define XFS_SICK_AG_INDIRECT	(XFS_SICK_AG_INODES)
 #define XFS_SICK_INO_INDIRECT	(0)
 
 /* All health masks. */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 1280d6acd1c1b..d0dcce462bf42 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -139,7 +139,7 @@ xfs_imap_to_bp(
 			imap->im_len, XBF_UNMAPPED, bpp, &xfs_inode_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
-				XFS_SICK_AG_INOBT);
+				XFS_SICK_AG_INODES);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index ef3763a13a667..71a65fb78c3df 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -185,7 +185,17 @@ xchk_update_health(
 		if (!sc->ip)
 			return;
 		if (bad) {
-			xfs_inode_mark_sick(sc->ip, sc->sick_mask);
+			unsigned int	mask = sc->sick_mask;
+
+			/*
+			 * If we're coming in for repairs then we don't want
+			 * sickness flags to propagate to the incore health
+			 * status if the inode gets inactivated before we can
+			 * fix it.
+			 */
+			if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+				mask |= XFS_SICK_INO_FORGET;
+			xfs_inode_mark_sick(sc->ip, mask);
 			xfs_inode_mark_checked(sc->ip, sc->sick_mask);
 		} else
 			xfs_inode_mark_healthy(sc->ip, sc->sick_mask);
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 6ea85cd6b66f8..2be1ac83f4c41 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -415,6 +415,7 @@ static const struct ioctl_sick_map ag_map[] = {
 	{ XFS_SICK_AG_FINOBT,	XFS_AG_GEOM_SICK_FINOBT },
 	{ XFS_SICK_AG_RMAPBT,	XFS_AG_GEOM_SICK_RMAPBT },
 	{ XFS_SICK_AG_REFCNTBT,	XFS_AG_GEOM_SICK_REFCNTBT },
+	{ XFS_SICK_AG_INODES,	XFS_AG_GEOM_SICK_INODES },
 	{ 0, 0 },
 };
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6412b558edf08..fe058a1a4fec4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1751,6 +1751,39 @@ xfs_inode_needs_inactive(
 	return xfs_can_free_eofblocks(ip, true);
 }
 
+/*
+ * Save health status somewhere, if we're dumping an inode with uncorrected
+ * errors and online repair isn't running.
+ */
+static inline void
+xfs_inactive_health(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+	unsigned int		sick;
+	unsigned int		checked;
+
+	xfs_inode_measure_sickness(ip, &sick, &checked);
+	if (!sick)
+		return;
+
+	trace_xfs_inode_unfixed_corruption(ip, sick);
+
+	if (sick & XFS_SICK_INO_FORGET)
+		return;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	if (!pag) {
+		/* There had better still be a perag structure! */
+		ASSERT(0);
+		return;
+	}
+
+	xfs_ag_mark_sick(pag, XFS_SICK_AG_INODES);
+	xfs_perag_put(pag);
+}
+
 /*
  * xfs_inactive
  *
@@ -1779,6 +1812,8 @@ xfs_inactive(
 	mp = ip->i_mount;
 	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
 
+	xfs_inactive_health(ip);
+
 	/*
 	 * If this is a read-only mount, don't do this (would generate I/O)
 	 * unless we're in log recovery and cleaning the iunlinked list.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0984a1c884c74..b78c8be57b2d4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3981,6 +3981,7 @@ DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
 	TP_ARGS(ip, flags))
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
+DEFINE_INODE_CORRUPT_EVENT(xfs_inode_unfixed_corruption);
 
 TRACE_EVENT(xfs_iwalk_ag,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,

