Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44311
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727264AbeLWJeB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Dec 2018 04:34:01 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 09/20] xfs: xfs_fsops: drop useless LIST_HEAD
Date: Sun, 23 Dec 2018 09:57:04 +0100
Message-Id: <1545555435-24576-10-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: kernel-janitors@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

Drop LIST_HEAD where the variable it declares is never used.

Commit 0410c3bb2b88 ("xfs: factor ag btree root block
initialisation") stopped using buffer_list and started using a
buffer list in an aghdr_init_data structure, but the declaration
of buffer_list was not removed.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
@@
- LIST_HEAD(x);
  ... when != x
// </smpl>

Fixes: 0410c3bb2b88 ("xfs: factor ag btree root block initialisation")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Successfully 0-day tested on 151 configurations.

 fs/xfs/xfs_fsops.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ec2e63a7963b..f3ef70c542e1 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -40,7 +40,6 @@ xfs_growfs_data_private(
 	xfs_rfsblock_t		new;
 	xfs_agnumber_t		oagcount;
 	xfs_trans_t		*tp;
-	LIST_HEAD		(buffer_list);
 	struct aghdr_init_data	id = {};
 
 	nb = in->newblocks;
