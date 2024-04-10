Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FC237C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710098; cv=none; b=Hx0Z+3yKSNZZqW43elTVYXa8O6i9wuZDdIs6Ojap+5LM7n43YBTmQoxWO7e3SFRjPw0GW/klqQR1wVD1fKnbfXS3Yo6dA2PnkIuse5SwQwAkGmrAIJ/D+R2ZPDeT5eB3e2gnyO6xsWMlQHrm47wEssJ+7Qs7jRLTA9uTU4QTGNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710098; c=relaxed/simple;
	bh=9R6yQlLfuCAAAvEDqJSLaF6pr+p8JuCJfxVRx9oUN/g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TPqRDpuElRuyp616VxBLWB7Khy/loP8GJwk9MQk2YyorH9MMiaeo00v61MqI9QlXyQ5le+IckpVzu1s//7g1LqMwknZ8Jnfvras9ANG12VuJ3MZyyQHxDG46LQjsJSgivJ9LhMLnu0/B0rthY+IAJIsg8YUv+7+L5i+OxczgP44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPSgqEGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPSgqEGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497AAC433C7;
	Wed, 10 Apr 2024 00:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710098;
	bh=9R6yQlLfuCAAAvEDqJSLaF6pr+p8JuCJfxVRx9oUN/g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lPSgqEGte7BBOcAGnjxSzmWgVojpX9+u/WaFTFoTq8LpKtrT0sI7fQy8xZRe77dbV
	 K/kEnxeH6n0gQkEQN4/EwivWJkiytxDHqyOINtIWa5N2EEvQBLvDa8jTF47YkrrdiG
	 eIyG7F5F1WYRr2tnDzmEyN1+u3YF8ffSTt6gyoNX5aAkNsBv7kCq6qA+lDpaOvTUCl
	 uLu6ocbx7GORtLIouiH7Q2YU9XVk2ArVahpa9r93CyKEC2If3NDsZ6XaUvShfWMl+2
	 VokrnlAdcrTzScsOx9Qun3iGT9lEiOlLn5zd3EOtEfSMPKL5cVT/380ebLl69hfSTm
	 ExIiTc+a/61nA==
Date: Tue, 09 Apr 2024 17:48:17 -0700
Subject: [PATCH 3/7] xfs: Hold inode locks in xfs_ialloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, catherine.hoang@oracle.com,
 hch@lst.de, allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171270967955.3631167.14088032466565972952.stgit@frogsfrogsfrogs>
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
index efd040094753f..2ec005e6c1dab 100644
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
index 0f4cf4170c357..47120b745c47f 100644
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
index fb060aaf6d40f..85ef56fdd7dfe 100644
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

