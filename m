Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E49EA7CA0
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 07:22:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D24AAC003
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 05:22:51 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id YYizKLz3t1qQFZel (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 24 Jun 2016 05:22:49 -0700 (PDT)
Date: Fri, 24 Jun 2016 15:22:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] xfs: don't allow negative error tags
Message-ID: <20160624122234.GA23169@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dave Chinner <david@fromorbit.com>
Cc: kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

Errors go from zero which means no error to XFS_ERRTAG_MAX (22).  My
static checker complains that xfs_errortag_add() puts an upper bound on
this but not a lower bound.  Let's fix it by making it unsigned.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 4ed3042..2e4f67f 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -128,7 +128,7 @@ extern int xfs_error_test(int, int *, char *, int, char *, unsigned long);
 	 xfs_error_test((tag), (mp)->m_fixedfsid, "expr", __LINE__, __FILE__, \
 			(rf))))
 
-extern int xfs_errortag_add(int error_tag, struct xfs_mount *mp);
+extern int xfs_errortag_add(unsigned int error_tag, struct xfs_mount *mp);
 extern int xfs_errortag_clearall(struct xfs_mount *mp, int loud);
 #else
 #define XFS_TEST_ERROR(expr, mp, tag, rf)	(expr)
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 355619a..ed7ee4e 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -55,7 +55,7 @@ xfs_error_test(int error_tag, int *fsidp, char *expression,
 }
 
 int
-xfs_errortag_add(int error_tag, xfs_mount_t *mp)
+xfs_errortag_add(unsigned int error_tag, xfs_mount_t *mp)
 {
 	int i;
 	int len;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
