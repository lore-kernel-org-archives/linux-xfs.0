Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8E70D8090
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 00:39:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6749B8F8035
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 22:39:46 -0800 (PST)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
	[209.85.220.43]) by cuda.sgi.com with ESMTP id lSd2HNwl5NjX5Y5p
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Feb 2013 22:39:45 -0800 (PST)
Received: by mail-pa0-f43.google.com with SMTP id bh2so1657518pad.30
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 22:39:45 -0800 (PST)
From: Hemanth Kumar <hemanthkumar51@gmail.com>
Subject: [test] btrfs quotas testing
Date: Fri, 15 Feb 2013 12:09:31 +0530
Message-Id: <1360910371-3258-1-git-send-email-hemanthkumar51@gmail.com>
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: chethan.casey@gmail.com, sandeen@redhat.com, sensille@gmx.net, ganeshkumar14@gmail.com, praneethu.u@gmail.com, bo.li.liu@oracle.com, skjmca51@gmail.com, Hemanth Kumar <hemanthkumar51@gmail.com>, kirantpatil@gmail.com


Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
---
 quota.sh | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 quota.sh

diff --git a/quota.sh b/quota.sh
new file mode 100644
index 0000000..8b82bf9
--- /dev/null
+++ b/quota.sh
@@ -0,0 +1,23 @@
+#! /bin/bash
+# btrfs quotas test case
+#tmp=/sample
+status=1
+
+cleanup()
+{
+    btrfs subvolume delete $TEST_DIR/vol1
+}
+
+#trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+btrfs quota enable $TEST_DIR
+echo "quota enabled on $TEST_DEV"
+btrfs subvolume create $TEST_DIR/vol1
+echo "vol1 created"
+btrfs qgroup show $TEST_DIR
+btrfs qgroup limit 2m $TEST_DIR/vol1
+echo "qgroup limited to 2mb"
+dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=3M count=1
+echo "tried to write 3m worth data"
+cleanup
+exit
-- 
1.8.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
