Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EF5E37CA6
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 06:06:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 42A15AC004
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 04:06:47 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QlDoEiMOmUHKfTMr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Mar 2016 04:06:45 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id EB5C98E3CF
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 12:06:44 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [XFSTESTS v4 1/4] Rename output file templates to match TEST.out*
Date: Wed,  9 Mar 2016 13:06:35 +0100
Message-Id: <1457525199-15355-2-git-send-email-agruenba@redhat.com>
In-Reply-To: <1457525199-15355-1-git-send-email-agruenba@redhat.com>
References: <1457525199-15355-1-git-send-email-agruenba@redhat.com>
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
To: xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Rename the expected output files so that they all match "$TEST_NAME.out*".
That way, we can statically check if a test has any .out* files.

Add $TEST_NAME.out and similar symlinks to .gitignore.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 .gitignore                 | 19 +++++++++++++++++
 tests/xfs/096              |  4 ++--
 tests/xfs/096.external     | 50 ---------------------------------------------
 tests/xfs/096.internal     | 51 ----------------------------------------------
 tests/xfs/096.out.external | 50 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/096.out.internal | 51 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 122 insertions(+), 103 deletions(-)
 delete mode 100644 tests/xfs/096.external
 delete mode 100644 tests/xfs/096.internal
 create mode 100644 tests/xfs/096.out.external
 create mode 100644 tests/xfs/096.out.internal

diff --git a/.gitignore b/.gitignore
index 28fa205..f9ea1fa 100644
--- a/.gitignore
+++ b/.gitignore
@@ -199,3 +199,22 @@
 /dmapi/src/suite2/src/test_invis
 /dmapi/src/suite2/src/test_region
 /dmapi/src/suite2/src/test_rights
+
+# Symlinked files
+/tests/generic/088.out
+/tests/generic/097.out
+/tests/xfs/018.op
+/tests/xfs/022.out
+/tests/xfs/023.out
+/tests/xfs/030.out
+/tests/xfs/031.out
+/tests/xfs/033.out
+/tests/xfs/035.out
+/tests/xfs/036.out
+/tests/xfs/039.out
+/tests/xfs/043.out
+/tests/xfs/055.out
+/tests/xfs/071.out
+/tests/xfs/082.op
+/tests/xfs/096.out
+/tests/xfs/146.out
diff --git a/tests/xfs/096 b/tests/xfs/096
index c289c10..f949e83 100755
--- a/tests/xfs/096
+++ b/tests/xfs/096
@@ -109,9 +109,9 @@ _require_v2log
 # choose .out file based on internal/external log
 rm -f $seqfull.out
 if [ "$USE_EXTERNAL" = yes ]; then
-	ln -s $seq.external $seqfull.out
+	ln -s $seq.out.external $seqfull.out
 else
-	ln -s $seq.internal $seqfull.out
+	ln -s $seq.out.internal $seqfull.out
 fi
 
 # maximum log record size
