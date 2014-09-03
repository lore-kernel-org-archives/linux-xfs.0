Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1DFCC7F57
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 22:26:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E377D8F8054
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 20:26:32 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 0EdKRISESCHcPIH8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Sep 2014 20:26:28 -0700 (PDT)
From: Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH] xfstests: remove check_scratch_fs in btrfs/012
Date: Wed,  3 Sep 2014 11:25:59 +0800
Message-Id: <1409714759-9805-1-git-send-email-bo.li.liu@oracle.com>
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
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>

From: Liu Bo <liub.liubo@gmail.com>

btrfs/012 is a case to verify btrfs-convert feature, it converts an ext4 to
btrfs firstly and do something, then rolls back to ext4.

So at last we have a ext4 on the scratch device, but setting _require_scratch
will force a btrfsck on a ext4 fs because $FSTYP here is btrfs, and it ends up
with a failure report of _check_btrfs_filesystem.

Now that we have deliberately check the final ext4 fs in btrfs/012, just do not
set _require_scratch in this case.

Signed-off-by: Liu Bo <liub.liubo@gmail.com>
---
 tests/btrfs/012 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/btrfs/012 b/tests/btrfs/012
index f7e5da5..12f6462 100755
--- a/tests/btrfs/012
+++ b/tests/btrfs/012
@@ -52,7 +52,6 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs btrfs
 _supported_os Linux
-_require_scratch
 
 BTRFS_CONVERT_PROG="`set_prog_path btrfs-convert`"
 MKFS_EXT4_PROG="`set_prog_path mkfs.ext4`"
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
