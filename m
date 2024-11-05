Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A3D1FBCA3
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844748; cv=none; b=iNhrnuiV3NaynJOO7l36o/2scAusNVWDeKQM1SrcTOnxOXc8CkOOOMsWsq/QeCyOOw5gm5nVdyrPGYGYFQ13l4eMJFb7l95hnFCnp1+lHrdUE/3XfZ8wKrKlTsQrmKPYl7h4hTKl2Ur6H1R4okjTCA7e8A7r5iyK05olqAVNrU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844748; c=relaxed/simple;
	bh=01iyvUGaxsyVwi4IqbmzmaWtaWXIeAYrfQrNHqgBCG8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UnjzLN2UPMCw050zrLKNOqt/nkPi/2p1jK7EGhiy9C9wtufr4gyIJGUVg34+/xXjgZRpbErFVoS+ZQOaG2iAyvWMT+QnbIZjIlN49mtsWzptfu8VfEjq4bC1E5yoivdGxgJL0RnQewB9L0svPy/tG6g2zI+GobhXIPZv3672lzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMMD0PFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMMD0PFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08B5C4CECF;
	Tue,  5 Nov 2024 22:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844748;
	bh=01iyvUGaxsyVwi4IqbmzmaWtaWXIeAYrfQrNHqgBCG8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EMMD0PFs0AVNpMvuFD5X2JmvWFKyVNL137N4Tv5UlsIir9AG3bH/EOUtavhLh8nwm
	 HYA3fktGU+ike4KnzXzHYnwHQr/sTGYvye0XbYSjHKqwT99V8w+Ng4zYwOt5P2XKMg
	 BDOg6Wbjsj2hBOGZpXIl14s3mK5TZ9griyKcCIl8Hzgq0n5GblEkEvuTQ/UNWnR+H4
	 ujO2IIrIWd+XhOYk/FytGG83qDoucUdGVLpZQTxa2RhCU8nRX0KafTQKl/PHfpvws0
	 oErJhQYQaBV7YZyj9b+RaiT3rFCRzO+dWWNs16nyMnJ1NlHrYko1u/33jCH6j1U0P3
	 GJ3hJ+vn9ziZw==
Date: Tue, 05 Nov 2024 14:12:28 -0800
Subject: [PATCH 23/23] xfs: insert the pag structures into the xarray later
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394846.1868694.12433133272337323443.stgit@frogsfrogsfrogs>
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

Cleaning up is much easier if a structure can't be looked up yet, so only
insert the pag once it is fully set up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 3e232b3d4c4262..d51e88a4e7e283 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -307,15 +307,6 @@ xfs_perag_alloc(
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
@@ -331,10 +322,7 @@ xfs_perag_alloc(
 
 	error = xfs_buf_cache_init(&pag->pag_bcache);
 	if (error)
-		goto out_remove_pag;
-
-	/* Active ref owned by mount indicates AG is online. */
-	atomic_set(&pag->pag_active_ref, 1);
+		goto out_defer_drain_free;
 
 	/*
 	 * Pre-calculated geometry
@@ -344,12 +332,23 @@ xfs_perag_alloc(
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

