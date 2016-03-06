Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 428407F63
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 15:50:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 07D04304043
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 13:50:13 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	cvEwvG9oK9THMZKQ for <xfs@oss.sgi.com>;
	Sun, 06 Mar 2016 13:50:11 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1acgYt-0000Y7-Lh
	for xfs@oss.sgi.com; Mon, 07 Mar 2016 08:50:03 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1acgYh-0004o9-U7
	for xfs@oss.sgi.com; Mon, 07 Mar 2016 08:49:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfs: fix computation of inode btree maxlevels
Date: Mon,  7 Mar 2016 08:49:47 +1100
Message-Id: <1457300990-18300-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1457300990-18300-1-git-send-email-david@fromorbit.com>
References: <1457300990-18300-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Commit 88740da18[1] introduced a function to compute the maximum
height of the inode btree back in 1994.  Back then, apparently, the
freespace and inode btrees shared the same geometry; however, it has
long since been the case that the inode and freespace btrees have
different record and key sizes.  Therefore, we must use m_inobt_mnr if
we want a correct calculation/log reservation/etc.

(Yes, this bug has been around for 21 years and ten months.)

(Yes, I was in middle school when this bug was committed.)

[1] http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=88740da18ddd9d7ba3ebaa9502fefc6ef2fd19cd

Historical-research-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 66d702e..22297f9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2403,8 +2403,8 @@ xfs_ialloc_compute_maxlevels(
 
 	maxleafents = (1LL << XFS_INO_AGINO_BITS(mp)) >>
 		XFS_INODES_PER_CHUNK_LOG;
-	minleafrecs = mp->m_alloc_mnr[0];
-	minnoderecs = mp->m_alloc_mnr[1];
+	minleafrecs = mp->m_inobt_mnr[0];
+	minnoderecs = mp->m_inobt_mnr[1];
 	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
 	for (level = 1; maxblocks > 1; level++)
 		maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
