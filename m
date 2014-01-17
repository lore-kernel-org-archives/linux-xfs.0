Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A9E577F6B
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 12:02:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 828CC304071
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 10:02:06 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id klvHz74doefhHF94 for
	<xfs@oss.sgi.com>; Fri, 17 Jan 2014 10:02:05 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0HI24mn024712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 13:02:05 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s0HI24MW005495
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 13:02:04 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: use tr_qm_dqalloc log reservation for dquot alloc
Date: Fri, 17 Jan 2014 13:02:03 -0500
Message-Id: <1389981723-54311-1-git-send-email-bfoster@redhat.com>
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

The dquot allocation path in xfs_qm_dqread() currently uses the
attribute set log reservation, which appears to be incorrect. We
have reports of transaction reservation overruns with the current
code. E.g., a repeated run of xfstests test generic/270 on a 512b
block size fs occassionally produces the following in dmesg:

	XFS (sdN): xlog_write: reservation summary:
	  trans type  = QM_DQALLOC (30)
	  unit res    = 7080 bytes
	  current res = -632 bytes
	  total reg   = 0 bytes (o/flow = 0 bytes)
	  ophdrs      = 0 (ophdr space = 0 bytes)
	  ophdr + reg = 0 bytes
	  num regions = 0

	XFS (sdN): xlog_write: reservation ran out. Need to up reservation

The dquot allocation case should consist of a write reservation
(i.e., we are allocating a range of the internal quota file) plus
the size of the actual dquots. We already have a log reservation
definition for this operation (tr_qm_dqalloc). Use it in
xfs_qm_dqread() and update the log reservation calculation function
to use the write res. calculation function rather than reading the
assumed to be pre-calculated value directly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
Hi all,

This issue was reported here:

https://bugzilla.redhat.com/show_bug.cgi?id=1052787

... and the patch seems to address the reservation overrun from my testing.
It also runs through an xfstests regression. Thanks.

Brian

 fs/xfs/xfs_dquot.c      | 2 +-
 fs/xfs/xfs_trans_resv.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 6b1e695..06280c6 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -614,7 +614,7 @@ xfs_qm_dqread(
 
 	if (flags & XFS_QMOPT_DQALLOC) {
 		tp = xfs_trans_alloc(mp, XFS_TRANS_QM_DQALLOC);
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_attrsetm,
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_dqalloc,
 					  XFS_QM_DQALLOC_SPACE_RES(mp), 0);
 		if (error)
 			goto error1;
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index 2fd59c0..60b7d40 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -651,8 +651,7 @@ STATIC uint
 xfs_calc_qm_dqalloc_reservation(
 	struct xfs_mount	*mp)
 {
-	ASSERT(M_RES(mp)->tr_write.tr_logres);
-	return M_RES(mp)->tr_write.tr_logres +
+	return xfs_calc_write_reservation(mp) +
 		xfs_calc_buf_res(1,
 			XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) - 1);
 }
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
