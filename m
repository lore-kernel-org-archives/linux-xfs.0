Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9597E4A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607389; cv=none; b=jqQr6BTs/13BhTG6l7hR1XLSCCBIw+Wg2pSBPsxy9ndYdSng87/7BZvk4L3AcRFMLQ+r3lpfDsPNsOCB2S31ifhtMG3JQbGEgw5Zhi1G/KfiUr8ixal6yiIyM5WZ+ctGFhiBwChbt4Bc6+nscj3QvRJcYmby6QCqyNGKvYnoNbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607389; c=relaxed/simple;
	bh=TzTzjr8gvSI8+SI41x2IRlFLrZIkK3/MLBH/V/dwNu4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b9ufnuf2VVlgrmcXvIO85qfPnRN19J762edldrkICkW1ocjpSLEsLeb3R+sYkNjpI7TjkP7wFeWWCMg4FM7vuaYDfPh85PHJOtL8QPM/TBLlaAuLafnQjJg6dgHDXAUmUY9a20KKRyYYwKcNoIF2BPerdJkcgBOQ3n3lnlxNj80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ue8WIhnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ue8WIhnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F53C4CEC5;
	Fri, 11 Oct 2024 00:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607389;
	bh=TzTzjr8gvSI8+SI41x2IRlFLrZIkK3/MLBH/V/dwNu4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ue8WIhnKJ+XUl6UB7E3xX8v3a1cY+v+SMCLy6zKdnZGT2C6gS8AZpaRfcWdEMEweS
	 XS0Fwu1uu0/qgdVqZ0725OWyDASxtlxxl5I0RjcJvZ7WVo+uG+E81DqHET2EYi1WX9
	 8ULO2rKHuw4TzoqvSkLdyX4e3+AdGwNHSTTfE58TKJUVUcksjQAjh9Q8PYTivBxlnI
	 smzKiYlg/p3H3queZ/1Kx9pGOjJDgBQkEGoKSR3WXhBse6mbmdwrdOKNDfPC/bst2h
	 UZdQWys6UQc9hFYfsfn8etqBhoJ32f0JSS1axRVoRxd3XtEtkWxCd7z++3HwKXQdHg
	 0WTFIdJpcQYCQ==
Date: Thu, 10 Oct 2024 17:43:09 -0700
Subject: [PATCH 21/25] xfs: pass the pag to the
 trace_xrep_calc_ag_resblks{,_btsize} trace points
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640772.4175438.5532427258392839865.stgit@frogsfrogsfrogs>
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

This requires holding the pag refcount a little longer, but allows for the
decoding to only happen when tracing is actually enabled, and cleans up the
callsites a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |    9 ++++-----
 fs/xfs/scrub/trace.h  |   22 +++++++++++-----------
 2 files changed, 15 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 289adabbbb02a8..337aecdbcb15db 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -331,10 +331,8 @@ xrep_calc_ag_resblks(
 		freelen = aglen;
 		usedlen = aglen;
 	}
-	xfs_perag_put(pag);
 
-	trace_xrep_calc_ag_resblks(mp, sm->sm_agno, icount, aglen,
-			freelen, usedlen);
+	trace_xrep_calc_ag_resblks(pag, icount, aglen, freelen, usedlen);
 
 	/*
 	 * Figure out how many blocks we'd need worst case to rebuild
@@ -372,8 +370,9 @@ xrep_calc_ag_resblks(
 		rmapbt_sz = 0;
 	}
 
-	trace_xrep_calc_ag_resblks_btsize(mp, sm->sm_agno, bnobt_sz,
-			inobt_sz, rmapbt_sz, refcbt_sz);
+	trace_xrep_calc_ag_resblks_btsize(pag, bnobt_sz, inobt_sz, rmapbt_sz,
+			refcbt_sz);
+	xfs_perag_put(pag);
 
 	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
 }
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 992f87f52b7656..0da641f046f3a7 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2189,10 +2189,10 @@ TRACE_EVENT(xrep_findroot_block,
 		  __entry->level)
 )
 TRACE_EVENT(xrep_calc_ag_resblks,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agino_t icount, xfs_agblock_t aglen, xfs_agblock_t freelen,
+	TP_PROTO(const struct xfs_perag *pag, xfs_agino_t icount,
+		 xfs_agblock_t aglen, xfs_agblock_t freelen,
 		 xfs_agblock_t usedlen),
-	TP_ARGS(mp, agno, icount, aglen, freelen, usedlen),
+	TP_ARGS(pag, icount, aglen, freelen, usedlen),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -2202,8 +2202,8 @@ TRACE_EVENT(xrep_calc_ag_resblks,
 		__field(xfs_agblock_t, usedlen)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->icount = icount;
 		__entry->aglen = aglen;
 		__entry->freelen = freelen;
@@ -2218,10 +2218,10 @@ TRACE_EVENT(xrep_calc_ag_resblks,
 		  __entry->usedlen)
 )
 TRACE_EVENT(xrep_calc_ag_resblks_btsize,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t bnobt_sz, xfs_agblock_t inobt_sz,
-		 xfs_agblock_t rmapbt_sz, xfs_agblock_t refcbt_sz),
-	TP_ARGS(mp, agno, bnobt_sz, inobt_sz, rmapbt_sz, refcbt_sz),
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t bnobt_sz,
+		 xfs_agblock_t inobt_sz, xfs_agblock_t rmapbt_sz,
+		 xfs_agblock_t refcbt_sz),
+	TP_ARGS(pag, bnobt_sz, inobt_sz, rmapbt_sz, refcbt_sz),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -2231,8 +2231,8 @@ TRACE_EVENT(xrep_calc_ag_resblks_btsize,
 		__field(xfs_agblock_t, refcbt_sz)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->bnobt_sz = bnobt_sz;
 		__entry->inobt_sz = inobt_sz;
 		__entry->rmapbt_sz = rmapbt_sz;

