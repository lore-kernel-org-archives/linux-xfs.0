Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D087485
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052074; cv=none; b=AX+P99B2Z3sgmbSPHCMwpinIA1i2xARJ91S6YGQCpkRqpuVRaF1P9DRRZkoI6Nbg1mhVXE4wtBr3z1lODG5cm8aEDDxO+vWntlCvI6+lq7p0lxTyzRQBxsjl+++W0vidum/ADGo4dRkyZ6S8TekaFRuIW3xppl4BTo+XkaWjNks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052074; c=relaxed/simple;
	bh=HEPXTZQQLHNyjKw6dkmYpyvLRXBwiZfkie4oTOaJ2AQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ijFvE/jJEmOEBFLELji5/4raOazueRUHnfLDUax04hu62XB6M3BTtb7NSdvNSO4jRGqXnywr453NK66gU8k38bnhaFRA+1poTi3BMTxaOpX3YW7BLlC4kRqYX0+gJGcuqFbK7OkJzfyW9xwlJs5nxKRtSAYuhghVqrCnrDXiwVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s/k5link; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s/k5link"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5183DC4CED3;
	Fri, 13 Dec 2024 01:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052074;
	bh=HEPXTZQQLHNyjKw6dkmYpyvLRXBwiZfkie4oTOaJ2AQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s/k5link5wK+AohRJdUYm44MOxndRFxCuqLatZbdIVoMP/sqLn4Vgap76vfEbp83s
	 +5nNMBRwEaP9pET25GD4+Wja0Q3euPeRiq5WyblKfHcx3WqsYeFYvakaJKE5LaF0f0
	 s6xO+nkjlmsPdWHjyeKGB4dP9d7G+LEIl22wAxKCCAzuJwb5kqx1IE+BpqXgPKljF+
	 PdwLIXbhtfz5fFtn9+0XAyP+wcnt2V7jvF39I4nIsyVVXGwyydUZoE7o5oJpMH2N2m
	 IQDLOYtd02BpUCjvsKdiT6dBzBtzDYTnb4oWZhQt1q4kbuiYQzhTykFG+QlTIS5G1y
	 iDBlsKbpTjf/w==
Date: Thu, 12 Dec 2024 17:07:53 -0800
Subject: [PATCH 28/37] xfs: repair inodes that have realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123795.1181370.12023276963649602828.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Plumb into the inode core repair code the ability to search for extents
on realtime devices.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/inode_repair.c |   58 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index a94f9df0ca78f6..816e81330ffc99 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -38,6 +38,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -773,17 +775,71 @@ xrep_dinode_count_ag_rmaps(
 	return error;
 }
 
+/* Count extents and blocks for an inode given an rt rmap. */
+STATIC int
+xrep_dinode_walk_rtrmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_inode		*ri = priv;
+	int				error = 0;
+
+	if (xchk_should_terminate(ri->sc, &error))
+		return error;
+
+	/* We only care about this inode. */
+	if (rec->rm_owner != ri->sc->sm->sm_ino)
+		return 0;
+
+	if (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))
+		return -EFSCORRUPTED;
+
+	ri->rt_blocks += rec->rm_blockcount;
+	ri->rt_extents++;
+	return 0;
+}
+
+/* Count extents and blocks for an inode from all realtime rmap data. */
+STATIC int
+xrep_dinode_count_rtgroup_rmaps(
+	struct xrep_inode	*ri,
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	int			error;
+
+	error = xrep_rtgroup_init(sc, rtg, &sc->sr, XFS_RTGLOCK_RMAP);
+	if (error)
+		return error;
+
+	error = xfs_rmap_query_all(sc->sr.rmap_cur, xrep_dinode_walk_rtrmap,
+			ri);
+	xchk_rtgroup_btcur_free(&sc->sr);
+	xchk_rtgroup_free(sc, &sc->sr);
+	return error;
+}
+
 /* Count extents and blocks for a given inode from all rmap data. */
 STATIC int
 xrep_dinode_count_rmaps(
 	struct xrep_inode	*ri)
 {
 	struct xfs_perag	*pag = NULL;
+	struct xfs_rtgroup	*rtg = NULL;
 	int			error;
 
-	if (!xfs_has_rmapbt(ri->sc->mp) || xfs_has_realtime(ri->sc->mp))
+	if (!xfs_has_rmapbt(ri->sc->mp))
 		return -EOPNOTSUPP;
 
+	while ((rtg = xfs_rtgroup_next(ri->sc->mp, rtg))) {
+		error = xrep_dinode_count_rtgroup_rmaps(ri, rtg);
+		if (error) {
+			xfs_rtgroup_rele(rtg);
+			return error;
+		}
+	}
+
 	while ((pag = xfs_perag_next(ri->sc->mp, pag))) {
 		error = xrep_dinode_count_ag_rmaps(ri, pag);
 		if (error) {

