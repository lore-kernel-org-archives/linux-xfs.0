Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0BFa3m4096766 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 09:36:04 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCBE1253ABD
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 07:38:16 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id r7EV2SY1gRjqfsSp for
	<xfs@oss.sgi.com>; Tue, 11 Jan 2011 07:38:16 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 1777248FF016
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 09:38:16 -0600 (CST)
Message-ID: <4D2C7967.2090801@sandeen.net>
Date: Tue, 11 Jan 2011 09:38:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH xfstests] 243: remove test files before starting
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

I found that overwriting existing files hides a bug
in ext4 (since fixed).  Removing the files before
the test reliably reproduces it.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/243 b/243
index 8b2e647..48f7932 100755
--- a/243
+++ b/243
@@ -125,6 +125,9 @@ _require_xfs_io_falloc
 # Real QA test starts here.
 rm -f $seq.full
 
+# Remove any leftover files from last run.
+rm -f ${TEST_DIR}/test_?
+
 # Begin test cases.
 echo "Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io)." \
     >> $seq.full

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
