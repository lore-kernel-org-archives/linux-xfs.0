Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0740C1BEF82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989875; cv=none; b=FDj7eejANmz4Bv+Nf+IErDcDVHJqplSFSywXtKPYRGe6+eQHK8mHUDwaudNQREgmHDooLFb/Ts/+MgrU+lzZlGuj+/3yrsTTAFk8cPuc7YZ55y4s47/qutyCL8LEIGih/N6+2LQZoWY4RBefa1fPmcmdpkC2nNN5JOlNU+l8N+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989875; c=relaxed/simple;
	bh=RusH3hwlmC8YZwLJDs+aGT4z0bGD8qePX/8cbpmIIGg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mOXdKLJEYgDJQuXm20z5UO7min3ue/wrUB3a15e14QcPboln+w0dJT4JUDv3R3FNgcNt4e+xVzF5fp1ABmH+KNFfVX9B0PePfl0RseIxg+qnZyF8hrKg1QFbCKqkouxyk8CC2P/C3O6lR6azH/VeZ8c5FjCN2P3DNOCMenAU7Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tDJtou5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tDJtou5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4092C4CED3;
	Mon, 23 Dec 2024 21:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989874;
	bh=RusH3hwlmC8YZwLJDs+aGT4z0bGD8qePX/8cbpmIIGg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tDJtou5Fo22oM520XBUyXNIFda+04Ucdo1kClUxN9xjiMBr9kRySOykmNM5/5OUHY
	 uMFz+j7oRXUvyYy/GPYnpIAsUm9ZzaYin1Q6f5G0lGIYPkd/cyFQQt1twfA5qgQWzT
	 k6ha/aZ6iyA1ZFpJm/rbNjyWk6eT1pADu9rXRPdAdAJUaMrZO3QT0JVHFWmeGAYEe5
	 kQn1VPDcGffXIkIVi5cH4CNjdpRMuoaT5mEAX9Bi9AafxepasMueN1b2FGLmSWKQ+A
	 CwMbiY91U8zIANsAHY6ihhbq37qzf4Gci743QwJvcyA8wSGx3wR0ODrCvcUN4AyQhd
	 JuXiJi0uTGy2A==
Date: Mon, 23 Dec 2024 13:37:54 -0800
Subject: [PATCH 03/36] xfs: remove the unused pagb_count field in struct
 xfs_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498939993.2293042.8777635963514324325.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4e071d79e477189a6c318f598634799e50921994

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

