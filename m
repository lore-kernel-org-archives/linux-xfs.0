Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6683C465
	for <linux-xfs@vger.kernel.org>; Sat, 13 Dec 2025 03:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765598399; cv=none; b=Zon/lMCBFpEg5CWbYwIwBH1cTMs7eCCwMfxbqcXw82c3cwuGuylnHhoW2CufTD+JC4wGSHOxrJM5ehXM6eStw6FdBOud8uBW0UyoitxP6kZG7jXMmOJneoGAjZ7eNyYd2+U1hrIslYiXXIpz/ywdKtnsGvdfkxAl7SitAhYcVMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765598399; c=relaxed/simple;
	bh=z06FZY+MYDysc5WZlVMCI1AgnCEtET5EAqv6W3jlXtw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vj1RVYRONsTSYlr6/6ZePpQRGMvOCEOIXKKZuAmWFyDGNbvmJDncWmpQbqGFuitrB4HcymvhqB8ec1uxu2p9dC0q8+C1cGybuIWDeja7HZzigi7nFf+9JnKhgqe5GqP0XYv1Mfn0tehLeESOIpUn+o+6MPs7itl7/21V8zjGIxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dSsyt6mSRzYQtyq
	for <linux-xfs@vger.kernel.org>; Sat, 13 Dec 2025 11:59:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7D7141A06DF
	for <linux-xfs@vger.kernel.org>; Sat, 13 Dec 2025 11:59:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgBHqPi45DxpYwMCAA--.611S6;
	Sat, 13 Dec 2025 11:59:54 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	chandan.babu@oracle.com,
	dchinner@redhat.com
Cc: yebin10@huawei.com
Subject: [PATCH 2/2] xfs: fix xfs_recover_inode_owner_change() failed
Date: Sat, 13 Dec 2025 11:59:51 +0800
Message-Id: <20251213035951.2237214-3-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251213035951.2237214-1-yebin@huaweicloud.com>
References: <20251213035951.2237214-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHqPi45DxpYwMCAA--.611S6
X-Coremail-Antispam: 1UD129KBjvJXoWxZF1UJrWkCr4Uuw13Xw1UKFg_yoW5tryDpr
	n3Jr1DGrZ5J3WUGF1fCr4Yvry8tFWYkF4UXr40gr17X3WDWr1jqr4vgFW8XryUJFWjvry3
	trn3Zw4vqr17WaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPvb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64
	vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_JF0_Jw1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2Iq
	xVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r
	126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY
	6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67
	AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuY
	vjxU7PfHUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

There's a issue as follows:
XFS: Assertion failed: in_f->ilf_fields & XFS_ILOG_DBROOT, file:
fs/xfs/xfs_inode_item_recover.c, line: 100
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:102!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 15687 Comm: mount Not tainted 6.18.0-next
RIP: 0010:assfail+0x9f/0xb0
RSP: 0018:ffffc90008de7340 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff8380ffa6
RDX: ffff88811abdba80 RSI: ffffffff8380ffcf RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: fffff520011bcdf9
R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff8af4fc60
R13: 0000000000000064 R14: ffffc90008de7860 R15: 0000000000000000
FS:  00007f0950a07880(0000) GS:ffff88878ad5b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f144fa03000 CR3: 00000001133b4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 xfs_recover_inode_owner_change+0x346/0x3a0
 xlog_recover_inode_commit_pass2+0x150e/0x2820
 xlog_recover_items_pass2+0x102/0x170
 xlog_recover_commit_trans+0x43f/0x980
 xlog_recovery_process_trans+0x1c0/0x1e0
 xlog_recover_process_ophdr+0x1ef/0x420
 xlog_recover_process_data+0x1ad/0x480
 xlog_recover_process+0x26d/0x480
 xlog_do_recovery_pass+0x6ea/0xfb0
 xlog_do_log_recovery+0xa7/0x110
 xlog_do_recover+0xe9/0x4e0
 xlog_recover+0x2af/0x500
 xfs_log_mount+0x23d/0x590
 xfs_mountfs+0x10b8/0x2260
 xfs_fs_fill_super+0x16aa/0x21d0
 get_tree_bdev_flags+0x38f/0x620
 vfs_get_tree+0x9c/0x380
 path_mount+0x72b/0x21c0
 __x64_sys_mount+0x298/0x310
 do_syscall_64+0x72/0xf80

Above issue happens as miss add XFS_ILOG_DOWNER flag for inode which format
is XFS_DINODE_FMT_EXTENTS.
We can reproduce above issue as follow steps:
1. Create two files with XFS_DINODE_FMT_BTREE format.
fallocate -l1m  /tmp/file1
for i in `seq 1 127`;do fallocate -p -o $((8192*i)) -l 4096 /tmp/file1;done
fallocate -l1m  /home/test/file2
for i in `seq 1 127`;do fallocate -p -o $((8192*i)) -l 4096 /tmp/file2;done
2. Swap two files with XFS_IOC_SWAPEXT IOCTL command.
3. Make inode with XFS_DINODE_FMT_EXTENTS format.
truncate -s 81920 /home/test/file1
truncate -s 81920 /home/test/file2
4. Wait for iclog submit to disk then power off.
5. Mount xfs file system will reproduce above issue.

To solve above issue there's need to clear XFS_ILOG_DOWNER flag for inode
which has XFS_DINODE_FMT_EXTENTS data format.

Fixes: 21b5c9784bce ("xfs: swap extents operations for CRC filesystems")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/xfs/xfs_inode_item.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 81dfe70e173d..f3ea98504cf0 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -343,8 +343,8 @@ xfs_inode_item_format_data_fork(
 
 	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
-		iip->ili_fields &=
-			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
+		iip->ili_fields &= ~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
+				     XFS_ILOG_DEV | XFS_ILOG_DOWNER);
 
 		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
 		    ip->i_df.if_nextents > 0 &&
-- 
2.34.1

