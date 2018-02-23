Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752457AbeBWXtm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Feb 2018 18:49:42 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EED1285542
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 23:49:41 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C51AB5D757
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 23:49:41 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: do not log/recover swapext extent owner changes for
 deleted inodes
Message-ID: <f2dcef25-01f2-d7fe-3b2d-f54a809215a5@redhat.com>
Date: Fri, 23 Feb 2018 17:49:41 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Today if we run swapext and crash, log replay can fail because
the recovery code tries to instantiate the donor inode from
disk to replay the swapext, but it's been deleted and we throw
corruption failures if we try to get an inode off disk with
i_mode == 0.

This fixes both sides: We don't log the swapext change if the
inode has been deleted, and we don't try to recover it either.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 26f2413..de48eb8 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -436,6 +436,12 @@ xfs_inode_item_format(
 			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
 	}
 
+	/* If this inode has been deleted do not log swapext owner changes */
+	if (VFS_I(ip)->i_mode == 0) {
+		ilf->ilf_fields &= ~(XFS_ILOG_DOWNER | XFS_ILOG_AOWNER);
+		iip->ili_fields &= ~(XFS_ILOG_DOWNER | XFS_ILOG_AOWNER);
+	}
+
 	/* update the format with the exact fields we actually logged */
 	ilf->ilf_fields |= (iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
 }
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5e219d9..d0e33b9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3199,7 +3199,9 @@ xlog_recover_inode_pass2(
 	}
 
 out_owner_change:
-	if (in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER))
+	/* Recover the swapext owner change unless inode has been deleted */
+	if ((in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER)) &&
+	    (dip->di_mode != 0))
 		error = xfs_recover_inode_owner_change(mp, dip, in_f,
 						       buffer_list);
 	/* re-generate the checksum. */

