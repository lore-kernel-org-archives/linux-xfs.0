Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44319
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727260AbeLWJeA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Dec 2018 04:34:00 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 08/20] xfs: xfs_buf: drop useless LIST_HEAD
Date: Sun, 23 Dec 2018 09:57:03 +0100
Message-Id: <1545555435-24576-9-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: kernel-janitors@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

Drop LIST_HEAD where the variable it declares has never
been used.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
@@
- LIST_HEAD(x);
  ... when != x
// </smpl>

Fixes: 26f1fe858f274 ("xfs: reduce lock hold times in buffer writeback")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Successfully 0-day tested on 151 configurations.

 fs/xfs/xfs_buf.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b21ea2ba768d..eedc5e0156ff 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1992,7 +1992,6 @@ xfs_buf_delwri_submit_buffers(
 	struct list_head	*wait_list)
 {
 	struct xfs_buf		*bp, *n;
-	LIST_HEAD		(submit_list);
 	int			pinned = 0;
 	struct blk_plug		plug;
 
