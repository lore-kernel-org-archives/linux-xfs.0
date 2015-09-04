Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 39BC47FB7
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 15:54:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 268B5304051
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 13:54:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Cv8rjlSmSdMIT9iJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Sep 2015 13:54:23 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 172D791C18
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 20:54:23 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-56-195.rdu2.redhat.com
	[10.10.56.195])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t84KsLOA004979
	for <xfs@oss.sgi.com>; Fri, 4 Sep 2015 16:54:22 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 2/3] xfs: create symlink proc/fs/xfs/stat to sys/fs/xfs/stats
Date: Fri,  4 Sep 2015 15:54:09 -0500
Message-Id: <1441400050-8455-3-git-send-email-billodo@redhat.com>
In-Reply-To: <1441400050-8455-1-git-send-email-billodo@redhat.com>
References: <1441400050-8455-1-git-send-email-billodo@redhat.com>
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
