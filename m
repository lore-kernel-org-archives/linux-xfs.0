Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 144F17F37
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 18:23:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B03E3AC00B
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 16:23:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AEETDdUCk5Hdlhzj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 Sep 2015 16:23:14 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 0A6B285545
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 23:23:14 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-55-243.rdu2.redhat.com
	[10.10.55.243])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8PNNBp2021662
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 19:23:13 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 2/7] xfs: create symlink proc/fs/xfs/stat to sys/fs/xfs/stats
Date: Fri, 25 Sep 2015 18:22:55 -0500
Message-Id: <1443223380-18870-3-git-send-email-billodo@redhat.com>
In-Reply-To: <1443223380-18870-1-git-send-email-billodo@redhat.com>
References: <1443223380-18870-1-git-send-email-billodo@redhat.com>
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
