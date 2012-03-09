Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29EM7vx236861 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 08:22:07 -0600
Message-ID: <4F59E7B2.6090006@oracle.com>
Date: Fri, 09 Mar 2012 19:21:22 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [RFC PATCH v1 4/4] cgroup quota: validate and charge  inode quota
	for XFS
Reply-To: jeff.liu@oracle.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: cgroups@vger.kernel.org
Cc: jack@suse.cz, Daniel Lezcano <daniel.lezcano@free.fr>, Christopher Jones <christopher.jones@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, tj@kernel.org, Ben Myers <bpm@sgi.com>, lxc-devel@lists.sourceforge.net, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, tytso@mit.edu, Chris Mason <chris.mason@oracle.com>

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_vnodeops.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index ce9268a..4824eef 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -50,6 +50,8 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 
+#include <linux/quota_cgroup.h>
+
 /*
  * The maximum pathlen is 1024 bytes. Since the minimum file system
  * blocksize is 512 bytes, we can get a max of 2 extents back from
@@ -853,6 +855,10 @@ xfs_create(
 	else
 		prid = XFS_PROJID_DEFAULT;
 
+	error = quota_cgroup_validate_pquota(QUOTA_NEW_INODE, prid, 1);
+	if (error)
+		return error;
+
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
@@ -983,6 +989,8 @@ xfs_create(
 	 */
 	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
 
+	quota_cgroup_charge_pquota(QUOTA_NEW_INODE, prid, 1);
+
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error)
 		goto out_bmap_cancel;
@@ -1354,6 +1362,8 @@ xfs_remove(
 	if (!is_dir && link_zero && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
+	quota_cgroup_charge_pquota(QUOTA_DROP_INODE, xfs_get_projid(ip), 1);
+
 	return 0;
 
  out_bmap_cancel:
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
