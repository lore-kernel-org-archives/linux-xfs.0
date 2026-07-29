Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45CC443E4E
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319597; cv=none; b=TaFjgfYVduvs6+MBLejmxP8ubg1npWFRyCOXm09dUaxzbRdhM9iVY/5cz+lICu3hsfR20u8KKNV6OFFh6sIKsaIBt2/TMXsRVUKyuaODeq8bpjEK3efrLSkJFME+S4YdbdeFSrlbuE44Vw3ECW4G2XhzOzEinyVKR1sAYEVUdWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319597; c=relaxed/simple;
	bh=fOpCBeFV+Rg/rTL5w67wDPrWTg3czLzAZDUMXGL5kDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imHw1hW/en+34SExn8A+L0NqrTNczf9qpm+Bg1UXTNVKUOGMNWNApI1bixp+/gLBR6DU7l7RdVAI0cS1pNyzhhH4CXB88nFocLeRjKzXVAldPL6OqnrqqBRUMIjSnEirzmpliHjeLppkBz5B5LX9hQ/kNX+Q4s52f4N9wpoAosE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJ54EOXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJ54EOXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01E01F00A3A;
	Wed, 29 Jul 2026 10:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319596;
	bh=aCu5LIfqFAp6nIiFs8KI2Ikh1Li7iftABTkdZjCVM4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJ54EOXT5BxVUvWRcTOTeJsYTVkR8r+bA29fGOV3nYYPvFr/tIhuSX8WRI4/kVbvz
	 Zz/v0tB0ZNOkpuJcq3ORO1s6sl2KmqGxHT/NsXr0TDSFd/S0CuhiHaDnwFyKgxx+ka
	 sW74EVdsEM5cQIg2D1xL59cVDJDn8Hh0+NETFlR9zUKA2X0MGdE89MBLipL0TtEZeK
	 6iP0GdnUidb/wjusC2YFxUuGAWqsr7/qG8nAkBdS/cdf/728BSC5+pqTpFQe3YMNj6
	 lx53eSHr4EKoPA7pCDhuphDu91Z+5EOg9zgz0XxmSEzbHcT9rxJBkYZQoxi8lm9Odt
	 7Glz+tvkAIr6w==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 01/33] xfs: fix dirty transaction cancellation in xfs_bmapi_convert_one_delalloc
Date: Wed, 29 Jul 2026 20:01:45 +1000
Message-ID: <20260729100629.1943710-2-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729100629.1943710-1-dgc@kernel.org>
References: <20260729100629.1943710-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_bmapi_convert_one_delalloc() calls xfs_iext_count_extend() before
checking whether there is actually a delalloc extent to convert. If
xfs_iext_count_extend() modifies the inode's extent count fields it
will dirty the transaction. If the subsequent extent lookup finds
nothing to convert (e.g. a racing COW completion moved the extent to
the data fork), the function returns -EAGAIN and the caller cancels
the transaction. Cancelling a dirty transaction triggers a filesystem
shutdown.

Fix this by moving the extent lookup and validation ahead of the
xfs_iext_count_extend() call. This ensures that if there is no extent
to convert, or the extent has already been converted by a racing
thread, the function returns before the transaction is dirtied and
can be safely cancelled.

Fixes: 4f86bb4b66c9 ("xfs: Conditionally upgrade existing inodes to use large extent counters")
Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d64defeda645..47c4d5c52b95 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4380,11 +4380,11 @@ xfs_bmapi_convert_one_delalloc(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_extend(tp, ip, whichfork,
-			XFS_IEXT_ADD_NOSPLIT_CNT);
-	if (error)
-		goto out_trans_cancel;
-
+	/*
+	 * Look up the extent before extending the extent count so that we
+	 * don't dirty the transaction if there is nothing to convert. A
+	 * dirty transaction cancellation on -EAGAIN would shutdown the fs.
+	 */
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
 	    bma.got.br_startoff > offset_fsb) {
 		/*
@@ -4409,6 +4409,11 @@ xfs_bmapi_convert_one_delalloc(
 		goto out_trans_cancel;
 	}
 
+	error = xfs_iext_count_extend(tp, ip, whichfork,
+			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	bma.tp = tp;
 	bma.ip = ip;
 	bma.wasdel = true;
-- 
2.55.0

