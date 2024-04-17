Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452992BAE2
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389596; cv=none; b=YL/iaU3QlMvbWnpS+RPWDjJMmT7GlD8SLrtDIwK1KpMt/3f7xFMeCxrkp6PBR42mHW20OBJordjypa44YTJ+PEdjUGXuNqU3gHj29axj9MoZnouHmuufKXN+FF5/uJsBPDVLMLhguNiK9L14Z9Bg0ZSOdPap7VF/CMv6UYdFNX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389596; c=relaxed/simple;
	bh=FhEHCc9YvqYdW9CUrjdLLQZsSBpy8JyTDaU2+CEg9LA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KvgAJsLdTJr0I00rSs2JKIxVEzyoGFNiAlN+Wk6iCEozU76s80nrDxlg4muglsr7EDkA9hTQpsp6dbEhN2JYswFtb+56Q8OF7MeYtS02x5aVx7RnG830/e/dHQs/t8wuKSHef9IGTRfGP9OnD2h9bg0BvyJk+iHR+1XiHSBjDOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eSyDDMbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eSyDDMbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2842C072AA;
	Wed, 17 Apr 2024 21:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389595;
	bh=FhEHCc9YvqYdW9CUrjdLLQZsSBpy8JyTDaU2+CEg9LA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eSyDDMbe8z/RgCp72h5MZvAMl+XmEcGZ4rr8tyzlkKpgfi4/VI2AOC92jTLodtb6E
	 H5dBSYk8kze5noWZcHjrJOcPTHA2AsmuF0LEEn9JFEnqIVwKFiYLDbX76ZjUKo7kPH
	 WbVNrXn+54ij1uLCTC2UrS5sFvhn3ydRnBigu0wDhmjn0u4vQpUWTauYx9QXtPoJLV
	 Tw67nJlXffQmEjS0lF3LNF43yO6Bn2XKOg0bzF7TgTKoGcIObmxpTn6a/zylcpRiwm
	 zDT1HVukrCKkKBN000QLXqMA1dFKx3UYqwO0orlboW2dOlZQMve7CwEQ/gsckb4A6E
	 1+ugmQNu+lTTQ==
Date: Wed, 17 Apr 2024 14:33:15 -0700
Subject: [PATCH 44/67] xfs: add lock protection when remove perag from radix
 tree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Long Li <leo.lilong@huawei.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843000.1853449.7497594288174839094.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_ag.c |    4 ++++
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

