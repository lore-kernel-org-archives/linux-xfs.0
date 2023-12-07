Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C420A1841
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="haWIuWfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9509DC433C8;
	Thu,  7 Dec 2023 02:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916730;
	bh=FfoaRmzhhtIQFXsPPI6mF04MCC43F+Scnxo79yTb0YE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=haWIuWfq3c8ipPvKAJxTlu+XmgvSZVuAwMdtE/yTWUcnImns9OV+RuR21pwdHWpmY
	 ShckxvOypex9dDMWhVkl2ROeI6b59DPcrdFa/rEBRj+dsa52kMOMA2xg4BR1lCqSQh
	 KA2kQUVszmIZhZpjWgvoOgRGvlXxJjZ0RJ6ulsxDRMdrkmxywbBWA+iF3Q4yIf9eLv
	 3t2wwbRXnXNfJMpjIyva5JDaH5GyTGxS3dFFUEIM80ndJIHdxHvIHUodmDqmGpiKi1
	 Uze/USb+dq4kcg+g1ibjd8dJ2rV0fIKfBijyDXepqJcjrJsoe+0DRMzh2Xx0ag5cZY
	 2w5qrxPWij6Ww==
Date: Wed, 06 Dec 2023 18:38:50 -0800
Subject: [PATCH 2/6] xfs: set XBF_DONE on newly formatted btree block that are
 ready for writing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191665178.1180191.7709444254217822674.stgit@frogsfrogsfrogs>
In-Reply-To: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
References: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
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

The btree bulkloading code calls xfs_buf_delwri_queue_here when it has
finished formatting a new btree block and wants to queue it to be
written to disk.  Once the new btree root has been committed, the blocks
(and hence the buffers) will be accessible to the rest of the
filesystem.  Mark each new buffer as DONE when adding it to the delwri
list so that the next btree traversal can skip reloading the contents
from disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ec4bd7a24d88c..702b3a1f9d1c4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2152,6 +2152,14 @@ xfs_buf_delwri_queue_here(
 
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 
+	/*
+	 * The buffer is locked.  The _delwri_queue below will bhold the buffer
+	 * so it cannot be reclaimed until the blocks are written to disk.
+	 * Mark this buffer XBF_DONE (i.e. uptodate) so that a subsequent
+	 * xfs_buf_read will not pointlessly reread the contents from the disk.
+	 */
+	bp->b_flags |= XBF_DONE;
+
 	xfs_buf_delwri_queue(bp, buffer_list);
 }
 

