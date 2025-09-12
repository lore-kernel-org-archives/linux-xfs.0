Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A4D306489
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 15:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757690896; cv=none; b=IQkPQghNfV6W4mwrT3KjZ1tBVa65ZaebN5Xhlbg2mb06ayZogR35n+uutVGzE1d/gAZY0w5c2z86Ygtp9dc3cG+y/N3ZXjKuVZi/Xg9WbbxbVirisDChi3loIwOWUfeu+z77IoWup8mMVw/oX0F80tBT7g8lhc8B+dQB7LUGi0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757690896; c=relaxed/simple;
	bh=CgyNEahm5gOOpEEykICG0JY6xqFEbeq32tKyTBTcXas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCb/4UKt2n7gwM63CUT23p1kknoF8vv8xhHronwlIoiRMnq4O/WqP1o1Q+R+UenqyNrBWs+a8AYxPJzGmb3UbCGxFHZl95X90bu9+qjYAU4W7VRhADiLukOaAmLFPFYCmawqdPm1JWpP32RdYBSJ7B4Ve1rwO5bztQEsqeNmpZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Irljk7+v; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Irljk7+v"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-77616dce48cso543912b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 08:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757690894; x=1758295694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qddzG88P0MDINuI3ttRfHIuZNQHYMA6MDyCfUKvDRo8=;
        b=Irljk7+vDXy/JeNOFoyMtzEjf1+GXyhS/GhnvZCuT5RQkU0ZPM9f05VzEknXVh8DqL
         Xp72IENBjSht0uXzdssiS6yXGy3wsQf6i0ygA5J5yp+5A3fByuP3pVpN4VTpAK8SplV3
         47I5Q2WVZXwLqCu3Svc8zzlrMRHsdjJiaFRz8z88QFCayW1+b2Z9YKremvvnTda3BB/b
         Nq3xuBaKwofmLvounCEzFFYS+frnVVe1uCbIFoIdTw+Y0amBqReYmNoqgYrRnJhZ2fsS
         h3X9L2C7PEVGOaZeP8X71y4/KCZCpcm6XRoWafb8onZW0F8lXZSu7F3WkfZsM+hFAup3
         PtSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757690894; x=1758295694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qddzG88P0MDINuI3ttRfHIuZNQHYMA6MDyCfUKvDRo8=;
        b=qVyGV9QyExbki5oMYTNraqUMvL8LI8RJp7dmzgmINJppeyzBXgYdf/T9vdacwY7BBU
         V/V9X6HzB3YKGFG24WDtlii4nD+J/vpRHN98yGq7YthJ3t8UQXFWA1DRfJIcfb2TjJjn
         5Sa6uS3esDTXIsHJec9dDh8jRBavvyVmpfEzIwxd0qma0M10OpCE0qd3x4pVwY9SMNDx
         b8ZXL1L68AQqvSIV3AiomQ2aS0CmWHwwQ2aAUg+7r5ZBza/Xt856A+pCEVq2xPw2e54r
         q/qndinkR1j/z7mj5NqSg+8DRXDLmgV+f8P+BKG4959BQ4hVTHVBVReyd7LBSRS21nGb
         77Lg==
X-Forwarded-Encrypted: i=1; AJvYcCWnBQZVLC6u65Sd7Yu7OoM405hMHronPoIzhQohIIKJ49KnD81PFmgcEvNaDoyKK1L/rnTYQyLGs/k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww+vuL7R4+ETWjWOQHtpCI4dTQKhQUa/GqCcAXN+oULNe9etjr
	yILVtXRA2VAj9hu49gEo1VlD+OdkEcQQIPJcK08qLOMnxdSzbaRVpbeu
X-Gm-Gg: ASbGnct+d/rhINNrY43Zp7RB9yK1MrZYgtkcLzCAic7ABv1l1spDMVHdz+2DXwZRQLM
	ec2wp/y8UrPuAf8D/BGa7U9NyKHw2o6IBMYRkZyH+TBen90aCK1SV/En18YUxueVTLXUsfT1MLM
	6KrNOX8d2ARwEi3mbiR6OgBvkyCJ2xTlNxSz+R/ni13NFK2QSqMtI5l6chS/bXOAlc+AtnQDs6V
	dz1+uDoqqmOu1Y2ViT0pXYfdkkYzTEppMDDZFZ4pRA3AJo2diqAVrOK4cEUg7qwJl6blUDDv/ys
	YBwLTtY9umoCrr7p57A73Gflh/PaB5q4j1lBSs1gGGXIxqPTbU57A6KoeRnD4VGqCPPeTo9LK/z
	T9aaJteApShcG9bTnTYoPRT1+uQ==
X-Google-Smtp-Source: AGHT+IHSzv32UvYk1/EENIG2Gkyl/RiUekw8QXYbvFQu5Nyt93BDAZEn7q5Lm/tAAdYqDnZf6JgTdA==
X-Received: by 2002:a05:6a20:3c8e:b0:24c:2fa1:fddb with SMTP id adf61e73a8af0-2602cd2779cmr4539525637.53.1757690893744;
        Fri, 12 Sep 2025 08:28:13 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7760944a9a9sm5436846b3a.78.2025.09.12.08.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:28:13 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	jlayton@kernel.org,
	amir73il@gmail.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH v3 10/10] xfs: add support for non-blocking fh_to_dentry()
Date: Fri, 12 Sep 2025 09:28:55 -0600
Message-ID: <20250912152855.689917-11-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912152855.689917-1-tahbertschinger@gmail.com>
References: <20250912152855.689917-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is to support using open_by_handle_at(2) via io_uring. It is useful
for io_uring to request that opening a file via handle be completed
using only cached data, or fail with -EAGAIN if that is not possible.

