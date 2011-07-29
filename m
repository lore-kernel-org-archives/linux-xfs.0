Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6TG737p053748 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 11:07:03 -0500
Received: from ysabell.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E42BE11F803D
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 09:07:24 -0700 (PDT)
Received: from ysabell.rzone.de (ysabell.rzone.de [81.169.144.237]) by
	cuda.sgi.com with ESMTP id yvIGhfwZjwCaNqHO for
	<xfs@oss.sgi.com>; Fri, 29 Jul 2011 09:07:24 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v2 3/4] xfstests: Changed test 015 to be generic for all
	filesystems
Date: Fri, 29 Jul 2011 18:07:00 +0200
Message-Id: <9fac26922ffbfbfb153818a3cbfb97d17ff42176.1311953979.git.sbehrens@giantdisaster.de>
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

Changed the test 015 to be generic for all filesystems and to be
executed for all filesystems.
Replaced the call to _scratch_mkfs_xfs with the XFS specific size
parameter by the generic one for sized filesystem creation which is
_scratch_mkfs_sized.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 015 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/015 b/015
index 8f2be7c..686a211 100755
--- a/015
+++ b/015
@@ -48,13 +48,13 @@ _free()
 }
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _require_scratch
 _require_nobigloopfs
 
-_scratch_mkfs_xfs -d size=50m >/dev/null || _fail "mkfs failed"
+_scratch_mkfs_sized `expr 50 \* 1024 \* 1024` >/dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
 out=$SCRATCH_MNT/fillup.$$
 rm -f $seq.full
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
