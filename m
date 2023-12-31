Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DE811189
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sQ2RzmTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB58C433CA;
	Sun, 31 Dec 2023 21:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059778;
	bh=yFeOMuN68qYYPMEpSZyDLwjbySyE1VG7tN59Fa7ykSk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sQ2RzmTU7uPN9RxSavxOu7aeccWCK4KQ37gLumzjDqBlAugAzQOi28EpD2R84kb3f
	 /J0elOjULm6a3TMW82w5f3qo/advE4A9ly9e+yrKS7gchkSduuZWCIz3jPLllYiRRN
	 1Xf7iJ+ERnN6R5/lk8SjsaFx5f2v96ZCyYqDrnR9HadjXr+eGDD0gBxlIi9XQhAJHB
	 0f95saHjIA+DZx+BGU6RsWfaoyp3gAgyNYaWVc7H47WyP84k+Tz7f0GfXBXTbYzrHD
	 15OFVNvTL7llUvpNWgUegn6f99sdMCI6St5M/0WmP4+k9HflD/cM++55f87BuTUlPR
	 lQByHqqlNe2JQ==
Date: Sun, 31 Dec 2023 13:56:18 -0800
Subject: [PATCH 1/9] vfs: explicitly pass the block size to the remap prep
 function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852686.1767395.2701297777524398388.stgit@frogsfrogsfrogs>
In-Reply-To: <170404852650.1767395.17654728220580066333.stgit@frogsfrogsfrogs>
References: <170404852650.1767395.17654728220580066333.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/dax.c           |    5 ++++-
 fs/remap_range.c   |   30 ++++++++++++++++++------------
 include/linux/fs.h |    3 ++-
 3 files changed, 24 insertions(+), 14 deletions(-)


diff --git a/fs/dax.c b/fs/dax.c
index 3380b43cb6bbb..06b631eafb46c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2061,7 +2061,10 @@ int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
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
index f75ff15c94976..5d5b802f56086 100644
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
 
@@ -128,9 +128,10 @@ static int generic_remap_check_len(struct inode *inode_in,
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
@@ -271,7 +272,8 @@ int
 __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				struct file *file_out, loff_t pos_out,
 				loff_t *len, unsigned int remap_flags,
-				const struct iomap_ops *dax_read_ops)
+				const struct iomap_ops *dax_read_ops,
+				unsigned int blocksize)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -306,7 +308,7 @@ __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 
 	/* Check that we don't violate system file offset limits. */
 	ret = generic_remap_checks(file_in, pos_in, file_out, pos_out, len,
-			remap_flags);
+			remap_flags, blocksize);
 	if (ret || *len == 0)
 		return ret;
 
@@ -347,7 +349,7 @@ __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	}
 
 	ret = generic_remap_check_len(inode_in, inode_out, pos_out, len,
-			remap_flags);
+			remap_flags, blocksize);
 	if (ret || *len == 0)
 		return ret;
 
@@ -357,13 +359,17 @@ __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 
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
index d9badb63bfc29..aeead94a5b167 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2036,7 +2036,8 @@ int remap_verify_area(struct file *file, loff_t pos, loff_t len, bool write);
 int __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				    struct file *file_out, loff_t pos_out,
 				    loff_t *len, unsigned int remap_flags,
-				    const struct iomap_ops *dax_read_ops);
+				    const struct iomap_ops *dax_read_ops,
+				    unsigned int block_size);
 int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
 				  loff_t *count, unsigned int remap_flags);

