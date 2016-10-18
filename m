Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34817 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753616AbcJRBK4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 21:10:56 -0400
Date: Mon, 17 Oct 2016 18:10:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: unset MS_ACTIVE if mount fails
Message-ID: <20161018011051.GB20337@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org

As part of the inode block map intent log item recovery process, we had
to set the IRECOVERY flag to prevent an unlinked inode from being
truncated during the first iput call.  This required us to set MS_ACTIVE
so that iput puts the inode on the lru instead of immediately evicting
the inode.

Unfortunately, if the mount fails later on, the inodes that have been
loaded (root dir and realtime) actually need to be evicted since we're
aborting the mount.  If we don't clear MS_ACTIVE in the failure step,
those inodes are not evicted and therefore leak.   The leak was found
by running xfs/130 and rmmoding xfs immediately after the test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fc78739..b341f10 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1009,6 +1009,7 @@ xfs_mountfs(
  out_quota:
 	xfs_qm_unmount_quotas(mp);
  out_rtunmount:
+	mp->m_super->s_flags &= ~MS_ACTIVE;
 	xfs_rtunmount_inodes(mp);
  out_rele_rip:
 	IRELE(rip);
