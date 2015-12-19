Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DC01729E08
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:07:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7B25CAC006
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:58 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id YddBwqDfmcrKhygf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:57 -0800 (PST)
Subject: [PATCH 27/53] xfs_repair: fix fino_bno calculation when rmapbt is
	enabled
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:07:49 -0800
Message-ID: <20151219090749.14255.87703.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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
index 2fe2e4e..3710636 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -416,8 +416,10 @@ calc_mkfs(xfs_mount_t *mp)
 	fino_bno = inobt_root + (2 * min(2, mp->m_ag_maxlevels)) + 1;
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
 		fino_bno++;
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		fino_bno += min(2, mp->m_ag_maxlevels);
 		fino_bno++;
+	}
 
 	/*
 	 * If the log is allocated in the first allocation group we need to

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
