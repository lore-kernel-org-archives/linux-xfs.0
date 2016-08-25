Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 118318059
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:45:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA44F304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:45:13 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Tbd3UBTRmDU5m4bv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:45:12 -0700 (PDT)
Subject: [PATCH 16/20] xfs: enable realtime rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:45:07 -0700
Message-ID: <147216870765.3688.6549904751705048479.stgit@birch.djwong.org>
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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2d249a5..34f6b94 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1601,16 +1601,9 @@ xfs_fs_fill_super(
 		"DAX and reflink have not been tested together!");
 	}
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-		if (mp->m_sb.sb_rblocks) {
-			xfs_alert(mp,
-	"EXPERIMENTAL reverse mapping btree not compatible with realtime device!");
-			error = -EINVAL;
-			goto out_filestream_unmount;
-		}
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		xfs_alert(mp,
 	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
-	}
 
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
 		xfs_alert(mp,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
