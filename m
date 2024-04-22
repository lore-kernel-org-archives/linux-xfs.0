Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42AE15532C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804015; cv=none; b=Xu83IteaCDlckZhMsghmT0z3g6mYSkFfqLKLnCTMHuV+zTssCWOVgs4NATFuHr9IYdBDV+9+4p7zdscdn8j/sxX1+8B1mYnbEX4o8WWmHj1h+OnR4WNkSF/O2K4vy8RHgN0kcc38+qhNkgML+ZCp/sZNVLU6orqgVCKemYpS+9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804015; c=relaxed/simple;
	bh=HuOdS/o33+w9Mpc5xiCPIBPlI7L0jq+HfOPo1LzwERE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQlt4WgtjZZV227Ff9fOChMMalzFRq0dnVj35lJKA2C1qb5PeTHP9H/MswXUihKtisDkdsp2e8S5wBFhB/DfIj+j4QysO2PWQHNnpEH7Lplnok9U90et4HVNnvKN56HU20diCm2XDEIpaIJQmip3yq8Agr60HrLLdrX2lH+v8kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cXguF37Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cXguF37Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B3DC113CC;
	Mon, 22 Apr 2024 16:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804014;
	bh=HuOdS/o33+w9Mpc5xiCPIBPlI7L0jq+HfOPo1LzwERE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXguF37QaZvzlrbadISlF8DpJ2Uv1lhLIaZMqvFLftGbK8Adub5JAFI02r3PRu5HO
	 ACd6lKVzM762mUF1bLSS2L/AqE5YQxlOh9lYCbAMomLRl5dsFNj+w2WcreMghfJbyI
	 5Ahjrkzc57M+S9TRJpcPgWoPa7Wg6Af+v4P6TF8iTAp2FkFwxIDIZnXXNN5fPEckO+
	 piBaQ8Hb9tPR+6xEktpdx+sQ25lKA8EBxutbc+7deFjU5pXCD900r75b85jeyC1oId
	 caUZPey8tEdSJw014+0QkB4NJOc68Omam+dBxlz1c2DOkdmKbmelScjwVfViPKvCBH
	 EIP1spafLFhlQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 44/67] xfs: add lock protection when remove perag from radix tree
Date: Mon, 22 Apr 2024 18:26:06 +0200
Message-ID: <20240422163832.858420-46-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <leo.lilong@huawei.com>

Source kernel commit: 07afd3173d0c6d24a47441839a835955ec6cf0d4

Take mp->m_perag_lock for deletions from the perag radix tree in
xfs_initialize_perag to prevent racing with tagging operations.
Lookups are fine - they are RCU protected so already deal with the
tree changing shape underneath the lookup - but tagging operations
require the tree to be stable while the tags are propagated back up
to the root.

Right now there's nothing stopping radix tree tagging from operating
while a growfs operation is progress and adding/removing new entries
into the radix tree.

Hence we can have traversals that require a stable tree occurring at
the same time we are removing unused entries from the radix tree which
causes the shape of the tree to change.

Likely this hasn't caused a problem in the past because we are only
doing append addition and removal so the active AG part of the tree
is not changing shape, but that doesn't mean it is safe. Just making
the radix tree modifications serialise against each other is obviously
correct.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ag.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index bdb8a08bb..1dbc01b97 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -422,13 +422,17 @@ xfs_initialize_perag(
 
 out_remove_pag:
 	xfs_defer_drain_free(&pag->pag_intents_drain);
+	spin_lock(&mp->m_perag_lock);
 	radix_tree_delete(&mp->m_perag_tree, index);
+	spin_unlock(&mp->m_perag_lock);
 out_free_pag:
 	kmem_free(pag);
 out_unwind_new_pags:
 	/* unwind any prior newly initialized pags */
 	for (index = first_initialised; index < agcount; index++) {
+		spin_lock(&mp->m_perag_lock);
 		pag = radix_tree_delete(&mp->m_perag_tree, index);
+		spin_unlock(&mp->m_perag_lock);
 		if (!pag)
 			break;
 		xfs_buf_hash_destroy(pag);
-- 
2.44.0

