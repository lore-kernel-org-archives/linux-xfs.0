Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7CB1392
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607452; cv=none; b=TtM8jNqNgQkbl05Adje6J27KcIPYaPnZD3E1cMPO/Wp1AjYJFPXEKmIveaeiYYv9+JLQ1GwJ9ci0k8Eckx5D525dCp7mu74Na0tqMZxWRYZZUaZWvxvTgf8+p7hWY5g1VFFUtHHcxojnsW8TIQuxwwhd/O7TeNkf9BzscPft0NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607452; c=relaxed/simple;
	bh=xdWTU7xqki1ph3VlKI/SKkSRbkmVMVwF2/avm5hYuu0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uU9yWxg4PBNe8PJqvsBUYmajT2lQWjfhZCV0yFul78MUIUFuzd3NV1DIPPKxhJh8kuuqwvQHRiBtP96F8Qj0tsfj3hyZkFVmmW6j4hdPu1Nh2HZ+PHRcujW3auDVBoSfxVRiN9U80ovuTCrinnkEomJMxBYNbCPh1Bvgw8d61eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AtWsu1rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AtWsu1rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6850C4CEC5;
	Fri, 11 Oct 2024 00:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607451;
	bh=xdWTU7xqki1ph3VlKI/SKkSRbkmVMVwF2/avm5hYuu0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AtWsu1rnELvhLX1Dvu6uQksIOiqD3GSpUpP6d333zT6q9Ri5HrSXhVJDHk4+xK9kH
	 YMZco10zqtA2cS1IQxVDcLXDrH4zsEh7U0A4XDHX1sXbjP24XttpGf9T0F9uWJqXYR
	 DNpe5AsQiqG3q50Aw7EpisbK9MSgE1pw8n0O8iHlbPVCBR20ykmgCuk4+VoodofCPU
	 YLm4zsLPzQsZXrknfZtPkdE9/YLRe3g138SntySaPue8LS+v+25yQzzxsfrHlgA9ln
	 D+rw/6zIxtiy11JIwBJJYkYu1FLTYtSEzlGCNJHru5oqglPBLcDoa9UE2bPoMmm/Hu
	 Ju+fSmavX4l4A==
Date: Thu, 10 Oct 2024 17:44:11 -0700
Subject: [PATCH 25/25] xfs: insert the pag structures into the xarray later
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640843.4175438.9188528279247642167.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
index 23d62acc89dc78..72a9a8c3501e81 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -286,15 +286,6 @@ xfs_perag_alloc(
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
@@ -310,10 +301,7 @@ xfs_perag_alloc(
 
 	error = xfs_buf_cache_init(&pag->pag_bcache);
 	if (error)
-		goto out_remove_pag;
-
-	/* Active ref owned by mount indicates AG is online. */
-	atomic_set(&pag->pag_active_ref, 1);
+		goto out_defer_drain_free;
 
 	/*
 	 * Pre-calculated geometry
@@ -323,12 +311,23 @@ xfs_perag_alloc(
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

