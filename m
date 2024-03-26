Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC65D1C6A8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422279; cv=none; b=Dxz457dru29UOlQwqpWaWbVfrQXWEvCzlnq7c5060JXgis5L4NCBqugED2avEbdFALGhpilkage5cZzMapzvOSo0q3tdWAc5agLcYJvnA609KBu/QHpYFoLEhw+/HjNjQvMl40oxV1vfIEQ6kQ0buGcb41IrG/CVuT7LI8pixN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422279; c=relaxed/simple;
	bh=E8y9VMqoiBZiuSHwppcbB1x1psX5IIkCuuN0ubcE6wk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XcJ5cCYt3iIAQWD2PtP90FzzktHi+rnFBno0lz0CtVDlIfG94Y3ghgslK4tDLglRGTbwj7HiDRwBAMJgTjfr7NgiyJqz6dClRBE24i+DqAlXpqU1p7Yi5/VleprmY9X9GbaDEE+LXX6YHEumx7USJSSKbYG488gWmo+dRol3ljI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqU27/dA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqU27/dA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E30C433C7;
	Tue, 26 Mar 2024 03:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422279;
	bh=E8y9VMqoiBZiuSHwppcbB1x1psX5IIkCuuN0ubcE6wk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UqU27/dA69bPEnrvuzMIY8MOwStgwpCO1n76cj2RsvjohHPdvKnyokRcBN2vqJvSs
	 BxMTWKckD/s8DMZ+PSmgwrN6Mn6J2ZD26wFt8p0RhB8qjlQyp/xy6XBt0r6wtHaKb1
	 llhUGbeOn77n1xEqsKW9Hyj8n+1Vr902BSfPbhWGri2fsY2gbPLhUOMBFPrskqZq1L
	 vdk08lGu5QSs8w+2m+8qSzwnCSLagyi0agTFavlVdVaIWUy4Q5f3QYP//9dJqWzYRi
	 dEb7oYA13hURuT58gQZcE6us4BeYiJx4TSkJ2GAdFsPaCoLEc/SDW+wo+7emRXTYef
	 nlWic0s+vi5Ow==
Date: Mon, 25 Mar 2024 20:04:39 -0700
Subject: [PATCH 07/67] xfs: use xfs_defer_create_done for the relogging
 operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127064.2212320.8721555101626987750.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: bd3a88f6b71c7509566b44b7021581191cc11ae3

Now that we have a helper to handle creating a log intent done item and
updating all the necessary state flags, use it to reduce boilerplate in
the ->iop_relog implementations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 include/xfs_trans.h |    2 +-
 libxfs/xfs_defer.c  |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 8371bc7e8a43..ee250d521118 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -158,7 +158,7 @@ libxfs_trans_read_buf(
 }
 
 #define xfs_log_item_in_current_chkpt(lip)	(false)
-#define xfs_trans_item_relog(lip, tp)		(NULL)
+#define xfs_trans_item_relog(lip, dontcare, tp)	(NULL)
 
 /* Contorted mess to make gcc shut up about unused vars. */
 #define xlog_grant_push_threshold(log, need)    \
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 1be9554e1b86..43117099cc4c 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -495,7 +495,11 @@ xfs_defer_relog(
 
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
-		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
+
+		xfs_defer_create_done(*tpp, dfp);
+		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent,
+				dfp->dfp_done, *tpp);
+		dfp->dfp_done = NULL;
 	}
 
 	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)

