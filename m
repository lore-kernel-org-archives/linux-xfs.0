Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6278317BA1
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052904; cv=none; b=rkfMovjceYNsCY94FppUv9Yd8FiIE/A5pw7CeuGBZwPGGhJhRRAIJVmsd373l4wjzFDMrLrTUsmfKnAuaTMz5o+5wOaJfIpmAclMzm2J5LuYgcMTwYZ/bP9Lfh7KdkrBJ0U0kwtRa//bFqoLbt2Myr0Tk6k06ZhvBVGxigp4LrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052904; c=relaxed/simple;
	bh=v/juFr1JZ3Mw7m4ULZG1dvu6bJZJbU4F1Y2pTICBUMU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lSId6vDb2gXNNGjRYV3n5CwP2M3ZfxrundZuQTOCmaH3dQN/KBmcQyyZlvXzdG4nk6mcZ7gShB6onzgd7uesASNsYfiKN7jSh/vveKWPnC0XuwPsqyhiHnRtAJd6lLDU4+AuLHdxQTDuDoBSUR5gxpvx/0fOPWAwJdgYrr8Gfxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L85F9kfU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L85F9kfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11DAC4CECE;
	Fri, 13 Dec 2024 01:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052903;
	bh=v/juFr1JZ3Mw7m4ULZG1dvu6bJZJbU4F1Y2pTICBUMU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L85F9kfUlrqLww01xtaGJptmXm6EavzSBPc1zUZh8q/drd+KCMHvkd9NfRwtlwEck
	 uNBxmA+hNH6slNf+XUcNgMYbjTskU7bjKOyKl+RUkP3AYoLOxzoGu4IAsa7HO5Iq10
	 k7wLmizFpnW4bSLzoXwqPBWKrbpQNkTE7aVxD40V57G5+ZcevDxc1N3SrPMikmFpGi
	 SaGkbalv8r8bcKF+iphay1xSD3SwFTv4pUA1e9a9rFPGh4Pz8p44PZ906kmiL1kovl
	 8l4f8PQe5PpNpL/DsbCMIgKijRfBcKNYlgMR9JftmJFCDZ3vvHUawQ5mA2pWuMafCS
	 phE/jVBf5WuJw==
Date: Thu, 12 Dec 2024 17:21:43 -0800
Subject: [PATCH 01/11] vfs: explicitly pass the block size to the remap prep
 function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125759.1184063.6610287530974429945.stgit@frogsfrogsfrogs>
In-Reply-To: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
References: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make it so that filesystems can pass an explicit blocksize to the remap
prep function.  This enables filesystems whose fundamental allocation
units are /not/ the same as the blocksize to ensure that the remapping
checks are aligned properly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/dax.c           |    5 ++++-
 fs/remap_range.c   |   30 ++++++++++++++++++------------
 include/linux/fs.h |    3 ++-
 3 files changed, 24 insertions(+), 14 deletions(-)


diff --git a/fs/dax.c b/fs/dax.c
index 21b47402b3dca4..c7ea298b4214a5 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2076,7 +2076,10 @@ int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 			      loff_t *len, unsigned int remap_flags,
 			      const struct iomap_ops *ops)
 {
+	unsigned int blocksize = file_inode(file_out)->i_sb->s_blocksize;
+
 	return __generic_remap_file_range_prep(file_in, pos_in, file_out,
-					       pos_out, len, remap_flags, ops);
+					       pos_out, len, remap_flags, ops,
+					       blocksize);
 }
 EXPORT_SYMBOL_GPL(dax_remap_file_range_prep);
