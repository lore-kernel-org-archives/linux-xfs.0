Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6S8S4id246812 for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 03:28:04 -0500
Received: from ysabell.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A8D31D8E8EB
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 01:28:02 -0700 (PDT)
Received: from ysabell.rzone.de (ysabell.rzone.de [81.169.144.237]) by
	cuda.sgi.com with ESMTP id PXh5v004pkotbujo for
	<xfs@oss.sgi.com>; Thu, 28 Jul 2011 01:28:02 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 3/4] xfstests: Add support for btrfs in 015
Date: Thu, 28 Jul 2011 10:28:00 +0200
Message-Id: <bebfc5c98e0fb878f55c1312d8750ce7b7f82e07.1311776403.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1311776403.git.sbehrens@giantdisaster.de>
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
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

Added btrfs to the list of supported filesystems for test 015, and
increased free space reporting tolerance to 10% for btrfs.
Replaced the call to _scratch_mkfs_xfs with the XFS specific size
parameter by the generic one for sized filesystem creation which is
_scratch_mkfs_sized.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 015 |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/015 b/015
index 8f2be7c..7020e67 100755
--- a/015
+++ b/015
@@ -48,13 +48,13 @@ _free()
 }
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs xfs btrfs
 _supported_os IRIX Linux
 
 _require_scratch
 _require_nobigloopfs
 
-_scratch_mkfs_xfs -d size=50m >/dev/null || _fail "mkfs failed"
+_scratch_mkfs_sized `expr 50 \* 1024 \* 1024` >/dev/null || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
 out=$SCRATCH_MNT/fillup.$$
 rm -f $seq.full
@@ -120,7 +120,12 @@ fi
 echo "free space after delete $free2" >> $seq.full
 
 echo -n "   !!! "
-_within_tolerance "free space" $free2 $free0 1% -v
+if [ $FSTYP = btrfs ]
+then
+	_within_tolerance "free space" $free2 $free0 10% -v
+else
+	_within_tolerance "free space" $free2 $free0 1% -v
+fi
 
 status=0
 exit
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
