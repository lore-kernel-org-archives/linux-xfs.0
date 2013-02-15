Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E06C7F86
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 07:06:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9DB1CAC00A
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 05:06:34 -0800 (PST)
Received: from mail-da0-f44.google.com (mail-da0-f44.google.com
	[209.85.210.44]) by cuda.sgi.com with ESMTP id eKG4JsKqPfOodWgw
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Feb 2013 05:06:33 -0800 (PST)
Received: by mail-da0-f44.google.com with SMTP id z20so1459957dae.3
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 05:06:32 -0800 (PST)
From: Hemanth Kumar <hemanthkumar51@gmail.com>
Subject: [btrfs-progs] testing btrfs hierarchical quotas
Date: Fri, 15 Feb 2013 18:35:41 +0530
Message-Id: <1360933541-2894-1-git-send-email-hemanthkumar51@gmail.com>
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
Cc: chethan.casey@gmail.com, sandeen@redhat.com, sensille@gmx.net, ganeshkumar14@gmail.com, praneethu.u@gmail.com, hugo@carfax.org.uk, bo.li.liu@oracle.com, skjmca51@gmail.com, Hemanth Kumar <hemanthkumar51@gmail.com>, kirantpatil@gmail.com


Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
---
 hq.sh | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 hq.sh

diff --git a/hq.sh b/hq.sh
new file mode 100644
index 0000000..6a0a820
--- /dev/null
+++ b/hq.sh
@@ -0,0 +1,33 @@
+#! /bin/bash
+# Btrfs quotas test case
+# Hi all,
+# This is shell script to test the hierarchical quotas feature of Btrfs
+# I created Btrfs filesystem on a new
+# partition, then activated quota management ('btrfs quota enable'), and
+# created a few subvolumes of multiple levels.
+
+
+cleanup()
+{
+    btrfs subvolume delete $TEST_DIR/vol1/vol2/vol3
+    btrfs subvolume delete $TEST_DIR/vol1/vol2
+    btrfs subvolume delete $TEST_DIR/vol1
+    btrfs subvolume disable $TEST_DIR
+}
+
+#trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+btrfs quota enable $TEST_DIR
+echo "quota enabled on $TEST_DEV"
+btrfs subvolume create $TEST_DIR/vol1
+btrfs subvolume create $TEST_DIR/vol1/vol2
+btrfs subvolume create $TEST_DIR/vol1/vol2/vol3
+btrfs qgroup limit 5m $TEST_DIR/vol1
+btrfs qgroup limit 3m $TEST_DIR/vol1/vol2
+btrfs qgroup limit 2m $TEST_DIR/vol1/vol2/vol3
+dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/vol3/file1 bs=3M count=1
+dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/file1 bs=2M count=1
+dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=5M count=1
+
+cleanup
+exit
-- 
1.8.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
