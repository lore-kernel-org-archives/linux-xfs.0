Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58726 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbeG3H3B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 03:29:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6U5rrjs012226
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 05:55:41 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2kgfwstxsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 05:55:41 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6U5tfiK029584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 05:55:41 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6U5tepj006421
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 05:55:41 GMT
Date: Sun, 29 Jul 2018 22:55:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] xfs: fix cow_seq locking behavior
Message-ID: <20180730055539.GT30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In Christoph Hellwig's patch "xfs: avoid COW fork extent lookups in
writeback if the fork didn't change" (which has not yet graduated to
for-next), we sample the COW fork sequence number without taking the
ilock.  This is a little strange, since in general we always take it
before accessing anything in a block mapping.  I think we get lucky in
that the unlocking during actual cow fork changes will erect the
necessary memory barriers (on x86 anyway) but let's not play fast and
loose with breaking everyone else's model of how locking works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index aff9d44fa338..2e178ef89a15 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -338,16 +338,21 @@ xfs_map_blocks(
 	 * COW one, or the COW fork hasn't changed from the last time we looked
 	 * at it.
 	 */
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	imap_valid = offset_fsb >= wpc->imap.br_startoff &&
 		     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount;
 	if (imap_valid &&
 	    (!xfs_inode_has_cow_data(ip) ||
 	     wpc->io_type == XFS_IO_COW ||
-	     wpc->cow_seq == ip->i_cowfp->if_seq))
+	     wpc->cow_seq == ip->i_cowfp->if_seq)) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		return 0;
+	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		return -EIO;
+	}
 
 	/*
 	 * If we don't have a valid map, now it's time to get a new one for this
@@ -355,7 +360,6 @@ xfs_map_blocks(
 	 * into real extents.  If we return without a valid map, it means we
 	 * landed in a hole and we skip the block.
 	 */
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
 	ASSERT(offset <= mp->m_super->s_maxbytes);
