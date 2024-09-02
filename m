Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7937814900E
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 07:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725263460; cv=none; b=ndU+HopGWlrmqr6mpMn/PMs/Kj6qdwJNBrmjRG3C4oTrDRPqxzOqPQsARfQmlom7EToRGCnalI5zkhO/ESvRx6eNo5yp3XToHX/5XVeoQip4w3oR1vz8zmH3r40b87HBLttGc5U2v+KfymCPGzRgc2n9Q1s6VHU+BFD9yJBzudY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725263460; c=relaxed/simple;
	bh=QCSWHPxRskPvIs+0/dQVhKoWl+BPzDeWn/uvbb5cVlw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nW009zLYX1Oi5U55kIsCak2qKhTR4Ab8Ub+fAtGKJsDpHN4yYg5NIwnPU/AXuq6EDy1G3t5kso4XovEnOyqwgKXBO0TJ96RTs1qQAUbYETIXD7sk5n69j0p3O5Q+T+P/IgE0D0sQmxTXWQ4ru/TzcYKU6sq/tyTgtQi7tdN48as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jlPKSgK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jlPKSgK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73914C4CEC2;
	Mon,  2 Sep 2024 07:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725263460;
	bh=QCSWHPxRskPvIs+0/dQVhKoWl+BPzDeWn/uvbb5cVlw=;
	h=From:To:Cc:Subject:Date:From;
	b=jlPKSgK2ZTd17p3t7tKqj8fnEa3/UCpJFBn5hxJR0ARphoum8XXr6Rjt++Yj5SLtj
	 XP1a22uleyeuvUg2WQz9SLgIUzGQqZQaUTGilKK5Sl/JpvQy2jMiIjFO26Bza6M4hV
	 cXozAwaZ/XecQIavGmlaxI9YHMakts6LJGIxJLDZnzeBt9A9hYaK4kY1o7iTfVJF0J
	 hzWnT7c8LnQMcYqbQR5fjUdjZ37LH8ZgcsUUPmL08f9HrupLC7x4Rz101RUmug4If3
	 v9KaXpajILcNxebVXNnIpACAbVFZB7LgTTE1ybg/zhnpki/5uWIIEAau73T3y+aIP0
	 RHYoQXc0powSg==
From: Chandan Babu R <chandanbabu@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>
Subject: [RFC PATCH] xfs: Prevent umount from indefinitely waiting on XFS_IFLUSHING flag on stale inodes
Date: Mon,  2 Sep 2024 13:20:41 +0530
Message-ID: <20240902075045.1037365-1-chandanbabu@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Executing xfs/057 can lead to an unmount task to wait indefinitely for
XFS_IFLUSHING flag on some inodes to be cleared. The following timeline
describes as to how inodes can get into such a state.

  Task A               Task B                      Iclog endio processing
  ----------------------------------------------------------------------------
  Inodes are freed

  Inodes items are
  added to the CIL

  CIL contents are
  written to iclog

  iclog->ic_fail_crc
  is set to true

  iclog is submitted
  for writing to the
  disk

                       Last inode in the cluster
                       buffer is freed

                       XFS_[ISTALE/IFLUSHING] is
                       set on all inodes in the
                       cluster buffer

                       XFS_STALE is set on
                       the cluster buffer
                                                   iclog crc error is detected
                       ...                         during endio processing

                       During xfs_trans_commit,    Set XFS_LI_ABORTED on inode
                       log shutdown is detected    items

                       XFS_LI_ABORTED is set       xfs_inode_item_committed()
                       on xfs_buf_log_item         - Unpin the inode since it
                                                   is stale and return -1
                       xfs_buf_log_item is freed
                                                   Inode log items are not
                       xfs_buf is not freed here   processed further since
                       since b_hold has a          xfs_inode_item_committed()
                       non-zero value              returns -1

During normal operation, the stale inodes are processed by
xfs_buf_item_unpin() => xfs_buf_inode_iodone(). This ends up calling
xfs_iflush_abort() which in turn clears the XFS_IFLUSHING flag. However, in
the case of this bug, the xfs_buf_log_item is freed just before the high level
transaction is committed to the CIL.

To overcome this bug, this commit removes the check for log shutdown during
high level transaction commit operation. The log items in the high level
transaction will now be committed to the CIL despite the log being
shutdown. This will allow the CIL processing logic (i.e. xlog_cil_push_work())
to invoke xlog_cil_committed() as part of error handling. This will cause
xfs_buf log item to to be unpinned and the corresponding inodes to be aborted
and have their XFS_IFLUSHING flag cleared.

Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
PS: I have tested this patch by executing xfs/057 in a loop for about 24 hours.
On a non-patched kernel, this issue gets recreated within 24 hours.

 fs/xfs/xfs_trans.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bdf3704dc301..b43436c8abaa 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -868,17 +868,6 @@ __xfs_trans_commit(
 	if (!(tp->t_flags & XFS_TRANS_DIRTY))
 		goto out_unreserve;
 
-	/*
-	 * We must check against log shutdown here because we cannot abort log
-	 * items and leave them dirty, inconsistent and unpinned in memory while
-	 * the log is active. This leaves them open to being written back to
-	 * disk, and that will lead to on-disk corruption.
-	 */
-	if (xlog_is_shutdown(log)) {
-		error = -EIO;
-		goto out_unreserve;
-	}
-
 	ASSERT(tp->t_ticket != NULL);
 
 	/*
-- 
2.43.0

