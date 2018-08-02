Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732348AbeHBTzL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Aug 2018 15:55:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w72HscEG042238
        for <linux-xfs@vger.kernel.org>; Thu, 2 Aug 2018 18:02:58 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2km6j3g2gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 02 Aug 2018 18:02:58 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w72I2vWc011178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 2 Aug 2018 18:02:57 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w72I2vEc028608
        for <linux-xfs@vger.kernel.org>; Thu, 2 Aug 2018 18:02:57 GMT
Date: Thu, 2 Aug 2018 11:02:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: avoid overflows in i_delayed_blks due to numerous cow
 reservations
Message-ID: <20180802180256.GR30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Prior to the arrival of copy on write, i_delayed_blks tracked the number
of blocks that had been reserved for delayed allocations.  Though the
counter was 32-bits in size, this was enough because writeback would
generally start flushing files well before we hit 2^32 blocks of dirty
data.

However, now that we're using it to track CoW reservations as well, it's
possible to create so many of those reservations that we overflow the
counter.  This is kind of an extreme case (it requires ~16T of COW
reservations) but we ought to avoid this trivial overflow.  A userspace
visible effect is that stat i_blocks returns incorrect values.

Change the field to xfs_filblks_t, which should suffice to fix the
problem.  There already was a 4-byte hole in struct xfs_inode, so we get
this for free.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 59b06133ceb8..3fd0e07a363e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -48,7 +48,7 @@ typedef struct xfs_inode {
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
 	/* Miscellaneous state. */
 	unsigned long		i_flags;	/* see defined flags below */
-	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
+	xfs_filblks_t		i_delayed_blks;	/* count of delay alloc blks */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
