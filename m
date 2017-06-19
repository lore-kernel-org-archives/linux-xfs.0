Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24171 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbdFSUXR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2017 16:23:17 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v5JKNGud013642
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2017 20:23:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v5JKNFEq022031
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2017 20:23:15 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v5JKNF91016496
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2017 20:23:15 GMT
Date: Mon, 19 Jun 2017 13:23:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: don't allow bmap/swap on rt files
Message-ID: <20170619202314.GB4733@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

bmap returns a dumb LBA address but not the block device that goes with
that LBA.  Swapfiles don't care about this and will blindly assume that
the data volume is the correct blockdev, which is totally bogus for
files on the rt subvolume.  This results in the swap code doing IOs to
arbitrary locations on the data device(!) if the passed in mapping is a
realtime file, so just turn off bmap for rt files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6bab8c4..716b5ee 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1316,9 +1316,12 @@ xfs_vm_bmap(
 	 * The swap code (ab-)uses ->bmap to get a block mapping and then
 	 * bypasseѕ the file system for actual I/O.  We really can't allow
 	 * that on reflinks inodes, so we have to skip out here.  And yes,
-	 * 0 is the magic code for a bmap error..
+	 * 0 is the magic code for a bmap error.
+	 *
+	 * Since we don't pass back blockdev info, we can't return bmap
+	 * information for rt files either.
 	 */
-	if (xfs_is_reflink_inode(ip))
+	if (xfs_is_reflink_inode(ip) || XFS_IS_REALTIME_INODE(ip))
 		return 0;
 
 	filemap_write_and_wait(mapping);
