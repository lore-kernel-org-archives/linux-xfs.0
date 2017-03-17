Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750999AbdCQP4y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Mar 2017 11:56:54 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F3D949D40A
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2017 15:47:39 +0000 (UTC)
Received: from Liberator.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C8CD3BFA63
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2017 15:47:39 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH (TRIVIAL)] xfs: fix up inode validation failure message
Message-ID: <59d16175-1c24-4bc2-5cd9-ac7a062e5ae3@redhat.com>
Date: Fri, 17 Mar 2017 08:47:38 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

"xfs_iread: validation failed for inode 96 failed"

One "failed" seems like enough.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Yo dawg, I heard you like failed so I put failed in your
failed so you can fail while you fail.

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d93f9d9..09c3d1a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -508,7 +508,7 @@
 
 	/* even unallocated inodes are verified */
 	if (!xfs_dinode_verify(mp, ip->i_ino, dip)) {
-		xfs_alert(mp, "%s: validation failed for inode %lld failed",
+		xfs_alert(mp, "%s: validation failed for inode %lld",
 				__func__, ip->i_ino);
 
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, dip);

