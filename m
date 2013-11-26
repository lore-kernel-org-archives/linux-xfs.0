Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D52247F3F
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 07:39:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 97A908F8096
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 05:39:04 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id UDAhj5I7ksp5ZGxp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Nov 2013 05:39:03 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAQDd2qT001079
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 13:39:02 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAQDd11O005157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 13:39:02 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAQDd1KC003008 for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 13:39:01 GMT
Message-ID: <5294A46E.1070303@oracle.com>
Date: Tue, 26 Nov 2013 21:38:54 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 3/3] xfs: fix false assertion at xfs_qm_vop_create_dqattach
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

After the previous fix, there still has another ASSERT failure if turning
off any type of quota while fsstress is running at the same time.

Backtrace in this case:

[   50.867897] XFS: Assertion failed: XFS_IS_GQUOTA_ON(mp), file: fs/xfs/xfs_qm.c, line: 2118
[   50.867924] ------------[ cut here ]------------
... <snip>
[   50.867957] Kernel BUG at ffffffffa0b55a32 [verbose debug info unavailable]
[   50.867999] invalid opcode: 0000 [#1] SMP
[   50.869407] Call Trace:
[   50.869446]  [<ffffffffa0bc408a>] xfs_qm_vop_create_dqattach+0x19a/0x2d0 [xfs]
[   50.869512]  [<ffffffffa0b9cc45>] xfs_create+0x5c5/0x6a0 [xfs]
[   50.869564]  [<ffffffffa0b5307c>] xfs_vn_mknod+0xac/0x1d0 [xfs]
[   50.869615]  [<ffffffffa0b531d6>] xfs_vn_mkdir+0x16/0x20 [xfs]
[   50.869655]  [<ffffffff811becd5>] vfs_mkdir+0x95/0x130
[   50.869689]  [<ffffffff811bf63a>] SyS_mkdirat+0xaa/0xe0
[   50.869723]  [<ffffffff811bf689>] SyS_mkdir+0x19/0x20
[   50.869757]  [<ffffffff8170f7dd>] system_call_fastpath+0x1a/0x1f
[   50.869793] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 <snip>
[   50.870003] RIP  [<ffffffffa0b55a32>] assfail+0x22/0x30 [xfs]
[   50.870050]  RSP <ffff88002941fd60>
[   50.879251] ---[ end trace c93a2b342341c65b ]---

We're hitting the ASSERT(XFS_IS_*QUOTA_ON(mp)) in xfs_qm_vop_create_dqattach(),
however the assertion itself is not right IMHO.  While performing quota off, we
firstly clear the XFS_*QUOTA_ACTIVE bit(s) from struct xfs_mount without taking
any special locks, see xfs_qm_scall_quotaoff().  Hence there is no guarantee
that the desired quota is still active.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_qm.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 81b3cd8..2fcd527 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -2111,24 +2111,21 @@ xfs_qm_vop_create_dqattach(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
-	if (udqp) {
+	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
-		ASSERT(XFS_IS_UQUOTA_ON(mp));
 		ASSERT(ip->i_d.di_uid == be32_to_cpu(udqp->q_core.d_id));
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
-	if (gdqp) {
+	if (gdqp && XFS_IS_GQUOTA_ON(mp)) {
 		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(XFS_IS_GQUOTA_ON(mp));
 		ASSERT(ip->i_d.di_gid == be32_to_cpu(gdqp->q_core.d_id));
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
-	if (pdqp) {
+	if (pdqp && XFS_IS_PQUOTA_ON(mp)) {
 		ASSERT(ip->i_pdquot == NULL);
-		ASSERT(XFS_IS_PQUOTA_ON(mp));
 		ASSERT(xfs_get_projid(ip) == be32_to_cpu(pdqp->q_core.d_id));
 
 		ip->i_pdquot = xfs_qm_dqhold(pdqp);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
