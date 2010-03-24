Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2O3WhL7184523 for <xfs@oss.sgi.com>; Tue, 23 Mar 2010 22:32:43 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 903DD1A34DFF
	for <xfs@oss.sgi.com>; Tue, 23 Mar 2010 20:34:24 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id F1Fi3YQipKxtuWEu for
	<xfs@oss.sgi.com>; Tue, 23 Mar 2010 20:34:24 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id BAF3F9E8450
	for <xfs@oss.sgi.com>; Tue, 23 Mar 2010 22:34:23 -0500 (CDT)
Message-ID: <4BA9883F.9010101@sandeen.net>
Date: Tue, 23 Mar 2010 22:34:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: use $TEST_DIR in 225
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

Oops, another hard-coded /mnt/test

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/225 b/225
index 673e93e..ab688cd 100644
--- a/225
+++ b/225
@@ -53,7 +53,7 @@ fiemapfile=$TEST_DIR/fiemap.$$
 [ -x $here/src/fiemap-tester ] || _notrun "fiemap-tester not built"
 
 echo "fiemap run without preallocation"
-$here/src/fiemap-tester -q -p 0 -r 200 /mnt/test/fiemapfile
+$here/src/fiemap-tester -q -p 0 -r 200 $TEST_DIR/fiemapfile
 
 rm -f $fiemapfile
 rm -f $seq.full

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
