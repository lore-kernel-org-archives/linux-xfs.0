Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J8xg6C178085 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 02:59:42 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B79B11F9772
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:00:38 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	L0EUUYmZeaGSJfiD for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 01:00:38 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11648319-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:30:35 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX9ww-0003fq-3s
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 20:00:34 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX9wv-00082Q-9d
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 20:00:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: Convert all tests to use /bin/bash
Date: Tue, 19 Jan 2010 20:00:33 +1100
Message-Id: <1263891633-30868-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

While most tests use /bin/sh, they are dependent on /bin/sh being a
bash shell.  Convert all the tests to execute via /bin/bash as it is
much, much simpler than trying to debug and remove all the bashisms
throughout the test code.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 001                |    2 +-
 002                |    2 +-
 003                |    2 +-
 004                |    2 +-
 005                |    2 +-
 006                |    2 +-
 007                |    2 +-
 008                |    2 +-
 009                |    2 +-
 010                |    2 +-
 011                |    2 +-
 012                |    2 +-
 013                |    2 +-
 014                |    2 +-
 015                |    2 +-
 016                |    2 +-
 017                |    2 +-
 018                |    2 +-
 019                |    2 +-
 020                |    2 +-
 021                |    2 +-
 022                |    2 +-
 023                |    2 +-
 024                |    2 +-
 025                |    2 +-
 026                |    2 +-
 027                |    2 +-
 028                |    2 +-
 029                |    2 +-
 030                |    2 +-
 031                |    2 +-
 032                |    2 +-
 033                |    2 +-
 034                |    2 +-
 035                |    2 +-
 036                |    2 +-
 037                |    2 +-
 038                |    2 +-
 039                |    2 +-
 040                |    2 +-
 041                |    2 +-
 042                |    2 +-
 043                |    2 +-
 044                |    2 +-
 045                |    2 +-
 046                |    2 +-
 047                |    2 +-
 048                |    2 +-
 049                |    2 +-
 050                |    2 +-
 051                |    4 ++--
 052                |    2 +-
 053                |    2 +-
 054                |    2 +-
 055                |    2 +-
 056                |    2 +-
 057                |    2 +-
 058                |    2 +-
 059                |    2 +-
 060                |    2 +-
 061                |    2 +-
 062                |    2 +-
 063                |    2 +-
 064                |    2 +-
 065                |    2 +-
 066                |    2 +-
 067                |    2 +-
 068                |    2 +-
 069                |    2 +-
 070                |    2 +-
 071                |    2 +-
 072                |    2 +-
 073                |    2 +-
 074                |    2 +-
 075                |    2 +-
 076                |    2 +-
 077                |    2 +-
 078                |    2 +-
 079                |    2 +-
 080                |    2 +-
 081                |    2 +-
 082                |    2 +-
 083                |    2 +-
 084                |    2 +-
 085                |    2 +-
 086                |    2 +-
 087                |    2 +-
 088                |    2 +-
 089                |    2 +-
 090                |    2 +-
 091                |    2 +-
 092                |    2 +-
 093                |    4 ++--
 094                |    2 +-
 095                |    2 +-
 096                |    2 +-
 097                |    2 +-
 098                |    2 +-
 099                |    4 ++--
 100                |    2 +-
 101                |    2 +-
 102                |    2 +-
 103                |    2 +-
 104                |    2 +-
 105                |    2 +-
 106                |    2 +-
 107                |    2 +-
 108                |    2 +-
 109                |    2 +-
 110                |    2 +-
 111                |    2 +-
 112                |    2 +-
 113                |    2 +-
 114                |    2 +-
 115                |    2 +-
 116                |    2 +-
 117                |    2 +-
 118                |    2 +-
 119                |    2 +-
 120                |    2 +-
 121                |    2 +-
 122                |    2 +-
 123                |    4 ++--
 124                |    2 +-
 125                |    2 +-
 126                |    2 +-
 127                |    2 +-
 128                |    4 ++--
 129                |    2 +-
 130                |    2 +-
 131                |    2 +-
 132                |    2 +-
 133                |    2 +-
 134                |    2 +-
 135                |    2 +-
 136                |    2 +-
 137                |    2 +-
 138                |    2 +-
 139                |    2 +-
 140                |    2 +-
 141                |    2 +-
 142                |    2 +-
 143                |    2 +-
 144                |    2 +-
 145                |    2 +-
 146                |    2 +-
 147                |    2 +-
 148                |    2 +-
 149                |    2 +-
 150                |    2 +-
 151                |    2 +-
 152                |    2 +-
 153                |    2 +-
 154                |    2 +-
 155                |    2 +-
 156                |    2 +-
 157                |    2 +-
 158                |    2 +-
 159                |    2 +-
 160                |    2 +-
 161                |    2 +-
 162                |    2 +-
 163                |    2 +-
 164                |    2 +-
 165                |    2 +-
 166                |    2 +-
 167                |    2 +-
 168                |    2 +-
 169                |    2 +-
 170                |    2 +-
 171                |    2 +-
 172                |    2 +-
 173                |    2 +-
 174                |    2 +-
 175                |    2 +-
 176                |    2 +-
 177                |    2 +-
 178                |    2 +-
 179                |    2 +-
 180                |    2 +-
 181                |    2 +-
 182                |    2 +-
 183                |    2 +-
 184                |    2 +-
 185                |    2 +-
 186                |    2 +-
 187                |    2 +-
 188                |    2 +-
 189                |    2 +-
 190                |    2 +-
 191                |    2 +-
 192                |    2 +-
 193                |    2 +-
 194                |    2 +-
 195                |    2 +-
 196                |    2 +-
 197                |    2 +-
 198                |    2 +-
 199                |    2 +-
 200                |    2 +-
 201                |    2 +-
 202                |    2 +-
 203                |    2 +-
 204                |    2 +-
 205                |    2 +-
 206                |    2 +-
 207                |    2 +-
 208                |    2 +-
 209                |    2 +-
 210                |    2 +-
 211                |    2 +-
 212                |    2 +-
 213                |    2 +-
 214                |    2 +-
 215                |    2 +-
 216                |    2 +-
 217                |    2 +-
 218                |    2 +-
 219                |    2 +-
 220                |    2 +-
 221                |    2 +-
 222                |    2 +-
 bench              |    2 +-
 check              |    2 +-
 common             |    2 +-
 common.attr        |    2 +-
 common.bonnie      |    2 +-
 common.config      |    2 +-
 common.dbench      |    2 +-
 common.defrag      |    2 +-
 common.dmapi       |    2 +-
 common.dump        |    2 +-
 common.filestreams |    2 +-
 common.filter      |    2 +-
 common.log         |    2 +-
 common.metaperf    |    2 +-
 common.punch       |    2 +-
 common.quota       |    2 +-
 common.rc          |    2 +-
 common.repair      |    2 +-
 240 files changed, 245 insertions(+), 245 deletions(-)

