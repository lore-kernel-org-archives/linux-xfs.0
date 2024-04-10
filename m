Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C5937C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710114; cv=none; b=JZfVlW2op/n4INFfhiafBtpC3d6xzjJSiwrjA8DQUVx6UD5cHPaCVcpFBXmfX5kYLtBBbzVYZMYPMsNSU41Tr5s6DQ2/hW2divZ4jKvLgwAfIIf1E+Hi1TaBuy/92lgkkBSf3KSvl1kQ2S8dAtLcyIHSHpkCNqCRFmdMrU+FK3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710114; c=relaxed/simple;
	bh=gRLu6dqJiVtyjY+mQm1VBrVZBKzn+bx6pEsVJVj+qrc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZZQAqgCCGvOqCsTsUK5+7cN1KuyZHb9XS7RCR6KhpEz4E+NET/7BWrrd2Rvcny6h7hMwnzJIYwRH95fjYpSMxA2IF631TMmsSc14cGOtfcH173PYv19PcOoG0IWsq6jcNVwW5bt9K+VLqNee6Yg+T73MtD9Kz4zbgV9WcTHQKwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izPKK10z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izPKK10z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1FCC433F1;
	Wed, 10 Apr 2024 00:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710113;
	bh=gRLu6dqJiVtyjY+mQm1VBrVZBKzn+bx6pEsVJVj+qrc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=izPKK10zNfANf7IDC4XcPU/lDP4/clW0flOCPNJuAU+7JC2S2gdxX+kyYGDdO02xi
	 aD7ZR9n4DefxNyiWrYhmMh2d11mjIdlev5Ahos1yoANrLgKloOeVSccKsKktUGwryr
	 hXlDK+ZlinXOOjPCT9rX8qY4srkHsrHLgauOTfCin2DwAZ3B7vnCJm2OMPDoenPJ93
	 oO6xTGwcy8CSmbEHUik0Cgn76AER01TxEF5/uogDNYn5eRzwNMlvM4uaUZpO03dXRP
	 tL/L64ZWhmIGxGx/K6VrIOZuyw2++yemQzea6mHKG0+Ox3c1bW15UJfd8dqUvv79y3
	 UylMNS2fHNQcA==
Date: Tue, 09 Apr 2024 17:48:33 -0700
Subject: [PATCH 4/7] xfs: Hold inode locks in xfs_trans_alloc_dir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, catherine.hoang@oracle.com,
 hch@lst.de, allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171270967972.3631167.11876713799653099191.stgit@frogsfrogsfrogs>
In-Reply-To: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
References: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
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
index 2ec005e6c1dab..36e1012e156a1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1368,10 +1368,15 @@ xfs_link(
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
@@ -2781,15 +2786,20 @@ xfs_remove(
 
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
index 7350640059cc6..50d878d78a5e1 100644
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

