Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F4B481BA
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:36:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 633E48F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:36:55 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id uImDyEgrKaLK1vQc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:36:54 -0700 (PDT)
Subject: [PATCH 057/145] xfs_repair: fix fino_bno calculation when rmapbt is
	enabled
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:36:44 -0700
Message-ID: <146612740486.16048.16298066777909039562.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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

In xfs_repair, we calculate where we think mkfs put the root inode
block.  However, the rmapbt component doesn't account for the fact
that mkfs reserved 2 AGFL blocks for the rmapbt, so its calculation
is off by a bit.  This leads to it complaining (incorrectly) about the
root inode block being in the wrong place and blowing up.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/xfs_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 709c0c3..3b63754 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -417,8 +417,10 @@ calc_mkfs(xfs_mount_t *mp)
 	fino_bno = inobt_root + (2 * min(2, mp->m_ag_maxlevels)) + 1;
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
 		fino_bno++;
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		fino_bno += min(2, mp->m_rmap_maxlevels);
 		fino_bno++;
+	}
 
 	/*
 	 * If the log is allocated in the first allocation group we need to

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