diff --git a/001 b/001
index 4fe443d..8e3aabd 100755
--- a/001
+++ b/001
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 001
 #
 # Random file copier to produce chains of identical files so the head
diff --git a/002 b/002
index 237580b..896fd1e 100755
--- a/002
+++ b/002
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 002
 #
 # simple inode link count test for a regular file
diff --git a/003 b/003
index 6120cc5..61afac5 100755
--- a/003
+++ b/003
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 003
 #
 # exercise xfs_db bug #784078
diff --git a/004 b/004
index a88fc10..9f28e17 100755
--- a/004
+++ b/004
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 004
 #
 # exercise xfs_db bug #789674 and other freesp functionality
diff --git a/005 b/005
index a9e9086..205256c 100755
--- a/005
+++ b/005
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 005
 #
 # Test symlinks & ELOOP
diff --git a/006 b/006
index 96f4426..e4d5e32 100755
--- a/006
+++ b/006
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 006
 #
 # permname
diff --git a/007 b/007
index f22d09b..50a8418 100755
--- a/007
+++ b/007
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 007
 #
 # drive the src/nametest program
diff --git a/008 b/008
index 519b1a9..dfc938a 100755
--- a/008
+++ b/008
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 008
 #
 # randholes test
diff --git a/009 b/009
index 37082c5..d2a19d8 100755
--- a/009
+++ b/009
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 009
 #
 # XFS allocator test (preallocation - allocp, resvsp ,etc)
diff --git a/010 b/010
index 9ee889a..78813a8 100755
--- a/010
+++ b/010
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 010
 #
 # dbtest
diff --git a/011 b/011
index 7906850..2fcc9d3 100755
--- a/011
+++ b/011
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 011
 #
 # dirstress
diff --git a/012 b/012
index 123c7a3..7d33f4c 100755
--- a/012
+++ b/012
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 012
 #
 # holes
diff --git a/013 b/013
index 4c5612b..58426ea 100755
--- a/013
+++ b/013
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 013
 #
 # fsstress
diff --git a/014 b/014
index ce5b0f8..a2be25a 100755
--- a/014
+++ b/014
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 014
 #
 # truncfile
diff --git a/015 b/015
index 9189e2d..8f2be7c 100755
--- a/015
+++ b/015
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 015
 #
 # check out-of-space behaviour
diff --git a/016 b/016
index 3a55d3a..980eb0b 100755
--- a/016
+++ b/016
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 016
 #
 # test end of log overwrite bug #796141
diff --git a/017 b/017
index e72ab52..9ca0e72 100755
--- a/017
+++ b/017
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 017
 #
 # test remount ro - pv 795642
diff --git a/018 b/018
index 8674ec5..85df390 100755
--- a/018
+++ b/018
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 018
 #
 # xfs_logprint test - test v2 logs of different LR sizes
diff --git a/019 b/019
index 44d3259..42e3c22 100755
--- a/019
+++ b/019
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 019
 #
 # mkfs protofile test
diff --git a/020 b/020
index c843bf5..0118e61 100755
--- a/020
+++ b/020
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 020
 #
 # extended attributes
diff --git a/021 b/021
index 11c8612..18284eb 100755
--- a/021
+++ b/021
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 021
 #
 # xfs_db type attr test (pv 797508 linux-xfs & IRIX)
diff --git a/022 b/022
index 90b46fb..76d18e6 100755
--- a/022
+++ b/022
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 022
 #
 # Test out a level 0 dump/restore to a tape of a subdir
diff --git a/023 b/023
index 8d77acb..b9eeafe 100755
--- a/023
+++ b/023
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 023
 #
 # To test xfsdump/restore to tape using a directory with
diff --git a/024 b/024
index ba3fec2..de5ab5f 100755
--- a/024
+++ b/024
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 024
 #
 # Test out incremental dumps
diff --git a/025 b/025
index a0da452..90d3389 100755
--- a/025
+++ b/025
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 025
 #
 # Test dump/restore using -m option (min strategy) 
diff --git a/026 b/026
index 25a6a7d..ef6aaa6 100755
--- a/026
+++ b/026
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 026
 #
 # Test xfsdump/xfsrestore to a dump file (as opposed to a tape)
diff --git a/027 b/027
index 222599b..9df06c3 100755
--- a/027
+++ b/027
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 027
 #
 # Test out "xfsdump | xfsrestore"
diff --git a/028 b/028
index 45dd7c6..6628f66 100755
--- a/028
+++ b/028
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 028
 #
 # To test out xfsinvutil
diff --git a/029 b/029
index b9c5f11..e4fe715 100755
--- a/029
+++ b/029
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 029
 #
 # exercise mkfs log (internal/external) zeroing
diff --git a/030 b/030
index f4517f5..74147d4 100755
--- a/030
+++ b/030
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 030
 #
 # exercise xfs_repair repairing broken filesystems
diff --git a/031 b/031
index d6383d8..b062277 100755
--- a/031
+++ b/031
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 031
 #
 # exercise xfs_repair - ensure repeated use doesn't corrupt
diff --git a/032 b/032
index 5db89ad..839b913 100755
--- a/032
+++ b/032
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 032
 #
 # cross check mkfs detection of foreign filesystems
diff --git a/033 b/033
index 599af62..9651f26 100755
--- a/033
+++ b/033
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 033
 #
 # exercise xfs_repair repairing broken filesystems (root inodes)
diff --git a/034 b/034
index 8af259c..c09f63b 100755
--- a/034
+++ b/034
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 034
 #
 # pv 801241 - check for reference leaks from the *handle xfsctls
diff --git a/035 b/035
index 592605b..34f5cac 100755
--- a/035
+++ b/035
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 035
 #
 # Test doing multiple dumps to tape and restoring the 2nd one
