Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:37244 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751739AbdGUEkU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:20 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 12/15] tests: clean up per-OS output files
Date: Thu, 20 Jul 2017 21:38:50 -0700
Message-Id: <20170721043853.364-13-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

Some tests had separate output files for IRIX and Linux.  Now that the
IRIX ones have been removed, rename the Linux ones and remove the
now-unneeded .cfg files and calls to _link_out_file.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 .gitignore                                   | 13 -------------
 tests/generic/088                            |  3 ---
 tests/generic/088.cfg                        |  1 -
 tests/generic/{088.out.linux => 088.out}     |  0
 tests/xfs/018                                |  3 ---
 tests/xfs/018.cfg                            |  1 -
 tests/xfs/{018.op.linux => 018.op}           |  0
 tests/xfs/022                                |  3 ---
 tests/xfs/022.cfg                            |  1 -
 tests/xfs/{022.out.linux => 022.out}         |  0
 tests/xfs/023                                |  3 ---
 tests/xfs/023.cfg                            |  1 -
 tests/xfs/{023.out.linux => 023.out}         |  0
 tests/xfs/030                                |  3 ---
 tests/xfs/030.cfg                            |  1 -
 tests/xfs/{030.out.linux => 030.out}         |  0
 tests/xfs/031                                |  3 ---
 tests/xfs/031.cfg                            |  1 -
 tests/xfs/{031.out.linux => 031.out}         |  0
 tests/xfs/033                                |  4 ++--
 tests/xfs/033.cfg                            |  3 +--
 tests/xfs/{033.out.crc.linux => 033.out.crc} |  0
 tests/xfs/{033.out.linux => 033.out.default} |  0
 tests/xfs/035                                |  3 ---
 tests/xfs/035.cfg                            |  1 -
 tests/xfs/{035.out.linux => 035.out}         |  0
 tests/xfs/036                                |  3 ---
 tests/xfs/036.cfg                            |  1 -
 tests/xfs/{036.out.linux => 036.out}         |  0
 tests/xfs/039                                |  3 ---
 tests/xfs/039.cfg                            |  1 -
 tests/xfs/{039.out.linux => 039.out}         |  0
 tests/xfs/043                                |  3 ---
 tests/xfs/043.cfg                            |  1 -
 tests/xfs/{043.out.linux => 043.out}         |  0
 tests/xfs/055                                |  3 ---
 tests/xfs/{055.out.linux => 055.out}         |  0
 tests/xfs/082                                |  3 ---
 tests/xfs/082.cfg                            |  1 -
 tests/xfs/{082.op.linux => 082.op}           |  0
 tests/xfs/146                                |  3 ---
 tests/xfs/146.cfg                            |  1 -
 tests/xfs/{146.out.linux => 146.out}         |  0
 43 files changed, 3 insertions(+), 68 deletions(-)
 delete mode 100644 tests/generic/088.cfg
 rename tests/generic/{088.out.linux => 088.out} (100%)
 delete mode 100644 tests/xfs/018.cfg
 rename tests/xfs/{018.op.linux => 018.op} (100%)
 delete mode 100644 tests/xfs/022.cfg
 rename tests/xfs/{022.out.linux => 022.out} (100%)
 delete mode 100644 tests/xfs/023.cfg
 rename tests/xfs/{023.out.linux => 023.out} (100%)
 delete mode 100644 tests/xfs/030.cfg
 rename tests/xfs/{030.out.linux => 030.out} (100%)
 delete mode 100644 tests/xfs/031.cfg
 rename tests/xfs/{031.out.linux => 031.out} (100%)
 rename tests/xfs/{033.out.crc.linux => 033.out.crc} (100%)
 rename tests/xfs/{033.out.linux => 033.out.default} (100%)
 delete mode 100644 tests/xfs/035.cfg
 rename tests/xfs/{035.out.linux => 035.out} (100%)
 delete mode 100644 tests/xfs/036.cfg
 rename tests/xfs/{036.out.linux => 036.out} (100%)
 delete mode 100644 tests/xfs/039.cfg
 rename tests/xfs/{039.out.linux => 039.out} (100%)
 delete mode 100644 tests/xfs/043.cfg
 rename tests/xfs/{043.out.linux => 043.out} (100%)
 rename tests/xfs/{055.out.linux => 055.out} (100%)
 delete mode 100644 tests/xfs/082.cfg
 rename tests/xfs/{082.op.linux => 082.op} (100%)
 delete mode 100644 tests/xfs/146.cfg
 rename tests/xfs/{146.out.linux => 146.out} (100%)

diff --git a/.gitignore b/.gitignore
index c0736486..fcbc0cd4 100644
--- a/.gitignore
+++ b/.gitignore
@@ -234,19 +234,6 @@
 /dmapi/src/suite2/src/test_rights
 
 # Symlinked files
-/tests/generic/088.out
-/tests/xfs/018.op
-/tests/xfs/022.out
-/tests/xfs/023.out
-/tests/xfs/030.out
-/tests/xfs/031.out
 /tests/xfs/033.out
