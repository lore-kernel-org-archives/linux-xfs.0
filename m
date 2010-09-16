Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8GI70Bc007211 for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 13:07:00 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10F97DF5CC3
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 11:19:46 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id T83tjO352zBtGNbc for
	<xfs@oss.sgi.com>; Thu, 16 Sep 2010 11:19:46 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 529844A8B9E3
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 13:07:48 -0500 (CDT)
Message-ID: <4C925CF3.3060303@sandeen.net>
Date: Thu, 16 Sep 2010 13:07:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: add local.config example
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

I think it'd be useful to have a local.config template in the
git repo, to avoid having to re-read the README each time
to remember the required environment variable names.

Thoughts?  Am I just lazy?  :)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/local.config b/local.config.example
new file mode 100644
index 0000000..6b2e0e9
--- /dev/null
+++ b/local.config.example
@@ -0,0 +1,10 @@
+# Ideally define at least these 4 to match your environment
+# The first 2 are required.
+# See README for other variables which can be set.
+#
+# Note: SCRATCH_DEV >will< get overwritten!
+
+export TEST_DEV=/dev/sdX1
+export TEST_DIR=/mnt/test
+export SCRATCH_DEV=/dev/sdX2
+export SCRATCH_MNT=/mnt/scratch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