diff --git a/036 b/036
index ac14e1a..4ed2ebc 100755
--- a/036
+++ b/036
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 036
 #
 # Test xfsdump/restore minrmt to a remote IRIX tape 
diff --git a/037 b/037
index 736385d..fd1e1af 100755
--- a/037
+++ b/037
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 037
 #
 # Test xfsdump/restore minrmt to a remote linux tape 
diff --git a/038 b/038
index 5796d93..f2af214 100755
--- a/038
+++ b/038
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 038
 #
 # Test xfsdump/restore to a remote linux tape 
diff --git a/039 b/039
index b4dda5e..016d2bc 100755
--- a/039
+++ b/039
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 039
 #
 # Test xfsdump/restore to a remote IRIX tape 
diff --git a/040 b/040
index 4481aeb..ea24ff5 100755
--- a/040
+++ b/040
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 040
 #
 # srcdiff test
diff --git a/041 b/041
index a49937c..2800811 100755
--- a/041
+++ b/041
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 041
 #
 # growfs QA tests - repeatedly fill/grow the filesystem
diff --git a/042 b/042
index ca6b365..7ac5492 100755
--- a/042
+++ b/042
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 042
 #
 # xfs_fsr QA tests
diff --git a/043 b/043
index cc8104e..189dc5b 100755
--- a/043
+++ b/043
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 043
 #
 # Test out xfsdump/restore but rmv inventory prior to restore.
diff --git a/044 b/044
index 80631ba..60a6e58 100755
--- a/044
+++ b/044
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 044
 #
 # external log uuid/format tests (TODO - version 2 log format)
diff --git a/045 b/045
index 736a777..db40333 100755
--- a/045
+++ b/045
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 045
 #
 # test mount of two FSes with identical UUID and mount with unknown option
diff --git a/046 b/046
index 4c4c39f..783459c 100755
--- a/046
+++ b/046
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 046
 #
 # check on symlinks permissions
diff --git a/047 b/047
index 72ed2d5..f5f6a52 100755
--- a/047
+++ b/047
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 047
 #
 # invutil with interactive responses
diff --git a/048 b/048
index 4d74b56..9d360d6 100755
--- a/048
+++ b/048
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 048
 #
 # test return codes from xfsctl on bad userspace address
diff --git a/049 b/049
index a0559c3..3d3f030 100755
--- a/049
+++ b/049
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 049
 #
 # XFS on loop test
diff --git a/050 b/050
index 306a7b5..57dfa92 100755
--- a/050
+++ b/050
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 050
 #
 # Exercises basic XFS quota functionality
diff --git a/051 b/051
index bf951c2..238abe9 100755
--- a/051
+++ b/051
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 051
 #
 # Test out ACLs.
@@ -100,7 +100,7 @@ echo "Setup file"
 #       in order to execute it.
 touch file1
 cat <<EOF >file1
-#!/bin/sh
+#!/bin/bash
 echo "Test was executed"
 EOF
 chmod u=rwx file1
diff --git a/052 b/052
index 3d8bb9e..2d8b73d 100755
--- a/052
+++ b/052
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 052
 #
 # Ensure that quota(1) displays blocksizes matching ondisk dquots.
diff --git a/053 b/053
index f28db3f..98644a7 100755
--- a/053
+++ b/053
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 053
 #
 # xfs_repair breaks acls
diff --git a/054 b/054
index b38efab..e5e500c 100755
--- a/054
+++ b/054
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 054
 #
 # Check behavior of chown with both user and group quota enabled,
diff --git a/055 b/055
index 330d933..309b9c3 100755
--- a/055
+++ b/055
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 055
 #
 # Test xfsdump/restore to a remote IRIX tape using RMT user
diff --git a/056 b/056
index 1578408..a19b85a 100755
--- a/056
+++ b/056
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 056
 #
 # Test xfsdump/xfsrestore to a dump file (as opposed to a tape)
diff --git a/057 b/057
index 5d427b0..f3219a3 100755
--- a/057
+++ b/057
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 057
 #
 # Place holder for test 075. Test out the different acl_get semantics
diff --git a/058 b/058
index c1290c8..43b2293 100755
--- a/058
+++ b/058
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 058
 #
 # Place holder test 068. Test some ACL API functions.
diff --git a/059 b/059
index 52033cc..6348f0e 100755
--- a/059
+++ b/059
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 059
 #
 # place holder for IRIX 059 test for xfsdump/xfsrestore multi streams
diff --git a/060 b/060
index 3f6e349..6e58e5b 100755
--- a/060
+++ b/060
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 060
 #
 # place holder for IRIX 060 test for xfsdump/xfsrestore multi streams
diff --git a/061 b/061
index 8c125d1..414675f 100755
--- a/061
+++ b/061
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 061
 #
 # Test restoring a dump created in IRIX/XFS
diff --git a/062 b/062
index b4144b9..76ad513 100755
--- a/062
+++ b/062
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 062
 #
 # Exercises the getfattr/setfattr tools
diff --git a/063 b/063
index 3bc4fd7..d2b8a9f 100755
--- a/063
+++ b/063
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 063
 #
 # xfsdump/xfsrestore with EAs
diff --git a/064 b/064
index be7b22d..16960c9 100755
--- a/064
+++ b/064
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 064
 #
 # test multilevel dump and restores with hardlinks
diff --git a/065 b/065
index 54419ae..f21a87f 100755
--- a/065
+++ b/065
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 065
 #
 # Testing incremental dumps and cumulative restores with
diff --git a/066 b/066
index 1d637d1..a6e76c1 100755
--- a/066
+++ b/066
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 066
 #
 # Test dumping of large files
diff --git a/067 b/067
index 2ac7878..5ab743e 100755
--- a/067
+++ b/067
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 067
 #
 # Test out acl/dacls which fit in shortform in the inode
diff --git a/068 b/068
index 82c1a4e..5d0053d 100755
--- a/068
+++ b/068
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 068
 #
 # Test case to reproduce xfs_freeze hang under filsystem load.
diff --git a/069 b/069
index cf55705..820ca5f 100755
--- a/069
+++ b/069
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 069
 #
 # Test out writes with O_APPEND flag sets.
diff --git a/070 b/070
index aeea518..5dca476 100755
--- a/070
+++ b/070
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 070
 #
 # fsstress incarnation testing extended attributes writes
