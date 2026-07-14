Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1712942BC3C;
	Tue, 14 Jul 2026 21:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784063401; cv=none; b=UIoGkmL1juUKWFdmnWz3MpzAPI1Jq9sQeWsKoQLwUrEqIdq6oU0yB5dZErf0d3+7p55od+0/k9rNF6bogFLwzdng0H4e8NhjzNPnmMhY0Qw4T9/GDbbOE2z30HLujXdXtK2y371rnxHzBqhT8vV7NCVRxMevAY4nxS6uIADvAeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784063401; c=relaxed/simple;
	bh=/PKCeTzBGwJ/fX/RPVvV2t7fJeEV6MwvJOtgIgoCvVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LwDZGIIo7sLkSMIAX5+2rT82CeBOxCelVntevXsBwr434BCKxlxaSTExChGikB+WFTlQLZO6UyL8PmSMVUPJ5Xxyjdv5MU9vsGk8+Y3zpvWAeSUvJhrkc67BZbxewilPyaERslGnpL/AmOHopyn+pm+7j9CE1Hk+Cg48T1rLcDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZtihMZIc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZtihMZIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A3A1F000E9;
	Tue, 14 Jul 2026 21:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784063399;
	bh=be6DrEWvPa6kK/0Bi2TniGp6w6cr2kXmMjxcnQdvtQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZtihMZIcpfKz1Lwu6hNVxt52R9gEJsvFCje+8P9ba1jEfmxJJBG2sxKQF2oEA7fsG
	 pGc/Wf3v9z2avwKy0DQ+TFwIIJQBEEh6mvxu6m+wEk+76ngw2bCcKbCBR1cS94rA2h
	 YLO8QIEzBi7rl6m0Chu7VUtiAjf+dtFgcUSGyCVyhZAK7H+zO2uOCRKBIHV1Q9jwbM
	 +L6Hctr12fMFVSS0pDSL04cPVqWIetfdwYgar8qD1FsUgo2WUhgvNHF4uUCU62K8xQ
	 2fXsnPpP1HdkROUKHyoFD+ed2FbGrbjeMdAx3hzoo2RDo8l9oJvAZSxB3n+Lhc2GnS
	 VzkzzylqNBuxg==
Date: Tue, 14 Jul 2026 15:09:57 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, jack@suse.cz, brauner@kernel.org, cem@kernel.org,
	jaegeuk@kernel.org, aalbersh@kernel.org, tytso@mit.edu
Subject: Re: [PATCHv2 3/5] xfs: report direct io attributes through
 file_getattr
Message-ID: <alalpRYxjqtdJhVR@kbusch-mbp>
References: <20260710210646.3576365-1-kbusch@meta.com>
 <20260710210646.3576365-4-kbusch@meta.com>
 <alTTRoOEglwuf4vg@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alTTRoOEglwuf4vg@infradead.org>

On Mon, Jul 13, 2026 at 05:00:06AM -0700, Christoph Hellwig wrote:
> Or maybe using the file attr for this isn't actually a good idea,
> and we should do an ioctl instead which automatically gets routed to
> the block device fops?

Something like this instead?

---
diff --git a/block/ioctl.c b/block/ioctl.c
index 3d4ea1537457d..6de2f87bcb8bd 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -642,6 +642,21 @@ static int blkdev_bszset(struct file *file, blk_mode_t mode,
 	return ret;
 }
 
