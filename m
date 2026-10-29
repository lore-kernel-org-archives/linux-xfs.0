Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275768;
	b=qTNlkSYa9UMqq2gm3UuKVWEqPHkWQ99YmRsxhrL88jJ5Jlk+qkW4I1IJlMaDIya9a+L7
	 4j5dgou9UDWYxc+OapJVkYnT0IJsXAbLvPbYG2A0twpxtLZAhGCLuaXvrTbjmGJZJ01ca
	 UfJNMFWeyCSf/u6HXkyE5tO6MaPpArL/GeTsF+c7BVkIoYJPq0nK023/6jOqb+HYSYsEf
	 M8Q3ThuC/xt5KRAcVvLlEfFF00+ZcWaE9N/os2oZD1UqVhW4b8EE/muZi+1+BGs7nfIEW
	 rFJe1XA4lSNip+REzIGSLld7jgjTYk8wxvzElYpC1fsZTboQYiWU/JRj97yUctFP9ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=S6XUTIjx7wshxAwrL2FlCFBo1rfJ0NaqEILlLF5zOe8=;
	b=b/cqGeqPTzjJ5+ZCp+GGC/eJ7+70thRA524A+UmDvf+STS89GUbGff4OW+lHqGwARN3x
	 GVbZ19EF9X6+sELklwpv4vULnyMZ+UCCNlGhqbk/SbgQsCvUt2nxHE6wAdjDkJaxUA84h
	 A/UqX+LGglc/x7te+DcyQHkpX7m/tqdEVHW9gdRF9J2jjeMYoVbudbhdmluuaNajFb1g1
	 G1fm6Xnhm+OrUVuR9cnaI7X8l7eooAcS19QBs8lQBcnAVXh0HRIcwr70RrZ6x7LWFqoKQ
	 PUKy8HgyztnsXGLNC4jFogNIbLNhBudWROlc09eAY3wZEV1QfWOUXk3px00UaP6H8EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O5uwhWA2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5B0606A31C
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O5uwhWA2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A683C1F01828;
	Thu, 29 Oct 2026 12:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275767;
	bh=S6XUTIjx7wshxAwrL2FlCFBo1rfJ0NaqEILlLF5zOe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5uwhWA2suZWO7u4tkDFG1ZzNCdNfpYLty4yCslLudgXxnjNnb2iv7JgYXFqVz+3M
	 ANsdrIq4NwepcE8BWjJKJHOHABhXF/mxBXSSV1j59Q0P0d8tIiHAbgzHurH4VybRNu
	 CC/L6zL40rBl81LYNoXUtPMRBwoNnwkuGkB0XNeWfYOBR2hCUIijY3Kp3/nokKIRcw
	 h0bZMA8LSt/A2exMkUF3LrZGwMeHxz8YVm5n1v0p84KaoSwmGJqf7FeRb9BP0qfCDz
	 V79q04s/J4BkmQ7TJFHip2FrInXv2RCzzlikJZc62oFAatFFj5s8F/uVJqxhdyd9NG
	 Z9ioBGbAhquxw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: [PATCH 01/28] xfs: add xfs_metadir_create_file helper
Date: Thu, 29 Oct 2026 13:05:58 +0100
Message-ID: <20261029120631.803074-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 libxfs/xfs_metadir.c | 78 ++++++++++++++++++++++++++------------------
 libxfs/xfs_metadir.h |  6 ++++
 2 files changed, 53 insertions(+), 31 deletions(-)

diff --git a/libxfs/xfs_metadir.c b/libxfs/xfs_metadir.c
index 74c4596ee4cf..0d6a153bc9e9 100644
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
diff --git a/libxfs/xfs_metadir.h b/libxfs/xfs_metadir.h
index bfecac7d3d14..a795a2d0e3fe 100644
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
 
-- 
2.54.0

