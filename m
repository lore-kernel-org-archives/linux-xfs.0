Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 41F0083F7
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:59:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA35EAC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:25 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id VN5xiz09RcN9Yc1c (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:24 -0700 (PDT)
Subject: [PATCH 07/29] xfs: realtime rmap btree transaction reservations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:59:20 -0700
Message-ID: <147216956023.7022.15229255210665379699.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Make sure that there's enough log reservation to handle mapping
and unmapping realtime extents.  We have to reserve enough space
to handle a split in the rtrmapbt to add the record and a second
split in the regular rmapbt to record the rtrmapbt split.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_trans_resv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 5152a5b..7947d8e 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -82,7 +82,8 @@ xfs_allocfree_log_count(
 
 	blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
+		blocks += max(num_ops * (2 * mp->m_rmap_maxlevels - 1),
+			      num_ops * (2 * mp->m_rtrmap_maxlevels - 1));
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
 		blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
