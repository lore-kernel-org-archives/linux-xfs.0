Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4QFt7k8086049 for <xfs@oss.sgi.com>; Wed, 26 May 2010 10:55:08 -0500
Date: Wed, 26 May 2010 17:57:23 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 11/17] fs/xfs/quota: Add missing mutex_unlock
Message-ID: <Pine.LNX.4.64.1005261757050.23743@ask.diku.dk>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a mutex_unlock missing on the error path.  The use of this lock is
balanced elsewhere in the file.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* mutex_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* mutex_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
The use of ENOMEM rather than -ENOMEM is also a bit odd.

 fs/xfs/quota/xfs_qm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index 38e7641..2d8b7bc 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -249,8 +249,10 @@ xfs_qm_hold_quotafs_ref(
 
 	if (!xfs_Gqm) {
 		xfs_Gqm = xfs_Gqm_init();
-		if (!xfs_Gqm)
+		if (!xfs_Gqm) {
+			mutex_unlock(&xfs_Gqm_lock);
 			return ENOMEM;
+		}
 	}
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
