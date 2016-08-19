Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9529D7CA2
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 15:32:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 598A5304048
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 13:32:15 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id UgnHVMphLJRkPMTH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Aug 2016 13:32:13 -0700 (PDT)
Date: Fri, 19 Aug 2016 13:32:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: disallow mounting of realtime + rmap filesystems
Message-ID: <20160819203207.GE8268@birch.djwong.org>
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
