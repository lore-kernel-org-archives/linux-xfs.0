Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471181EC006
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844624; cv=none; b=Mv3nIfs/BX0hZkQAtNKRwqmDPy1onPwv/nkWzj4iv43B658rgfNcGq0YYIql7zXHgmlH7Hs1UdPboWVgTpj8cvlLpEA4ihbSKS3Og1x3BkABfBqMayTFx0Hncesq0cW4d5uMucGIj30tPZmvTZYpme3x7kGNcYdBkC0f9kiVBuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844624; c=relaxed/simple;
	bh=uXlRcZ5J8dJdIpS7pmHNVQa+HMw+6t9jGuDpZdV6+Rc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ms22GD4HL+qE6Zixy414E7dj3B2b7CCBsjy89YfP4z7pYPahXeRMxKby7uDSq7PwOSMGWuE28xFuGYN+sca21Nh7713t7uEM4CqBMyDE0WqqP6EdTy7vA95ohVDKeGJO95FVrCDqWSiplJQikp+8Gr/STIbzirbevBYhJPerGkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQN9bo1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQN9bo1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0070C4CECF;
	Tue,  5 Nov 2024 22:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844623;
	bh=uXlRcZ5J8dJdIpS7pmHNVQa+HMw+6t9jGuDpZdV6+Rc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AQN9bo1xvUTQrysjBYNpBfD097kWeazW+Rd6m+iu8AL/BYrlLIutLIruwpKdTS8eJ
	 g6+xveVGLU7CzqFbG2gRLz2PnPgsrKRxeSc+oktS1hYGlCZZ6hRY01Tp0AZYPOX4Rz
	 l+0ArJCwR2vEbcnhojbCkUScGLwiGPwF9B6uIOPGHJ/MRpdz6wHwP+QLFVDO9zAqOu
	 kUBzzDd3XEhaih7WSeUXQxZomcwx/leEpFormeowCbwDum4pCTLqor7J+SG4cp/ecN
	 QK1MQLOhxjg478CvraieJpEWT9srOocdQQsf4B596jL+OPkup2I4vx1pPsWCi7qQ1W
	 Xtc42OvAG2uzQ==
Date: Tue, 05 Nov 2024 14:10:23 -0800
Subject: [PATCH 15/23] xfs: pass a perag structure to the
 xfs_ag_resv_init_error trace point
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394708.1868694.1674583518761912707.stgit@frogsfrogsfrogs>
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

And remove the single instance class indirection for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag_resv.c |    3 +--
 fs/xfs/xfs_trace.h          |   18 +++++-------------
 2 files changed, 6 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 216423df939e5c..4b1bd7cc7ba28c 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -206,8 +206,7 @@ __xfs_ag_resv_init(
 	else
 		error = xfs_dec_fdblocks(mp, hidden_space, true);
 	if (error) {
-		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
-				error, _RET_IP_);
+		trace_xfs_ag_resv_init_error(pag, error, _RET_IP_);
 		xfs_warn(mp,
 "Per-AG reservation for AG %u failed.  Filesystem may run out of space.",
 				pag->pag_agno);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c5128b151dbfce..14fb86daea61bf 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3139,11 +3139,10 @@ DEFINE_AG_RESV_EVENT(xfs_ag_resv_free_extent);
 DEFINE_AG_RESV_EVENT(xfs_ag_resv_critical);
 DEFINE_AG_RESV_EVENT(xfs_ag_resv_needed);
 
-/* simple AG-based error/%ip tracepoint class */
-DECLARE_EVENT_CLASS(xfs_ag_error_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int error,
+TRACE_EVENT(xfs_ag_resv_init_error,
+	TP_PROTO(const struct xfs_perag *pag, int error,
 		 unsigned long caller_ip),
-	TP_ARGS(mp, agno, error, caller_ip),
+	TP_ARGS(pag, error, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -3151,8 +3150,8 @@ DECLARE_EVENT_CLASS(xfs_ag_error_class,
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
@@ -3163,13 +3162,6 @@ DECLARE_EVENT_CLASS(xfs_ag_error_class,
 		  (char *)__entry->caller_ip)
 );
 
-#define DEFINE_AG_ERROR_EVENT(name) \
-DEFINE_EVENT(xfs_ag_error_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int error, \
-		 unsigned long caller_ip), \
-	TP_ARGS(mp, agno, error, caller_ip))
-DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
-
 /* refcount tracepoint classes */
 
 DECLARE_EVENT_CLASS(xfs_refcount_class,

