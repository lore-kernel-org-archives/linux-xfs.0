Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43918 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754172AbcK1TJo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Nov 2016 14:09:44 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2DEE13D959
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 19:09:44 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uASJ9hvn006330
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 14:09:44 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5/6] xfs: free cowblocks and retry on buffered write ENOSPC
Date: Mon, 28 Nov 2016 14:09:40 -0500
Message-Id: <1480360181-20396-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
References: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
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
index d818c16..7fd97c3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -716,6 +716,7 @@ xfs_file_buffered_aio_write(
 		eofb.eof_scan_owner = ip->i_ino; /* for locking */
 		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
 		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
 		goto write_retry;
 	}
 
-- 
2.7.4

