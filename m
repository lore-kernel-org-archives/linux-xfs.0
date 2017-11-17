Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56448 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760132AbdKQU2i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 15:28:38 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v4 3/4] dm-log-writes: allow DAX to be used when possible
Date: Fri, 17 Nov 2017 13:28:27 -0700
Message-Id: <20171117202828.25472-4-ross.zwisler@linux.intel.com>
In-Reply-To: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
References: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests <fstests@vger.kernel.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, Amir Goldstein <amir73il@gmail.com>

Enhance _require_dm_target so that a user can request a minimum version of a
given dm target.

DAX support was added to v1.1.0 of the dm-log-writes kernel module, so
allow the DAX mount option starting with that version.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
---
 common/dmlogwrites           |  5 +++--
 common/rc                    | 23 +++++++++++++++++++++--
 doc/requirement-checking.txt |  5 +++--
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/common/dmlogwrites b/common/dmlogwrites
index 80ed4fc..2cb804c 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -23,8 +23,9 @@ _require_log_writes()
 	[ -z "$LOGWRITES_DEV" -o ! -b "$LOGWRITES_DEV" ] && \
 		_notrun "This test requires a valid \$LOGWRITES_DEV"
 
-	_exclude_scratch_mount_option dax
-	_require_dm_target log-writes
+	local z=0
+	_scratch_has_mount_option dax && z=1
+	_require_dm_target log-writes 1 $z 0
 	_require_test_program "log-writes/replay-log"
 }
 
diff --git a/common/rc b/common/rc
index 701b1ff..c1f24ed 100644
--- a/common/rc
+++ b/common/rc
@@ -1782,6 +1782,18 @@ _require_sane_bdev_flush()
 	fi
 }
 
+_compare_dm_target_versions()
+{
+	for i in $(seq 0 2); do
+		if [[ ${_actual_ver[$i]} > ${_required_ver[$i]} ]]; then
+			return
+		fi
+		if [[ ${_actual_ver[$i]} < ${_required_ver[$i]} ]]; then
+			_notrun "dm $_target version ${_required_ver[@]} required"
+		fi
+	done
+}
+
 # this test requires a specific device mapper target
 _require_dm_target()
 {
@@ -1795,8 +1807,15 @@ _require_dm_target()
 
 	modprobe dm-$_target >/dev/null 2>&1
 
-	$DMSETUP_PROG targets 2>&1 | grep -q ^$_target
-	if [ $? -ne 0 ]; then
+	local _version=$($DMSETUP_PROG targets 2>&1 | grep ^$_target)
+	if [[ $_version =~ .*v([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
+		# check for a required minimum version?
+		if [[ $# == 4 ]]; then
+			local _actual_ver=(${BASH_REMATCH[@]:1})
+			local _required_ver=($2 $3 $4)
+			_compare_dm_target_versions
+		fi
+	else
 		_notrun "This test requires dm $_target support"
 	fi
 }
diff --git a/doc/requirement-checking.txt b/doc/requirement-checking.txt
index 4e01b1f..bbfc34f 100644
--- a/doc/requirement-checking.txt
+++ b/doc/requirement-checking.txt
@@ -112,10 +112,11 @@ _require_statx
 DEVICE MAPPER REQUIREMENTS
 ==========================
 
-_require_dm_target <name>
+_require_dm_target <name> [<version 1> <version 2> <version 3>]
 
      The test requires the use of the device mapper target and will be skipped
-     if it isn't available in the kernel.
+     if it isn't available in the kernel.  Optionally specify the minimum
+     three part version number of the dm target that is required.
 
 _require_log_writes
 
-- 
2.9.5

