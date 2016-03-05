Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C2CDA7CBA
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:37:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F578304039
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 16:37:58 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3nQvlMyLXYeq3sVy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 16:37:57 -0800 (PST)
Subject: [PATCH 05/12] xfs/206: fix output when mkfs knows about reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Mar 2016 16:37:50 -0800
Message-ID: <20160305003750.28738.48204.stgit@birch.djwong.org>
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/206     |    1 +
 tests/xfs/206.out |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/tests/xfs/206 b/tests/xfs/206
index 0f5d97d..24e690a 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -80,6 +80,7 @@ mkfs_filter()
 	    -e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/" \
 	    -e "s/, projid32bit=[0-9]//" \
 	    -e "s/ ftype=[0-9]//" \
+	    -e "s/ reflink=[0-9]//" \
 	    -e "s/\(sectsz\)\(=[0-9]* *\)/\1=512   /" \
 	    -e "s/\(sunit=\)\([0-9]* blks,\)/\10 blks,/" \
 	    -e "s/, lazy-count=[0-9]//" \
diff --git a/tests/xfs/206.out b/tests/xfs/206.out
index 2db839d..e73a954 100644
--- a/tests/xfs/206.out
+++ b/tests/xfs/206.out
@@ -12,6 +12,7 @@ realtime =none                   extsz=4096   blocks=0, rtextents=0
 === xfs_growfs ===
 meta-data=FILE isize=N    agcount=52, agsize=76288719 blks
          =                       sectsz=512   attr=2
+         =                      
 data     =                       bsize=4096   blocks=3905982455, imaxpct=5
          =                       sunit=0      swidth=0 blks
 naming   =version 2              bsize=4096   ascii-ci=0
@@ -22,6 +23,7 @@ data blocks changed from 3905982455 to 4882478016
 === xfs_info ===
 meta-data=FILE isize=N    agcount=64, agsize=76288719 blks
          =                       sectsz=512   attr=2
+         =                      
 data     =                       bsize=4096   blocks=4882478016, imaxpct=5
          =                       sunit=0      swidth=0 blks
 naming   =version 2              bsize=4096   ascii-ci=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
