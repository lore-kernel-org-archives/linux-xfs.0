Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46997 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbdBACfU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2017 21:35:20 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v112YuYl007032
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 1 Feb 2017 02:34:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v112Yt1k013875
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 1 Feb 2017 02:34:55 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v112Ytt9023890
        for <linux-xfs@vger.kernel.org>; Wed, 1 Feb 2017 02:34:55 GMT
Date: Tue, 31 Jan 2017 18:34:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 1/7] xfs: fix toctou race when locking an inode to access
 the data map
Message-ID: <20170201023454.GK9134@birch.djwong.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582219035.12293.12084220786527965512.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148582219035.12293.12084220786527965512.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We use di_format and if_flags to decide whether we're grabbing the ilock
in btree mode (btree extents not loaded) or shared mode (anything else),
but the state of those fields can be changed by other threads that are
also trying to load the btree extents -- IFEXTENTS gets set before the
_bmap_read_extents call and cleared if it fails.

We don't actually need to have IFEXTENTS set until after the bmbt
records are successfully loaded and validated, which will fix the race
between multiple threads trying to read the same directory.  The next
patch strengthens directory bmbt validation by refusing to open the
directory if reading the bmbt to start directory readahead fails.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 222e103..421341f 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -497,15 +497,14 @@ xfs_iread_extents(
 	 * We know that the size is valid (it's checked in iformat_btree)
 	 */
 	ifp->if_bytes = ifp->if_real_bytes = 0;
-	ifp->if_flags |= XFS_IFEXTENTS;
 	xfs_iext_add(ifp, 0, nextents);
 	error = xfs_bmap_read_extents(tp, ip, whichfork);
 	if (error) {
 		xfs_iext_destroy(ifp);
-		ifp->if_flags &= ~XFS_IFEXTENTS;
 		return error;
 	}
 	xfs_validate_extents(ifp, nextents, XFS_EXTFMT_INODE(ip));
+	ifp->if_flags |= XFS_IFEXTENTS;
 	return 0;
 }
 /*
