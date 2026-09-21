Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D77035F19D;
	Mon, 21 Sep 2026 06:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971365; cv=none; b=kk1nPtKXH2LTNJ0WxJs5RlQIJg2LCXqADQRt4Bh3YOaaZtPH7zroTWp0fziSo42Cx2DV6VfgreQBy3/N5LqGHxUCu9XtnIBeBS09RvVC0hunrrMsu5JA3bqsBsfvNvtZKrfFIiiUmKu/+NpKcHOV4ZXj6gXaP7GyGpT0IHxpIZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971365; c=relaxed/simple;
	bh=VO/fddkPSJikQx5PP6jgIB+JJ0i0Pu+v10G6hZWgZfM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F89d2+5RuI/4fUy7uadqkQnsnPllAnYRCldGWKyLd8pvONPgsrJGzmvIKiHMQVLbhwetB5kpG9TXFIPU2ZfYpXYRDL0CShGejyqhR2n/0mcrlVXD5BXm6+Ft1GbtT7ZOqjAG+7DCPpccLeInCNlNPYvLYTGczOlT70Yg5KcBY2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FUIV1vcF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FUIV1vcF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C7B8E1F000FF;
	Mon, 21 Sep 2026 06:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971361;
	bh=/08bzoSYCvPUWR0t3E0KkOnb2TgE5F0v22iah8jRwWc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=FUIV1vcFtwvlnvUNSYgWRe2rEfQWIcGiWRWhvGqHLMXpU+FapjZkRuBwFZlSSDsBq
	 KOxF6hNf4flKohA/gjMnqhPwow2GylXEOHNQhD3o+00qumsMto6z2QDKIcGABDaK9m
	 OdWp1gddhAEyfEEwcMj8/Fm0yCvxdw0toai5IGYOV4XkEIT4MDvssripZl+gfVuYK5
	 d/0KSRyxE+P24+wySt0NKD5F0Vk/M/8XrggOj2FknKSn0W5ttxCNiMv924WcZ2HLOT
	 rr2+9ur6Q3fH9JTKNMRLHkQGikaYs9EE4m1CbXNgYshgFUFcfIZ96ffm5pdkhDGpy9
	 eecqpWTLgxXdw==
Date: Sun, 20 Sep 2026 23:16:01 -0700
Subject: [PATCH 04/14] xfs: clean up after failed metafile relinking
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178996120636.181988.3123812677951717201.stgit@frogsfrogsfrogs>
In-Reply-To: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Once we start a metadir update to link in a file, we have to commit or
cancel it, just like any other operation.  LOLLM pointed out that I
forgot that, so fix it.  This fixes a bug in xfs_repair.

However, in commit e80fbe1ad8eff7, we made xfs_metadir_cancel a static
function within xfs_metadir.c, so we can't just add a xfs_metadir_cancel
call to xfs_dqinode_metadir_link.

Instead, create a new xfs_metadir_link_file helper in xfs_metadir.c that
takes only the xfs_metadir_update object, and handles everything from
start to finish.  This enables us to make xfs_metadir_commit a static
function too.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: e80fbe1ad8eff7 ("xfs: use metadir for quota inodes")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_metadir.h   |    5 +----
 fs/xfs/libxfs/xfs_dquot_buf.c |   13 +------------
 fs/xfs/libxfs/xfs_metadir.c   |   30 +++++++++++++++++++++++++++---
 3 files changed, 29 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_metadir.h b/fs/xfs/libxfs/xfs_metadir.h
index e434b9d1c93200..b64f9fc5ca7867 100644
--- a/fs/xfs/libxfs/xfs_metadir.h
+++ b/fs/xfs/libxfs/xfs_metadir.h
@@ -38,10 +38,7 @@ int xfs_metadir_create_file(struct xfs_metadir_update *upd, umode_t mode,
 		xfs_metadir_createfn create, void *priv,
 		struct xfs_inode **ipp);
 
-int xfs_metadir_start_link(struct xfs_metadir_update *upd);
-int xfs_metadir_link(struct xfs_metadir_update *upd);
-
-int xfs_metadir_commit(struct xfs_metadir_update *upd);
+int xfs_metadir_link_file(struct xfs_metadir_update *upd);
 
 int xfs_metadir_mkdir(struct xfs_inode *dp, const char *path,
 		struct xfs_inode **ipp);
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 77954d1d924cc3..6c8a9afdfb1c0f 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -454,19 +454,8 @@ xfs_dqinode_metadir_link(
 		.path			= xfs_dqinode_path(type),
 		.ip			= ip,
 	};
-	int				error;
 
-	error = xfs_metadir_start_link(&upd);
-	if (error)
-		return error;
-
-	error = xfs_metadir_link(&upd);
-	if (error)
-		return error;
-
-	xfs_trans_log_inode(upd.tp, upd.ip, XFS_ILOG_CORE);
-
-	return xfs_metadir_commit(&upd);
+	return xfs_metadir_link_file(&upd);
 }
 #endif /* __KERNEL__ */
 
diff --git a/fs/xfs/libxfs/xfs_metadir.c b/fs/xfs/libxfs/xfs_metadir.c
index 7c6b086b73db61..1ff26e55b1864f 100644
--- a/fs/xfs/libxfs/xfs_metadir.c
+++ b/fs/xfs/libxfs/xfs_metadir.c
@@ -317,7 +317,7 @@ xfs_metadir_create(
  * Begin the process of linking a metadata file by allocating transactions
  * and locking whatever resources we're going to need.
  */
-int
+static int
 xfs_metadir_start_link(
 	struct xfs_metadir_update	*upd)
 {
@@ -364,7 +364,7 @@ xfs_metadir_start_link(
  * The path (up to the final component) must already exist, but the final
  * component must not already exist.
  */
-int
+static int
 xfs_metadir_link(
 	struct xfs_metadir_update	*upd)
 {
@@ -409,7 +409,7 @@ xfs_metadir_link(
 #endif /* ! __KERNEL__ */
 
 /* Commit a metadir update and unlock/drop all resources. */
-int
+static int
 xfs_metadir_commit(
 	struct xfs_metadir_update	*upd)
 {
@@ -499,3 +499,27 @@ xfs_metadir_mkdir(
 
 	return xfs_metadir_create_file(&upd, S_IFDIR, NULL, NULL, ipp);
 }
+
+#ifndef __KERNEL__
+/* Link a metadata file into a metadata directory. */
+int
+xfs_metadir_link_file(
+	struct xfs_metadir_update	*upd)
+{
+	int				error;
+
+	error = xfs_metadir_start_link(upd);
+	if (error)
+		return error;
+
+	error = xfs_metadir_link(upd);
+	if (error) {
+		xfs_metadir_cancel(upd, error);
+		return error;
+	}
+
+	xfs_trans_log_inode(upd->tp, upd->ip, XFS_ILOG_CORE);
+
+	return xfs_metadir_commit(upd);
+}
+#endif /* ! __KERNEL__ */

