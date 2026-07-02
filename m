Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD0E306776
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022686; cv=none; b=i2tH6UuhrbPuqrFV7h/rs99N4o91iWMH5JQbKmILO/IMsuu0rJj3oI30Qgw8hhILLuiFlpdW1FwNNOttulYnpu/Z5Ec8zsgrkLrNtibn/kokENrMrxu0l19NpC4HDvx2vywY7OYHReXfCW7P3RK9b4N24xQnsrXnxyuQChyfkzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022686; c=relaxed/simple;
	bh=P20RQ+qNGxAuTAwp0iC5m1WpvzOMXYJBhrcD1AehOk4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IEUpEFjOT8VRZnvpDqS6aTd0bYDvLMHwwslR5Qm6Xm71G9acQjIr0pgYVxmougHltyBL6r/asrqP75wGRuy7dB4F6HY1VYBugwwMjgoRAsugWkO+WYRRCiBrGi4MzzFGS6MLJ7qgqjPsz/4bKPd1s2bthGytGWkwxk5QNoK7pmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQSiAzoV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQSiAzoV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B35FD1F000E9;
	Thu,  2 Jul 2026 20:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022685;
	bh=TSzy7sNktQn/GUIP1456+yRvcGbBdvOeWUyCpik9Jbo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=FQSiAzoVXUCPXOddjasfzQaSrh3j58VGyPrSRhHdknjLGY7VCT+OscveeUtQFaIEa
	 B+a/miWs2hOA5kN+W0xNXAqg6486m8zVIrFB3tV89z+THX3q5m1sV62r1L4b6Q8V2p
	 BwdlI6+/3M2d52fXqWrfqQ669TuRyJUxqgBnAgdR1WYptP9CqDTOc4CHs/VqvzWlrg
	 SwA4gSZ28yzWPaAdgb8MzSdIneI4HlZMQp90Azu0oi8JdpgHRoBeTsEk828WjKWNZx
	 cpZ+9w/jxFQ9z48/9apKwMEsxZDd/DsCd7g1b3wsG2/bjc9aWwK5eatWs0O509c0z/
	 +a9bmR3iK8dsQ==
Date: Thu, 02 Jul 2026 13:04:45 -0700
Subject: [PATCH 17/18] xfs: cleanup xfs_growfs_compute_deltas
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178302226620.845537.14856515881189534198.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
---
 libxfs/xfs_ag.h |    5 ++---
 libxfs/xfs_ag.c |   42 ++++++++++++++++++++----------------------
 2 files changed, 22 insertions(+), 25 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 8aa4266c55714d..fd22fe59893176 100644
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
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index fb8c9bb3df82ed..2f47a02cc6fdb9 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -861,32 +861,30 @@ xfs_ag_shrink_space(
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

