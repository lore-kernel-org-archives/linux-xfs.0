Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44500 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728373AbfDQBl7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 21:41:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1cum8080079
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:41:58 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2rvwk3r2cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:41:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1c9Ci048819
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:39:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2rv2tv31xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:39:57 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3H1duXN022001
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:39:56 GMT
Subject: [PATCH 2/2] xfs: widen inode delalloc block counter to 64-bits
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 16 Apr 2019 18:39:54 -0700
Message-ID: <155546519490.176148.10439883748477358842.stgit@magnolia>
In-Reply-To: <155546518260.176148.16583864799178682873.stgit@magnolia>
References: <155546518260.176148.16583864799178682873.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Widen the incore inode's i_delayed_blks counter to be a 64-bit integer.
This is necessary to fix an integer overflow problem that can be
reproduced easily now that we use the counter to track blocks that are
assigned to the inode in memory but not on disk.  This includes actual
delalloc reservations as well as real extents in the COW fork that
are waiting to be remapped into the data fork.

These 'delayed mapping' blocks can easily exceed 2^32 blocks if one
creates a very large sparse file of size approximately 2^33 bytes with
one byte written every 2^23 bytes, sets a very large COW extent size
hint of 2^23 blocks, reflinks the first file into a second file, and
then writes a single byte every 2^23 blocks in the original file.

When this happens, we'll try to create approximately 1024 2^23 extent
reservations in the COW fork, which will overflow the counter and cause
problems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.h |    2 +-
 fs/xfs/xfs_qm.c    |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 87e701b638ae..558173f95a03 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -56,7 +56,7 @@ typedef struct xfs_inode {
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
 	/* Miscellaneous state. */
 	unsigned long		i_flags;	/* see defined flags below */
-	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
+	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 52ed7904df10..aa6b6db3db0e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1812,7 +1812,8 @@ xfs_qm_vop_chown_reserve(
 	uint			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	uint			delblks, blkflags, prjflags = 0;
+	uint64_t		delblks;
+	unsigned int		blkflags, prjflags = 0;
 	struct xfs_dquot	*udq_unres = NULL;
 	struct xfs_dquot	*gdq_unres = NULL;
 	struct xfs_dquot	*pdq_unres = NULL;
