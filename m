Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932266AbdAFThN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Jan 2017 14:37:13 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CDD36C04B941
        for <linux-xfs@vger.kernel.org>; Fri,  6 Jan 2017 19:37:13 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v06JbD26003727
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jan 2017 14:37:13 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: remove racy hasattr check from attr get
Date: Fri,  6 Jan 2017 14:37:12 -0500
Message-Id: <1483731432-55042-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_attr_get() has an unlocked attribute fork check to optimize away a
lock cycle in cases where the fork does not exist or is otherwise empty.
This check is not safe, however, because an attribute fork short form to
extent format conversion includes a transient state that causes the
xfs_inode_hasattr() check to fail. Specifically,
xfs_attr_shortform_to_leaf() creates an empty extent format attribute
fork and then adds the existing shortform attributes to it.

This means that lookup of an existing xattr can spuriously return
-ENOATTR when racing against a setxattr that causes the associated
format conversion. This was originally reproduced by an untar on a
particularly configured glusterfs volume, but can also be reproduced on
demand with properly crafted xattr requests.

The format conversion occurs under the exclusive ilock. xfs_attr_get()
already has the proper locking and checks further down in the function
to handle this situation correctly. Drop the unlocked check to avoid the
spurious failure and rely on the existing logic.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This survives a local xfstests run and the original glusterfs
reproducer. I also have an xfstests reproducer that I will post shortly.

Brian

 fs/xfs/libxfs/xfs_attr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index af1ecb1..8fcbc52 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -131,9 +131,6 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	if (!xfs_inode_hasattr(ip))
-		return -ENOATTR;
-
 	error = xfs_attr_args_init(&args, ip, name, flags);
 	if (error)
 		return error;
-- 
2.7.4

