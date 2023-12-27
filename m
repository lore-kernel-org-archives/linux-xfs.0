Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A699634
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/hjXyjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18A3C433C7;
	Mon,  1 Jan 2024 00:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067502;
	bh=9gmdVBdN1ZTxMH+7C3rsNXTwFH5jTym4DgU3IA22y2Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T/hjXyjdwwmsmo5a3Y+NiJuHdSc6nhr5BhWoSK5WeR5SYcOO0EahsSLDmq233sMT+
	 cLt8ntA/EiUQQB86cu8eqjFs4KMvftSwhV3MdIiBZAJtE1FOeeQSTjq3IDaKGP9+Og
	 injJBvgCDV0ArDVjz4AFtMZqpGICvKpEA8xTyFGUnSGOKGqhPOnFYZHedcNypJjQpa
	 5SZH0vwFxqdSlJsZed+M4sWtvAou4dkDBQChLirmX314MsGGDY4/CV6iskbc70s+xw
	 b/hXb8M5f6YpclRCvTeyf+ewzrA60qG5aliobxzXx1e5PTQZCDW18YFQjjIHHXyqrZ
	 yPTJtczu5IGdg==
Date: Sun, 31 Dec 2023 16:05:02 +9900
Subject: [PATCH 1/2] xfs: simplify xfs_ag_resv_free signature
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013714.1813633.3720310586907142681.stgit@frogsfrogsfrogs>
In-Reply-To: <170405013700.1813633.7627597760064686124.stgit@frogsfrogsfrogs>
References: <170405013700.1813633.7627597760064686124.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

It's not possible to fail at increasing fdblocks, so get rid of all the
error returns here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h  |    1 -
 libxfs/xfs_ag.c      |    4 +---
 libxfs/xfs_ag_resv.c |   22 +++++-----------------
 libxfs/xfs_ag_resv.h |    2 +-
 4 files changed, 7 insertions(+), 22 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index b3240213364..08ec51fc799 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -269,7 +269,6 @@
 #define trace_xfs_ag_resv_critical(...)		((void) 0)
 #define trace_xfs_ag_resv_needed(...)		((void) 0)
 #define trace_xfs_ag_resv_free(...)		((void) 0)
-#define trace_xfs_ag_resv_free_error(...)	((void) 0)
 #define trace_xfs_ag_resv_init(...)		((void) 0)
 #define trace_xfs_ag_resv_init_error(...)	((void) 0)
 #define trace_xfs_ag_resv_alloc_extent(...)	((void) 0)
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index ddd5584f23e..f22d58ad040 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -942,9 +942,7 @@ xfs_ag_shrink_space(
 	 * Disable perag reservations so it doesn't cause the allocation request
 	 * to fail. We'll reestablish reservation before we return.
 	 */
-	error = xfs_ag_resv_free(pag);
-	if (error)
-		return error;
+	xfs_ag_resv_free(pag);
 
 	/* internal log shouldn't also show up in the free space btrees */
 	error = xfs_alloc_vextent_exact_bno(&args,
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 3a80b1613e1..542740bb850 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -125,14 +125,13 @@ xfs_ag_resv_needed(
 }
 
 /* Clean out a reservation */
-static int
+static void
 __xfs_ag_resv_free(
 	struct xfs_perag		*pag,
 	enum xfs_ag_resv_type		type)
 {
 	struct xfs_ag_resv		*resv;
 	xfs_extlen_t			oldresv;
-	int				error;
 
 	trace_xfs_ag_resv_free(pag, type, 0);
 
@@ -148,30 +147,19 @@ __xfs_ag_resv_free(
 		oldresv = resv->ar_orig_reserved;
 	else
 		oldresv = resv->ar_reserved;
-	error = xfs_mod_fdblocks(pag->pag_mount, oldresv, true);
+	xfs_mod_fdblocks(pag->pag_mount, oldresv, true);
 	resv->ar_reserved = 0;
 	resv->ar_asked = 0;
 	resv->ar_orig_reserved = 0;
-
-	if (error)
-		trace_xfs_ag_resv_free_error(pag->pag_mount, pag->pag_agno,
-				error, _RET_IP_);
-	return error;
 }
 
 /* Free a per-AG reservation. */
-int
+void
 xfs_ag_resv_free(
 	struct xfs_perag		*pag)
 {
-	int				error;
-	int				err2;
-
-	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
-	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
-	if (err2 && !error)
-		error = err2;
-	return error;
+	__xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
+	__xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
 }
 
 static int
diff --git a/libxfs/xfs_ag_resv.h b/libxfs/xfs_ag_resv.h
index b74b210008e..ff20ed93de7 100644
--- a/libxfs/xfs_ag_resv.h
+++ b/libxfs/xfs_ag_resv.h
@@ -6,7 +6,7 @@
 #ifndef __XFS_AG_RESV_H__
 #define	__XFS_AG_RESV_H__
 
-int xfs_ag_resv_free(struct xfs_perag *pag);
+void xfs_ag_resv_free(struct xfs_perag *pag);
 int xfs_ag_resv_init(struct xfs_perag *pag, struct xfs_trans *tp);
 
 bool xfs_ag_resv_critical(struct xfs_perag *pag, enum xfs_ag_resv_type type);

