Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23743 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752099AbcLGATG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 19:19:06 -0500
Subject: [PATCH 08/11] populate: cache scratch metadata images
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Dec 2016 16:19:01 -0800
Message-ID: <148106994166.19334.6295439286918894885.stgit@birch.djwong.org>
In-Reply-To: <148106989109.19334.6839386416313318071.stgit@birch.djwong.org>
References: <148106989109.19334.6839386416313318071.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Create a helper function to create a populated FS image and dump the
metadata into a file on the test device, with the purpose of allowing
future (fuzzer) invocations of _populate_fs use the cached metadata to
save time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   44 ++++++++++++++++++++++++++++++++++++++++++++
 common/rc       |    3 ++-
 2 files changed, 46 insertions(+), 1 deletion(-)


diff --git a/common/populate b/common/populate
index 74a77a1..0e6bcfd 100644
--- a/common/populate
+++ b/common/populate
@@ -605,3 +605,47 @@ _scratch_populate() {
 		;;
 	esac
 }
+
+# Populate a scratch FS from scratch or from a cached image.
+_scratch_populate_cached() {
+	POPULATE_METADUMP="${TEST_DIR}/__populate.${FSTYP}"
+	POPULATE_METADUMP_DESCR="${TEST_DIR}/__populate.${FSTYP}.txt"
+
+	# Don't keep metadata images cached for more 48 hours...
+	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
+
+	# Throw away cached image if it doesn't match our spec.
+	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} ARGS $@"
+	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || rm -rf "${POPULATE_METADUMP}"
+
+	# Do we have a cached image?
+	if [ -r "${POPULATE_METADUMP}" ]; then
+		case "${FSTYP}" in
+		"xfs")
+			xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" && return
+			;;
+		"ext2"|"ext3"|"ext4")
+			e2image -r "${POPULATE_METADUMP}" "${SCRATCH_DEV}" && return
+			;;
+		esac
+	fi
+
+	# Oh well, just create one from scratch
+	_scratch_mkfs
+	echo "${meta_descr}" > "${POPULATE_METADUMP_DESCR}"
+	case "${FSTYP}" in
+	"xfs")
+		_scratch_xfs_populate $@
+		_scratch_xfs_populate_check
+		_scratch_metadump "${POPULATE_METADUMP}" -a -o
+		;;
+	"ext2"|"ext3"|"ext4")
+		_scratch_ext4_populate $@
+		_scratch_ext4_populate_check
+		e2image -Q "${SCRATCH_DEV}" "${POPULATE_METADUMP}"
+		;;
+	*)
+		_fail "Don't know how to populate a ${FSTYP} filesystem."
+		;;
+	esac
+}
diff --git a/common/rc b/common/rc
index 2719b23..e5cffd0 100644
--- a/common/rc
+++ b/common/rc
@@ -413,12 +413,13 @@ _scratch_mkfs_options()
 _scratch_metadump()
 {
 	dumpfile=$1
+	shift
 	options=
 
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		options="-l $SCRATCH_LOGDEV"
 
-	xfs_metadump $options $SCRATCH_DEV $dumpfile
+	xfs_metadump $options "$@" $SCRATCH_DEV $dumpfile
 }
 
 _setup_large_ext4_fs()

