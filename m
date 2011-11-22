Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM6F2no122803 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 00:15:02 -0600
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 369EB26AEF7
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 22:15:00 -0800 (PST)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id HTSWWwEX7UlWXOPH for
	<xfs@oss.sgi.com>; Mon, 21 Nov 2011 22:15:00 -0800 (PST)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id D87A03EE0B6
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 15:14:58 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id BA75745DEB4
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 15:14:58 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id A11D145DEB3
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 15:14:58 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 942DF1DB8038
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 15:14:58 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.240.81.145])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 59C2A1DB8046
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 15:14:58 +0900 (JST)
Message-ID: <4ECB3DCA.5000509@jp.fujitsu.com>
Date: Tue, 22 Nov 2011 15:14:34 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] 198, 240: check presence of aiodio_sparce2
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Use same trick with:
  commit 4e9072472fbc56b9d4c8ee8094cc62ce793df9b7
  Gracefully fail aio tests if they weren't built

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 198 |    5 ++++-
 240 |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/198 b/198
index e46ec8d..60db6dc 100755
--- a/198
+++ b/198
@@ -45,13 +45,16 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+AIO_TEST=src/aio-dio-regress/aiodio_sparse2
+[ -x $here/$AIO_TEST ] || _notrun "$AIO_TEST not built"
+
 echo "Silence is golden."
 
 # real QA test starts here
 rm -f $seq.full
 
 rm -f "$TEST_DIR/aiodio_sparse*"
-$here/src/aio-dio-regress/aiodio_sparse2 "$TEST_DIR/aiodio_sparse"
+$here/$AIO_TEST "$TEST_DIR/aiodio_sparse"
 
 status=$?
 exit
diff --git a/240 b/240
index 563449e..22c1756 100755
--- a/240
+++ b/240
@@ -53,6 +53,9 @@ _supported_os Linux
 
 _require_sparse_files
 
+AIO_TEST=src/aio-dio-regress/aiodio_sparse2
+[ -x $here/$AIO_TEST ] || _notrun "$AIO_TEST not built"
+
 echo "Silence is golden."
 
 # real QA test starts here
@@ -69,7 +72,7 @@ fi
 
 # 2 threads, fs block sized writes, 64k filesize, stride through file by
 # fs block size, start at logical block size offset
-$here/src/aio-dio-regress/aiodio_sparse2 -i 2 -w $fs_block_size -s 64k -n $fs_block_size -o $logical_block_size "$TEST_DIR/aiodio_sparse"
+$here/$AIO_TEST -i 2 -w $fs_block_size -s 64k -n $fs_block_size -o $logical_block_size "$TEST_DIR/aiodio_sparse"
 
 status=$?
 exit
-- 
1.7.7.3


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
