Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C860847A66
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HqDWRMeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D57AC433CA;
	Wed, 20 Dec 2023 17:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092317;
	bh=7G/UL274rtKbAKQhCnbv3dwuC+UcYc752BQy7RrS6mM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HqDWRMeCrKmjCB1WN3RMfVo9vtXYAO5OPjPyDfiOxB74vTjEWkXDfk/MmLkxfS3Zy
	 yzkbkqfH1kNh6n5lkbsWx9WRwtLyQRJEhkahIP2vteyWsGk9nzfzrNV0bnV9YQ643u
	 GasbvHAoGGiQ76QYpSJTr5G3qJ1OvSmSeBENZScCFJ4lQcFknCkAdJ+I6Mdnk2e6Eu
	 LXetpbRt5GP23RQYJeLli5Z+dOkhQ8WB0r+gfvEEVMGKt629zQozb800GZi331n7Sw
	 rnsVbQQ78i1s1exbbPBReBm68ZXkSztqXdygWasNrdJiLw1Wp/iY3d0o4ajq01DZmU
	 oK4965RLypN3g==
Date: Wed, 20 Dec 2023 09:11:57 -0800
Subject: [PATCH 2/5] libxfs: don't UAF a requeued EFI
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <170309218390.1607770.7016009394079896736.stgit@frogsfrogsfrogs>
In-Reply-To: <170309218362.1607770.1848898546436984000.stgit@frogsfrogsfrogs>
References: <170309218362.1607770.1848898546436984000.stgit@frogsfrogsfrogs>
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

In the kernel, commit 8ebbf262d4684 ("xfs: don't block in busy flushing
when freeing extents") changed the allocator behavior such that AGFL
fixing can return -EAGAIN in response to detection of a deadlock with
the transaction busy extent list.  If this happens, we're supposed to
requeue the EFI so that we can roll the transaction and try the item
again.

If a requeue happens, we should not free the xefi pointer in
xfs_extent_free_finish_item or else the retry will walk off a dangling
pointer.  There is no extent busy list in userspace so this should
never happen, but let's fix the logic bomb anyway.

We should have ported kernel commit 0853b5de42b47 ("xfs: allow extent
free intents to be retried") to userspace, but neither Carlos nor I
noticed this fine detail. :(

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/defer_item.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 3f519252..8731d183 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -115,6 +115,13 @@ xfs_extent_free_finish_item(
 	error = xfs_free_extent(tp, xefi->xefi_pag, agbno,
 			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE);
 
+	/*
+	 * Don't free the XEFI if we need a new transaction to complete
+	 * processing of it.
+	 */
+	if (error == -EAGAIN)
+		return error;
+
 	xfs_extent_free_put_group(xefi);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 	return error;

