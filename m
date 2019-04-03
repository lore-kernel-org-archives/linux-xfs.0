Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfDCKmg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Apr 2019 06:42:36 -0400
From: Pankaj Gupta <pagupta@redhat.com>
Subject: [PATCH v4 5/5] xfs: disable map_sync for async flush
Date: Wed,  3 Apr 2019 16:10:18 +0530
Message-Id: <20190403104018.23947-6-pagupta@redhat.com>
In-Reply-To: <20190403104018.23947-1-pagupta@redhat.com>
References: <20190403104018.23947-1-pagupta@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@redhat.com, david@fromorbit.com, cohuck@redhat.com, xiaoguangrong.eric@gmail.com, pagupta@redhat.com

Virtio pmem provides asynchronous host page cache flush
mechanism. we don't support 'MAP_SYNC' with virtio pmem 
and xfs.

Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
---
 fs/xfs/xfs_file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1f2e2845eb76..dced2eb8c91a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1203,6 +1203,14 @@ xfs_file_mmap(
 	if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
 		return -EOPNOTSUPP;
 
+	/* We don't support synchronous mappings with DAX files if
+	 * dax_device is not synchronous.
+	 */
+	if (IS_DAX(file_inode(filp)) && !dax_synchronous(
+		xfs_find_daxdev_for_inode(file_inode(filp))) &&
+					(vma->vm_flags & VM_SYNC))
+		return -EOPNOTSUPP;
+
 	file_accessed(filp);
 	vma->vm_ops = &xfs_file_vm_ops;
 	if (IS_DAX(file_inode(filp)))
-- 
2.20.1
