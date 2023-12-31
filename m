Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9DFC2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qm1eM0WH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BCAC433C8;
	Sun, 31 Dec 2023 22:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061530;
	bh=IAjGyFFotrVx3A9NexiCgy0eEEQwPNdU8XgtUh7YvVQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qm1eM0WHFQzU6NLGNEnW8mkZTlRtW6R+XFgXUmFsJLB+LfRYe87YrGPbl7mLIWJPa
	 fHZI0a3lzcQHZZKZrKTgRG3HCBDvLES9jAixUAitaHw+yl3PIInWyhllUT80SfW0j8
	 BgiyNXQAkzRbUbhaV2nSf0lFhGMBn6trPuJzBNoOrxwdWzfvbKDPLFK0mfJtUgfcvJ
	 Apx0ogdbBmGbxZ3RU7gitUu0R87+A0PT+yGduaU7GOj1OxkMeuRLzYaKHdAUVuHNWi
	 R4yS/rClI+r6aXWTnosCA8gVYb+Ezc01wzlV8KtAyKANNs4OcDkz3jBidjSg4XIZjl
	 7WrWVW73bDIlg==
Date: Sun, 31 Dec 2023 14:25:29 -0800
Subject: [PATCH 2/2] xfs: add a realtime flag to the bmap update log redo
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404995227.1795774.7271970679282592714.stgit@frogsfrogsfrogs>
In-Reply-To: <170404995199.1795774.9776541526454187305.stgit@frogsfrogsfrogs>
References: <170404995199.1795774.9776541526454187305.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Extend the bmap update (BUI) log items with a new realtime flag that
indicates that the updates apply against a realtime file's data fork.
We'll wire up the actual code later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c     |    6 ++++++
 libxfs/xfs_log_format.h |    4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index e9875f3e208..e7d64be014d 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -490,6 +490,9 @@ xfs_bmap_update_get_group(
 {
 	xfs_agnumber_t		agno;
 
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		return;
+
 	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
 
 	/*
@@ -519,6 +522,9 @@ static inline void
 xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		return;
+
 	xfs_perag_intent_put(bi->bi_pag);
 }
 
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 269573c8280..16872972e1e 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -838,10 +838,12 @@ struct xfs_cud_log_format {
 
 #define XFS_BMAP_EXTENT_ATTR_FORK	(1U << 31)
 #define XFS_BMAP_EXTENT_UNWRITTEN	(1U << 30)
+#define XFS_BMAP_EXTENT_REALTIME	(1U << 29)
 
 #define XFS_BMAP_EXTENT_FLAGS		(XFS_BMAP_EXTENT_TYPE_MASK | \
 					 XFS_BMAP_EXTENT_ATTR_FORK | \
-					 XFS_BMAP_EXTENT_UNWRITTEN)
+					 XFS_BMAP_EXTENT_UNWRITTEN | \
+					 XFS_BMAP_EXTENT_REALTIME)
 
 /*
  * This is the structure used to lay out an bui log item in the

