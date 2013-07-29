Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 172787F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 12:21:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EBF548F8037
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 10:21:07 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id 0CJFi2fnIGqmYm9o (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 10:21:06 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 21D627C0427
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 11:21:06 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: generic/315: add one more sync and more output
Date: Mon, 29 Jul 2013 13:21:03 -0400
Message-ID: <1375118463-29654-1-git-send-email-jbacik@fusionio.com>
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, jeff.liu@oracle.com

So df in btrfs is tricky at best, and relying on it for accurate information is
not great, but it's the best way to verify this test.  So we need to add another
sync to make sure the pinned blocks are all freed up and the df space is really
really accurate, otherwise we end up with this test failling because the df
after the test is slightly off (in my case it was like 36kb off).  With this
patch I'm not seeing random failures of this test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/generic/315 |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tests/generic/315 b/tests/generic/315
index 7cfc40d..7c55b8a 100644
--- a/tests/generic/315
+++ b/tests/generic/315
@@ -70,10 +70,11 @@ fsize=`ls -l $TEST_DIR/testfile.$seq | awk '{print $5}'`
 # Truncate the file size back to 0
 truncate -s 0 $TEST_DIR/testfile.$seq
 sync
+sync
 
 # Preallocated disk space should be released
 avail_done=`df -P $TEST_DIR | awk 'END {print $4}'`
-[ "$avail_done" -eq "$avail_begin" ] || _fail "Available disk space ($avail_done KiB)"
+[ "$avail_done" -eq "$avail_begin" ] || _fail "Available disk space ($avail_done KiB) wanted ($avail_begin KiB)"
 
 # success, all done
 exit
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
