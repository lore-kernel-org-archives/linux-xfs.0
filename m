Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0F288J3022109 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 20:08:09 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCBD717FF4FD
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 18:08:06 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id CbfMDxzYNq0V2WEC for
	<xfs@oss.sgi.com>; Wed, 14 Jan 2009 18:08:06 -0800 (PST)
Message-ID: <496E9A84.2060304@sandeen.net>
Date: Wed, 14 Jan 2009 20:08:04 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: only run 197 on 32-bit machines
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: Christoph Hellwig <hch@infradead.org>

Don't run test 197 on 64-bit machines

If it always passes on 64 bits, this gives a false
sense of security.  Make it obvious.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

diff --git a/197 b/197
index 4c81941..f77bfa2 100644
--- a/197
+++ b/197
@@ -37,6 +37,10 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs xfs
 _supported_os Linux
 
+bitsperlong=`src/feature -w`
+if [ "$bitsperlong" -ne 32 ]; then
+	_notrun "This test is only valid on 32 bit machines"
+fi
 
 mkdir $TEST_DIR/ttt
 for n in {1..168}; do


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