diff --git a/071 b/071
index 303498e..be9b11b 100755
--- a/071
+++ b/071
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 071
 #
 # Exercise IO at large file offsets.
diff --git a/072 b/072
index 96b783d..981c408 100755
--- a/072
+++ b/072
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 072
 #
 # Check some unwritten extent boundary conditions
diff --git a/073 b/073
index 756c1c8..90fa1f0 100755
--- a/073
+++ b/073
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 073
 #
 # Test xfs_copy
diff --git a/074 b/074
index 9ce4563..b9fb9d5 100755
--- a/074
+++ b/074
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 074
 #
 # fstest
diff --git a/075 b/075
index 49d006d..0f0a6ed 100755
--- a/075
+++ b/075
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 075
 #
 # fsx (non-AIO variant)
diff --git a/076 b/076
index 0b1a195..e472b26 100755
--- a/076
+++ b/076
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 076
 #
 # Test blockdev reads in parallel with filesystem reads/writes
diff --git a/077 b/077
index 719c8c3..cdee8da 100755
--- a/077
+++ b/077
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 077
 #
 # Check use of ACLs (extended attributes) on a full filesystem
diff --git a/078 b/078
index acef5c1..b8d9132 100755
--- a/078
+++ b/078
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 078
 #
 # Check several growfs corner cases
diff --git a/079 b/079
index b26cc0a..151835c 100755
--- a/079
+++ b/079
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 079
 #
 # Run the t_immutable test program for immutable/append-only files.
diff --git a/080 b/080
index dc51c59..8ece84d 100755
--- a/080
+++ b/080
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 080
 #
 # rwtest (iogen|doio)
diff --git a/081 b/081
index c8eba80..96156c8 100755
--- a/081
+++ b/081
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 081
 #
 # To test out logprint with quotas
diff --git a/082 b/082
index ca19821..c413c10 100755
--- a/082
+++ b/082
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 082
 #
 # Test out the v2 stripe logs with logprint
diff --git a/083 b/083
index a61aa66..7342baa 100755
--- a/083
+++ b/083
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 083
 #
 # Exercise filesystem full behaviour - run numerous fsstress
diff --git a/084 b/084
index 212bbfa..622eb4f 100755
--- a/084
+++ b/084
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 084
 #
 # Exercises unwritten extent reads and writes, looking
diff --git a/085 b/085
index 7a62b0c..361aec1 100755
--- a/085
+++ b/085
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 085
 #
 # To test log replay by shutdown of file system
diff --git a/086 b/086
index 5a1270f..9c3f22d 100755
--- a/086
+++ b/086
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 086
 #
 # To test log replay with version 2 logs
diff --git a/087 b/087
index 14a9d4e..48e5eaa 100755
--- a/087
+++ b/087
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 087
 #
 # * like 086 but want to create more/different kinds of metadata
diff --git a/088 b/088
index 3ebda66..f6f0e26 100755
--- a/088
+++ b/088
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 088
 #
 # test out CAP_DAC_OVERRIDE and CAP_DAC_SEARCH code in 
diff --git a/089 b/089
index 3fce2f8..e28e099 100755
--- a/089
+++ b/089
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 089
 #
 # Emulate the way Linux mount manipulates /etc/mtab to attempt to
diff --git a/090 b/090
index e71badb..0cdbe34 100755
--- a/090
+++ b/090
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 090
 #
 # Exercise IO on the realtime device (direct, buffered, mmapd)
diff --git a/091 b/091
index 0ee9c7a..6c4566f 100755
--- a/091
+++ b/091
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 091
 #
 # fsx exercising direct IO -- sub-block sizes and concurrent buffered IO
diff --git a/092 b/092
index 73384b9..429fa80 100755
--- a/092
+++ b/092
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 092
 #
 # Make sure that we can mount inode64 filesystems
diff --git a/093 b/093
index 3232476..5babfb3 100755
--- a/093
+++ b/093
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 093
 #
 # Test out for IRIX the removal of file capabilities when
@@ -75,7 +75,7 @@ user=`grep ':all=:all=' /etc/capability | tail -1 | $AWK_PROG -F: '{print $1}'`
 uid=`grep $user /etc/passwd | $AWK_PROG -F: '{print $3}'`
 
 cat >$tmp.append <<EOF
-#!/bin/sh
+#!/bin/bash
 echo data >>$file
 EOF
 chmod ugo+x $tmp.append
diff --git a/094 b/094
index 97f6be7..8e8b5e7 100755
--- a/094
+++ b/094
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 094
 #
 # Exercising the inheritable realtime inode bit.
diff --git a/095 b/095
index 6e2005a..b85b97f 100755
--- a/095
+++ b/095
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 095
 #
 # test out xfs_chver on IRIX
diff --git a/096 b/096
index 6011f34..237edad 100755
--- a/096
+++ b/096
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 096
 #
 # test out mkfs_xfs output on IRIX/Linux and some of its error handling
diff --git a/097 b/097
index a6c57b0..2597d53 100755
--- a/097
+++ b/097
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 097. Modifed from UDFQA test 033.
 #
 # simple attr tests for EAs:
diff --git a/098 b/098
index dcdfb16..e59f5ac 100755
--- a/098
+++ b/098
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 098. Modified from UDFQA test 035
 #
 # simple attr tests for EAs:
diff --git a/099 b/099
index 4827b89..90af18f 100755
--- a/099
+++ b/099
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 099. Modified from UDFQA test 036.
 #
 # ACL test
@@ -103,7 +103,7 @@ echo "Setup file"
 #       in order to execute it.
 touch file1
 cat <<EOF >file1
-#!/bin/sh
+#!/bin/bash
 echo "Test was executed"
 EOF
 chmod u=rwx file1
diff --git a/100 b/100
index 7c22f87..f3504ce 100755
--- a/100
+++ b/100
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 100. Modified from UDF QA test 030.
 #
 # Test whether a tarred directory structure can be untarred onto
diff --git a/101 b/101
index ca385d1..e58f8b6 100755
--- a/101
+++ b/101
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 101. Modified from UDFQA test 029. 
 #
 # This tests mkfs_udf with -s [SIZE] option. 
diff --git a/102 b/102
index 048772c..dab9b5c 100755
--- a/102
+++ b/102
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 102
 #
 # This tests mkfs_udf/mkudffs and the device detection code
