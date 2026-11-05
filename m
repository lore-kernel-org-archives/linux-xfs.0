Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793879817;
	b=hN6tMeaC88e6fYx0KWfunHC5vZhbNQQQM8Bxso8dAdQgPorMunAa4+ilFtdrRRegpTzA
	 hg3ko37+v3fhBJtLCXCLuQNHPknAfQe25cw6zbBCzDxjqBoaCoDBmopsGXfx/9JoR9oVi
	 lHPUQogEnLmphCqJ75GdvGxTDl6A7wxkBrMyGepwYK/4M6BHRTuUFe3NVJz4Nmv7TxR/a
	 k/2CtIpnEsF0vDsD+dgHTF6vj6ca4RXDZiH0TZGQjNtWxQ9MURY7eU22gwWmfVUYvTSq2
	 iL8JRuPnctr1rUrxMtpn07A/WNsvSVSlT9MPtezfCtJiEvoWJtZo4ktlcIuAwVpiHjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793879817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+IrPC0FHgxyuSqXIoEfYMR7j75cyEud/FZQj+mfi+S8=;
	b=H3gt2FWtAvafSzEBzCAX0nE0PwoFZWiZE0CnpiEtoP7Kt4MSJhEe2sUS9KmexD2pXqJv
	 yElhLim8EDX8T6/4gXvgw/FqziuBxV4HzJy3BUs5oEUd7XzHy/v1jwZjn8sr6114bESm3
	 I4hib8ZS85Mrr4Fh+wf6KdPMi2bw+eOe8igsu2089AuyajAjjXa9Wx2NKk4dueUlFx0yb
	 RnStBwyRxzgAiXwA++cApkrs8jtPmdwb4NvdbFKCAde5BDgSZ5tRK9USEYz3Zn5vLSvWP
	 50EQcqksbhMdrqe6CU5pN/8KAXxdf+qBsz7pRqedzhGjzNATok3sWIwlIb7PoYdYAag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fumQCCvo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E23606A31B;
	Thu,  5 Nov 2026 11:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fumQCCvo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFB21F0093A;
	Thu,  5 Nov 2026 11:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793879816;
	bh=+IrPC0FHgxyuSqXIoEfYMR7j75cyEud/FZQj+mfi+S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fumQCCvouI1SvEB8bhxwQ9qqO+ILxo1Okiu1ebut8FhArs5p9WuAnSjyHf4MGM4Rt
	 WKZ3GMr0neoGVqmt98VByDBZi1Xa0XSfUVbeMozKaU8tMXKWef+wwlqOFPHSzsZEz6
	 K2vL512BS3/Cg3YUmLFO/j8MDPguoqMb1vIte7MPUI2fXt7kl/Mc6QnKhU9aCU81rY
	 Rfl8c2pKcXtqSQn+KZGIWnwAtnrYyK66/h4JsP2ZPgFdkojHRaFg8cmZgbvCVuNZgS
	 cShSEEkyHWiK92kgmg6EbdfeiKzGVo1q80vRCNPve43L/w9CRut9pzDZ9hMpZFqftz
	 7O1JzNo95Bdkg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	fsverity@lists.linux.dev,
	dsterba@suse.com
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jaegeuk@kernel.org,
	chao@kernel.org,
	tytso@mit.edu
Subject: [PATCH v2 4/5] ext4: use I_VERITY_BUILDING instead of private flags
Date: Thu,  5 Nov 2026 12:55:29 +0100
Message-ID: <20261105115532.613467-5-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261105115532.613467-1-aalbersh@kernel.org>
References: <20261105115532.613467-1-aalbersh@kernel.org>
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
generic fs-verity enable path, drop the per-filesystem runtime flags that
duplicated this state.

