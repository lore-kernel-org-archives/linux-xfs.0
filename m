Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595F51FF7AF
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844452; cv=none; b=ou2bABMjm83WzQXjWj41/imfmodz5DloUD2w4q3Dj5rtkJKT9QCaLdewo3Cvx4jnhPvTvYQIpkduTotkK7yLWIhqCpdU4Kvu6OaDeluuRmD7AgimXIZD9qL7HX25uuS07ltXlzYYB/HDE3aQWkcU7jevk/Je6rrsrtdf37Zt+wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844452; c=relaxed/simple;
	bh=9zcy220o2HrX94LlR+XAvU0HFmcDC9h2gDZ8Bym2EtU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P5SAVYfT4mjqpz97kVcG2Y+BPvSXYJCSGs1FUNRQRa6HsBacxTQL2agkRHdY5QkMJXJu/GyRIY1CKxybWR10YtTYkzXdq6qTJ3Y40LkfZkjqwINqAmFd1HkCxLTGokuM7xbivCsuo0/hXEOyxWi6H1ZKrsNOKC2K1n4sTSYMScc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N1NlIfe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N1NlIfe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9984C4CECF;
	Tue,  5 Nov 2024 22:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844452;
	bh=9zcy220o2HrX94LlR+XAvU0HFmcDC9h2gDZ8Bym2EtU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N1NlIfe5jTOanfPhiexZrYwLYq4G8kCmHFk3qR7jw01s7vIWDyAtFUvw/4jfg1p7V
	 EbQzDey0Xq7HE/rhj6fVlrVqDJ47R5PJjyea91G1tVqjuJjeYnPHKO0GwT9haLVTvx
	 WrSxYXe89ukSaXJeKKl6YNalhr0EC5mClBzxDyeRK6xac0RrVtMhRF7ZIx9XQssLLq
	 SvbAReyFZ6ZUovmkjn/Htgus78glsu0mw8+OvvQrQgsDx04U4QqVrS6YB1sbp+hYdJ
	 MHl6qeVtzO+6V2yBtepnrhdmQyn7PziBXhN8zuZedy196vheS3rf6ArNygPU1vFHQ+
	 mV9xxkvMjAVOQ==
Date: Tue, 05 Nov 2024 14:07:31 -0800
Subject: [PATCH 04/23] xfs: remove the unused pag_active_wq field in struct
 xfs_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394517.1868694.7058164622198572340.stgit@frogsfrogsfrogs>
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

pag_active_wq is only woken, but never waited for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    4 +---
 fs/xfs/libxfs/xfs_ag.h |    1 -
 2 files changed, 1 insertion(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 1b6027ad9ce5f6..b9677abee70fd6 100644
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
@@ -326,7 +325,6 @@ xfs_initialize_perag(
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		xfs_defer_drain_init(&pag->pag_intents_drain);
 		init_waitqueue_head(&pag->pagb_wait);
-		init_waitqueue_head(&pag->pag_active_wq);
 		pag->pagb_tree = RB_ROOT;
 		xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 79149a5ec44e9a..958ca82524292f 100644
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

