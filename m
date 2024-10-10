Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE9C17C22F;
	Thu, 10 Oct 2024 09:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728552248; cv=none; b=qSzc9BLAYVZcppRk4OrCpFosW46S5pPzWZmmhyNyN4AE8L7SqqRyi2NBzPGrfn26xGAXhMOACFHOEu2VZC2kkF3USCMdGEP/QGTcqevWf13NF0Wl3m07mRRz+x17Iz2hkrX6t3qQi1Ey9880qqrGJ0dz0WG7k3UhuhaOa2X8JzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728552248; c=relaxed/simple;
	bh=ghzwxPwNu8feBDF0hyGDHijR9VuaksqZcNMBiDbhfH4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fFEJkhw6yTs2MDpqCJqwoh3+oF4BfFm0TtjWvIt/caFWFzyYjVx34C5Bo9zdVbzbB1Bd4MaxJfSyxPbovUXAKbbIRB530zrfKCQ60Gzt/7m4EsLCaKhrYU7b0LwOSKHzD/8OzuEXafodybmUH2ypHAyxGECfkcL15zLe9xKE7As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XPPSv4N0Xz4f3jdW;
	Thu, 10 Oct 2024 17:23:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7AF541A058E;
	Thu, 10 Oct 2024 17:24:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
	by APP4 (Coremail) with SMTP id gCh0CgAnXMgvnQdnqFHIDg--.40076S4;
	Thu, 10 Oct 2024 17:24:00 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	chandan.babu@oracle.com,
	dchinner@redhat.com
Cc: linux-kernel@vger.kernel.org,
	yebin10@huawei.com,
	zhangxiaoxu5@huawei.com
Subject: [PATCH] xfs: fix dead loop when do mount with IO fault injection
Date: Thu, 10 Oct 2024 17:38:35 +0800
Message-Id: <20241010093835.1506926-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnXMgvnQdnqFHIDg--.40076S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tr1UJF4xJw13ur13Gr4fGrg_yoW8KF4rp3
	93Ga1DGrykWr45Cws2kas8K348K3yrCa1a9rs2g3W3X3ZxJryxKF1rtFnFgryDKFsYvry0
	qr18Gw4DWw45Ca7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF
	7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IUbiF4tUUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

When do IO fault injection, mount maybe hung:
blk_update_request: I/O error, dev dm-4, sector 2128216 op 0x0:(READ)
flags 0x1000 phys_seg 1 prio class 0
XFS (dm-4): metadata I/O error in "xfs_btree_read_buf_block.constprop.
0+0x190/0x200 [xfs]" at daddr 0x207958 len 8 error 5
blk_update_request: I/O error, dev dm-4, sector 2108042 op 0x1:(WRITE)
flags 0x29800 phys_seg 1 prio class 0
XFS (dm-4): log I/O error -5
XFS (dm-4): Metadata I/O Error (0x1) detected at xfs_trans_read_buf_map
+0x2b6/0x510 [xfs] (fs/xfs/xfs_trans_buf.c:296).  Shutting down filesystem.
sd 6:0:0:3: [sdh] Synchronizing SCSI cache
XFS (dm-4): Please unmount the filesystem and rectify the problem(s)
XFS (dm-4): Failed to recover intents
XFS (dm-4): Ending recovery (logdev: internal)

xfs_buftarg_drain+0x53a/0x740
xfs_log_mount_finish+0x2be/0x550
xfs_mountfs+0x16ba/0x2220
xfs_fs_fill_super+0x1376/0x1f10
get_tree_bdev+0x44a/0x770
vfs_get_tree+0x8d/0x350
path_mount+0x1228/0x1cc0
do_mount+0xf7/0x110
__x64_sys_mount+0x193/0x230
do_syscall_64+0x39/0xb0
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Above issue hapnens as xfs_buf log item is in AIL list, but xlog is already
shutdown, so xfs_log_worker() will not wakeup xfsaild to submit AIL list.
Then the last 'b_hold' will no chance to be decreased. Then
xfs_buftarg_drain() will dead loop to free xfs_buf.
To solve above issue there is need to push AIL list before call
xfs_buftarg_drain(). As xfs_log_mount_finish() return error, xfs_mountfs()
will call xfs_log_mount_cancel() to clean AIL list, and call
xfs_buftarg_drain() to make sure all xfs_buf has been reclaimed. So what we
need to do is call xfs_wait_buftarg() when 'error == 0' in
xfs_log_mount_finish().

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/xfs/xfs_log.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 817ea7e0a8ab..b91892733b78 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -765,7 +765,9 @@ xfs_log_mount_finish(
 	} else {
 		xfs_info(mp, "Ending clean mount");
 	}
-	xfs_buftarg_drain(mp->m_ddev_targp);
+
+	if (!error)
+		xfs_buftarg_drain(mp->m_ddev_targp);
 
 	clear_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
 
-- 
2.31.1

