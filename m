Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468F7CA9EC4
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 04:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D19D20866
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 04:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfJ3EOe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 00:14:34 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:4016 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727370AbfJ3EOb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 00:14:31 -0400
X-IronPort-AV: E=Sophos;i="5.68,245,1569254400"; 
   d="scan'208";a="77665122"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 30 Oct 2019 12:14:26 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 616F24CE1508;
        Wed, 30 Oct 2019 12:06:24 +0800 (CST)
Received: from localhost.localdomain (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Wed, 30 Oct 2019 12:14:32 +0800
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To:     <linux-xfs@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
        <darrick.wong@oracle.com>, <rgoldwyn@suse.de>, <hch@infradead.org>,
        <david@fromorbit.com>
CC:     <linux-kernel@vger.kernel.org>, <gujx@cn.fujitsu.com>,
        <qi.fuli@fujitsu.com>, <caoj.fnst@cn.fujitsu.com>,
        <ruansy.fnst@cn.fujitsu.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [RFC PATCH v2 4/7] fs: dedup file range to use a compare function
Date:   Wed, 30 Oct 2019 12:13:55 +0800
Message-ID: <20191030041358.14450-5-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
References: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: 616F24CE1508.A4B19
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

With dax we cannot deal with readpage() etc. So, we create a
funciton callback to perform the file data comparison and pass
it to generic_remap_file_range_prep() so it can use iomap-based
functions.

This may not be the best way to solve this. Suggestions welcome.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c     |  3 ++-
 fs/dax.c             | 58 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/file.c      |  2 +-
 fs/read_write.c      | 11 +++++----
 fs/xfs/xfs_reflink.c |  2 +-
 include/linux/dax.h  |  4 +++
 include/linux/fs.h   |  9 ++++++-
 7 files changed, 80 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index de730e56d3f5..ee16e275c44a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3910,7 +3910,8 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 		return ret;
 
 	return generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-					    len, remap_flags);
+					    len, remap_flags,
+					    vfs_dedupe_file_range_compare);
 }
 
 loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
diff --git a/fs/dax.c b/fs/dax.c
index e6174c0c669a..a4f90f3faddb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -30,6 +30,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/fs_dax.h>
 
+#define MIN(a, b) (((a) < (b)) ? (a) : (b))
+
 static inline unsigned int pe_order(enum page_entry_size pe_size)
 {
 	if (pe_size == PE_SIZE_PTE)
@@ -1826,3 +1828,59 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 	return dax_insert_pfn_mkwrite(vmf, pfn, order);
 }
 EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
+
+int dax_file_range_compare(struct inode *src, loff_t srcoff, struct inode *dest,
+		loff_t destoff, loff_t len, bool *is_same, const struct iomap_ops *ops)
+{
+	void *saddr, *daddr;
+	struct iomap s_iomap = {0};
+	struct iomap d_iomap = {0};
+	bool same = true;
+	loff_t cmp_len;
+	int id, ret = 0;
+
+	id = dax_read_lock();
+	while (len) {
+		ret = ops->iomap_begin(src, srcoff, len, 0, &s_iomap, NULL);
+		if (ret < 0) {
+			if (ops->iomap_end)
+				ops->iomap_end(src, srcoff, len, ret, 0, &s_iomap);
+			return ret;
+		}
+		cmp_len = len;
+		cmp_len = MIN(len, s_iomap.offset + s_iomap.length - srcoff);
+
+		ret = ops->iomap_begin(dest, destoff, cmp_len, 0, &d_iomap, NULL);
+		if (ret < 0) {
+			if (ops->iomap_end) {
+				ops->iomap_end(src, srcoff, len, ret, 0, &s_iomap);
+				ops->iomap_end(dest, destoff, len, ret, 0, &d_iomap);
+			}
+			return ret;
+		}
+		cmp_len = MIN(cmp_len, d_iomap.offset + d_iomap.length - destoff);
+
+		dax_iomap_direct_access(&s_iomap, srcoff,
+					ALIGN(srcoff + cmp_len, PAGE_SIZE),
+					NULL, &saddr);
+		dax_iomap_direct_access(&d_iomap, destoff,
+					ALIGN(destoff + cmp_len, PAGE_SIZE),
+					NULL, &daddr);
+
+		same = !memcmp(saddr, daddr, cmp_len);
+		if (!same)
+			break;
+		len -= cmp_len;
+		srcoff += cmp_len;
+		destoff += cmp_len;
+
+		if (ops->iomap_end) {
+			ret = ops->iomap_end(src, srcoff, len, 0, 0, &s_iomap);
+			ret = ops->iomap_end(dest, destoff, len, 0, 0, &d_iomap);
+		}
+	}
+	dax_read_unlock(id);
+	*is_same = same;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dax_file_range_compare);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 2e982db3e1ae..f29315d2e26b 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2545,7 +2545,7 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
 		goto out_unlock;
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-			&len, remap_flags);
+			&len, remap_flags, vfs_dedupe_file_range_compare);
 	if (ret < 0 || len == 0)
 		goto out_unlock;
 