+void bdev_dio_align(struct block_device *bdev, struct fs_dio_align *align)
+{
+	align->dio_mem_align = bdev_dma_alignment(bdev) + 1;
+	align->dio_offset_align = bdev_logical_block_size(bdev);
+	align->dio_read_offset_align = bdev_logical_block_size(bdev);
+	align->dio_virt_boundary_align = bdev_virt_boundary_alignment(bdev);
+	align->dio_offset_align_max_vecs = bdev_max_segments(bdev);
+}
+EXPORT_SYMBOL_GPL(bdev_dio_align);
+
 /*
  * Common commands that are handled the same way on native and compat
  * user space. Note the separate arg/argp parameters that are needed
@@ -690,6 +705,12 @@ static int blkdev_common_ioctl(struct block_device *bdev, blk_mode_t mode,
 		return put_uint(argp, bdev_io_opt(bdev));
 	case BLKALIGNOFF:
 		return put_int(argp, bdev_alignment_offset(bdev));
+	case FS_IOC_GETDIOALIGN: {
+		struct fs_dio_align align = {};
+
+		bdev_dio_align(bdev, &align);
+		return copy_to_user(argp, &align, sizeof(align)) ? -EFAULT : 0;
+	}
 	case BLKDISCARDZEROES:
 		return put_uint(argp, 0);
 	case BLKSECTGET:
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1b53701bebea1..e980522fa7539 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -49,6 +49,7 @@
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
+#include <linux/blkdev.h>
 
 /* Return 0 on success or positive error */
 int
@@ -1244,6 +1245,23 @@ xfs_file_ioctl(
 	"%s should use fallocate; XFS_IOC_{ALLOC,FREE}SP ioctl unsupported",
 				current->comm);
 		return -ENOTTY;
+	case FS_IOC_GETDIOALIGN: {
+		struct fs_dio_align	align = {};
+
+		if (!S_ISREG(inode->i_mode))
+			return -ENOTTY;
+		bdev_dio_align(xfs_inode_buftarg(ip)->bt_bdev, &align);
+		if (xfs_is_cow_inode(ip))
+			align.dio_offset_align = xfs_inode_alloc_unitsize(ip);
+		if (copy_to_user(arg, &align, sizeof(align)))
+			return -EFAULT;
+		return 0;
+	}
 	case XFS_IOC_DIOINFO: {
 		struct kstat		st;
 		struct dioattr		da;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9213a5716f95a..dc32acf696e40 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1607,6 +1607,17 @@ static inline unsigned int bdev_dma_alignment(struct block_device *bdev)
 	return queue_dma_alignment(bdev_get_queue(bdev));
 }
 
+static inline unsigned long bdev_virt_boundary_mask(struct block_device *bdev)
+{
+	return bdev_get_queue(bdev)->limits.virt_boundary_mask;
+}
+
+static inline unsigned int
+bdev_virt_boundary_alignment(struct block_device *bdev)
+{
+	return bdev_virt_boundary_mask(bdev) + 1;
+}
+
 static inline unsigned int
 blk_lim_dma_alignment_and_pad(struct queue_limits *lim)
 {
@@ -1805,6 +1816,8 @@ int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
 int sync_blockdev_nowait(struct block_device *bdev);
 void sync_bdevs(bool wait);
 void bdev_statx(const struct path *path, struct kstat *stat, u32 request_mask);
+struct fs_dio_align;
+void bdev_dio_align(struct block_device *bdev, struct fs_dio_align *align);
 void printk_all_partitions(void);
 int __init early_lookup_bdev(const char *pathname, dev_t *dev);
 #else
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index bd87262f2e349..81b0c81e17282 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -234,6 +234,21 @@ struct file_attr {
 #define FILE_ATTR_SIZE_VER0 24
 #define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER0
 
+struct fs_dio_align {
+	__u32 dio_mem_align;		/* buffer alignment */
+	__u32 dio_offset_align;		/* write offset alignment */
+	__u32 dio_read_offset_align;	/* read offset alignment */
+	__u32 dio_virt_boundary_align;	/* segment boundary */
+	__u32 dio_offset_align_max_vecs;	/* max vecs per unit */
+	__u32 dio_reserved[3];		/* must be zero */
+};
+
 /*
  * Flags for the fsx_xflags field
  */
@@ -344,6 +359,8 @@ struct file_attr {
 #define FS_IOC_GETFSSYSFSPATH		_IOR(0x15, 1, struct fs_sysfs_path)
 /* Get logical block metadata capability details */
 #define FS_IOC_GETLBMD_CAP		_IOWR(0x15, 2, struct logical_block_metadata_cap)
+/* Get direct I/O alignment and layout constraints */
+#define FS_IOC_GETDIOALIGN		_IOR(0x15, 3, struct fs_dio_align)
 
 /*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
--
