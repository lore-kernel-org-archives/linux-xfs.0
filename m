Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 54F5429E82
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:06:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 44473304032
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:06:48 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id wMNf8P3vxMJizwvV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:06:46 -0700 (PDT)
Subject: [PATCH 14/51] libxfs: fix min freelist length calculation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:06:43 -0700
Message-ID: <20151007050643.1504.28716.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

If rmapbt is disabled, it is incorrect to require 1 extra AGFL block
for the rmapbt (due to the + 1); the entire clause needs to be gated
on the feature flag.

This causes serious problems if formatting a v4 filesystem because the
extra AGFL block causes the root inode not to be where xfs_repair
expects it.  In turn, xfs_repair reports major FS damage when
everything is fine.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 1a69bdc..40cb20a 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1964,8 +1964,10 @@ xfs_alloc_min_freelist(
 	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_CNTi] + 1,
 				       mp->m_ag_maxlevels);
 	/* space needed reverse mapping used space btree */
-	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
-				       mp->m_ag_maxlevels);
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		min_free += min_t(unsigned int,
+				  pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
+				  mp->m_ag_maxlevels);
 
 	return min_free;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
