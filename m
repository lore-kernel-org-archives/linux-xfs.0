Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C7A57314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422859; cv=none; b=ee3KzEG7I/eXnPkac4vJK+JJg3trJ/YBnuTDM2+4KYRzfKOOdHvqjGz2AzRcfUjRBP6gZ71tw5RUaKeS+SJQUmGFVHXTMQJR2HqcROuHx/KJBp3Nen0ac+seEVuGB4ZKQ/go1RM8xa2X0I5ds7ObIFEaxG9TgPHIm0c+JZwEHOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422859; c=relaxed/simple;
	bh=ikvALEj/y/WI9ndx6gOZLxe6Q13ZYYJgpidh4iPs2X0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RRu62+F/pD/kseJtSWBi94lTw6RDhRL0eReCrs7PORMp9BcdNU0zQow55NvvpVHpNCf9s+NfcDGHHTo5+bqEv3Wc8Ig1nAKmwS9FAhMt4y/A2y+SkXzxgZOLKggXAIt0AwJKwxMqaMLecmGPFi708630dsCmkvhX4l4eTde8p14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=atPO+Aqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="atPO+Aqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547E4C433F1;
	Tue, 26 Mar 2024 03:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422859;
	bh=ikvALEj/y/WI9ndx6gOZLxe6Q13ZYYJgpidh4iPs2X0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=atPO+Aqfh3vtc0LIgfu3gBWgTUlMLFYwsMQyikbSq/bZxZIMgZ+e3mvQpwJuUcNGX
	 F318OfNUJBP1XvuMeYBFs6l8iwo7JC3Ll7sMdYbV9+HU4JNCdsVlWWB5ShAAJoNhRq
	 O5+otYfXcFCOh+lUJX+S2zW5USrdjEK238LjyQvBxNvJk604Q3xrdEvb4dkxrkX5K7
	 6spzfnjAJZ2ndGdTxZDheJ9Fa38UF9s8P9ZFmIOKovp3adGnHUZIomrXHfw2pJ1pyP
	 OTrOjh4O7K7FzmuyGqHYtzE2zX09XTpQ00azogkjZJnVto/ieXCtGQVLWIh6RUr+E0
	 fUKUNyka/6vfA==
Date: Mon, 25 Mar 2024 20:14:18 -0700
Subject: [PATCH 44/67] xfs: add lock protection when remove perag from radix
 tree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Long Li <leo.lilong@huawei.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127591.2212320.10397070337652797766.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

