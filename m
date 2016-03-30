Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 924DF7CB0
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 02:57:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 51081304062
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 00:57:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KbqQ0GELgPV8FD4C (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2016 00:57:07 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs/206: filter out reflink related outputs
Date: Wed, 30 Mar 2016 15:56:49 +0800
Message-Id: <1459324609-5531-1-git-send-email-eguan@redhat.com>
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
Cc: darrick.wong@oracle.com, Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

Commit 13717ffc96fe ("xfs/206: fix output when mkfs knows about
reflink") added extra lines to xfs/206.out to fit the mkfs output with
reflink support, but broke tests without reflink support.

Fix it by filtering out reflink related outputs, just like filtering out
crc related outputs in the test.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---

Tested with v4.5 xfsprogs as well as Darrick's xfsprogs (for-dave-for-4.6
branch) with reflink support.

https://github.com/djwong/xfsprogs.git

 tests/xfs/206     | 2 +-
 tests/xfs/206.out | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tests/xfs/206 b/tests/xfs/206
index 24e690a..d549a4c 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -80,7 +80,7 @@ mkfs_filter()
 	    -e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/" \
 	    -e "s/, projid32bit=[0-9]//" \
 	    -e "s/ ftype=[0-9]//" \
-	    -e "s/ reflink=[0-9]//" \
+	    -e "/.*reflink=/d" \
 	    -e "s/\(sectsz\)\(=[0-9]* *\)/\1=512   /" \
 	    -e "s/\(sunit=\)\([0-9]* blks,\)/\10 blks,/" \
 	    -e "s/, lazy-count=[0-9]//" \
diff --git a/tests/xfs/206.out b/tests/xfs/206.out
index e73a954..2db839d 100644
--- a/tests/xfs/206.out
+++ b/tests/xfs/206.out
@@ -12,7 +12,6 @@ realtime =none                   extsz=4096   blocks=0, rtextents=0
 === xfs_growfs ===
 meta-data=FILE isize=N    agcount=52, agsize=76288719 blks
          =                       sectsz=512   attr=2
-         =                      
 data     =                       bsize=4096   blocks=3905982455, imaxpct=5
          =                       sunit=0      swidth=0 blks
 naming   =version 2              bsize=4096   ascii-ci=0
@@ -23,7 +22,6 @@ data blocks changed from 3905982455 to 4882478016
 === xfs_info ===
 meta-data=FILE isize=N    agcount=64, agsize=76288719 blks
          =                       sectsz=512   attr=2
-         =                      
 data     =                       bsize=4096   blocks=4882478016, imaxpct=5
          =                       sunit=0      swidth=0 blks
 naming   =version 2              bsize=4096   ascii-ci=0
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
