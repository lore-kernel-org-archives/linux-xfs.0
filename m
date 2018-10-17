Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out04.smtpout.orange.fr ([193.252.22.213]:45698 "EHLO
        out.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbeJQOXU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 10:23:20 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] xfs: Fix error code in 'xfs_ioc_getbmap()'
Date: Wed, 17 Oct 2018 08:21:38 +0200
Message-Id: <20181017062138.1721-1-christophe.jaillet@wanadoo.fr>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>

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
2.17.1
