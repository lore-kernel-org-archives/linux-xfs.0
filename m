Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29929 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752210AbdEVPsP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 11:48:15 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 77D23624AB
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2017 15:48:15 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F5E35DD6A
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2017 15:48:15 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: fix unaligned access in xfs_btree_visit_blocks
Message-ID: <105ed603-971a-e7db-6040-b85e5eecd928@redhat.com>
Date: Mon, 22 May 2017 10:48:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This was throwing unaligned access warnings on sparc64:

Kernel unaligned access at TPC[1043c088] xfs_btree_visit_blocks+0x88/0xe0 [xfs]

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5392674..84089f8 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4395,7 +4395,7 @@ struct xfs_btree_split_args {
 			xfs_btree_readahead_ptr(cur, ptr, 1);
 
 			/* save for the next iteration of the loop */
-			lptr = *ptr;
+			lptr = get_unaligned(ptr);
 		}
 
 		/* for each buffer in the level */
