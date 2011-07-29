Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6TG74Mt053773 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 11:07:04 -0500
Received: from mort.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90950A5EBF
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 09:07:03 -0700 (PDT)
Received: from mort.rzone.de (mort.rzone.de [81.169.144.234]) by cuda.sgi.com
	with ESMTP id MdVDQOeDgRiJve2k for <xfs@oss.sgi.com>;
	Fri, 29 Jul 2011 09:07:03 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v2 1/4] xfstests: Changed test 062 to be generic for all
	filesystems
Date: Fri, 29 Jul 2011 18:06:58 +0200
Message-Id: <95dfa968c48d2bd1095876a6db3369672e76db5f.1311953979.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1311953979.git.sbehrens@giantdisaster.de>
References: <cover.1311953979.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1311953979.git.sbehrens@giantdisaster.de>
References: <cover.1311953979.git.sbehrens@giantdisaster.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Changed the test 062 to be generic for all filesystems and to be
executed for all filesystems.
Remove output of mkfs since this is specific to mkfs.xfs and now
filtered out.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 062     |    4 ++--
 062.out |    6 ------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/062 b/062
index 5cb6f92..a6e4bc8 100755
--- a/062
+++ b/062
@@ -71,7 +71,7 @@ _create_test_bed()
 }
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux
 
 _require_scratch
@@ -80,7 +80,7 @@ _require_attrs
 rm -f $tmp.backup1 $tmp.backup2 $seq.full
 
 # real QA test starts here
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
 _create_test_bed
 
diff --git a/062.out b/062.out
index 73fd628..1d5a094 100644
--- a/062.out
+++ b/062.out
@@ -1,10 +1,4 @@
 QA output created by 062
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 *** create test bed
 SCRATCH_MNT
 SCRATCH_MNT/dev
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
