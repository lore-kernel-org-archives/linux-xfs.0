Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 59A367F47
	for <xfs@oss.sgi.com>; Sat, 29 Nov 2014 10:45:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DC3EDAC005
	for <xfs@oss.sgi.com>; Sat, 29 Nov 2014 08:45:41 -0800 (PST)
Received: from mout.web.de (mout.web.de [212.227.15.3]) by cuda.sgi.com with
	ESMTP id EGFnmB4QXThC7Bg9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 29 Nov 2014 08:45:40 -0800 (PST)
Message-ID: <5479F823.60900@users.sourceforge.net>
Date: Sat, 29 Nov 2014 17:45:23 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
MIME-Version: 1.0
Subject: [PATCH 1/1] XFS: Deletion of unnecessary checks before two function
	calls
References: <5307CAA2.8060406@users.sourceforge.net>
	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	<530A086E.8010901@users.sourceforge.net>
	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 29 Nov 2014 17:40:22 +0100

The functions xfs_blkdev_put() and xfs_qm_dqrele() test whether their argument
is NULL and then return immediately.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/xfs/xfs_qm.c    | 12 +++++-------
 fs/xfs/xfs_super.c |  3 +--
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d68f230..9a4b50a 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1749,23 +1749,21 @@ xfs_qm_vop_dqalloc(
 	xfs_iunlock(ip, lockflags);
 	if (O_udqpp)
 		*O_udqpp = uq;
-	else if (uq)
+	else
 		xfs_qm_dqrele(uq);
 	if (O_gdqpp)
 		*O_gdqpp = gq;
-	else if (gq)
+	else
 		xfs_qm_dqrele(gq);
 	if (O_pdqpp)
 		*O_pdqpp = pq;
-	else if (pq)
+	else
 		xfs_qm_dqrele(pq);
 	return 0;
 
 error_rele:
-	if (gq)
-		xfs_qm_dqrele(gq);
-	if (uq)
-		xfs_qm_dqrele(uq);
+	xfs_qm_dqrele(gq);
+	xfs_qm_dqrele(uq);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 206b97f..97eaa25 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -796,8 +796,7 @@ xfs_open_devices(
  out_free_ddev_targ:
 	xfs_free_buftarg(mp, mp->m_ddev_targp);
  out_close_rtdev:
-	if (rtdev)
-		xfs_blkdev_put(rtdev);
+	xfs_blkdev_put(rtdev);
  out_close_logdev:
 	if (logdev && logdev != ddev)
 		xfs_blkdev_put(logdev);
-- 
2.1.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
