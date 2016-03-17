Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 249B47CA0
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 23:27:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9FE72AC002
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 21:27:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Fjq3cNJeDDmgEbmY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 21:27:54 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v3] xfs/073: ignore mkfs output
Date: Thu, 17 Mar 2016 12:27:45 +0800
Message-Id: <1458188865-14819-1-git-send-email-eguan@redhat.com>
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

Fix it by dumping mkfs output to $seqres.full and updating 073.out
accordingly.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---

v3:
- just ignore mkfs output
v2:
- disable finobt explicitly, instead of filtering the warning

 tests/xfs/073     | 2 +-
 tests/xfs/073.out | 6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/tests/xfs/073 b/tests/xfs/073
index e1335df..9e29223 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -138,7 +138,7 @@ _require_loop
 
 rm -f $seqres.full
 
-_scratch_mkfs_xfs -m crc=0 -dsize=41m,agcount=2 | _filter_mkfs 2>/dev/null
+_scratch_mkfs_xfs -m crc=0 -dsize=41m,agcount=2 >>$seqres.full 2>&1
 _scratch_mount 2>/dev/null || _fail "initial scratch mount failed"
 
 echo
diff --git a/tests/xfs/073.out b/tests/xfs/073.out
index 3f27467..5f36ebe 100644
--- a/tests/xfs/073.out
+++ b/tests/xfs/073.out
@@ -1,10 +1,4 @@
 QA output created by 073
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 === populating scratch device
 1000+0 records in
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
