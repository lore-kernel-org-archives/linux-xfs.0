Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA20C495056
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435709; cv=none; b=Uhbym8V76py2Z9FEMcapG7EoqU9nLlib8hX2MUe0Zd1bvSAN1J2CX0/V/cxCf8py6KJ8zPo3VtmeTUEbaoC1/qFO0i7ooZf7kgGJPSU7IctScWpLyeoScPpOpTiB3JOUiYlhugkO+Hvk4xKKt1wrnVQ7ToA+9BQU1xr0H1tIvc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435709; c=relaxed/simple;
	bh=oNEjMDUyG6g/z+IgNJMG9rVUODcBAEk68GC9Z7cAFhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRBYMiimzu/iD9Fn1ceQvzFfvPtX36iYrIR/KtrtpkLqX9lH6za/eqYU3eV+Nc2QBg8LFh+Drzg9aw6YgMQTDqOgyejPd1wtio4CgbRJxzM4U10ag7PJNZPUeLAmGi3CPFPZdObyEg3yoAfcWFCVRPEMfps7fWPeKF0pXG0PtBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GjxAN/xK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjxAN/xK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522EB1F00A3E;
	Thu,  3 Sep 2026 11:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435701;
	bh=xwntnSQ6GGJU3yhFmUxI8YrNwFs4czcSXX39ds+OAo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjxAN/xKysyam9sk7TJAgKYeltC8sq14zrkNlNROUypDZEBCJDQUZ+HSXsLzj/AuK
	 2Ii9S0ssiEIIx5+t8RrEdMkdBuRbvrQ1z8e+b1xNIfPS9lEPSa0T3/VvqCoGhqpuYz
	 AFKtW8geRd0bk3U1/adeokLQzYETwlu5hslAWJ59RBoiDENLhaoWbziKJbW/g5YJXD
	 EoLyITcPhcYFi6QjIUTY6evduw1OxwCu/JHOJy3jcC44Kfrbki490jrTSH9Sh51uMw
	 PgBLOgvbhd4/XrUBQxVXAv75GNHRG35JvJB39sZXh4BwDXLdGLx8SsVhF/QF5XhLer
	 7GkyUgx/d5Rog==
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
Subject: [PATCH v2 16/23] xfs: pass back updated nb from xfs_growfs_compute_deltas
Date: Thu,  3 Sep 2026 13:39:58 +0200
Message-ID: <20260903114022.570210-17-aalbersh@kernel.org>
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

Source kernel commit: 4cb6e89a3d901d4da515977e55f9a9a779238660

xfs_growfs_compute_deltas can update nb for corner cases like a number
of blocks that would create a less the minimal sized AG, or running
past the max AG limit.  Pass back the calculated value to the caller,
as it relies on to calculate the new number of perag structures.

Note that the grown file system size is not affected by this
miscalculation as it uses the passed back delta value.

Fixes: a49b7ff63f98 ("xfs: Refactoring the nagcount and delta calculation")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.c | 10 +++++-----
 libxfs/xfs_ag.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 1c75ef510567..fb8c9bb3df82 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -864,7 +864,7 @@ resv_err:
 void
 xfs_growfs_compute_deltas(
 	struct xfs_mount	*mp,
-	xfs_rfsblock_t		nb,
+	xfs_rfsblock_t		*nb,
 	int64_t			*deltap,
 	xfs_agnumber_t		*nagcountp)
 {
@@ -872,19 +872,19 @@ xfs_growfs_compute_deltas(
 	int64_t		delta;
 	xfs_agnumber_t	nagcount;
 
-	nb_div = nb;
+	nb_div = *nb;
 	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
 	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
 		nb_div++;
 	else if (nb_mod)
-		nb = nb_div * mp->m_sb.sb_agblocks;
+		*nb = nb_div * mp->m_sb.sb_agblocks;
 
 	if (nb_div > XFS_MAX_AGNUMBER + 1) {
 		nb_div = XFS_MAX_AGNUMBER + 1;
-		nb = nb_div * mp->m_sb.sb_agblocks;
+		*nb = nb_div * mp->m_sb.sb_agblocks;
 	}
 	nagcount = nb_div;
-	delta = nb - mp->m_sb.sb_dblocks;
+	delta = *nb - mp->m_sb.sb_dblocks;
 	*deltap = delta;
 	*nagcountp = nagcount;
 }
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 16a9b43a3c27..8aa4266c5571 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -330,7 +330,7 @@ int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
 int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
 			xfs_extlen_t delta);
 void
-xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
+xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t *nb,
 			int64_t *deltap, xfs_agnumber_t *nagcountp);
 int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
 			xfs_extlen_t len);
-- 
2.55.0

