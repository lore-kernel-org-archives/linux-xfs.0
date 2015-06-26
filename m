Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 607CE7F5F
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2015 04:15:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 06BA4AC001
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2015 02:15:37 -0700 (PDT)
Received: from mout.web.de (mout.web.de [212.227.17.11]) by cuda.sgi.com with
	ESMTP id 0YLV7Ocu03f49WBu (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Jun 2015 02:15:35 -0700 (PDT)
Message-ID: <558D1833.3080009@users.sourceforge.net>
Date: Fri, 26 Jun 2015 11:15:31 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
MIME-Version: 1.0
Subject: [PATCH] XFS: Delete unnecessary checks before the function call
	"xfs_qm_dqrele"
References: <530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<5479F823.60900@users.sourceforge.net>
	<20141130230904.GF16151@dastard>
In-Reply-To: <20141130230904.GF16151@dastard>
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
Date: Fri, 26 Jun 2015 11:05:41 +0200

The xfs_qm_dqrele() function tests whether its argument is NULL and
then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/xfs/xfs_qm_syscalls.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 3640c6e..6deee1e 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -735,15 +735,15 @@ xfs_dqrele_inode(
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
+	if (flags & XFS_UQUOTA_ACCT) {
 		xfs_qm_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
 	}
-	if ((flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
+	if (flags & XFS_GQUOTA_ACCT) {
 		xfs_qm_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
-	if ((flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
+	if (flags & XFS_PQUOTA_ACCT) {
 		xfs_qm_dqrele(ip->i_pdquot);
 		ip->i_pdquot = NULL;
 	}
-- 
2.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
