Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F084149481C
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435711; cv=none; b=kcwGAiaxUMZXFTJBavmRrMMLOMKYVrlL5U44z+6EyN00d2yC0S8By6wewZ5CgcOiSQbMaKoTaYT6SKJTSLL2sHPMY5dME/MoVeSM/lgUtbd8U/JCumJ22Xh+AQtND5mN3CecZuwEge7kKFKmPC4AqdhIoO4/Zhga135fbNQ2smg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435711; c=relaxed/simple;
	bh=teBwtVX3hFqlquyDFBhxMC5zdtvY2+2xC8T/6GAY9ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ua5Sag7MWJxsJo2eno0sE5mIwWRAmurtHQmCue5f9X3HPCDdn0P1k/mrI0iz/VEkomYKzaLi00MvSHh3uSYb1qn5213ZnxxcZuja0OiB3ZMosAef+iNIJ8JDYkeFzkj2YrTDv1f2iYkEtPnNjc+DhQI2j9jQzq2ue6GN2j4vHZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iHunok25; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iHunok25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE871F000E9;
	Thu,  3 Sep 2026 11:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435704;
	bh=Ym6TdMfCfk3YqSxHhnJcZGbLR/HJallpffrWZ7/Mvv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHunok25oSOiLOaetcHnbR0pYKNyUkhymmsWsw8TtOI7TSmlhGPzzmNvnZdAcDCZE
	 mWY91AX5Xs9CutzZKLGGrfHg4X8YeF7GmKjrMEDyKYrh3NrCtR5znCLXkFLJdfz6Ub
	 eyS8j2haHaA5ycdZlf+hBO1KTAfpJFhr8Aya9FbqfV/EOjvwZQO/jY+pBlnLYy2b+1
	 gZfUmORRVS+482CfRNyWtv51L/GP/eGKb8Nlwq3zz4m6L2hZIuxYquxr21NL5Vnah2
	 Q3/tenmxWyFvqVZ+r2QJQvKw9Fa4tRgq5GTcvFGb+1cUGpTBzVUFbmpPLuAx48Wa6r
	 gKW74JloylDTQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH v2 17/23] xfs: cleanup xfs_growfs_compute_deltas
Date: Thu,  3 Sep 2026 13:39:59 +0200
Message-ID: <20260903114022.570210-18-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: dfac6ba84819bd12535943c4090766bbc6c5ea7e

xfs_growfs_compute_deltas has an odd calling conventions, and looks
very convoluted due to the use of do_div and strangely named and typed
variables.

Rename it, make it return the agcount and let the caller calculate the
delta.  The internally use the better div_u64_rem helper and descriptive
variable names and types.  Also add a comment describing what the
function is used for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.c | 42 ++++++++++++++++++++----------------------
 libxfs/xfs_ag.h |  5 ++---
 2 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index fb8c9bb3df82..2f47a02cc6fd 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -861,32 +861,30 @@ resv_err:
 	return err2;
 }
 
-void
-xfs_growfs_compute_deltas(
+/*
+ * Return the agcount for the new file system size passed in *nb and adjust *nb
+ * when it has to be reduced because of maximum AG count or because it would
+ * create a below minimum size AG.
+ */
+xfs_agnumber_t
+xfs_growfs_compute_agcount(
 	struct xfs_mount	*mp,
-	xfs_rfsblock_t		*nb,
-	int64_t			*deltap,
-	xfs_agnumber_t		*nagcountp)
+	xfs_rfsblock_t		*nb)
 {
-	xfs_rfsblock_t	nb_div, nb_mod;
-	int64_t		delta;
-	xfs_agnumber_t	nagcount;
+	uint64_t		agcount; /* 64-bits wide to catch overflows */
+	xfs_extlen_t		remainder;
 
-	nb_div = *nb;
-	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
-	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
-		nb_div++;
-	else if (nb_mod)
-		*nb = nb_div * mp->m_sb.sb_agblocks;
-
-	if (nb_div > XFS_MAX_AGNUMBER + 1) {
-		nb_div = XFS_MAX_AGNUMBER + 1;
-		*nb = nb_div * mp->m_sb.sb_agblocks;
+	agcount = div_u64_rem(*nb, mp->m_sb.sb_agblocks, &remainder);
+	if (agcount >= XFS_MAX_AGNUMBER + 1) {
+		agcount = XFS_MAX_AGNUMBER + 1;
+		remainder = 0;
+	}
+	*nb = (xfs_rfsblock_t)agcount * mp->m_sb.sb_agblocks;
+	if (remainder >= XFS_MIN_AG_BLOCKS) {
+		*nb += remainder;
+		agcount++;
 	}
-	nagcount = nb_div;
-	delta = *nb - mp->m_sb.sb_dblocks;
-	*deltap = delta;
-	*nagcountp = nagcount;
+	return agcount;
 }
 
 /*
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 8aa4266c5571..fd22fe598931 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -329,12 +329,11 @@ struct aghdr_init_data {
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
 int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
 			xfs_extlen_t delta);
-void
-xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t *nb,
-			int64_t *deltap, xfs_agnumber_t *nagcountp);
 int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
 			xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
+xfs_agnumber_t xfs_growfs_compute_agcount(struct xfs_mount *mp,
+		xfs_rfsblock_t *nb);
 
 static inline xfs_fsblock_t
 xfs_agbno_to_fsb(
-- 
2.55.0