diff --git a/103 b/103
index 8d3e226..8f7e45b 100755
--- a/103
+++ b/103
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 103
 #
 # Exercise the XFS nosymlinks inode flag
diff --git a/104 b/104
index 5f18d08..b35c43b 100755
--- a/104
+++ b/104
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 104
 #
 # XFS online growfs-while-allocating tests (data subvol variant)
diff --git a/105 b/105
index a98a03e..e3163fd 100755
--- a/105
+++ b/105
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 105
 #
 # Test fix of bug:
diff --git a/106 b/106
index 30f740b..5bff660 100755
--- a/106
+++ b/106
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 106
 #
 # Exercise basic xfs_quota functionality (user/group/project quota)
diff --git a/107 b/107
index f36dc21..c270f0e 100755
--- a/107
+++ b/107
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 107
 #
 # Project quota.
diff --git a/108 b/108
index 3a1fee9..b429bc6 100755
--- a/108
+++ b/108
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 108
 #
 # Simple quota accounting test for direct/buffered/mmap IO.
diff --git a/109 b/109
index 1ec25ea..a9c174f 100755
--- a/109
+++ b/109
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 109
 #
 # ENOSPC deadlock case from Asano Masahiro.
diff --git a/110 b/110
index fa8ade9..cf5f663 100755
--- a/110
+++ b/110
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 110
 #
 # Incorrect dir2 freetab warning case from Masanori Tsuda.
diff --git a/111 b/111
index db86df6..719a0e0 100755
--- a/111
+++ b/111
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 111
 #
 # Infinite xfs_bulkstat bad-inode loop case from Roger Willcocks.
diff --git a/112 b/112
index d6c2952..557350a 100755
--- a/112
+++ b/112
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 112
 #
 # fsx (AIO variant, based on 075)
diff --git a/113 b/113
index f05275d..23676e0 100755
--- a/113
+++ b/113
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 113
 #
 # aio-stress
diff --git a/114 b/114
index 3596da8..8787937 100755
--- a/114
+++ b/114
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 114
 #
 # Test some parent ptr stuff
diff --git a/115 b/115
index b874cb8..8ef0e4c 100755
--- a/115
+++ b/115
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 115
 #
 # Test out xfs_repair_ipaths
diff --git a/116 b/116
index e902ce9..cc2bb0f 100755
--- a/116
+++ b/116
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 116
 #
 # pv#940491
diff --git a/117 b/117
index 04c628e..915520f 100755
--- a/117
+++ b/117
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 117
 #
 # Attempt to cause filesystem corruption with serial fsstresses doing
diff --git a/118 b/118
index cb0e5ee..403655e 100755
--- a/118
+++ b/118
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 118
 #
 # To test out pv#940675 crash in xfs_trans_brelse + quotas
diff --git a/119 b/119
index 516f992..1509ece 100755
--- a/119
+++ b/119
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 119
 #
 # Leaking reservation space in the GRH
diff --git a/120 b/120
index dd6e91a..bf1e617 100755
--- a/120
+++ b/120
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # FS QA Test No. 120
 #
 # Test noatime mount option.
diff --git a/121 b/121
index eb0158d..2137ebc 100755
--- a/121
+++ b/121
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 121
 #
 # To test log replay for the unlinked list.
diff --git a/122 b/122
index 9fbe437..4c11556 100755
--- a/122
+++ b/122
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 122
 #
 # pv#952498
diff --git a/123 b/123
index f76b62c..27c1e66 100755
--- a/123
+++ b/123
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 123
 #
 # Make sure user cannot overwrite, append, delete or move a file created by 
