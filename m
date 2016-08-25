Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6AE97DDA
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:38:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 29B86AC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:38:58 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id RbD6pS33qf7StMsb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:38:56 -0700 (PDT)
Subject: [PATCH 64/71] xfs: set a default CoW extent size of 32 blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:38:51 -0700
Message-ID: <147216833153.867.6545330182721132210.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

If the admin doesn't set a CoW extent size or a regular extent size
hint, default to creating CoW reservations 32 blocks long to reduce
fragmentation.

Signed-off-by: DarricK J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e91fd84..8c2f9a7 100644
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
