Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 998487CBB
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 23:09:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01F00AC001
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 21:09:39 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id R1r8PW53fkl0iofR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 21:09:35 -0800 (PST)
Date: Tue, 1 Mar 2016 21:09:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix computation of inode btree maxlevels
Message-ID: <20160302050930.GD27973@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Commit 88740da18[1] introduced a function to compute the maximum
height of the inode btree back in 1994.  Back then, apparently, the
freespace and inode btrees shared the same geometry; however, it has
long since been the case that the inode and freespace btrees have
different record and key sizes.  Therefore, we must use m_inobt_mnr if
we want a correct calculation/log reservation/etc.

(Yes, this bug has been around for 21 years and ten months.)

(Yes, I was in middle school when this bug was committed. 8-) )

[1] http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=88740da18ddd9d7ba3ebaa9502fefc6ef2fd19cd

Historical-research-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |    4 ++--
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