diff --git a/tests/xfs/096.external b/tests/xfs/096.external
deleted file mode 100644
index 3122330..0000000
--- a/tests/xfs/096.external
+++ /dev/null
@@ -1,50 +0,0 @@
-QA output created by 096
-
-# su too big but must be a multiple of fs block size too
---- mkfs=-l version=2,su=262656 ---
-log stripe unit (262656) must be a multiple of the block size (4096)
-
-
-# test log stripe greater than LR size
---- mkfs=-l version=2,su=266240 ---
-meta-data=DEV isize=N      agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=N
-         =                       sunit=0      swidth=0 blks, unwritten=1
-naming   =version 2              bsize=4096
-log      =LOG                    bsize=4096   blocks=N, version=N
-realtime =REALTIME               extsz=N, blocks=N, rtextents=N
-
-
-# same test but get log stripe from data stripe
---- mkfs=-l version=2 -d su=266240,sw=1 ---
-meta-data=DEV isize=N      agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=N
-         =                       sunit=65     swidth=65 blks, unwritten=1
-naming   =version 2              bsize=4096
-log      =LOG                    bsize=4096   blocks=N, version=N
-         =                       sunit=N blks
-realtime =REALTIME               extsz=N, blocks=N, rtextents=N
-
-
-# test out data stripe
---- mkfs=-m crc=0 -l version=1 -d su=266240,sw=1 ---
-meta-data=DEV isize=N      agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=N
-         =                       sunit=65     swidth=65 blks, unwritten=1
-naming   =version 2              bsize=4096
-log      =LOG                    bsize=4096   blocks=N, version=N
-         =                       sunit=N blks
-realtime =REALTIME               extsz=N, blocks=N, rtextents=N
-
-
-# test out data stripe the same but using sunit & swidth
---- mkfs=-m crc=0 -l version=1 -d sunit=520,swidth=520 ---
-meta-data=DEV isize=N      agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=N
-         =                       sunit=65     swidth=65 blks, unwritten=1
-naming   =version 2              bsize=4096
-log      =LOG                    bsize=4096   blocks=N, version=N
-         =                       sunit=N blks
-realtime =REALTIME               extsz=N, blocks=N, rtextents=N
-
-
diff --git a/tests/xfs/096.internal b/tests/xfs/096.internal
deleted file mode 100644
index 80201d2..0000000
--- a/tests/xfs/096.internal
+++ /dev/null
@@ -1,51 +0,0 @@
-QA output created by 096
-
-# su too big but must be a multiple of fs block size too
---- mkfs=-l version=2,su=262656 ---
-log stripe unit (262656) must be a multiple of the block size (4096)
-
-
-# test log stripe greater than LR size
---- mkfs=-l version=2,su=266240 ---
-meta-data=DEV isize=N    agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=N
-         =                       sunit=0      swidth=0 blks, unwritten=1
-naming   =version 2              bsize=4096
-log      =LOG                    bsize=4096   blocks=N, version=N
-         =                       sunit=N blks
-realtime =REALTIME               extsz=N, blocks=N, rtextents=N
-
-
-# same test but get log stripe from data stripe
---- mkfs=-l version=2 -d su=266240,sw=1 ---
-meta-data=DEV isize=N    agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=N
-         =                       sunit=65     swidth=65 blks, unwritten=1
-naming   =version 2              bsize=4096
-log      =LOG                    bsize=4096   blocks=N, version=N
-         =                       sunit=N blks
-realtime =REALTIME               extsz=N, blocks=N, rtextents=N
-
-
-# test out data stripe
---- mkfs=-m crc=0 -l version=1 -d su=266240,sw=1 ---
-meta-data=DEV isize=N    agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=N
-         =                       sunit=65     swidth=65 blks, unwritten=1
-naming   =version 2              bsize=4096
-log      =LOG                    bsize=4096   blocks=N, version=N
-         =                       sunit=N blks
-realtime =REALTIME               extsz=N, blocks=N, rtextents=N
-
-
-# test out data stripe the same but using sunit & swidth
---- mkfs=-m crc=0 -l version=1 -d sunit=520,swidth=520 ---
-meta-data=DEV isize=N    agcount=N, agsize=N blks
-data     =                       bsize=4096   blocks=N, imaxpct=N
-         =                       sunit=65     swidth=65 blks, unwritten=1
-naming   =version 2              bsize=4096
-log      =LOG                    bsize=4096   blocks=N, version=N
-         =                       sunit=N blks
-realtime =REALTIME               extsz=N, blocks=N, rtextents=N
-
-
diff --git a/tests/xfs/096.out.external b/tests/xfs/096.out.external
new file mode 100644
index 0000000..3122330
--- /dev/null
+++ b/tests/xfs/096.out.external
@@ -0,0 +1,50 @@
+QA output created by 096
+
+# su too big but must be a multiple of fs block size too
+--- mkfs=-l version=2,su=262656 ---
+log stripe unit (262656) must be a multiple of the block size (4096)
+
+
+# test log stripe greater than LR size
+--- mkfs=-l version=2,su=266240 ---
+meta-data=DEV isize=N      agcount=N, agsize=N blks
+data     =                       bsize=4096   blocks=N, imaxpct=N
+         =                       sunit=0      swidth=0 blks, unwritten=1
+naming   =version 2              bsize=4096
+log      =LOG                    bsize=4096   blocks=N, version=N
+realtime =REALTIME               extsz=N, blocks=N, rtextents=N
+
+
+# same test but get log stripe from data stripe
+--- mkfs=-l version=2 -d su=266240,sw=1 ---
+meta-data=DEV isize=N      agcount=N, agsize=N blks
+data     =                       bsize=4096   blocks=N, imaxpct=N
+         =                       sunit=65     swidth=65 blks, unwritten=1
+naming   =version 2              bsize=4096
+log      =LOG                    bsize=4096   blocks=N, version=N
+         =                       sunit=N blks
+realtime =REALTIME               extsz=N, blocks=N, rtextents=N
+
+
+# test out data stripe
+--- mkfs=-m crc=0 -l version=1 -d su=266240,sw=1 ---
+meta-data=DEV isize=N      agcount=N, agsize=N blks
+data     =                       bsize=4096   blocks=N, imaxpct=N
+         =                       sunit=65     swidth=65 blks, unwritten=1
+naming   =version 2              bsize=4096
+log      =LOG                    bsize=4096   blocks=N, version=N
+         =                       sunit=N blks
+realtime =REALTIME               extsz=N, blocks=N, rtextents=N
+
+
+# test out data stripe the same but using sunit & swidth
+--- mkfs=-m crc=0 -l version=1 -d sunit=520,swidth=520 ---
+meta-data=DEV isize=N      agcount=N, agsize=N blks
+data     =                       bsize=4096   blocks=N, imaxpct=N
+         =                       sunit=65     swidth=65 blks, unwritten=1
+naming   =version 2              bsize=4096
+log      =LOG                    bsize=4096   blocks=N, version=N
+         =                       sunit=N blks
+realtime =REALTIME               extsz=N, blocks=N, rtextents=N
+
+
diff --git a/tests/xfs/096.out.internal b/tests/xfs/096.out.internal
new file mode 100644
index 0000000..80201d2
--- /dev/null
+++ b/tests/xfs/096.out.internal
@@ -0,0 +1,51 @@
+QA output created by 096
+
+# su too big but must be a multiple of fs block size too
+--- mkfs=-l version=2,su=262656 ---
+log stripe unit (262656) must be a multiple of the block size (4096)
+
+
+# test log stripe greater than LR size
+--- mkfs=-l version=2,su=266240 ---
+meta-data=DEV isize=N    agcount=N, agsize=N blks
+data     =                       bsize=4096   blocks=N, imaxpct=N
+         =                       sunit=0      swidth=0 blks, unwritten=1
+naming   =version 2              bsize=4096
+log      =LOG                    bsize=4096   blocks=N, version=N
+         =                       sunit=N blks
+realtime =REALTIME               extsz=N, blocks=N, rtextents=N
+
+
+# same test but get log stripe from data stripe
+--- mkfs=-l version=2 -d su=266240,sw=1 ---
+meta-data=DEV isize=N    agcount=N, agsize=N blks
+data     =                       bsize=4096   blocks=N, imaxpct=N
+         =                       sunit=65     swidth=65 blks, unwritten=1
+naming   =version 2              bsize=4096
+log      =LOG                    bsize=4096   blocks=N, version=N
+         =                       sunit=N blks
+realtime =REALTIME               extsz=N, blocks=N, rtextents=N
+
+
+# test out data stripe
+--- mkfs=-m crc=0 -l version=1 -d su=266240,sw=1 ---
+meta-data=DEV isize=N    agcount=N, agsize=N blks
+data     =                       bsize=4096   blocks=N, imaxpct=N
+         =                       sunit=65     swidth=65 blks, unwritten=1
+naming   =version 2              bsize=4096
+log      =LOG                    bsize=4096   blocks=N, version=N
+         =                       sunit=N blks
+realtime =REALTIME               extsz=N, blocks=N, rtextents=N
+
+
+# test out data stripe the same but using sunit & swidth
+--- mkfs=-m crc=0 -l version=1 -d sunit=520,swidth=520 ---
+meta-data=DEV isize=N    agcount=N, agsize=N blks
+data     =                       bsize=4096   blocks=N, imaxpct=N
+         =                       sunit=65     swidth=65 blks, unwritten=1
+naming   =version 2              bsize=4096
+log      =LOG                    bsize=4096   blocks=N, version=N
+         =                       sunit=N blks
+realtime =REALTIME               extsz=N, blocks=N, rtextents=N
+
+
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