-/tests/xfs/035.out
-/tests/xfs/036.out
-/tests/xfs/039.out
-/tests/xfs/043.out
-/tests/xfs/055.out
 /tests/xfs/071.out
-/tests/xfs/082.op
 /tests/xfs/096.out
-/tests/xfs/146.out
diff --git a/tests/generic/088 b/tests/generic/088
index 1f01c4f5..8d31741b 100755
--- a/tests/generic/088
+++ b/tests/generic/088
@@ -42,9 +42,6 @@ _filter()
     _filter_test_dir | sed -e '/----------/d'
 }
 
-# link correct .out file
-_link_out_file
-
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
diff --git a/tests/generic/088.cfg b/tests/generic/088.cfg
deleted file mode 100644
index 7fd51a7d..00000000
diff --git a/tests/generic/088.out.linux b/tests/generic/088.out
similarity index 100%
rename from tests/generic/088.out.linux
rename to tests/generic/088.out
diff --git a/tests/xfs/018 b/tests/xfs/018
index 253af940..b2913821 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -53,9 +53,6 @@ rm -f $seqres.full $tmp.*
 _require_scratch
 _require_v2log
 
-# link correct .out file
-_link_out_file_named $seqfull.op $(_get_os_name)
-
 echo "*** init FS"
 _scratch_unmount >/dev/null 2>&1
 
diff --git a/tests/xfs/018.cfg b/tests/xfs/018.cfg
deleted file mode 100644
index 7fd51a7d..00000000
diff --git a/tests/xfs/018.op.linux b/tests/xfs/018.op
similarity index 100%
rename from tests/xfs/018.op.linux
rename to tests/xfs/018.op
diff --git a/tests/xfs/022 b/tests/xfs/022
index 1cd6d28e..ebe539ab 100755
--- a/tests/xfs/022
+++ b/tests/xfs/022
@@ -38,9 +38,6 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/rc
 . ./common/dump
 
-# link correct .out file
-_link_out_file
-
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
diff --git a/tests/xfs/022.cfg b/tests/xfs/022.cfg
deleted file mode 100644
index 7fd51a7d..00000000
diff --git a/tests/xfs/022.out.linux b/tests/xfs/022.out
similarity index 100%
rename from tests/xfs/022.out.linux
rename to tests/xfs/022.out
diff --git a/tests/xfs/023 b/tests/xfs/023
index d304384b..fff49d56 100755
--- a/tests/xfs/023
+++ b/tests/xfs/023
@@ -37,9 +37,6 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/rc
 . ./common/dump
 
-# link correct .out file
-_link_out_file
-
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
diff --git a/tests/xfs/023.cfg b/tests/xfs/023.cfg
deleted file mode 100644
index 7fd51a7d..00000000
diff --git a/tests/xfs/023.out.linux b/tests/xfs/023.out
similarity index 100%
rename from tests/xfs/023.out.linux
rename to tests/xfs/023.out
diff --git a/tests/xfs/030 b/tests/xfs/030
index 4d8d7d67..bc807753 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -45,9 +45,6 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common/filter
 . ./common/repair
 
-# link correct .out file
-_link_out_file
-
 # nuke the superblock, AGI, AGF, AGFL; then try repair the damage
 #
 _check_ag()
diff --git a/tests/xfs/030.cfg b/tests/xfs/030.cfg
deleted file mode 100644
index 7fd51a7d..00000000
diff --git a/tests/xfs/030.out.linux b/tests/xfs/030.out
similarity index 100%
rename from tests/xfs/030.out.linux
rename to tests/xfs/030.out
diff --git a/tests/xfs/031 b/tests/xfs/031
index 678c3249..b05f28b0 100755
--- a/tests/xfs/031
+++ b/tests/xfs/031
@@ -38,9 +38,6 @@ rm -f $seqres.full
 . ./common/repair
 . ./common/filter
 
