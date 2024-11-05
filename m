Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9154D1F667B
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844686; cv=none; b=uQIC4o+xHnsGOOCh8QJmhMqB40KndNdeqYo5yuU42mWVntEbvZkm5z8eCTNSvUycdG/D7XRdU5xGIvEFa9XhVvyM1SV6+eB1odFudCm9Xi3Yl0+VuXAFIvrXgk46q+ImJteDYVLCAh1ghmjuDFZwHHjbLy2IO6P6/0qBDbzbYnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844686; c=relaxed/simple;
	bh=BtOJkkhfrl2cvbskGUmm5t0NMosMSjbUQ9IY7xbnWRc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pFHYO76aYTmhRuc8jzUlcEI9EDaBNYsjJIFgaC8L/YQo1rN/UztDF/LwXy9q/IXycKBGDBZoQ9awdFCIpuc6f4ASk0xSUPuCajNdy5RYqqs0Pwol7ztxmtQvj2AnAhyyV++Px8LPUmsW1i9VVcCaawYW0ZT3bmuuUldkl7QJM4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SqTKYoTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SqTKYoTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32979C4CECF;
	Tue,  5 Nov 2024 22:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844686;
	bh=BtOJkkhfrl2cvbskGUmm5t0NMosMSjbUQ9IY7xbnWRc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SqTKYoTz59+RvpuRrcEKJjvmyvJv3qrLYOfhRFiCg8UQKO7GTW6+W0+CRwgyeQsmG
	 7ujWvB3NAUkkTORKafjOV4PMZpb/A8RwjySPJ8s0kGgSrMVurbL3xjSjapjaiJ8xfq
	 TnGVeSdxsDSOw5/fJuv0dInT3kfTelo+I4gqQ65Jvwwl7K+O8NOtmhPalU4G9MZ/8C
	 U0GZPfLIBY0UIJrSTMrdm27wY/p6zACjjVvJ+fO+pKxBxaaJg21GBaFDX5cPzzETnR
	 ORcbRaJm0YV1CN2UNHm0tHwb2Py+NHwT/Qft8eKJAqc+Cr34wjk6pFOppA2azvDDd5
	 jXDkzXVn1rWew==
Date: Tue, 05 Nov 2024 14:11:25 -0800
Subject: [PATCH 19/23] xfs: pass the pag to the
 trace_xrep_calc_ag_resblks{,_btsize} trace points
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394777.1868694.735868572924028203.stgit@frogsfrogsfrogs>
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
index 382092a6ea6410..47f9b04e3798f1 100644
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

