Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AECCC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbiLaB7O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbiLaB7N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:59:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613CD1C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:59:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F060161C63
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C34C433D2;
        Sat, 31 Dec 2022 01:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451951;
        bh=60Aa8kLwcxl1JFcfdqnLAU0sQB63EmIk8WV/gAj7c7k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=squ3xetuE8lnO0Ng3C0Frp8XzHFjg39myXWYjDtkVeddn8VHQE/7r4iJr0SJrzhVV
         jlPxk4rLg9JQi+9AUckt08rmnulLsXY0ETeTFaVZw5hW5+GvGU3PlSPSDu6b9gPwxQ
         bKCxxk92zWuEeS6Mf0Q/4/tPzRPIWc0Exbh5Nc3D3MqXk7bZmOfxgEOwJqLBeAQ1HV
         P8xKi7q1O1lRFIQp4PUCGj9FO8MLvO6Xc5QhevbBhYxqj2NKFVD/TSv3Eqpg7nGEn4
         8I4NJpbsNir8XtZ/l66PMpnFwku5zmfjsnpZRsD5ZVhqWBGM0pIk6a7dKX2+SoqJYy
         p+6Oe36dPzY8Q==
Subject: [PATCH 1/9] vfs: explicitly pass the block size to the remap prep
 function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:38 -0800
Message-ID: <167243871817.718512.8634564486988370537.stgit@magnolia>
In-Reply-To: <167243871792.718512.13170681692847163098.stgit@magnolia>
References: <167243871792.718512.13170681692847163098.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index c48a3a93ab29..9ec07a06f49c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2035,7 +2035,10 @@ int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
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
index 469d53fb42e9..8a43038dc3e7 100644
--- a/fs/remap_range.c
+++ b/fs/remap_range.c
@@ -29,18 +29,18 @@
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
@@ -74,10 +74,10 @@ static int generic_remap_checks(struct file *file_in, loff_t pos_in,
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
 
@@ -125,9 +125,10 @@ static int generic_remap_check_len(struct inode *inode_in,
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
@@ -268,7 +269,8 @@ int
 __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				struct file *file_out, loff_t pos_out,
 				loff_t *len, unsigned int remap_flags,
-				const struct iomap_ops *dax_read_ops)
+				const struct iomap_ops *dax_read_ops,
+				unsigned int blocksize)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -303,7 +305,7 @@ __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 
 	/* Check that we don't violate system file offset limits. */
 	ret = generic_remap_checks(file_in, pos_in, file_out, pos_out, len,
-			remap_flags);
+			remap_flags, blocksize);
 	if (ret || *len == 0)
 		return ret;
 
@@ -344,7 +346,7 @@ __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	}
 
 	ret = generic_remap_check_len(inode_in, inode_out, pos_out, len,
-			remap_flags);
+			remap_flags, blocksize);
 	if (ret || *len == 0)
 		return ret;
 
@@ -354,13 +356,17 @@ __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 
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
index cd86ac22c339..5f8f4b11dc28 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2204,7 +2204,8 @@ extern ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
 int __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				    struct file *file_out, loff_t pos_out,
 				    loff_t *len, unsigned int remap_flags,
-				    const struct iomap_ops *dax_read_ops);
+				    const struct iomap_ops *dax_read_ops,
+				    unsigned int block_size);
 int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
 				  loff_t *count, unsigned int remap_flags);

