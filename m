Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbeJRGSl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Oct 2018 02:18:41 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B22E3307D982
        for <linux-xfs@vger.kernel.org>; Wed, 17 Oct 2018 22:20:57 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: reject per-inode dax flag on reflink filesystems
Message-ID: <c1ad993d-5330-88c3-b859-06e33dcd75d8@redhat.com>
Date: Wed, 17 Oct 2018 17:20:56 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>

Today we reject this flag on an already-reflinked inode, but we really
need to reject it for any inode on a reflink-capable filesystem until
reflink+dax is supported.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(um, do we need to catch this when reading from disk as well?  If we
found a dax-flagged inode on a reflinked fs, then what would we do with it?)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0ef5ece5634c..63d579c652f2 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1031,8 +1031,9 @@ xfs_ioctl_setattr_xflags(
 	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
 		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
 
-	/* Don't allow us to set DAX mode for a reflinked file for now. */
-	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))
+	/* Don't allow us to set DAX mode on a reflink filesystem for now. */
+	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
+	    xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
 		return -EINVAL;
 
 	/*
