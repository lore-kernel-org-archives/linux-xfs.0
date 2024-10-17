Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF37D20ADE7
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191104; cv=none; b=ArW1K7jk1qwAfhKXIwAxC3n8bZND29KRg/uSWLyBenX5pRDaUViZWPq+0wsLapnftF0pGrVlkbqWVTlL8/bD02yoSiVRk9VmGk0jD7WDeBgUS2YJIgVFhxe34iosIvIllZ98jcYT3V2BV0mNa2lLEt++p2bG4jpJjqOV1dLjrTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191104; c=relaxed/simple;
	bh=01iyvUGaxsyVwi4IqbmzmaWtaWXIeAYrfQrNHqgBCG8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lrtVLiP4wfeyMAWKcyzDOXhbwX41t8x3CulsAFF9IiBylz3hsoKXtvn9qXcPx/HdRZ7wRO2iaVycHSnBL/y+/NGUNpjksfscFwI2Dd6Mr93xhQP8B26V23kYzX8W6oBcv8QIPbFv7thCRF/4PEkWCQsk+hM4VT7gXBleK/ezw24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ofTM/Pvb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ofTM/Pvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE8EC4CECE;
	Thu, 17 Oct 2024 18:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191104;
	bh=01iyvUGaxsyVwi4IqbmzmaWtaWXIeAYrfQrNHqgBCG8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ofTM/PvblH6xiQQ3jAuvrgxbqkGfNmmCS+2w5nikOrvWdwxr5k4gFIGNKgXXZZ004
	 2b7hi/GurW0Kzh7BFYNo6Qyk8T4ai8/nzCWvWJWWT4nBe47iWRaQPO8RgCSMyPcttC
	 MwLE0ghabKwxDmV9BxWqMX0WD3XUQTYUhY6Gn0bUzPqe841Je/fwyXT81P9ABi6+ee
	 BP6lQ5n4Yjo3eqY9jDbGLG8HIvq+2K3YpyhCV9njsNM3GAl4WksXG3rGtE2gtRQMBR
	 n3BSgBo0jZwYtTYDiicdyKIbNNj00o1aDjeovdoxoYPJlc5Rwbe5Q+ZsSJgV6862A1
	 +IKVQvIXkkvCQ==
Date: Thu, 17 Oct 2024 11:51:43 -0700
Subject: [PATCH 22/22] xfs: insert the pag structures into the xarray later
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068242.3449971.2480912756354502529.stgit@frogsfrogsfrogs>
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

