Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C0007F55
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 07:08:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 809E2304048
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 05:08:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FNKlBlHSQCh1i1mG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2015 05:08:03 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 837B3C0B2B57
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 12:08:03 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-53-129.rdu2.redhat.com
	[10.10.53.129])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8MC81nh022782
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 08:08:03 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 2/5] xfs: create symlink proc/fs/xfs/stat to sys/fs/xfs/stats
Date: Tue, 22 Sep 2015 07:07:48 -0500
Message-Id: <1442923671-14125-3-git-send-email-billodo@redhat.com>
In-Reply-To: <1442923671-14125-1-git-send-email-billodo@redhat.com>
References: <1442923671-14125-1-git-send-email-billodo@redhat.com>
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

As a part of the work to move xfs global stats from procfs to sysfs,
this patch creates the symlink from proc/fs/xfs/stat to sys/fs/xfs/stats.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 fs/xfs/xfs_stats.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 6008e25..a9f05de 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -244,9 +244,10 @@ xfs_init_procfs(void)
 	if (!proc_mkdir("fs/xfs", NULL))
 		goto out;
 
-	if (!proc_create("fs/xfs/stat", 0, NULL,
-			 &xfs_stat_proc_fops))
+	if (!proc_symlink("fs/xfs/stat", NULL,
+			  "/sys/fs/xfs/stats/stats"))
 		goto out_remove_xfs_dir;
+
 #ifdef CONFIG_XFS_QUOTA
 	if (!proc_create("fs/xfs/xqmstat", 0, NULL,
 			 &xqmstat_proc_fops))
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
