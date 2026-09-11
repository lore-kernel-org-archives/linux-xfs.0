Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2669A38757A;
	Fri, 11 Sep 2026 05:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106053; cv=none; b=kmjjLQkR0Il4UgovFRMrb2/edaECuLLPbWzTYKwD6LOaYks/lWUTvPSFeHQYGNlLWSENL9vwzE20ShdBEIurG57UuSOtHhaJQ1h7kL9eSc1XEIfK5BuJwAzPU1o+IbPFt9gNnraqDysAv+e+imBKKLg8fkvDBXDndjstmgyWkj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106053; c=relaxed/simple;
	bh=f+gbMRRi5fYdJbFtI7ppH0ySvwNRA03u80TPmZvpOTg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SO+Qq4JN1zH7bEn0qbWFrfrqU0ne2AAGIA0kVdeFl4tkpVw1dkxEIgS1SotW/Bo2OjXiOmD59cooIfnOpRG+M+2eYV71ENo7CEmXukQdtVMoP9dwZkBn5nQRzlqPb6omQP8AaY1x7e93CxQhqZuPn4G1tlL6bt3pm7mYxtVpA6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SloFOAjN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SloFOAjN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9D7591F000FF;
	Fri, 11 Sep 2026 05:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789106051;
	bh=Y4T4Tieqr4HlNzAHWnMAzda7ntkcPe30MjZxuHX9JJA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=SloFOAjNayy41RzZQHPKwld5/Tyc18GDXu9pdmu+yN8sWE7sNqux5cIBjKqXiycow
	 HStSOP3M6zH9XGgOWeVW/pwlPtCQ4ORnqtuf6dBVp9oQv8PRmSx6sNGTS+3gN+CFPI
	 1J4h14vey7vpDdVYZJFLegWaYeQ+JCe/LSwmEJODsBIU7ijsJ+qeQZotQoHBdU+hmC
	 Di7T2dEAx3dfmO267wWO+5k8LjhlT+GjBek6CvOwoAtQ5mekqUqWphYRMYYabWVwXT
	 Lhi29tb1VJwYqi4i3cI9QgHRSbBjOFdmEIbuwf7JKqFpV4hiRNgq6+45O4BPuoTc76
	 YsatZDg0IeXgA==
Date: Thu, 10 Sep 2026 22:54:11 -0700
Subject: [PATCH 3/6] xfs: use the correct reservations for rtrmap/refcount
 recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178910162084.174887.6554307015098246037.stgit@frogsfrogsfrogs>
In-Reply-To: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that we might reserve the wrong number of blocks for
recovering rtrmap and rtrefcount updates after a crash.  Fix that.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 5e0679d1c62f25 ("xfs: support recovering rmap intent items targetting realtime extents")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_refcount_item.c |    8 ++++++--
 fs/xfs/xfs_rmap_item.c     |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 8bccf89a77668b..682c6e1b45e3ee 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -508,6 +508,7 @@ xfs_refcount_recover_work(
 	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
+	unsigned int			dblocks;
 	bool				isrt = xfs_cui_item_isrt(lip);
 	int				i;
 	int				error = 0;
@@ -543,8 +544,11 @@ xfs_refcount_recover_work(
 	 * full btree split on either end of the refcount range.
 	 */
 	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
-	error = xfs_trans_alloc(mp, &resv, mp->m_refc_maxlevels * 2, 0,
-			XFS_TRANS_RESERVE, &tp);
+	if (isrt)
+		dblocks = mp->m_rtrefc_maxlevels * 2;
+	else
+		dblocks = mp->m_refc_maxlevels * 2;
+	error = xfs_trans_alloc(mp, &resv, dblocks, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 2a3a73a8566d11..000cff1ce324f0 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -573,6 +573,7 @@ xfs_rmap_recover_work(
 	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
+	unsigned int			dblocks;
 	bool				isrt = xfs_rui_item_isrt(lip);
 	int				i;
 	int				error = 0;
@@ -596,8 +597,11 @@ xfs_rmap_recover_work(
 	}
 
 	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
-	error = xfs_trans_alloc(mp, &resv, mp->m_rmap_maxlevels, 0,
-			XFS_TRANS_RESERVE, &tp);
+	if (isrt)
+		dblocks = mp->m_rtrmap_maxlevels;
+	else
+		dblocks = mp->m_rmap_maxlevels;
+	error = xfs_trans_alloc(mp, &resv, dblocks, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
 

