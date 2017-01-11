Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1765297AbdAKRyS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 12:54:18 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2ED4261BA4
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 17:54:11 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v0BHsAXL014900
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 12:54:11 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 4/5] xfs: free cowblocks and retry on buffered write ENOSPC
Date: Wed, 11 Jan 2017 12:54:08 -0500
Message-Id: <1484157249-464-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1484157249-464-1-git-send-email-bfoster@redhat.com>
References: <1484157249-464-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

XFS runs an eofblocks reclaim scan before returning an ENOSPC error to
userspace for buffered writes. This facilitates aggressive speculative
preallocation without causing user visible side effects such as
premature ENOSPC.

Run a cowblocks scan in the same situation to reclaim lingering COW fork
preallocation throughout the filesystem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index bbb9eb6..ef7eaa6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -655,6 +655,7 @@ xfs_file_buffered_aio_write(
 		eofb.eof_scan_owner = ip->i_ino; /* for locking */
 		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
 		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
 		goto write_retry;
 	}
 
-- 
2.7.4

