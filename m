Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9660A19ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527863; cv=none; b=Qs5zc/XHR0hgzTy2CF88x2YjyUF0uhIe/ujTwcRrucwkjAvlH/4wyMSW66ObK6BPFKdMH5nZpibAEZ56pCQGhTC3Xs8alC42zmkaQ4EyoZcvYpH6+RMZDbu0+vmfxxOz+cvJLDE5wbioCu/hXKPF928PlVXQLWh9+nJ7xbfI6gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527863; c=relaxed/simple;
	bh=zOQwcc2ma2oaoCcJydH0vvlUBAvRdDbpRFDdFiF2sRg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yfob/QJUXg9gl97tYT9WkuVQ/AlHeJP3BZ3w3llbmAWIuy8JMeLu/LxBqaKCfkxCvdsL7Qb6oXwY89vNwI5bmEAyQrMWtTfxZf/HY2nQhIneMp2JZuyaQTML2clCgeuBpUZqkjaNJnbUUJRldC4YHmyfz2l8+iI/IY/2Up2pMi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kaj380/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kaj380/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB0BC4CED1;
	Fri,  6 Dec 2024 23:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527863;
	bh=zOQwcc2ma2oaoCcJydH0vvlUBAvRdDbpRFDdFiF2sRg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kaj380/lCmzG7CZ/XB96AJOQvgoQrPq/OFXPM59cEsz5Qh1mTHu5X+UrxovL3d1D3
	 dmoDpBhxuZqFMljcq7Xanji6if3ox7mehmIEtfeMdnRzKpLLnYpkQe6NcF/nLhbLa3
	 2BRZA1Pi0Ws3Pjp/H1ps/DyGO7CY6q2e7SQFItYfNxWIQr4yCPU2btnBdzAmHCcNWJ
	 YU2IyHoU0vXzuuwGA2LiRUaUMBzAhaXd9HE3XGHZ+ha7O2697l/hbjtiEiExvbIFd7
	 Mf3qJB66h/cK6koGa/KKh0t4FfJbVbmvXfTArVP9YqwZLUd7AbdVH8fBF/phuCaF26
	 hzW81wKewSInw==
Date: Fri, 06 Dec 2024 15:31:03 -0800
Subject: [PATCH 03/36] xfs: remove the unused pagb_count field in struct
 xfs_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352746928.121772.3549052117395667321.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4e071d79e477189a6c318f598634799e50921994

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.c |    1 -
 libxfs/xfs_ag.h |    1 -
 2 files changed, 2 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 79ee483b42695a..975b139ca497a2 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -325,7 +325,6 @@ xfs_initialize_perag(
 		xfs_defer_drain_init(&pag->pag_intents_drain);
 		init_waitqueue_head(&pag->pagb_wait);
 		init_waitqueue_head(&pag->pag_active_wq);
-		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
 		xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 9edfe0e9643964..79149a5ec44e9a 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -55,7 +55,6 @@ struct xfs_perag {
 	xfs_agino_t	pagl_leftrec;
 	xfs_agino_t	pagl_rightrec;
 
-	int		pagb_count;	/* pagb slots in use */
 	uint8_t		pagf_refcount_level; /* recount btree height */
 
 	/* Blocks reserved for all kinds of metadata. */

