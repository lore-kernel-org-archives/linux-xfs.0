Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D54F57F47
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 08:13:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9569A8F8049
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 06:13:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ATdVC7Rh9ngxWhoY for
	<xfs@oss.sgi.com>; Fri, 06 Jun 2014 06:13:36 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s56DDZo9020005
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 6 Jun 2014 09:13:35 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s56DDZGi005926
	for <xfs@oss.sgi.com>; Fri, 6 Jun 2014 09:13:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/6] xfs: add a sysfs kset
Date: Fri,  6 Jun 2014 09:13:30 -0400
Message-Id: <1402060414-22075-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
References: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
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

Create a sysfs kset to contain all sub-objects associated with the XFS
module. The kset is created and removed on module initialization and
removal respectively. The kset uses fs_obj as a parent. This leads to
the creation of a /sys/fs/xfs directory when the kset exists.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8f0333b..1766214 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -61,6 +61,7 @@
 static const struct super_operations xfs_super_operations;
 static kmem_zone_t *xfs_ioend_zone;
 mempool_t *xfs_ioend_pool;
+struct kset *xfs_kset;
 
 #define MNTOPT_LOGBUFS	"logbufs"	/* number of XFS log buffers */
 #define MNTOPT_LOGBSIZE	"logbsize"	/* size of XFS log buffers */
@@ -1761,9 +1762,15 @@ init_xfs_fs(void)
 	if (error)
 		goto out_cleanup_procfs;
 
+	xfs_kset = kset_create_and_add("xfs", NULL, fs_kobj);
+	if (!xfs_kset) {
+		error = -ENOMEM;
+		goto out_sysctl_unregister;;
+	}
+
 	error = xfs_qm_init();
 	if (error)
-		goto out_sysctl_unregister;
+		goto out_kset_unregister;
 
 	error = register_filesystem(&xfs_fs_type);
 	if (error)
@@ -1772,6 +1779,8 @@ init_xfs_fs(void)
 
  out_qm_exit:
 	xfs_qm_exit();
+ out_kset_unregister:
+	kset_unregister(xfs_kset);
  out_sysctl_unregister:
 	xfs_sysctl_unregister();
  out_cleanup_procfs:
@@ -1793,6 +1802,7 @@ exit_xfs_fs(void)
 {
 	xfs_qm_exit();
 	unregister_filesystem(&xfs_fs_type);
+	kset_unregister(xfs_kset);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
 	xfs_buf_terminate();
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