@@ -60,7 +60,7 @@ _user_do()
 {
     if [ "$HOSTOS" == "IRIX" ]
 	then
-	echo $1 | /bin/sh "su $qa_user 2>&1" | _filter_user_do
+	echo $1 | /bin/bash "su $qa_user 2>&1" | _filter_user_do
     else
 	echo $1 | su $qa_user 2>&1 | _filter_user_do
     fi
diff --git a/124 b/124
index 5a44656..adae304 100755
--- a/124
+++ b/124
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 124
 #
 # Test preallocated_rw_pattern_test modified from CXFSQA test preallocated_rw_pattern_test
diff --git a/125 b/125
index afc31d0..e84109a 100755
--- a/125
+++ b/125
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 125
 #
 # ftruncate test, modified from CXFSQA tests cxfs_ftrunc and cxfs_trunc
diff --git a/126 b/126
index 7bb10de..44db64c 100755
--- a/126
+++ b/126
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 126
 #
 # tests various file permission options modified from CXFSQA test fs_perms
diff --git a/127 b/127
index 30f4fdb..8a61ffb 100755
--- a/127
+++ b/127
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 127
 #
 # fsx tests modified from CXFSQA tests
diff --git a/128 b/128
index c3f311d..7760b95 100755
--- a/128
+++ b/128
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 128
 #
 # Test nosuid mount option modified from CXFSQA test mount_option_nosuid
@@ -58,7 +58,7 @@ cp `which ls` $SCRATCH_MNT
 chmod 700 $SCRATCH_MNT/nosuid
 chmod 4755 $SCRATCH_MNT/ls
 
-su -s/bin/sh - $qa_user -c "$SCRATCH_MNT/ls $SCRATCH_MNT/nosuid >/dev/null 2>&1"
+su -s/bin/bash - $qa_user -c "$SCRATCH_MNT/ls $SCRATCH_MNT/nosuid >/dev/null 2>&1"
 if [ $? -eq 0 ] ; then
 	echo "Error: we shouldn't be able to ls the directory"
 fi
diff --git a/129 b/129
index 66b4cb9..c9f11d6 100755
--- a/129
+++ b/129
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 129
 #
 # looptests created from CXFSQA test looptest
diff --git a/130 b/130
index 816f4bc..21582ea 100755
--- a/130
+++ b/130
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 130
 #
 # xfs_io vector read/write and trunc tests. modified from cxfsqa tests
diff --git a/131 b/131
index de83fe2..9be0a14 100755
--- a/131
+++ b/131
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 131
 #
 # lock test created from CXFSQA test lockfile_simple
diff --git a/132 b/132
index 760315c..e90f56c 100755
--- a/132
+++ b/132
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 132
 #
 # xfs_io aligned vector rw created from CXFSQA test
diff --git a/133 b/133
index 26d16fe..9dbcb64 100755
--- a/133
+++ b/133
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 133
 #
 # Concurrent I/O to same file to ensure no deadlocks
diff --git a/134 b/134
index f00e1f0..0f97e18 100755
--- a/134
+++ b/134
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 134
 #
 # test to reproduce PV951636:
diff --git a/135 b/135
index a3a8ac9..915701f 100755
--- a/135
+++ b/135
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 135
 #
 # Concurrent I/O to same file to ensure no deadlocks
diff --git a/136 b/136
index d5d8a34..d394594 100755
--- a/136
+++ b/136
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 136
 #
 # Test the attr2 code
diff --git a/137 b/137
index 4db8127..42fb853 100755
--- a/137
+++ b/137
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 137
 #
 # Test for NULL files problem
diff --git a/138 b/138
index c9a2381..e7b5609 100755
--- a/138
+++ b/138
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 138
 #
 # Test for NULL files problem
diff --git a/139 b/139
index 3fb05cf..706a112 100755
--- a/139
+++ b/139
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 139
 #
 # Test for NULL files problem
diff --git a/140 b/140
index 84ee0f0..1f88302 100755
--- a/140
+++ b/140
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 140
 #
 # Test for NULL files problem
diff --git a/141 b/141
index 9ee27e4..cc501d6 100755
--- a/141
+++ b/141
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 141
 #
 # Test for xfs_io mmap read problem
diff --git a/142 b/142
index 0bc3ded..c09a968 100755
--- a/142
+++ b/142
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 142
 #
 # Dmapi get/set_dmattr
diff --git a/143 b/143
index c4763f5..7db6fea 100755
--- a/143
+++ b/143
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 143
 #
 # Dmapi get/set_eventlist
diff --git a/144 b/144
index cbbbc42..36b9263 100755
--- a/144
+++ b/144
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 144
 #
 # Dmapi get/set_fileattr, get_bulkattr, get_dirattrs
diff --git a/145 b/145
index 59ce6a2..3d6c158 100755
--- a/145
+++ b/145
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 145
 #
 # Dmapi probe/punch_hole
diff --git a/146 b/146
index 9e2eeae..477df83 100755
--- a/146
+++ b/146
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 146
 #
 # Dmapi read/write_invis
diff --git a/147 b/147
index c376567..b775478 100755
--- a/147
+++ b/147
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 147
 #
 # Dmapi get/set_region
diff --git a/148 b/148
index a2f0873..76cbf37 100755
--- a/148
+++ b/148
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 148
 #
 # Exercise xfs parallel repair on broken filesystems
diff --git a/149 b/149
index 0a1904a..5131a45 100755
--- a/149
+++ b/149
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 149
 #
 # Exercise xfs_prepair - ensure repeated use doesn't corrupt
diff --git a/150 b/150
index 96be389..a865875 100755
--- a/150
+++ b/150
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 150
 #
 # Set DM_EVENT_RENAME event on a DMAPI filesystem and verify it is set.
diff --git a/151 b/151
index 65fefbb..f10460d 100755
--- a/151
+++ b/151
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 151
 #
 # Create three DMAPI sessions,
diff --git a/152 b/152
index 53531ce..071be85 100755
--- a/152
+++ b/152
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 152
 #
 # Verify DMAPI functions
diff --git a/153 b/153
index 2f552f5..7c609d2 100755
--- a/153
+++ b/153
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 153
 #
 # Associate filesystem with a session by setting DMAPI DM_EVENT_RENAME
diff --git a/154 b/154
index 8520833..2384d26 100755
--- a/154
+++ b/154
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 154
 #
 # Get DMAPI filesystem handle
diff --git a/155 b/155
index 78abb9a..de88ecb 100755
--- a/155
+++ b/155
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 155
 #
 # DMAPI event DM_EVENT_RENAME generation
diff --git a/156 b/156
index 5305ee6..0f3b229 100755
--- a/156
+++ b/156
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 156
 #
 # DMAPI get directory attributes (simple check
diff --git a/157 b/157
index 7e1af5b..11488c6 100755
--- a/157
+++ b/157
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 157
 #
 # get/set DMAPI attributes
diff --git a/158 b/158
index d116321..2b95ec6 100755
--- a/158
+++ b/158
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 158
 #
 # get/set file attributes
diff --git a/159 b/159
index 0d6889f..203afca 100755
--- a/159
+++ b/159
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 159
 #
 # Create DMAPI event and respond to it.
diff --git a/160 b/160
index c3b4251..095951b 100755
--- a/160
+++ b/160
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 160
 #
 # Change and view DMAPI access rights.
diff --git a/161 b/161
index 82d950c..8d0aed2 100755
--- a/161
+++ b/161
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 161
 #
 # DMAPI function punch hole. Create 3Mb file and punch a hole from
diff --git a/162 b/162
index 072a8d4..409d3a1 100755
--- a/162
+++ b/162
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 162
 #
 # Placing holds on objects
diff --git a/163 b/163
index c5c4755..faf02e4 100755
--- a/163
+++ b/163
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 163
 #
 # File descriptor to handle conversion
diff --git a/164 b/164
index 01e56d3..03784c6 100755
--- a/164
+++ b/164
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 164
 #
 # To test for short dio reads on IRIX and Linux - pv#962005/962547
diff --git a/165 b/165
index c5a321d..d47ad8e 100755
--- a/165
+++ b/165
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 165
 #
 # Test out prealloc, direct writes and buffered read
diff --git a/166 b/166
index e7b21aa..65c46da 100755
--- a/166
+++ b/166
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 166
 #
 # ->page-mkwrite test - unwritten extents and mmap
diff --git a/167 b/167
index 8ec174f..98b55e6 100755
--- a/167
+++ b/167
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 167
 #
 # unwritten extent conversion test
diff --git a/168 b/168
index 5d9d4eb..e044091 100755
--- a/168
+++ b/168
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 168
 #
 # Check for DMAPI destroy events when removing files without attributes
diff --git a/169 b/169
index ac0ecad..627981e 100755
--- a/169
+++ b/169
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 169
 #
 # Test for file size consistency with append followed by umount/mount
diff --git a/170 b/170
index 5785511..a807de0 100755
--- a/170
+++ b/170
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 #
 # FSQA Test No. 170
 #
diff --git a/171 b/171
index d7bfdeb..7e70466 100755
--- a/171
+++ b/171
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 171
 #
 # Check the filestreams allocator is doing its job.
diff --git a/172 b/172
index e0a2d8c..3220697 100755
--- a/172
+++ b/172
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 172
 #
 # Check the filestreams allocator is doing its job.
diff --git a/173 b/173
index f57226a..9156403 100755
--- a/173
+++ b/173
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 173
 #
 # Check the filestreams allocator is doing its job.
diff --git a/174 b/174
index 9f97289..4828854 100755
--- a/174
+++ b/174
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 174
 #
 # Check the filestreams allocator is doing its job.
diff --git a/175 b/175
index 480c4c1..523dce1 100755
--- a/175
+++ b/175
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 175
 #
 # Hole punching with extsize hints, holes may not reported by xfs_bmap.
diff --git a/176 b/176
index 2aec086..b988783 100755
--- a/176
+++ b/176
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 176
 #
 # Check if resvsp on file create effects bmap output after hole punch.
diff --git a/177 b/177
index 94ea9c3..b6f4789 100755
--- a/177
+++ b/177
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 177
 #
 # Test to reproduce PV#: 964316
diff --git a/178 b/178
index a0a8a42..e4e104e 100755
--- a/178
+++ b/178
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 178
 #
 # Reproduce PV#:967665
diff --git a/179 b/179
index 5a801c9..5cec718 100755
--- a/179
+++ b/179
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 179
 #
 # Test for NULL files problem
diff --git a/180 b/180
index a11e947..6ba32fe 100755
--- a/180
+++ b/180
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 180
 #
 # Test for NULL files problem
diff --git a/181 b/181
index 44ed955..6db52ac 100755
--- a/181
+++ b/181
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 181
 #
 # Like 121 only creating large EAs
diff --git a/182 b/182
index 984e1e5..ae1f920 100755
--- a/182
+++ b/182
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 182
 #
 # Test for NULL files problem
diff --git a/183 b/183
index b302dcd..5558eb9 100755
--- a/183
+++ b/183
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 183
 #
 # Test to check bulkstat returns unlinked-but-referenced inodes
diff --git a/184 b/184
index 170e63a..8544dc1 100755
--- a/184
+++ b/184
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 184
 #
 # check mknod makes working nodes.
diff --git a/185 b/185
index 264f157..74c4d3c 100755
--- a/185
+++ b/185
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 185
 #
 # Dmapi Punch/Probe Alignment compared to xfsctl(FREESPACE); 
diff --git a/186 b/186
index 524c9ee..94d399a 100755
--- a/186
+++ b/186
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 186
 #
 # Test out:
diff --git a/187 b/187
index cb5b9ca..6a489d0 100755
--- a/187
+++ b/187
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 187
 #
 # To test out the noattr2 flag which is broken in pv#980021
diff --git a/188 b/188
index d0656ac..ed93e65 100755
--- a/188
+++ b/188
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 188
 #
 # drive the src/nametest program for CI mode
diff --git a/189 b/189
index 85fe5a4..8f1c0e1 100755
--- a/189
+++ b/189
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 189
 #
 # Test remount behaviour
diff --git a/190 b/190
index 07464ee..096b871 100755
--- a/190
+++ b/190
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 190
 #
 # This test uses xfs_io to unreserve space in a file at various different
diff --git a/191 b/191
index 0152c7d..b1e66bf 100755
--- a/191
+++ b/191
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # FS QA Test No. 191
 #
 # To call into the nfs4acl qa suite of Andreas Gruenbacher.
diff --git a/192 b/192
index 3550ae6..0d0b294 100755
--- a/192
+++ b/192
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 192
 #
 # Simple test of atime
diff --git a/193 b/193
index 9c676c6..9891256 100755
--- a/193
+++ b/193
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 193
 #
 # Test permission checks in ->setattr
diff --git a/194 b/194
index 38c7a58..931068d 100755
--- a/194
+++ b/194
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 194
 #
 # Test mapping around/over holes for sub-page blocks
diff --git a/195 b/195
index b4aaeff..b910f72 100755
--- a/195
+++ b/195
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 195
 #
 # Make sure the chattr dump flag gets picked up by xfsdump without a sync
diff --git a/196 b/196
index 5da3659..6b9998f 100755
--- a/196
+++ b/196
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 196
 #
 # Make sure renames accross project boundaries are properly rejected
diff --git a/197 b/197
index 736ece8..0996630 100755
--- a/197
+++ b/197
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 197
 #
 # Check that d_off can be represented in a 32 bit long type without
diff --git a/198 b/198
index 97ba737..e46ec8d 100755
--- a/198
+++ b/198
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 198
 #
 # Test that aio+dio into holes does completion at the proper offsets
diff --git a/199 b/199
index 918e849..2151cd2 100755
--- a/199
+++ b/199
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 199
 #
 # Check that the features2 location fixups work correctly.  We check both
diff --git a/200 b/200
index 712fb38..dcf0f38 100755
--- a/200
+++ b/200
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 200
 #
 # Check out various mount/remount/unmount scenarious on a read-only blockdev.
diff --git a/201 b/201
index add69fe..99bcde8 100755
--- a/201
+++ b/201
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 201
 #
 # Test out the infamous xfs_btree_delrec corruption.
diff --git a/202 b/202
index e5e35e7..cbdcb57 100755
--- a/202
+++ b/202
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 202
 #
 # Test out the xfs_repair -o force_geometry option on single-AG filesystems.
diff --git a/203 b/203
index 8a1c2d7..174bdae 100755
--- a/203
+++ b/203
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 203
 #
 # Test out reallocation of the extent array in xfs_io.
diff --git a/204 b/204
index 8c4e91e..1ac9ebf 100755
--- a/204
+++ b/204
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 204
 #
 # Test out ENOSPC flushing on small filesystems.
diff --git a/205 b/205
index c85e102..3f45185 100755
--- a/205
+++ b/205
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 205
 #
 # Test out ENOSPC flushing on small filesystems.
diff --git a/206 b/206
index 0935335..034bbf1 100755
--- a/206
+++ b/206
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 206
 #
 # Test trim of last small AG for large filesystem resizes
diff --git a/207 b/207
index 8e29e90..32e6299 100755
--- a/207
+++ b/207
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 207
 #
 # Run aio-dio-extend-stat - test race in dio aio completion
diff --git a/208 b/208
index 9848f2f..e1fdaa1 100755
--- a/208
+++ b/208
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 208
 #
 # Run aio-dio-invalidate-failure - test race in read cache invalidation
diff --git a/209 b/209
index 57cd429..06f10ae 100755
--- a/209
+++ b/209
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 209
 #
 # Run aio-dio-invalidate-readahead - test sync DIO invalidation of readahead
diff --git a/210 b/210
index 8db47b4..e093079 100755
--- a/210
+++ b/210
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 210
 #
 # Run aio-dio-subblock-eof-read - test AIO read of last block of DIO file
diff --git a/211 b/211
index 57ab2b4..9428320 100755
--- a/211
+++ b/211
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 211
 #
 # Run aio-free-ring-with-bogus-nr-pages - test aio_setup_ring with bad nr_pages
diff --git a/212 b/212
index f3e62ac..627a431 100755
--- a/212
+++ b/212
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 212
 #
 # Run aio-io-setup-with-nonwritable-context-pointer -
diff --git a/213 b/213
index 7d66338..9982dd4 100755
--- a/213
+++ b/213
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 213
 #
 # Check some unwritten extent boundary conditions, fallocate version.
diff --git a/214 b/214
index a71680a..eb18825 100755
--- a/214
+++ b/214
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 214
 #
 # Basic unwritten extent sanity checks
diff --git a/215 b/215
index 691e552..c61f7a5 100644
--- a/215
+++ b/215
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 215
 #
 # Test out c/mtime updates after mapped writes.
diff --git a/216 b/216
index f8ddb5d..7c046f5 100755
--- a/216
+++ b/216
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 216
 #
 # log size mkfs test - ensure the log size scaling works for small filesystems
diff --git a/217 b/217
index 18ab53e..6032578 100755
--- a/217
+++ b/217
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 217
 #
 # large log size mkfs test - ensure the log size scaling works
diff --git a/218 b/218
index 8c8afe7..53d0b61 100755
--- a/218
+++ b/218
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 218
 #
 # Basic defragmentation sanity tests
diff --git a/219 b/219
index 9d79d5c..08ecab6 100755
--- a/219
+++ b/219
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 219
 #
 # Simple quota accounting test for direct/buffered/mmap IO.
diff --git a/220 b/220
index 8d4987d..b913434 100644
--- a/220
+++ b/220
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 220
 #
 # Test quota off handling.
diff --git a/221 b/221
index c7fa64d..6681237 100644
--- a/221
+++ b/221
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 221
 #
 # Check ctime updates when calling futimens without UTIME_OMIT for the
diff --git a/222 b/222
index c22dd9a..574c181 100644
--- a/222
+++ b/222
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 222
 #
 # xfs_fsr QA tests
diff --git a/bench b/bench
index 2ed4942..f415423 100755
--- a/bench
+++ b/bench
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 #
 # Wrapper for automating benchmarking runs.
 # Usage:   bench passes user group [script]
diff --git a/check b/check
index 5768be6..560ac7b 100755
--- a/check
+++ b/check
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 #
 # Control script for QA
 #
diff --git a/common b/common
index e3d7d41..c66cbad 100644
--- a/common
+++ b/common
@@ -1,4 +1,4 @@
-##/bin/sh 
+##/bin/bash 
 #
 # Copyright (c) 2000-2005 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff --git a/common.attr b/common.attr
index 5f16273..a6b9b3b 100644
--- a/common.attr
+++ b/common.attr
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #-----------------------------------------------------------------------
 #  Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
 #  This program is free software; you can redistribute it and/or modify
diff --git a/common.bonnie b/common.bonnie
index 6693502..96ca700 100644
--- a/common.bonnie
+++ b/common.bonnie
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #
 # Copyright (c) 2002-2004 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff --git a/common.config b/common.config
index fecbabe..26906aa 100644
--- a/common.config
+++ b/common.config
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #
 # Copyright (c) 2000-2003,2006 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff --git a/common.dbench b/common.dbench
index 584ef07..026acdf 100755
--- a/common.dbench
+++ b/common.dbench
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #
 # Copyright (c) 2002-2005 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff --git a/common.defrag b/common.defrag
index a0716de..1bcf01d 100644
--- a/common.defrag
+++ b/common.defrag
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #
 # Copyright (c) 2009 Eric Sandeen
 # All Rights Reserved.
diff --git a/common.dmapi b/common.dmapi
index 3a3668d..c8a463a 100644
--- a/common.dmapi
+++ b/common.dmapi
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #
 # Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff --git a/common.dump b/common.dump
index db9a92e..f330daf 100644
--- a/common.dump
+++ b/common.dump
@@ -1,4 +1,4 @@
-#/bin/sh
+##/bin/bash
 #
 # Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff --git a/common.filestreams b/common.filestreams
index be8ec35..08eaf90 100644
--- a/common.filestreams
+++ b/common.filestreams
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #
 # Copyright (c) 2007 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff --git a/common.filter b/common.filter
index 067fafa..a0034c6 100644
--- a/common.filter
+++ b/common.filter
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #
 # Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff --git a/common.log b/common.log
index 56a2012..3958c48 100644
--- a/common.log
+++ b/common.log
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #
 # Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff --git a/common.metaperf b/common.metaperf
index f5384e5..9def379 100755
--- a/common.metaperf
+++ b/common.metaperf
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #
 # Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff --git a/common.punch b/common.punch
index 42f6703..b6576f6 100644
--- a/common.punch
+++ b/common.punch
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #
 # Copyright (c) 2007 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff --git a/common.quota b/common.quota
index e2a7872..51bdc71 100644
--- a/common.quota
+++ b/common.quota
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #
 # Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
 # All Rights Reserved.
diff --git a/common.rc b/common.rc
index 761170d..6424871 100644
--- a/common.rc
+++ b/common.rc
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #-----------------------------------------------------------------------
 #  Copyright (c) 2000-2006 Silicon Graphics, Inc.  All Rights Reserved.
 #  This program is free software; you can redistribute it and/or modify
diff --git a/common.repair b/common.repair
index 66e8b20..c598782 100644
--- a/common.repair
+++ b/common.repair
@@ -1,4 +1,4 @@
-##/bin/sh
+##/bin/bash
 #
 # Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
 #
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
