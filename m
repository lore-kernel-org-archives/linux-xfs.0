Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4OECF1u183216 for <xfs@oss.sgi.com>; Mon, 24 May 2010 09:12:16 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0566D369D38
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 07:14:37 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id eXm42DS2IMKEPhAV for <xfs@oss.sgi.com>;
	Mon, 24 May 2010 07:14:37 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/8] Fix fallocate() test
Date: Mon, 24 May 2010 16:14:13 +0200
Message-Id: <1274710459-11446-3-git-send-email-jack@suse.cz>
In-Reply-To: <1274710459-11446-1-git-send-email-jack@suse.cz>
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>

The test for fallocate was broken because it used $TEST_DIR/$tmp.io. Because
$tmp is usually something like /tmp/1234 or /mnt/1234 the file cannot be
created and xfs_io fails regardless of existance of fallocate support. Moreover
the subsequent message parsing decides that fallocate is actually supported
because it does not expect this message.

Fix the test to not use $tmp.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 common.rc |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/common.rc b/common.rc
index e6d818d..6bf1e12 100644
--- a/common.rc
+++ b/common.rc
@@ -803,8 +803,9 @@ _require_user()
 #
 _require_xfs_io_falloc()
 {
-	testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $TEST_DIR/$tmp.io 2>&1`
-	rm -f $TEST_DIR/$tmp.io 2>&1 > /dev/null
+	testfile=$TEST_DIR/$$.falloc
+	testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
+	rm -f $testfile 2>&1 > /dev/null
 	echo $testio | grep -q "not found" && \
 		_notrun "xfs_io fallocate support is missing"
 	echo $testio | grep -q "Operation not supported" && \
-- 
1.6.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
