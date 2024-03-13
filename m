Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13048CA4A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295471; cv=none; b=Pxdhxf/K8DvzpN8p5zu91Npd2dylGD4LxdM9IHLaGt3mZtSGzLKpVUfnxeb5PACiguT81wxJNz23y6pxV3miCrj8jL5T/BH+EoBF9CpwaAPKPXqbigAHHKs+eDOtI/u1nMouNGuwLMGu1GVNGeb/Y3bnyypL2uMeTzaoWEJYqGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295471; c=relaxed/simple;
	bh=5t0uQYg27mmUsafZo8rWridbQG0coTZjNSqZ/kF+OUY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qMk9o92ZT7Q6Q3qt7XN+VmO2P1mgZZ+rh7kJgltf3HtTKuxeLY7b1IxjLmpB3gz78kIvoMhVIVYMBn+M7qmwhVi3fT0h8NtkXJ297x0yD1ejEDMZDK3q37gFSpPQZUmy4R7pjErjk8gePlA0HpyCQBgFGh0iPANW/oAyOpiUK6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PSuhJU41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PSuhJU41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0886C433A6;
	Wed, 13 Mar 2024 02:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295470;
	bh=5t0uQYg27mmUsafZo8rWridbQG0coTZjNSqZ/kF+OUY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PSuhJU41BM81HrlwsFnRxuqNt9LoaTJ9LFsOycKO4pNkEfXnZedALRwRGflZldep5
	 WplbQDed2wOTFLMZf55yTWmntkpd8/BfW5clbyoISugHDMACSZGt/J7+9Y6fgcVVNF
	 4XxvZMnbwGX4LceLvJaWxtpK3ww9E5QUJgHwrDAJZQssc5ho0/oqD8VW1ViOU0YyFI
	 2PDdFzQjjfYykIcrPmftCms2xZeCDktJAJxk+U0EUhvjkU2IYBNF+W5kyNUm3Lmh6f
	 BWyJ+k7Uqxt0e5qtvP1VW7b8yUQSyJ2Nwg2POpMBxMObG8FVC2ScCMCUCFYgSZpGHk
	 3tbFf2p6pTV2A==
Date: Tue, 12 Mar 2024 19:04:30 -0700
Subject: [PATCH 44/67] xfs: add lock protection when remove perag from radix
 tree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Long Li <leo.lilong@huawei.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171029431828.2061787.7367710186504342954.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
---
 libxfs/xfs_ag.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index bdb8a08bbea7..1dbc01b97366 100644
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

