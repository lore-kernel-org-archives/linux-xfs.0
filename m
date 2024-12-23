Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02791161328
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990047; cv=none; b=JY89GOTubbAZSZdfR0SOCHVKabpVfDDUo5ajEhe63jJQModN+wp2uJDLYK4ynjIxjjeX/HWgFQtNDOM3/0I0/Mjxc4BQ7loJksns+NfWSXxW9pHAPUcgmydFF46UqHOpmWB9zLleoEDw5dWynmkzlDt47X5fn+S5qxthAO+Ipbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990047; c=relaxed/simple;
	bh=O5bXcWC6/erVcKzDBgZoagH7FcPwXxy1Rx73aDJtsxo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=spuc1O5CxkAy5Nc06TwDg/xQ9LZ3lyDq5oS4k8esuhwPvFTYqVsoZxelXrUthFhrCQdSzSfXZkft3WD9LWzrqt2vhatbbXzkQzPImQ3q6Wq9HMt4rz/Hbvhgy12JANSNQRextosaGtYoRxaJYJ8QmFn0bqVfL9KMXhbSyjV6J8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnMrM1dg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnMrM1dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F65C4CED3;
	Mon, 23 Dec 2024 21:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990046;
	bh=O5bXcWC6/erVcKzDBgZoagH7FcPwXxy1Rx73aDJtsxo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nnMrM1dgQCapcbPxmhJNnVrsSnDEMqe5VvzzJu9Lgt65KgRQX18GACc69BbQ/ZY9E
	 A0K4vej+th4A+hZME+35dQc7cCsbHqlCRd4Pf0s9WoZaFnwElV+1IboXuRvx93ZUUL
	 74mhYK/h/okNFonAZ7XT7ICQyXQel2MZ+wR6uulWgjzqgGMer849CJgVU3Zy1MIUzd
	 GNrC5iBcATI+JJNMJ9N0UVuEao8KqBML4ayg3YBHRC6F9m8uAXGW1mdb2cophsPfTA
	 iu4wHO9ko9cHVXcMrtKpjp7ePjjhifleowYbuBjEZ66DodbRJFvjff5lxbc1eM4TAO
	 NfP34Uis0+Llg==
Date: Mon, 23 Dec 2024 13:40:46 -0800
Subject: [PATCH 14/36] xfs: insert the pag structures into the xarray later
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940160.2293042.5173621765621797998.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