The signature of xfs_nfs_get_inode() is extended with a new flags
argument that allows callers to specify XFS_IGET_INCORE.

That flag is set when the VFS passes the FILEID_CACHED flag via the
fileid_type argument.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
Acked-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_export.c | 34 ++++++++++++++++++++++++++--------
 fs/xfs/xfs_export.h |  3 ++-
 fs/xfs/xfs_handle.c |  2 +-
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 201489d3de08..6a57ed8fd9b7 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -106,7 +106,8 @@ struct inode *
 xfs_nfs_get_inode(
 	struct super_block	*sb,
 	u64			ino,
-	u32			generation)
+	u32			generation,
+	uint			flags)
 {
  	xfs_mount_t		*mp = XFS_M(sb);
 	xfs_inode_t		*ip;
@@ -123,7 +124,9 @@ xfs_nfs_get_inode(
 	 * fine and not an indication of a corrupted filesystem as clients can
 	 * send invalid file handles and we have to handle it gracefully..
 	 */
-	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED, 0, &ip);
+	flags |= XFS_IGET_UNTRUSTED;
+
+	error = xfs_iget(mp, NULL, ino, flags, 0, &ip);
 	if (error) {
 
 		/*
@@ -140,6 +143,10 @@ xfs_nfs_get_inode(
 		case -EFSCORRUPTED:
 			error = -ESTALE;
 			break;
+		case -ENODATA:
+			if (flags & XFS_IGET_INCORE)
+				error = -EAGAIN;
+			break;
 		default:
 			break;
 		}
@@ -170,10 +177,15 @@ xfs_nfs_get_inode(
 
 STATIC struct dentry *
 xfs_fs_fh_to_dentry(struct super_block *sb, struct fid *fid,
-		 int fh_len, int fileid_type)
+		 int fh_len, int fileid_type_flags)
 {
+	int			fileid_type = FILEID_TYPE(fileid_type_flags);
 	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fid;
 	struct inode		*inode = NULL;
+	uint			flags = 0;
+
+	if (fileid_type_flags & FILEID_CACHED)
+		flags = XFS_IGET_INCORE;
 
 	if (fh_len < xfs_fileid_length(fileid_type))
 		return NULL;
@@ -181,11 +193,11 @@ xfs_fs_fh_to_dentry(struct super_block *sb, struct fid *fid,
 	switch (fileid_type) {
 	case FILEID_INO32_GEN_PARENT:
 	case FILEID_INO32_GEN:
-		inode = xfs_nfs_get_inode(sb, fid->i32.ino, fid->i32.gen);
+		inode = xfs_nfs_get_inode(sb, fid->i32.ino, fid->i32.gen, flags);
 		break;
 	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
 	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
-		inode = xfs_nfs_get_inode(sb, fid64->ino, fid64->gen);
+		inode = xfs_nfs_get_inode(sb, fid64->ino, fid64->gen, flags);
 		break;
 	}
 
@@ -194,10 +206,15 @@ xfs_fs_fh_to_dentry(struct super_block *sb, struct fid *fid,
 
 STATIC struct dentry *
 xfs_fs_fh_to_parent(struct super_block *sb, struct fid *fid,
-		 int fh_len, int fileid_type)
+		 int fh_len, int fileid_type_flags)
 {
+	int			fileid_type = FILEID_TYPE(fileid_type_flags);
 	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fid;
 	struct inode		*inode = NULL;
+	uint			flags = 0;
+
+	if (fileid_type_flags & FILEID_CACHED)
+		flags = XFS_IGET_INCORE;
 
 	if (fh_len < xfs_fileid_length(fileid_type))
 		return NULL;
@@ -205,11 +222,11 @@ xfs_fs_fh_to_parent(struct super_block *sb, struct fid *fid,
 	switch (fileid_type) {
 	case FILEID_INO32_GEN_PARENT:
 		inode = xfs_nfs_get_inode(sb, fid->i32.parent_ino,
-					      fid->i32.parent_gen);
+					      fid->i32.parent_gen, flags);
 		break;
 	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
 		inode = xfs_nfs_get_inode(sb, fid64->parent_ino,
-					      fid64->parent_gen);
+					      fid64->parent_gen, flags);
 		break;
 	}
 
@@ -248,4 +265,5 @@ const struct export_operations xfs_export_operations = {
 	.map_blocks		= xfs_fs_map_blocks,
 	.commit_blocks		= xfs_fs_commit_blocks,
 #endif
+	.flags			= EXPORT_OP_NONBLOCK,
 };
diff --git a/fs/xfs/xfs_export.h b/fs/xfs/xfs_export.h
index 3cd85e8901a5..9addfcd5b1e1 100644
--- a/fs/xfs/xfs_export.h
+++ b/fs/xfs/xfs_export.h
@@ -57,6 +57,7 @@ struct xfs_fid64 {
 /* This flag goes on the wire.  Don't play with it. */
 #define XFS_FILEID_TYPE_64FLAG	0x80	/* NFS fileid has 64bit inodes */
 
-struct inode *xfs_nfs_get_inode(struct super_block *sb, u64 ino, u32 gen);
+struct inode *xfs_nfs_get_inode(struct super_block *sb, u64 ino, u32 gen,
+				uint flags);
 
 #endif	/* __XFS_EXPORT_H__ */
diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index f19fce557354..7d877ff504d6 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -193,7 +193,7 @@ xfs_khandle_to_inode(
 		return ERR_PTR(-EINVAL);
 
 	inode = xfs_nfs_get_inode(mp->m_super, handle->ha_fid.fid_ino,
-			handle->ha_fid.fid_gen);
+			handle->ha_fid.fid_gen, 0);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
-- 
2.51.0

