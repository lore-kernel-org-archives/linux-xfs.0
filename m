Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BFAB663
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295252; cv=none; b=uTT0cVVZXBftoL7iPGybesrwAa+uEhMqR8pLIZL12DkrpEVktIRysuYahnEqVSF0NEgTizMCvI9dsLcd3B2eYjhZg6Pn9RH0+qn6/r7ZR39hIZDNv4Hf7BeXxAMPXe884954Nn9ioKQL1Q52Y5kFA/TwTBwURU/8BC0e8eV74kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295252; c=relaxed/simple;
	bh=4ewVXUA4tD7RL6SyRz+9CftZCrpevqvXi7K3CEOsRgM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FXLuboqAqML9K1Nikwt7ZyHJyc1w+/SO7DB/N8ENzOdnG2tT8WDXQNhmJrXA1hclYIPo1MF4CJbgZMh41G2HhlTNaj2e82UnQrK/JjUoroojp2QBSYf7f6zStXDxYJhUmCPiY4Z8SditVKOgE6yfr4xqh2bM1tZI+ZGOMgQdKHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y7T+zoYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y7T+zoYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26DBC433F1;
	Wed, 13 Mar 2024 02:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295252;
	bh=4ewVXUA4tD7RL6SyRz+9CftZCrpevqvXi7K3CEOsRgM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y7T+zoYEMXN/7L2EmKgqgRQsTNGCBcZN+FXnhtLymT9sWqxfngAtb6vKRZyJUeSE3
	 ON6q2yVfoOvXaj2yV5yKcdMX0t5WbN/FrS1enkAguw7NqcAtTYJQ1ALeqlgsB9XME1
	 1NleUQCRcPlpehYUxZX9JN3X56hqBC011/OiGzyOw93LGPzJQH1L+k8rvgbIMtwuxI
	 78/cQrM9y95uLx91OLuh7AvunZXKmoUpKyO89EyHBm5v94o1ZoZyBFcUd9ufpcV0P9
	 8piV7tZhVJVsDnCuNIuAGvGGMRvzI5xBjCDIqyJsHcINNTPGrIZwBKpyw4gfR54av9
	 DzmNDDITzgIfQ==
Date: Tue, 12 Mar 2024 19:00:51 -0700
Subject: [PATCH 30/67] xfs: set XBF_DONE on newly formatted btree block that
 are ready for writing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431627.2061787.13154035033729176250.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: c1e0f8e6fb060b23b6f1b82eb4265983f7d271f8

The btree bulkloading code calls xfs_buf_delwri_queue_here when it has
finished formatting a new btree block and wants to queue it to be
written to disk.  Once the new btree root has been committed, the blocks
(and hence the buffers) will be accessible to the rest of the
filesystem.  Mark each new buffer as DONE when adding it to the delwri
list so that the next btree traversal can skip reloading the contents
from disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree_staging.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index baf7f422603e..ae2d9c63f484 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -342,6 +342,12 @@ xfs_btree_bload_drop_buf(
 	if (*bpp == NULL)
 		return;
 
+	/*
+	 * Mark this buffer XBF_DONE (i.e. uptodate) so that a subsequent
+	 * xfs_buf_read will not pointlessly reread the contents from the disk.
+	 */
+	(*bpp)->b_flags |= XBF_DONE;
+
 	xfs_buf_delwri_queue_here(*bpp, buffers_list);
 	xfs_buf_relse(*bpp);
 	*bpp = NULL;

