Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793821608;
	b=g1geCcUG9UmSoCct7NZR64Q9ZO3vhq1TPaMqKiUtgphLHmnZDdI0BPb7gVFr8F6dfGUb
	 MuLs5PZYKmTzrs6rVBWlhaaMqfqHxBztX+RTFmSsH3Y5CYux4TeILcgg8CsBWUYkoYkKZ
	 VBoqMKF7WANdmBYO0MpfyUypoGPr/+N4AAQeJ2MG0p3U1uratSUz4Rz5pocs6vb/QM9sm
	 ZE4bfTYMnauLJ+WxStwq8q7LoOj2xGBigx/KwTLJMBvT3HtqZTsOtbCmT01zJ+pRyO9sw
	 +1pfflF1ZuXwjTLT/Q20JZFszd0wVwKinpt059SBci7HgzH5wVqTAJU3vvxIvep4ZEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793821608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=BimR1D9/wvZGY0reDOYel4C+9wjSglW0Ag8MNWquP3M=;
	b=kEBrpXpv7IuPkrT4ACnN4DYS48EKijZt9qTOSq5A3rrFCIXy6DSga/QNSeO/uDP3+I90
	 dLLSa7+DmyaV6UqKd1n1LhXtZF6W1k7gXnPm1Ga8FcZJz9yWHCifehA+Q9JR0YyBkxFve
	 jyeoc+kC0OEX8HOuF8GnxwoZZHFvWlnkPxVN8GdngurVG+IFrL2yK73qdUbgXEwGjIkNC
	 g9yuejNSwVYxPB0hbiEw/w1YwudR5kIiGC54Qr/AInnZ0st9urikLvc1F/DCWuCwIyler
	 WGyoTy97rB2XjyObdaktDN48lLGSzNQ7tO1njNiBegIxT9XUOwoItgh/sgGjlXHW37g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYMjwR9C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB35E608C9A1;
	Wed,  4 Nov 2026 19:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYMjwR9C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C321F00A1C;
	Wed,  4 Nov 2026 19:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821607;
	bh=BimR1D9/wvZGY0reDOYel4C+9wjSglW0Ag8MNWquP3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SYMjwR9CisNRR4trA29J7KYyt9QQltUoV6GaOZQupCdWwqP7nEenQBuyfJvbd/Y6G
	 c+d8wNrGK/ym2gUcRUDIR39Q7A+spBR7QqRMpG1m5xpI7GS4v5txkTX1Y7D88y5HuI
	 ImYXCqFJosDpkrORlHNlK3Vxl/xkCOHMjSg65oGEfSFzOwzh6fWQYonctIPAbQKmDl
	 lz1o0JzenKjtMcZLg4GGdUEa6Bww5ILNLq3OPjsRnSTiz30hEJQknKv065WnqaGmx0
	 Ks7S3MzxpObGiRSZDhv+2WnBKRf2AEuIAKyzXOfzT7JldhUl0nPlkfmO7w6syp2tgi
	 qgbNGRI7x/qng==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	fsverity@lists.linux.dev
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org
Subject: [PATCH 5/5] f2fs: use I_VERITY_BUILDING instead of private flags
Date: Wed,  4 Nov 2026 20:46:14 +0100
Message-ID: <20261104194618.103332-6-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104194618.103332-1-aalbersh@kernel.org>
References: <20261104194618.103332-1-aalbersh@kernel.org>
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

Now that the VFS tracks an inode whose Merkle tree is under construction
via I_VERITY_BUILDING and handles the concurrent-enable guard in the
generic fs-verity enable path, drop the inode runtime flags that
duplicated this state.