diff --git a/fs/read_write.c b/fs/read_write.c
index 5bbf587f5bc1..9c7a8320a260 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1853,7 +1853,7 @@ static void vfs_unlock_two_pages(struct page *page1, struct page *page2)
  * Compare extents of two files to see if they are the same.
  * Caller must have locked both inodes to prevent write races.
  */
-static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
+int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 					 struct inode *dest, loff_t destoff,
 					 loff_t len, bool *is_same)
 {
@@ -1934,6 +1934,7 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 out_error:
 	return error;
 }
+EXPORT_SYMBOL_GPL(vfs_dedupe_file_range_compare);
 
 /*
  * Check that the two inodes are eligible for cloning, the ranges make
@@ -1945,7 +1946,8 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
  */
 int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
-				  loff_t *len, unsigned int remap_flags)
+				  loff_t *len, unsigned int remap_flags,
+				  compare_range_t compare)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -2004,9 +2006,8 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	 */
 	if (remap_flags & REMAP_FILE_DEDUP) {
 		bool		is_same = false;
-
-		ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
-				inode_out, pos_out, *len, &is_same);
+		ret = (*compare)(inode_in, pos_in,
+			inode_out, pos_out, *len, &is_same);
 		if (ret)
 			return ret;
 		if (!is_same)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index de451235c4ee..2c8ad581d4db 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1339,7 +1339,7 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-			len, remap_flags);
+			len, remap_flags, vfs_dedupe_file_range_compare);
 	if (ret < 0 || *len == 0)
 		goto out_unlock;
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 9bd8528bd305..4533bfb99683 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -220,6 +220,10 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
+int dax_file_range_compare(struct inode *src, loff_t srcoff,
+			   struct inode *dest, loff_t destoff,
+			   loff_t len, bool *is_same,
+			   const struct iomap_ops *ops);
 
 #ifdef CONFIG_FS_DAX
 int __dax_zero_page_range(struct block_device *bdev,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e0d909d35763..ac5755f70995 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1912,13 +1912,20 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *, rwf_t);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
+extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
+					 struct inode *dest, loff_t destoff,
+					 loff_t len, bool *is_same);
+typedef int (*compare_range_t)(struct inode *src, loff_t srcpos,
+			       struct inode *dest, loff_t destpos,
+			       loff_t len, bool *is_same);
 extern ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
 				       struct file *file_out, loff_t pos_out,
 				       size_t len, unsigned int flags);
 extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 					 struct file *file_out, loff_t pos_out,
 					 loff_t *count,
-					 unsigned int remap_flags);
+					 unsigned int remap_flags,
+					 compare_range_t cmp);
 extern loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
 				  loff_t len, unsigned int remap_flags);
-- 
2.23.0



