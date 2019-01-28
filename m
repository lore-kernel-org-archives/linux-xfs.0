Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50222 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbfA1Ozt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Jan 2019 09:55:49 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 544A5356F6
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jan 2019 14:55:49 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 070E9600D7
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jan 2019 14:55:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: end sync buffer I/O properly on shutdown error
Date: Mon, 28 Jan 2019 09:55:48 -0500
Message-Id: <20190128145548.20726-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

As of commit e339dd8d8b ("xfs: use sync buffer I/O for sync delwri
queue submission"), the delwri submission code uses sync buffer I/O
for sync delwri I/O. Instead of waiting on async I/O to unlock the
buffer, it uses the underlying sync I/O completion mechanism.

If delwri buffer submission fails due to a shutdown scenario, an
error is set on the buffer and buffer completion never occurs. This
can cause xfs_buf_delwri_submit() to deadlock waiting on a
completion event.

We could check the error state before waiting on such buffers, but
that doesn't serialize against the case of an error set via a racing
I/O completion. Instead, invoke I/O completion in the shutdown case
regardless of buffer I/O type.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index eedc5e0156ff..1f9857e3630a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1536,8 +1536,7 @@ __xfs_buf_submit(
 		xfs_buf_ioerror(bp, -EIO);
 		bp->b_flags &= ~XBF_DONE;
 		xfs_buf_stale(bp);
-		if (bp->b_flags & XBF_ASYNC)
-			xfs_buf_ioend(bp);
+		xfs_buf_ioend(bp);
 		return -EIO;
 	}
 
-- 
2.17.2
