Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107AE10F9
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607140; cv=none; b=qIulqQNQOwIMgsVX4noUiDsiv6hHRJIga5y2+WjOQpUR9dNJvC+T2p0mydInRKJBSoQ06peYRttodmRK8Z/rtMw0itK1frWJ1r2h+WAd1RWGJOXcPBcUj7ai7jCz38rkx90xdI8kwunZj/ECIUrKPmvhAeVQw66iDJKkbYP5IN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607140; c=relaxed/simple;
	bh=i8eCyQBww8WKdR6Lx/H491PdRU/ajWxw5Nl7A+WE0gE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sFSzNK2wDxakp3gNwgOZ88FsdtlwpGQ0bA5Xr98VbfbH0JKM3Xf6HUn5QwuUQePtWssvEMtMvw0XPlKPc5VuBW0V7cAM6kOHp4DxKD+Rt+dTdLQwBkhfXWEyvFoemPOVPV7uaCB5VdfpzxPhk0XA1BYwohre0zKqnx2OUfI3EhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u4eTG5GU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u4eTG5GU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EEAC4CEC5;
	Fri, 11 Oct 2024 00:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607139;
	bh=i8eCyQBww8WKdR6Lx/H491PdRU/ajWxw5Nl7A+WE0gE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u4eTG5GUzMUP+x8RV0P6fso5a/W611FvV22YTD9Hhkm4/VJ16bhIU0slbjtK01E1o
	 6qIPmmr+spLoGfYtonP3haJBYQLGagEDguUImUOjw5HFi4IytrQGLgtTtWCptKTqjM
	 qoQWLazJOZTf8v8j7vm70sGFtJ5bSmyX6I6eUwyWJBbtG2ZlaVfON859O30bOJ399f
	 xXrEpHt2OVR/O59uXGkv/v23B8ZH6/JIFciPio0fGM8jYJb75BrLTpzCqTuckCp8g/
	 3jJOXcYhedFgIi90U9Vy8Wg5ISGpAzSbe8+v0n49voOBN9cF1fdqYZAWdxt+huyv+r
	 MgGmRudcTefbg==
Date: Thu, 10 Oct 2024 17:38:59 -0700
Subject: [PATCH 05/25] xfs: remove the unused pagb_count field in struct
 xfs_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640493.4175438.5926907268250759284.stgit@frogsfrogsfrogs>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    1 -
 fs/xfs/libxfs/xfs_ag.h |    1 -
 2 files changed, 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 29feaed7c8f880..e5efa7df623d65 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -313,7 +313,6 @@ xfs_initialize_perag(
 		xfs_defer_drain_init(&pag->pag_intents_drain);
 		init_waitqueue_head(&pag->pagb_wait);
 		init_waitqueue_head(&pag->pag_active_wq);
-		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
 		xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 6e68d6a3161a0f..93d7dbb11c2cb0 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -55,7 +55,6 @@ struct xfs_perag {
 	xfs_agino_t	pagl_leftrec;
 	xfs_agino_t	pagl_rightrec;
 
-	int		pagb_count;	/* pagb slots in use */
 	uint8_t		pagf_refcount_level; /* recount btree height */
 
 	/* Blocks reserved for all kinds of metadata. */

