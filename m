Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C693E7F55
	for <xfs@oss.sgi.com>; Sun,  6 Dec 2015 11:37:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A9E568F8035
	for <xfs@oss.sgi.com>; Sun,  6 Dec 2015 09:37:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wuKE5ZC9CxRfZ9jE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 06 Dec 2015 09:37:44 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 769F2C0B7A0F
	for <xfs@oss.sgi.com>; Sun,  6 Dec 2015 17:37:43 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [XFSTESTS v2 3/6] Rename output file templates to match TEST.out*
Date: Sun,  6 Dec 2015 18:37:28 +0100
Message-Id: <1449423451-29845-4-git-send-email-agruenba@redhat.com>
In-Reply-To: <1449423451-29845-1-git-send-email-agruenba@redhat.com>
References: <1449423451-29845-1-git-send-email-agruenba@redhat.com>
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

Tests with multiple output file variants symlink $TEST_NAME.out to one
of those variants.  For those tests, add $TEST_NAME.out to .gitignore.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 .gitignore                  |  16 ++++
 tests/xfs/033               |   2 +-
 tests/xfs/033.crc.out.linux | 197 --------------------------------------------
 tests/xfs/033.out.crc.linux | 197 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/096               |   4 +-
 tests/xfs/096.external      |  50 -----------
 tests/xfs/096.internal      |  51 ------------
 tests/xfs/096.out.external  |  50 +++++++++++
 tests/xfs/096.out.internal  |  51 ++++++++++++
 9 files changed, 317 insertions(+), 301 deletions(-)
 delete mode 100644 tests/xfs/033.crc.out.linux
 create mode 100644 tests/xfs/033.out.crc.linux
 delete mode 100644 tests/xfs/096.external
 delete mode 100644 tests/xfs/096.internal
 create mode 100644 tests/xfs/096.out.external
 create mode 100644 tests/xfs/096.out.internal

diff --git a/.gitignore b/.gitignore
index 5dc4f69..7c25c41 100644
--- a/.gitignore
+++ b/.gitignore
@@ -195,3 +195,19 @@
 /dmapi/src/suite2/src/test_invis
 /dmapi/src/suite2/src/test_region
 /dmapi/src/suite2/src/test_rights
+
+# Symlinked .out files
+/tests/generic/088.out
+/tests/generic/097.out
+/tests/xfs/022.out
+/tests/xfs/023.out
+/tests/xfs/031.out
+/tests/xfs/033.out
+/tests/xfs/035.out
+/tests/xfs/036.out
+/tests/xfs/039.out
+/tests/xfs/043.out
+/tests/xfs/055.out
+/tests/xfs/071.out
+/tests/xfs/096.out
+/tests/xfs/146.out
diff --git a/tests/xfs/033 b/tests/xfs/033
index 576d437..4163964 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -85,7 +85,7 @@ _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
 
 # link correct .out file
 if [ $_fs_has_crcs -eq 1 ]; then
-	_link_out_file $seq.crc.out $seqfull.out
+	_link_out_file $seq.out.crc $seqfull.out
 else
 	_link_out_file $seq.out $seqfull.out
 fi
