Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3LK2uYW150226 for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 15:02:56 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E700B135A8BC
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 13:05:31 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id PcZSKP44Cfjv0AdM for <xfs@oss.sgi.com>;
	Tue, 21 Apr 2009 13:05:31 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n3LK2kJw011185
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 16:02:46 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3LK2jKM010981
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 16:02:46 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n3LK2i9o011662
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 16:02:45 -0400
Message-ID: <49EE2664.7030701@sandeen.net>
Date: Tue, 21 Apr 2009 15:02:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: filter out imaxpct value in test 096
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
To: xfs mailing list <xfs@oss.sgi.com>

xfstests: filter out imaxpct value in test 096

On large filesystems, imaxpc drops from 25 to 5

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

iff --git a/096 b/096
index 369d95d..a0560b1 100755
--- a/096
+++ b/096
@@ -55,6 +55,7 @@ _mkfs_filter()
    sed \
 	-e 's/extsz=[0-9][0-9]*[ ]*/extsz=N, /' \
 	-e 's/blocks=[0-9][0-9]*/blocks=N/' \
+	-e 's/imaxpct=[0-9][0-9]*/imaxpct=N/' \
 	-e 's/agsize=[0-9][0-9]*/agsize=N/' \
 	-e 's/agcount=[0-9][0-9]*/agcount=N/' \
         -e 's/swidth=[0-9][0-9]* blks$/&, unwritten=1/' \
diff --git a/096.external b/096.external
index 7d68373..989a7bd 100644
--- a/096.external
+++ b/096.external
@@ -10,7 +10,7 @@ log stripe unit (262656) must be a multiple of the block size (4096)
 log stripe unit (266240 bytes) is too large (maximum is 256KiB)
 log stripe unit adjusted to 32KiB
 meta-data=DEV isize=256    agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=25
+data     =                       bsize=4096   blocks=N, imaxpct=N
          =                       sunit=0      swidth=0 blks, unwritten=1
 naming   =version 2              bsize=4096
 log      =LOG                    bsize=4096   blocks=N, version=2
@@ -21,7 +21,7 @@ realtime =REALTIME               extsz=N, blocks=N, rtextents=N
 # same test but get log stripe from data stripe
 --- mkfs=-l version=2 -d su=266240,sw=1 ---
 meta-data=DEV isize=256    agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=25
+data     =                       bsize=4096   blocks=N, imaxpct=N
          =                       sunit=65     swidth=65 blks, unwritten=1
 naming   =version 2              bsize=4096
 log      =LOG                    bsize=4096   blocks=N, version=2
@@ -32,7 +32,7 @@ realtime =REALTIME               extsz=N, blocks=N, rtextents=N
 # test out data stripe
 --- mkfs=-d su=266240,sw=1 ---
 meta-data=DEV isize=256    agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=25
+data     =                       bsize=4096   blocks=N, imaxpct=N
          =                       sunit=65     swidth=65 blks, unwritten=1
 naming   =version 2              bsize=4096
 log      =LOG                    bsize=4096   blocks=N, version=1
@@ -43,7 +43,7 @@ realtime =REALTIME               extsz=N, blocks=N, rtextents=N
 # test out data stripe the same but using sunit & swidth
 --- mkfs=-d sunit=520,swidth=520 ---
 meta-data=DEV isize=256    agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=25
+data     =                       bsize=4096   blocks=N, imaxpct=N
          =                       sunit=65     swidth=65 blks, unwritten=1
 naming   =version 2              bsize=4096
 log      =LOG                    bsize=4096   blocks=N, version=1
diff --git a/096.internal b/096.internal
index e0e1ee4..cf75037 100644
--- a/096.internal
+++ b/096.internal
@@ -10,7 +10,7 @@ log stripe unit (262656) must be a multiple of the block size (4096)
 log stripe unit (266240 bytes) is too large (maximum is 256KiB)
 log stripe unit adjusted to 32KiB
 meta-data=DEV isize=256    agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=25
+data     =                       bsize=4096   blocks=N, imaxpct=N
          =                       sunit=0      swidth=0 blks, unwritten=1
 naming   =version 2              bsize=4096
 log      =LOG                    bsize=4096   blocks=N, version=2
@@ -23,7 +23,7 @@ realtime =REALTIME               extsz=N, blocks=N, rtextents=N
 log stripe unit (266240 bytes) is too large (maximum is 256KiB)
 log stripe unit adjusted to 32KiB
 meta-data=DEV isize=256    agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=25
+data     =                       bsize=4096   blocks=N, imaxpct=N
          =                       sunit=65     swidth=65 blks, unwritten=1
 naming   =version 2              bsize=4096
 log      =LOG                    bsize=4096   blocks=N, version=2
@@ -34,7 +34,7 @@ realtime =REALTIME               extsz=N, blocks=N, rtextents=N
 # test out data stripe
 --- mkfs=-l version=1 -d su=266240,sw=1 ---
 meta-data=DEV isize=256    agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=25
+data     =                       bsize=4096   blocks=N, imaxpct=N
          =                       sunit=65     swidth=65 blks, unwritten=1
 naming   =version 2              bsize=4096
 log      =LOG                    bsize=4096   blocks=N, version=1
@@ -45,7 +45,7 @@ realtime =REALTIME               extsz=N, blocks=N, rtextents=N
 # test out data stripe the same but using sunit & swidth
 --- mkfs=-l version=1 -d sunit=520,swidth=520 ---
 meta-data=DEV isize=256    agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=25
+data     =                       bsize=4096   blocks=N, imaxpct=N
          =                       sunit=65     swidth=65 blks, unwritten=1
 naming   =version 2              bsize=4096
 log      =LOG                    bsize=4096   blocks=N, version=1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
