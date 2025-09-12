Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B875222597
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 15:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757690882; cv=none; b=oQtyjLKiU/kKSYAHvZLVy+jd9TejlUpLfKQQXgIlU5bseeLaB1SFdvVYNIWtCCCrBOU/qsy4QZ2e95Qu72nF9YWae6CnmDzTIdA9DiPTWsmHDX6zhAK3XrfpgHY7sXsLH2MpwWlWjFlsvStjNtSUM7Huy550nG3ff586hC8xXWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757690882; c=relaxed/simple;
	bh=o0kkG3gbsibzPiYytCDeVsUKeybnHwvskBHSa2z0UkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E62PgBZsJ3dZ+d+lWAVlBjCxRgVCosinVjNdqUfeQwD+1HNpAiZdGGyh5WEEHUD1I/ZWcbmQP2q8rRpXP72ubMfQpV1T3VLwBFcuONXzFO8FDwnnLfpo6wRThpqoPUz0TMP0LBmmrv/9Ev6KP7cvpjmY0adeZj/cxvETaDgn1fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A+1XLQwF; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A+1XLQwF"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-772627dd50aso3687183b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 08:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757690879; x=1758295679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tp5k30KObX2DHbYjNETNA0vsxWRW2WFebT5yQL1efcA=;
        b=A+1XLQwFscCw6MNFlM4Sw62ktqkXpIgfecNzQPJFiKzKufX4Waok8gksjCwvYo9Wn4
         J5gihhfAaH3VcP526h/p+981g31C7J/mYRC1WziqcNsPRowzs3yyxqR4F1npCGlC/YGQ
         k4uBEL+rsn+KZ94reGO/0owODjg28HATU/7f9FvMtMsP3wdhCkNVJSpxWew5yoQl3btw
         Pnxz6pfr06NQTjV26K86aF5tJ5yBwTIT2T1fuVTlVuJKtLy3dOb38qea9az3nlagOtQN
         KF2r4DWbCf8+gXfpdmO9jdgjAi9FIL+rwAwTNFSSPpCg25debTrH/VeYlkdBaMsaBzic
         qlcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757690879; x=1758295679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tp5k30KObX2DHbYjNETNA0vsxWRW2WFebT5yQL1efcA=;
        b=eDeXAcGHUr9eGb4XgOFsBIyQdGBPY5YsP7vhW69zaLpUzc9Av7VpnJk3mxmPjYvesw
         2XqWwYERzCCstE4Mhvd/+56h6u2vFbl/rClTGC1h5IF0LMpMEGIOo/xBrzSRbD9j9RpU
         S4UhipWZ9iCHneBf4uuy4sl9IG9kjEjFqx0zhm+/J6VDmhhrWqk7PcASsF48lTMOkXBq
         97v7pcNuAm0aIt7VGXI3WU5dPP65gyseVtMpNZO2rStuczCl/zS8+FJ0v/UiVJYeUTVz
         ZjLoBgcv4BsV7ZMAOu8B/JctCofCb6BrzKFOgXp9/AgRlmlBCqY7qFub1ReYj9lILnZW
         I9IQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcBbcLDj9evKV9Ws3eEIPqwQ7Mq9BM/rNcvsqQ4WcQ8JAb0tPXlSIzclTqCGW8snXGgGQ+j5dvJ+A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcoC/+I/wcs3cJPmyJdvh85q7WhmVzwxK1a9UcX4rkgZS610C0
	t4jeKJFzcX9p1nsefCXk+Ca56dMK/wOJhcYZAF1b8xDfiVtzLcffVzK7
X-Gm-Gg: ASbGncts+FuKh8odb4gEg8vxraDTzsHIRPJW2LfkwDUkoWflik8KPm49Gil3K9WPqJT
	E4Y2OZGwJPHkmLE2O1h9H0n6mpMRYmbTG0r+P1OU1jYbcW2Caarrn6BDHtinV/6hQL+qIK2RNoO
	KhoNSoDTJSVKzxfuWaStUz7Gj2vb8QfAp1xJFYnHFvB0UIZ7Uk1bAlXQy9/VkZ1wwl7GuM5XH3A
	62e4G5pxQHFIDfoQTLbCiodNWlNyaF0fIgYDN1hvnJAEaXCpEGtlRpdX8WRMnzUZhEMNGZNJNcd
	3OsCrbdMrMOOkSKIuThlMmWo8TgblGDEW+Fle4XPyhsMK7inGT7QW/CdGL4bSFlGmF1Ds287eXw
	ujEf6Ex0kFljTeRy0s8VE0UdzUg==
X-Google-Smtp-Source: AGHT+IEHoyPuPNjRXMF6D9AbSE9Owm5HszgJnuRdDm6U9PHJUuzC7ORv4NWPgIIfR+wfu5arnCEw/w==
X-Received: by 2002:a05:6a21:6d9c:b0:243:c5a9:4309 with SMTP id adf61e73a8af0-2602a09ffa6mr3679449637.20.1757690879236;
        Fri, 12 Sep 2025 08:27:59 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7760944a9a9sm5436846b3a.78.2025.09.12.08.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:27:58 -0700 (PDT)
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
Subject: [PATCH v3 07/10] exportfs: new FILEID_CACHED flag for non-blocking fh lookup
Date: Fri, 12 Sep 2025 09:28:52 -0600
Message-ID: <20250912152855.689917-8-tahbertschinger@gmail.com>
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

