Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C60367F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 13:56:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B214C304070
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 11:56:00 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id BRkENOXNIZU2S22A (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 11:55:59 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5DA979A0407
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 12:55:59 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: generic/315: allow a little tolerance for our used
	check
Date: Mon, 29 Jul 2013 14:55:56 -0400
Message-ID: <1375124156-17620-1-git-send-email-jbacik@fusionio.com>
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, jeff.liu@oracle.com, sandeen@redhat.com

So df in btrfs is tricky at best, and relying on it for accurate information is
not great, but it's the best way to verify this test.  To get around btrfs being
inconsistent sometimes just use _within_tolerance to check our new df value to
make sure that our truncate did something.  With this patch I no longer see
transient failures of this test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/generic/315 |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tests/generic/315 b/tests/generic/315
index 7cfc40d..9c01b5e 100644
--- a/tests/generic/315
+++ b/tests/generic/315
@@ -73,7 +73,8 @@ sync
 
 # Preallocated disk space should be released
 avail_done=`df -P $TEST_DIR | awk 'END {print $4}'`
-[ "$avail_done" -eq "$avail_begin" ] || _fail "Available disk space ($avail_done KiB)"
+_within_tolerance "df" $avail_done $avail_begin 1%
+[ $? -eq 0 ] || _fail "Available disk space ($avail_done KiB) wanted ($avail_begin KiB)"
 
 # success, all done
 exit
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
