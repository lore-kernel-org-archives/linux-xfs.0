Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B7B153BF2
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803994; cv=none; b=Y9iduw7lDtJQz0v0mOsMuWyc8uBHSlmtny0zK/dNaPgI3Ri9GWQyBGHZfEGNfZOJx04lOSXQBDml/rT4ITLCkKwruarZ/WKmFnzEIygyB4QX6wsQQcsURMKyuO322UBWd3cXt/cvhzgnCK852vLSCvxxNIxDfUtxNlO531Rqb/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803994; c=relaxed/simple;
	bh=LfYwI2i/Cl+MWr/gX91Gs26/pBz5iPrUgY4Kaq/uTDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlSLx+c1zCAGPWppTwRa4FFfShfaFpbpBJ5xGHz2TmkqXlGyEbxBSZozx4/e6npzrggjkXXEWClWWBApHA/4xarKWVlhbjYdHvoqn/U8pJ0LGvsctiTIXJ7YLiLxJSzNWd+WK03YZIlA/t4KDkp2Ykb3oToYYqdRu9ErRCnzFuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TUMJQje7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUMJQje7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB82C113CC;
	Mon, 22 Apr 2024 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803993;
	bh=LfYwI2i/Cl+MWr/gX91Gs26/pBz5iPrUgY4Kaq/uTDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUMJQje7pS9FlHyhBw/P1qWYKQNhvlFbcb3Mf4GTvwUFwbLxlzRzqqoV/+cwZQFDZ
	 yrcyotOnG4twFLi7FgevpEomI+OdqCIesUl6yQ7ffJc3CrAa+08Hy00E8Y0UKjNQiH
	 N/OmzGEXd17XwG0bkG64wXh4WpMxXke/6N5qQQdyPo8RkSQ67BKbQMSWdp4DbyjDEz
	 BhgBdzY8Eu8iTJ8eNQ29vd/5h1cRPcJAXq7rxj9W9SwoqJZbzho0FLpuyfq1INxTQ9
	 x1ENkOG93xmPShwOY7qDCIR0mECb+UWdMVSInxuuGvT/eDolrBPJyLiJ/BfKEZDgDN
	 Fsf5SrJliSHFQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 30/67] xfs: set XBF_DONE on newly formatted btree block that are ready for writing
Date: Mon, 22 Apr 2024 18:25:52 +0200
Message-ID: <20240422163832.858420-32-cem@kernel.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

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
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_btree_staging.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index baf7f4226..ae2d9c63f 100644
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
-- 
2.44.0

