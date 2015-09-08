Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 044147F37
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 14:49:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84003AC00E
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 12:49:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jtF5K6eV9Q24FZQf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 Sep 2015 12:49:06 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 9FB7CC0B9890
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 19:49:05 +0000 (UTC)
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t88Jn26Y011197
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 8 Sep 2015 15:49:05 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: simplify /proc teardown & error handling
Message-ID: <55EF3BAE.5010904@redhat.com>
Date: Tue, 8 Sep 2015 14:49:02 -0500
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
To: xfs-oss <xfs@oss.sgi.com>

remove_proc_subtree() was added in 3.9, and can be
used to simplify our procfile creation error handling
and cleanup, removing the nested gotos.  It simply
removes fs/xfs and everything created under it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This goes after Bill's patches, I just noticed it
while reviewing them.

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 05d5227..009a860 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -168,41 +168,29 @@ int
 xfs_init_procfs(void)
 {
 	if (!proc_mkdir("fs/xfs", NULL))
-		goto out;
+		return -ENOMEM;
 
 	if (!proc_symlink("fs/xfs/stat", NULL,
 			  "/sys/fs/xfs/stats/stats"))
-		goto out_remove_xfs_dir;
+		goto out;
 
 #ifdef CONFIG_XFS_QUOTA
 	if (!proc_create("fs/xfs/xqmstat", 0, NULL,
 			 &xqmstat_proc_fops))
-		goto out_remove_stat_file;
+		goto out;
 	if (!proc_create("fs/xfs/xqm", 0, NULL,
 			 &xqm_proc_fops))
-		goto out_remove_xqmstat_file;
+		goto out;
 #endif
 	return 0;
 
-#ifdef CONFIG_XFS_QUOTA
- out_remove_xqmstat_file:
-	remove_proc_entry("fs/xfs/xqmstat", NULL);
- out_remove_stat_file:
-	remove_proc_entry("fs/xfs/stat", NULL);
-#endif
- out_remove_xfs_dir:
-	remove_proc_entry("fs/xfs", NULL);
- out:
+out:
+	remove_proc_subtree("fs/xfs", NULL);
 	return -ENOMEM;
 }
 
 void
 xfs_cleanup_procfs(void)
 {
-#ifdef CONFIG_XFS_QUOTA
-	remove_proc_entry("fs/xfs/xqm", NULL);
-	remove_proc_entry("fs/xfs/xqmstat", NULL);
-#endif
-	remove_proc_entry("fs/xfs/stat", NULL);
-	remove_proc_entry("fs/xfs", NULL);
+	remove_proc_subtree("fs/xfs", NULL);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
