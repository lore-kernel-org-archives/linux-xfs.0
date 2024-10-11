Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B1710F9
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607343; cv=none; b=roFOo/KgPAseAW775DaWzz4yImeSTxG+KlDyB4Si6v2/YHlMTR5dn4XBkYIuPYF8Ct3G/BjoLLwf7LDTsTkQ3ZItLtm6IRpqmdJ+AyuF1xzmn+IgJCgcxwXpYAZAV78Ivrqf6jJ3MIU7vXN298ITEKkKjEN0cYp3WylyinR2LTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607343; c=relaxed/simple;
	bh=ZG+pqaP13BU4uOm1ywVM75JJ1SW0++pTBZrwKsdK+MA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TJh1y+jDQkAQB23tTnR6uIEZC4hij4rfJrrp0UdoLB9W0irav2v7jrkEmXQVudpJosw8t7Tci/MX9AsvcU7b2N8Hou2wNR20HZRP79yb5bJQjISS67FwY5arn2317tYe1QN8aiQ3F7HvTP8pgre52fRCRaYtGcpvP7Pl1XQopOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Awn9tlWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Awn9tlWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FAAC4CEC5;
	Fri, 11 Oct 2024 00:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607342;
	bh=ZG+pqaP13BU4uOm1ywVM75JJ1SW0++pTBZrwKsdK+MA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Awn9tlWibBd5VEXoahw71tinfETLVML2DamvkwzWqHl/I5JsCV52R2OWesH1/TRIj
	 ctTKKqV/lR53gDem1tlKkoAcfjbFkVCEJVhNdutjre04O1tuNOKi2QtvZ3xL0JNjLA
	 03+kR7MzqUSOmU2KfWWmFf6Ul/9snumlqMciyghMeo+4f9rMrwSh5qJU10OUSZe0IX
	 6KgONdXqAQ/T/gX1Q9FXykQSPr8rWb6JsOs4t0U0l+xrdywLoyP/Ub3nVP2aQ1+heO
	 rkev/6Hc5vSvio+SmsTecMjuHBVci5JQYDOtcOF8L0oirhcMxQxFSaWwpFbqnZTljv
	 2aj/dlzlsTY9Q==
Date: Thu, 10 Oct 2024 17:42:22 -0700
Subject: [PATCH 18/25] xfs: pass objects to the xfs_irec_merge_{pre,post}
 trace points
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640721.4175438.13052410236743928317.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

