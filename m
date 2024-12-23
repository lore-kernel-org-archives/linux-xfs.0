Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFA938F82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989892; cv=none; b=FQmfnDmoZf4/zVD1ONM0XDpv/VHN5G4covZ7r3MW0G7je0HbcVbxv8BteP/4M6DdREqMzDByd4jcrYVEg1LKbYetbzrrUxpqNnj4vYcJnXqHbl+gB0dqcICARlyfeaaxSw07TDoilfw0z0fhAfeZe5Ykcy5dHK3B839m35S+TG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989892; c=relaxed/simple;
	bh=wzEX/nLs9P9rvXfodJRgPv0hYMdp/V/3ozABeN1iW6w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K9Umz1tszO+Yg61a1jko+hlKLx2QX1NDVyhBO34fIIKi5QTdOyT9SmL9i+Xuj9/6oo8WOSsIm35sYfTJrHyjVFCuV/Az5nDVhZWDQJ4y+/DOqw+qU6CqS9hQjL1W5WvbT7YrFoFhdE0nrF47FNcGPmiJFVivvthT5x47DTB4LQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mGj97ege; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mGj97ege"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85800C4CED3;
	Mon, 23 Dec 2024 21:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989890;
	bh=wzEX/nLs9P9rvXfodJRgPv0hYMdp/V/3ozABeN1iW6w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mGj97egemQQ5tlxZKFaOdGXPoSTYZuGkOcXfBgBolQOP20SZiTEnE6cVLoUd0NVsb
	 ePdGoxPstmk7abPliHAexigr0ScPIOX9fYFrO4KpOUsl4XdS8/9390f9uO+ylQmy7y
	 zaiyTa5Nm4wrxvVnghgm3McNVg4YPDRij6p+p4Ks9/rqpBPpiAybyTJKD69V8+t/t7
	 eaHV3idNHiF45KYpXg/y5NEMB4SmeYsGBKHUBorOpE/E/ePLOdoMleXHmQk9XVLyxm
	 cWwz9mnDfnHFA/kWjzf1RE/jiKwlwGFUJ/0Yh/FuxLFI8UI8vEpripCmJMcfO9ivKC
	 +i7npmxeND3FQ==
Date: Mon, 23 Dec 2024 13:38:10 -0800
Subject: [PATCH 04/36] xfs: remove the unused pag_active_wq field in struct
 xfs_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940008.2293042.1238926203712896387.stgit@frogsfrogsfrogs>
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

Source kernel commit: 9943b45732905a70496fc44368ab85b230c70db4

pag_active_wq is only woken, but never waited for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

