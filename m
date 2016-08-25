Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A11CC800F
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:44:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7433F8F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:44:17 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id S73msUDKHEYniwI6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:44:15 -0700 (PDT)
Subject: [PATCH 07/20] xfs: realtime rmap btree transaction reservations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:44:11 -0700
Message-ID: <147216865128.3688.1537361834919049399.stgit@birch.djwong.org>
In-Reply-To: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
References: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
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
 fs/xfs/libxfs/xfs_trans_resv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index b456cca..f9771b7 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -83,7 +83,8 @@ xfs_allocfree_log_count(
 
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
