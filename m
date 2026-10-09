Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683203ECBE4
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589555; cv=none; b=X+MA+51ypv/iOG/ToO2Ezh/9SXt5Kr1HBQ3YbjgXkKJfpfk51GleqwYEMQQFvbJcBkpb39hJ+wgiwYTIQVd13VLdxPi63D5jce/vLlqqPs1QIGKQKllD0u34qgTd4xTVKuHmAtuM/30V63lvClMTvqFxw9sni6sS5DkvbSO79xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589555; c=relaxed/simple;
	bh=aZar/iN65WZFSTCftREXxdx02vaZ97MjVmOnvWSIAn4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UXrGq3NUQgozNvLvKqU3AeYwTk7YEajDB+4CMIdyN0Gq6V5lvdY1kfanEhMbglcwFuGFLsGfTGZNZJCfNMbA6uU/s+RbDbiUpkSw0ox5SzmLixjJu5dBbMmeldDnxyMvREPgtRw0HmTRQWu8i9SfH/M8qOPxrX+96snzrK8BMZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJPNFrqW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJPNFrqW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 144A31F00893;
	Fri,  9 Oct 2026 23:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589554;
	bh=3QDXrz+ww3ZYGQvOuI5TeeCbXT7Q7uKxF23xu3yi15w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=KJPNFrqW/yn/iO7xsLHsFL3DA5Ui3uTKPa30/mOfoWmjo5ACSrcpPtWHiB9UXmz30
	 rWzKPpVGQP/pswepx/S4r8IfmA769eZDyOB8f/bodqWagLHDVmniXwc89eL7Lm8g3n
	 Muxd5V/NIGOyego5DjhsuQqcWGtQWZTdQmsGHjnaxAXn8BwTK/q0na/uPPfK84HFti
	 S2f60lhPkXL+riMR3Zs9HdBZ99QwlMayyxFRwIRGHRlUt4v8WL1GpIumP7b4B+FHdM
	 Qsac1rnBsRUQolsaDKocTG8Cytgv6/v0c+e/BnQvIRBvhfdk+R8B3skPu14rBJ4LZk
	 PlHG8nug5iIaw==
Date: Fri, 09 Oct 2026 16:45:53 -0700
Subject: [PATCH 01/26] xfs: add xfs_metadir_create_file helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, johannes.thumshirn@wdc.com,
 linux-xfs@vger.kernel.org
Message-ID: <179158947386.3719791.14958932228183914453.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Source kernel commit: daf43402da0d3a66eda26fefe3473799165bd7b2

Factor the metadata inode create/commit/cleanup lifecycle out of
xfs_metadir_mkdir into a reusable helper that takes an optional callback
to initialize the new inode, and convert xfs_metadir_mkdir to it.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_metadir.h |    6 ++++
 libxfs/xfs_metadir.c |   78 ++++++++++++++++++++++++++++++--------------------
 2 files changed, 53 insertions(+), 31 deletions(-)


diff --git a/libxfs/xfs_metadir.h b/libxfs/xfs_metadir.h
index bfecac7d3d1472..a795a2d0e3fe5b 100644
--- a/libxfs/xfs_metadir.h
+++ b/libxfs/xfs_metadir.h
@@ -35,6 +35,12 @@ int xfs_metadir_load(struct xfs_trans *tp, struct xfs_inode *dp,
 int xfs_metadir_start_create(struct xfs_metadir_update *upd);
 int xfs_metadir_create(struct xfs_metadir_update *upd, umode_t mode);
 
+typedef int (*xfs_metadir_createfn)(struct xfs_metadir_update *upd, void *priv);
+
+int xfs_metadir_create_file(struct xfs_metadir_update *upd, umode_t mode,
+		xfs_metadir_createfn create, void *priv,
+		struct xfs_inode **ipp);
+
 int xfs_metadir_start_link(struct xfs_metadir_update *upd);
 int xfs_metadir_link(struct xfs_metadir_update *upd);
 
diff --git a/libxfs/xfs_metadir.c b/libxfs/xfs_metadir.c
index 74c4596ee4cf81..0d6a153bc9e995 100644
--- a/libxfs/xfs_metadir.c
+++ b/libxfs/xfs_metadir.c
@@ -438,6 +438,52 @@ xfs_metadir_cancel(
 	xfs_metadir_teardown(upd, error);
 }
 
+int
+xfs_metadir_create_file(
+	struct xfs_metadir_update	*upd,
+	umode_t				mode,
+	xfs_metadir_createfn		create,
+	void				*priv,
+	struct xfs_inode		**ipp)
+{
+	int				error;
+
+	if (xfs_is_shutdown(upd->dp->i_mount))
+		return -EIO;
+
+	error = xfs_metadir_start_create(upd);
+	if (error)
+		return error;
+
+	error = xfs_metadir_create(upd, mode);
+	if (error)
+		goto out_cancel;
+
+	if (create) {
+		error = create(upd, priv);
+		if (error)
+			goto out_cancel;
+	}
+
+	error = xfs_metadir_commit(upd);
+	if (error)
+		goto out_irele;
+
+	xfs_finish_inode_setup(upd->ip);
+	*ipp = upd->ip;
+	return 0;
+
+out_cancel:
+	xfs_metadir_cancel(upd, error);
+out_irele:
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (upd->ip) {
+		xfs_finish_inode_setup(upd->ip);
+		xfs_irele(upd->ip);
+	}
+	return error;
+}
+
 /* Create a metadata for the last component of the path. */
 int
 xfs_metadir_mkdir(
@@ -450,36 +496,6 @@ xfs_metadir_mkdir(
 		.path			= path,
 		.metafile_type		= XFS_METAFILE_DIR,
 	};
-	int				error;
 
-	if (xfs_is_shutdown(dp->i_mount))
-		return -EIO;
-
-	/* Allocate a transaction to create the last directory. */
-	error = xfs_metadir_start_create(&upd);
-	if (error)
-		return error;
-
-	/* Create the subdirectory and take our reference. */
-	error = xfs_metadir_create(&upd, S_IFDIR);
-	if (error)
-		goto out_cancel;
-
-	error = xfs_metadir_commit(&upd);
-	if (error)
-		goto out_irele;
-
-	xfs_finish_inode_setup(upd.ip);
-	*ipp = upd.ip;
-	return 0;
-
-out_cancel:
-	xfs_metadir_cancel(&upd, error);
-out_irele:
-	/* Have to finish setting up the inode to ensure it's deleted. */
-	if (upd.ip) {
-		xfs_finish_inode_setup(upd.ip);
-		xfs_irele(upd.ip);
-	}
-	return error;
+	return xfs_metadir_create_file(&upd, S_IFDIR, NULL, NULL, ipp);
 }