diff --git a/fs/remap_range.c b/fs/remap_range.c
index 26afbbbfb10c2e..d3c6c6b05eb191 100644
--- a/fs/remap_range.c
+++ b/fs/remap_range.c
@@ -30,18 +30,18 @@
  */
 static int generic_remap_checks(struct file *file_in, loff_t pos_in,
 				struct file *file_out, loff_t pos_out,
-				loff_t *req_count, unsigned int remap_flags)
+				loff_t *req_count, unsigned int remap_flags,
+				unsigned int blocksize)
 {
 	struct inode *inode_in = file_in->f_mapping->host;
 	struct inode *inode_out = file_out->f_mapping->host;
 	uint64_t count = *req_count;
 	uint64_t bcount;
 	loff_t size_in, size_out;
-	loff_t bs = inode_out->i_sb->s_blocksize;
 	int ret;
 
 	/* The start of both ranges must be aligned to an fs block. */
-	if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_out, bs))
+	if (!IS_ALIGNED(pos_in, blocksize) || !IS_ALIGNED(pos_out, blocksize))
 		return -EINVAL;
 
 	/* Ensure offsets don't wrap. */
@@ -75,10 +75,10 @@ static int generic_remap_checks(struct file *file_in, loff_t pos_in,
 	 */
 	if (pos_in + count == size_in &&
 	    (!(remap_flags & REMAP_FILE_DEDUP) || pos_out + count == size_out)) {
-		bcount = ALIGN(size_in, bs) - pos_in;
+		bcount = ALIGN(size_in, blocksize) - pos_in;
 	} else {
-		if (!IS_ALIGNED(count, bs))
-			count = ALIGN_DOWN(count, bs);
+		if (!IS_ALIGNED(count, blocksize))
+			count = ALIGN_DOWN(count, blocksize);
 		bcount = count;
 	}
 
@@ -134,9 +134,10 @@ static int generic_remap_check_len(struct inode *inode_in,
 				   struct inode *inode_out,
 				   loff_t pos_out,
 				   loff_t *len,
-				   unsigned int remap_flags)
+				   unsigned int remap_flags,
+				   unsigned int blocksize)
 {
-	u64 blkmask = i_blocksize(inode_in) - 1;
+	u64 blkmask = blocksize - 1;
 	loff_t new_len = *len;
 
 	if ((*len & blkmask) == 0)
@@ -277,7 +278,8 @@ int
 __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				struct file *file_out, loff_t pos_out,
 				loff_t *len, unsigned int remap_flags,
-				const struct iomap_ops *dax_read_ops)
+				const struct iomap_ops *dax_read_ops,
+				unsigned int blocksize)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -312,7 +314,7 @@ __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 
 	/* Check that we don't violate system file offset limits. */
 	ret = generic_remap_checks(file_in, pos_in, file_out, pos_out, len,
-			remap_flags);
+			remap_flags, blocksize);
 	if (ret || *len == 0)
 		return ret;
 
@@ -353,7 +355,7 @@ __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	}
 
 	ret = generic_remap_check_len(inode_in, inode_out, pos_out, len,
-			remap_flags);
+			remap_flags, blocksize);
 	if (ret || *len == 0)
 		return ret;
 
@@ -363,13 +365,17 @@ __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 
 	return ret;
 }
+EXPORT_SYMBOL(__generic_remap_file_range_prep);
 
 int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
 				  loff_t *len, unsigned int remap_flags)
 {
+	unsigned int blocksize = file_inode(file_out)->i_sb->s_blocksize;
+
 	return __generic_remap_file_range_prep(file_in, pos_in, file_out,
-					       pos_out, len, remap_flags, NULL);
+					       pos_out, len, remap_flags, NULL,
+					       blocksize);
 }
 EXPORT_SYMBOL(generic_remap_file_range_prep);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7e29433c5ecce2..b638fb1bcbc96f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2191,7 +2191,8 @@ int remap_verify_area(struct file *file, loff_t pos, loff_t len, bool write);
 int __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				    struct file *file_out, loff_t pos_out,
 				    loff_t *len, unsigned int remap_flags,
-				    const struct iomap_ops *dax_read_ops);
+				    const struct iomap_ops *dax_read_ops,
+				    unsigned int block_size);
 int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
 				  loff_t *count, unsigned int remap_flags);

