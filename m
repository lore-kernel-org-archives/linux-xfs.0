Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14773BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="txltuD0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8828BC433C8;
	Sun, 31 Dec 2023 20:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055428;
	bh=85IYLaWJhqUeoHqjRFeM7978Es17iGgEJLLURhPjtpM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=txltuD0fZ4gkqqgv8WJ4Sg5wNkgcvrphUfet5Qqw5TexkA82hyeDP0iWeTe3mmlo3
	 NLoLH08giBTTcRCZSAnAlTxpHgTBkx+0p1olYk5GmoO0MLJL+TvTkE/bRXCrkM/hUv
	 GdetOO6h84dYvXTCDJokTqZAd4O/J1BG+7xQehTJGLoNZ1y3ko2w3uhYGf2FNgmKI9
	 stirnS9a1z3q9EZmLMvAtitUg050kJt3LHljiT9x6srA28x/dsjO4b1udMJkLC1bhm
	 0leQff3lqyvLhkFZkM4W8DOZjD92Gpk14pJx8f0nZLRmSH1UcTM/JcyyJpFFwzuvMP
	 eoSw8XOXtkBgw==
Date: Sun, 31 Dec 2023 12:43:48 -0800
Subject: [PATCH 3/7] xfs: Hold inode locks in xfs_ialloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <170404839953.1756291.12809738582908157349.stgit@frogsfrogsfrogs>
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

Modify xfs_ialloc to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
[djwong: hold the parent ilocked across transaction rolls too]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c   |   12 +++++++++---
 fs/xfs/xfs_qm.c      |    4 +++-
 fs/xfs/xfs_symlink.c |    6 ++++--
 3 files changed, 16 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6ff3d2cab5802..910764bf8810f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -769,6 +769,8 @@ xfs_inode_inherit_flags2(
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
+ *
+ * Caller is responsible for unlocking the inode manually upon return
  */
 int
 xfs_init_new_inode(
@@ -895,7 +897,7 @@ xfs_init_new_inode(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup the inode structure */
@@ -1114,8 +1116,7 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
 					resblks - XFS_IALLOC_SPACE_RES(mp));
@@ -1164,6 +1165,8 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1175,6 +1178,7 @@ xfs_create(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (ip) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
@@ -1260,6 +1264,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1271,6 +1276,7 @@ xfs_create_tmpfile(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (ip) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 4f357cb6de748..c25d917487f0e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -835,8 +835,10 @@ xfs_qm_qino_alloc(
 		ASSERT(xfs_is_shutdown(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 	}
-	if (need_alloc)
+	if (need_alloc) {
+		xfs_iunlock(*ipp, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(*ipp);
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 06df5522db7a5..307a2b7e5426e 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -173,8 +173,7 @@ xfs_symlink(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	/*
 	 * Also attach the dquot(s) to it, if applicable.
@@ -216,6 +215,8 @@ xfs_symlink(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
 out_trans_cancel:
@@ -227,6 +228,7 @@ xfs_symlink(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (ip) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}

