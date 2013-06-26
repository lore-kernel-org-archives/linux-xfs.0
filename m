Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 494817F4E
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 10:53:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C73A2AC003
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 08:53:08 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id 3zMZE0HaE55JT093 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 08:53:07 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 4AB299A0320
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 09:53:07 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: fix btrfs/264 to not use the scratch dev pool
Date: Wed, 26 Jun 2013 11:52:56 -0400
Message-ID: <1372261976-11426-1-git-send-email-jbacik@fusionio.com>
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
To: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

This test doesn't need the scratch dev pool and it also doesn't call
_require_scratch_dev_pool, so just kick out the scratch dev pool part of the
test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/264 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tests/btrfs/264 b/tests/btrfs/264
index b08667a..8eef43b 100755
--- a/tests/btrfs/264
+++ b/tests/btrfs/264
@@ -46,7 +46,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch
 
-_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount
 
 # Create and save sha256sum
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
