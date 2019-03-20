Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57502 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfCTApc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:45:32 -0400
Subject: [PATCH 07/12] common/populate: refactor _scratch_populate_cached
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 19 Mar 2019 17:45:28 -0700
Message-ID: <155304272879.31707.4358538241141797662.stgit@magnolia>
In-Reply-To: <155304267647.31707.14180452399822113095.stgit@magnolia>
References: <155304267647.31707.14180452399822113095.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor _scratch_populate_cached into smaller helper functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   69 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 26 deletions(-)


diff --git a/common/populate b/common/populate
index 95953476..1f921ac5 100644
--- a/common/populate
+++ b/common/populate
@@ -765,20 +765,14 @@ _fill_fs()
 	done
 }
 
-# Populate a scratch FS from scratch or from a cached image.
-_scratch_populate_cached() {
-	POPULATE_METADUMP="${TEST_DIR}/__populate.${FSTYP}"
-	POPULATE_METADUMP_DESCR="${TEST_DIR}/__populate.${FSTYP}.txt"
-
-	# Don't keep metadata images cached for more 48 hours...
-	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
+# Compute the fs geometry description of a populated filesystem
+_scratch_populate_cache_tag() {
+	local extra_descr=""
+	local size="$(blockdev --getsz "${SCRATCH_DEV}")"
 
-	# Throw away cached image if it doesn't match our spec.
 	case "${FSTYP}" in
 	"ext4")
 		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL}"
-		# ext4 cannot e2image external logs, so we cannot restore
-		test -n "${SCRATCH_LOGDEV}" && rm -f "${POPULATE_METADUMP}"
 		;;
 	"xfs")
 		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL} RTDEV ${SCRATCH_RTDEV}"
@@ -787,23 +781,46 @@ _scratch_populate_cached() {
 			extra_descr="${extra_descr} QUOTAS"
 		fi
 		;;
-	*)
-		extra_descr="";;
 	esac
-	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} SIZE $(blockdev --getsz "${SCRATCH_DEV}") ${extra_descr} ARGS $@"
-	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || rm -rf "${POPULATE_METADUMP}"
-
-	# Do we have a cached image?
-	if [ -r "${POPULATE_METADUMP}" ]; then
-		case "${FSTYP}" in
-		"xfs")
-			xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" && return
-			;;
-		"ext2"|"ext3"|"ext4")
-			e2image -r "${POPULATE_METADUMP}" "${SCRATCH_DEV}" && return
-			;;
-		esac
-	fi
+	echo "FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} SIZE ${size} ${extra_descr} ARGS $@"
+}
+
+# Restore a cached populated fs from a metadata dump
+_scratch_populate_restore_cached() {
+	local metadump="$1"
+
+	case "${FSTYP}" in
+	"xfs")
+		xfs_mdrestore "${metadump}" "${SCRATCH_DEV}" && return 0
+		;;
+	"ext2"|"ext3"|"ext4")
+		# ext4 cannot e2image external logs, so we cannot restore
+		test -n "${SCRATCH_LOGDEV}" && return 1
+		e2image -r "${metadump}" "${SCRATCH_DEV}" && return 0
+		;;
+	esac
+	return 1
+}
+
+# Populate a scratch FS from scratch or from a cached image.
+_scratch_populate_cached() {
+	local meta_descr="$(_scratch_populate_cache_tag "$@")"
+
+	# These variables are shared outside this function
+	POPULATE_METADUMP="${TEST_DIR}/__populate.${FSTYP}"
+	POPULATE_METADUMP_DESCR="${TEST_DIR}/__populate.${FSTYP}.txt"
+
+	# Don't keep metadata images cached for more 48 hours...
+	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
+
+	# Throw away cached image if it doesn't match our spec.
+	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || \
+		rm -rf "${POPULATE_METADUMP}"
+
+	# Try to restore from the metadump
+	test -r "${POPULATE_METADUMP}" && \
+		_scratch_populate_restore_cached "${POPULATE_METADUMP}" && \
+		return
 
 	# Oh well, just create one from scratch
 	_scratch_mkfs
