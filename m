Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753638AbeDRNbV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Apr 2018 09:31:21 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 07D563182F27
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 13:31:21 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0B6069C80
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 13:31:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 4/6] xfs: defer agfl frees from inode inactivation
Date: Wed, 18 Apr 2018 09:31:17 -0400
Message-Id: <20180418133119.21775-5-bfoster@redhat.com>
In-Reply-To: <20180418133119.21775-1-bfoster@redhat.com>
References: <20180418133119.21775-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

XFS inode chunks are already freed via deferred operations (which
now also defer AGFL block frees), but inode btree blocks are freed
directly in the associated context. This has been known to lead to
log reservation overruns in particular workloads where an inobt
block free may require several AGFL block frees (and thus several
allocation btree modifications) before the inobt block itself is
actually freed.

To avoid this problem, defer the frees of any AGFL blocks before the
inobt block free takes place. This requires passing the dfops from
xfs_inactive_ifree() down through the inobt ->[alloc|free]_block()
callouts, which essentially only requires to attach the dfops to the
transaction since it is already carried all the way through to the
inobt update and allocation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2b70c8b4cee2..33e36bb019b6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1811,6 +1811,7 @@ xfs_inactive_ifree(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	xfs_defer_init(&dfops, &first_block);
+	tp->t_agfl_dfops = &dfops;
 	error = xfs_ifree(tp, ip, &dfops);
 	if (error) {
 		/*
-- 
2.13.6

