Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbfBDQyf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 11:54:35 -0500
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 03/10] xfs: Fix error code in 'xfs_ioc_getbmap()'
Date: Mon,  4 Feb 2019 08:54:20 -0800
Message-Id: <20190204165427.23607-4-mcgrof@kernel.org>
In-Reply-To: <20190204165427.23607-1-mcgrof@kernel.org>
References: <20190204165427.23607-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, "Darrick J . Wong" <darrick.wong@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 132bf6723749f7219c399831eeb286dbbb985429 upstream.

In this function, once 'buf' has been allocated, we unconditionally
return 0.
However, 'error' is set to some error codes in several error handling
paths.
Before commit 232b51948b99 ("xfs: simplify the xfs_getbmap interface")
this was not an issue because all error paths were returning directly,
but now that some cleanup at the end may be needed, we must propagate the
error code.

Fixes: 232b51948b99 ("xfs: simplify the xfs_getbmap interface")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0ef5ece5634c..bad90479ade2 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1616,7 +1616,7 @@ xfs_ioc_getbmap(
 	error = 0;
 out_free_buf:
 	kmem_free(buf);
-	return 0;
+	return error;
 }
 
 struct getfsmap_info {
-- 
2.18.0
