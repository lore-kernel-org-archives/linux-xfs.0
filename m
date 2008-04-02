Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 22:34:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m325YMgp030991
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 22:34:26 -0700
Date: Wed, 2 Apr 2008 15:34:51 +1000
From: David Chinner <dgc@sgi.com>
Subject: [Patch] xfsqa: 091 needs to support sector size != 512 bytes
Message-ID: <20080402053451.GE103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Test 091 assumes a direct I/O alignment of 512 bytes,
a hold over from 2.4 kernels. On 2.6. kernels, direct
I/O needs to be aligned to the sector size the filesystem
was mkfs'd with.

Teach 091 about 2.6 kernels and grab the sector size from the
xfs_info output.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfstests/091 |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: xfs-cmds/xfstests/091
===================================================================
--- xfs-cmds.orig/xfstests/091	2007-03-19 08:49:37.000000000 +1100
+++ xfs-cmds/xfstests/091	2008-04-02 15:27:39.266824430 +1000
@@ -43,10 +43,20 @@ run_fsx()
 
 psize=`$here/src/feature -s`
 bsize=512
-# 2.4 Linux kernels support bsize aligned direct I/O only
 kernel=`uname -r  | sed -e 's/\(2\..\).*/\1/'`
+
+# 2.4 Linux kernels support bsize aligned direct I/O only
 [ "$HOSTOS" = "Linux" -a "$kernel" = "2.4" ] && bsize=$psize
 
+# 2.6 Linux kernels support sector aligned direct I/O only
+if [ "$HOSTOS" = "Linux" -a "$kernel" = "2.6" ]; then
+	xfs_info $TEST_DIR | _filter_mkfs 2> $tmp.info
+	if [ $? -eq 0 ]; then
+		source $tmp.info
+		bsize=$sectsz
+	fi
+fi
+
 # fsx usage:
 # 
 # -N numops: total # operations to do 
