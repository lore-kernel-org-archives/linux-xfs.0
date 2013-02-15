Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9FA927F59
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 06:45:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8892530404E
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 04:45:38 -0800 (PST)
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id LXSiB6Cjk5dn5zl8
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Feb 2013 04:45:37 -0800 (PST)
Received: by mail-pb0-f53.google.com with SMTP id un1so601186pbc.40
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 04:45:36 -0800 (PST)
From: Hemanth Kumar <hemanthkumar51@gmail.com>
Subject: [btrfs-progs] Btrfs quotas testing
Date: Fri, 15 Feb 2013 18:15:24 +0530
Message-Id: <1360932324-2722-1-git-send-email-hemanthkumar51@gmail.com>
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
 quotas.sh | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 quotas.sh

diff --git a/quotas.sh b/quotas.sh
new file mode 100644
index 0000000..7e64578
--- /dev/null
+++ b/quotas.sh
@@ -0,0 +1,30 @@
+#! /bin/bash
+# Btrfs quotas test case
+# Hi all,
+# This is shell script to test the quotas feature of Btrfs
+# I created Btrfs filesystem on a new
+# partition, then activated quota management ('btrfs quota enable'), and
+# created a few subvolumes.
+# I have lmited the quota to 2mb and tried filling it
+# its working as expected
+
+
+cleanup()
+{
+    btrfs subvolume delete $TEST_DIR/vol1
+    btrfs subvolume disable $TEST_DIR
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
