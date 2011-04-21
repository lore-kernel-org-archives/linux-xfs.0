Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3L4Pbam132806 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 23:25:38 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CC441507392
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 21:29:04 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AFyTkDnDCALGdD34 for <xfs@oss.sgi.com>;
	Wed, 20 Apr 2011 21:29:04 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QClVk-00030u-M6
	for xfs@oss.sgi.com; Thu, 21 Apr 2011 14:29:00 +1000
Received: from dave by disappointment with local (Exim 4.75)
	(envelope-from <dave@disappointment.disaster>) id 1QClVt-0002mG-7P
	for xfs@oss.sgi.com; Thu, 21 Apr 2011 14:29:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: obey minleft values during extent allocation
	correctly.
Date: Thu, 21 Apr 2011 14:29:04 +1000
Message-Id: <1303360144-10632-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1303360144-10632-1-git-send-email-david@fromorbit.com>
References: <1303360144-10632-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When allocating an extent that is long enough to consume the
remaining free space in an AG, we need to ensure that the allocation
leaves enough space in the AG for any subsequent bmap btree blocks
that are needed to track the new extent. These have to be allocated
in the same AG as we only reserve enough blocks in an allocation
transaction for modification of the freespace trees in a single AG.

xfs_alloc_fix_minleft() has been considering blocks on the AGFL as
free blocks available for extent and bmbt block allocation, which is
not correct - blocks on the AGFL are there exclusively for the use
of the free space btrees. As a result, when minleft is less than the
number of blocks on the AGFL, xfs_alloc_fix_minleft() does not trim
the given extent to leave minleft blocks available for bmbt
allocation, and hence we can fail allocation during bmbt record
insertion.

A further problem is that bmbt block allocation doesn't set the
total number of blocks correctly for the allocation, thereby
allowing it to allocate a block from the AGFL before failing on the
second block in xfs_alloc_fix_freelist(). The total needs to be set
so that it skips AGs that only have the minimum reserved
amount of AGFL blocks free in them.

Similarly, xfs_inobt_alloc_block() needs to set args->total as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 27d64d7..8946464 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -280,7 +280,6 @@ xfs_alloc_fix_minleft(
 		return 1;
 	agf = XFS_BUF_TO_AGF(args->agbp);
 	diff = be32_to_cpu(agf->agf_freeblks)
-		+ be32_to_cpu(agf->agf_flcount)
 		- args->len - args->minleft;
 	if (diff >= 0)
 		return 1;
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