Replace ext4 own helper ext4_verity_in_progress() with
fsverity_is_building(), and remove the EXT4_STATE_VERITY_IN_PROGRESS
flags. The IS_ENABLED() guard is fine to remove now as
fsverity_is_building() has stub for disabled fsverity.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/ext4/ext4.h   |  7 -------
 fs/ext4/file.c   |  2 +-
 fs/ext4/inode.c  | 17 +++++++++--------
 fs/ext4/ioctl.c  |  3 +--
 fs/ext4/verity.c | 18 +++++-------------
 5 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f38fec3167fb..bc624ed58353 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2049,7 +2049,6 @@ enum {
 	EXT4_STATE_MAY_INLINE_DATA,	/* may have in-inode data */
 	EXT4_STATE_EXT_PRECACHED,	/* extents have been precached */
 	EXT4_STATE_LUSTRE_EA_INODE,	/* Lustre-style ea_inode */
-	EXT4_STATE_VERITY_IN_PROGRESS,	/* building fs-verity Merkle tree */
 	EXT4_STATE_FC_COMMITTING,	/* Fast commit ongoing */
 	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
 	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
@@ -2128,12 +2127,6 @@ static inline int ext4_inode_state_wait_bit(int bit)
 #define EXT4_SB(sb)	(sb)
 #endif
 
-static inline bool ext4_verity_in_progress(struct inode *inode)
-{
-	return IS_ENABLED(CONFIG_FS_VERITY) &&
-	       ext4_test_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
-}
-
 #define NEXT_ORPHAN(inode) EXT4_I(inode)->i_dtime
 
 /*
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 50d3c92709c8..109dea94c6e3 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -318,7 +318,7 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	 * partial block that beyond the existing EOF, as it may contains
 	 * stale data written through mmap.
 	 */
-	if (iocb->ki_pos > old_size && !ext4_verity_in_progress(inode)) {
+	if (iocb->ki_pos > old_size && !fsverity_is_building(inode)) {
 		if (iocb->ki_flags & IOCB_NOWAIT)
 			return -EAGAIN;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 10cd85d4c721..171028185c9d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -42,6 +42,7 @@
 #include <linux/bitops.h>
 #include <linux/iomap.h>
 #include <linux/iversion.h>
+#include <linux/fsverity.h>
 
 #include "ext4_jbd2.h"
 #include "ext4_extents.h"
@@ -511,7 +512,7 @@ void ext4_check_map_extents_env(struct inode *inode)
 	    is_special_ino(inode->i_sb, inode->i_ino) ||
 	    (inode_state_read_once(inode) & (I_FREEING | I_WILL_FREE | I_NEW)) ||
 	    ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE) ||
-	    ext4_verity_in_progress(inode))
+	    fsverity_is_building(inode))
 		return;
 
 	WARN_ON_ONCE(!inode_is_locked(inode) &&
@@ -1498,7 +1499,7 @@ static int ext4_write_begin(const struct kiocb *iocb,
 
 	if (ret) {
 		bool extended = (pos + len > inode->i_size) &&
-				!ext4_verity_in_progress(inode);
+				!fsverity_is_building(inode);
 
 		folio_unlock(folio);
 		/*
@@ -1565,7 +1566,7 @@ static int ext4_write_end(const struct kiocb *iocb,
 	loff_t old_size = inode->i_size;
 	int ret = 0, ret2;
 	int i_size_changed = 0;
-	bool verity = ext4_verity_in_progress(inode);
+	bool verity = fsverity_is_building(inode);
 
 	trace_ext4_write_end(inode, pos, len, copied);
 
@@ -1670,7 +1671,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 	int partial = 0;
 	unsigned from, to;
 	int size_changed = 0;
-	bool verity = ext4_verity_in_progress(inode);
+	bool verity = fsverity_is_building(inode);
 
 	trace_ext4_journalled_write_end(inode, pos, len, copied);
 	from = pos & (PAGE_SIZE - 1);
@@ -2215,7 +2216,7 @@ static void mpage_submit_folio(struct mpage_da_data *mpd, struct folio *folio)
 	size = i_size_read(mpd->inode);
 	len = folio_size(folio);
 	if (folio_pos(folio) + len > size &&
-	    !ext4_verity_in_progress(mpd->inode))
+	    !fsverity_is_building(mpd->inode))
 		len = size & (len - 1);
 	ext4_bio_write_folio(&mpd->io_submit, folio, len);
 }
@@ -2305,7 +2306,7 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
 	ext4_lblk_t blocks = (i_size_read(inode) + i_blocksize(inode) - 1)
 							>> inode->i_blkbits;
 
-	if (ext4_verity_in_progress(inode))
+	if (fsverity_is_building(inode))
 		blocks = EXT_MAX_BLOCKS;
 
 	do {
@@ -2711,7 +2712,7 @@ static int mpage_journal_page_buffers(handle_t *handle,
 	mpd->wbc->nr_to_write -= folio_nr_pages(folio);
 
 	if (folio_pos(folio) + len > size &&
-	    !ext4_verity_in_progress(inode))
+	    !fsverity_is_building(inode))
 		len = size & (len - 1);
 
 	return ext4_journal_folio_buffers(handle, folio, len);
@@ -3276,7 +3277,7 @@ static int ext4_da_write_begin(const struct kiocb *iocb,
 
 	index = pos >> PAGE_SHIFT;
 
-	if (ext4_nonda_switch(inode->i_sb) || ext4_verity_in_progress(inode)) {
+	if (ext4_nonda_switch(inode->i_sb) || fsverity_is_building(inode)) {
 		*fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
 		return ext4_write_begin(iocb, mapping, pos,
 					len, foliop, fsdata);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e8e579498c99..d3db2e77ebda 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -575,8 +575,7 @@ static bool dax_compatible(struct inode *inode, unsigned int oldflags,
 
 	if (flags & EXT4_DAX_FL) {
 		if ((oldflags & EXT4_DAX_MUT_EXCL) ||
-		     ext4_test_inode_state(inode,
-					  EXT4_STATE_VERITY_IN_PROGRESS)) {
+		     fsverity_is_building(inode)) {
 			return false;
 		}
 	}
diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 56fe3e5b33e0..0189c8868b74 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -83,9 +83,6 @@ static int ext4_begin_enable_verity(struct file *filp)
 	if (IS_DAX(inode) || ext4_test_inode_flag(inode, EXT4_INODE_DAX))
 		return -EINVAL;
 
-	if (ext4_verity_in_progress(inode))
-		return -EBUSY;
-
 	/*
 	 * Since the file was opened readonly, we have to initialize the jbd
 	 * inode and quotas here and not rely on ->open() doing it.  This must
@@ -123,8 +120,6 @@ static int ext4_begin_enable_verity(struct file *filp)
 		return PTR_ERR(handle);
 
 	err = ext4_orphan_add(handle, inode);
-	if (err == 0)
-		ext4_set_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
 
 	ext4_journal_stop(handle);
 	return err;
@@ -185,10 +180,9 @@ static int ext4_end_enable_verity(struct file *filp, const void *desc,
 		goto cleanup;
 
 	/*
-	 * Write all pages (both data and verity metadata).  Note that this must
-	 * happen before clearing EXT4_STATE_VERITY_IN_PROGRESS; otherwise pages
-	 * beyond i_size won't be written properly.  For crash consistency, this
-	 * also must happen before the verity inode flag gets persisted.
+	 * Write all pages (both data and verity metadata). For crash
+	 * consistency, this also must happen before the verity inode flag gets
+	 * persisted.
 	 */
 	err = filemap_write_and_wait(inode->i_mapping);
 	if (err)
@@ -224,7 +218,6 @@ static int ext4_end_enable_verity(struct file *filp, const void *desc,
 
 	/* Now that rollback is no longer possible, set S_VERITY. */
 	ext4_set_inode_flags(inode, false);
-	ext4_clear_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
 	return 0;
 
 stop_and_cleanup:
@@ -234,13 +227,12 @@ static int ext4_end_enable_verity(struct file *filp, const void *desc,
 	/*
 	 * Verity failed to be enabled, so clean up by truncating any verity
 	 * metadata that was written beyond i_size (both from cache and from
-	 * disk), removing the inode from the orphan list (if it wasn't done
-	 * already), and clearing EXT4_STATE_VERITY_IN_PROGRESS.
+	 * disk) and removing the inode from the orphan list (if it wasn't done
+	 * already).
 	 */
 	truncate_inode_pages(inode->i_mapping, inode->i_size);
 	ext4_truncate(inode);
 	ext4_orphan_del(NULL, inode);
-	ext4_clear_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
 	return err;
 }
 
-- 
2.54.0

