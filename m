Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9461F7F8E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:29:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1DCC5AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:29:36 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id SpJfqteAnTaYSMmU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:29:34 -0700 (PDT)
Subject: [PATCH 107/119] xfs: set a default CoW extent size of 32 blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:29:25 -0700
Message-ID: <146612696580.12839.10793081509573349729.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

If the admin doesn't set a CoW extent size or a regular extent size
hint, default to creating CoW reservations 32 blocks long to reduce
fragmentation.

Signed-off-by: DarricK J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fb9c2d7..f2971e2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -80,7 +80,8 @@ xfs_get_extsz_hint(
 /*
  * Helper function to extract CoW extent size hint from inode.
  * Between the extent size hint and the CoW extent size hint, we
- * return the greater of the two.
+ * return the greater of the two.  If the value is zero (automatic),
+ * default to 32 blocks.
  */
 xfs_extlen_t
 xfs_get_cowextsz_hint(
@@ -93,9 +94,10 @@ xfs_get_cowextsz_hint(
 		a = ip->i_d.di_cowextsize;
 	b = xfs_get_extsz_hint(ip);
 
-	if (a > b)
-		return a;
-	return b;
+	a = max(a, b);
+	if (a == 0)
+		return 32;
+	return a;
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
