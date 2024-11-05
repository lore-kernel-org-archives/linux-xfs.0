Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD151FF7AF
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844436; cv=none; b=nmgVSrGexARK9J6MvA6P2nKHBEuOiR6n9bSX5B7qpJTZcpRR4mCKTuoC5Ysrelbr3qCF8fI7pYaVFPefIMGEyU1Pp43Z7ugL0OWsahjeCw62gyR6QUKp1F9CK0Hbd7WqVPdNWtErgecPJh5f2hJZQ8b24jHseaDpMCmg+5S9JLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844436; c=relaxed/simple;
	bh=lqsvEh3gX1AHWkkGajR/SKcCYap7fsP4IaGc7lC6mZQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MmCQPEUPcyleeb9RpgNu9SGy4lFGzwSdCvPNJTWyLGDc3j2Td3B1bHDDy0psJSGiKcXBqt85H+WxE4Y/6Kx7ZM++txPXS2KEoRAUSCI8HenRn/gMQYwX9xj3zrjjs1XIyndT48D/GgSvlNTvMco6y/iLDjZN1FmxglA/bVnYNrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j6S07zKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6S07zKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53089C4CECF;
	Tue,  5 Nov 2024 22:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844436;
	bh=lqsvEh3gX1AHWkkGajR/SKcCYap7fsP4IaGc7lC6mZQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j6S07zKSRFY220IxIUZj1fpYKBCYtuMVPaliHpCPsuTsLVE3/mt1o6hhwJlWXngdh
	 q4Sj0KdnTD04nW3OZXhCiNgq2odKH4phxdUPrte+I5O3gtWGpDwP/Zrx31nmFu67Fo
	 BZQesnGHbrjc4DdpuBC1svY+4u0JuPxLhuxtNRQxEjV9q5gZLAMY/CR79zH1YGVm/b
	 fzHYQMcc9dbAYjN181LUaiNHGjBjaZI5kDes064sHV9bd51bPGysT41xYwP47/9Z4R
	 ZtRqYvCp/EBh/KXkmVZlX+9VNuUpUFGUG7HXZz1jk7FwZF2YcR2UV4Fd8c3XNKlMZe
	 7dGT+ce4TqGMA==
Date: Tue, 05 Nov 2024 14:07:15 -0800
Subject: [PATCH 03/23] xfs: remove the unused pagb_count field in struct
 xfs_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394500.1868694.147133543877406507.stgit@frogsfrogsfrogs>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    1 -
 fs/xfs/libxfs/xfs_ag.h |    1 -
 2 files changed, 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 5ca8d01068273d..1b6027ad9ce5f6 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -327,7 +327,6 @@ xfs_initialize_perag(
 		xfs_defer_drain_init(&pag->pag_intents_drain);
 		init_waitqueue_head(&pag->pagb_wait);
 		init_waitqueue_head(&pag->pag_active_wq);
-		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
 		xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 9edfe0e9643964..79149a5ec44e9a 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -55,7 +55,6 @@ struct xfs_perag {
 	xfs_agino_t	pagl_leftrec;
 	xfs_agino_t	pagl_rightrec;
 
-	int		pagb_count;	/* pagb slots in use */
 	uint8_t		pagf_refcount_level; /* recount btree height */
 
 	/* Blocks reserved for all kinds of metadata. */

