Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4BF4B7CF3
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 06:54:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B3EBFAC004
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 04:54:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id c5Lpor2fCfyhpP8B (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 04:54:03 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs/073: filter out finobt warning from mkfs.xfs
Date: Wed, 16 Mar 2016 19:53:24 +0800
Message-Id: <1458129204-31882-1-git-send-email-eguan@redhat.com>
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

When testing xfs/073 with MKFS_OPTIONS="-m crc=1,finobt=1" set, it fails
due to extra warning about disabling finobt feature:

 +warning: finobt not supported without CRC support, disabled.

Because xfs/073 disables crc unconditionally and finobt can not be
enabled either.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/xfs/073 | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/073 b/tests/xfs/073
index e1335df..909231b 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -61,6 +61,11 @@ _filter_path()
 	sed -e "s,$1,<MNTPATH>,g" | LC_COLLATE=POSIX sort
 }
 
+filter_finobt_warn()
+{
+	sed -e "s/warning: finobt .*without CRC.*disabled.//"
+}
+
 _populate_scratch()
 {
 	POSIXLY_CORRECT=yes \
@@ -138,7 +143,8 @@ _require_loop
 
 rm -f $seqres.full
 
-_scratch_mkfs_xfs -m crc=0 -dsize=41m,agcount=2 | _filter_mkfs 2>/dev/null
+_scratch_mkfs_xfs -m crc=0 -dsize=41m,agcount=2 2>&1 | filter_finobt_warn | \
+	_filter_mkfs 2>/dev/null
 _scratch_mount 2>/dev/null || _fail "initial scratch mount failed"
 
 echo
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
