Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 471BE7CA2
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 19:49:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F3681304032
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 17:49:24 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UBSOHRVoihpJjSDY for <xfs@oss.sgi.com>;
	Thu, 21 Jul 2016 17:49:22 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1bQOeW-0005gA-G7
	for xfs@oss.sgi.com; Fri, 22 Jul 2016 10:49:20 +1000
Received: from dave by disappointment with local (Exim 4.87)
	(envelope-from <dave@disappointment.disaster>) id 1bQOeI-0004my-E8
	for xfs@oss.sgi.com; Fri, 22 Jul 2016 10:49:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: remove EXPERIMENTAL tag from sparse inode feature
Date: Fri, 22 Jul 2016 10:49:06 +1000
Message-Id: <1469148546-18369-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Been around for long enough now, hasn't caused any regression test
failures in the past 3 months, so it's time to make it a fully
supported feature.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_super.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 258b594..0303f10 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1573,10 +1573,6 @@ xfs_fs_fill_super(
 		}
 	}
 
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
-		xfs_alert(mp,
-	"EXPERIMENTAL sparse inode feature enabled. Use at your own risk!");
-
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
