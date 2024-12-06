Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3639619ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527879; cv=none; b=VPHy8xAgbAe6OrF/IIar3pMtEN79LGHwf59B5k7lyZmR/D6gyEsh/7YXUl9y7uNs8XxOkyRNQxMacO3twMyFzBYGcJtUUGOWOJXRVAJM0VtoD2E+9PFpnBX0mqA6zQo/FlRDJmP0EHl8ezt32BUMqKHK3dQlTVQi/BFuS2RX/xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527879; c=relaxed/simple;
	bh=m62REzub7rkUjtm2kv5C6S/AAnYWC2c5oqlgxAiwkJM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2BYOzG4+PxyyHOHrsYX+UzJnYXTLZGL8dGevCFP+dB1N0Q/YQnYru1EPr+l7gm6cWYlu9VGaPvza8bD2R7g5X3H0bppdvZESc5dJ6uq9o08hypSQIiiYbDMQwvPfL1v/Mikg1P2Bm+HErnvNKWQjTRHrXiVJhsiOz5fYEhEAt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcNCyxFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcNCyxFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEC3C4CED1;
	Fri,  6 Dec 2024 23:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527879;
	bh=m62REzub7rkUjtm2kv5C6S/AAnYWC2c5oqlgxAiwkJM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dcNCyxFN6HRoHz7whsgYWSA90sFMzAKdIzC8IwpF9OUsab6uIpFblCaXq9wWTnRmm
	 LKnkIakRe8gp94E0fW0CRn+ZSkjcYW7nSYZN3fXdpu+ylGza4tI9S0Lc9BPHURlljb
	 hlqsRdBAM0DZFQwipcclte/NPOSBak1PF86cBt4OMSJAceHGWtj8K6nAkbf7ZDtl4i
	 DeE+dmf4izkFWK9ArQXl9PjtHYTqReWZIamIoCKGM/QSaokliW7NHiIlJLEV9yusQa
	 U+Fjr2TfQ/zkPajvzvZ9DaCkl7ubP5k8IR1GVjnSXWCvNg5TZF/9Y4J/xa0paDGmnR
	 XorqN11j6QKuw==
Date: Fri, 06 Dec 2024 15:31:18 -0800
Subject: [PATCH 04/36] xfs: remove the unused pag_active_wq field in struct
 xfs_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352746943.121772.5882998905672943388.stgit@frogsfrogsfrogs>
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

Source kernel commit: 9943b45732905a70496fc44368ab85b230c70db4

pag_active_wq is only woken, but never waited for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.c |    4 +---
 libxfs/xfs_ag.h |    1 -
 2 files changed, 1 insertion(+), 4 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 975b139ca497a2..62fc21fe7109b9 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -105,8 +105,7 @@ xfs_perag_rele(
 	struct xfs_perag	*pag)
 {
 	trace_xfs_perag_rele(pag, _RET_IP_);
-	if (atomic_dec_and_test(&pag->pag_active_ref))
-		wake_up(&pag->pag_active_wq);
+	atomic_dec(&pag->pag_active_ref);
 }
 
 /*
@@ -324,7 +323,6 @@ xfs_initialize_perag(
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		xfs_defer_drain_init(&pag->pag_intents_drain);
 		init_waitqueue_head(&pag->pagb_wait);
-		init_waitqueue_head(&pag->pag_active_wq);
 		pag->pagb_tree = RB_ROOT;
 		xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 79149a5ec44e9a..958ca82524292f 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -34,7 +34,6 @@ struct xfs_perag {
 	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
 	atomic_t	pag_ref;	/* passive reference count */
 	atomic_t	pag_active_ref;	/* active reference count */
-	wait_queue_head_t pag_active_wq;/* woken active_ref falls to zero */
 	unsigned long	pag_opstate;
 	uint8_t		pagf_bno_level;	/* # of levels in bno btree */
 	uint8_t		pagf_cnt_level;	/* # of levels in cnt btree */

