Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:36221 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934171AbcJQKQo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 06:16:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] xfs: Fix uninitialized variable in xfs_reflink_reserve_cow_range()
Date: Mon, 17 Oct 2016 12:16:44 +0200
Message-Id: <1476699404-5977-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

with gcc 4.1.2:

    fs/xfs/xfs_reflink.c: In function ‘xfs_reflink_reserve_cow_range’:
    fs/xfs/xfs_reflink.c:327: warning: ‘error’ may be used uninitialized in this function

Indeed, if "count" is zero, the function will return an uninitialized
error value.

While "count" is unlikely to be zero, this function is called through
the public iomap API. Hence fix this by preinitializing error to zero.

Fixes: 2a06705cd5954030 ("xfs: create delalloc extents in CoW fork")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/xfs/xfs_reflink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 5965e9455d91e036..d48a7cc2fe007f66 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -324,7 +324,7 @@
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb, end_fsb;
 	bool			skipped = false;
-	int			error;
+	int			error = 0;
 
 	trace_xfs_reflink_reserve_cow_range(ip, offset, count);
 
-- 
1.9.1