diff --git a/tests/xfs/033.crc.out.linux b/tests/xfs/033.crc.out.linux
deleted file mode 100644
index a6e86b9..0000000
--- a/tests/xfs/033.crc.out.linux
+++ /dev/null
@@ -1,197 +0,0 @@
-QA output created by 033
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-Corrupting root inode - setting bits to 0
-Wrote X.XXKb (value 0x0)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-bad magic number 0x0 on inode INO
-bad version number 0x0 on inode INO
-inode identifier 0 mismatch on inode INO
-bad magic number 0x0 on inode INO, resetting magic number
-bad version number 0x0 on inode INO, resetting version number
-inode identifier 0 mismatch on inode INO
-cleared root inode INO
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-root inode lost
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-reinitializing root directory
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-resetting inode INO nlinks from 1 to 2
-done
-Corrupting rt bitmap inode - setting bits to 0
-Wrote X.XXKb (value 0x0)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-bad magic number 0x0 on inode INO
-bad version number 0x0 on inode INO
-inode identifier 0 mismatch on inode INO
-bad magic number 0x0 on inode INO, resetting magic number
-bad version number 0x0 on inode INO, resetting version number
-inode identifier 0 mismatch on inode INO
-cleared realtime bitmap inode INO
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-reinitializing realtime bitmap inode
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-done
-Corrupting rt summary inode - setting bits to 0
-Wrote X.XXKb (value 0x0)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-bad magic number 0x0 on inode INO
-bad version number 0x0 on inode INO
-inode identifier 0 mismatch on inode INO
-bad magic number 0x0 on inode INO, resetting magic number
-bad version number 0x0 on inode INO, resetting version number
-inode identifier 0 mismatch on inode INO
-cleared realtime summary inode INO
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-reinitializing realtime summary inode
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-done
-Corrupting root inode - setting bits to -1
-Wrote X.XXKb (value 0xffffffff)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-bad magic number 0xffff on inode INO
-bad version number 0xffffffff on inode INO
-inode identifier 18446744073709551615 mismatch on inode INO
-bad magic number 0xffff on inode INO, resetting magic number
-bad version number 0xffffffff on inode INO, resetting version number
-inode identifier 18446744073709551615 mismatch on inode INO
-cleared root inode INO
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-root inode lost
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-reinitializing root directory
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-resetting inode INO nlinks from 1 to 2
-done
-Corrupting rt bitmap inode - setting bits to -1
-Wrote X.XXKb (value 0xffffffff)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-bad magic number 0xffff on inode INO
-bad version number 0xffffffff on inode INO
-inode identifier 18446744073709551615 mismatch on inode INO
-bad magic number 0xffff on inode INO, resetting magic number
-bad version number 0xffffffff on inode INO, resetting version number
-inode identifier 18446744073709551615 mismatch on inode INO
-cleared realtime bitmap inode INO
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-reinitializing realtime bitmap inode
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-done
-Corrupting rt summary inode - setting bits to -1
-Wrote X.XXKb (value 0xffffffff)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-bad magic number 0xffff on inode INO
-bad version number 0xffffffff on inode INO
-inode identifier 18446744073709551615 mismatch on inode INO
-bad magic number 0xffff on inode INO, resetting magic number
-bad version number 0xffffffff on inode INO, resetting version number
-inode identifier 18446744073709551615 mismatch on inode INO
-cleared realtime summary inode INO
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-reinitializing realtime summary inode
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-done
diff --git a/tests/xfs/033.out.crc.linux b/tests/xfs/033.out.crc.linux
new file mode 100644
index 0000000..a6e86b9
--- /dev/null
+++ b/tests/xfs/033.out.crc.linux
@@ -0,0 +1,197 @@
+QA output created by 033
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+Corrupting root inode - setting bits to 0
+Wrote X.XXKb (value 0x0)
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+bad magic number 0x0 on inode INO
+bad version number 0x0 on inode INO
+inode identifier 0 mismatch on inode INO
+bad magic number 0x0 on inode INO, resetting magic number
+bad version number 0x0 on inode INO, resetting version number
+inode identifier 0 mismatch on inode INO
+cleared root inode INO
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+root inode lost
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+reinitializing root directory
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+resetting inode INO nlinks from 1 to 2
+done
+Corrupting rt bitmap inode - setting bits to 0
+Wrote X.XXKb (value 0x0)
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+bad magic number 0x0 on inode INO
+bad version number 0x0 on inode INO
+inode identifier 0 mismatch on inode INO
+bad magic number 0x0 on inode INO, resetting magic number
+bad version number 0x0 on inode INO, resetting version number
+inode identifier 0 mismatch on inode INO
+cleared realtime bitmap inode INO
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+reinitializing realtime bitmap inode
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+done
+Corrupting rt summary inode - setting bits to 0
+Wrote X.XXKb (value 0x0)
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+bad magic number 0x0 on inode INO
+bad version number 0x0 on inode INO
+inode identifier 0 mismatch on inode INO
+bad magic number 0x0 on inode INO, resetting magic number
+bad version number 0x0 on inode INO, resetting version number
+inode identifier 0 mismatch on inode INO
+cleared realtime summary inode INO
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+reinitializing realtime summary inode
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+done
+Corrupting root inode - setting bits to -1
+Wrote X.XXKb (value 0xffffffff)
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+bad magic number 0xffff on inode INO
+bad version number 0xffffffff on inode INO
+inode identifier 18446744073709551615 mismatch on inode INO
+bad magic number 0xffff on inode INO, resetting magic number
+bad version number 0xffffffff on inode INO, resetting version number
+inode identifier 18446744073709551615 mismatch on inode INO
+cleared root inode INO
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+root inode lost
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+reinitializing root directory
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+resetting inode INO nlinks from 1 to 2
+done
+Corrupting rt bitmap inode - setting bits to -1
+Wrote X.XXKb (value 0xffffffff)
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+bad magic number 0xffff on inode INO
+bad version number 0xffffffff on inode INO
+inode identifier 18446744073709551615 mismatch on inode INO
+bad magic number 0xffff on inode INO, resetting magic number
+bad version number 0xffffffff on inode INO, resetting version number
+inode identifier 18446744073709551615 mismatch on inode INO
+cleared realtime bitmap inode INO
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+reinitializing realtime bitmap inode
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+done
+Corrupting rt summary inode - setting bits to -1
+Wrote X.XXKb (value 0xffffffff)
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+bad magic number 0xffff on inode INO
+bad version number 0xffffffff on inode INO
+inode identifier 18446744073709551615 mismatch on inode INO
+bad magic number 0xffff on inode INO, resetting magic number
+bad version number 0xffffffff on inode INO, resetting version number
+inode identifier 18446744073709551615 mismatch on inode INO
+cleared realtime summary inode INO
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+reinitializing realtime summary inode
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+done
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
