Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3129153BFB
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804043; cv=none; b=k+eyFF3ZNDogQsQi3cyZPJsJxtzUlBmM058lKyYT1YR/DRVTZB/vuAZGY5o7zdnGEaGqSYvEWRdj2CEK//EbIKlOpChsaDDxvALBoziuKd4Vb0ZDHR1FEfOwUXp7It1nFHr0DhC4x+ouMM69iAwqFwpClOqzQIq82EJtiXZJpEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804043; c=relaxed/simple;
	bh=ftz1jEtiHbhcvz4RBiJZwh7BMm9+3il6XPTF5OC4vXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKxWy6lPjZ6ksAqe/Bgh2qhUuTwlEmbtB86UgquASM3dUdD/6L/I9GqJA+xgjOLE/r7m/DtTFLfSw4Hr3g7nPvP2JigQEt5heYyN1owVfIhyAqSugT4ikcSFSyNDt8cZcQMznUOOQgOAw44Xz/T++WscB0i5nir+IMWtjP9IgzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jsy6OL4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jsy6OL4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9978CC116B1;
	Mon, 22 Apr 2024 16:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804043;
	bh=ftz1jEtiHbhcvz4RBiJZwh7BMm9+3il6XPTF5OC4vXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jsy6OL4kbCjWimzrf+045t9zYgEFB5MuznWv8/R8ei34dhWI8OiwQ+F6cQjYhxND9
	 oY/IGiDpLO/A7yZG326snWObvEd4E+4GdfaU6fVAwA6cYdaIyl7WOuQGpUSJ1nOoU/
	 G+zO1eQ+ctRf60682C83K5gyCGlYwTEEURY2PMu6n1n6XkEo9F/yv1IRCW9KBwq6D6
	 3QQofBQIzx77Yn0bNY16k9pqrtvGAYd0XB5Rqz8kkZny/uuCt0A1pH6OIHxEtvdtuY
	 eIZZnCZ0Nx5ChiUeZIOR7qxzrKgxmwKhoZlWndWuTJyFmywd/t4sIbRHZgWjB9IWIc
	 EB8gJARpwXMKA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 63/67] xfs: fix a use after free in xfs_defer_finish_recovery
Date: Mon, 22 Apr 2024 18:26:25 +0200
Message-ID: <20240422163832.858420-65-cem@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 4f6ac47b55e3ce6e982807928d6074ec105ab66e

dfp will be freed by ->recover_work and thus the tracepoint in case
of an error can lead to a use after free.

Store the defer ops in a local variable to avoid that.

Fixes: 7f2f7531e0d4 ("xfs: store an ops pointer in struct xfs_defer_pending")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 077e99298..5bdc8f5a2 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -909,12 +909,14 @@ xfs_defer_finish_recovery(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
+	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	int				error;
 
-	error = dfp->dfp_ops->recover_work(dfp, capture_list);
+	/* dfp is freed by recover_work and must not be accessed afterwards */
+	error = ops->recover_work(dfp, capture_list);
 	if (error)
 		trace_xlog_intent_recovery_failed(mp, error,
-				dfp->dfp_ops->recover_work);
+				ops->recover_work);
 	return error;
 }
 
-- 
2.44.0

