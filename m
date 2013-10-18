Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 35D6C7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 13:26:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B830CAC004
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 11:26:34 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id lemoQmI7vdhiAmQa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 18 Oct 2013 11:26:33 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id C91D89A03DC
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:26:32 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH 1/8] xfstests: fix btrfs/002 to not use the scratch dev pool
Date: Fri, 18 Oct 2013 14:26:23 -0400
Message-ID: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

This test doesn't need the scratch dev pool and it also doesn't call
_require_scratch_dev_pool, so just kick out the scratch dev pool part of the
test.  Thanks,

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/002 | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/btrfs/002 b/tests/btrfs/002
index f4389ae..19a62c6 100755
--- a/tests/btrfs/002
+++ b/tests/btrfs/002
@@ -45,9 +45,8 @@ _need_to_be_root
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-_require_scratch_dev_pool
 
-_scratch_pool_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
+_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount
 
 # Create and save sha256sum
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
