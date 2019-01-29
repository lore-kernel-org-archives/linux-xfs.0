Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbfA2Sdx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Jan 2019 13:33:53 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 29F36369BC
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 18:33:53 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDA8D5D717
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 18:33:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5/5] xfs: fix typo in xfs_inode_buf_ra_ops verifier name
Date: Tue, 29 Jan 2019 13:33:50 -0500
Message-Id: <20190129183350.27302-6-bfoster@redhat.com>
In-Reply-To: <20190129183350.27302-1-bfoster@redhat.com>
References: <20190129183350.27302-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Fix a typo in the struct xfs_inode_buf_ra_ops verifier name.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 09d9c8cfa4a0..fd2df5747a3a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -152,7 +152,7 @@ const struct xfs_buf_ops xfs_inode_buf_ops = {
 };
 
 const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
-	.name = "xxfs_inode_ra",
+	.name = "xfs_inode_ra",
 	.verify_read = xfs_inode_buf_readahead_verify,
 	.verify_write = xfs_inode_buf_write_verify,
 };
-- 
2.17.2
