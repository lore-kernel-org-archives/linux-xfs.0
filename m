Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 016657CA1
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 21:21:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BA6D68F8033
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:21:11 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id QG3aJAFBg6eOJyLV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:21:10 -0700 (PDT)
Subject: [PATCH 5/5] xfs: disallow mounting of realtime + rmap filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Aug 2016 19:20:59 -0700
Message-ID: <147200525982.14738.18075322042697360316.stgit@birch.djwong.org>
In-Reply-To: <147200522764.14738.15186015137934319456.stgit@birch.djwong.org>
References: <147200522764.14738.15186015137934319456.stgit@birch.djwong.org>
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

Since the kernel doesn't currently support the realtime rmapbt,
don't allow such filesystems to be mounted.  Support will appear
in a future release.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 24ef83e..fd6be45 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1574,9 +1574,16 @@ xfs_fs_fill_super(
 		}
 	}
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		if (mp->m_sb.sb_rblocks) {
+			xfs_alert(mp,
+	"EXPERIMENTAL reverse mapping btree not compatible with realtime device!");
+			error = -EINVAL;
+			goto out_filestream_unmount;
+		}
 		xfs_alert(mp,
 	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
+	}
 
 	error = xfs_mountfs(mp);
 	if (error)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
