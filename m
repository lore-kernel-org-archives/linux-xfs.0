Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E8A977CB0
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:18:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A7A32304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:18:08 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id oHzpJTS1T5lEg6Xl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:18:07 -0700 (PDT)
Subject: [PATCH 001/119] vfs: fix return type of ioctl_file_dedupe_range
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:17:59 -0700
Message-ID: <146612627940.12839.15145788608361492501.stgit@birch.djwong.org>
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

All the VFS functions in the dedupe ioctl path return int status, so
the ioctl handler ought to as well.

Found by Coverity, CID 1350952.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/ioctl.c b/fs/ioctl.c
index 116a333..db3d033 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -568,7 +568,7 @@ static int ioctl_fsthaw(struct file *filp)
 	return thaw_super(sb);
 }
 
-static long ioctl_file_dedupe_range(struct file *file, void __user *arg)
+static int ioctl_file_dedupe_range(struct file *file, void __user *arg)
 {
 	struct file_dedupe_range __user *argp = arg;
 	struct file_dedupe_range *same = NULL;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
