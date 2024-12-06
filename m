Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F068819ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528036; cv=none; b=VGO+XWfVWBd/S0FZUXJImsOI6igTXy8W3hVo+m8qGW0hIHtLLvRNbwJKJq3F+F8ouK0VEAUNqdGpjABtQC+vM4UAl1Sp6cwrGi42BpisMVf30qWl12x5L01Pka4EOFm9ky4wVRnX9oPfZVXH85mNuJ/8hzpmBK/n24W/Jxv0p7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528036; c=relaxed/simple;
	bh=kPh+7hR6WjnZh61MuInuDgdrM2HGcfyY2SlOrYc3Gzs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SJYyWSwGuhd0rm7YY/BS/T9fI13TXHtrtFar985bU1Bg+bNGyKv3dV55xkpEopHTKPXoi/dMAgjEGwZitCDlspC+Alg2OJlAaipZ8REdJHspMTSBna2ZFqk4vYpof0Ruq/gyFMUvBZDS43YkqKL6fn703Kiq7yorLPSiGZe4PVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vBfqH5M+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vBfqH5M+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E7EC4CED1;
	Fri,  6 Dec 2024 23:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528035;
	bh=kPh+7hR6WjnZh61MuInuDgdrM2HGcfyY2SlOrYc3Gzs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vBfqH5M+2QXBQ/dFWSo56Q01mAnu1ixZ2yhbKy1jvqncMTfTG8+Zbtxnr0MVKQ9VS
	 SZG4r6kzWuPXkZCdYkAMiCktCZFwHuDK4NHQzdUP5xhcgwqNv91DIk1v2YHAQOyv4x
	 JEZFHAF//Ze+TDVAmWTDXV33eWsunajb6MGl3l9hH+E8K031VK6/PJx0EeBJFCqdZx
	 OlnV7lkOSzMwrLgDItPdGH1DbTOeCXlph7R/lkOJ1R3UXr1VlpYf+c8LCliGsYI9Ng
	 tsMT2iZpzCyR2aZ2Uk4d3Lo/wBIsQr4mOLs7uG0ZcmF3w6IVLGLuPZi4vzWLgEEckS
	 2R+j6kkxPW55w==
Date: Fri, 06 Dec 2024 15:33:55 -0800
Subject: [PATCH 14/36] xfs: insert the pag structures into the xarray later
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747092.121772.9805864329051373584.stgit@frogsfrogsfrogs>
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

Source kernel commit: d66496578b2a099ea453f56782f1cd2bf63a8029

Cleaning up is much easier if a structure can't be looked up yet, so only
insert the pag once it is fully set up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 8809d76d496ae9..e22ce4e83f4a62 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -305,15 +305,6 @@ xfs_perag_alloc(
 	if (!pag)
 		return -ENOMEM;
 
-	pag->pag_agno = index;
-	pag->pag_mount = mp;
-
-	error = xa_insert(&mp->m_perags, index, pag, GFP_KERNEL);
-	if (error) {
-		WARN_ON_ONCE(error == -EBUSY);
-		goto out_free_pag;
-	}
-
 #ifdef __KERNEL__
 	/* Place kernel structure only init below this point. */
 	spin_lock_init(&pag->pag_ici_lock);
@@ -329,10 +320,7 @@ xfs_perag_alloc(
 
 	error = xfs_buf_cache_init(&pag->pag_bcache);
 	if (error)
-		goto out_remove_pag;
-
-	/* Active ref owned by mount indicates AG is online. */
-	atomic_set(&pag->pag_active_ref, 1);
+		goto out_defer_drain_free;
 
 	/*
 	 * Pre-calculated geometry
@@ -342,12 +330,23 @@ xfs_perag_alloc(
 	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
 			&pag->agino_max);
 
+	pag->pag_agno = index;
+	pag->pag_mount = mp;
+	/* Active ref owned by mount indicates AG is online. */
+	atomic_set(&pag->pag_active_ref, 1);
+
+	error = xa_insert(&mp->m_perags, index, pag, GFP_KERNEL);
+	if (error) {
+		WARN_ON_ONCE(error == -EBUSY);
+		goto out_buf_cache_destroy;
+	}
+
 	return 0;
 
-out_remove_pag:
+out_buf_cache_destroy:
+	xfs_buf_cache_destroy(&pag->pag_bcache);
+out_defer_drain_free:
 	xfs_defer_drain_free(&pag->pag_intents_drain);
-	pag = xa_erase(&mp->m_perags, index);
-out_free_pag:
 	kfree(pag);
 	return error;
 }

