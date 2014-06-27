Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CCFAB7FA4
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 07:07:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 61FA8AC002
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 05:07:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WZMVktTsSynxt3wq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Jun 2014 05:07:03 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5RC72gf019747
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 08:07:02 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s5RC71mc028005
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 08:07:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 2/6] xfs: add a sysfs kset
Date: Fri, 27 Jun 2014 08:06:57 -0400
Message-Id: <1403870821-20143-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1403870821-20143-1-git-send-email-bfoster@redhat.com>
References: <1403870821-20143-1-git-send-email-bfoster@redhat.com>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_super.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f2e5f8a..986c557 100644
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
