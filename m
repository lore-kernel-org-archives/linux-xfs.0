Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04EE97F50
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 02:42:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E7E238F8094
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 00:42:15 -0700 (PDT)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	TZFf1f9lpa7QJQoJ for <xfs@oss.sgi.com>;
	Wed, 25 Mar 2015 00:42:14 -0700 (PDT)
Date: Wed, 25 Mar 2015 15:42:08 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH dgc-xfs] xfs: xfs_shift_file_space can be static
Message-ID: <20150325074208.GA22854@snb>
References: <201503251558.Dje24s0l%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201503251558.Dje24s0l%fengguang.wu@intel.com>
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
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: linux-kernel@vger.kernel.org, kbuild-all@01.org, Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 xfs_bmap_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fe1f11b..e867573 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1383,7 +1383,7 @@ out:
  * If we are shifting right, we will start with last extent inside file space
  * and continue until we reach the block corresponding to offset.
  */
-int
+static int
 xfs_shift_file_space(
 	struct xfs_inode        *ip,
 	xfs_off_t               offset,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
