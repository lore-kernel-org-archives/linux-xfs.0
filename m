Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59048 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfDWIIL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Apr 2019 04:08:11 -0400
From: Pankaj Gupta <pagupta@redhat.com>
Subject: [PATCH v6 5/6] ext4: disable map_sync for async flush
Date: Tue, 23 Apr 2019 13:36:11 +0530
Message-Id: <20190423080612.15361-6-pagupta@redhat.com>
In-Reply-To: <20190423080612.15361-1-pagupta@redhat.com>
References: <20190423080612.15361-1-pagupta@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@redhat.com, david@fromorbit.com, cohuck@redhat.com, xiaoguangrong.eric@gmail.com, pagupta@redhat.com, pbonzini@redhat.com, yuval.shaia@oracle.com, kilobyte@angband.pl

Dont support 'MAP_SYNC' with non-DAX files and DAX files
with asynchronous dax_device. Virtio pmem provides 
asynchronous host page cache flush mechanism. We don't
support 'MAP_SYNC' with virtio pmem and ext4.

Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
---
 fs/ext4/file.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 69d65d49837b..4b2ccaf1932e 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -360,15 +360,16 @@ static const struct vm_operations_struct ext4_file_vm_ops = {
 static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct inode *inode = file->f_mapping->host;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct dax_device *dax_dev = sbi->s_daxdev;
 
-	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+	if (unlikely(ext4_forced_shutdown(sbi)))
 		return -EIO;
 
-	/*
-	 * We don't support synchronous mappings for non-DAX files. At least
-	 * until someone comes with a sensible use case.
+	/* We don't support synchronous mappings for non-DAX files and
+	 * for DAX files if underneath dax_device is not synchronous.
 	 */
-	if (!IS_DAX(file_inode(file)) && (vma->vm_flags & VM_SYNC))
+	if (!daxdev_mapping_supported(vma, dax_dev))
 		return -EOPNOTSUPP;
 
 	file_accessed(file);
-- 
2.20.1
