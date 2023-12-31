Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE1BBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JG0KsuZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E31AC433C7;
	Sun, 31 Dec 2023 20:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055444;
	bh=T7baWJF6eWj6s6McWBF4vHFSwErlhl9CmAPwhVUdUUs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JG0KsuZiC+TXkcnYO9+UJeuAPJbwF6Lly7e6E4IKACoKRYE62kI8l4Jt6iT73hRZr
	 yqEceXU3qlCgTbYbPahgdTXulFnCFUHQ8xb66nJBfMjjl+H31HICyjw9vlpHwKAbSJ
	 k2Le6Ly5UVRp3CtHWzI4XytnbTtlsHK9Ob+9HKANS1/NoremL/fnwiGUXcQMgF1M5I
	 1Mj8OQiRa60LjZOpQPWJgwsjN+M3+xDNtJKXqGADLJ8q4gvnCJZuAsJLDPxg8IhP5I
	 V4z8ElSubZk2SAgbPY7Y9+EvZxkZM+jZQBIXezGPXeS+fgmKt1DNI9w4jaTBEI/1rR
	 388rHQRT1uIeg==
Date: Sun, 31 Dec 2023 12:44:03 -0800
Subject: [PATCH 4/7] xfs: Hold inode locks in xfs_trans_alloc_dir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <170404839969.1756291.6285058862556086801.stgit@frogsfrogsfrogs>
In-Reply-To: <170404839888.1756291.10910474860265774109.stgit@frogsfrogsfrogs>
References: <170404839888.1756291.10910474860265774109.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_trans_alloc_dir to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   14 ++++++++++++--
 fs/xfs/xfs_trans.c |    9 +++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 910764bf8810f..606d0aec9b450 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1370,10 +1370,15 @@ xfs_link(
 	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	return error;
 
  error_return:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
@@ -2783,15 +2788,20 @@ xfs_remove(
 
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto std_return;
+		goto out_unlock;
 
 	if (is_dir && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
 	xfs_trans_cancel(tp);
+ out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
  std_return:
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 12d45e93f07d5..81337fdb89ab8 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1430,6 +1430,8 @@ xfs_trans_alloc_ichange(
  * The caller must ensure that the on-disk dquots attached to this inode have
  * already been allocated and initialized.  The ILOCKs will be dropped when the
  * transaction is committed or cancelled.
+ *
+ * Caller is responsible for unlocking the inodes manually upon return
  */
 int
 xfs_trans_alloc_dir(
@@ -1460,8 +1462,8 @@ xfs_trans_alloc_dir(
 
 	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	error = xfs_qm_dqattach_locked(dp, false);
 	if (error) {
@@ -1484,6 +1486,9 @@ xfs_trans_alloc_dir(
 	if (error == -EDQUOT || error == -ENOSPC) {
 		if (!retried) {
 			xfs_trans_cancel(tp);
+			xfs_iunlock(dp, XFS_ILOCK_EXCL);
+			if (dp != ip)
+				xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			xfs_blockgc_free_quota(dp, 0);
 			retried = true;
 			goto retry;

