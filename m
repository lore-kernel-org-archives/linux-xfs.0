Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E846C1D86E4
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191019; cv=none; b=JYHvAZWisViHIGP4kiC0cKyRI00d/z0/dsWOsdMcUfS/HxMk1WXVjwnkqHRMCi89L8veGQfqgOpa723b1hXTDr4HxCyt1VbILv1aJPkmlN4H/7Zp1CvkSXqH1vfcXwM3ZgKluFr3rVsfhaVAh9vhoF3LCDkZjcdqGx4cES+arts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191019; c=relaxed/simple;
	bh=8cxDpIj5W1QyyLnSy15+jFPNqbyGZ7J+uVX+IB/+b1U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pm+6JC/cNVoNyoDAD+F6VfCVX5UpYgQdtHlI2QJgqPN/Bih9rNq1OlJwIb9NeWvito6qTKRUw8V2RLhUd0kHuej1VGpSFYxblyrXwgHdOXGemnYyYJjcBm8V7Dty5X0I+BkBwAuxWDQzZgl3WBZ9KlSAg5FifH+cwNg4mEgbhhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eHS3w5cm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eHS3w5cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9ADDC4CEC3;
	Thu, 17 Oct 2024 18:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191018;
	bh=8cxDpIj5W1QyyLnSy15+jFPNqbyGZ7J+uVX+IB/+b1U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eHS3w5cmXUSZjI5BADhF2Dqu9QC31rtI527aIydE9Wn8f1LujAx7vSgqbp3VAg8T0
	 1p+4FKhCf5Efxv/U5suIdTSlFayV1kp4FLILA+MqNTyI4I4lX6C7aWEll56V8W1afh
	 HPUWSoe7qFB5VQ31TKFTtAOOZe/vKvJmXtfVJxsy6baPywyZmGFngorNjLd0kRl01a
	 HdNraBsQLhKtGrkmbjD64F4pTS51nbCms7KQl6QJbDBENrPzeIdCKmDjX71k0jYi71
	 8V0BjAIxKpPtuDX+UBoptH9as0e5Urb1GQER/mKGGahSk4lkr9H/9EAoQDvjT1Ox4q
	 fZDMuHERnwacw==
Date: Thu, 17 Oct 2024 11:50:18 -0700
Subject: [PATCH 14/22] xfs: pass a perag structure to the
 xfs_ag_resv_init_error trace point
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068102.3449971.1874306830464302793.stgit@frogsfrogsfrogs>
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
index b85e75712a3ebe..a4f37738ae957a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3144,11 +3144,10 @@ DEFINE_AG_RESV_EVENT(xfs_ag_resv_free_extent);
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
@@ -3156,8 +3155,8 @@ DECLARE_EVENT_CLASS(xfs_ag_error_class,
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
@@ -3168,13 +3167,6 @@ DECLARE_EVENT_CLASS(xfs_ag_error_class,
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

