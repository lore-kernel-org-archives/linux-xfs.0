Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAB019ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527988; cv=none; b=s68dw69LoMHbmhmIA+ptIZEKeWMIjv3o1vCDJnmANgSiQXbZONtc7ZLWDNahnRySQb/jVciMpRb0kNym23sWG1jylvOE+1zC746ud+H7WQ8clNyZMZj7XTiD7xUATDt/4bSn8T6YkoUFsbotTaJZtS463SGoxKEAlK9tRy1TstE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527988; c=relaxed/simple;
	bh=NGvDRMBLvP9BJGTwSqiDYz4TMwxEiPGpkTwPVPUp7RQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z4FFp03MHjI4Yry+N9khUFiIRHM56GTQD7SKEadCMZk1WWuZ50SWWoJApaqfc6Gs7FVd/ZTOx687FVCBlllYfig1O7vpry2ic/0WUVR3ThqqOsx4ITxBiM9/JDFOfm4XJJ/ozRkrO8SPeiUH4/8DEBaQcWjcK8kc8ZpgAUup9tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQ3E93Zi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQ3E93Zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D19C4CED1;
	Fri,  6 Dec 2024 23:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527988;
	bh=NGvDRMBLvP9BJGTwSqiDYz4TMwxEiPGpkTwPVPUp7RQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IQ3E93ZiewGb7wFWcZ8fIId7CeBfhEApjmNOHhnkcuYkBDmn66M+sv+QAX0z8cL19
	 fmFcZp4k0WqdbNIbBftORK4oYVcGIu3UpoesGAN1SoKLV8qgEtmhS0+DQmel6e5JwD
	 GjSJA9k2tdmhNihspkOuLTOzoEQSsqesILpnjAKhNL85B3/l/o2asXdAzVZ+NP5hKC
	 ch6epBItEUe2MICaxKE9Z1bRHM6eCONbVY8PYomrDGE3v6btRzkijHF35wm4ay4FEJ
	 dFxwAV2ctzKjdSs/FIsb0LiaFmB86RPTeFoONtF5lVQsCbMwcr56boiKg8keBF3z4X
	 NGLloMpI0CS1g==
Date: Fri, 06 Dec 2024 15:33:08 -0800
Subject: [PATCH 11/36] xfs: pass objects to the xfs_irec_merge_{pre,post}
 trace points
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747050.121772.11443088190171169129.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 487092ceaa72448ca3a82ea9fb89768c88f6abec

Pass the perag structure and the irec to these tracepoints so that the
decoding is only done when tracing is actually enabled and the call sites
look a lot neater.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h |    4 ++--
 libxfs/xfs_ialloc.c |    7 ++-----
 2 files changed, 4 insertions(+), 7 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index ba51419b3df3d3..0986e1621437d4 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -85,8 +85,8 @@
 #define trace_xfs_alloc_read_agf(a,b)		((void) 0)
 #define trace_xfs_read_agi(a,b)			((void) 0)
 #define trace_xfs_ialloc_read_agi(a,b)		((void) 0)
-#define trace_xfs_irec_merge_pre(a,b,c,d,e,f)	((void) 0)
-#define trace_xfs_irec_merge_post(a,b,c,d)	((void) 0)
+#define trace_xfs_irec_merge_pre(...)		((void) 0)
+#define trace_xfs_irec_merge_post(...)		((void) 0)
 
 #define trace_xfs_iext_insert(a,b,c,d)		((void) 0)
 #define trace_xfs_iext_remove(a,b,c,d)		((void) 0)
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 01b2e2d8c27c22..b3d6f7f4212588 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -601,15 +601,12 @@ xfs_inobt_insert_sprec(
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

