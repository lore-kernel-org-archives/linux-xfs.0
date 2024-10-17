Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CEE218D97
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190901; cv=none; b=ZYUUZ/NG6jSxQ8sTWHz1SJeG7uyfFU59LO9os4aowWAbL+IlcByLY56jrkdSD5vMFCanIjdD5D3X+JFK2qUTf/vBUBv97VV9hcXxtCAVrBz6KjzQu+pg63ioUtgtWB8CZTu8/nZokx7a6HqW5Q/JMveJpRAithwN10ezV9IXvW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190901; c=relaxed/simple;
	bh=KavjNK0HJ2KFPBBvxc1Z0OjqeB6+u/pJ58U81mple7U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XDPUmfW7zzmILJHCsuqnSVNMTGqEz/wSggH6KgxkX9V/KspN8M01XGsapqCvhO9ubsOIA89iZMG8zk8KpxHegxWt47xKMQ1Ntzb68NVM8xpWd4hdcuhcC5yIXigiocT6vDgs9F+1ehLZaYlqty/bDayeQ+pacPrWL20ZesB/+X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/q4rfpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/q4rfpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C1BC4CEC3;
	Thu, 17 Oct 2024 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190901;
	bh=KavjNK0HJ2KFPBBvxc1Z0OjqeB6+u/pJ58U81mple7U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a/q4rfpEpVnV3KfzenWhN0GU7l302OkOa6z5OKW1peB1I+RiH/gnMbyW3uT0IN/5h
	 AUtBQLPNifszFIM5qfVtgWjxn3LpUrxDUUL3jXmDaS9Qe9yMhaW0l31EhrZG1Ivmcm
	 /oTVZJ54zn9GfxIgQY5CdoUEBsJ3bjqKUMFNpueIx8g/R1LPUzdFDF0FXx8WEj6EFO
	 uiU1pSq7Cxa0dXOGa1yQsdOAlcYV6exnk7lJSzLGhKed+inj1QI3W63k/lNy66fXGX
	 0EyXJq6HPTKwaYkKvx/nxj/N7E+JXJeEIhFFdjeOA5a9WUB9khEkc6nC1MnQCmnFPl
	 FCdNLE/bndnCQ==
Date: Thu, 17 Oct 2024 11:48:20 -0700
Subject: [PATCH 03/22] xfs: remove the unused pag_active_wq field in struct
 xfs_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919067908.3449971.14650056107546874518.stgit@frogsfrogsfrogs>
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

pag_active_wq is only woken, but never waited for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    4 +---
 fs/xfs/libxfs/xfs_ag.h |    1 -
 2 files changed, 1 insertion(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 6fb0b698504c81..48ea596796b5d6 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -107,8 +107,7 @@ xfs_perag_rele(
 	struct xfs_perag	*pag)
 {
 	trace_xfs_perag_rele(pag, _RET_IP_);
-	if (atomic_dec_and_test(&pag->pag_active_ref))
-		wake_up(&pag->pag_active_wq);
+	atomic_dec(&pag->pag_active_ref);
 }
 
 /*
@@ -330,7 +329,6 @@ xfs_initialize_perag(
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		xfs_defer_drain_init(&pag->pag_intents_drain);
 		init_waitqueue_head(&pag->pagb_wait);
-		init_waitqueue_head(&pag->pag_active_wq);
 		pag->pagb_tree = RB_ROOT;
 		xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index c02d6cb8f2df7d..13d8ba8a1cb705 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -34,7 +34,6 @@ struct xfs_perag {
 	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
 	atomic_t	pag_ref;	/* passive reference count */
 	atomic_t	pag_active_ref;	/* active reference count */
-	wait_queue_head_t pag_active_wq;/* woken active_ref falls to zero */
 	unsigned long	pag_opstate;
 	uint8_t		pagf_bno_level;	/* # of levels in bno btree */
 	uint8_t		pagf_cnt_level;	/* # of levels in cnt btree */