This defines a new flag FILEID_CACHED that the VFS can set in the
handle_type field of struct file_handle to request that the FS
implementations of fh_to_{dentry,parent}() only complete if they can
satisfy the request with cached data.

Because not every FS implementation will recognize this new flag, those
that do recognize the flag can indicate their support using a new
export flag, EXPORT_OP_NONBLOCK.

If FILEID_CACHED is set in a file handle, but the filesystem does not
set EXPORT_OP_NONBLOCK, then the VFS will return -EAGAIN without
attempting to call into the filesystem code.

exportfs_decode_fh_raw() is updated to respect the new flag by returning
-EAGAIN when it would need to do an operation that may not be possible
with only cached data.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
I didn't apply Amir's Reviewed-by for this patch because I added the
Documenation section, which was not reviewed in v2.

 Documentation/filesystems/nfs/exporting.rst |  6 ++++++
 fs/exportfs/expfs.c                         | 12 ++++++++++++
 fs/fhandle.c                                |  2 ++
 include/linux/exportfs.h                    |  5 +++++
 4 files changed, 25 insertions(+)

diff --git a/Documentation/filesystems/nfs/exporting.rst b/Documentation/filesystems/nfs/exporting.rst
index de64d2d002a2..70f46eaeb0d4 100644
--- a/Documentation/filesystems/nfs/exporting.rst
+++ b/Documentation/filesystems/nfs/exporting.rst
@@ -238,3 +238,9 @@ following flags are defined:
     all of an inode's dirty data on last close. Exports that behave this
     way should set EXPORT_OP_FLUSH_ON_CLOSE so that NFSD knows to skip
     waiting for writeback when closing such files.
+
+  EXPORT_OP_NONBLOCK - FS supports fh_to_{dentry,parent}() using cached data
+    When performing open_by_handle_at(2) using io_uring, it is useful to
+    complete the file open using only cached data when possible, otherwise
+    failing with -EAGAIN.  This flag indicates that the filesystem supports this
+    mode of operation.
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 949ce6ef6c4e..e2cfdd9d6392 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -441,6 +441,7 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct fid *fid, int fh_len,
 		       void *context)
 {
 	const struct export_operations *nop = mnt->mnt_sb->s_export_op;
+	bool decode_cached = fileid_type & FILEID_CACHED;
 	struct dentry *result, *alias;
 	char nbuf[NAME_MAX+1];
 	int err;
@@ -453,6 +454,10 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct fid *fid, int fh_len,
 	 */
 	if (!exportfs_can_decode_fh(nop))
 		return ERR_PTR(-ESTALE);
+
+	if (decode_cached && !(nop->flags & EXPORT_OP_NONBLOCK))
+		return ERR_PTR(-EAGAIN);
+
 	result = nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_type);
 	if (IS_ERR_OR_NULL(result))
 		return result;
@@ -481,6 +486,10 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct fid *fid, int fh_len,
 		 * filesystem root.
 		 */
 		if (result->d_flags & DCACHE_DISCONNECTED) {
+			err = -EAGAIN;
+			if (decode_cached)
+				goto err_result;
+
 			err = reconnect_path(mnt, result, nbuf);
 			if (err)
 				goto err_result;
@@ -526,6 +535,9 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct fid *fid, int fh_len,
 		err = PTR_ERR(target_dir);
 		if (IS_ERR(target_dir))
 			goto err_result;
+		err = -EAGAIN;
+		if (decode_cached && (target_dir->d_flags & DCACHE_DISCONNECTED))
+			goto err_result;
 
 		/*
 		 * And as usual we need to make sure the parent directory is
diff --git a/fs/fhandle.c b/fs/fhandle.c
index 2dc669aeb520..509ff8983f94 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -273,6 +273,8 @@ static int do_handle_to_path(struct file_handle *handle, struct path *path,
 	if (IS_ERR_OR_NULL(dentry)) {
 		if (dentry == ERR_PTR(-ENOMEM))
 			return -ENOMEM;
+		if (dentry == ERR_PTR(-EAGAIN))
+			return -EAGAIN;
 		return -ESTALE;
 	}
 	path->dentry = dentry;
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 30a9791d88e0..8238b6f67956 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -199,6 +199,8 @@ struct handle_to_path_ctx {
 #define FILEID_FS_FLAGS_MASK	0xff00
 #define FILEID_FS_FLAGS(flags)	((flags) & FILEID_FS_FLAGS_MASK)
 
+#define FILEID_CACHED		0x100 /* Use only cached data when decoding handle */
+
 /* User flags: */
 #define FILEID_USER_FLAGS_MASK	0xffff0000
 #define FILEID_USER_FLAGS(type) ((type) & FILEID_USER_FLAGS_MASK)
@@ -303,6 +305,9 @@ struct export_operations {
 						*/
 #define EXPORT_OP_FLUSH_ON_CLOSE	(0x20) /* fs flushes file data on close */
 #define EXPORT_OP_NOLOCKS		(0x40) /* no file locking support */
+#define EXPORT_OP_NONBLOCK		(0x80) /* Filesystem supports non-
+						  blocking fh_to_dentry()
+						*/
 	unsigned long	flags;
 };
 
-- 
2.51.0

