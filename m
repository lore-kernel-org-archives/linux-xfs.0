Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8252C1D86E4
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191029; cv=none; b=JrxCdzmvFHeRLftqEZHwahDsx08WCV3WnkSv7NW1P4A3B23974VQmG9rywqpmdacvuP4JrLteOZGGjku1+4hMOwNcYHnK6+aWm7dTebQO7CHGoUOoyPtn8uYowIBg85zj4PoCuI92Q0IEJOHFQHRQNScjBqxrDn0SsQ7ZRqjYrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191029; c=relaxed/simple;
	bh=ZG+pqaP13BU4uOm1ywVM75JJ1SW0++pTBZrwKsdK+MA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WUwAlVtQouiEFhCkGfzBkIOB6S6OOgNI3EuBqt8C29b90Qbk8uEkd9vuE92+Qma74dK3blnQP/qX6w8htiop70fea05A1/zl10LFdUebvVQ78BNRwLmlbxhaUThJTa+gIF+bsg6X8cfzhigb1V4iLQhKiry+fpMNdmXs0XuSOz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nfF6yyWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nfF6yyWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4C8C4CEC3;
	Thu, 17 Oct 2024 18:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191029;
	bh=ZG+pqaP13BU4uOm1ywVM75JJ1SW0++pTBZrwKsdK+MA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nfF6yyWilEihNElLBWA0bnjRdoCfwk8vVWaUb7X0kyJ/YDIzNdjF+EY8K/VTy0iZw
	 0A9/5lW+wtwgHKKJ3QxXfDw28BtbC68xN0gJ0p64iFaDCeP7Lj9IT2A/HygtEP6lrZ
	 W8w+9vcH7ZkTPSonqOG+qpjnNADx25MeC7q1gapT0KXjal2foL4whUCsPRwZj+hkn7
	 +fV8sU1eN/fdcqoyNP+vQaaLAED4ISejGhnzE4J/KAZmxmL8YqMoTsxtADjXyXLZaa
	 PNW1cEni0iKm1HZEMBizk3bu2DxUMgOPiYLffRk0IJDORsti1oyoD6MxmQSQgDW81C
	 Xn1qKeex7Eitg==
Date: Thu, 17 Oct 2024 11:50:28 -0700
Subject: [PATCH 15/22] xfs: pass objects to the xfs_irec_merge_{pre,post}
 trace points
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068120.3449971.15621871276683278177.stgit@frogsfrogsfrogs>
In-Reply-To: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
References: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
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
index a4f37738ae957a..43cc59bdf1c31e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -899,9 +899,10 @@ TRACE_EVENT(xfs_iomap_prealloc_size,
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
@@ -911,12 +912,12 @@ TRACE_EVENT(xfs_irec_merge_pre,
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
@@ -928,9 +929,9 @@ TRACE_EVENT(xfs_irec_merge_pre,
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
@@ -938,10 +939,10 @@ TRACE_EVENT(xfs_irec_merge_post,
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