Replace f2fs own helper f2fs_verity_in_progress() with
fsverity_is_building(), and remove the and FI_VERITY_IN_PROGRESS flags.
It's fine to remove IS_ENABLED() guard as fsverity_is_building() has
stub.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/f2fs/data.c   | 10 +++++-----
 fs/f2fs/f2fs.h   |  7 -------
 fs/f2fs/verity.c | 15 ++++-----------
 3 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 28fd8afff5d4..ab6f6f182f97 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3356,7 +3356,7 @@ int f2fs_write_single_data_page(struct folio *folio, int *submitted,
 		goto redirty_out;
 
 	if (folio->index < end_index ||
-			f2fs_verity_in_progress(inode) ||
+			fsverity_is_building(inode) ||
 			compr_blocks)
 		goto write;
 
@@ -3889,7 +3889,7 @@ void f2fs_write_failed(struct inode *inode, loff_t to)
 		return;
 
 	/* In the fs-verity case, f2fs_end_enable_verity() does the truncate */
-	if (to > i_size && !f2fs_verity_in_progress(inode)) {
+	if (to > i_size && !fsverity_is_building(inode)) {
 		f2fs_down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 		filemap_invalidate_lock(inode->i_mapping);
 
@@ -4205,7 +4205,7 @@ static int f2fs_write_begin(const struct kiocb *iocb,
 		return 0;
 
 	if (!(pos & (PAGE_SIZE - 1)) && (pos + len) >= i_size_read(inode) &&
-	    !f2fs_verity_in_progress(inode)) {
+	    !fsverity_is_building(inode)) {
 		folio_zero_segment(folio, len, folio_size(folio));
 		return 0;
 	}
@@ -4279,7 +4279,7 @@ static int f2fs_write_end(const struct kiocb *iocb,
 		f2fs_update_time(F2FS_I_SB(inode), REQ_TIME);
 
 		if (pos + copied > i_size_read(inode) &&
-				!f2fs_verity_in_progress(inode))
+				!fsverity_is_building(inode))
 			f2fs_i_size_write(inode, pos + copied);
 		return copied;
 	}
@@ -4294,7 +4294,7 @@ static int f2fs_write_end(const struct kiocb *iocb,
 		folio_set_f2fs_atomic(folio);
 
 	if (pos + copied > i_size_read(inode) &&
-	    !f2fs_verity_in_progress(inode)) {
+	    !fsverity_is_building(inode)) {
 		f2fs_i_size_write(inode, pos + copied);
 		if (f2fs_is_atomic_file(inode))
 			f2fs_i_size_write(F2FS_I(inode)->cow_inode,
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f7423b3f6e4a..374c861f13b9 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -925,7 +925,6 @@ enum {
 	FI_EXTRA_ATTR,		/* indicate file has extra attribute */
 	FI_PROJ_INHERIT,	/* indicate file inherits projectid */
 	FI_PIN_FILE,		/* indicate file should not be gced */
-	FI_VERITY_IN_PROGRESS,	/* building fs-verity Merkle tree */
 	FI_COMPRESSED_FILE,	/* indicate file's data can be compressed */
 	FI_COMPRESS_CORRUPT,	/* indicate compressed cluster is corrupted */
 	FI_MMAP_FILE,		/* indicate file was mmapped */
@@ -3535,12 +3534,6 @@ static inline void clear_inode_flag(struct inode *inode, int flag)
 	__mark_inode_dirty_flag(inode, flag, false);
 }
 
-static inline bool f2fs_verity_in_progress(struct inode *inode)
-{
-	return IS_ENABLED(CONFIG_FS_VERITY) &&
-	       is_inode_flag_set(inode, FI_VERITY_IN_PROGRESS);
-}
-
 static inline void set_acl_inode(struct inode *inode, umode_t mode)
 {
 	F2FS_I(inode)->i_acl_mode = mode;
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 4a2cea4288f9..af3d33c6f26d 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -94,9 +94,6 @@ static int f2fs_begin_enable_verity(struct file *filp)
 	struct inode *inode = file_inode(filp);
 	int err;
 
-	if (f2fs_verity_in_progress(inode))
-		return -EBUSY;
-
 	if (f2fs_is_atomic_file(inode))
 		return -EOPNOTSUPP;
 
@@ -113,7 +110,6 @@ static int f2fs_begin_enable_verity(struct file *filp)
 	if (err)
 		return err;
 
-	set_inode_flag(inode, FI_VERITY_IN_PROGRESS);
 	return 0;
 }
 
@@ -143,10 +139,9 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
 		goto cleanup;
 
 	/*
-	 * Write all pages (both data and verity metadata).  Note that this must
-	 * happen before clearing FI_VERITY_IN_PROGRESS; otherwise pages beyond
-	 * i_size won't be written properly.  For crash consistency, this also
-	 * must happen before the verity inode flag gets persisted.
+	 * Write all pages (both data and verity metadata). For crash
+	 * consistency, this also must happen before the verity inode flag gets
+	 * persisted.
 	 */
 	err = filemap_write_and_wait(inode->i_mapping);
 	if (err)
@@ -164,14 +159,13 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
 	f2fs_set_inode_flags(inode);
 	f2fs_mark_inode_dirty_sync(inode, true);
 
-	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
 	return 0;
 
 cleanup:
 	/*
 	 * Verity failed to be enabled, so clean up by truncating any verity
 	 * metadata that was written beyond i_size (both from cache and from
-	 * disk) and clearing FI_VERITY_IN_PROGRESS.
+	 * disk).
 	 *
 	 * Taking i_gc_rwsem[WRITE] is needed to stop f2fs garbage collection
 	 * from re-instantiating cached pages we are truncating (since unlike
@@ -186,7 +180,6 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 	}
 	f2fs_up_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
-	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
 	return err ?: err2;
 }
 
-- 
2.54.0

