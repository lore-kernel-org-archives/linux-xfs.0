Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 249EA7F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 03:56:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DAABF304077
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 01:56:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TGhmbmH5pqZ8fEsP for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 01:56:24 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wk8VV-0000JY-Ua
	for xfs@oss.sgi.com; Tue, 13 May 2014 18:56:18 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wk8VV-0001kh-Ts
	for xfs@oss.sgi.com; Tue, 13 May 2014 18:56:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/9] xfs: xfs_commit_metadata returns wrong errno
Date: Tue, 13 May 2014 18:56:07 +1000
Message-Id: <1399971373-6242-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1399971373-6242-1-git-send-email-david@fromorbit.com>
References: <1399971373-6242-1-git-send-email-david@fromorbit.com>
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

Invert it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_export.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 1399e18..753e467 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -237,7 +237,7 @@ xfs_fs_nfs_commit_metadata(
 
 	if (!lsn)
 		return 0;
-	return _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
+	return -_xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
 }
 
 const struct export_operations xfs_export_operations = {
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
