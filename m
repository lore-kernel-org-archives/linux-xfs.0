Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7344B7F51
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 09:10:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CFD78AC008
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 07:10:40 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id q6TcFDvhhvzjXhCG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 07:10:39 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAMFAa7S010659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 15:10:38 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAMFAaha011949
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 15:10:36 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAMFAZJ9011935 for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 15:10:35 GMT
Message-ID: <528F743D.9010800@oracle.com>
Date: Fri, 22 Nov 2013 23:11:57 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: fix assertion failure at xfs_setattr_nonsize
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

For CRC enabled v5 super block, change a file's ownership can simply
trigger ASSERT failure at xfs_setattr_nonsize() if both group and
project quota are enabled, e.g,

[  305.337609] XFS: Assertion failed: !XFS_IS_PQUOTA_ON(mp), file: fs/xfs/xfs_iops.c, line: 621
[  305.339250] Kernel BUG at ffffffffa0a7fa32 [verbose debug info unavailable]
[  305.383939] Call Trace:
[  305.385536]  [<ffffffffa0a7d95a>] xfs_setattr_nonsize+0x69a/0x720 [xfs]
[  305.387142]  [<ffffffffa0a7dea9>] xfs_vn_setattr+0x29/0x70 [xfs]
[  305.388727]  [<ffffffff811ca388>] notify_change+0x1a8/0x350
[  305.390298]  [<ffffffff811ac39d>] chown_common+0xfd/0x110
[  305.391868]  [<ffffffff811ad6bf>] SyS_fchownat+0xaf/0x110
[  305.393440]  [<ffffffff811ad760>] SyS_lchown+0x20/0x30
[  305.394995]  [<ffffffff8170f7dd>] system_call_fastpath+0x1a/0x1f
[  305.399870] RIP  [<ffffffffa0a7fa32>] assfail+0x22/0x30 [xfs]

To remain the current semantics under the debug mode, this fix add
an additional judgement to make this assertion only works for non-CRC
enabled version.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_iops.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 27e0e54..586f1f2 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -618,7 +618,10 @@ xfs_setattr_nonsize(
 		}
 		if (!gid_eq(igid, gid)) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
-				ASSERT(!XFS_IS_PQUOTA_ON(mp));
+#ifdef DEBUG
+				if (!xfs_sb_version_has_pquotino(&mp->m_sb))
+					ASSERT(!XFS_IS_PQUOTA_ON(mp));
+#endif
 				ASSERT(mask & ATTR_GID);
 				ASSERT(gdqp);
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
