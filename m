Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8CE3BB13A
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 05:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143105; cv=none; b=s7q+a8nkvl53CnSiSHmsbFwSUo7oswdL0uuo8lk+S2uQ+0KQ3AxcvhV3jQ8SavUX0PrNIXXtqxgQ1VL7IPOuaXO0mnYjoo12qwzgAvFdpcWKnMI3YpTfR2hrL0gnjPJM7ZB/fTtExu76Fnw2mipAw8axXvfUQOHZpiZNuksDntM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143105; c=relaxed/simple;
	bh=sHS/m/vd9XOOu/Oie8kY3UC9R1De/znWQ8yx45kBIyE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TkeqNwEgAWtB67RwOsC0AGOT3BqiDLMMFkhXdj5N1g9L0xgkqNpSOucV0rXWFDzqQYW5B7tdTEYJ9Cq/yM72dFhgm5P405UcVrSBqPFtLBjFSvPEDDOHEwfNe6cr2a9sSWTxAZt5Y7hs6WYVacO+6tcUKuBSLl6UO7Gj738p3ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvPIiCfm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvPIiCfm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A0F991F000FF;
	Wed, 23 Sep 2026 05:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143104;
	bh=V6iG/mS17xFEQ3cdOVsUe+P5o/4gtkDIYAD07KHmgpY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=fvPIiCfmiH1fTkFJ52fS2N2UUTjK2CgFZ/2B/gbCeoQY+2XvuIyFk+BSWKr3qdMwp
	 5gUaKsFaVnijFpZ1Z0dZPhBlhyc31rZGEw2Xs15m6h/81baL+VE4HJ3y8OA0ygZ+gi
	 XhttZpQUHhasR3sbbnHkhcaRtbzbWm0hICtih7uLUdSOS6+5LhC+X5EWUzljZuBSGM
	 Dz+AZ5JeBOnP1Aaa/hzHaJW4knW4WHApiyRw4VrEccai75T/cOoj91xmia0Nl9gXhx
	 hLtIu/V19LYYDszlNsdVFbqczEpzJK7+5xI8sOt++iQQrud8a8A+6O5lZOFmydS1KI
	 UtyJLRACExnhQ==
Date: Tue, 22 Sep 2026 22:58:24 -0700
Subject: [PATCH 04/13] xfs: clean up after failed metafile relinking
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179014159013.1874904.6962968533158888275.stgit@frogsfrogsfrogs>
In-Reply-To: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
References: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
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

Fixes: e80fbe1ad8eff7 ("xfs: use metadir for quota inodes")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

