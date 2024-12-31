Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5295F13C9C4
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 02:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735612750; cv=none; b=nhwJui+o9RE8lIIi0Uo4jWiUcQNPAyIlNesbyNDoXC6UQYl1CoPxxzcQGlmhkGYh4ti2J3nIo5knPwYgbxPVzUT3uelIuhhqWh5toU4fdNfYNlQxVSSwGzKNnYtiZmN+5w+o7pF+eRi3Zl2vLf+o7CUsrPXARTu18uJFEnCYzV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735612750; c=relaxed/simple;
	bh=hSXbnmhzaUjhg5HZgrHHGvRWP022yZXfV24xLgETBHU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QEtbGOuP2PrPMWADdHdof3J9j4lag3ncdz1fp+pitUXWbXNylKFsiO8SqEhVuyhG0D3Gq2CWqN7UolZeXX+tNKKe3IVErVox9gxBnF5tgvjLA5qCsUOKiygqRAbC0oYZynJqCGxtQsY/UkZ2nqutCzOpXU3iy/77dx01R9l2txU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4YMcXv2H4bz2DjY2;
	Tue, 31 Dec 2024 10:36:15 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 237BD180044;
	Tue, 31 Dec 2024 10:39:06 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 31 Dec
 2024 10:39:05 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 2/2] xfs: fix mount hang during primary superblock recovery failure
Date: Tue, 31 Dec 2024 10:34:23 +0800
Message-ID: <20241231023423.656128-3-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241231023423.656128-1-leo.lilong@huawei.com>
References: <20241231023423.656128-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf500017.china.huawei.com (7.185.36.126)

When mounting an image containing a log with sb modifications that require
log replay, the mount process hang all the time and stack as follows:

  [root@localhost ~]# cat /proc/557/stack
  [<0>] xfs_buftarg_wait+0x31/0x70
  [<0>] xfs_buftarg_drain+0x54/0x350
  [<0>] xfs_mountfs+0x66e/0xe80
  [<0>] xfs_fs_fill_super+0x7f1/0xec0
  [<0>] get_tree_bdev_flags+0x186/0x280
  [<0>] get_tree_bdev+0x18/0x30
  [<0>] xfs_fs_get_tree+0x1d/0x30
  [<0>] vfs_get_tree+0x2d/0x110
  [<0>] path_mount+0xb59/0xfc0
  [<0>] do_mount+0x92/0xc0
  [<0>] __x64_sys_mount+0xc2/0x160
  [<0>] x64_sys_call+0x2de4/0x45c0
  [<0>] do_syscall_64+0xa7/0x240
  [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

During log recovery, while updating the in-memory superblock from the
primary SB buffer, if an error is encountered, such as superblock
corruption occurs or some other reasons, we will proceed to out_release
and release the xfs_buf. However, this is insufficient because the
xfs_buf's log item has already been initialized and the xfs_buf is held
by the buffer log item as follows, the xfs_buf will not be released,
causing the mount thread to hang.

  xlog_recover_do_primary_sb_buffer
    xlog_recover_do_reg_buffer
      xlog_recover_validate_buf_type
        xfs_buf_item_init(bp, mp)

The solution is straightforward: we simply need to allow it to be
handled by the normal buffer write process. The filesystem will be
shutdown before the submission of buffer_list in xlog_do_recovery_pass(),
ensuring the correct release of the xfs_buf.

Fixes: 6a18765b54e2 ("xfs: update the file system geometry after recoverying superblock buffers")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_buf_item_recover.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 3d0c6402cb36..ec2a42ef66ff 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1079,7 +1079,7 @@ xlog_recover_buf_commit_pass2(
 		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
 				current_lsn);
 		if (error)
-			goto out_release;
+			goto out_writebuf;
 
 		/* Update the rt superblock if we have one. */
 		if (xfs_has_rtsb(mp) && mp->m_rtsb_bp) {
@@ -1096,6 +1096,7 @@ xlog_recover_buf_commit_pass2(
 		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 	}
 
+out_writebuf:
 	/*
 	 * Perform delayed write on the buffer.  Asynchronous writes will be
 	 * slower when taking into account all the buffers to be flushed.
-- 
2.39.2

