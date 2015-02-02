Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EB6157F47
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 01:01:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA71A8F8054
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 23:01:22 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	6Vy46GlzDIcPDxEm for <xfs@oss.sgi.com>;
	Sun, 01 Feb 2015 23:01:21 -0800 (PST)
Date: Mon, 2 Feb 2015 15:00:42 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH dgc-xfs] xfs: xfs_ioctl_setattr_check_extsize can be static
Message-ID: <20150202070042.GA111291@lkp-sb04>
References: <201502021535.BvQbm6Lm%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201502021535.BvQbm6Lm%fengguang.wu@intel.com>
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
Cc: linux-kernel@vger.kernel.org, kbuild-all@01.org, xfs@oss.sgi.com

fs/xfs/xfs_ioctl.c:1102:1: sparse: symbol 'xfs_ioctl_setattr_check_extsize' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 xfs_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9f80853..992b669 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1098,7 +1098,7 @@ out_cancel:
 	return ERR_PTR(error);
 }
 
-int
+static int
 xfs_ioctl_setattr_check_extsize(
 	struct xfs_inode	*ip,
 	struct fsxattr		*fa)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
