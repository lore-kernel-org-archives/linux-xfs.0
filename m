Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38100 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbcKEAR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:17:29 -0400
Subject: [PATCH 2/9] populate: add _require_populate_commands to check for
 tools
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:17:23 -0700
Message-ID: <147830504306.1919.15509242384721251908.stgit@birch.djwong.org>
In-Reply-To: <147830503054.1919.4998804611100937975.stgit@birch.djwong.org>
References: <147830503054.1919.4998804611100937975.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Back when I created common/populate, I thought it was sufficient to
_require the tools that the populate functions need in the main
file.  This turned out to be a bit sloppy, so move them into a
helper function and call it from everything that uses populate.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |    9 ++++++---
 tests/ext4/006  |    1 +
 tests/xfs/083   |    3 +--
 tests/xfs/085   |    1 +
 tests/xfs/086   |    1 +
 tests/xfs/087   |    1 +
 tests/xfs/088   |    1 +
 tests/xfs/089   |    1 +
 tests/xfs/091   |    1 +
 tests/xfs/093   |    1 +
 tests/xfs/097   |    1 +
 tests/xfs/098   |    1 +
 tests/xfs/099   |    1 +
 tests/xfs/100   |    1 +
 tests/xfs/101   |    1 +
 tests/xfs/102   |    1 +
 tests/xfs/105   |    1 +
 tests/xfs/112   |    1 +
 tests/xfs/113   |    1 +
 tests/xfs/117   |    1 +
 tests/xfs/120   |    1 +
 tests/xfs/123   |    1 +
 tests/xfs/124   |    1 +
 tests/xfs/125   |    1 +
 tests/xfs/126   |    1 +
 tests/xfs/269   |    1 +
 tests/xfs/273   |    1 +
 27 files changed, 32 insertions(+), 5 deletions(-)


diff --git a/common/populate b/common/populate
index 6ada902..2ac2c22 100644
--- a/common/populate
+++ b/common/populate
@@ -22,9 +22,12 @@
 #  Mountain View, CA 94043, USA, or: http://www.sgi.com
 #-----------------------------------------------------------------------
 
