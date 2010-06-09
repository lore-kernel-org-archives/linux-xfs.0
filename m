Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o593Phs7252009 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 22:25:43 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15C5396CFFD
	for <xfs@oss.sgi.com>; Tue,  8 Jun 2010 20:31:12 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id u5c9O5RUnwp8tnC5 for
	<xfs@oss.sgi.com>; Tue, 08 Jun 2010 20:31:12 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 3DAD54968903
	for <xfs@oss.sgi.com>; Tue,  8 Jun 2010 22:28:12 -0500 (CDT)
Message-ID: <4C0F0A4C.7050600@sandeen.net>
Date: Tue, 08 Jun 2010 22:28:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests 217: remove file in between mkfs's
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

217 requires a 2G scratch:

_require_fs_space $SCRATCH_MNT 2202000

but as we mkfs different sizes, we actually are filling in the
sparse loopback more and more, and 3.8G isn't enough to contain it.

If we remove & recreate the file between mkfs's it doesn't take
so much space ... I don't think it adds significantly to test time.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/217 b/217
index 19540ad..ed86a51 100755
--- a/217
+++ b/217
@@ -60,6 +60,9 @@ LOOP_MNT=$SCRATCH_MNT/test_fs_dir
 _do_mkfs()
 {
 	for i in $*; do
+		# make large holey file
+		rm -f $LOOP_DEV
+		$XFS_IO_PROG -f -c "truncate 16383g" $LOOP_DEV
 		echo -n "fssize=${i}g "
 		$MKFS_XFS_PROG -f -b size=4096 -l version=2 \
 			-d name=$LOOP_DEV,size=${i}g |grep log

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
