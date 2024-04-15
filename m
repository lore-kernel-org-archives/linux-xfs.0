Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E910159567
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225496; cv=none; b=dCKpA5FlFMbgfm/jpuqb+gWB3l4rLttxzlMz9pMljUpu2V169mtmIqQpvcl3cFk1MQajaCvpNo+HYwtuIpv0DDu+y6t0MtIUR6RKmrnTMmOO8MoB56J6MzCzXas6ECHVPv9oBj/KiWApO5nfcSB/86vHHwuANeKSwQ8L7QZEdCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225496; c=relaxed/simple;
	bh=gy8RZJlhGVv4Voy7qPIsTG1/0xX4Z25dJzqlCwalL+Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GsW3UUroldpdQqX3HvJliCGmA+xCZ3Lay+eUTGjHI/0FVvSTGboYRyEj6QNsqFxcPYIK+fJ4Xo0fe5yjq2reQzASvQ11CxMILXwOmcGZE9xjYbNMNF9c1MPMBTEiOP9pD5u2Xq+IyxrkpK//ZQiabVVKOyr4MArjkKDobVxtavQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hxOVwM2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hxOVwM2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3990C2BD10;
	Mon, 15 Apr 2024 23:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225495;
	bh=gy8RZJlhGVv4Voy7qPIsTG1/0xX4Z25dJzqlCwalL+Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hxOVwM2VxDPVLXFr99+X3MPkqth3YHo9LCaySOwX4Kjvkpz+sSVwczfQ8A/tZ/Lcz
	 NVVrZCuUrcveR5jlj1C+uhvmkSs+r0g8aM0SoJHpTEBhSpgQ+piyl5LoPqlxMDhcDF
	 RFYh2o7DISR+4IkEfv+FGFsWABM/tnf5+Py/7De58YJqiQLlyPQ+oQem3IGYnrf8sf
	 ujTQsXO2lizCIBz6sxGe/Mw2UGlKcnt5P6Z8AH6x0Wv3fz7gS27apJ9NpA/hXpQWMF
	 CchrEeRbpdhWvsSra7/38hPhS7paKgOj/IZj+B5im32FL0dlOSEKvVCb1Ln+QW/Ie6
	 mVV/PRHQ2dv2A==
Date: Mon, 15 Apr 2024 16:58:15 -0700
Subject: [PATCH 3/7] xfs: Hold inode locks in xfs_ialloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171322386563.92087.5298943608727895023.stgit@frogsfrogsfrogs>
In-Reply-To: <171322386495.92087.3714112630678704273.stgit@frogsfrogsfrogs>
References: <171322386495.92087.3714112630678704273.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c   |   12 +++++++++---
 fs/xfs/xfs_qm.c      |    4 +++-
 fs/xfs/xfs_symlink.c |    6 ++++--
 3 files changed, 16 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index efd040094753..2ec005e6c1da 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -747,6 +747,8 @@ xfs_inode_inherit_flags2(
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
+ *
+ * Caller is responsible for unlocking the inode manually upon return
  */
 int
 xfs_init_new_inode(
@@ -873,7 +875,7 @@ xfs_init_new_inode(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup the inode structure */
@@ -1101,8 +1103,7 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
 					resblks - XFS_IALLOC_SPACE_RES(mp));
@@ -1151,6 +1152,8 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1162,6 +1165,7 @@ xfs_create(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (ip) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
@@ -1247,6 +1251,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1258,6 +1263,7 @@ xfs_create_tmpfile(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (ip) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 0f4cf4170c35..47120b745c47 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -836,8 +836,10 @@ xfs_qm_qino_alloc(
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
index fb060aaf6d40..85ef56fdd7df 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -172,8 +172,7 @@ xfs_symlink(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	/*
 	 * Also attach the dquot(s) to it, if applicable.
@@ -215,6 +214,8 @@ xfs_symlink(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
 out_trans_cancel:
@@ -226,6 +227,7 @@ xfs_symlink(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (ip) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}

