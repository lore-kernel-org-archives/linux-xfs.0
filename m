Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38560 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbfEPUlA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 May 2019 16:41:00 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 311493086204
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 20:41:00 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DC6BB5C882
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 20:40:59 +0000 (UTC)
Subject: [PATCH 7/3] libxfs: fix argument to xfs_trans_add_item
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <1bd8bba2-b884-02f6-8e49-eb2374481888@redhat.com>
Date: Thu, 16 May 2019 15:40:57 -0500
MIME-Version: 1.0
In-Reply-To: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The hack of casting an inode_log_item or buf_log_item to a
xfs_log_item_t is pretty gross; yes it's the first member in the
structure, but yuk.  Pass in the correct structure member.

This was fixed in the kernel with commit e98c414f9
("xfs: simplify log item descriptor tracking")

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/trans.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/trans.c b/libxfs/trans.c
index f78222fd..6ef4841f 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -346,7 +346,7 @@ xfs_trans_ijoin(
 	ASSERT(iip->ili_lock_flags == 0);
 	iip->ili_lock_flags = lock_flags;
 
-	xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
+	xfs_trans_add_item(tp, &iip->ili_item);
 }
 
 void
@@ -570,7 +570,7 @@ _xfs_trans_bjoin(
 	 * Attach the item to the transaction so we can find it in
 	 * xfs_trans_get_buf() and friends.
 	 */
-	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
+	xfs_trans_add_item(tp, &bip->bli_item);
 	bp->b_transp = tp;
 
 }
-- 
2.17.0
