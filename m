Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190056;
	b=NUqRA905qjSfZ30DMnz4KxYM9/xXHxQqI34j+j6RgESLTi54Fov7qfab6+liAbEELsVC
	 bRy5DOx2uPnJpZoXuYIbGEQ2An/+1eH++JLrTB0fHwUxCBHTFHxjM7nRBixpXF3yzSKwK
	 K1wydKN5jZK/OjkT0/Q1lp6Uc56zAKrMfd5gmf/NR4h2W9n87y1P7inuiv+D/psKkyqZa
	 d56dFCkygk4E28PrzG6E1O6NLTrnVsbJSOWn1msqjN/mryo7oPTmKLwIR7Gk9gALp/LvX
	 HpjGjdTcUEyN8akCCtELuCuVN8ccmoNEm9PlLoq7uIRzybc6v1f9oKXNcaF2k7Sjh7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+8w5qlf8jD//ZtOO2vLYEXLr+YWwj7aWgsYMhZaXWmY=;
	b=pzmys4u2MbOi+N8mV5FRozbBGwGo0Mg3yBKT/fYK5F1V+WDOZ6ZexoKcpTD0Cb5rTE1G
	 rQISCi22p2oNWV1IoroJV6pELzMnvw6ebZjDrADNS46EVUS9urPc3/CO9gitHlS0Z4MKT
	 FmRvwJzFp3XTjmZIPdq0U9BJs6ASGULUNtnTqYyNG1q66cO7M3rxl0PLM5xAY/U6fDc4L
	 yq2s2xmLjiYqAkaCAqEfZSUl2cw4UrYbgmxRZ23r+fQa0rTFFkT3nsQrigkgt7lTWTvkd
	 3bTodhSvFwVRaJ7vVb7c59wC99qN0ztZB/tRf/zCsn7N2aKrJDwAri+X9jbcfoqeDzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oquvyCd6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8101B60A2606;
	Fri, 20 Nov 2026 15:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oquvyCd6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C1C1F000D3;
	Fri, 20 Nov 2026 15:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190056;
	bh=+8w5qlf8jD//ZtOO2vLYEXLr+YWwj7aWgsYMhZaXWmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oquvyCd61j8lJzeU+qPQzLF+Y1v9DmtHSx0UbdnlXhxFBeK+CiXqs15r70oeh7AKu
	 WwlMLu7LwkliqzBEe9WSkFEj2iCchRi758Maf9tAPtgCylwkH4SpTVxhoPEjGwNd6y
	 OW2PkP/Sw7PSXoSsSIWKN0PH5QW0tgPoGhxTIlLizVV/gaBzekAZEH94RBQ/R8HRqd
	 lONgehHB76cq+8DsTh0F9hdzlxN7IU+cMXDCSAzbBhFHc1g6XhEQJYW8pd296q6mcu
	 LRMzIZ8sDI71eKKCCAJ7m/Z0l/XnjTXQ6DBbkCgOW9/JlctE2h3Mas/yzPhh8hQNcc
	 lvyOYf9BWyCGA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "fsdevel" <linux-fsdevel@vger.kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-f2fs" <linux-f2fs-devel@lists.sourceforge.net>,
	"linux-xfs" <linux-xfs@vger.kernel.org>,
	dsterba@suse.com,
	"Eric Biggers" <ebiggers@kernel.org>,
	"Christian Brauner" <brauner@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	tytso@mit.edu,
	chao@kernel.org,
	jaegeuk@kernel.org,
	viro@zeniv.linux.org.uk
Subject: [PATCH v3 7/7] f2fs: use I_VERITY_BUILDING instead of private flags
Date: Fri, 20 Nov 2026 16:50:29 +0100
Message-ID: <20261120155032.187246-8-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155032.187246-1-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
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
 fs/f2fs/verity.c | 12 +++---------
 3 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7c5aa95b7da8..c75e61af21f7 100644
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
index 6941891d7cae..c0fca6229170 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -926,7 +926,6 @@ enum {
 	FI_EXTRA_ATTR,		/* indicate file has extra attribute */
 	FI_PROJ_INHERIT,	/* indicate file inherits projectid */
 	FI_PIN_FILE,		/* indicate file should not be gced */
-	FI_VERITY_IN_PROGRESS,	/* building fs-verity Merkle tree */
 	FI_COMPRESSED_FILE,	/* indicate file's data can be compressed */
 	FI_COMPRESS_CORRUPT,	/* indicate compressed cluster is corrupted */
 	FI_MMAP_FILE,		/* indicate file was mmapped */
@@ -3536,12 +3535,6 @@ static inline void clear_inode_flag(struct inode *inode, int flag)
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
index 4a2cea4288f9..f31a71295e47 100644
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
 
@@ -143,8 +139,8 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
 		goto cleanup;
 
 	/*
-	 * Write all pages (both data and verity metadata).  Note that this must
-	 * happen before clearing FI_VERITY_IN_PROGRESS; otherwise pages beyond
+	 * Write all pages (both data and verity metadata). Note that this must
+	 * happen before I_VERITY_BUILDING is cleared; otherwise pages beyond
 	 * i_size won't be written properly.  For crash consistency, this also
 	 * must happen before the verity inode flag gets persisted.
 	 */
@@ -164,14 +160,13 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
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
@@ -186,7 +181,6 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 	}
 	f2fs_up_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
-	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
 	return err ?: err2;
 }
 
-- 
2.54.0

