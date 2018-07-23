Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388105AbeGWOFX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 10:05:23 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9AD9E4059FF8
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:14 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84948111AF23
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:14 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 03/15] xfs: fix transaction leak on remote attr set/remove failure
Date: Mon, 23 Jul 2018 09:04:02 -0400
Message-Id: <20180723130414.47980-4-bfoster@redhat.com>
In-Reply-To: <20180723130414.47980-1-bfoster@redhat.com>
References: <20180723130414.47980-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The xattr remote value set/remove handlers both clear args.trans in
the error path without having cancelled the transaction. This leaks
the transaction, causes warnings around returning to userspace with
locks held and leads to system lockups or other general problems.

The higher level xfs_attr_[set|remove]() functions already detect
and cancel args.trans when set in the error path. Drop the NULL
assignments from the rmtval handlers and allow the callers to clean
up the transaction correctly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 7841e6255129..829ab20f0cd7 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -558,7 +558,6 @@ xfs_attr_rmtval_set(
 	return 0;
 out_defer_cancel:
 	xfs_defer_cancel(args->trans->t_dfops);
-	args->trans = NULL;
 	return error;
 }
 
@@ -646,6 +645,5 @@ xfs_attr_rmtval_remove(
 	return 0;
 out_defer_cancel:
 	xfs_defer_cancel(args->trans->t_dfops);
-	args->trans = NULL;
 	return error;
 }
-- 
2.17.1