-# link correct .out file
-_link_out_file
-
 _check_repair()
 {
 	echo "Repairing, round 0" >> $seqres.full
diff --git a/tests/xfs/031.cfg b/tests/xfs/031.cfg
deleted file mode 100644
index 7fd51a7d..00000000
diff --git a/tests/xfs/031.out.linux b/tests/xfs/031.out
similarity index 100%
rename from tests/xfs/031.out.linux
rename to tests/xfs/031.out
diff --git a/tests/xfs/033 b/tests/xfs/033
index a6f93f29..321856fc 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -86,9 +86,9 @@ if [ $isize -lt 512 ]; then
 fi
 
 # link correct .out file
-FEATURES=$(_get_os_name)
+FEATURES=
 if [ $_fs_has_crcs -eq 1 ]; then
-	FEATURES=$FEATURES,crc
+	FEATURES=crc
 fi
 _link_out_file_named $seqfull.out "$FEATURES"
 
diff --git a/tests/xfs/033.cfg b/tests/xfs/033.cfg
index 768ca9e0..46df3b03 100644
--- a/tests/xfs/033.cfg
+++ b/tests/xfs/033.cfg
@@ -1,2 +1 @@
-linux,crc: crc.linux
-linux: linux
+crc: crc
diff --git a/tests/xfs/033.out.crc.linux b/tests/xfs/033.out.crc
similarity index 100%
rename from tests/xfs/033.out.crc.linux
rename to tests/xfs/033.out.crc
diff --git a/tests/xfs/033.out.linux b/tests/xfs/033.out.default
similarity index 100%
rename from tests/xfs/033.out.linux
rename to tests/xfs/033.out.default
diff --git a/tests/xfs/035 b/tests/xfs/035
index 6b6c86b7..1fde45df 100755
--- a/tests/xfs/035
+++ b/tests/xfs/035
@@ -36,9 +36,6 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/rc
 . ./common/dump
 
-# link correct .out file
-_link_out_file
-
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
diff --git a/tests/xfs/035.cfg b/tests/xfs/035.cfg
deleted file mode 100644
index 7fd51a7d..00000000
diff --git a/tests/xfs/035.out.linux b/tests/xfs/035.out
similarity index 100%
rename from tests/xfs/035.out.linux
rename to tests/xfs/035.out
diff --git a/tests/xfs/036 b/tests/xfs/036
index c65523f5..2a930b20 100755
--- a/tests/xfs/036
+++ b/tests/xfs/036
@@ -36,9 +36,6 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/rc
 . ./common/dump
 
-# link correct .out file
-_link_out_file
-
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
diff --git a/tests/xfs/036.cfg b/tests/xfs/036.cfg
deleted file mode 100644
index 7fd51a7d..00000000
diff --git a/tests/xfs/036.out.linux b/tests/xfs/036.out
similarity index 100%
rename from tests/xfs/036.out.linux
rename to tests/xfs/036.out
diff --git a/tests/xfs/039 b/tests/xfs/039
index 62735906..51d5544a 100755
--- a/tests/xfs/039
+++ b/tests/xfs/039
@@ -36,9 +36,6 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/rc
 . ./common/dump
 
-# link correct .out file
-_link_out_file
-
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
diff --git a/tests/xfs/039.cfg b/tests/xfs/039.cfg
deleted file mode 100644
index 7fd51a7d..00000000
diff --git a/tests/xfs/039.out.linux b/tests/xfs/039.out
similarity index 100%
rename from tests/xfs/039.out.linux
rename to tests/xfs/039.out
diff --git a/tests/xfs/043 b/tests/xfs/043
index caca73da..9bd6f1ec 100755
--- a/tests/xfs/043
+++ b/tests/xfs/043
@@ -38,9 +38,6 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/rc
 . ./common/dump
 
-# link correct .out file
-_link_out_file
-
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
diff --git a/tests/xfs/043.cfg b/tests/xfs/043.cfg
deleted file mode 100644
index 7fd51a7d..00000000
diff --git a/tests/xfs/043.out.linux b/tests/xfs/043.out
similarity index 100%
rename from tests/xfs/043.out.linux
rename to tests/xfs/043.out
diff --git a/tests/xfs/055 b/tests/xfs/055
index 383058a5..9f67e176 100755
--- a/tests/xfs/055
+++ b/tests/xfs/055
@@ -36,9 +36,6 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/rc
 . ./common/dump
 
-# link correct .out file
-_link_out_file
-
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
diff --git a/tests/xfs/055.out.linux b/tests/xfs/055.out
similarity index 100%
rename from tests/xfs/055.out.linux
rename to tests/xfs/055.out
diff --git a/tests/xfs/082 b/tests/xfs/082
index f824d5ef..03878379 100755
--- a/tests/xfs/082
+++ b/tests/xfs/082
@@ -54,9 +54,6 @@ rm -f $seqres.full $tmp.*
 _require_scratch
 _require_v2log 
 
-# link correct .out file
-_link_out_file_named $seqfull.op $(_get_os_name)
-
 echo "*** init FS"
 _scratch_unmount >/dev/null 2>&1
 
diff --git a/tests/xfs/082.cfg b/tests/xfs/082.cfg
deleted file mode 100644
index 7fd51a7d..00000000
diff --git a/tests/xfs/082.op.linux b/tests/xfs/082.op
similarity index 100%
rename from tests/xfs/082.op.linux
rename to tests/xfs/082.op
diff --git a/tests/xfs/146 b/tests/xfs/146
index ea448db2..9d93e951 100755
--- a/tests/xfs/146
+++ b/tests/xfs/146
@@ -47,9 +47,6 @@ _report_filter () {
 _supported_fs xfs
 _supported_os Linux
 
-# link correct .out file
-_link_out_file
-
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _dmapi_scratch_mount
diff --git a/tests/xfs/146.cfg b/tests/xfs/146.cfg
deleted file mode 100644
index 7fd51a7d..00000000
diff --git a/tests/xfs/146.out.linux b/tests/xfs/146.out
similarity index 100%
rename from tests/xfs/146.out.linux
rename to tests/xfs/146.out
-- 
2.13.3

