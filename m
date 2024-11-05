Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D892A1EC006
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844639; cv=none; b=EHTGEkJonlF8xmK59TYQo0ENnKoVIgUjS8J3rEqUZUy4Mztl9a7HZUMQrNLbd+FPQLFny+c5707qV1KWukzqKUaWUZkklGgOOArI1gwvLLg0TyNoDM/8bWm9VyZ6U3O3pXeb0OsyhnoqJsjaOAY5X+5ZuOwqv5UbHhuWm4i3gJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844639; c=relaxed/simple;
	bh=igZ3gvF13glVSZEEEcaqIWAuDsv2wZnznzkyqagURjg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EIdyVdrFpLs4tnVxn+fwmwE+O5oyyo/jVvf9Sl3fmxrfVJpSRVQtK+Tof/C594vRP5F9VymI3UVf8eqSHNH2MDyfjh/2XLyzOmQLdyuvK49T9+GPmUtfoEcblWzepBbuZ0UySVPcWW51g52FCb/XiDfQz4z95c4XLVGegrTnl2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mrqiOcyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mrqiOcyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6293BC4CECF;
	Tue,  5 Nov 2024 22:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844639;
	bh=igZ3gvF13glVSZEEEcaqIWAuDsv2wZnznzkyqagURjg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mrqiOcyDTNorOJL1dfZOj6Tsx8qplLZcKFtpLZJ3r+8oJXCsIQLrN4huokWc4OQpU
	 FC0zP0NRCoihpkOqOiyuVAIp2XIp07/0/ZW7BTDR+u5ZR/L5pbSiG/eBxOzeKGOeH5
	 SuHAcY1iTeY5zr1+7/RmHUM+ZCv7+u7O9W9g+wayd7IDVZujAIOqrM58uwBbaBtAqk
	 vK2yppMypZyrlcPCu9PWYRLVkEm1h0sk/2s+0MhReNl1MSq4Alr51cslycWOaCxHqB
	 aDhgd05ThsqjJFgQrzguWddRKXPX+/O9BRjw8N2ci9xYg4lSuKSdSjCZLU2LxvCsdM
	 AryN5IChzNuyA==
Date: Tue, 05 Nov 2024 14:10:38 -0800
Subject: [PATCH 16/23] xfs: pass objects to the xfs_irec_merge_{pre,post}
 trace points
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394725.1868694.10286866643558730353.stgit@frogsfrogsfrogs>
In-Reply-To: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
References: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Pass the perag structure and the irec to these tracepoints so that the
decoding is only done when tracing is actually enabled and the call sites
look a lot neater.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c |    7 ++-----
 fs/xfs/xfs_trace.h         |   33 +++++++++++++++++----------------
 2 files changed, 19 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index c072317a0fe514..085032443f1267 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -606,15 +606,12 @@ xfs_inobt_insert_sprec(
 		goto error;
 	}
 
-	trace_xfs_irec_merge_pre(mp, pag->pag_agno, rec.ir_startino,
-				 rec.ir_holemask, nrec->ir_startino,
-				 nrec->ir_holemask);
+	trace_xfs_irec_merge_pre(pag, &rec, nrec);
 
 	/* merge to nrec to output the updated record */
 	__xfs_inobt_rec_merge(nrec, &rec);
 
-	trace_xfs_irec_merge_post(mp, pag->pag_agno, nrec->ir_startino,
-				  nrec->ir_holemask);
+	trace_xfs_irec_merge_post(pag, nrec);
 
 	error = xfs_inobt_rec_check_count(mp, nrec);
 	if (error)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 14fb86daea61bf..efd89d79dff2b6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -894,9 +894,10 @@ TRACE_EVENT(xfs_iomap_prealloc_size,
 )
 
 TRACE_EVENT(xfs_irec_merge_pre,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agino_t agino,
-		 uint16_t holemask, xfs_agino_t nagino, uint16_t nholemask),
-	TP_ARGS(mp, agno, agino, holemask, nagino, nholemask),
+	TP_PROTO(const struct xfs_perag *pag,
+		 const struct xfs_inobt_rec_incore *rec,
+		 const struct xfs_inobt_rec_incore *nrec),
+	TP_ARGS(pag, rec, nrec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -906,12 +907,12 @@ TRACE_EVENT(xfs_irec_merge_pre,
 		__field(uint16_t, nholemask)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->agino = agino;
-		__entry->holemask = holemask;
-		__entry->nagino = nagino;
-		__entry->nholemask = holemask;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->agino = rec->ir_startino;
+		__entry->holemask = rec->ir_holemask;
+		__entry->nagino = nrec->ir_startino;
+		__entry->nholemask = nrec->ir_holemask;
 	),
 	TP_printk("dev %d:%d agno 0x%x agino 0x%x holemask 0x%x new_agino 0x%x new_holemask 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -923,9 +924,9 @@ TRACE_EVENT(xfs_irec_merge_pre,
 )
 
 TRACE_EVENT(xfs_irec_merge_post,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agino_t agino,
-		 uint16_t holemask),
-	TP_ARGS(mp, agno, agino, holemask),
+	TP_PROTO(const struct xfs_perag *pag,
+		 const struct xfs_inobt_rec_incore *nrec),
+	TP_ARGS(pag, nrec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -933,10 +934,10 @@ TRACE_EVENT(xfs_irec_merge_post,
 		__field(uint16_t, holemask)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->agino = agino;
-		__entry->holemask = holemask;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->agino = nrec->ir_startino;
+		__entry->holemask = nrec->ir_holemask;
 	),
 	TP_printk("dev %d:%d agno 0x%x agino 0x%x holemask 0x%x",
 		  MAJOR(__entry->dev),

