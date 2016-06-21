Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 926817CA1
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 07:02:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6186F304032
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 05:02:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VAE7BjvyJhz7PJ9J (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 21 Jun 2016 05:02:55 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs/186: run test on expected XFS configuration
Date: Tue, 21 Jun 2016 20:01:47 +0800
Message-Id: <1466510507-17548-1-git-send-email-eguan@redhat.com>
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
To: fstests@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

Usually xfs/186 _notrun on crc enabled XFS because of
_require_attr_v1, since v2 attr format is always enabled on v5 XFS.

But when testing on 512B block size XFS, i.e. MKFS_OPTIONS="-m crc=0
-b size=512", test fails. This is because crc enalbed XFS was
created in the end, not 512B block size XFS with crc disabled, and
that's not what we want to test.

The reason why _scratch_mkfs_xfs creates a different XFS than
expected is that, it may ignore $MKFS_OPTIONS if mkfs fails due to
conflicts between $MKFS_OPTIONS and the provided mkfs options.

In the case of xfs/186, "-b size=512" conflicts with "-i size=512",
and the first mkfs fails, then it ends up with a 4k block size XFS
with crc enabled (the default config).

Fix it by checking crc enablement status and attr version in the
test, to make sure it's testing on expected XFS.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/xfs/186 | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/186 b/tests/xfs/186
index 9b64d6c..192a8c8 100755
--- a/tests/xfs/186
+++ b/tests/xfs/186
@@ -156,7 +156,20 @@ _require_attr_v1
 
 rm -f $seqres.full
 
-_scratch_mkfs -i attr=2,size=512 -l lazy-count=1 >/dev/null 2>&1
+_scratch_mkfs -i attr=2,size=512 -l lazy-count=1 | _filter_mkfs \
+	>>$seqres.full 2>$tmp.mkfs
+# import crc status and attr version
+. $tmp.mkfs
+
+# _scratch_mkfs may ignore $MKFS_OPTIONS if mkfs fails due to conflicts between
+# $MKFS_OPTIONS and the provided mkfs options, which could result in creating
+# an XFS we don't want. Check crc status and attr version to be sure.
+if [ $_fs_has_crcs -eq 1 ]; then
+	_notrun "attr v1 not supported on $SCRATCH_DEV"
+fi
+if [ $attr -ne 2 ]; then
+	_notrun "need attr v2 on $SCRATCH_DEV"
+fi
 
 # set inum to root dir ino
 # we'll add in dirents and EAs into the root directory
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
