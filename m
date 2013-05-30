Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D1697F51
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 07:45:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD6BD304064
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 05:45:52 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 48RQRcdlV2vGBdPJ for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 05:45:51 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] 285: Fix test for ext4 in some configurations
Date: Thu, 30 May 2013 14:45:37 +0200
Message-Id: <1369917939-22660-1-git-send-email-jack@suse.cz>
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
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>

In some configurations (e.g. 1 KB block size), ext4 can decide it is
better to zero out several blocks rather than splitting unwritten
extent. This changes results SEEK_HOLE / SEEK_DATA returns and thus the
test fails. Fix the problem by disabling the feature for this test.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tests/generic/285 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tests/generic/285 b/tests/generic/285
index b700a15..8078b1c 100755
--- a/tests/generic/285
+++ b/tests/generic/285
@@ -46,6 +46,12 @@ BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
 
 [ -x $here/src/seek_sanity_test ] || _notrun "seek_sanitfy_tester not built"
 
+# Disable extent zeroing for ext4 as that change where holes are created
+if [ "$FSTYP" = "ext4" ]; then
+	DEV=`basename $TEST_DEV`
+	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
+fi
+
 _cleanup()
 {
 	eval "rm -f $BASE_TEST_FILE.*"
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