-_require_xfs_io_command "falloc"
-_require_xfs_io_command "fpunch"
-_require_test_program "punch-alternating"
+_require_populate_commands() {
+	_require_xfs_io_command "falloc"
+	_require_xfs_io_command "fpunch"
+	_require_test_program "punch-alternating"
+	_require_command "$XFS_DB_PROG" "xfs_db"
+}
 
 _require_xfs_db_blocktrash_z_command() {
 	test "${FSTYP}" = "xfs" || _notrun "cannot run xfs_db on ${FSTYP}"
diff --git a/tests/ext4/006 b/tests/ext4/006
index f6cca66..9662f50 100755
--- a/tests/ext4/006
+++ b/tests/ext4/006
@@ -54,6 +54,7 @@ _supported_os Linux
 
 _require_scratch
 _require_attrs
+_require_populate_commands
 
 repair_scratch() {
 	fsck_pass="$1"
diff --git a/tests/xfs/083 b/tests/xfs/083
index 040f3b6..39bd75f 100755
--- a/tests/xfs/083
+++ b/tests/xfs/083
@@ -48,12 +48,11 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux
 
-_require_xfs_io_command "falloc"
-_require_xfs_io_command "fpunch"
 _require_scratch
 #_require_xfs_crc	# checksum not required, but you probably want it anyway...
 #_require_xfs_mkfs_crc
 _require_attrs
+_require_populate_commands
 
 scratch_repair() {
 	fsck_pass="$1"
diff --git a/tests/xfs/085 b/tests/xfs/085
index 1ca5354..0c85850 100755
--- a/tests/xfs/085
+++ b/tests/xfs/085
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 
 rm -f $seqres.full
diff --git a/tests/xfs/086 b/tests/xfs/086
index cf0a71a..787f886 100755
--- a/tests/xfs/086
+++ b/tests/xfs/086
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/087 b/tests/xfs/087
index 0bb3ec1..58ba958 100755
--- a/tests/xfs/087
+++ b/tests/xfs/087
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/088 b/tests/xfs/088
index d6972a4..36745b2 100755
--- a/tests/xfs/088
+++ b/tests/xfs/088
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/089 b/tests/xfs/089
index 06996a5..52bdd54 100755
--- a/tests/xfs/089
+++ b/tests/xfs/089
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/091 b/tests/xfs/091
index a263cb0..ae62337 100755
--- a/tests/xfs/091
+++ b/tests/xfs/091
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/093 b/tests/xfs/093
index 753231e..0f9311e 100755
--- a/tests/xfs/093
+++ b/tests/xfs/093
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/097 b/tests/xfs/097
index a75f06a..303ad04 100755
--- a/tests/xfs/097
+++ b/tests/xfs/097
@@ -52,6 +52,7 @@ _require_xfs_mkfs_finobt
 _require_xfs_finobt
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/098 b/tests/xfs/098
index 581377e..7873f32 100755
--- a/tests/xfs/098
+++ b/tests/xfs/098
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/099 b/tests/xfs/099
index 85193ab..7835df9 100755
--- a/tests/xfs/099
+++ b/tests/xfs/099
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/100 b/tests/xfs/100
index 3bfafce..ebb656d 100755
--- a/tests/xfs/100
+++ b/tests/xfs/100
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/101 b/tests/xfs/101
index d3abd19..709fc9d 100755
--- a/tests/xfs/101
+++ b/tests/xfs/101
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/102 b/tests/xfs/102
index cf0d7a6..3d51c6a 100755
--- a/tests/xfs/102
+++ b/tests/xfs/102
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/105 b/tests/xfs/105
index 07ccf00..fc91a4f 100755
--- a/tests/xfs/105
+++ b/tests/xfs/105
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/112 b/tests/xfs/112
index 84f1f1d..ae75684 100755
--- a/tests/xfs/112
+++ b/tests/xfs/112
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/113 b/tests/xfs/113
index ec328bc..c347db7 100755
--- a/tests/xfs/113
+++ b/tests/xfs/113
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/117 b/tests/xfs/117
index f251fb3..f0b95aa 100755
--- a/tests/xfs/117
+++ b/tests/xfs/117
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/120 b/tests/xfs/120
index 3deece6..5a38000 100755
--- a/tests/xfs/120
+++ b/tests/xfs/120
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/123 b/tests/xfs/123
index e6cd8e7..7355e86 100755
--- a/tests/xfs/123
+++ b/tests/xfs/123
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/124 b/tests/xfs/124
index cfea2e6..a828dd6 100755
--- a/tests/xfs/124
+++ b/tests/xfs/124
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/125 b/tests/xfs/125
index 3f2f6f0..3afb4cc 100755
--- a/tests/xfs/125
+++ b/tests/xfs/125
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/126 b/tests/xfs/126
index 77779e0..d696ff1 100755
--- a/tests/xfs/126
+++ b/tests/xfs/126
@@ -50,6 +50,7 @@ _supported_os Linux
 _require_scratch
 test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
 _require_attrs
+_require_populate_commands
 _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
diff --git a/tests/xfs/269 b/tests/xfs/269
index b51ce64..318dd22 100755
--- a/tests/xfs/269
+++ b/tests/xfs/269
@@ -44,6 +44,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _require_scratch
+_require_populate_commands
 _require_test_program "attr-list-by-handle-cursor-test"
 
 rm -f "$seqres.full"
diff --git a/tests/xfs/273 b/tests/xfs/273
index f4b57bb..1a4ee93 100755
--- a/tests/xfs/273
+++ b/tests/xfs/273
@@ -44,6 +44,7 @@ _cleanup()
 _supported_os Linux
 _supported_fs xfs
 _require_scratch
+_require_populate_commands
 _require_xfs_io_command "fsmap"
 
 rm -f "$seqres.full"

